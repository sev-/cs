unit base;

interface

procedure doElement (which : integer; t : real);
procedure initElem;
procedure initPart (num : integer);
procedure initScheme;

implementation
uses header;

procedure initElem;
var i : integer;
begin
  for i := 1 to C_NUMELEM do
    element[i].my_num := i;

  with element[1] do
  begin
    name := 'pro';
    num_in := 1;
    num_out := 1;
    num_par := 3;
    num_var := 0;
    in_name[1] := 'v';
    out_name[1] := 'w';
    par_name[1] := 'k';
    par_name[2] := 'max';
    par_name[3] := 'min';
  end;
  with element[2] do
  begin
    name := 'ogr';
    num_in := 1;
    num_out := 1;
    num_par := 2;
    num_var := 0;
    in_name[1] := 'v';
    out_name[1] := 'w';
    par_name[1] := 'max';
    par_name[2] := 'min';
  end;
  with element[3] do
  begin
    name := 'intg';
    num_in := 1;
    num_out := 1;
    num_par := 1;
    num_var := 3;
    in_name[1] := 'v';
    out_name[1] := 'w';
    par_name[1] := 't';
    var_name[1] := 'Si';
    var_name[2] := 'Ti';
    var_name[3] := 'dVi';
  end;
  with element[4] do
  begin
    name := 'dif';
    num_in := 1;
    num_out := 1;
    num_par := 1;
    num_var := 2;
    in_name[1] := 'v';
    out_name[1] := 'w';
    par_name[1] := 't';
    var_name[1] := 'Ti';
    var_name[2] := 'Vi';
  end;
  with element[5] do
  begin
    name := 'inv';
    num_in := 1;
    num_out := 1;
    num_par := 0;
    num_var := 0;
    in_name[1] := 'v';
    out_name[1] := 'w';
  end;
  with element[6] do
  begin
    name := 'eds';
    num_in := 0;
    num_out := 1;
    num_par := 3;
    num_var := 0;
    out_name[1] := 'e';
    par_name[1] := 'a';
    par_name[2] := 'f';
    par_name[3] := 'phi';
  end;
  with element[7] do
  begin
    name := 'edap';
    num_in := 0;
    num_out := 1;
    num_par := 4;
    num_var := 0;
    out_name[1] := 'e';
    par_name[1] := 'a';
    par_name[2] := 'phi';
    par_name[3] := 'k1';
    par_name[4] := 'k2'
  end;
  with element[8] do
  begin
    name := 'dpol';
    num_in := 1;
    num_out := 1;
    num_par := 1;
    num_var := 0;
    in_name[1] := 'v';
    out_name[1] := 'w';
    par_name[1] := 'a';
  end;
  with element[9] do
  begin
    name := 'sum';
    num_in := 2;
    num_out := 1;
    num_par := 0;
    num_var := 0;
    in_name[1] := 'v1';
    in_name[2] := 'v2';
    out_name[1] := 'w';
  end;
  with element[10] do
  begin
    name := 'dext';
    num_in := 1;
    num_out := 2;
    num_par := 1;
    num_var := 4;
    in_name[1] := 's';
    out_name[1] := 'imp';
    out_name[2] := 'e';
    par_name[1] := 'k';
    var_name[1] := 'dV';
    var_name[2] := 'Ti';
    var_name[3] := 'Vi';
    var_name[4] := 'e';
  end;
  with element[11] do
  begin
    name := 'accum';
    num_in := 0;
    num_out := 0;
    num_par := 0;
    num_var := 0;
  end;
  with element[12] do
  begin
    name := 'begin';
    num_in := 0;
    num_out := 1;
    num_par := 1;
    num_var := 0;
    out_name[1] := 'w';
    par_name[1] := 'k'
  end;
  with element[13] do
  begin
    name := 'apo';
    num_in := 1;
    num_out := 1;
    num_par := 4;
    num_var := 4;
    in_name[1] := 'v';
    out_name[1] := 'w';
    par_name[1] := 'k';
    par_name[2] := 'max';
    par_name[3] := 'min';
    par_name[4] := 't';
    var_name[1] := 'Si';
    var_name[2] := 'Ti';
    var_name[3] := 'ddVi';
    var_name[4] := 'Wi';
  end;
  with element[14] do
  begin
    name := 'into';
    num_in := 1;
    num_out := 1;
    num_par := 3;
    num_var := 4;
    in_name[1] := 'v';
    out_name[1] := 'w';
    par_name[1] := 't';
    par_name[2] := 'max';
    par_name[3] := 'min';
    var_name[1] := 'Si';
    var_name[2] := 'Ti';
    var_name[3] := 'dVi';
    var_name[4] := 'Wi';
  end;
  with element[15] do
  begin
    name := 'prointo';
    num_in := 1;
    num_out := 1;
    num_par := 4;
    num_var := 4;
    in_name[1] := 'v';
    out_name[1] := 'w';
    par_name[1] := 'k';
    par_name[2] := 'max';
    par_name[3] := 'min';
    par_name[4] := 't';
    var_name[1] := 'Si';
    var_name[2] := 'Ti';
    var_name[3] := 'dVi';
    var_name[4] := 'Wi';
  end;
