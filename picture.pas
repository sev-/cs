unit picture;

interface

procedure tracePicture;
function readPicture (fileName : string) : integer;

implementation

uses   header,  toks, base, search;

procedure tracePicture;

type
  pT = record
    x, y  : integer;
    in_y  : array[1..C_NUMPAR] of integer;
    out_x : integer;
    out_y : array[1..C_NUMPAR] of integer;
  end;

var
  i, j, k : integer;
  i1, j1 : integer;
  x, y : integer;
  p : array[1..C_MAXPARTS] of ^pT;
  curr : integer;
  chainNum : integer;

  procedure setValOfIn (x, y : integer);
  var
    i, j : integer;
  label loop1;
  begin
    i := 1;

  loop1:
    while p[i]^.x <> x do
      inc (i);

    j := 1;
    while (p[i]^.in_y[j] <> y) and (p[i]^.in_y[j] > -1) do
      inc (j);

    if p[i]^.in_y[j] = -1 then
    begin
      inc (i);
      goto loop1
    end;

    if part[i]^.in_wh[j] = -1 then
    begin
      part[i]^.in_wh[j] := chainNum;
{      gotoxy (x, y);
      write (chainNum:0); }
    end
    else
    begin
{      gotoxy (15, 2);
      write (part[i]^.in_wh[j], 'of ', i, j) }
    end
  end;

  procedure setValOfOut (x, y : integer);
  var
    i, j : integer;
  label loop1;
  begin
    i := 1;

  loop1:
    while p[i]^.out_x <> x do
      inc (i);

    j := 1;
    while (p[i]^.out_y[j] <> y) and (p[i]^.out_y[j] > -1) do
      inc (j);

    if p[i]^.out_y[j] = -1 then
    begin
      inc (i);
      goto loop1
    end;

    if part[i]^.out_wh[j] = -1 then
      part[i]^.out_wh[j] := chainNum;
  end;

  	{ traces a wire }
  procedure setChainNum (x, y, dx, dy : integer);
  label loop1;
  const
    symb : string = '┌┐┼└┘│─';
    DXforDY : array[1..2, 1..7] of integer =
		((1, -1, 0, 0, 0,  0, 0), { up }
		 (0,  0, 0, 1, -1, 0, 0));{ down }
    DYforDY : array[1..2, 1..7] of integer =
		((0, 0, -1, 0, 0, -1, 0), { up }
		 (0, 0, 1, 0, 0, 1, 0));  { down }
    DXforDX : array[1..2, 1..7] of integer =
		((0, 0, -1, 0, 0, 0, -1), { left }
		 (0, 0, 1, 0, 0, 0, 1));  { right }
    DYforDX : array[1..2, 1..7] of integer =
		((1, 0, 0, -1, 0, 0, 0), { left }
		 (0, 1, 0, 0, -1, 0, 0));{ right }

  begin
loop1:
    case screen[y+dy][x+dx] of
      '┌', '┐', '┼', '└', '┘', '│', '─':
        begin
          x := x+dx;
          y := y+dy;

          if dy = -1 then
          begin
            dx := DXforDY[1][pos (screen[y][x], symb)];
            dy := DYforDY[1][pos (screen[y][x], symb)];
            goto loop1
          end;

          if dy = 1 then
          begin
            dx := DXforDY[2][pos (screen[y][x], symb)];
            dy := DYforDY[2][pos (screen[y][x], symb)];
            goto loop1
          end;

          if dx = -1 then
          begin
            dx := DXforDX[1][pos (screen[y][x], symb)];
            dy := DYforDX[1][pos (screen[y][x], symb)];
            goto loop1
          end;

          if dx = 1 then
          begin
            dx := DXforDX[2][pos (screen[y][x], symb)];
            dy := DYforDX[2][pos (screen[y][x], symb)];
            goto loop1
          end;
        end;

      '┬':
        begin
          if dy = 0 then
          begin
            setChainNum (x+dx, y, dx, 0);
            x := x+dx;
            dx := 0;
            dy := 1;
            goto loop1
          end
          else
          begin
            setChainNum (x, y-1, -1, 0);
            y := y-1;
            dx := 1;
            dy := 0;
            goto loop1
          end
        end;
      '├':
        begin
          if dy = 0 then
          begin
            setChainNum (x-1, y, 0, -1);
            x := x-1;
            dx := 0;
            dy := 1;
            goto loop1
          end
          else
          begin
            setChainNum (x, y+dy, 0, dy);
            y := y+dy;
            dx := 1;
            dy := 0;
            goto loop1
          end
        end;
      '┤':
        begin
          if dy = 0 then
          begin
            setChainNum (x+1, y, 0, -1);
            x := x+1;
            dx := 0;
            dy := 1;
            goto loop1
          end
          else
          begin
            setChainNum (x, y+dy, 0, dy);
            y := y+dy;
            dx := -1;
            dy := 0;
            goto loop1
          end
        end;
      '┴':
        begin
          if dy = 0 then
          begin
            setChainNum (x+dx, y, dx, 0);
            x := x+dx;
            dx := 0;
            dy := -1;
            goto loop1
          end
          else
          begin
            setChainNum (x, y+1, -1, 0);
            y := y+1;
            dx := 1;
            dy := 0;
            goto loop1
          end
        end;
      ' ':
        ;
      '╢':
         setValOfIn (x+1, y);
      '╟':
         setValOfOut (x-1, y);
    end;
  end;

  
