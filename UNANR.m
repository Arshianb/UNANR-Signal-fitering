% Unbiased and Normalized Adaptive Noise Reduction (UNANR) system

function [O, W] = UNANR (P, T, Lr)

% P - QxK pattern matrix (K: number of delayed input; Q: number of signal samples)
% T - Qx1 target vector
% O - Qx1 output vector
% W - Kx1 tap-weights of the filter
% E - Qx1 estimated error vector

% UNANR Parameter
% Lr - learning/adaption rate parameter

% Learning
[Q, K] = size(P);
W = zeros(Q,K);
TW = zeros(K,1);
TW = TW + eps; % Initialize tap-weights
TW = TW./sum(TW);

E = zeros(Q,1);
Diff = zeros(Q,K);

% Calculation
for i = 1:Q
    for j = 1:K
        O(i,:) = P(i,:)*TW;
        E(i) = T(i) - O(i);
        Diff(i,j) = T(i) - P(i,j);
        TW(j) = TW(j) + 2*Lr.*P(i,j)*Diff(i,j)*TW(j);
        TW = TW./sum(TW);
    end
    W(i,:) = TW';
    O(i,:) = P(i,:)*TW;
end