end;

procedure propor_restrictor (t : real; el : ppartT; f : boolean);
begin                   { num_in: 1 num_out: 1 }
  with el^ do
  begin
  { par[3] = MIN for restrictor
    par[2] = MAX for restrictor
    par[1] = K for amplifier }
    out_val[1] := par[1] * in_val[1];
    if out_val[1] < par[3] then
      out_val[1] := par[3];
    if out_val[1] > par[2] then
      out_val[1] := par[2];
  end
end;

procedure restrictor (t : real; el : ppartT; f : boolean);
begin                           { num_in: 1 num_out: 1 }
  with el^ do
  begin
    out_val[1] := in_val[1];
    if in_val[1] > par[1] then  { > MAX }
      out_val[1] := par[1];
    if in_val[1] < par[2] then  { < MIN }
      out_val[1] := par[2];
  end
end;

procedure integrator (t : real; el : ppartT; f : boolean);
begin                                   { num_in: 1 num_out: 1 }
  { vars[1] = S(i-1)  previous integral
    vars[2] = t(i-1)  previous time
    vars[3] = v'(i-1) previous value for integral
    par[1] = T for integral }
  with el^ do
  begin
    if par[1] = 0 then
      out_val[1] := 0
    else
      out_val[1] := vars[1] + (in_val[1] + vars[3]) * (t - vars[2])
                                                                / 2 / par[1];
    if out_val[1] > 1000 then
      out_val[1] := 1000;
    if f then
    begin
      vars[1] := out_val[1];    { S(i-1) }
      vars[2] := t;             { t(i-1) }
      vars[3] := in_val[1];     { v(i-1) }
    end
  end
end;

procedure differ (t : real; el : ppartT; f : boolean);
                        { num_in: 1 num_out: 1 }
begin
  with el^ do
  begin
    if (t - vars[2]) = 0 then
      out_val[1] := 0
    else
      out_val[1] := (in_val[1] - vars[3]) / (t - vars[2]) * par[1];
    if f then
    begin
      vars[2] := t;               { t(i-1) }
      vars[3] := in_val[1];       { v(i-1) }
    end
  end
end;

procedure invertor (t : real; el : ppartT; f : boolean);
                      { num_in: 1 num_out: 1 }
begin
  with el^ do
  begin
    out_val[1] := -in_val[1];
  end
end;

procedure sine (t : real; el : ppartT; f : boolean);
                      { num_in: 1 num_out: 1 }
begin
  with el^ do
  begin
  { par[1] = A амплитуда
    par[2] = f
    par[3] = начальный угол }

    out_val[1] := par[1] * sin(2 * Pi * par[2] * t + par[3]);
  end
