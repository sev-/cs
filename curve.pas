unit curve;

interface

uses header;

procedure kriv_main (t1 : points; t2: points; param : integer; N1: integer; N2: integer);
procedure table(Name : string; t1 : points; N1 : integer);
procedure gist_main (t1 : points; t2: points; param : integer; N1: integer; N2: integer);

implementation

uses graph, crt;

procedure gis_psev (t1 : points; N1:integer; xx : integer; xm : integer; yy : integer;
              ym : integer; max: real);
var j, c, tmp2                : integer;
    tx, ty, kx, ky , ky1, kyN : integer;  { текущие координаты }
    tmp, step, l              : real;
    k                         : REAL;
    txs                       : string;
begin
  k:=(xm-xx)/(t1[N1].x);
  tx:=xx;
  ty:=ym;
  t1[N1+1].x:=t1[N1].x;
  for c:=1 to N1 do
  begin
    if ty < ty-round(t1[c].y * (ym-yy)/max)  then
    begin
      ky1:=ty;
      kyN:=ty-round(t1[c].y * (ym-yy)/max);
    end
    else
    begin
      kyN:=ty;
      ky1:=ty-round(t1[c].y * (ym-yy)/max);
    end;
    for kx:=tx to tx+round((t1[c+1].x-t1[c].x)*k) do
    begin
      for ky:=ky1 to kyN do
      begin
        gotoxy(kx,ky);
        write('▒');
      end;
    end;
    tx:=tx+round((t1[c+1].x-t1[c].x)*k);
  end;
  c:=xx;
  while c<=xm do
  begin
    tmp:=c/k;
    gotoxy(c,ty+2);
    write(tmp:3:2);
    c:=c+5;
  end;
  c:=ym-yy;
  while c>=1 do
  begin
    tmp:=(ym-c)*max/(ym-yy);
    gotoxy(xx-5,c);
    write(tmp:3:2);
    c:=c-2;
  end;
end;

{ main procedure for Histogram }

procedure gist_psev_main (t1 : points; t2: points; param : integer; N1: integer; N2: integer);
var xm, ym     :integer;
    ky, kx, i :integer;
    max,min:real;
    key : char;
begin
  textbackground(0);
  textcolor(15);
  clrscr;
  max:= abs(t1[1].y);
  for i:=2 to N1 do
    if abs(t1[i].y) > max then max:= abs(t1[i].y);
  min:= (t1[1].y);
  for i:=2 to N1 do
    if (t1[i].y) < min then min:= (t1[i].y);
  if min<0 then ym:=round((25*max)/(max-min))
  else ym:=24;
  { оси }
  { одна гистограмма }
  if param<>2 then begin
    xm:=80-1;
    for ky:=1 to 25 do   {  line(4,25,4,1); }
    begin
      gotoxy(5+1,ky);
      write('│');
    end;
    gotoxy(5+1,ym);
    write('├');
    for kx:=5+2 to xm-1 do {  line(4,ym,xm,ym); }
    begin
      gotoxy(kx,ym);
      write('─');
    end;
    textcolor(2);
    gis_psev (t1,N1,5+2,xm,1,ym-1,max);
                   end
  { две гистограммы }
  else begin
    xm:=80 div 2;
    for ky:=1 to 25 do   {  line(4,25,4,1); }
    begin
      gotoxy(5+1,ky);
      write('│');
    end;
    gotoxy(5+1,ym);
    write('├');
    for kx:=5+2 to xm-1 do {  line(4,ym,xm,ym); }
    begin
      gotoxy(kx,ym);
      write('─');
    end;
    textcolor(2);
    gis_psev (t1,N1,5+2,xm-1,1,ym-1,max);
    textcolor(15);
    max:= abs(t2[1].y);
    for i:=2 to N2 do
      if abs(t2[i].y) > max then max:= abs(t2[i].y);
    min:= (t2[1].y);
    for i:=2 to N2 do
      if (t2[i].y) > min then min:= (t2[i].y);
    if min<0 then ym:=round((25*max)/(max-min))
    else ym:=24;
    for ky:=1 to 25 do   {  line(4,25,4,1); }
    begin
      gotoxy(5+xm+1,ky);
      write('│');
    end;
    gotoxy(5+xm+1,ym);
    write('├');
    for kx:=5+xm+2 to xm+xm do {  line(xm+4,ym,xm+xm,ym);      ---}
    begin
      gotoxy(kx,ym);
      write('─');
    end;
    textcolor(3);
    gis_psev (t2,N2,5+xm+2,80,1,ym-1,max);
                   end;
  repeat
    key:=readkey;
  until key<>'';
