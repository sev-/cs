program cs;

uses crt, interp, base;

var
  fileName : string;
  i : integer;
begin
{  write ('Input file name: ');
  readln (fileName);
}
  clrscr;
  initElem;
  initScheme;
  i := dialog ('con');
  writeln ('Bye!');
end.

