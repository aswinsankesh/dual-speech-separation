clc;
clear all;
close all;


load CocktailPartyNet.mat

mixValidate = audioread('mix_validate.wav');

windowLength = 128;
fftLength = 128;
overlapLength = 128-1;
Fs = 4000;
win = hann(windowLength,"periodic");

P_Val_mix0 = stft(mixValidate,Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided");
P_Val_mix = log(abs(P_Val_mix0) + eps);
MP = mean(P_Val_mix(:));
SP = std(P_Val_mix(:));
P_Val_mix = (P_Val_mix - MP) / SP;

seqLen = 20;
seqOverlap = 10;

mixValSequences = zeros(1 + fftLength/2,seqLen,1,0);
seqOverlap = seqLen;

loc = 1;
while loc < size(P_Val_mix,2) - seqLen
    mixValSequences(:,:,:,end+1) = P_Val_mix(:,loc:loc+seqLen-1);
    loc = loc + seqOverlap;
end

mixSequencesV = reshape(mixValSequences,[1 1 (1 + fftLength/2)*seqLen size(mixValSequences,4)]);

estimatedMasks0 = predict(CocktailPartyNet,mixSequencesV);

estimatedMasks0 = estimatedMasks0.';
estimatedMasks0 = reshape(estimatedMasks0,1 + fftLength/2,numel(estimatedMasks0)/(1 + fftLength/2));


SoftMaleMask = estimatedMasks0; 
SoftFemaleMask = 1 - SoftMaleMask;

P_Val_mix0 = P_Val_mix0(:,1:size(SoftMaleMask,2));
P_Male = P_Val_mix0.*SoftMaleMask;

maleSpeech_est_soft = istft(P_Male,Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided",ConjugateSymmetric=true);
maleSpeech_est_soft = maleSpeech_est_soft/max(abs(maleSpeech_est_soft));


range = windowLength:numel(maleSpeech_est_soft)-windowLength;
t = range*(1/Fs);

sound(maleSpeech_est_soft(range),Fs)

plot(t,maleSpeech_est_soft(range))
xlabel("Time (s)")
title("Estimated Male Speech (Soft Mask)")
grid on


P_Female = P_Val_mix0.*SoftFemaleMask;

femaleSpeech_est_soft = istft(P_Female,Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided",ConjugateSymmetric=true);
femaleSpeech_est_soft = femaleSpeech_est_soft/max(femaleSpeech_est_soft);

% sound(femaleSpeech_est_soft(range),Fs)

figure;
plot(t,femaleSpeech_est_soft(range))
xlabel("Time (s)")
title("Estimated Female Speech (Soft Mask)")
grid on