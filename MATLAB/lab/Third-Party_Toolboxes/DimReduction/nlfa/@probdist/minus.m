function c = minus(a,b)
% MINUS subtract probability distributions

% Copyright (C) 1999-2000 Xavier Giannakopoulus, Antti Honkela,
% and Harri Valpola.
%
% This package comes with ABSOLUTELY NO WARRANTY; for details
% see License.txt in the program package.  This is free software,
% and you are welcome to redistribute it under certain conditions;
% see License.txt for details.

if (~isa(a, 'probdist'))
  a = probdist(a);
end
if (~isa(b, 'probdist'))
  b = probdist(b);
end
c = probdist(a.expection-b.expection, a.variance+b.variance);