
-- truncate
TEST ///
R = ZZ[x]
f = i->7
deg = 5

P = calculatePolynomial(deg,R,f)
truncate(5, P)
///
-- testing maximumsList
TEST ///
k = {{1,3},{2,5},{3,4},{-6,8}}
assert(maximumsList(k) == {3,8})

k = {{1,3,8},{2,5,-54},{3,4,99},{-6,8,7}}
assert((maximumsList(k) == {3,8,99}))
///
-- testing toMonomial
TEST ///
R = ZZ[x]
assert(toMonomial({3}, R) == x^3)
///




--
TEST ///
n = 1+4*5+3*5^2+4*5^3
toAdics(p, n)


///