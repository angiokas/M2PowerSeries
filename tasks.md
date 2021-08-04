# Goals

## Big goals

- [ ] Implement formal power series as an object
  - [X] `LazySeries` using a ring and function
    - [X] Works for multivariate rings
    - [X] saves the coefficient function
  - [ ] `LazySeries` using a ring and a polynomial as a function
  - [X] Polynomial/`RingElement` conversion to `LazySeries`

- [ ] Basic Operations involving series
  - [X] Addition and substraction of two `LazySeries`
  - [X] Multiplying and dividing a `LazySeries` by a scalar (of class `Number`)
  - [X] Adding/substracting a scalar (of class `Number`) to/from a `LazySeries`
  - [ ] Multiplying and dividing a `LazySeries` by a Polynomial/`RingElement`
  - [ ] Adding/substracting a Polynomial/`RingElement` to/from a `LazySeries`

- [X] Division of two LazySeries
  - [X] inversion of a lazySeries
    - [X] Taking LazySeries up to nth power
      - [X] Multiplication of two `LazySeries`
  - [X] implement geometric series formula
  

- [ ] Implementation of p-adics
  - [ ] base p conversion
  - [ ] 

- [ ] Helper/Utility methods
  - [X] `zeroSeries`
  - [X] `oneSeries`
  - [X] `isUnit` -
  - [X] `toBinary` - 
  - [X] `maclaurinSeries`
  - [X] `changeDegree` - make sure computed and displayed degree are properly sorted. if wanting higher degree, make sure to change both, if less then change only displayed.
  - [ ] Returns the polynomial of a lazySeries up to a specific degree
  - [ ] overload `sub` so that it takes a lazySeries and a ring and tries to convert the series into an a lazySeries over that ring by changing the function of the lazySeries.
  - [ ] Also make another overload of `sub` so that you can input values and a lazySeries that (NEVER MIND IT DOESNT MAKE SENSEBECAUSE IF I EVALUATE MY POWERSERIES IT WONT CONVERGE)
  - [ ] `addCoefficientFunction` function so that we work with functions instead of full series during computations
  - [ ] comparing LazySeries objects with one another

## Improvements for later
- [X] make method that spits out coefficient at specific index
  - [ ] Make it so that it takes in a list of coefficients and spits out a list of values.
- [ ] make toBase into general function of base p conversion
- [X] make sure ^p powers are actually faster than S*S...S p times because right now it isn't
- [X] Displaying lazySeries using pretty by defining a new pretty function
  - [ ] Need to fix the ```i -> part_i(select(s#displayedPolynomial, i -> degree i >= {s#displayedDegree})) ``` line because displayedDegree in graded rings will be a list and not an integer and `{s#displayedDegree}` will not give us what we want. 
  - [ ] `pretty` doesn't work properly because it went out of bounds on a specific LazySeries.
  - [ ] `toLazySeries` isn't outputting the correct degree
  - [X] Update `lazySeries` method to work with any ring, i.e no matter the function, the values all get converted to the corresponding value in the given ring. (Solved using `sub`)




## to-do for later
- [ ] check out http://www2.macaulay2.com/Macaulay2/doc/Macaulay2-1.14/share/doc/Macaulay2/Divisor/html/index.html for ideas on displaying and constructors and documentation.
- [ ] 
## Other
- [ ] Other 
  - [ ] Documentation
  - [ ] Testing
  - [ ] Github
    - [X] Set up Github Repo
    - [X] Set up read me
  - [X] Jupyter Notebook

- [ ] Theory
  - [X] Atiyah Macdonald chapter 6
    - [X] exercises 
  - [X] Atiyah Macdonald chapter 7
    - exercises
  - [ ] Atiyah Macdonald chapter 8
  - [ ] Atiyah Macdonald chapter 10
  - [ ] Read about the **Cohen Structure Theorem**
  - [ ] 
  
- [ ] For REU Symposium **August 20th** 
  - [ ] Type up results in LaTeX
    - [ ] Background 
    - [ ] 
  - [ ] Prepare 10 minute presentation 
    - [ ] Prepare demonstrations in Jupyter
    - [ ] Prepare speech

## Some questions
- When is a lazySeries equal to 0?
  - Currently the only way to know is if you multiply a series by 0 or if you start off with a 0 function. You could also check suspicious coefficients that might not be 0 and rule out the whole series being 0 if you do find a nonzero coefficient. 
- 


## Ideas for later
1. When I tried typing
    ```
    R = RR[x,1/x]
    ```
    It said 
    ``not implemented yet: fraction fields of polynomial rings over rings other than ZZ, QQ, or a finite field``
2. Implement Ring structure for formal power series


## If you want to be extra
- [ ] Make github pages and organize notes
- [ ] Make it possible to enter functions for LazySeries creation that doesn't have the exact same amount of inputs as the ring generators. So basically, if my ring is `QQ[x,y,z]` and someone enters a function for a LazySeries which is `(i,j)-> 7`, how do you expand it so that it corresponds with `(i,j,k)->???` form.
- [ ] MULTITHREADING 