# Least Absolute Deviations reformulation
Least absolute deviation (LAD) method is using L1 norm to get the solution x for `Ax = b` instead of L2 norm. We test a simple linear regression problem with LAD and compare its performance with Least Squares (LS) method.

# Description of files
demo_LAD.m: test script for LAD

# Least Absolute Deviation with Linear Programming
LAD is the optimization problem like the following:

``` min_x ||Ax - b||1 ```

This can be reformulated to LP and solved efficiently. You can use `linprog` function in Matlab.

``` min_x c'x subject to Fx < g ```

To reformulate this, we used 'suppression trick', which create additional non-negative vector s to suppress x from both positive/negative sides, minimizing the absolute value.
