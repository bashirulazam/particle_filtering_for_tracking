function S = Myresample(alpha,S)
 N = size(S,2);
 w = alpha./sum(alpha);
 f = cumsum(w,2);
 T = rand(1,N);
 [~,Ind] = histc(T,f);
 S = S(:,Ind + 1);