end;

procedure kriv_psev (t1 : points; N1:integer; xx : integer; xm : integer; yy : integer;
              ym : integer; max : real);
var j, c, tmp2                : integer;
    tx, ty, kx, ky , ky1, kyN : integer;  { текущие координаты }
    tmp, step, l              : real;
    k                         : REAL;
    txs                       : string;
begin
  k:=(xm-xx)/(t1[N1].x);
  tx:=xx;
  ty:=ym;
  t1[N1+1].x:=t1[N1].x;
  for c:=1 to N1 do
  begin
    gotoxy(tx,ty-round(t1[c].y * (ym-yy)/max));
    write('*');
    tx:=tx+round((t1[c+1].x-t1[c].x)*k);
  end;
  c:=xx;
  while c<=xm do
  begin
    tmp:=c/k;
    gotoxy(c,ty+2);
    write(tmp:3:2);
    c:=c+5;
  end;
  c:=ym-yy;
  while c>=1 do
  begin
    tmp:=(ym-c)*max/(ym-yy);
    gotoxy(xx-5,c);
    write(tmp:3:2);
    c:=c-2;
  end;
end;

{ main procedure for krivaya }

procedure kriv_psev_main (t1 : points; t2: points; param : integer; N1: integer; N2: integer);
var xm, ym,ky,kx, i     :integer;
   max,min:real;
   key : char;
begin
  textbackground(0);
  textcolor(15);
  clrscr;
  max:= abs(t1[1].y);
  for i:=2 to N1 do
    if abs(t1[i].y) > max then max:= abs(t1[i].y);

  min:= (t1[1].y);
  for i:=2 to N1 do
    if (t1[i].y) < min then min:= (t1[i].y);

  if min<0 then ym:=round((25*max)/(max-min))
  else ym:=24;

  { оси }
  { одна гистограмма }
  if param<>2 then begin
    xm:=80-1;
    for ky:=1 to 25 do   {  line(4,25,4,1); }
    begin
      gotoxy(5+1,ky);
      write('│');
    end;
    gotoxy(5+1,ym);
    write('├');
    for kx:=5+2 to xm-1 do {  line(4,ym,xm,ym); }
    begin
      gotoxy(kx,ym);
      write('─');
    end;
    textcolor(2);
    kriv_psev (t1,N1,5+2,xm,1,ym-1,max);
                   end
  { две гистограммы }
  else begin
    xm:=80 div 2;
    for ky:=1 to 25 do   {  line(4,25,4,1); }
    begin
      gotoxy(5+1,ky);
      write('│');
    end;
    gotoxy(5+1,ym);
    write('├');
    for kx:=5+2 to xm-1 do {  line(4,ym,xm,ym); }
    begin
      gotoxy(kx,ym);
      write('─');
    end;
    textcolor(2);
    kriv_psev (t1,N1,5+2,xm-1,1,ym-1,max);
    textcolor(15);
    max:= abs(t2[1].y);
    for i:=2 to N2 do
      if abs(t2[i].y) > max then max:= abs(t2[i].y);
    min:= (t2[1].y);
    for i:=2 to N2 do
      if (t2[i].y) > min then min:= (t2[i].y);
    if min<0 then ym:=round((25*max)/(max-min))
    else ym:=24;
    for ky:=1 to 25 do   {  line(4,25,4,1); }
    begin
      gotoxy(5+xm+1,ky);
      write('│');
    end;
    gotoxy(5+xm+1,ym);
    write('├');
    for kx:=5+xm+2 to xm+xm do {  line(xm+4,ym,xm+xm,ym);      ---}
    begin
      gotoxy(kx,ym);
      write('─');
    end;
    textcolor(3);
    kriv_psev (t2,N2,5+xm+2,80,1,ym-1,max);
                   end;
  repeat
    key:=readkey;
  until key<>'';
end;

procedure table(Name : string; t1 : points; N1 : integer);
var i,j:integer;
    key :char;
    tmp : real;
