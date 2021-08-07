-- Reference: https://github.com/Macaulay2/M2/blob/f0ce581750dfd94336883695d3552671410f32f5/M2/Macaulay2/tests/normal/engine-div.m2
TEST ///
R = ZZ[x]
f = i-> 7
L = lazySeries(R, f)
///

TEST ///
R = QQ[x]

f = i-> 7
L = lazySeries(R, f)

f = i-> 1/7
L = lazySeries(R, f)

f = 
///

TEST ///
R = ZZ/5[x]
h = i-> 7
lazySeries(R,h)
///



TEST ///
R = ZZ/5[x,y]
h = i-> 7
lazySeries(R,h)
///


TEST ///
R = ZZ/5[a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p]
h = i-> 7
lazySeries(R,h)
///