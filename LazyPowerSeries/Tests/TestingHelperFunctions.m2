
-*
Example config file:
configs = {
Seriesring => ZZ
SeriesFunction => 
ExpectedPoly => x^5+7*x^4+6
DisplayedDegree =>6
ComputedDegree =>8
}
*-
checkLazySeriesCache = method()
checkLazySeriesCache(List) := configs -> (
  -- Extract values from the HashTable
  R := configs#0;  -- Ring you want to use for the series
  functionName := configs#1;  -- Function you want to use for the series
  try(
    f := value functionName;
  )  
  else (
    error("Invalid function.");
  );
  P := configs#2;  -- Expected polynomial that was calculated manually
  dispDeg := configs#3;  -- Display degree you want to test
  compDeg := configs#4;  -- Computed degree you want to test

  L := lazySeries(R, f, DisplayedDegree => dispDeg, ComputedDegree => compDeg);

  expectedDisplayedPoly := part(0, dispDeg, P);
  expectedComputedPoly := part(0, compDeg, P);

  -- Initialize an empty list to store errors
  err := {};

  -- Try-else blocks for assertions, accumulate errors in the list
  try (
    assert(L.cache.displayedPolynomial == expectedDisplayedPoly);
  ) 
  else (
    errMessage := concatenate(
      "------Error in displayed polynomial comparison.------",
      "\nExpected: ", toString(expectedDisplayedPoly),
      "\nFound:    ", toString(L.cache.displayedPolynomial),"\n\n"
      );
    err = append(err, errMessage);
  );  
  try (
    assert(L.cache.computedPolynomial == expectedComputedPoly);
  ) else (
    errMessage = concatenate(
      "------Error in computed polynomial comparison.------",
      "\nExpected: ", toString(expectedComputedPoly),
      "\nFound: ", toString(L.cache.computedPolynomial),"\n\n"
      );
    err = append(err, errMessage);
  );

  try (
    assert(L.cache.DisplayedDegree == dispDeg);
  ) else (
    errMessage =concatenate(
      "------Error in displayed degree comparison.------",
      "\nExpected: ", toString(dispDeg),
      "\nFound: ", toString(L.cache.DisplayedDegree),"\n\n"
      );
    err = append(err, errMessage);
  );

  try (
    assert(L.cache.ComputedDegree == compDeg);
  ) else (
    errMessage = concatenate(
      "------Error in computed degree comparison.------",
      "\n Expected: ", toString(compDeg),
      "\nFound: ", toString(L.cache.ComputedDegree),"\n\n"
      );
    err =append(err, errMessage);
  );
  -- Return the list of errors, or a success message if no errors
  if #err > 0 then(
    return concatenate(err)
  )
  else return "All checks passed.\n";
)