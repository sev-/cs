unit incide;

interface
procedure incident;

implementation
uses header;

procedure incident;

  procedure optimIncid;
  var
    i, j, num : integer;
    x : integer;
    max, nmax : integer;
  label loop1;
  begin
    for i := 1 to lastPart do
      indincid[i] := i;

    for num := 1 to lastPart do
    begin
      for i := num to lastPart do
        if numCon[indincid[i]] = 0 then
        begin
          x := indincid[i];
          indincid[i] := indincid[num];
          indincid[num] := x;
          goto loop1
        end;

      max := 1000;
      nmax := 0;
      for j := num to lastPart do
        for i := 1 to lastPart do
          if incid[indincid[i], indincid[j]] and (i < max) then
          begin
            max := i;
            nmax := j
          end;
      x := indincid[nmax];
      indincid[nmax] := indincid[num];
      indincid[num] := x;
      
  loop1:
    end
  end;   { optimIncid }
  
var
  i, j, k, l : integer;
begin
  for i := 1 to lastPart do
  begin
    numCon[i] := 0;
    for j := 1 to lastPart do
      incid[i, j] := false
  end;

  for i := 1 to lastPart do
  begin
    j := 1;
    while part[i]^.out_wh[j] <> -1 do
    begin
      for k := 1 to lastPart do
      begin
        l := 1;
        while part[k]^.in_wh[l] <> -1 do
        begin
          if part[i]^.out_wh[j] = part[k]^.in_wh[l] then
            if incid[i, k] then
              writeln ('Error ')
            else
            begin
              inc (numCon[k]);
              incid[i, k] := true
            end;
          inc (l)
        end
      end;
      inc (j)
    end
  end;
  optimIncid
end;      { incident }

end.