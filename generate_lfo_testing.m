[sound_file, fs] = audioread('bart.wav');

f0 = 5; %frequency of square wave
duration = 4; %duration
A = 1; %amplitude
n = length(sound_file); 
rate = 20; %sampling rate

t = 0:1/fs:n/fs-1/fs;

squareWave = A * square(2 * pi * f0 * t);

lfo_square = zeros(size(sound_file));
k = round(linspace(1,n,duration*rate));
sampled_values = sound_file(k);
for i= 1:length(k)-1
    lfo_square(k(i):k(i+1)) = sampled_values(i)*squareWave(k(i));
end

figure;
subplot(3,1,1);
plot(t, sound_file, 'b');
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Sound');
ylim([-1, 1]);

subplot(3,1,2);
plot(t, lfo_square, 'r');
xlabel('Time (s)');
ylabel('Amplitude');
title('Generated LFO');
ylim([-1, 1]);

freq = 440; %can be changed to increase the pitch
input = sin(2*pi*freq*t); %can be changed into other types of waves?, this doesn't really do anything it just shows what the input wave is

x = zeros(size(sound_file));

for i = 1:length(k)-1
    lfo_square2 = sampled_values(i) * squareWave(k(i):k(i+1)-1);
    lfo_freq = freq * f0 * lfo_square2;
    t_1 = t(k(i):k(i+1)-1);
    lfo_input = sin(2*pi*lfo_freq.*t_1);
    x(k(i):k(i+1)-1) = lfo_input;
end

subplot(3,1,3);
plot(t, x, 'g');
xlabel('Time (s)');
ylabel('Amplitude');
title('LFO Applied to Input Wave');
ylim([-1, 1]);

%==========================Removing Noise Code============================

%Sorry my code is messy and kind of hard to follow, feel free to change 
%or delete whatever, I don't think I got any of it to really work

%My FT's didnt work ~ I may have been doing it wrong

%My attempt at plotting a FT of x
Len = length(x); %length
freq2 = freq * f0; 
f_1 = freq*(-Len/2:Len/2-1)/Len;
mFreq = fft(x); %FT of x

figure (2);
subplot(4,1,1);
plot(f_1, abs(fftshift(mFreq)));
xlim([0 50])
ylim([0 2500])
xlabel("Frequency Hz");
ylabel("Amplitude");

P2 = abs(mFreq/Len);
P1 = P2(1:Len/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f_2 = freq*(0:(Len/2))/Len;

figure (2)
subplot(4,1,2);
plot(f_2, P1);
xlim([0 50])

f_3 = (0:length(mFreq)-1*freq/length(mFreq));

figure (2)
subplot(4, 1, 3);
plot(f_3, abs(mFreq));
xlim([0 5000])


%figure (2)
%subplot(4,1,4);
%plot(x, fs);
%xlim([0 2000])



%Attempted bandpass filter

%Can change these variables to change bandpass begin and end frequencies
tpass = 1;
bpass = 40;

tfill = tpass;
bfill = bpass;


figure(3);
bandpass(x, [tfill bfill], freq);



%soundsc(x,fs);

%==========================Adding Noise Code==============================
%This should be working, just adjust 'percentOfNoise' from 0.0-0.99

%Noise figures
figure (4)
subplot(2,1,1);
plot(x);
ylim([-1, 1]);
title('Sigal with no noise');

% Add impulsive noise
percentOfNoise = 0.0; % Ex: 0.1 = 10% noise being added, at 0.0 or 0% no 
                      %noise is being added, so the sound plays normally

noiseAmplitude = percentOfNoise * x;
x = x + noiseAmplitude .* rand(size(x));

figure (4)
subplot(2,1,2);
plot(x);
ylim([-1, 1]);
title('Sigal with noise');

%=======================================================================


%Sound output
soundsc(x, fs);
