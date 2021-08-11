-- Reference: https://github.com/Macaulay2/M2/blob/f0ce581750dfd94336883695d3552671410f32f5/M2/Macaulay2/tests/normal/engine-div.m2

-- Testing main constructor lazySeries(Ring, Function) method --
TEST ///
R = ZZ[x]

f = i-> 7
L = lazySeries(R, f)

g = i->i
L = lazySeries(R, g)
///

TEST ///
R = QQ[x]

f = i-> 7
L = lazySeries(R, f)

f = i-> 1/7
L = lazySeries(R, f)

///

TEST ///
R = RR[x]
f = i-> sqrt i
L = lazySeries(R, f)

///

TEST ///
R = CC[x]
f = j-> ii+j -- ii is the sqrt 2
L = lazySeries(R, f)
///


TEST ///
R = ZZ/5[x]

h = i-> 7
lazySeries(R,h)
///



TEST ///
R = ZZ/5[x,y]

h = (i,j)-> 7
lazySeries(R,h)
///

TEST ///
R = ZZ/5[x,y,z] -- 3-variable

h = (i,j,k)-> i+j+k
lazySeries(R,h)
///

TEST ///
R = ZZ/5[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p]
h = (a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)-> sum {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p}
lazySeries(R,h)
///

TEST /// --Multi-graded ring test
R = ZZ/101[a,b,c,Degrees=>{{1,2},{2,1},{1,0}}]

h = (i,j,k)-> i+j+k
lazySeries(R,h)
///

-- Testing lazySeries(RingElement) method

-- check 9
TEST /// 
R = ZZ[x]
P = 7*x^2+57*x^8-91*x^5

L = lazySeries(P)
///

--check 10
TEST ///
R = ZZ/5[x,y,z]
S = lazySeries(x^2+x*y+z^2+ 54+z)


///
