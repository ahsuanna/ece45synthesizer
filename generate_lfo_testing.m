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

x1 = x.';
f_lower = 1400; %1400
f_upper = 20000; %20000
y = fft(x1);
f1 = fs*(0:(n-1))/n;

filter = zeros(1,n);
filter(f1<f_lower) = 1;
filter(f1>f_upper) = 1;

x_filteredf = y .* filter;
x_filtered = real(ifft(x_filteredf));

figure (2);

subplot(2,1,1);
plot(f1, abs(y), 'b');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Frequency Domain');
xlim

subplot(2,1,2);
plot(t,x_filtered,'m');
xlabel('Time (s)');
ylabel('Amplitude');
title('Time Domain');

%==========================Adding Noise Code==============================
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


soundsc(x, fs);
