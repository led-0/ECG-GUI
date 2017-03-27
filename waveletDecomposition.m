function [ app, det ] = waveletDecomposition( x )
%waveletDecompositon reduces noise in a signal x via 2nd level wavelet
%decomposition. The outputs are approximation & detail coefficient vectors
%app and det respectively.
%   [ app, det ] = waveletDecomposition( x ) the process of wavelet
%   decomposition uses twin filters; one low-pass and one high-pass.

[c,l] = wavedec(x, 2, 'db4');       %   2 level wavelet decomposition by
                                    %   Daubechies-4 filter
%////////////////////////////////////////////////////////////////////////// 
app2 = appcoef(c, l, 'db4', 2);     %   2nd level app. coefficients
%//////////////////////////////////////////////////////////////////////////
det2 = detcoef(c, l, 2);     %   1 to 2 level det. coefficients

app = app2;
det = det2;

%/////////////////////////////////////////////////////////////////////////

end
