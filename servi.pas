unit servi;

interface

uses header;
procedure servis(t1 : points; N1 : integer);

implementation

uses crt;

procedure servis(t1 : points; N1 : integer);
var i, j : integer;
    S,S_sr,S_d,S_i,n : real;
    key :char;
begin
  S := 0;
  S_i := 0;
  S_d := 0;
  n := ( t1[N1].x-t1[1].x ) / ( t1[2].x-t1[1].x );
  for i := 1 to N1 do
  begin
    S := S + t1[i].y;
    S_d := S_d + SQR( t1[i].y );
    if i > 1 then
      S_i := S_i + (t1[i-1].y-t1[i].y)*(t1[i].x+t1[i-1].x)/2;
  end;
  S_sr := S / N1;
  S_d := SQRT (S_d) / N1;
  clrscr;
  i:=1;
  while i<=N1 do
  begin
    clrscr;
    writeln('╔══════════╤══════════╗');
    writeln('║    t     │    W     ║');
    writeln('╠══════════╪══════════╣');
    j:=2;
    while (j<=19) and (i<=N1) do
    begin
      writeln('║',t1[i].x:10:4,'│',t1[i].y:10:4,'║');
      i:=i+1;
      j:=j+1;
    end;
    writeln('╚══════════╧══════════╝');
    writeln('Hажмите любую клавишу');
    repeat
      key:=readkey;
    until key<>'';
  end;
  gotoxy(30,3);
  write('Среднее значение выходного сигнала     : ',S_sr:10:4);
  gotoxy(30,5);
  write('Действующее значение выходного сигнала : ',S_d:10:4);
  gotoxy(30,7);
  write('Интеграл выходного сигнала             : ',S_i:10:4);
  repeat
    key:=readkey;
  until key<>'';
  clrscr;
end;

end.
