# SAR-autofocusing-with-a-non-convex-penalty

This is the code for our Remote Sensing paper "Sparse Regularization with a Non-Convex Penalty for SAR Imaging and Autofocusing" (https://www.mdpi.com/2072-4292/14/9/2190). 

The code is inspired by the implemention of SDA, which is proposed in "A Sparsity-Driven Approach for Joint SAR Imaging and Phase Error Correction" (https://ieeexplore.ieee.org/abstract/document/6099622). We give our special thanks to the authors of SDA for sending their code to us.

Some matlab functions (the process of generating simulated corrupted phase history and the reconstructed result of polar format algorithm) used in our main.m is from another thirty party (according to the authors of SDA), and thus will be released if permission is given to them and us.

It is notable that there are typos in the equation (28) and (71) of our paper, though they are correct in the code. Specifically, the denominator and the numerator of the term inside the arctan() function should be exchanged, and the "C_m" therein should be replaced by its conjugate transpose. This correct form can be found in equation (27) and (28) in the paper of SDA, as well as in our code.
