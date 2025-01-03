-- Reference: https://github.com/Macaulay2/M2/blob/f0ce581750dfd94336883695d3552671410f32f5/M2/Macaulay2/tests/normal/engine-div.m2

-- Testing main constructor lazySeries(Ring, Function) method --
TEST /// -- 0 
R = ZZ[x]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

f = i-> 7
L = lazySeries(R, f)

g = i->i
L = lazySeries(R, g)
///

TEST /// -- 1
R = QQ[x]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

f = i-> 7
L = lazySeries(R, f)

f = i-> 1/7
L = lazySeries(R, f)

f = i-> 1/7
L = lazySeries(R, f)


///

TEST /// --2
R = RR[x]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

f = i-> sqrt i
L = lazySeries(R, f)

///

TEST /// --3
R = CC[x]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

f = j-> ii+j -- ii is the sqrt 2
L = lazySeries(R, f)
///


TEST /// --4
R = ZZ/5[x]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

h = i-> 7
lazySeries(R,h)
///


-- check 
TEST /// --5
R = ZZ/5[x,y]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

h = (i,j)-> 7
lazySeries(R,h)
///

TEST /// --6
R = ZZ/5[x,y,z]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

h = (i,j,k)-> i+j+k
lazySeries(R,h)
///

-- check 7
TEST /// -- 7
R = ZZ/5[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

h = (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)-> sum {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p}
lazySeries(R,h, ComputedDegree => 2, DisplayedDegree => 2)
1/0
///

-- check 8
TEST ///
R = ZZ/101[a,b,c]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

h = (i,j,k)-> i+j+k
L = lazySeries(R,h)
assert(truncate(1,L)== a+b+c)
///

-- Testing lazySeries(RingElement) method

-- check 9
TEST /// 
R = ZZ[x]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

P = 7*x^2+57*x^8-91*x^5
L = lazySeries(P)

assert(truncate(3,L) == 7*x^2 )
///

--check 10
TEST ///
R = ZZ/5[x,y,z]

s0 = zeroSeries(R);
s1 = oneSeries(R);

assert(s0.cache.displayedPolynomial == sub(0, R))
assert(s1.cache.displayedPolynomial == sub(1, R))

S = lazySeries(x^2+x*y+z^2+ 54+z)
assert()

///
