unit interp;  { version 1.1 }

interface

function dialog (fileName : string) : integer;

implementation

uses edit5, header, base, parse, toks, search,  picture;

function dialog (fileName : string) : integer;

  procedure parseLOAD (s : string);
  var
    i : integer;
  label fail;
  begin
    if (upString (getTok (s, 2)) = 'SCHEME') and
			(upString (getTok (s, 3)) = 'FROM') then
    begin
      for i := 1 to lastPart do
        dispose (part[i]);

      initScheme;

      if dialog (getTok (s, 4)) = 1 then
        writeln ('Loaded from ', getTok (s, 4));
      goto fail
    end;

    if (upString (getTok (s, 2)) = 'STATE') and
			(upString (getTok (s, 3)) = 'FROM') then
    begin
      if dialog (getTok (s, 4)) = 1 then
        writeln ('Loaded from ', getTok (s, 4));
      goto fail
    end;

    if (upString (getTok (s, 2)) = 'PICTURE') and
			(upString (getTok (s, 3)) = 'FROM') then
    begin
      for i := 1 to lastPart do
        dispose (part[i]);

      initScheme;

      if readPicture (getTok (s, 4)) = 1 then
      begin
        writeln ('Loaded from ', getTok (s, 4));
        tracePicture;
        goto fail
      end;

      goto fail
    end;

    printError (s, posTok (s, 2), 'Unknown LOAD directive');
  fail:
  end;    { parseLOAD }

var
  st : string;       { a readed string from file }
  f : text;
  tok : string;
  currLine : integer; { number of current string  for dignosis }
  stop : boolean;

label contread, exit;
begin
  assign (f, fileName);
  {$I-}
  reset (f);
  {$I+}

  currLine := 1;
  stop := false;
  dialog := 0;

  if IOResult = 0 then
  begin
    while (not Eof (f)) and (not stop) do
    begin
      readln (f, st);

      tok := upString (getTok (st, 1));

      if tok = 'NEW' then
      begin
        parseNEW (st);
        goto contread
      end;

      if (tok = 'BYE') or (tok = 'QUIT') then
      begin
        stop := true;
        goto exit
      end;

      if tok = 'LIST' then
      begin
        parseLIST (st);
        goto contread
      end;

      if tok = 'SET' then
      begin
        parseSET (st);
        goto contread
      end;

      if tok = 'CONNECT' then
      begin
        parseCONNECT (st);
        goto contread
      end;

      if tok = 'SAVE' then
      begin
        parseSAVE (st);
        goto contread
      end;

      if tok = 'LOAD' then
      begin
        parseLOAD (st);
        goto contread
      end;

      if tok = 'SHOW' then
      begin
        parseSHOW (st);
        goto contread
      end;

      if tok = 'CALCULATE' then
      begin
        parseCALCULATE (st);
        goto contread
      end;

      if (tok = 'HELP') or (tok = '?') then
      begin
        parseHELP (st);
        goto contread
      end;

      if (tok = 'EDIT') then
      begin
        edit;
        goto contread
      end;

       { we didn't got any directive }
      if length (getTok (st, 1)) > 0 then
        printError (st, 0, 'Syntax error');
  contread:
      inc (currLine);
    end;     { while not eof }
  exit:
    close (f);
    dialog := 1;
  end
  else
    writeln ('Can not open file')
end;

end.
