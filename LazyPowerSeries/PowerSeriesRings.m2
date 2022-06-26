needs "methods.m2"
needs "enginering.m2"
needs "tables.m2"

PowerSeriesRing = new Type of EngineRing

PowerSeriesRing.synonym = "Formal Power Series Ring"

PowerSeriesRing#{Standard,AfterPrint} = R -> (
    << endl << concatenate(interpreterDepth:"o") << lineNumber << " : "; -- standard template
    << "PowerSeriesRing";
    )

isPowerSeriesRing = method(TypicalValue => Boolean)
isPowerSeriesRing Thing := x -> false;
isPowerSeriesRing PowerSeriesRing := (R) -> true;

--isHomogeneous PowerSeriesRing := R -> true -- Not sure if this even makes sense since you can't have a non-trivial grading on power series rings

coefficientRing PowerSeriesRing := R -> last R.baseRings





PowerList = new Type of Array
powerList = method()
powerList(Array) := PowerList => A -> new PowerList from [A];

generators PowerSeriesRing := opts -> R -> R
---
--Ring [Array] := PowerSeriesRing => (R, variables) -> use R monoid variables

--Ring Array := Ring => (R, variables) -> (
  --  if(toString(class(variables#0)) == toString(Array)) then print "HELLO"--use R powerList(variables#0)
    --else use R monoid variables)
    --**************************************
    --**************************************
    --**************************************
    --**************************************
    --Annie, I commented out your Ring Array thing, it was causing errors for me.
    --**************************************
    --**************************************
    --**************************************
    --**************************************

Ring PowerList := PowerSeriesRing =>(R, M)->(

    S := new PowerSeriesRing from R M;
    S
)
