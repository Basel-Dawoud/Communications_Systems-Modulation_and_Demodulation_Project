%% Part II: DSB-SC and SSB-SC Modulation/Demodulation
clear; close all; clc;

%% Set base directory for saving
base_dir = 'G:\Faculty\2nd Sem Communication\Communication Systems\Project\';

%% Load bandlimited message signal (from Part I)
[message, Fs] = audioread(fullfile(base_dir, 'filtered_voice.wav'));
message = message(:,1);         % Mono
message = message(:);           % Column vector

%% Time axis for message
t_msg = (0:length(message)-1)/Fs;

%% Upsample message for modulation
ups_factor = 16;                 
Fs_up = ups_factor * Fs;        % New sampling rate

t_max = t_msg(end);
t_up = (0:1/Fs_up:t_max)';      % Column vector time axis
message_up = interp1(t_msg, message, t_up, 'linear', 0);

%% Carrier parameters
Fc = 48000;                     
carrier = cos(2*pi*Fc*t_up);

%% 1) DSB-SC Modulation
dsb_mod = message_up .* carrier;

% Plot time-domain (1-s)
samps_td = round(Fs_up);
fig1 = figure;
subplot(2,1,1);
plot(t_up(1:samps_td), dsb_mod(1:samps_td));
title('DSB-SC Modulated Signal (5 ms)');
xlabel('Time [s]'); ylabel('Amplitude'); grid on;

% Spectrum
N = length(dsb_mod);
f = (-N/2:N/2-1)*(Fs_up/N);
spec_dsb = fftshift(fft(dsb_mod))/N;
subplot(2,1,2);
plot(f/1e3, abs(spec_dsb));
title('DSB-SC Spectrum');
xlabel('Freq [kHz]'); ylabel('Magnitude'); xlim([-100 100]); grid on;

saveas(fig1, fullfile(base_dir, 'DSB_SC_Time_Spectrum.png'));

%% 2) Coherent Detection (no offset)
coh = dsb_mod .* (2*cos(2*pi*Fc*t_up));
lp = fir1(100, (Fs/2e3)/(Fs_up/2)); % ~3.4 kHz cutoff
rec_dsb = filter(lp,1,coh);
rec_dsb_ds = resample(rec_dsb, Fs, Fs_up);
soundsc(rec_dsb_ds, Fs);

%% 3) Plot demodulated signal
fig2 = figure;
subplot(2,1,1);
t_ds = (0:length(rec_dsb_ds)-1)/Fs;
plot(t_ds, rec_dsb_ds);
title('Recovered DSB-SC Signal (Time)');
xlabel('Time [s]'); ylabel('Amplitude'); grid on;

N2 = length(rec_dsb_ds);
f2 = (-N2/2:N2/2-1)*(Fs/N2);
spec_rec = fftshift(fft(rec_dsb_ds))/N2;
subplot(2,1,2);
plot(f2/1e3, abs(spec_rec));
title('Recovered DSB-SC Spectrum');
xlabel('Freq [kHz]'); ylabel('Magnitude'); xlim([-5 5]); grid on;

saveas(fig2, fullfile(base_dir, 'DSB_SC_Recovered_Time_Spectrum.png'));

%% 4) Frequency offset experiments
offsets = [10, 50, 100]; % Hz
for k = 1:length(offsets)
    delta = offsets(k);
    coh_off = dsb_mod .* (2*cos(2*pi*(Fc + delta)*t_up));
    rec_off = filter(lp,1,coh_off);
    rec_off_ds = resample(rec_off, Fs, Fs_up);
    fprintf('Offset = %d Hz: playing...\n', delta);
    soundsc(rec_off_ds, Fs);
    pause(length(rec_off_ds)/Fs + 0.5);
end

%% 5) SSB-SC Modulation (Upper Sideband)
analytic = hilbert(message_up);
ssb_mod = real(analytic .* exp(1j*2*pi*Fc*t_up));

fig3 = figure;
subplot(2,1,1);
plot(t_up(1:samps_td), ssb_mod(1:samps_td));
title('SSB-SC Modulated Signal (5 ms)');
xlabel('Time [s]'); ylabel('Amplitude'); grid on;

spec_ssb = fftshift(fft(ssb_mod))/N;
subplot(2,1,2);
plot(f/1e3, abs(spec_ssb));
title('SSB-SC Spectrum');
xlabel('Freq [kHz]'); ylabel('Magnitude'); xlim([-20 100]); grid on;

saveas(fig3, fullfile(base_dir, 'SSB_SC_Modulated_Time_Spectrum.png'));

%% 6) SSB Coherent Demodulation
coh_ssb = ssb_mod .* (2*cos(2*pi*Fc*t_up));
rec_ssb = filter(lp,1,coh_ssb);
rec_ssb_ds = resample(rec_ssb, Fs, Fs_up);
soundsc(rec_ssb_ds, Fs);

%% 7) Plot recovered SSB
fig4 = figure;
subplot(2,1,1);
plot((0:length(rec_ssb_ds)-1)/Fs, rec_ssb_ds);
title('Recovered SSB-SC Signal (Time)');
xlabel('Time [s]'); ylabel('Amplitude'); grid on;

N3 = length(rec_ssb_ds);
f3 = (-N3/2:N3/2-1)*(Fs/N3);
spec_ssb_rec = fftshift(fft(rec_ssb_ds))/N3;
subplot(2,1,2);
plot(f3/1e3, abs(spec_ssb_rec));
title('Recovered SSB-SC Spectrum');
xlabel('Freq [kHz]'); ylabel('Magnitude'); xlim([-5 5]); grid on;

saveas(fig4, fullfile(base_dir, 'SSB_SC_Recovered_Time_Spectrum.png'));

%% 8) Frequency offset for SSB
for k = 1:length(offsets)
    delta = offsets(k);
    coh_off_ssb = ssb_mod .* (2*cos(2*pi*(Fc+delta)*t_up));
    rec_off_ssb = filter(lp,1,coh_off_ssb);
    rec_off_ssb_ds = resample(rec_off_ssb, Fs, Fs_up);
    fprintf('SSB Offset = %d Hz: playing...\n', delta);
    soundsc(rec_off_ssb_ds, Fs);
    pause(length(rec_off_ssb_ds)/Fs + 0.5);
end
