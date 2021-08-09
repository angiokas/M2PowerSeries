TEST ///
R = ZZ[x,y]
f = (i,j)-> 5
L = lazySeries(R, f)

assert(coefficient({{1, 2}, {4, 5}}, L), {5, 5})
assert(coefficient({1, 2}, L), {5})
///
