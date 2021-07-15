# To-do
- [X] make a lazy series that saves the coefficient function
- [X] By using two lazy series, make a new lazy series that has its own coefficient function.
- [X] same thing for addition, subtraction, scaling, etc.
- [ ] polynomial * series as well, same idea, make lazy series
- [ ] make method that spits out coefficient at specific index
- [ ] implement geometric series formula

## `applyList`
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
## Mutable vs Immutable variables
Mutable example: `n = 5;` 

Immutable example: `n := 5;`

Remember, you cannot have immutable variables in functions unless you are in some loop or instance. 

## Notes on for and while loops
This is why I'm more used to C++... Make sure you are typing for loops correctly! I certainly didn't! Here are some examples:

```
k = 4;
for i from 0 to k do (
    print k;
    k = k//2;  
)
```
Output:
```
4
2
1
0
0
```
This is probably what you wanted instead:
```
k = 4;
for i from 0 to k when k>0 do (
    print k;
    k = k//2;  
)
```
with output:
```
4
2
1
```
For the `toBinary` function though, the way it's written using `floor(log(2, n))` for the counter is more efficient than replacing it with `n` like here:
```
toBinary(ZZ) := n ->(
    b := "";
    for i from 0 to n do(
        b = concatenate{toString(n % 2), b};
        n = (n//2);
    );
    b
);
```
With larger numbers this will be computationally very inneficient.

## `/` vs `//`
In Macaulay2, division using `/` on integers is not going to output an integer, but rather a rational fraction. If you want to get rid of the remainder and use division in a classical sense like it is done in python for integers, then you have to use `//`.

`/` is called the *exact division* wgise result is often in a larger field, such as the rationals or a function field. Documentation link: http://www.math.kobe-u.ac.jp/icms2006/icms2006-video/slides/grayson/share/doc/Macaulay2/Macaulay2/html/__sl.html

Example:
```
7/2
``` 
will output a fraction in `QQ`:
```
      7
o25 = -
      2

o25 : QQ
```
Meanwhile, `//` is called *division with remainder*, whose result is in the same ring. Documentation link: http://www.math.kobe-u.ac.jp/icms2006/icms2006-video/slides/grayson/share/doc/Macaulay2/Macaulay2/html/__sl_sl.html

Example:
```
7//2
```
will output an integer in `ZZ`:
```
o24 = 3
```
## Conditional functions
Documentation link: https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.16/share/doc/Macaulay2/Macaulay2Doc/html/_conditional_spexecution.html

Example:
```
f = i->(if i>0 then 0
        else if i==0 then 3
        else 6);
```

## Some useful functions to look into for later

fastExp = (f,N) ->
(
     p:=char ring f;
     E:=basePExp(N,p);
     product(#E, e -> (sum(terms f^(E#e), g->g^(p^e))))
)
link: http://www.math.utah.edu/~schwede/M2/PosChar.m2

- isANumber()
- 