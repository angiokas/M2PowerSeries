## To-do
[] make a lazy series that saves the coefficient function
[] By using two lazy series, make a new lazy series that has its own coefficient function.
[] same thing for addition, subtraction, scaling, etc.
[] polynomial * series as well, same idea, make lazy series
[] make method that spits out coefficient at specific index
[] implement geometric series formula

## applyList
I was trying to figure out a way to make all of the combinations of the variables powers, so I wrote this code which works: 
```
applyList = method()
applyList(Function, List, List) := (f,l1,l2)->(
    if (#l1 != #l2) then
        error("lists not of equal length"); -- first checks that list lengths are equal
    
    l := {}; -- starting with an empty list
    for i from 0 to (#l1-1) do
        l = append(l,f(l1#i,l2#i));

    return l;
)

```
but there was an easier solution that is already build in Macaulay2:

```
applyList((x,y)->x^y,{x,y,z},{4,6,8})
L1 = {x,y,z}
L2 = {3,6,8}
apply(3, i -> (L1#i)^(L2#i))

```