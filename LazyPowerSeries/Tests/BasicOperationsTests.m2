TEST /// -- 0. power series over ZZ, single variable
R = ZZ[x]

L = lazySeries(R, i-> 1+i, DisplayedDegree => 5)
assert(L.cache.displayedPolynomial == 1 + 2*x + 3*x^2 + 4*x^3 + 5*x^4 + 6*x^5)
M = lazySeries(R, i-> i+5, DisplayedDegree => 5)
a = 7
f = x

assert( (L*f + a*M + 2).cache.displayedPolynomial == 37 + 43*x + 51*x^2 + 59*x^3 + 67*x^4 + 75*x^5)
assert( (L*f - a*M - 3).cache.displayedPolynomial == -38 - 41*x - 47*x^2 - 53*x^3 - 59*x^4 - 65*x^5)

assert((L*L^-1).cache.displayedPolynomial == 1)

assert( ((M/L)*L).cache.displayedPolynomial == M.cache.displayedPolynomial )
///


TEST ///-- 1. power series over QQ, single-variable
R = QQ[x]

L = lazySeries(R, i-> 1+i, DisplayedDegree => 5)
assert(L.cache.displayedPolynomial == 1 + 2*x + 3*x^2 + 4*x^3 + 5*x^4 + 6*x^5)
M = lazySeries(R, i-> i+5, DisplayedDegree => 5)
a = 3/5
f = x

assert( (L*f + a*M + 2).cache.displayedPolynomial == 5 + (23/5)*x + (31/5)*x^2 + (39/5)*x^3 + (47/5)*x^4 + 11*x^5)
assert( (L*f - a*M - 3/4).cache.displayedPolynomial == -15/4 - (13/5)*x - (11/5)*x^2 - (9/5)*x^3 - (7/5)*x^4 - x^5)

assert((L*L^-1).cache.displayedPolynomial == 1)

assert( ((M/L)*L).cache.displayedPolynomial == M.cache.displayedPolynomial )

h = lazySeries(1-x, DisplayedDegree => 5)
assert(truncate(4, 1/h) == 1 + x + x^2 + x^3 + x^4)
assert(truncate(6, 1/h) == 1 + x + x^2 + x^3 + x^4 + x^5 + x^6)
///

TEST ///--2. power series over QQ, multi-variable
R =  QQ[x,y,z]

L = lazySeries(R, (i,j,k)-> i^6+j+k^7, DisplayedDegree => 5)
assert(truncate(2, L) == 0 + x + y + z + 2*x*y + 2*x*z + 2*y*z + 64*x^2 + 2*y^2 + 128*z^2)
M = lazySeries(R, (i,j,k)-> i*j+k, DisplayedDegree => 5)
f = 3/5*L + 2/3

assert(((f)*f^-1).cache.displayedPolynomial == 1)

assert((f*M / f ).cache.displayedPolynomial == M.cache.displayedPolynomial)
///

TEST ///-- 3. power series of prime field, multi-variable
R =  ZZ/101[x,y,z]

L = lazySeries(R, (i,j,k)-> 105*i^6+9*j+245*k^7+3)
M = lazySeries(R, (i,j,k)-> i*j+k)
a = 5

L + M
L - M
K = L*M

L + a
L - a
a - L
L*a
a*L

assert(((L+a)*(L+a)^-1).cache.displayedPolynomial == 1)

assert(truncate(6, L * M * inverse(L)) == truncate(6, M))
///



TEST /// -- 4. changing degrees
R = ZZ[x]
L = lazySeries(R, i-> 2, DisplayedDegree => 7, ComputedDegree=>7)

changeDegree(L, 10)
assert(L.cache.displayedPolynomial == 2+2*x+2*x^2+2*x^3+2*x^4+2*x^5+2*x^6+2*x^7+2*x^8+2*x^9+2*x^10)

changeDegree(L, 4)
assert(L.cache.displayedPolynomial == 2+2*x+2*x^2+2*x^3+2*x^4)
assert(L.cache.computedPolynomial == 2+2*x+2*x^2+2*x^3+2*x^4+2*x^5+2*x^6+2*x^7+2*x^8+2*x^9+2*x^10)
///

TEST /// -- 5. power series over a polynomial ring
A = QQ[a,b]
R = A[x,y]
L = lazySeries(R, (i,j) -> i + a^i + b^(i+j+1))
assert(not isUnit L)
assert(truncate(2, L) == (0 + 1 + b) + (1 + a + b^2)*x + (0 + 1 + b^2)*y + (2 + a^2 + b^3)*x^2 + (1 + a + b^3)*x*y + (0 + 1 + b^3)*y^2 )
M = L - sub(b,R)
assert(isUnit M)
assert(truncate(5, M*(inverse M)) == 1)
///



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

