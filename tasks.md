# Goals

## Big goals

- [ ] Implement formal power series as an object
  - [X] `LazySeries` using a ring and function
    - [X] Works for multivariate rings
    - [X] saves the coefficient function
  - [ ] `LazySeries` using a ring and a polynomial as a function
  - [ ] Polynomial/`RingElement` conversion to `LazySeries`

- [ ] Basic Operations involving series
  - [X] Addition and substraction of two `LazySeries`
  - [X] Multiplying and dividing a `LazySeries` by a scalar (of class `Number`)
  - [X] Adding/substracting a scalar (of class `Number`) to/from a `LazySeries`
  - [ ] Multiplying and dividing a `LazySeries` by a Polynomial/`RingElement`
  - [ ] Adding/substracting a Polynomial/`RingElement` to/from a `LazySeries`

- [ ] Division of two LazySeries
  - [ ] Taking LazySeries up to nth power
    - [X] Multiplication of two `LazySeries`
  - [ ] implement geometric series formula
  - [ ] inversion of a lazySeries

- [ ] Implementation of p-adics
  - 

- [ ]  

- [ ] Other 
  - [ ] Documentation
  - [ ] Testing
  - [ ] Github
    - [X] Set up Github Repo
  - [X] Jupyter Notebook

- [ ] Theory
  - [ ] Atiyah Macdonald chapter 6
    - exercises
  - [X] Atiyah Macdonald chapter 7
    - exercises
  - [ ] Atiyah Macdonald chapter 8
  - [ ] Atiyah Macdonald chapter 10
  - [ ] Read about the **Cohen Structure Theorem**
  - [ ] 
  
- [ ] For REU Symposium **August 20th** 
  - [ ] Type up results in LaTeX
  - [ ] Prepare 10 minute presentation 
## Improvements for later
- [X] make method that spits out coefficient at specific index
  - [ ] Make it so that it takes in a list of coefficients and spits out a list of values.
- [ ] 



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
2. 
## If you want to be extra
- [ ] Make github pages and organize notes
- [ ] Make it possible to enter functions for LazySeries creation that doesn't have the exact same amount of inputs as the ring generators. So basically, if my ring is `QQ[x,y,z]` and someone enters a function for a LazySeries which is `(i,j)-> 7`, how do you expand it so that it corresponds with `(i,j,k)->???` form.
- [ ] 