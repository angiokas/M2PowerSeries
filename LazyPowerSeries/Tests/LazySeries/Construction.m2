testCases = {
  {ZZ[x], "i -> 5", 5 + 5*x + 5*x^2 + 5*x^3 + 5*x^4 + 5*x^5 + 5*x^6 + 5*x^7, 5, 6},
  {ZZ[x], "i -> 3*i", 0 + 3*x + 6*x^2 + 9*x^3 + 12*x^4 + 15*x^5 + 18*x^6 + 21*x^7, 4, 6},
  {ZZ[x], "i -> i^2", 0 + 1*x +4* x^2 + 9*x^3 + 16*x^4 + 25*x^5 + 36*x^6 + 49*x^7, 5, 6},
  {ZZ[x], "i -> 2^i", 1 + 2*x + 4*x^2 + 8*x^3 + 16*x^4 + 32*x^5 + 64*x^6 + 128*x^7, 6, 7}
}

for i from 0 to #testCases-1 do(
    R := (testCases#i)#0;
    functionName := (testCases#i)#1;

    print(concatenate("Test Case ",toString(i),", R=",toString(R),", ",functionName));
    print(checkLazySeriesCache(testCases#i));
)