end;

procedure operiod (t : real; el : ppartT; f : boolean);
                       { num_in: 1 num_out: 1 }
begin
  with el^ do
  begin
  { par[1] = A амплитуда
    par[2] = угол
    par[3] = k1
    par[4] = k2 }

    out_val[1] := par[1] * (par[3] - par[4] * exp(par[2] * t) );
  end
end;

procedure polar (t : real; el : ppartT; f : boolean);
begin
  with el^ do
  begin
  { par[1] = A }

    if in_val[1] > 0 then
      out_val[1] := par[1]
    else
      out_val[1] := -1 * par[1];
  end
end;

procedure summator (t : real; el : ppartT; f : boolean);
                          { num_in: 1 num_out: 1 }
begin
  with el^ do
    out_val[1] := in_val[2] + in_val[1];
end;

procedure detector (t : real; el : ppartT; f : boolean);
var dv : real;
begin
  with el^ do
  begin
  { par[1] = K
    vars[1] = V'
    vars[2] = t(i-1)
    vars[3] = v(i-1)
    vars[4] = E
    out_val[1] = IMP
    out_val[2] = E  }

    if (t - vars[2]) = 0 then
      dv := 0
    else
      dv := (in_val[1] - vars[3]) / (t - vars[2]) ;
    if f then
    begin
      vars[1] := dv;
      vars[2] := t;               { t(i-1) }
      vars[3] := in_val[1];       { v(i-1) }
    end;

    if dv = 0 then
    begin
      out_val[1]:=par[1] * abs(in_val[1]);
      if vars[4] > 0 then
        out_val[2]:=0
      else
        out_val[2]:=par[1]* in_val[1];
    end
    else
    begin
      out_val[1]:=0;
      out_val[2]:=vars[4];
    end;

    if f then
      vars[4]:=out_val[2];
  end
end;

procedure beg (t : real; el : ppartT; f: boolean);
begin                 { num_in:0 num_out:1 }
  with el^ do
  begin
    out_val[1] := par[1];
  end;
end;

procedure operiodicel_restrictor ( t : real; el : ppartT; f : boolean );
                       { num_in: 1 num_out: 1 }
