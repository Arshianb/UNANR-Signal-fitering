
% ECG Noise Reduction

clc
close all
clear all

load('D:\daneshgah\Signal project\Signal\article\UNANR_Matlab\ECG_modified.mat');

Sig = ECG_BaseFree; % This ECG is a baseline free signal
fs = 360; % ECG sampling rate


% IIR Comb filer
fo = 60;            % 60 Hz Removal
q = 30;             % IIR Q factor
bw = (fo/(fs/2))/q; % Filter bandwidth.
[b, a] = iircomb(fs/fo, bw, 'notch');
% fvtool(b, a); % Frequency response plot of IIR comb filter
Signal_Comb = filter(b, a, Sig);


% Noise reference generation
ECG_Clean = Signal_Comb;
SignalPower = mean(ECG_Clean.^2);
Reference_Input = Noise_5dB;
Primary_Input = ECG_Clean + Noise_5dB;


% Adaptive filtering
% LMS adaptive filter
StepSize_LMS = 0.5;
% H_LMS1 = adaptfilt.lms(10, StepSize_LMS);
% [Error_LMS] = filter(H_LMS, Reference_Input, Primary_Input);
% Gain_LMS = sum(H_LMS.Coefficients);
% Error_LMS = Error_LMS ./ Gain_LMS;

H_LMS = dsp.LMSFilter(11 , 'StepSize', StepSize_LMS);
[y,e,w] = step(H_LMS, Reference_Input, Primary_Input);
Gain_LMS = sum(w);
Error_LMS = e./ Gain_LMS ;

Output_LMS = Error_LMS;
ECG_LMS = Primary_Input - y;

% UNANR filter
Lr_UNANR = 0.5;
[Output_UNANR, W_UNANR] = UNANR(SignalDelay(Reference_Input, 10), Primary_Input, Lr_UNANR); % 10-order UNANR filter
ECG_UNANR = Primary_Input - Output_UNANR;
Error_UNANR = ECG_UNANR - ECG_Clean;


% Filtering output plots
figure()
subplot(3,1,1)
plot(Time, Primary_Input, 'k');
axis ([0, 10, -0.5, 1.3]);
xlabel({'Time (s)'; '(a)'});
ylabel('Amplitude (mV)');
title('Primary Input')

subplot(3,1,2)
plot(Time, ECG_LMS, 'k');
axis ([0, 10, -0.5, 1.3]);
xlabel({'Time (s)'; '(b)'});
ylabel('Amplitude (mV)');
title('LMS Output')
subplot(3,1,3)
plot(Time, ECG_UNANR, 'k');
axis ([0, 10, -0.5, 1.3]);
xlabel({'Time (s)'; '(c)'});
ylabel('Amplitude (mV)');
title('UNANR Output')




