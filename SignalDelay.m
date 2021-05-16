%
% Signal Delay function


function [Delayed_Sig] = SignalDelay(Sig, Point)

slen = length(Sig);
Delayed_Sig(:,1) = Sig;

for i = 2:Point
    Delayed_Sig = [Delayed_Sig, [Sig(i:slen); ones(i-1,1)*Sig(slen)]];
end
