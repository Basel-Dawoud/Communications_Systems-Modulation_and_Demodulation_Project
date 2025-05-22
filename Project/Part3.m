%% Part III: FM Modulation and Demodulation
clear; close all; clc;

% Base directory
baseDir = 'G:\Faculty\2nd Sem Communication\Communication Systems\Project\';

% Load message signal
[message, Fs] = audioread(fullfile(baseDir, 'filtered_voice.wav'));
message = message(:,1);  % Mono
message = message / max(abs(message));  % Normalize

% Time vector
t_msg = (0:length(message)-1)' / Fs;

% Upsample for modulation
upsample_factor = 8;
Fs_up = Fs * upsample_factor;
t_up = (0:1/Fs_up:t_msg(end))';
message_up = interp1(t_msg, message, t_up, 'linear', 0);

% Carrier and modulation parameters
Fc = 48000;
betas = [3, 5];
N = length(t_up);

% ----------- Figure 1: FM Modulated Signals (Time and Frequency) -----------
figure('Name', 'FM Modulated Signals');
tiledlayout(2, 2);

for i = 1:2
    beta = betas(i);
    kf = beta * 2 * pi * 3400 / max(abs(message));  % freq sensitivity
    int_msg = cumsum(message_up) / Fs_up;
    fm_sig = cos(2*pi*Fc*t_up + kf * int_msg);
    
    % Time-domain plot (first 5ms)
    nexttile;
    plot(t_up(1:round(Fs_up*0.005)), fm_sig(1:round(Fs_up*0.005)));
    title(['FM Signal (β = ', num2str(beta), ')']);
    xlabel('Time [s]'); ylabel('Amplitude'); grid on;

    % Frequency-domain plot
    nexttile;
    f = (-N/2:N/2-1)*(Fs_up/N);
    spec = fftshift(fft(fm_sig)) / N;
    plot(f/1000, abs(spec));
    title(['Spectrum (β = ', num2str(beta), ')']);
    xlabel('Frequency [kHz]'); ylabel('Magnitude'); xlim([-100 100]); grid on;
end

saveas(gcf, fullfile(baseDir, 'FM_Modulated_Signals.png'));

% ----------- Figure 2: FM Demodulation (Time and Frequency) -----------
beta = 5;
kf = beta * 2 * pi * 3400 / max(abs(message));
fm_sig = cos(2*pi*Fc*t_up + kf * cumsum(message_up)/Fs_up);

% Demodulation using phase differentiation
analytic = hilbert(fm_sig);
inst_phase = unwrap(angle(analytic));
demod = [0; diff(inst_phase)] * Fs_up / kf;
demod = lowpass(demod, 3400, Fs_up);

% Downsample
demod_ds = resample(demod, Fs, Fs_up);
t_ds = (0:length(demod_ds)-1)' / Fs;

% Play sound
soundsc(demod_ds, Fs);

% Plot
figure('Name', 'FM Demodulated Signal');
tiledlayout(2,1);
nexttile;
plot(t_ds, demod_ds); title('Demodulated Signal (Time)');
xlabel('Time [s]'); ylabel('Amplitude'); grid on;

nexttile;
N2 = length(demod_ds);
f2 = (-N2/2:N2/2-1)*(Fs/N2);
plot(f2/1e3, abs(fftshift(fft(demod_ds))/N2));
title('Demodulated Signal Spectrum'); xlabel('Freq [kHz]');
ylabel('Magnitude'); xlim([-5 5]); grid on;

saveas(gcf, fullfile(baseDir, 'FM_Demodulated_Signal.png'));

% ----------- Tone Signal Generation (3 kHz) -----------
tone_freq = 3000;
tone = cos(2*pi*tone_freq*t_up);

% ----------- Figure 3: FM of 3 kHz Tone (Time) -----------
betas_tone = [0.5, 1, 3, 5];
figure('Name', 'FM Tone Modulation (Time)');
tiledlayout(2,2);
for i = 1:length(betas_tone)
    beta = betas_tone(i);
    kf = beta * 2 * pi * tone_freq;
    fm_tone = cos(2*pi*Fc*t_up + kf * cumsum(tone)/Fs_up);
    
    nexttile;
    plot(t_up(1:round(Fs_up*0.005)), fm_tone(1:round(Fs_up*0.005)));
    title(['FM Tone β = ', num2str(beta)]); xlabel('Time [s]');
    ylabel('Amplitude'); grid on;
end
saveas(gcf, fullfile(baseDir, 'FM_Tone_Time.png'));

% ----------- Figure 4: FM Tone Spectrum -----------
figure('Name', 'FM Tone Modulation (Spectrum)');
tiledlayout(2,2);
for i = 1:length(betas_tone)
    beta = betas_tone(i);
    kf = beta * 2 * pi * tone_freq;
    fm_tone = cos(2*pi*Fc*t_up + kf * cumsum(tone)/Fs_up);

    nexttile;
    N3 = length(fm_tone);
    f3 = (-N3/2:N3/2-1)*(Fs_up/N3);
    plot(f3/1e3, abs(fftshift(fft(fm_tone))/N3));
    title(['Spectrum Tone β = ', num2str(beta)]); xlabel('Freq [kHz]');
    ylabel('Magnitude'); xlim([-100 100]); grid on;
end
saveas(gcf, fullfile(baseDir, 'FM_Tone_Spectrum.png'));
