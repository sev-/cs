unit toks;

interface

function upString (s : string) : string;
procedure printError (s : string; num : integer; msg : string);
function posTok (s : string; num : integer) : integer;
function getTok (s : string; num : integer) : string;

implementation

function upString (s : string) : string;
var
  i : integer;
  tmp : string;
begin
  tmp := s;
  for i := 1 to length (s) do
    tmp[i] := upcase (tmp[i]);
  upString := tmp;
end;

{ prints an error to the screen.
  s   - string
  num - position
  msg - message }
procedure printError (s : string; num : integer; msg : string);
var i : integer;
begin
  if num > 0 then
  begin
    writeln (s);
    if length (msg)+2 < num then
    begin
      write (msg);
      for i := length (msg) to num do
        write (' ');
      writeln ('^');
    end
    else
      begin
        for i := 1 to num-1 do
          write (' ');
        write ('^  ');

        if length (msg)+num+3 >= 78 then
          writeln;
        writeln (msg);
      end
  end
  else
    writeln ('^  ', msg)
end;

function posTok (s : string; num : integer) : integer;
var
  i, j : integer;
begin
  i := 1;
  j := 1;

  while (i <= length (s)) and (j < num) do
  begin
    while (i <= length (s)) and ((s[i] = ' ') or (s[i] = chr (9))) do
      inc (i);
    while (i <= length (s)) and (s[i] <> ' ') and (s[i] <> chr (9)) do
      inc (i);
    inc (j);
  end;

  posTok := -1;

  if i <= length (s) then
  begin
    while (i <= length (s)) and ((s[i] = ' ') or (s[i] = chr (9))) do
      inc (i);

    if i <= length (s) then
      posTok := i
  end
end;  { posTok }

function getTok (s : string; num : integer) : string;
var
  i, j : integer;
  tmp : string;
begin
  i := posTok (s, num);

  if i = -1 then
    getTok := ''
  else
  begin
    j := 0;
    while (i+j <= length (s)) and (s[i+j] <> ' ') and (s[i+j] <> chr (9)) do
      inc (j);

    if j > 0 then
      getTok := copy (s, i, j)
    else
      getTok := ''
  end
end;  { getTok }

end.