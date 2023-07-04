mSpeechTrain = audioread("MaleSpeech-16-4-mono-405secs.wav");
fSpeechTrain = audioread("FemaleSpeech-16-4-mono-405secs.wav");

L = min(length(mSpeechTrain),length(fSpeechTrain));  
mSpeechTrain = mSpeechTrain(1:L);
fSpeechTrain = fSpeechTrain(1:L);



mSpeechTrain = mSpeechTrain/norm(mSpeechTrain);
fSpeechTrain = fSpeechTrain/norm(fSpeechTrain);
ampAdj = max(abs([mSpeechTrain;fSpeechTrain]));

mSpeechTrain = mSpeechTrain/ampAdj;
fSpeechTrain = fSpeechTrain/ampAdj;

mixTrain = mSpeechTrain + fSpeechTrain;
mixTrain = mixTrain/max(mixTrain);

windowLength = 128;
fftLength = 128;
overlapLength = 128-1;
Fs = 4000;
win = hann(windowLength,"periodic");

P_mix0 = abs(stft(mixTrain,Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided"));
P_M = abs(stft(mSpeechTrain,Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided"));
P_F = abs(stft(fSpeechTrain,Window=win,OverlapLength=overlapLength,FFTLength=fftLength,FrequencyRange="onesided"));

P_mix = log(P_mix0 + eps);
MP = mean(P_mix(:));
SP = std(P_mix(:));
P_mix = (P_mix - MP)/SP;

figure(6)
histogram(P_mix,EdgeColor="none",Normalization="pdf")
xlabel("Input Value")
ylabel("Probability Density")

maskTrain = P_M./(P_M + P_F + eps);
figure(7)

histogram(maskTrain,EdgeColor="none",Normalization="pdf")
xlabel("Input Value")
ylabel("Probability Density")

seqLen = 20;
seqOverlap = 10;
mixSequences = zeros(1 + fftLength/2,seqLen,1,0);
maskSequences = zeros(1 + fftLength/2,seqLen,1,0);

loc = 1;
while loc < size(P_mix,2) - seqLen
    mixSequences(:,:,:,end+1) = P_mix(:,loc:loc+seqLen-1);
    maskSequences(:,:,:,end+1) = maskTrain(:,loc:loc+seqLen-1);
    loc = loc + seqOverlap;
end


mixSequencesT = reshape(mixSequences,[1 1 (1 + fftLength/2)*seqLen size(mixSequences,4)]);
maskSequencesT = reshape(maskSequences,[1 1 (1 + fftLength/2)*seqLen size(maskSequences,4)]);

numNodes = (1 + fftLength/2)*seqLen;

layers = [ ...
    
    imageInputLayer([1 1 (1 + fftLength/2)*seqLen],Normalization="None")
    
    fullyConnectedLayer(numNodes)
    BiasedSigmoidLayer(6)
    batchNormalizationLayer
    dropoutLayer(0.1)

    fullyConnectedLayer(numNodes)
    BiasedSigmoidLayer(6)
    batchNormalizationLayer
    dropoutLayer(0.1)

    fullyConnectedLayer(numNodes)
    BiasedSigmoidLayer(0)

    regressionLayer
    
    ];

maxEpochs = 3;
miniBatchSize = 64;

options = trainingOptions("adam", ...
    MaxEpochs=maxEpochs, ...
    MiniBatchSize=miniBatchSize, ...
    SequenceLength="longest", ...
    Shuffle="every-epoch", ...
    Verbose=0, ...
    Plots="training-progress", ...
    ValidationFrequency=floor(size(mixSequencesT,4)/miniBatchSize), ...
    ValidationData={mixSequencesV,maskSequencesV}, ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropFactor=0.9, ...
    LearnRateDropPeriod=1);


CocktailPartyNet = trainNetwork(mixSequencesT,maskSequencesT,layers,options);


