TEST ///
R = ZZ[x]

L = lazySeries(R, i-> 1+i)
M = lazySeries(R, i-> i+5)
a = 7
f = x

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

(M/L)*L
///


TEST ///
R = QQ[x,y]

L = lazySeries(R, (i,j)->(5/2))
M = lazySeries(R,(i,j)-> 7)
a = 1/2
f = 1+x+y

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
R =  QQ[x,y,z]

L = lazySeries(R, (i,j,k)-> i^6+j+k^7)
M = lazySeries(R, (i,j,k)-> i*j+k)
f = L + 2/3
a = 3/5

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

assert(((f)*f^-1).cache.displayedPolynomial == 1)

assert((f*M / f ).cache.displayedPolynomial - M.cache.displayedPolynomial == 0)
///

TEST ///
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

(L+a)^-1
assert(((L+a)*(L+a)^-1).cache.displayedPolynomial == 1)

M /L
///



--
TEST ///
R = ZZ[x]
L = lazySeries(R, i-> 2, DisplayedDegree => 7, ComputedDegree=>7)

changeDegree(L, 10)
assert(L.cache.displayedPolynomial == 2+2*x+2*x^2+2*x^3+2*x^4+2*x^5+2*x^6+2*x^7+2*x^8+2*x^9+2*x^10)

changeDegree(L, 4)
assert(L.cache.displayedPolynomial == 2+2*x+2*x^2+2*x^3+2*x^4)
///

-- PADICS
TEST ///
R = ZZ

L = padics(2, R, i-> 1+i)
M = padics(2, R, i-> i+5)
a = 7

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

