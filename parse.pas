unit  parse;

interface

procedure parseNEW (s : string);
procedure parseLIST (s : string);
procedure parseCONNECT (s : string);
procedure parseSAVE (s : string);
procedure parseSHOW (s : string);
procedure parseCALCULATE (s : string);
procedure parseSET (s : string);
procedure parseHELP (s : string);

implementation

uses header, toks, search, base, incide, comp, curve, servi;

  procedure parseNEW (s : string);
  var
    num : integer;
    y_n : string[2];
    i : integer;
  label fail;
  begin
    if upString (getTok (s, 2)) = 'PART' then
    begin
      num := searchElement (getTok (s, 3));
      if num = 0 then
      begin
        printError (s, posTok (s, 3), 'Unknown element');
        goto fail
      end;
      if lastPart = C_MAXPARTS then
      begin
        printError (s, 0, 'Can not add a new part');
        goto fail
      end;

      if upString (getTok (s, 4)) <> 'NAME' then
      begin
        printError (s, posTok (s, 4), 'NAME expected');
        goto fail
      end;
      if posTok (s, 5) = -1 then
      begin
        printError (s, length (s), 'Part name expected');
        goto fail
      end;
      if searchPart (getTok (s, 5)) > 0 then
      begin
        printError (s, posTok (s, 5), 'Part already defined');
        goto fail
      end;

      inc (lastPart);
      new (part[lastPart]);
      initPart (lastPart);
      part[lastPart]^.whatIs := @element[num];
      part[lastPart]^.name := getTok (s, 5);
      goto fail;
    end;

    if upString (getTok (s, 2)) = 'SCHEME' then
    begin
      writeln ('Are you sure (Y/N)?');
      readln (y_n);
      if not ((y_n[1] = 'y') or (y_n[1] = 'Y')) then
        goto fail;

      for i := 1 to lastPart do
        dispose (part[i]);

      initScheme;
      writeln ('Scheme is empty');
      goto fail
    end;

    printError (s, posTok (s, 2), 'Unknown NEW directive');
  fail:
  end;

  procedure parseLIST (s : string);
  var
    i, j : integer;
    num, x : integer;
    tmp : string;
  const C1=(C_NAMELEN+1);
        C2=4;
        C3=12;
  label fail;
  begin
    if upString (getTok (s, 2)) = 'ELEMENTS' then
    begin
      writeln ('Available elements:');
      for i := 1 to C_NUMELEM do
      begin
        write (element[i].name:(C_NAMELEN+1));
        if i mod 7 = 0 then
          writeln
      end;

      writeln;
      goto fail;
    end;

    if (upString (getTok (s, 2)) = 'ALL') and
                         (upString (getTok (s, 3)) = 'PARTS') then
    begin
      if lastPart = 0 then
        writeln ('Scheme is empty')
      else
        writeln ('Described parts:');
      for i := 1 to lastPart do
        writeln (part[i]^.name:(C_NAMELEN+1), ' IS ',
                                   part[i]^.whatIs^.name:(C_NAMELEN+1));
      goto fail;
    end;

    if (upString (getTok (s, 2)) = 'ALL') and
                         (upString (getTok (s, 3)) = 'CHAINS') then
    begin
      for num := 1 to C_MAXCHAINS do
      begin
        x := 0;
        for i := 1 to lastPart do
          for j := 1 to part[i]^.whatIs^.num_out do
            if part[i]^.out_wh[j] = num then
            begin
              write (i:3);
              x :=  1;
            end;
        if x  = 1 then
        begin
          write (' --> ');

          for i := 1 to lastPart do
            for j := 1 to part[i]^.whatIs^.num_in do
              if part[i]^.in_wh[j] = num then
                write (i:3);
          writeln;
        end;
      end;
      goto fail;
    end;

    if upString (getTok (s, 2)) = 'PART' then
    begin
      i := searchPart (getTok (s, 3));
      if i = 0 then
      begin
        printError (s, posTok (s, 3), 'Part not defined');
        goto fail
      end;
      with part[i]^ do
      begin
        writeln ('Part: ', name, ' IS ', whatIs^.name);
        writeln ('INs:':C1, 'to':C2, 'OUTs':C1, 'to':C2,
			'PARs ':C1, '  is');
        for j := 1 to max (whatIs^.num_in,
                 max (whatIs^.num_out, whatIs^.num_par)) do
        begin
          if whatIs^.num_in >= j then
            write (whatIs^.in_name[j]:C1, in_wh[j]:C2)
          else
            write (' ':C1, ' ':C2);
          if whatIs^.num_out >= j then
            write (whatIs^.out_name[j]:C1, out_wh[j]:C2)
          else
            write (' ':C1, ' ':C2);
          if whatIs^.num_par >= j then
            writeln (whatIs^.par_name[j]:C1, ' ', par[j])
          else
            writeln;
        end;
      end;
      goto fail
    end;

    if (upString (getTok (s, 2)) = 'STATE') and
		(upString (getTok (s, 3)) = 'OF')
			and (upString (getTok (s, 4)) = 'PART') then
    begin
      i := searchPart (getTok (s, 5));
      if i = 0 then
      begin
        printError (s, posTok (s, 5), 'Part not defined');
        goto fail
      end;
      with part[i]^ do
      begin
        writeln ('Part: ', name, ' IS ', whatIs^.name);
        if whatIs^.num_var > 0 then
          for j := 1 to whatIs^.num_var do
            writeln (whatIs^.var_name[j]:C1, vars[j])
        else
          writeln ('Has not variables')
      end;
      goto fail
    end;

    if upString (getTok (s, 2)) = 'TIME' then
    begin
      with time do
      begin
        writeln ('Time start: ', start:0:10);
        writeln ('Time  stop: ', stop:0:10);
        writeln ('Time  step: ', step:0:10)
      end;
      goto fail;
    end;

    if upString (getTok (s, 2)) = 'CHAIN' then
    begin
      val (getTok (s, 3), num, x);
      if x = 1 then
      begin
        printError (s, posTok (s, 3), 'number expected');
        goto fail
      end;
      for i := 1 to lastPart do
        for j := 1 to part[i]^.whatIs^.num_out do
          if part[i]^.out_wh[j] = num then
            write (i:3);
      write (' --> ');

      for i := 1 to lastPart do
        for j := 1 to part[i]^.whatIs^.num_in do
          if part[i]^.in_wh[j] = num then
            write (i:3);
      writeln;
      goto fail
    end;

    if upString (getTok (s, 2)) = 'COLLECT' then
    begin
      str (collectChain, tmp);
      parseLIST ('list chain '+tmp);
      goto fail
    end;

    printError (s, posTok (s, 2), 'Unknown LIST directive');
  fail:
  end;

  procedure parseCONNECT (s : string);
  var
    i, j, x : integer;
    num : integer;
    in_out : integer;
  label fail;
  begin
    i := searchPart (getTok (s, 2));
    if i = 0 then
    begin
      printError (s, posTok (s, 2), 'Part not defined');
      goto fail
    end;

    if upString (getTok (s, 3)) = 'IN' then
      in_out := 1
    else if upString (getTok (s, 3)) = 'OUT' then
      in_out := 2
    else
    begin
      printError (s, posTok (s, 3), 'IN or OUT expected');
      goto fail
    end;

    if upString (getTok (s, 5)) <> 'WITH' then
    begin
      printError (s, posTok (s, 5), 'WITH expected');
      goto fail
    end;

    if in_out = 1 then
    begin
      num := searchIN (i, getTok (s, 4));
      if num = 0 then
      begin
        printError (s, posTok (s, 4), 'unknown IN');
        goto fail
      end;
    end
    else
    begin
      num := searchOUT (i, getTok (s, 4));
      if num = 0 then
      begin
        printError (s, posTok (s, 4), 'unknown OUT');
        goto fail
      end;
    end;

    val (getTok (s, 6), j, x);
    if x = 1 then
    begin
      printError (s, posTok (s, 6), 'number expected');
      goto fail
    end;

    if in_out = 1 then
      part[i]^.in_wh[num] := j
    else
      part[i]^.out_wh[num] := j;

  fail:
  end;    { parseCONNECT }

  procedure parseSAVE (s : string);
  var i, j : integer;
    f : text;
    y_n : string[2];
  label fail;
  begin
    if (upString (getTok (s, 2)) = 'SCHEME') and
			(upString (getTok (s, 3)) = 'TO') then
    begin
      assign (f, getTok (s, 4));
      {$I-}
      reset (f);
      {$I+}

      if IOResult = 0 then
      begin
        writeln ('File exist. Rewrite (Y/N)?');
        readln (y_n);
        if not ((y_n[1] = 'y') or (y_n[1] = 'Y')) then
          goto fail
      end;

      rewrite (f);

      for i := 1 to lastPart do
        writeln (f, 'new part ', part[i]^.whatIs^.name, ' name ', part[i]^.name);

      for i := 1 to lastPart do
      begin
        for j := 1 to part[i]^.whatIs^.num_in do
          writeln (f, 'connect ', part[i]^.name, ' in ',
                part[i]^.whatIs^.in_name[j], ' with ', part[i]^.in_wh[j]:0);
        for j := 1 to part[i]^.whatIs^.num_out do
          writeln (f, 'connect ', part[i]^.name, ' out ',
                part[i]^.whatIs^.out_name[j], ' with ', part[i]^.out_wh[j]:0);
        for j := 1 to part[i]^.whatIs^.num_par do
          writeln (f, 'set part ', part[i]^.name, ' parameter ',
                part[i]^.whatIs^.par_name[j], ' to ', part[i]^.par[j]:0:10);
      end;
      close (f);
      writeln ('Saved');
      goto fail
    end;

    if (upString (getTok (s, 2)) = 'STATE') and
			(upString (getTok (s, 3)) = 'TO') then
    begin
      assign (f, getTok (s, 4));
      {$I-}
      reset (f);
      {$I+}

      if IOResult = 0 then
      begin
        writeln ('File exist. Rewrite (Y/N)?');
        readln (y_n);
        if not ((y_n[1] = 'y') or (y_n[1] = 'Y')) then
          goto fail
      end;

      rewrite (f);

      for i := 1 to lastPart do
      begin
        for j := 1 to part[i]^.whatIs^.num_var do
          writeln (f, 'set part ', part[i]^.name, ' variable ',
                part[i]^.whatIs^.var_name[j], ' to ', part[i]^.vars[j]:0:10);
      end;
      writeln (f, 'set time start ', time.start);
      writeln (f, 'set time stop ', time.stop);
      writeln (f, 'set time step ', time.step);
      writeln (f, 'set collect chain ', collectChain);
      writeln (f, 'set collect file ', collectFile);
      close (f);
      writeln ('Saved');
      goto fail
    end;

    printError (s, posTok (s, 2), 'Unknown SAVE directive');
  fail:
  end;    { parseSAVE }

  procedure parseSHOW (s : string);
  var
    i, j : integer;
    f : text;
  label fail;
  begin
    if upString (getTok (s, 2)) = 'INCIDENT' then
    begin
      incident;

      write ('Normal     ');
      for i := 5 to lastPart do
        write ('  ');
      writeln ('Optimized');

      for i := 1 to lastPart do
      begin
        for j := 1 to lastPart do
          if incid[i, j] then
            write ('1 ')
          else
            write ('0 ');
        write ('   ');
        for j := 1 to lastPart do
          if incid[indincid[i], indincid[j]] then
            write ('1 ')
          else
            write ('0 ');
        writeln
      end;
      goto fail
    end;

    if upString (getTok (s, 2)) = 'SEQUENCE' then
    begin
      if collectChain = -1 then
      begin
        writeln ('Use SET COLLECT first');
        goto fail
      end;

      compile (collectPart);

      for i := sthead-1 downto 1 do
        write (st[i] : 0, ' ');
      writeln;
      writeln (sthead-1:0, ' elements');
      goto fail
    end;

    if (upString (getTok (s, 2)) = 'CURVE') or
                 (upString (getTok (s, 2)) = 'HISTO') or
                 (upString (getTok (s, 2)) = 'TABLE') or
                 (upString (getTok (s, 2)) = 'SERVICE') then
    begin
      if collectChain = -1 then
      begin
        writeln ('Use SET COLLECT CHAIN first');
        goto fail
      end;

      if length (collectFile) = 0 then
      begin
        writeln ('Use SET COLLECT FILE first');
        goto fail
      end;

      assign (f, collectFile);

      {$I-}
      reset (f);
      {$I+}
      if IOresult <> 0 then
      begin
        writeln ('File not found');
        goto fail
      end;

      i := 1;
      while (not eof (f)) and (i <= C_MAXPOINTS) do
      begin
        readln (f, result[i].x, result[i].y);
        inc (i);
      end;

    if upString (getTok (s, 2)) = 'CURVE' then
      kriv_main (result, result, 1, i-1, i-1)
    else if upString (getTok (s, 2)) = 'HISTO' then
      gist_main (result, result, 1, i-1, i-1)
    else if upString (getTok (s, 2)) = 'TABLE' then
      table ('Results', result, i-1)
    else if upString (getTok (s, 2)) = 'SERVICE' then
      servis (result, i-1);

      goto fail
    end;

    printError (s, posTok (s, 2), 'Unknown SHOW directive');
  fail:
  end;    { parse SHOW }

  procedure parseCALCULATE (s : string);

    procedure loadElement (which : integer);
    var
      i : integer;
    begin
      with part[abs (which)]^ do
        for i := 1 to whatIs^.num_in do
          in_val[i] := chain[in_wh[i]]
    end;

    procedure saveElement (which : integer);
    var
      i : integer;
    begin
      with part[abs (which)]^ do
        for i := 1 to whatIs^.num_out do
          if abs (out_val[i]) > 1000 then
            if out_val[i] < 0 then
              chain[out_wh[i]] := -1000
            else
              chain[out_wh[i]] := 1000
          else
            chain[out_wh[i]] := out_val[i]
    end;

  var
    i, j : integer;
    cChain1, cChain2, cPart1, x, num : integer;
    flag, flag1 : boolean;
    numpart, numparam : integer;
    from,  to_, step_ :  real;
    prevChain : real;
    mid_num : integer;
    mid_sum : real;
    typo    : integer;   { type of calculation for lab 4 }
    t : real;
    f : text;
  label fail;
  begin
    if collectChain = -1 then
    begin
      writeln ('Use SET COLLECT CHAIN first');
      goto fail
    end;

    if length (collectFile) = 0 then
    begin
      writeln ('Use SET COLLECT FILE first');
      goto fail
    end;

    if (time.start >= time.stop) or (time.step = 0) then
    begin
      writeln ('Check time please');
      goto fail
    end;

    flag := false;
    flag1 := false;
    cChain1 :=   collectChain;
    cPart1 := collectPart;

    if upstring(getTok(s, 2)) = 'FOR' then
    begin
      val (getTok(s, 3), num, x);
      cChain1 := num;
      for i := 1 to lastPart do
        for j := 1 to part[i]^.whatIs^.num_out do
          if part[i]^.out_wh[j] = num then
            cPart1 := i;

      if upstring(getTok(s, 4)) = 'AND' then
      begin
        val (getTok(s, 5), num, x);
        cChain2 := num;
        flag := true;
      end;

      if upstring(getTok(s, 4)) = 'PARAMETER' then
      begin
        if (upstring(getTok(s, 6)) <> 'OF') or
             (upstring(getTok(s, 7)) <> 'PART') then
        begin
          printError(s, posTok(s, 6), 'OF PART  expecteed');
          goto fail;
        end;

        numpart := searchPart (getTok (s, 8));
        if numpart = 0 then
        begin
          printError (s, posTok (s, 8), 'Part not defined');
          goto fail
        end;

        numparam := searchParameter (numpart, getTok (s, 5));
        if numparam = 0 then
        begin
          printError (s, posTok (s, 5), 'Unknown parameter');
          goto fail
        end;

        if (upstring(getTok(s, 9)) <> 'FROM') then
        begin
          printError(s, posTok(s, 9), 'FROM expecteed');
          goto fail;
        end;

        if (upstring(getTok(s, 11)) <> 'TO') then
        begin
          printError(s, posTok(s, 11), 'TO expecteed');
          goto fail;
        end;

        if (upstring(getTok(s, 13)) <> 'STEP') then
        begin
          printError(s, posTok(s, 13), 'STEP expecteed');
          goto fail;
        end;

        if (upstring(getTok(s, 15)) <> 'TYPE') then
        begin
          printError(s, posTok(s, 15), 'TYPE expecteed');
          goto fail;
        end;

        if (upstring(getTok(s, 16)) = 'INT') then
          typo := 0
        else if (upstring(getTok(s, 16)) = 'MID') then
          typo := 1
        else  if (upstring(getTok(s, 16)) = 'DIF') then
          typo := 2
        else
        begin
          printError(s, posTok(s, 16), 'INT or MID or DIF expecteed');
          goto fail;
        end;

        val (getTok (s, 10), from, x);
        if x = 1 then
        begin
          printError (s, posTok (s, 10), 'number expected');
          goto fail;
        end;

        val (getTok (s, 12), to_, x);
        if x = 1 then
        begin
          printError (s, posTok (s, 12), 'number expected');
          goto fail;
        end;

        val (getTok (s, 14), step_, x);
        if x = 1 then
        begin
          printError (s, posTok (s, 14), 'number expected');
          goto fail;
        end;

        if (from >= to_) or (step_ = 0) then
        begin
          writeln ('Check parameter interval please');
          goto  fail;
        end;
        flag1 := true;
      end;
    end;

    compile (cPart1);

    for i := 1 to C_MAXCHAINS do        { init the process }
      chain[i] := 0;

    for i := 1 to lastPart do        { init the process }
      for j := 1 to C_NUMPAR do
        part[i]^.vars[j] := 0;

    assign (f, collectFile);
    rewrite (f);

    if flag1 then
      part[numpart]^.par[numparam]  := from;

    repeat
      mid_num := 0;
      mid_sum := 0;
      prevChain := 0;

      t := time.start;

      while t < time.stop do
      begin
        for i := sthead-1 downto 1 do
        begin
          loadElement (st[i]);
          doElement (st[i], t);
          saveElement (st[i]);
        end;

        if flag1 then
        begin
          case typo of
            0: mid_sum := mid_sum + t*(chain[cChain1]+prevChain)/2;
            1: mid_sum := mid_sum + chain[cChain1];
            2: mid_sum := mid_sum + SQRt(abs(chain[cChain1]));
          end;
          inc(mid_num);
        end
        else
          if flag then
            writeln (f, chain[cChain1], ' ', chain[cChain2])
          else
            writeln (f, t, ' ', chain[cChain1]);

        prevChain := chain[cChain1];
        t := t + time.step
      end;
      if flag1  then
      begin
        case typo of
          0: ;
          1: mid_sum := mid_sum/mid_num;
          2: mid_sum := sqrt(mid_sum)/mid_num;
        end;
        writeln(f, part[numpart]^.par[numparam], ' ', mid_sum);
        part[numpart]^.par[numparam] := part[numpart]^.par[numparam] + step_;
        if part[numpart]^.par[numparam] >= to_ then
           flag1 := false
      end
    until  not  flag1;

    close (f);
    writeln ('Time is over');
  fail:
  end;    { parse CALCULATE }

  procedure parseSET (s : string);
  var
    i, num, b, x : integer;
    v : real;
    par_var : integer;
  label fail;
  begin
    if upString (getTok (s, 2)) = 'TIME' then
    begin
      if upString (getTok (s, 3)) = 'START' then
      begin
        val (getTok (s, 4), v, x);
        if x = 1 then
          printError (s, posTok (s, 4), 'number expected')
        else
          time.start := v;
        goto fail
      end;
      if upString (getTok (s, 3)) = 'STOP' then
      begin
        val (getTok (s, 4), v, x);
        if x = 1 then
          printError (s, posTok (s, 4), 'number expected')
        else
          time.stop := v;
        goto fail
      end;
      if upString (getTok (s, 3)) = 'STEP' then
      begin
        val (getTok (s, 4), v, x);
        if x = 1 then
          printError (s, posTok (s, 4), 'number expected')
        else
          time.step := v;
        goto fail
      end;
      printError (s, posTok (s, 3), 'Unknown SET TIME directive');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'PART' then
    begin
      i := searchPart (getTok (s, 3));
      if i = 0 then
      begin
        printError (s, posTok (s, 3), 'Part not defined');
        goto fail
      end;
      if (upString (getTok (s, 4)) = 'PARAMETER') or
		(upString (getTok (s, 4)) = 'VARIABLE') then
      begin
        if upString (getTok (s, 4)) = 'PARAMETER' then
          par_var := 1
        else
          par_var := 2;

        if par_var = 1 then
        begin
          num := searchParameter (i, getTok (s, 5));
          if num = 0 then
          begin
            printError (s, posTok (s, 5), 'Unknown parameter');
            goto fail
          end;
        end
        else
        begin
          num := searchVar (i, getTok (s, 5));
          if num = 0 then
          begin
            printError (s, posTok (s, 5), 'Unknown variable');
            goto fail
          end;
        end;

        if upString (getTok (s, 6)) <> 'TO' then
        begin
          printError (s, posTok (s, 6), 'TO expected');
          goto fail
        end;

        val (getTok (s, 7), v, x);
        if x = 1 then
        begin
          printError (s, posTok (s, 7), 'number expected');
          goto fail
        end;

        if par_var = 1 then
          part[i]^.par[num] := v
        else
          part[i]^.vars[num] := v;
        goto fail
      end;
      printError (s, posTok (s, 4), 'Unknown SET PART directive');
      goto fail
    end;

    if (upString (getTok (s, 2)) = 'COLLECT') and
			(upString (getTok (s, 3)) = 'PART') then
    begin
      i := searchPart (getTok (s, 4));
      if i = 0 then
      begin
        printError (s, posTok (s, 4), 'Part not defined');
        goto fail
      end;

      if upString (getTok (s, 5)) <> 'OUT' then
      begin
        printError (s, posTok (s, 5), 'OUT expected');
        goto fail
      end;

      num := searchOUT (i, getTok (s, 6));
      if num = 0 then
      begin
        printError (s, posTok (s, 6), 'unknown OUT');
        goto fail
      end;

      collectChain := part[i]^.out_wh[num];
      collectPart := i;
      goto fail
    end;

    if (upString (getTok (s, 2)) = 'COLLECT') and
			(upString (getTok (s, 3)) = 'CHAIN') then
    begin
      val (getTok (s, 4), num, x);
      if x = 1 then
      begin
        printError (s, posTok (s, 4), 'number expected');
        goto fail
      end;

      collectChain := num;
      for i := 1 to lastPart do
        for b := 1 to part[i]^.whatIs^.num_out do
          if part[i]^.out_wh[b] = num then
            collectPart := i;
      goto fail
    end;

    if (upString (getTok (s, 2)) = 'COLLECT') and
			(upString (getTok (s, 3)) = 'FILE') then
    begin
      collectFile := getTok (s, 4);
      for i := 1 to lastPart do
        for b := 1 to part[i]^.whatIs^.num_out do
          if part[i]^.out_wh[b] = num then
            collectPart := i;
      goto fail
    end;

    printError (s, posTok (s, 2), 'Unknown SET directive');
  fail:
  end;
  procedure parseHELP (s : string);
  label fail;
  begin
    if upString (getTok (s, 2)) = 'NEW' then
    begin
      writeln ('NEW PART element NAME name');
      writeln ('NEW SCHEME');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'LIST' then
    begin
      writeln ('LIST ELEMENTS');
      writeln ('LIST ALL PARTS');
      writeln ('LIST ALL CHAINS');
      writeln ('LIST PART name');
      writeln ('LIST STATE OF PART name');
      writeln ('LIST TIME');
      writeln ('LIST CHAIN number');
      writeln ('LIST COLLECT');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'SET' then
    begin
      writeln ('SET TIME START');
      writeln ('SET TIME STOP');
      writeln ('SET TIME STEP');
      writeln ('SET PART name PARAMETER name TO number');
      writeln ('SET PART name VARIABLE name TO number');
      writeln ('SET COLLECT PART name OUT name');
      writeln ('SET COLLECT CHAIN number');
      writeln ('SET COLLECT FILE name');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'CONNECT' then
    begin
      writeln ('CONNECT name IN name WITH number');
      writeln ('CONNECT name OUT name WITH number');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'SAVE' then
    begin
      writeln ('SAVE SCHEME TO fname');
      writeln ('SAVE STATE to fname');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'LOAD' then
    begin
      writeln ('LOAD SCHEME FROM fname');
      writeln ('LOAD STATE FROM fname');
      writeln ('LOAD PICTURE FROM fname');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'SHOW' then
    begin
      writeln ('SHOW INCIDENT');
      writeln ('SHOW SEQUENCE');
      writeln ('SHOW CURVE');
      writeln ('SHOW HISTO');
      writeln ('SHOW TABLE');
      writeln ('SHOW SERVICE');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'EDIT' then
    begin
      writeln ('EDIT');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'HELP' then
    begin
      writeln ('HELP');
      writeln ('?');
      goto fail
    end;

    if upString (getTok (s, 2)) = 'CALCULATE' then
    begin
      writeln ('CALCULATE');
      writeln ('CALCULATE FOR chain');
      writeln ('CALCULATE FOR chain1 AND chain2');
      writeln ('CALCULATE FOR chain PARAMETER name OF PART name FROM value TO value STEP value TYPE type');
      writeln ('    Type = int, mid, dif');
      goto fail
    end;

    if (upString (getTok (s, 2)) = 'BYE') or
			(upString (getTok (s, 2)) = 'QUIT') then
    begin
      writeln ('BYE');
      writeln ('QUIT');
      goto fail
    end;

    writeln ('BYE CALCULATE CONNECT EDIT HELP LIST LOAD NEW QUIT SAVE SET SHOW');
  fail:
  end;

end.
