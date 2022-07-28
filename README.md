# SAR-autofocusing-with-a-non-convex-penalty

This is the code for our Remote Sensing paper "Sparse Regularization with a Non-Convex Penalty for SAR Imaging and Autofocusing" (https://www.mdpi.com/2072-4292/14/9/2190). 

The code is inspired by the implemention of SDA, which is proposed in "A Sparsity-Driven Approach for Joint SAR Imaging and Phase Error Correction" (https://ieeexplore.ieee.org/abstract/document/6099622), whose code can be found at https://github.com/ozbenn/Source-code-for-the-sparsity-driven-autofocus. We give our special thanks to the authors of SDA for sending their code to us.

It is notable that there are typos in the equation (28) and (71) of our paper, though they are correct in the code. Specifically, the denominator and the numerator of the term inside the arctan() function should be exchanged, and the "C_m" therein should be replaced by its conjugate transpose. This correct form can be found in equation (27) and (28) in the paper of SDA, as well as in our code.

If you use this code, please cite the following three papers as the original academic publications where the code has been used:

Z. Y. Zhang, O. Pappas, I. G. Rizaev, A. Achim, "Sparse regularization with a non-convex penalty for SAR imaging and autofocusing," Remote Sensing, 14(9), 2190, May 2022; https://doi.org/10.3390/rs14092190.

N. O. Onhon and M. Cetin, "A Sparsity-Driven Approach for Joint SAR Imaging and Phase Error Correction," in IEEE Transactions on Image Processing, vol. 21, no. 4, pp. 2075-2088, April 2012, doi: 10.1109/TIP.2011.2179056.

R. L. Moses, L. C. Potter, M. Cetin, "Wide-angle SAR imaging," Proc. SPIE 5427, Algorithms for Synthetic Aperture Radar Imagery XI, (2 September 2004); https://doi.org/10.1117/12.544935
