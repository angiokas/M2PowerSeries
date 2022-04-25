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
applyList((x,y)->x^y,{x,y,z},{4,6,8})
```
but there was an easier solution that is already build in Macaulay2:

```
L1 = {x,y,z}
L2 = {3,6,8}
apply(3, i -> (L1#i)^(L2#i))

```
## HashTables VS MutableHashTables
A hash table consists of: a class type, a parent type, and a set of key-value pairs. The keys and values can be anything. The access functions below accept a key and return the corresponding value.

Main difference is that MutableHashTables are basically HashTables whose entries can be modified (changed, deleted, added).

We will be using HashTables because a user wouldn't want to modify a polynomial anyway. It is better to just make a new one. 

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
for loops do not work on lists :(
```
for i from {1,2,3} do print i;
```
will give an error

## `toBinary` method notes
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
## On functions
Functions will not take lists as input. You can only use sequences when you have multi-variable functions.

Example:
Both `f` and `g` here are valid functions
```
f = (i,j) -> i
g = {i,j} -> i
```
But you can only plug in values like this:
```
f (2,3)
g (457,24)
```

The curly braces, i.e lists, will not work and will give you an error
```
f {2,3}
f {457,24}
```

This is why it is a safe practice to put `toSequence` in front of variables that are going to be plugged into these types of functions, because this will convert any other type of list into a sequence and sequences will be unchanged. 

## Evaluating a polynomial by using `sub`
Link to documentation: http://www.math.kobe-u.ac.jp/icms2006/icms2006-video/slides/grayson/share/doc/Macaulay2/Macaulay2/html/_substitute.html

Example
```
p = x*y+x^2 +y^5
f = (i,j)->sub(p, {x=>i, y=>j})
f (4,5)
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



------------------------------------------------------------------------------

## Combinations, or rather, `compositions`

Example:
```
combinations = {};
for j from 0 to 5 do combinations = append(combinations, compositions (3,j)); 
print combinations;
combinations = flatten combinations; 
print combinations;

```

```
sort(combinations)
rsort(combinations)
```

[`compositions`](https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.18/share/doc/Macaulay2/Macaulay2Doc/html/_compositions.html)

## comparing Rings 
You can only compare rings by using `===` symbol, otherwise it won't work. 
Example: 
```
R = ZZ[x]
T = QQ[x,y]
R === T
```

## Promoting elements to rings by using `sub`







## Implementing caching in objects




## 
Using `sub` is actually slow if you use it a lot of times. Another way to promote ringElements to other rings that might be faster is to use ring maps like so:
``` 
R = ZZ[x,y]
S = QQ[x,y]
use R
phi = map(S,R)
phi(x_R)
```

## PRINT SUCKS
```
print #{2,3,4}
```
will not work and will give an error. 
Use `<<` instead 
```
<< #{2,3,4}
```

## Old Meeting notes
f(i,j,k)

f(0,0,0)+(....) inverse of f(0,0,0)(1-K) is this*by using geometric sequence): 1/(f(0,0,0)(1-K)) = 1+K+k^2+...

any any((1,2,3), t -> t==2) 1/(a-f(x,y,z)) = ... 1/(1 - f(x,y,z)) 1 + f(x,y,z) + f(x,y,z)^2 + ... a + f(x,y,z) f(x,y,z) = a + g(x,y,z) = (1/a)(1 - (-1/a)g(x,y,z)) = (a)(1 - (-1/a)g(x,y,z)) = a(1 - h(x,y,z)) (1/a)(1 + h(x,y,z) + h(x,y,z)^2 + …) From Karl E Schwede to Everyone: 01:25 PM (a+b)^7 = a^7 + b^7

a^7 + (7 choose 1)a^6b^1 + … + b^7 (prime choose i) is divisible by p if i is not p or 0 (a+b)^7 a^7 + b^7 f(x,y)^7 f(x,y)^8 f(x,y)^7*f(x,y) {a \choose b} char R {i,j,k} {2,0,1} {0,0,0}+{2,0,1} {2,0,1}+{0,0,0} {1,0,1} + {1,0,0} {1,0,0}+{1,0,1} {2,0,0}, + {0,0,1}

to check if a user has inputted a function with the corect amount of variables that corresponds with the number of variables in the ring, we could use a test with a zero vector of the size of the amounnt of variables in the ring and if it ouputs an error, then error out to the user that they need to input the correct type of function. Use try Catch. https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.18/share/doc/Macaulay2/Macaulay2Doc/html/_try.html

## For testing
- [`assert`](https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.17/share/doc/Macaulay2/Macaulay2Doc/html/_assert.html)
- [hypertext list format](https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.15/share/doc/Macaulay2/Macaulay2Doc/html/_hypertext_splist_spformat.html)

## Some polynomial methods I used
- Truncating polynomial: 
[`parts`](https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.15/share/doc/Macaulay2/Macaulay2Doc/html/_part.html)

- Getting coefficient of monomial in a polynomial:
[`coefficient `](https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.18/share/doc/Macaulay2/Macaulay2Doc/html/_coefficient.html)

- Getting a list of degree of polynomial:
[`degree`](https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.15/share/doc/Macaulay2/Macaulay2Doc/html/_degree_lp__Ring__Element_rp.html)

- List exponents of a polynomial
[`exponents`](https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.16/share/doc/Macaulay2/Macaulay2Doc/html/_exponents.html)
- 
## Documentation

[SimpleDoc](https://faculty.math.illinois.edu/Macaulay2/doc/Macaulay2-1.16/share/doc/Macaulay2/SimpleDoc/html/index.html)
[]

## `listUserSymbols`
This seems to be helpful if you want to get information on your local variables:
[`listUserSmybols`](http://www2.macaulay2.com/Macaulay2/doc/Macaulay2-1.18/share/doc/Macaulay2/Macaulay2Doc/html/_list__User__Symbols.html)
[`userSymbols`](http://www2.macaulay2.com/Macaulay2/doc/Macaulay2-1.18/share/doc/Macaulay2/Macaulay2Doc/html/_user__Symbols.html)