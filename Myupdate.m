function S = Myupdate(S)

phi = [1 0 1 0;
       0 1 0 1;
       0 0 1 0;
       0 0 0 1];

Q = [16 0 0 0;
     0 16 0 0;
     0  0 4 0;
     0  0 0 4];
N = size(S, 2);

S = phi * S;

S(1:2,:) = S(1:2,:) + sqrt(Q(1,1)) * randn(2, N);
S(3:4,:) = S(3:4,:) + sqrt(Q(3,3)) * randn(2, N);
S = round(S);