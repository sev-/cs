unit header;

interface

const
  C_NUMPAR = 5;		{ max num parameters }
  C_MAXPARTS = 20;	{ max size of the scheme }
  C_NAMELEN = 10;
  C_MAXSTACK = 1000;    { max size of compile stack }
  C_MAXCHAINS = 100;     { max number of chains }
  C_MAXPOINTS = 200;
  C_NUMELEM = 14;	{ how many types of elements }

type
  nameT = string[C_NAMELEN];

  elementT = record
    my_num   : integer;
    name     : nameT;
    num_par  : integer;
    num_var  : integer;
    num_in   : integer;
    num_out  : integer;
    in_name  : array [1..C_NUMPAR] of nameT;
    out_name : array [1..C_NUMPAR] of nameT;
    par_name : array [1..C_NUMPAR] of nameT;
    var_name : array [1..C_NUMPAR] of nameT;
  end;
  pelementT = ^elementT;

  partT = record
    name    : nameT;
    in_wh   : array[1..C_NUMPAR] of integer;
    out_wh  : array[1..C_NUMPAR] of integer;
    par     : array[1..C_NUMPAR] of real;
    vars    : array[1..C_NUMPAR] of real;
    in_val  : array[1..C_NUMPAR] of real;
    out_val : array[1..C_NUMPAR] of real;
    whatIs  : pelementT;
  end;
  ppartT = ^partT;

  point = record
    x : real;
    y : real;
  end;
  points = array [1..C_MAXPOINTS] of point;


var
  element : array[1..C_NUMELEM] of elementT;
  part : array[1..C_MAXPARTS] of ppartT;
  lastPart : integer;		{ how many parts there are }

  screen : array[1..100] of string;	{ picture }
  scrY : integer;			{ picture vertical size }

  time : record
    start : real;
    stop : real;
    step : real
  end;

  numCon : array[1..C_MAXPARTS] of word;      { number of connections }

  incid : array[1..C_MAXPARTS, 1..C_MAXPARTS] of boolean; { incidence matrix }
  indincid : array[1..C_MAXPARTS] of word;	{ index incid }
  st : array[1..C_MAXSTACK] of integer;		{ stack }
  sthead : integer;				{ last of stack }

  collectChain : integer;		{ # of chain that will be calculated }
  collectPart : integer;
  chain : array[1..C_MAXCHAINS] of real;
  result : points;
  collectFile : string;

function max (i, j : integer) : integer;

implementation

function max (i, j : integer) : integer;
begin
  if i > j then
    max := i
  else
    max := j
end;


end.