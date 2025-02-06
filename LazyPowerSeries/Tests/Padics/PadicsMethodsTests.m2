-- Testing PadicSeries constructors
--USING BASIC RINGS
TEST ///
R = ZZ
p = 5
f = i-> -1
padics(R, p, f)
///

TEST ///
R = ZZ[x,y,z]
p = 5
f = i-> i
padics(R, p, f)

///

TEST ///
R = RR

///

TEST ///
R = CC

///

-- USING POLYNOMIAL RINGS
TEST ///
R = ZZ[x]
p = 5
f = i-> i
padics(R, p, f)

g = 5
padics(ZZ, RingElement)
///

TEST ///
R = QQ[x,y]

///

TEST ///
R = RR[x,y,z]

///

TEST ///
R = CC[a,...,z]


///
-- USING QUOTIENT RINGS






-- Testing Basic operations





-- Testing Inverses