begin
  for i:=1 to N1-1 do
  for j:=i+1 to N1 do
    if t1[j].x<t1[i].x then begin
				tmp:=t1[i].x;
				t1[i].x:=t1[j].x;
				t1[j].x:=tmp;
				tmp:=t1[i].y;
				t1[i].y:=t1[j].y;
				t1[j].y:=tmp;
                           end;
  clrscr;
  i:=1;
  while i<=N1 do
  begin
    clrscr;
    writeln(Name);
    writeln('╔══════════╤══════════╗');
    writeln('║   W1     │    W2    ║');
    writeln('╠══════════╪══════════╣');
    j:=2;
    while (j<=19) and (i<=N1) do
    begin
      writeln('║',t1[i].x:10:4,'│',t1[i].y:10:4,'║');
      i:=i+1;
      j:=j+1;
    end;
    writeln('╚══════════╧══════════╝');
    writeln('Для продолжения нажмите любую клавишу');
    repeat
      key:=readkey;
    until key<>'';
  end;
  clrscr;
end;

procedure gis (t1 : points; N1:integer; xx : integer; xm : integer; yy : integer;
              ym : integer;max:real);
var j,c,tmp2 : integer;
    tx,ty : integer;  { текущие координаты }
    tmp,step,l:real;
    k :REAL;
    txs :string;
begin
  { масштаб: x -> (xm-xx)/k     y -> ym/max  }
  { гистограмма }
  k:=(xm-xx)/(t1[N1].x);
  tx:=xx;
  ty:=ym-1;
  t1[N1+1].x:=t1[N1].x;
  for c:=1 to N1 do
    begin
      bar(tx,                             ty,
          tx+round((t1[c+1].x-t1[c].x)*k),ty-round(t1[c].y * (ym-yy)/max));
      tx:=tx+round((t1[c+1].x-t1[c].x)*k);
    end;
  c:=xx;
  while c<=xm do
  begin
    tmp:=c/k;
    str(tmp:3:2,txs);
    outtextxy(c,ty+4,txs);
    c:=c+40;
  end;
  c:=ym-yy-10;
  while c>=1 do
  begin
    tmp:=(ym-c)*max/(ym-yy);
    str(tmp:3:2,txs);
    outtextxy(xx-30,c,txs);
    c:=c-15;
  end;
end;

{ main procedure for Histogram }

procedure gist_main (t1 : points; t2: points; param : integer; N1: integer; N2: integer);
var graphdriver:integer;
    graphmode  :integer;
    xm, ym, i     :integer;
    max,min :real;
    key : char;
begin
  graphdriver:=detect;
  initgraph(graphdriver,graphmode,'');
  cleardevice;
  setlinestyle(solidln,0,thickwidth);
  max:= abs(t1[1].y);
  for i:=2 to N1 do
    if abs(t1[i].y) > max then max:= abs(t1[i].y);
  min:= t1[1].y;
  for i:=2 to N1 do
    if t1[i].y < min then min:= t1[i].y;
  if min<0 then ym:=round((getmaxy * max)/(max-min))
  else ym:=getmaxy-15;
  { оси }
  if param<>2 then begin
    xm:=getmaxx-1;
    line(25+4,getmaxy,25+4,1);            { | }
    line(25+4,ym,xm,ym);               {---}
    line(25+4,1,25+0,5);                  { ^ }
    line(25+4,1,25+8,5);
    line(xm,ym,xm-4,ym+4);          { > }
    line(xm,ym,xm-4,ym-4);
    setfillstyle(8,2);
    setcolor(2);
    gis(t1,N1,25+5,xm,1,ym,max);
                   end
              else begin
    xm:=getmaxx div 2;
    line(25+4,getmaxy,25+4,1);                 { | }
    line(25+4,ym,xm,ym);               {---}
    line(25+4,1,25+0,5);                  { ^ }
    line(25+4,1,25+8,5);
    line(xm,ym,xm-4,ym+4);          { > }
    line(xm,ym,xm-4,ym-4);
    setfillstyle(8,2);
    setcolor(2);
    gis(t1,N1,25+5,xm,1,ym,max);
    setlinestyle(solidln,0,thickwidth);
    setcolor(15);
    max:= abs(t2[1].y);
    for i:=2 to N2 do
      if abs(t2[i].y) > max then max:= abs(t2[i].y);
    min:= t2[1].y;
    for i:=2 to N2 do
      if t2[i].y < min then min:= t2[i].y;
    if min<0 then ym:=round((getmaxy * max)/(max-min))
    else ym:=getmaxy-15;
    line(25+xm+4,getmaxy,25+xm+4,1);           { | }
    line(25+xm+4,ym,xm+xm,ym);         {---}
    line(25+xm+4,1,25+xm+0,5);            { ^ }
    line(25+xm+4,1,25+xm+8,5);
    line(xm+xm,ym,xm+xm-4,ym+4);    { > }
    line(xm+xm,ym,xm+xm-4,ym-4);
    setfillstyle(8,3);
    setcolor(3);
    gis(t2,N2,25+xm+5,xm+xm,1,ym,max);
                   end;
  repeat
    key:=readkey;
  until key<>'';
  closegraph;
