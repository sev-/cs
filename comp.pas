unit comp;

interface

procedure compile (what : integer);

implementation

uses header, incide;

procedure compile (what : integer);

  function tryTo (what : integer) : boolean;    { search if loop }
  var
    i, j, k : integer;
  begin
    tryTo := false;
    i := 1;

    while (i < sthead) and (st[i] <> what) do
      inc (i);

    if i < sthead then
    begin
      tryTo := true;
      k := sthead - i;
      for i := 1 to k do
      begin
        st[sthead] := st[sthead-k];
        inc (sthead);
      end;
    end
  end;

  procedure lookup (what : integer);		{ makes sequent }
  var
    i : integer;
  label loop1, loop2;
  begin
  loop1:
    st[sthead] := indincid[what];
    inc (sthead);

    if numCon[indincid[what]] > 0 then
    begin
      if ((numCon[indincid[what]] = 1) and
		(not incid[indincid[what], indincid[what]])) or
         ((numCon[indincid[what]] = 2) and
		(incid[indincid[what], indincid[what]])) then
      begin
        if incid[indincid[what], indincid[what]] then
        begin
          st[sthead] := indincid[what];
          inc (sthead);
        end;

        i := 1;
        while (not incid[indincid[i], indincid[what]]) or (i = what)  do
          inc (i);
        if tryTo (indincid[i]) then
          goto loop2;
        what := i;
        goto loop1
      end;
      if incid[indincid[what], indincid[what]] then
      begin
        st[sthead] := indincid[what];
        inc (sthead);
      end;

      for i := 1 to lastPart do
        if i <> what then
          if incid[indincid[i], indincid[what]] then
            if not tryTo (indincid[i]) then
              lookup (i)
    end;
loop2:
  end;   { lookup }

var
  i, j, x : integer;
begin   { compile }
  incident;

  sthead := 1;

  i := 1;
  while indincid[i] <> what do
    inc (i);
  lookup (i);

  for i := 1 to lastPart do
  begin
    x := -1;
    for j := sthead-1 downto 1 do
      if st[j] = i then
      begin
        st[j] := -i;
        x := j
      end;
    if x > -1 then
      st[x] := i
  end
end;

end.