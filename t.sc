new part eds name 11
new part intg name 22
new part dif name 33
new part inv name 44
connect 11 out e with 1
set part 11 parameter a to 10.0000000000
set part 11 parameter f to 3.0000000000
set part 11 parameter phi to 0.0000000000
connect 22 in v with 1
connect 22 out w with 2
set part 22 parameter t to 02.0000000000
connect 33 in v with 2
connect 33 out w with 3
set part 33 parameter t to 03.0000000000
connect 44 in v with 3
connect 44 out w with 4
load state  from t.st
calculate for 3 and 1
show table
calculate for 3 parameter t of part 33 from 0.1 to 2 step 0.05 type int
show curve