end;

procedure parab(t1 : points; x1 : integer; x2 : integer; y1 : integer;
                y2 : integer; z : integer; xx : integer; c : integer;
                k : real; m : real; ym : integer; col : integer);
var a:real;
    j,i:real;
    txs:string;
begin
  if t1[x1].x-t1[x2].x=0 then
    i:=0.0001 else i:=t1[x1].x-t1[x2].x;
  a:=z * (t1[y1].y-t1[y2].y) / SQR(i);
  j:=(t1[c+1].x-t1[c].x)/400;
  i:=t1[c].x;
  while i<=t1[c+1].x do
    begin
      putpixel(xx+round(i*k),ym-round((z*a*(i-t1[x2].x)*(i-t1[x2].x)+t1[y2].y) * m),col);
      i:=i+j;
    end;
end;

procedure kriv(t1 : points; N1:integer;xx : integer; xm : integer; yy : integer;
               ym : integer; col : integer;max:real);
var j,c,tmp2 : integer;
    ty : integer;  { текущие координаты }
    a:real;
    tmp,step,l:real;
    k :REAL;
    txs :string;
begin
  if max=0 then a:=0.000001 else a:=max;
  a:=(ym-yy)/a;
  k:=(xm-xx)/t1[N1].x;
  ty:=ym-1;

  for c:=1 to N1-1 do
    begin
      if c=N1-1 then
      begin
        if t1[c+1].y>t1[c].y then
        begin
          if t1[c-1].y<t1[c].y then begin
            parab(t1,c,c+1,c,c+1,-1,xx,c,k,a,ym,col);
                                    end
          else
          if t1[c-1].y>=t1[c].y then begin
            parab(t1,c+1,c,c+1,c,1,xx,c,k,a,ym,col);
                                     end
        end
        else
        if t1[c+1].y<t1[c].y then
        begin
          if (t1[c-1].y>t1[c].y) and (t1[c-2].y>t1[c-1].y) then begin
            parab(t1,c+1,c,c+1,c,{-}1,xx,c,k,a,ym,col);
                                                                end
          else
          if (t1[c-1].y>t1[c].y) and (t1[c-2].y<=t1[c-1].y) then begin
            parab(t1,c,c+1,c,c+1,1,xx,c,k,a,ym,col);
                                                                 end
          else
          if t1[c-1].y<=t1[c].y then begin
            parab(t1,c,c+1,c,c+1,1,xx,c,k,a,ym,col);
                                     end
        end
        else
        if t1[c+1].y=t1[c].y then
        begin
          line(xx+round(t1[c].x*k),                   ym-round(t1[c].y * a),
               xx+round((t1[c+1].x)*k),ym-round(t1[c+1].y*a));
        end
      end
      else
      if t1[c+1].y>t1[c].y then
      begin
        if t1[c+2].y<=t1[c+1].y then
        begin
          parab(t1,c,c+1,c,c+1,-1,xx,c,k,a,ym,col);
        end
        else
        if t1[c+2].y>t1[c+1].y then begin
        begin
          line(xx+round(t1[c].x*k),                   ym-round(t1[c].y * a),
               xx+round((t1[c+1].x)*k),ym-round(t1[c+1].y*a));
        end
{          parab(t1,c+1,c,c+1,c,1,xx,c,k,a,ym,col);
}                                    end
      end
      else
      if t1[c+1].y<t1[c].y then
      begin
        if t1[c+2].y<t1[c+1].y then begin
        begin
          line(xx+round(t1[c].x*k),                   ym-round(t1[c].y * a),
               xx+round((t1[c+1].x)*k),ym-round(t1[c+1].y*a));
        end
{         parab(t1,c+1,c,c+1,c,-1,xx,c,k,a,ym,col);
}                                    end
        else
        if t1[c+2].y>=t1[c+1].y then begin
          parab(t1,c,c+1,c,c+1,1,xx,c,k,a,ym,col);
                                     end
      end
      else
      if t1[c+1].y=t1[c].y then
      begin
        line(xx+round(t1[c].x*k),    ym-round(t1[c].y * a),
             xx+round((t1[c+1].x*k)),ym-round(t1[c+1].y*a));
      end;
    end;
  c:=xx;
  while c<=xm do
  begin
    tmp:=c/k;
    str(tmp:3:2,txs);
    outtextxy(c,ty+4,txs);
    c:=c+40;
  end;
  c:=getmaxy-60{ym-1};
  while c>=50 do
  begin
    tmp:=(ym-c)*max/(ym-yy);
    str(tmp:3:2,txs);
    outtextxy(xx-30-5,c,txs);
    c:=c-15;
  end;
