## To-do
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

## Sadly for and while loops aren't as powerful in Macaulay2
This issue came up when I was trying to write a decimal to binary conversion function where you need to be able to change initial limit given to the loop conditions. As an example, I wanted to write something like this with integer input `n`:
```
for i from 0 to n do(
       print n;
       b = concatenate{b,toString(n % 2)};
        n = n+2;
    );
    b
```
however, the problem is that `n` is not going to change as the limit of the loop because it is immutable . If you try using an intermediatery mutable variable to solve the issue like so:
```
m = n;
for i from 0 to m do(
       print m;
       b = concatenate{b,toString(m % 2)};
        m = m+2;
    );
    b
```
 it will give you an error about it saying "error: mutable unexported unset symbol(s) in package NewPowerSeries: 'm'"

## `/` vs `//`
In Macaulay2, division using `/` on integers is not going to output an integer, but rather a rational fraction. If you want to get rid of the remainder and use division in a classical sense like it is done in python for integers, then you have to use `//`.

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
Meanwhile
```
7//2
```
will output an integer in `ZZ`:
```
o24 = 3
```


