-- Reference: https://github.com/Macaulay2/M2/blob/f0ce581750dfd94336883695d3552671410f32f5/M2/Macaulay2/tests/normal/engine-div.m2
R = [x,y,z]
p = x^2+x*y 
f = (i,j)->sub(p, {x=>i, y=>j})
f(6,7)