end;

{ main procedure for krivaya }

procedure kriv_main (t1 : points; t2: points; param : integer; N1: integer; N2: integer);
var graphdriver:integer;
    graphmode  :integer;
    xm, ym, i, j     :integer;
    max,min,tmp:real;
    key : char;
begin
  graphdriver:=detect;
  initgraph(graphdriver,graphmode,'');
  cleardevice;
  setlinestyle(solidln,0,thickwidth);

  for i:=1 to N1-1 do
  for j:=i+1 to N1 do
    if t1[j].x<t1[i].x then begin
				tmp:=t1[i].x;
				t1[i].x:=t1[j].x;
				t1[j].x:=tmp;
				tmp:=t1[i].y;
				t1[i].y:=t1[j].y;
				t1[j].y:=tmp;
                           end;
  max:= abs(t1[1].y);
  for i:=2 to N1 do
    if abs(t1[i].y) > max then max:= abs(t1[i].y);

  min:= t1[1].y;
  for i:=2 to N1 do
    if t1[i].y < min then min:= t1[i].y;

  if min<0 then ym:=round((getmaxy * max)/(max-min))
  else ym:=getmaxy-15;

  { оси }
  if param<>2 then begin
    xm:=getmaxx-1;
    line(25+4+5,getmaxy,25+4+5,1+60);            { | }
    line(25+4+5,ym,xm,ym);               {---}
    line(25+4+5,1+60,25+0+5,5+60);                  { ^ }
    line(25+4+5,1+60,25+8+5,5+60);
    line(xm,ym,xm-4,ym+4);          { > }
    line(xm,ym,xm-4,ym-4);
    setlinestyle(solidln,0,normwidth);
    setcolor(2);
    kriv(t1,N1,25+5+5,xm,1+60,ym,2,max);
                   end
              else begin
    xm:=getmaxx div 2;
    line(25+4,getmaxy,25+4,1);                 { | }
    line(25+4,ym,xm,ym);               {---}
    line(25+4,1,25+0,5);                  { ^ }
    line(25+4,1,25+8,5);
    line(xm,ym,xm-4,ym+4);          { > }
    line(xm,ym,xm-4,ym-4);
    setlinestyle(solidln,0,normwidth);
    setcolor(2);
    kriv(t1,N1,25+5,xm,1,ym,2,max);
    setlinestyle(solidln,0,thickwidth);
    setcolor(15);
    max:= abs(t2[1].y);
    for i:=2 to N2 do
      if abs(t2[i].y) > max then max:= abs(t2[i].y);
    min:= t2[1].y;
    for i:=2 to N2 do
      if t2[i].y < min then min:= t2[i].y;
    if min<0 then ym:=round((getmaxy * max)/(max-min))
    else ym:=getmaxy-15;
    line(25+xm+4,getmaxy,25+xm+4,1);           { | }
    line(25+xm+4,ym,xm+xm,ym);         {---}
    line(25+xm+4,1,25+xm+0,5);            { ^ }
    line(25+xm+4,1,25+xm+8,5);
    line(xm+xm,ym,xm+xm-4,ym+4);    { > }
    line(xm+xm,ym,xm+xm-4,ym-4);
    setcolor(3);
    setlinestyle(solidln,0,normwidth);
    kriv(t2,N2,25+xm+5,xm+xm,1,ym,3,max);
                   end;
  repeat
    key:=readkey;
  until key<>'';
  closegraph;
end;

end.