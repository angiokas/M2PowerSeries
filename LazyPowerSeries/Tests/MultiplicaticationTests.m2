TEST ///
R = ZZ[x]
L = lazySeries(R, i-> i)
M = lazySeries(R, i-> i+5)
K = L * M
-- because default degree for a LazySeries is 3, so baybe this test shouldn't be the best
assert(K.cache.displayedPolynomial == 24*x^6+37*x^5+40*x^4+34*x^3+16*x^2+5*x )
///