

-- PADICS
TEST /// -- 6. power series over a polynomial ring
R = ZZ

L = padics(7, R, i-> 1)
M = padics(7, R, i-> 6)
a = 7

assert(values((L + M).cache.valueList),)
L - M
K = L*M

L + a   
L - a
a - L
L*a
a*L

L^-1
assert((L*L^-1).cache.displayedPolynomial == 1)

M/L

///

TEST /// -- 7. 
R = ZZ

L = padics(101, R, i-> 1+i)
M = padics(101, R, i-> i+5)
a = 6

L + M
L - M
K = L*M

L + a
L - a
a - L
L*a
a*L

L^-1
assert((L*L^-1).cache.displayedPolynomial == 1)

M /L
///

TEST ///
R = ZZ[x]

L = padics(11, R, (i,j)->5)
M = padics(11, R,(i,j)-> 7)
a = 1
f = x^2+2*x

L + M
L - M
K = L*M

L + a
L - a
a - L
L*a
a*L

L + f
L - f
f - L
L*f
f*L

L^-1
assert((L*L^-1).cache.displayedPolynomial == 1)

M /L

///

TEST ///
R =  ZZ[x,y]

L = padics(3,R, (i,j,k)-> i^6+j+k^7)
M = padics(3,R, (i,j,k)-> i*j+k)
a = 2
f = x+y

L + M
L - M
K = L*M

L + a
L - a
a - L
L*a
a*L

L + f
L - f
f - L
L*f
f*L

L^-1
assert((L*L^-1).cache.displayedPolynomial == 1)

M /L

///

