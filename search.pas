unit search;

interface

function searchElement (s : string) : integer;	{ returns # el name }
function searchOUT (num : integer; s : string) : integer;{ returns #el's OUT }
function searchIN (num : integer; s : string) : integer;{ returns #el's IN }
function searchPart (s : string) : integer;	{ returns # el name }
function searchParameter (num : integer; s : string) : integer;
function searchVar (num : integer; s : string) : integer;

implementation

uses header;

function searchElement (s : string) : integer;	{ returns # el name }
var i : integer;
begin
  searchElement := 0;
  i := 1;

  while (i <= C_NUMELEM) and (element[i].name <> s) do
    inc (i);

  if i <= C_NUMELEM then
    searchElement := i;
end;	{ searchElement }

function searchOUT (num : integer; s : string) : integer;{ returns #el's OUT }
var i : integer;
    x : integer;
    b : integer;
begin
  searchOUT := 0;
  i := 1;

  with part[num]^.whatIs^ do
    while (i <= num_out) and (out_name[i] <> s) do
      inc (i);

  if i <= part[num]^.whatIs^.num_out then
    searchOUT := i
  else
  begin
    val (s, b, x);
    if (x = 1) or (b > part[num]^.whatIs^.num_out) then
      searchOUT := 0
    else
      searchOUT := b;
  end
end;	{ searchOUT }

function searchIN (num : integer; s : string) : integer;{ returns #el's IN }
var i : integer;
    x : integer;
    b : integer;
begin
  searchIN := 0;
  i := 1;

  with part[num]^.whatIs^ do
    while (i <= num_in) and (in_name[i] <> s) do
      inc (i);

  if i <= part[num]^.whatIs^.num_in then
    searchIN := i
  else
  begin
    val (s, b, x);
    if (x = 1) or (b > part[num]^.whatIs^.num_in) then
      searchIN := 0
    else
      searchIN := b;
  end
end;	{ searchIN }

function searchPart (s : string) : integer;	{ returns # el name }
var i : integer;
begin
  searchPart := 0;
  i := 1;

  while (i <= lastPart) and (part[i]^.name <> s) do
    inc (i);
  if i <= lastPart then
    searchPart := i;
end;	{ searchPart }

function searchParameter (num : integer; s : string) : integer;
var i : integer;
    x : integer;
    b : integer;
begin
  searchParameter := 0;
  i := 1;

  with part[num]^.whatIs^ do
    while (i <= num_par) and (par_name[i] <> s) do
      inc (i);
  if i <= part[num]^.whatIs^.num_par then
    searchParameter := i
  else
  begin
    val (s, b, x);
    if (x = 1) or (b > part[num]^.whatIs^.num_par) then
      searchParameter := 0
    else
      searchParameter := b;
  end
end;	{ searchParameter }

function searchVar (num : integer; s : string) : integer;
var i : integer;
    x : integer;
    b : integer;
begin
  searchVar := 0;
  i := 1;

  with part[num]^.whatIs^ do
    while (i <= num_var) and (var_name[i] <> s) do
      inc (i);
  if i <= part[num]^.whatIs^.num_var then
    searchVar := i
  else
  begin
    val (s, b, x);
    if (x = 1) or (b > part[num]^.whatIs^.num_var) then
      searchVar := 0
    else
      searchVar := b;
  end
end;	{ searchVar }


end.