var vv, integ, vvv  : real;
begin
  with el^ do
  begin
  { vars[1] = S(i-1)  previous integral
    vars[2] = t(i-1)  previous time
    vars[3] = v''(i-1) previous value for integral
    vars[4] = w(i-1)  previous output
    par[1] = K
    par[2] = MAX for ogr
    par[3] = MIN for ogr
    par[4] = T for integral }

    vv := in_val[1]*par[1] - vars[1]; { v' }

        { and }
    if ( (vars[1] > par[2]) and (vv > 0) ) or
       ( (vars[1] < par[3]) and (vv < 0) ) then
      vvv := 0          { v'' }
    else
      vvv := vv;

        { integrator }
    if par[4] = 0 then
      integ := 0
    else
      integ := vars[1] + (vvv + vars[3]) * (t - vars[2]) / par[4];

    if integ > 1000 then
      integ := 1000;

    if f then
    begin
      vars[1] := integ;   { S(i-1) }
      vars[2] := t;       { t(i-1) }
      vars[3] := vvv;     { v''(i-1) }
    end;

        { restrictor }
    out_val[1] := integ;
    if out_val[1] < par[3] then
      out_val[1] := par[3];
    if out_val[1] > par[2] then
      out_val[1] := par[2];
    if f then
      vars[4] := out_val[1];
  end
end;

procedure integrator_restrictor (t : real; el : ppartT; f : boolean);
var vv, integ : real;
begin                           { num_in: 1 num_out: 1 }
  with el^ do
  begin
  { vars[1] = S(i-1)  previous integral
    vars[2] = t(i-1)  previous time
    vars[3] = v'(i-1) previous value for integral
    vars[4] = w(i-1)  previous output
    par[1] = T for integral
    par[2] = MAX for restrictor
    par[3] = MIN for restrictor }
        { and }
    if ((vars[4] = par[3]) and (in_val[1] < 0)) or ((vars[4] = par[2])
                        and (in_val[1] > 0)) then
      vv := 0           { v'}
    else
      vv := in_val[1];
        { integrator }
    if par[1] = 0 then
      integ := 0
    else
      integ := vars[1] + (vv + vars[3]) * (t - vars[2]) / 2 / par[1];

    if integ > 1000 then
      integ := 1000;

    if f then
    begin
      vars[1] := integ; { S(i-1) }
      vars[2] := t;     { t(i-1) }
      vars[3] := vv;    { v'(i-1) }
    end;
        { restrictor }
    out_val[1] := integ;
    if out_val[1] < par[3] then
      out_val[1] := par[3];
    if out_val[1] > par[2] then
      out_val[1] := par[2];
    if f then
      vars[4] := out_val[1];
  end
end;

procedure propor_integrator_restrictor (t : real; el : ppartT; f : boolean);
var vv, integ : real;
begin                           { num_in: 1 num_out: 1 }
  with el^ do
  begin
  { vars[1] = S(i-1)  previous integral
    vars[2] = t(i-1)  previous time
    vars[3] = v'(i-1) previous value for integral
    vars[4] = w(i-1)  previous output
    par[1] = K for amplifier
    par[2] = MAX for restrictor
    par[3] = MIN for restrictor
    par[4] = T for integral }
        { and }
    if ((vars[4] = par[3]) and (in_val[1] < 0)) or ((vars[4] = par[2])
                        and (in_val[1] > 0)) then
      vv := 0           { v'}
    else
      vv := in_val[1];
        { integrator }
    if par[4] = 0 then
      integ := 0
    else
      integ := vars[1] + (vv + vars[3]) * (t - vars[2]) / 2 / par[4];
    if integ > 1000 then
      integ := 1000;

    if f then
    begin
      vars[1] := integ; { S(i-1) }
      vars[2] := t;     { t(i-1) }
      vars[3] := vv;    { v'(i-1) }
    end;
        { summator }
    out_val[1] := integ + par[1] * in_val[1];   { w'}
        { restrictor }
    if out_val[1] < par[3] then
      out_val[1] := par[3];
    if out_val[1] > par[2] then
      out_val[1] := par[2];
    if f then
      vars[4] := out_val[1];
  end
end;

procedure doElement (which : integer; t : real);
var f : boolean;
    c : integer;
begin
  if which < 0 then
  begin
    c := -which;
    f := false
  end
  else
  begin
    c := which;
    f := true
  end;

  case part[c]^.whatIs^.my_num of
    1:  propor_restrictor (t, part[c], f);
    2:  restrictor (t, part[c], f);
    3:  integrator (t, part[c], f);
    4:  differ (t, part[c], f);
    5:  invertor (t, part[c], f);
    6:  sine (t, part[c], f);
    7:  operiod (t, part[c], f);
    8:  polar (t, part[c], f);
    9:  summator (t, part[c], f);
    10: detector (t, part[c], f);
    11: ;
    12: beg (t, part[c], f);
    13: operiodicel_restrictor (t, part[c], f);
    14: integrator_restrictor (t, part[c], f);
    15: propor_integrator_restrictor (t, part[c], f);
  end;
end;

procedure initPart (num : integer);
var
  i : integer;
begin
  with part[num]^ do
  for i := 1 to C_NUMPAR do
  begin
    in_wh[i] := -1;
    out_wh[i] := -1;
    par[i] := 0;
    vars[i] := 0;
    in_val[i] := 0;
    out_val[i] := 0;
  end;
end;

procedure initScheme;
begin
  scrY := 0;
  lastPart := 0;
  time.start := 0;
  time.stop := 0;
  time.step := 0;
  collectChain := -1;
end;


end.
