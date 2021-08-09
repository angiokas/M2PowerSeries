-- Addition testing
TEST ///
R = ZZ[x]

L = lazySeries(R, i->5)
M = lazySeries(R,i-> 7)
L + M

///


TEST ///
R = ZZ[x,y]

L = lazySeries(R, (i,j)->5)
M = lazySeries(R,(i,j)-> 7)
L + M
///

TEST ///
R =  QQ[x,y,z]

L = lazySeries(R, (i,j,k)-> i^6+j+k^7)
M = lazySeries(R, (i,j,k)-> i*j+k)

L + M
///

TEST ///
R =  ZZ/101[x,y,z]

L = lazySeries(R, (i,j,k)-> 105*i^6+9*j+245*k^7)
M = lazySeries(R, (i,j,k)-> i*j+k)

L + M
///

-- Substraction testing