begin
  for i := 1 to lastPart do
  begin
    new (p[i]);

    p[i]^.out_x := -1;
    for j := 1 to C_NUMPAR do
      with p[i]^ do
      begin
        in_y[j]  := -1;
        out_y[j] := -1
      end;
  end;

  { search parts on the scheme }
  for i := 1 to scrY do
    for j := 1 to length (screen[i]) do
    begin
      if screen[i][j] = '╔' then
      begin
        k := j+1;
        while (screen[i][k] >= '0') and (screen[i][k] <= '9') do
          inc (k);
        val (copy (screen[i], j+1, k-j-1), x, k);
        p[x]^.x := j;
        p[x]^.y := i;
      end;
    end;

  { search parts' outlets }
  for i := 1 to lastPart do
  begin
      { scan for in }
    x := p[i]^.x;
    y := p[i]^.y + 1;
    curr := 1;

    while screen[y][x] <> '╚' do
    begin
      if screen[y][x] = '╢' then
      begin
        if curr > part[i]^.whatIs^.num_in then
          writeln ('Too IN elements at part #', i);
        p[i]^.in_y[curr] := y;
        inc (curr)
      end;
      inc (y)
    end;

      { search out }
    y := p[i]^.y;
    while screen[y][x] <> '╗' do
      inc (x);
    p[i]^.out_x := x;

      { scan for out }
    curr := 1;

    while screen[y][x] <> '╝' do
    begin
      if screen[y][x] = '╟' then
      begin
        if curr > part[i]^.whatIs^.num_out then
          writeln ('Too OUT elements at part #', i);
        p[i]^.out_y[curr] := y;
        inc (curr)
      end;
      inc (y)
    end;
  end;	{ for to lastPart }

  chainNum := 1;

     { traces every outlet }
  for i := 1 to lastPart do
  begin
      { trace out }
    j := 1;

    while p[i]^.out_y[j] > -1 do	{ if defined outlet }
    begin
      if part[i]^.out_wh[j] = -1 then	{ if chain not set }
      begin
        x := p[i]^.out_x;		{ +1 to skip a box }
        y := p[i]^.out_y[j];
        setValOfOut (x, y);
        setChainNum (x, y, 1, 0);
        inc (chainNum);
      end;
      inc (j);
    end;

      { trace in }
    j := 1;

    while p[i]^.in_y[j] > -1 do		{ if defined outlet }
    begin
      if part[i]^.in_wh[j] = -1 then	{ if chain not set }
      begin
        x := p[i]^.x;		{ -1 to skip a box }
        y := p[i]^.in_y[j];
        setValOfIn (x, y);
        setChainNum (x, y, -1, 0);
        inc (chainNum);
      end;
      inc (j)
    end
  end;	{ outlets }

	{ free memory }
  for i := 1 to lastPart do
    dispose (p[i]);
end;

function readPicture (fileName : string) : integer;

  function scanNames (name : string) : pelementT;
  var
    i : integer;
    stop : byte;
  begin
    i := 1;
    stop := 0;

    while (i <= C_NUMELEM) and (stop = 0) do
      if element[i].name = name then
        stop := 1
      else
        inc (i);

     scanNames := @element[i];
  end;

var
  f : text;
  s : string;
  i, j : integer;
  stop : byte;
  tmp : string;
  x, y : integer;
label fail;

begin
  assign (f, fileName);
  {$I-}
  reset (f);
  {$I+}

  if IOResult <> 0 then
  begin
    writeln ('File not found');
    readPicture := 0;
    goto fail
  end;

  readPicture := 1;
  stop := 0;

  while (not eof (f)) and (stop = 0) do
  begin
    readln (f, s);

    if pos ('section scheme', s) <> 0 then
    begin
      {for i := 1 to scrY do
        dispose (screen[i]); }

      scrY := 0;
      readln (f, s);
      repeat
        inc (scrY);
      {  new (screen[scrY]);}
        screen[scrY] := s;
        readln (f, s);
      until pos ('section end', s) <> 0;
    end;

    if pos ('section description', s) <> 0 then
    begin
      readln (f, s);
      val (getTok (s, 1), lastPart, x);
      if (upString (getTok (s, 2)) <> 'PARTS') or (x = 1) or
			(lastPart > C_MAXPARTS) then
      begin
        lastPart := 0;
        close (f);
        writeln ('Error at first line of section description');
        goto fail
      end;

      for i := 1 to lastPart do
        new (part[i]);

      while stop = 0 do
      begin
        readln (f, s);

        if pos ('section end', s) <> 0 then
          stop := 1
        else
        begin
          val (getTok (s, 1), y, x);
          if (x = 1) or (y < 1) or (y > lastPart) then
          begin
            writeln ('Error in part number (', getTok (s, 1), ')');
            close (f);
            goto fail
          end;
          initPart (y);

          i := searchElement (getTok (s, 2));
          if i = 0 then
          begin
            writeln ('Unknown part ', getTok (s, 2));
            close (f);
            goto fail
          end;

          if upString (getTok (s, 3)) <> 'IS' then
          begin
            writeln ('IS expected ', s);
            close (f);
            goto fail
          end;

          if searchPart (getTok (s, 4)) > 0 then
          begin
            printError (s, posTok (s, 4), 'Part multiply defined');
            close (f);
            goto fail
          end;
          
          part[y]^.whatIs := @element[i];
          part[y]^.name := getTok (s, 4);
          for j := 1 to element[i].num_par do
          begin
            tmp := getTok (s, 4+j);     { to avoid the bug }
            val (getTok (s, 4+j), part[y]^.par[j], x);
            if x = 1 then
              writeln ('Error in parameter #', j:0, ' in part ', getTok (s, 4));
          end;
        end;
      end;
      stop := 0;
    end;
    if pos ('eof', s) <> 0 then
      stop := 1;
  end;	{ while not eof }
  close (f);
  fail:
end;

end.