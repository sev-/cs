unit edit5;

interface

procedure edit;

implementation
uses crt, dos, header, base, parse, load;

procedure edit;
const
  MaxKr=5;              { Кол-во режимов в меню }
  MaxLen=16;             { Кол-во символов в названиях режимов}
  winX1=2;
  WinY1=3;
  WinX2=78;
  WinY2=22;
  maxX=150;            {   Границы экрана        }
  maxY=100;
  SizeEl=6;
  Fon=blue;
  TxtCl=white;
  x1=30;               { Координаты диалогового окна }
  y1=5;
  x2=60;
  y2=11;


type
  r_Name = array [1..MaxKr] of string[MaxLen];  {   Названия режимов   }
  el_Name = array [1..C_NUMELEM] of string[8]; {  Названия элементов }
  st150 = string[maxX];
var
  Regime:byte;{ Номер выбранного режима }
  SubRegime:integer;
  NR: r_Name;  { Названия опций меню }
  NR2: r_Name;
  NE: el_Name;
  i:integer;
 { screen : array [1..maxY] of st150;}
  CurrentSelected: integer;
  Select:integer;
  XVMenu : integer;
  x,y:integer;
  ShownX, ShownY : integer;
  old_X,old_Y: integer;    { значение x y для левого крайнего угла экрана }

 Procedure CF ( C,F : byte);
   { C - цвет символов , F - фон }
 begin
   TextColor(C);
   TextBackGround(F);
 end;

    { " Видимый-невидимый " курсор  }
Procedure Cursor ( Flag : boolean);
const
  SizeCursor : word = 0;
var
  Reg : registers;
begin
  with Reg do
  begin
    if Flag then
      Cx := SizeCursor   { Восстановим старый размер курсора  }
    else
    begin
      BH := 0;       { 0 - страница дисплея  }
      AH := 03;      { Функция чтения размера и позиции курсора }
      Intr($10,Reg);
      SizeCursor := Cx; { Сохраняем размер курсора }
      CH := $20;        { Делаем курсор невидимым  }
    end;
      AH := 01;         { Функция установки размера курсора }
      Intr($10,Reg);
  end;
end;

    { Процедура черчения рамок }
procedure SingFrame( X1, Y1, X2, Y2 : integer );
const
  A='│'; B='┐'; C='┘';
  D='└'; E='┌'; F='─';
var
  i,j : integer;
begin
  GotoXY(X2,Y2);
  write(C);
  GotoXY (X1,Y1);
  write(E);
  for i:= (X1+1) to  (X2-1) do write(F);
  write(B);
  for i:=(Y1+1) to (Y2-1) do
  begin
    GotoXY(X1,i);
    write(A);
    GotoXY(X2,i);
    write(A);
  end;
  GotoXY(X1,Y2);
  write(D);
  for i := (X1+1) to (X2-1) do write(F);

end;

procedure Frame( X1, Y1, X2, Y2 : integer );
const
  A='║'; B='╗'; C='╝';
  D='╚'; E='╔'; F='═';
var
  i,j : integer;
begin
  GotoXY(X2,Y2);
  write(C);
  GotoXY (X1,Y1);
  write(E);
  for i:= (X1+1) to  (X2-1) do write(F);
  write(B);
  for i:=(Y1+1) to (Y2-1) do
  begin
    GotoXY(X1,i);
    write(A);
    GotoXY(X2,i);
    write(A);
  end;
  GotoXY(X1,Y2);
  write(D);
  for i := (X1+1) to (X2-1) do write(F);

end;

    {  Процедура  строит горизонтальное меню   }
    {  Kr - количество режимов                 }
procedure GMenu ( K1,K2,Kr : byte; M : r_Name; var Result:byte;
               var XVmenu : integer );
Label Met;
var
  I,T,R : byte;
  Pp : array [1..20] of byte;
  Ch : char;
  Fl : boolean;
  Prompt : string;
begin
  Cursor (False);
  Fl := True;
  T := Length ( M[1] );
  R := 0;
  for i:=1 to Kr do
  R := R+Length(M[i]);
  R := Round ((78-R)/Kr)-1;
  Cf(Fon, TxtCl);
  GotoXY(1,24);
  Prompt:=
  '   С помощью '+ Chr(26)+ ' или '+ Chr(27)+' укажите режим и нажмите < Enter > ,<Esc> - выход';
  write('':79);
  GotoXY(1,24);
  write(Prompt);
  CF(Fon,TxtCl);
  GotoXY(4,K2);
  write('':Round(R/2+5));
  GotoXY( Round( R/2+5 ),K2);
  for i:=1 to Kr do
  begin
    if i=1 then CF(TxtCl,Fon) else CF(Fon,TxtCl);
    Pp[i] := WhereX;
    write(M[i]); CF(Fon,TxtCl);
    if i=Kr then R:=3;
    write('':R);
  end;
  i:=1;
  while Fl=True do
  begin
    Ch:=ReadKey;
    if Ch = #13 then Fl:=False;
    if Ch = #27 then
    begin
      Fl:=False;
      i:=0;
    end;
    if (Ch = #0) and KeyPressed then
    begin
      Ch:=ReadKey;
      case Ch of

        #77 : begin
                GotoXY(Pp[i],K2);
                CF(Fon,TxtCl); write( M[i] );
                i:=i+1;
                if i=(Kr+1) then
                begin
                  i:=1;
                  CF(Fon,TxtCl);
                  GotoXY(Pp[i],K2);
                  CF(TxtCl,Fon);
                  write ( M[i]);
                  CF(Fon,TxtCl);
                  goto Met;
                end;
                GotoXY(Pp[i],K2);
                CF(TxtCl,Fon);
                write (M[i]);
                CF(Fon,TxtCl)
              end;

        #75 : begin
                if i=1 then goto Met;
                GotoXY (Pp[i],K2);
                CF(Fon,TxtCl);
                write(M[i]);
                i:=i-1;
                GotoXY(Pp[i],K2);
                CF(TxtCl,Fon);
                write(M[i]);
              end;
      end;
 met:
      end;
      end;
      Result:=i;
      XVmenu:=pp[i];
      CF(TxtCl, Fon);
      Cursor (True);
end;

Procedure el_Vmenu( k1, k2, kr : byte; M : el_Name;
                 var Result : integer );
 Label Met;
var
  I,T,R : byte;
  Pp : array [1..20] of byte;
  Ch : char;
  Fl : boolean;
begin
  Cursor (False);
  Fl := True;
  T := Length ( M[1] );
  for i:=1 to Kr do
    if  Length (M[i]) > T then T:=Length(M[i]);

  Frame( K1-1, K2, K1+T, kr+K2+1+1);
  window( K1-1+WinX1, K2+WinY1, K1+T, kr+K2+1+1);
  ClrScr;
  for i:=1 to Kr do
  begin
    if i=1 then CF(Fon,TxtCl) else CF(TxtCl,Fon);
    gotoXY ( 1, i );
    write(M[i]);
  end;
  CF(TxtCl,Fon);
  i:=1;
  while Fl=True do
  begin
    Ch:=ReadKey;
    if Ch = #13 then Fl:=False;
    if (Ch = #0) and KeyPressed then
    begin
      Ch:=ReadKey;
      case Ch of

        #80 : begin
                GotoXY(1,i);
                CF(TxtCl,Fon);
                write( M[i] );
                i:=i+1;
                if i=(Kr+1) then
                begin
                  i:=1;
                  CF(TxtCl,Fon);
                  GotoXY(1,i);
                  CF(Fon,TxtCl);
                  write ( M[i]);
                  CF(TxtCl,Fon);
                  goto Met;
                end;
                GotoXY(1,i);
                CF(Fon,TxtCl);
                write (M[i]);
                CF(TxtCl,Fon)
              end;

        #72 : begin
                if i=1 then goto Met;
                GotoXY (1,i);
                CF(TxtCl,Fon);
                write(M[i]);
                i:=i-1;
                GotoXY(1,i);
                CF(Fon,TxtCl);
                write(M[i]);
              end;
      end;
 met:
      end;
      end;
      Result:=i;
      CF(TxtCl,Fon);
      Cursor (True);
      window ( WinX1, WinY1, WinX2, WinY2 );
end;

Procedure Vmenu( k1, k2, kr : byte; M : r_Name;
                 var Result : integer );
 Label Met;
var
  I,T,R : byte;
  Pp : array [1..20] of byte;
  Ch : char;
  Fl : boolean;
begin
  Cursor (False);
  Fl := True;
  T := Length ( M[1] );
  for i:=1 to Kr do
    if  Length (M[i]) > T then T:=Length(M[i]);

  window( K1, K2-1, K1+T+3, kr+K2);
  cf(Fon,TxtCL);
  ClrScr;
  SingFrame(2,1,T+3,Kr+2);
  for i:=1 to Kr do
  begin
    if i=1 then CF(TxtCl,Fon) else CF(Fon,TxtCl);
    gotoXY ( 3, i+1 );
    write(M[i]);
  end;
  CF(Fon,TxtCl);
  i:=1;
  while Fl=True do
  begin
    Ch:=ReadKey;
    if Ch = #13 then Fl:=False;
    if Ch = #27 then
    begin
      Fl:=False;
      i:=0;
    end;
    if (Ch = #0) and KeyPressed then
    begin
      Ch:=ReadKey;
      case Ch of

        #80 : begin
                GotoXY(3,i+1);
                CF(Fon,TxtCl);
                write( M[i] );
                i:=i+1;
                if i=(Kr+1) then
                begin
                  i:=1;
                  CF(Fon,TxtCl);
                  GotoXY(3,i+1);
                  CF(TxtCl,Fon);
                  write ( M[i]);
                  CF(Fon,TxtCl);
                  goto Met;
                end;
                GotoXY(3,i+1);
                CF(TxtCl,Fon);
                write (M[i]);
                CF(Fon,TxtCl)
              end;

        #72 : begin
                if i=1 then goto Met;
                GotoXY (3,i+1);
                CF(Fon,TxtCl);
                write(M[i]);
                i:=i-1;
                GotoXY(3,i+1);
                CF(TxtCl,Fon);
                write(M[i]);
              end;
      end;
 met:
      end;
      end;
      Result:=i;
      CF(TxtCl,Fon);
      Cursor (True);
      window ( 1, 1, 80, 25 );
end;


procedure InitWin(Fx1,Fy1,Fx2,Fy2,Ffon,Fletter:byte);
  { Инициировать окно: устаноить координаты окна, цвет фона}
begin
  TextBackGround(Ffon);
  TextColor(Fletter);
  window(Fx1,Fy1,Fx2,Fy2);
  ClrScr;
end;


procedure InitScreen;
var
  i,j:integer;
begin
  
  for i:=1 to maxY do
  begin
    for j:=1 to maxX  do
      screen[i][j] := ' ';
  end;
end;

procedure ShowScreen ( x1, y1 : integer;  width, height: integer;
                       scX,scY : integer);
var
i,j : integer;
begin
  for i:=ScY to height+ScY-1 do
  begin
     for j:=ScX to width+ScX do
     begin
       gotoxy (j, i);
       write ( screen[i-1+y1][j-1+x1]);
     end;
  end;
end;

function CheckFreePlace ( x, y, h, w :integer ) : boolean;
var
  i,j : integer;
begin
  CheckFreePlace:=True;

  i := 0;
  while i<=w  do
  begin
    j := 0;
    while j<=h do
    begin
      if screen[y+i][x+j]<>' ' then
         CheckFreePlace:=False;
      j:=j+1;
    end;
    i:=i+1;
  end;
end;


function max ( z1, z2 : integer ) : integer;
begin
  if z1 > z2 then max := z1 else max := z2;
end;


procedure ShowElement (ShownX, ShownY, x, y, what : integer);
  var
  i, j, max_num, k : integer;
begin
  max_num := max ( element[what].num_in, element[what].num_out);
  k:=0;
  for j:=y to y + max_num + 1 do
  begin
    for i := 0 to SizeEl do
    begin
      GotoXY(ShownX+i, ShownY+k);
      write (screen[j][x+i]);
    end;
    k:=K+1;
  end;
end;

procedure putElement ( x, y, ShownX,ShownY, what : integer;
                      var CurrentSelected:integer );
var
  i,j,max_num : integer;
  st:string;
  k : integer;

begin
  st:='══';
  str( CurrentSelected, st );
  max_num := max ( element[what].num_in, element[what].num_out);
  if CheckFreePlace ( x, y, SizeEl, max_num+1) then
  begin
    screen[y][x]:='╔';
    screen[y][x+1]:=st[1];
    screen[y][x+2]:=st[2];
    for i:=3 to SizeEl-1 do
      screen[y][x+i] := '═';

    k:=1;
    for j:=y+1 to max_num+y+1 do
    begin
      if k <= element [what].num_in then
        screen[j][x]:='╢'
      else
        screen[j][x]:='║';
      for i:=1 to SizeEl-1 do
        screen[j][x+i] := ' ';
      if k <= element [what].num_out then
        screen[j][x+SizeEl]:='╟'
      else
        screen[j][x+SizeEl] := '║';
      k:=k+1;
    end;
    screen[y][x+SizeEl]:='╗';
    for i:=1 to SizeEl-1 do
      screen [y+max_num+1][X+i]:='═';
    screen[y+max_num+1][x]:='╚';
    screen[y+max_num+1][x+SizeEl]:='╝';
    ShowElement ( ShownX, ShownY, x, y, what);
    CurrentSelected:=CurrentSelected+1;
    
  end;
end;



  {  Удаление элемента из  памяти   }
procedure NullEl ( x, y, what: integer);
var
  i,j : integer;
  max_num : integer;
begin
  max_num := max ( element[what].num_in, element[what].num_out);
  for i:=0 to max_num+1 do
    for j:=0 to SizeEl do
    screen[y+i][x+j] := ' ';
end;


procedure ParamSet ( what : integer; CurrentSelect: integer);
var
  i: integer;
begin
  Frame ( x1-1, y1-1, x2+1, y2+1);
  window( x1+WinX1-1, y1+WinY1-1, x2+WinX1-1, y2+WinY1-1);
  ClrScr;
  write ( '  Элемент : ');
  writeln ( element[what].name);
  writeln ('  Введите параметры :');
  part[CurrentSelect]^.name:= element[what].name;
  for i:=1 to element[what].num_par do
  begin
    write(element[what].par_name[i], '= ');
    readln(part[CurrentSelect]^.par[i]);
  end;
  window(1,1,25,80);
  window( WinX1, WinY1, WinX2, WinY2);
end;

procedure ParamList (  Select: integer);
var
  i: integer;
  stop:char;
begin
  Frame ( x1-1, y1-1, x2+1, y2+1);
  window( x1+WinX1-1, y1+WinY1-1, x2+WinX1-1, y2+WinY1-1);
  ClrScr;
  if Select > 0 then
  begin
    write ( '  Элемент : ');
    writeln ( part[Select]^.name);
    writeln (' Параметры :');
    for i:=1 to part[Select]^.whatIs^.num_par do
    begin
      write(part[Select]^.whatIs^.par_name[i], '= ');
      writeln(part[Select]^.par[i]:8:5);
    end;
  end
  else
  begin
    writeln('         Error  ');
    writeln('  Установите курсор');
    writeln('  на элемент');
  end;
  stop:=readkey;
  window(1,1,25,80);
  window( WinX1, WinY1, WinX2, WinY2);
end;
       { Замена параметров }
procedure ParamDel (  Select: integer);
var
  i: integer;
  stop:char;
begin
  Frame ( x1-1, y1-1, x2+1, y2+1);
  window( x1+WinX1-1, y1+WinY1-1, x2+WinX1-1, y2+WinY1-1);
  ClrScr;
  if Select > 0 then
  begin
    write ( '  Элемент : ');
    writeln ( part[Select]^.name);
    writeln (' Введите параметры :');
    for i:=1 to part[Select]^.whatIs^.num_par do
    begin
      write(part[Select]^.whatIs^.par_name[i], '= ');
      readln(part[Select]^.par[i]);
    end;
  end
  else
  begin
    writeln('        Error');
    writeln('  Установите курсор');
    writeln('  на элемент');
    stop:=readkey;
  end;
  window(1,1,25,80);
  window( WinX1, WinY1, WinX2, WinY2);
end;

   {  Получить номер выбранного элемента  }
procedure scanNumber(var scanX,scanY:integer; var Select:integer);
const
 example='╢║╚╔';
var
   i: integer;
   stSelect:string;
   code : integer;
begin
   i:=1;
   while (pos(screen[scanY][scanX],example)=0) and (i<SizeEl) do
   begin
     scanX:=scanX-1;
     i:=i+1;
   end;
   i:=1;
   while (screen[scanY][scanX]<>'╔') and (i<c_NumPar) do
   begin
     scanY:=scanY-1;
     i:=i+1;
   end;
   if screen[scanY][scanX+2] = '═' then StSelect:=screen[scanY][scanX+1]
   else
   StSelect:=screen[scanY][scanX+1]+screen[scanY][scanX+2];
   val(stSelect,Select,code);
end;


   { Удаление элемента  }
procedure DelEl(sx,sy:integer);
begin
  scanNumber(sx,sy,Select);
  NullEl(sx,sy,Select);
end;

  {  Курсор превращается в изображение элемента }
procedure MoveEl( var x, y, ShownX, ShownY, CurrentSelected : integer;
                 what : integer);
var
  SetEl : boolean;
  ChEl : char;
  old_X, old_Y : integer;
  max_num : integer;
begin

  max_num := max ( element[what].num_in, element[what].num_out);
  SetEl := True;
  Cursor(False);

  while SetEl do
  begin
    ChEl := readkey;

    if ChEl = #13 then
    begin
      SetEl := False;
      Cursor(True);
      Paramset(what, CurrentSelected-1);
    end;

    if ChEl = #27 then
    begin
      SetEl := False;
      NullEl(X,Y,what);
      CurrentSelected := CurrentSelected - 1;
    end;

    if ( ChEl = #0 ) and KeyPressed then
    begin
      NullEl ( x, y, what);
      ChEl := ReadKey;
      case ChEl of
      #75: begin      {  влево  }
             if  CheckFreePlace ( x-1, y, SizeEl, max_num+1) then
             begin
               if x > 1 then
               begin
                 x:=x-1;
                 if ShownX-1 < 1 then
                   ShownX := 1
                 else ShownX := ShownX-1;
               end
               else
                 x:=1;
             end;
           end;
      #77: begin      {  вправо }
             if  CheckFreePlace ( x+1, y, SizeEl, max_num+1) then
             begin
               if x < MaxX then
               begin
                 x:=x+1;
                 if ShownX+1 > WinX2-WinX1 then
                   ShownX := WinX2-WinX1
                 else ShownX := ShownX + 1
               end
               else
                 x:=MaxX;
             end;
           end;
      #80: begin       {  вниз  }
             if  CheckFreePlace ( x, y+1, SizeEl, max_num+1) then
             begin
               if y < maxY then
               begin
                 y:=y+1;
                 if ShownY+1 > WinY2-WinY1 then
                 begin
                   ShownY := WinY2-WinY1;
                 end
                 else ShownY := ShownY + 1;
               end
               else
                 y:=maxY;
             end;
          end;
      #72: begin   {  вверх   }
             if  CheckFreePlace ( x, y-1, SizeEl, max_num+1) then
             begin
               if y > 1 then
               begin
                 y:=y-1;
                 if ShownY-1 < 1 then
                 begin
                   ShownY := 1;
                 end
                 else ShownY := ShownY - 1
               end
               else y:=1;
             end;
           end;
      end;
      ClrScr;
      old_X:=x-ShownX+1;
      old_Y:=y-ShownY+1;
      ShowScreen(old_X,old_y,WinX2-WinX1,WinY2-WinY1,1,1);
      if CheckFreePlace ( x, y, SizeEl, max_num+1) then
        CurrentSelected := CurrentSelected - 1;
      putelement ( x, y, ShownX, ShownY, what, CurrentSelected);

    end;
  end;
  Cursor(True);
  GotoXY(ShownX, ShownY);
end;

  (* Рисует соединяющие линии *)

Procedure Connects ( x, y, dx1, dy1, dx2, dy2 : integer);
const
  primer = '╢╟║╗╝╜╚═';
begin
  if pos(screen[y][x] , primer) = 0 then
  begin
  case screen[y-dy1][x-dx1] of
    '─' : begin
            if (dx1=1) and (screen[y][x] = '│') then
               screen[y][x] := '┤';
            if (dx1=-1) and (screen[y][x] = '│') then
               screen[y][x] := '├';
            if (dy2 = -1) and (dx1 = 1) then
            begin
              screen[y][x] :='┘';
            end;

            if (dy2 = -1) and (dx1 = -1) then
            begin
              screen[y][x] := '└';
            end;
            if (dy2 = 1) and (dx1 = -1) then
            begin
              screen[y][x] := '┌';
            end;
            if (dy2 = 1) and (dx1 = 1) then
            begin
              screen[y][x] := '┐';
            end;
            if ((dx2 = 1) or ( dx2 = -1)) and ((screen[y][x] <> '┼')
               and (screen[y][x] <> '┤') and (screen[y][x] <> '├'))
            then
              screen[y][x] := '─';

          end;


    '│' : begin
            if  (dy1=1) and (screen[y][x] = '─') then
               screen[y][x] := '┴';
            if  (dy1=-1) and (screen[y][x] = '─') then
               screen[y][x] := '┬';
            if (dx2 = -1) and (dy1=1) then
            begin
               screen[y][x] := '┘';
            end;
            if (dx2 = -1) and (dy1=-1) then
            begin
               screen[y][x] :='┐';
            end;
            if (dx2 = 1) and (dy1=-1)  then
            begin
              screen[y][x] := '┌';
            end;
            if (dx2 = 1) and (dy1=1)  then
            begin
              screen[y][x] := '└';
            end;
            if ((dy2 = 1) or ( dy2 = -1)) and ((screen[y][x] <> '┼')
               and (screen[y][x] <> '┴')  and (screen[y][x] <> '┬'))
            then
              screen[y][x] := '│';
          end;

     '┤': if dx2=1 then
          begin
            screen[y-dy1][x-dx1] := '┼';
            screen[y][x]:='─';
          end;

     '├': if dx2=-1 then
          begin
            screen[y-dy1][x-dx1] := '┼';
            screen[y][x] := '─';
          end;

     '┴': if dy2=1 then
          begin
            screen[y-dy1][x-dx1] := '┼';
            screen[y][x] := '│';
          end;

     '┬': if dy2=-1 then
          begin
            screen[y-dy1][x-dx1] := '┼';
            screen[y][x] := '│';
          end;

    '┼','└','┘','┌','┐' :
           begin
                if ((screen[y][x] ='│') and (abs ( dx2)=1))
                   or ((screen[y][x] ='─') and (abs (dy2)=1)) then
                   screen[y][x]:='┼'
                else
                begin
                if (dy2=1) or (dy2=-1) then
                   screen[y][x] := '│';
                if (dx2=1) or (dx2=-1) then
                   screen[y][x] := '─';
                if ((dx2=-1) and (dy1=-1)) or ((dy2=1) and (dx1=1)) then
                   screen[y][x] :=  '┐';
                if ((dx2=-1) and (dy1=1)) or  ((dy2=-1) and (dx1=1)) then
                   screen[y][x] := '┘';
                if ((dx2=1) and (dy1=-1)) or ((dy2=1) and (dx1=-1)) then
                   screen[y][x] := '┌';
                if ((dx2=1) and (dy1=1)) or ((dy2=-1) and (dx1=-1)) then
                   screen[y][x] := '└';
                end;
              end;

    '╟' : begin
              screen[y][x] := '─';
          end;
  end;
  end;
end;

procedure shema(  var CurrentSelected : integer );
var
  M2 : el_Name;       { Названия элементов}
  Ch1, Ch2 : char;
  what: integer;           { номер элемента в базе данных элементов }
  stop: boolean;
  max_num : integer;
  dx1, dy1 : integer; { Направление движения }
  i : integer;
  xx,yy : integer;
procedure Left;
begin
                   if x > 1 then
                   begin
                     x:=x-1; {  влево  }
                     if ShownX-1 < 1 then
                     begin
                       ShownX := 1;
                       ClrScr;
                       old_X:=x-ShownX+1;
                       old_Y:=y-ShownY+1;
                       ShowScreen(old_X,old_y,WinX2-WinX1,WinY2-WinY1,1,1);
                     end
                     else ShownX := ShownX-1;
                   end
                   else
                   x:=1;
end;

procedure Right;
begin
                   if x < MaxX then
                   begin
                     x:=x+1;   {  вправо }
                     if ShownX+1 > WinX2-WinX1 then
                     begin
                       ShownX := WinX2-WinX1;
                       ClrScr;
                       old_X:=x-ShownX+1;
                       old_Y:=y-ShownY+1;
                       ShowScreen(old_X,old_y,WinX2-WinX1,WinY2-WinY1,1,1);
                     end
                     else ShownX := ShownX + 1
                   end
                   else
                     x:=MaxX;
                 end;

procedure Down;
begin
                   if y < maxY then
                   begin
                     y:=y+1;   {  вниз  }
                     if ShownY+1 > WinY2-WinY1 then
                     begin
                       ShownY := WinY2-WinY1;
                       ClrScr;
                       old_X:=x-ShownX+1;
                       old_Y:=y-ShownY+1;
                       ShowScreen(old_X,old_y,WinX2-WinX1,WinY2-WinY1,1,1);
                     end
                     else ShownY := ShownY + 1;
                   end
                   else
                     y:=maxY;
end;

procedure Up;
begin
                   if y > 1 then
                   begin
                     y:=y-1;   {  вверх   }
                     if ShownY-1 < 1 then
                     begin
                       ShownY := 1;
                       ClrScr;
                       old_X:=x-ShownX+1;
                       old_Y:=y-ShownY+1;
                       ShowScreen(old_X,old_y,WinX2-WinX1,WinY2-WinY1,1,1);
                     end
                     else ShownY := ShownY - 1
                   end
                   else y:=1;
end;

begin
  window(1,1,80,25);
    cf(Fon, TxtCl);
    GotoXY(1, 24);
    write('':79);
    GotoXY(1, 24);
    write('< F10 > - Меню < ENTER > - новый элемент ',
          '<A>,<W>,<S>,<D> - соединение элементов');
    cf(TxtCl, Fon);
    window ( WinX1, WinY1, WinX2, WinY2);
    ClrScr;
  for i:=1 to  C_NUMELEM do
     M2[i] := element[i].name;
  dx1:=1;
  dy1:=0;
  ShowScreen(1,1,WinX2-WinX1,WinY2-WinY1,1,1);
  GotoXY(1,1);
  stop:=false;
  repeat
    
    ch1:=readkey;
    case ch1 of
      #97 :       { a }
           begin
             Connects( x, y, dx1, dy1, -1, 0);
             GotoXY(ShownX-dx1, ShownY-dy1);
             write(screen[y-dy1][x-dx1]);
             dx1:=-1; dy1:=0;
             GotoXY(ShownX, ShownY);
             write(screen[y][x]);
             Left;
           end;


      #115:       { s }
           begin
             Connects( x, y, dx1, dy1, 0, 1);
             GotoXY(ShownX-dx1, ShownY-dy1);
             write(screen[y-dy1][x-dx1]);
             dx1:=0;
             dy1:=1;
             GotoXY(ShownX, ShownY);
             write(screen[y][x]);
             Down;
           end;

      #100 :      { d }
            begin
              Connects(x, y, dx1, dy1, 1, 0);
              GotoXY(ShownX-dx1, ShownY-dy1);
              write(screen[y-dy1][x-dx1]);
              dx1:=1;
              dy1:=0;
              GotoXY(ShownX, ShownY);
              write(screen[y][x]);
              Right;
            end;

      #119:       { w }
           begin
             Connects( x, y, dx1, dy1, 0, -1 );
             GotoXY(ShownX-dx1, ShownY-dy1);
             write(screen[y-dy1][x-dx1]);
             dx1:=0;
             dy1:=-1;
             GotoXY(ShownX, ShownY);
             write(screen[y][x]);
             Up;
           end;
      #32:
          
            if pos(screen[y][x],'╢╟║╗╝╜╚═')=0 then
            begin
              screen[y][x]:=' ';
           {   GotoXY(x,y);}
              write(screen[y][x]);
            end;
      #0: begin
            Ch2:=readkey;
            case Ch2 of
            #60: begin
                   old_X:=x-ShownX+1;
                   old_Y:=y-ShownY+1;
                   xx:=x;
                   yy:=y;
                   scanNumber(xx,yy,Select);
                   ParamList(Select);
                   showscreen(old_X,old_Y,x2-x1+2,y2-y1+3,x1-1,y1-1);
                 end;
            #61: begin
                   old_X:=x-ShownX+1;
                   old_Y:=y-ShownY+1;
                   xx:=x;
                   yy:=y;
                   scanNumber(xx,yy,Select);
                   ParamDel(Select);
                   showscreen(old_X,old_Y,x2-x1+2,y2-y1+3,x1-1,y1-1);
                 end;
            #62: begin
                   DelEl(x,y);
                   ClrScr;
                   old_X:=x-ShownX+1;
                   old_Y:=y-ShownY+1;
                   ShowScreen(old_X,old_y,WinX2-WinX1,WinY2-WinY1,1,1);
                 end;
            #68: stop:=True;
            #75: Left;
            #77: Right;
            #80: Down;
            #72: Up;
            end;
          end;

      #13: begin
             el_VMenu(15,4,C_NUMELEM,M2,what);
             new(part[CurrentSelected]);
             part[CurrentSelected]^.whatIs:=@element[what];
             ClrScr;
             old_X:=x-ShownX+1;
             old_Y:=y-ShownY+1;
             ShowScreen(old_X,old_y,WinX2-WinX1,WinY2-WinY1,1,1);
             max_num := max ( element[what].num_in, element[what].num_out);
             if CheckFreePlace ( x, y, SizeEl, max_num+1) then
             begin
               putelement ( x, y, ShownX, ShownY, what, CurrentSelected);
               MoveEl( x, y, ShownX, ShownY, CurrentSelected, what );
               ClrScr;
               old_X:=x-ShownX+1;
               old_Y:=y-ShownY+1;
               ShowScreen(old_X,old_y,WinX2-WinX1,WinY2-WinY1,1,1);
               dx1:=1;
               dy1:=1;
             end;
           end;
    end;
    
    GotoXY ( ShownX, ShownY );
  until stop;
end;


  procedure WriteFile(FileName: string; CurrentSelected : integer);
  var
   f : text;
   i, j, mny, mxy : integer;
   stop : boolean;
  begin
    FileName:=fileName+'.sch';
    assign(f, FileName);
    rewrite( f );
    writeln(f,'section scheme');
    stop := false;
    i := 1;
    while (i <= maxY) and not stop do
    begin
      for j := 1 to maxX do
        if screen[i][j] <> ' ' then
        begin
          mny := i;
          stop := true;
        end;
      inc (i);
    end;

    stop := false;
    i := maxY;
    while (i >= mny) and not stop do
    begin
      for j := 1 to maxX do
        if screen[i][j] <> ' ' then
        begin
          mxy := i;
          stop := true;
        end;
      dec (i);
    end;

    for i := mny to mxy do
    begin
      for j:=1 to  maxX do
      write(f, screen[i][j]);
      writeln(f);
    end;

    writeln(f,'section end');
    writeln(f, 'section description');
    writeln(f, CurrentSelected-1:0, ' parts');
    for i := 1 to CurrentSelected-1 do
    begin
      write (f,i:0, ' ', part[i]^.whatIs^.name, ' is ', i:0);
      for j := 1 to part[i]^.whatIs^.num_par do
        write (f, ' ', part[i]^.par[j]);
      writeln(f,'');
    end;
    writeln(f, 'section end');
    close(f);
  end;
         { WriteFile }


procedure ReadFile(FileName: string; var CurrentSelected : integer);
  var
   f : text;
   i : integer;
   StRead : string;
  begin
    assign(f, FileName);
    {$I-}
    reset( f );
    {$I+}
    if IoResult<>0 then
    begin
       Frame(x1,y1,x2,y2);
       window(x1+1,y1+1,x2-1,y2-1);
       ClrScr;
       writeln('Файл не найден');
       writeln('Введите имя файла: ');
       readln ( FileName );
    end
    else
      readln(f,StRead);
      i:=1;
      while (pos('section end',StRead)=0) and (not (eof(f)))
             and (i<100) do
      begin
        readln(f,StRead);
        if  pos('section end',StRead)=0 then
           screen[i]:=StRead;
        i:=i+1;
      end;
    close(f);
  end;
  procedure ClrSubmenu;
  begin
    window(WinX1,WinY1,WinX2,WinY2);
    old_X:=x-ShownX+1;
    old_Y:=y-ShownY+1;
    showScreen( old_X, old_y, maxLen+4,
    maxKr+2,XVmenu-WinX1,4-WinY1);
  end;

var
  filename : string;
  fileNumber: integer;
  z: integer;
  t,t1,t2:string;
  xx,yy: integer;
label exit;

begin
  initElem;
  fileName := 'noname';
  Initwin  (1,1,80,25,Fon,TxtCl);
  InitScreen;
  CurrentSelected:=1;
  parseSET('Set collect file '+filename+'.res');
  x:=1;
  y:=1;
  ShownX:=1;
  ShownY:=1;
  FileNumber:=0;
  While True do
  begin
    NR[1]:='Scheme';
    NR[2]:='List';
    NR[3]:='Set';
    NR[4]:='Show';
    NR[5]:='Quit';
    GMenu(0,1,5,NR,Regime,XVmenu);
    case Regime of
      0: begin
           window(WinX1,WinY1,WinX2,WinY2);
           shema(CurrentSelected);
         end;


      1 : begin
            NR2[1]:=' New         ';
            NR2[2]:=' Save scheme ';
            NR2[3]:=' Save state  ';
            NR2[4]:=' Load        ';
            NR2[5]:=' Calculate   ';
            Vmenu( XVmenu,4, 5, NR2, SubRegime);
            case SubRegime of
            0: ClrSubMenu;

            1: begin
              Frame (WinX1-1,WinY1-1,WinX2+1,WinY2+1);
              if FileNumber>1 then
                FileNumber:=FileNumber-1;
              InitWin(WinX1,WinY1,WinX2,WinY2,Fon,TxtCl);
              InitScreen;
              CurrentSelected:=1;
              X:=1;
              y:=1;
              ShownX:=1;
              ShownY:=1;
              shema(CurrentSelected);
              FileNumber:=FileNumber+1;
              end;
            2 : begin
                Frame(x1,y1,x2,y2);
                window(x1+1,y1+1,x2-1,y2-1);
                ClrScr;
                writeln('   Введите имя файла: ');
                write('   ');
                readln ( FileName );
                ClrScr;
                parseSAVE('save state to '+filename+'.st');
                readln;
                window(WinX1,WinY1,WinX2,WinY2);
                old_X:=x-ShownX+1;
                old_Y:=y-ShownY+1;
                showScreen( old_X, old_y, x2-x1+2, y2-y1+2,x1-1,y1-2);
                window(1,1,80,25);
                WriteFile ( FileName, CurrentSelected );
               { if FileNumber>1 then
                begin
                   ScrClose;
                   FileNumber:=FileNumber-1;
                end;  }
                ClrSubMenu;
              end;
            3 : begin
                  Frame(x1,y1,x2,y2);
                  window(x1+1,y1+1,x2-1,y2-1);
                  ClrScr;
                  parseSAVE('Save state to '+filename+'.st');
                  window(WinX1,WinY1,WinX2,WinY2);
                  old_X:=x-ShownX+1;
                  old_Y:=y-ShownY+1;
                  showScreen( old_X, old_y, x2-x1+2, y2-y1+2,x1-1,y1-2);
                  window(1,1,80,25);
                  ClrSubMenu;
                end;
            4 : begin
                  Frame(x1,y1,x2,y2);
                  window(x1+1,y1+1,x2-1,y2-1);
                  ClrScr;
                  writeln('   Введите имя файла: ');
                  write('   ');
                  readln ( FileName );
                  ClrScr;
                  InitScreen;
                  LOADsch('Load picture from '+FileName+'.sch');
                  LOADsch('Load state from '+FileName+'.st');
                  writeln;
                  write('          Ok');
                  readln;
                  CurrentSelected:=lastpart+1;
                  window(1,1,80,25);
                  Frame (WinX1-1,WinY1-1,WinX2+1,WinY2+1);;
                  InitWin(WinX1,WinY1,WinX2,WinY2,Fon,TxtCl);
               {   if FileNumber>1 then
                  begin
                    ScrClose;
                    FileNumber:=FileNumber-1;
                  end;}
                  ShownX:=1;
                  ShownY:=1;
                  X:=1;
                  Y:=1;
                  shema(CurrentSelected);
            end;

            5: begin
                Frame(x1,y1,x2,y2);
                window(x1+1,y1+1,x2-1,y2-1);
                ClrScr;
                parseSET('Set collect file '+filename+'.res');
                parseCalculate('Calculate');
                writeln;
                writeln('           Ok    ');
                readln;
                window(WinX1,WinY1,WinX2,WinY2);
                old_X:=x-ShownX+1;
                old_Y:=y-ShownY+1;
                showScreen( old_X, old_y, x2-x1+2, y2-y1+2,x1-1,y1-2);
                window(1,1,80,25);
                ClrSubMenu;
               end;
            end;
          end;

      2 : begin
            NR2[1]:=' Time   ';
            NR2[2]:=' Parameter F2';
            NR2[3]:=' Collect chain ';
            Vmenu( XVmenu,4, 3, NR2, SubRegime);
            case SubRegime of
            0: ClrSubMenu;
            1: begin
                 Frame(x1,y1,x2,y2);
                 window(x1+1,y1+1,x2-1,y2-1);
                 ClrScr;
                 parseLIST('list time');
                 readln;
                 window(WinX1,WinY1,WinX2,WinY2);
                 old_X:=x-ShownX+1;
                 old_Y:=y-ShownY+1;
                 showScreen( old_X, old_y, x2-x1+2, y2-y1+2,x1-1,y1-2);
                 window(1,1,80,25);
                 ClrSubMenu;
               end;
            2: begin
                 window(WinX1,WinY1,WinX2,WinY2);
                 xx:=x;
                 yy:=y;
                 scanNumber(xx,yy,Select);
                 ParamList(Select);
                 old_X:=x-ShownX+1;
                 old_Y:=y-ShownY+1;
                 showscreen(old_X,old_Y,x2-x1+2,y2-y1+3,x1-1,y1-1);
                 window(1,1,80,25);
                 ClrSubMenu;
               end;
            3: begin
                 Frame(x1,y1,x2,y2);
                 window(x1+1,y1+1,x2-1,y2-1);
                 ClrScr;
                 parseLIST('list collect chain');
                 readln;
                 window(WinX1,WinY1,WinX2,WinY2);
                 old_X:=x-ShownX+1;
                 old_Y:=y-ShownY+1;
                 showScreen( old_X, old_y, x2-x1+2, y2-y1+2,x1-1,y1-2);
                 window(1,1,80,25);
                 ClrSubMenu;
               end;
            end;
         end;
      3 : begin
            NR2[1]:=' Time   ';
            NR2[2]:=' Parameter F3';
            NR2[3]:=' Collect chain ';
            Vmenu( XVmenu,4, 3, NR2, SubRegime);
            case SubRegime of
            0: ClrSubMenu;
            1: begin
                 Frame(x1,y1,x2,y2);
                 window(x1+1,y1+1,x2-1,y2-1);
                 ClrScr;
                 write(' Введите начальное время:');
                 readln(t);
                 write(' Введите конечное время:');
                 readln(t1);
                 write(' Введите шаг:');
                 readln(t2);
                 window(WinX1,WinY1,WinX2,WinY2);
                 old_X:=x-ShownX+1;
                 old_Y:=y-ShownY+1;
                 showScreen( old_X, old_y, x2-x1+2, y2-y1+2,x1-1,y1-2);
                 parseSET('Set time start '+t);
                 parseSET('Set time stop '+t1);
                 parseSET('Set time step '+t2);
                 window(1,1,80,25);
                 ClrSubMenu;
               end;
            3: begin
                 Frame(x1,y1,x2,y2);
                 window(x1+1,y1+1,x2-1,y2-1);
                 ClrScr;
                 write(' Введите номер элемента:');
                 readln(t);
                 parseSET('Set collect chain '+ t);
                 window(WinX1,WinY1,WinX2,WinY2);
                 old_X:=x-ShownX+1;
                 old_Y:=y-ShownY+1;
                 showScreen( old_X, old_y, x2-x1+2, y2-y1+2,x1-1,y1-2);
                 window(1,1,80,25);
                 ClrSubMenu;
               end;
            end;
          end;

      4: begin
           NR2[1]:=' Curve   ';
           NR2[2]:=' Service ';
           Vmenu( XVmenu,4, 2, NR2, SubRegime);
           case SubRegime of
           0: ClrSubMenu;
           1: begin
                parseSHOW ('Show curve');
                shema(CurrentSelected);
              end;
           2: begin
                parseSHOW ('Show service');
                shema(CurrentSelected);
              end;
           end;
         end;
      5 : goto exit;

    end;
    cf(Fon,TxtCl);
    window(1,1,80,25);
  end;
 exit:
  cf(white,black);
  clrscr;
  writeln ('Editor has gone');
end;

end.