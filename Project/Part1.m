%% Communications Systems Project - Part I (Improved Version)
% Student: Basel Dawoud
% Date: May 20, 2025
% Description: Voice recording, filtering, AM modulation, envelope detection with spectrum visualization
% Improvements: Time-domain plots in blue, frequency-domain plots (magnitude in dB, unwrapped phase in degrees) in red, GUI file picker, fixed t_sounds bug, clearer phase plots

clear; close all; clc;

%% Setup Parameters
basePath = uigetdir('', 'Select folder to save results');
if isequal(basePath, 0)
    error('You must select a folder to continue.');
end

fs_target = 48000;
duration_min = 5;
duration_max = 10;

cutoff_freq = 3400;
filter_order = 100;

fc = 48000;               % Carrier frequency for AM
mod_index = 0.8;

nyquist = fs_target / 2;

%% Step 1: Choose Input Method
choice = menu('Choose voice input:', '1 - Record Live', '2 - Upload Audio');
if choice == 0, choice = 2; end

switch choice
    case 1
        voice_data = recordAudio(fs_target, duration_min, duration_max);
        fs = fs_target;
        method_used = 'Live microphone';
    case 2
        [file, path] = uigetfile({'*.wav;*.mp3'}, 'Select an audio file', basePath);
        if isequal(file, 0), error('No file selected.'); end
        [voice_data, fs] = audioread(fullfile(path, file));
        if fs ~= fs_target
            voice_data = resample(voice_data, fs_target, fs);
            fs = fs_target;
        end
        dur = length(voice_data)/fs;
        if dur > duration_max
            voice_data = voice_data(1:duration_max*fs);
        elseif dur < duration_min
            error('Audio too short.');
        end
        voice_data = voice_data / max(abs(voice_data));
        method_used = ['File: ', file];
end

%% Step 2: Plot Original Signal
N = length(voice_data);
t = (0:N-1)/fs;
f = (-N/2:N/2-1)*(fs/N)/1000; % Convert to kHz
voice_fft = fftshift(fft(voice_data)/N);
voice_fft_mag = 20*log10(abs(voice_fft) + eps);
voice_fft_phase = unwrap(angle(voice_fft)) * 180/pi; % Unwrap phase in degrees

figure('Name', 'Original Signal', 'Position', [100, 100, 800, 900]);
subplot(3,1,1); plot(t, voice_data, 'b', 'LineWidth', 1.5);
title(['Time Domain (', method_used, ')'], 'Interpreter', 'none'); 
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(3,1,2); plot(f, voice_fft_mag, 'r', 'LineWidth', 1.5);
title(['Frequency Domain - Magnitude (', method_used, ')'], 'Interpreter', 'none'); 
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)'); 
xlim([-fs/2/1000, fs/2/1000]); ylim([-80, 0]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));
subplot(3,1,3); plot(f, voice_fft_phase, 'r', 'LineWidth', 1.5);
title(['Frequency Domain - Unwrapped Phase (', method_used, ')'], 'Interpreter', 'none'); 
xlabel('Frequency (kHz)'); ylabel('Phase (degrees)'); 
xlim([-fs/2/1000, fs/2/1000]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));
saveas(gcf, fullfile(basePath, 'Original_Signal.png'));

soundsc(voice_data, fs);
audiowrite(fullfile(basePath, 'original_voice.wav'), voice_data, fs);

%% Step 3: Low-Pass Filter
b = fir1(filter_order, cutoff_freq/nyquist);
filtered_voice = filter(b, 1, voice_data);
filtered_voice = filtered_voice(filter_order/2+1:end);
filtered_voice = filtered_voice / max(abs(filtered_voice));
Nf = length(filtered_voice);
tf = (0:Nf-1)/fs;
freq = (-Nf/2:Nf/2-1)*(fs/Nf)/1000; % Convert to kHz
fft_filtered = fftshift(fft(filtered_voice)/Nf);
fft_filtered_mag = 20*log10(abs(fft_filtered) + eps);
fft_filtered_phase = unwrap(angle(fft_filtered)) * 180/pi;

figure('Name', 'Filtered Signal', 'Position', [100, 100, 800, 900]);
subplot(3,1,1); plot(tf, filtered_voice, 'b', 'LineWidth', 1.5);
title('Filtered Signal - Time Domain'); 
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(3,1,2); plot(freq, fft_filtered_mag, 'r', 'LineWidth', 1.5);
title('Filtered Signal - Frequency Domain - Magnitude'); 
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)'); 
xlim([-fs/2/1000, fs/2/1000]); ylim([-80, 0]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));
subplot(3,1,3); plot(freq, fft_filtered_phase, 'r', 'LineWidth', 1.5);
title('Filtered Signal - Frequency Domain - Unwrapped Phase'); 
xlabel('Frequency (kHz)'); ylabel('Phase (degrees)'); 
xlim([-fs/2/1000, fs/2/1000]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));
saveas(gcf, fullfile(basePath, 'Filtered_Signal.png'));
soundsc(filtered_voice, fs);

%% Step 4: Test Smaller Cutoff Frequencies for Intelligibility
test_cutoffs = [2000, 1000, 100, 50, 10];  % Hz
filtered_signals = cell(length(test_cutoffs), 1);  % Store for playback

% --- Time Domain Plots ---
figure(3); clf;
set(gcf, 'Position', [100, 100, 800, 600]);
for i = 1:length(test_cutoffs)
    cutoff = test_cutoffs(i);
    normalized_cutoff = cutoff / nyquist;
    b = fir1(filter_order, normalized_cutoff, 'low');

    filtered = filter(b, 1, voice_data);
    filtered = filtered(filter_order/2+1:end);  % Compensate for delay
    filtered = filtered(:);

    % Save for playback
    filtered_signals{i} = filtered;

    % Plot time domain
    t_test = (0:length(filtered)-1) / fs;
    subplot(length(test_cutoffs), 1, i);
    plot(t_test, filtered, 'b', 'LineWidth', 1.2);
    title(sprintf('Filtered Signal (Cutoff = %d Hz) - Time Domain', cutoff));
    xlabel('Time (s)'); ylabel('Amplitude');
    xlim([0 t_test(end)]); grid on;
end
saveas(gcf, fullfile(basePath, 'Part1_Step4_Time_Domain.png'));

% --- Frequency Domain Plots ---
figure(4); clf;
set(gcf, 'Position', [100, 100, 800, 1200]);
for i = 1:length(test_cutoffs)
    filtered = filtered_signals{i};
    N_test = length(filtered);
    f_test = (-N_test/2:N_test/2-1) * (fs / N_test) / 1000; % Convert to kHz
    test_fft = fftshift(fft(filtered) / N_test);
    test_fft_mag = 20*log10(abs(test_fft) + eps);
    test_fft_phase = unwrap(angle(test_fft)) * 180/pi;

    subplot(length(test_cutoffs), 2, 2*i-1);
    plot(f_test, test_fft_mag, 'r', 'LineWidth', 1.2);
    title(sprintf('Filtered Signal (Cutoff = %d Hz) - Magnitude', test_cutoffs(i)));
    xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)');
    xlim([-fs/2/1000, fs/2/1000]); ylim([-80, 0]);
    grid on; xticks(-24:4:24); xticklabels(string(-24:4:24));

    subplot(length(test_cutoffs), 2, 2*i);
    plot(f_test, test_fft_phase, 'r', 'LineWidth', 1.2);
    title(sprintf('Filtered Signal (Cutoff = %d Hz) - Unwrapped Phase', test_cutoffs(i)));
    xlabel('Frequency (kHz)'); ylabel('Phase (degrees)');
    xlim([-fs/2/1000, fs/2/1000]); grid on;
    xticks(-24:4:24); xticklabels(string(-24:4:24));
end
saveas(gcf, fullfile(basePath, 'Part1_Step4_Frequency_Domain.png'));

% --- Playback for each cutoff ---
for i = 1:length(test_cutoffs)
    filtered = filtered_signals{i};
    filtered = filtered / max(abs(filtered));  % Normalize
    fprintf('Playing signal filtered at %d Hz...\n', test_cutoffs(i));
    soundsc(filtered, fs);
    pause(length(filtered) / fs + 0.5);
end

%% Step 5: Speech Sounds Input, Filtering, Visualization
sounds_choice = menu('Choose input method for speech sounds (f, s, b, d, n, m):', ...
                     '1 - Live Recording', '2 - Pre-recorded File');
if sounds_choice == 0
    warning('No selection made. Defaulting to pre-recorded file.');
    sounds_choice = 2;
end

switch sounds_choice
    case 1
        speech_sounds = recordAudio(fs_target, duration_min, duration_max);
        sounds_method = 'Live microphone recording';
        fprintf('Sampling rate set to %d Hz (live recording).\n', fs_target);
    case 2
        [sounds_file, sounds_path] = uigetfile({'*.wav;*.mp3'}, 'Select speech sounds file', basePath);
        if isequal(sounds_file, 0), error('No file selected.'); end
        [speech_sounds, fs_sounds] = audioread(fullfile(sounds_path, sounds_file));
        fprintf('Native sampling rate of %s: %d Hz\n', sounds_file, fs_sounds);
        if fs_sounds ~= fs_target
            fprintf('Resampling from %d Hz to %d Hz...\n', fs_sounds, fs_target);
            speech_sounds = resample(speech_sounds, fs_target, fs_sounds);
        end
        duration_sounds = length(speech_sounds) / fs_target;
        if duration_sounds > duration_max
            speech_sounds = speech_sounds(1:duration_max * fs_target);
            fprintf('Trimmed to %.1f seconds.\n', duration_max);
        elseif duration_sounds < duration_min
            error('Audio too short (%.2f < %.2f seconds)', duration_sounds, duration_min);
        end
        speech_sounds = speech_sounds / max(abs(speech_sounds));
        sounds_method = sprintf('Pre-recorded file: %s', sounds_file);
end

% Playback original speech sounds
fprintf('Playing speech sounds...\n');
soundsc(speech_sounds, fs_target);
pause(length(speech_sounds) / fs_target + 1);

% Plot original speech sounds
figure(5); clf;
set(gcf, 'Position', [100, 100, 800, 900]);
t_sounds = (0:length(speech_sounds)-1) / fs_target; % Define t_sounds before plotting
subplot(3,1,1);
plot(t_sounds, speech_sounds, 'b', 'LineWidth', 1.5);
title(['Speech Sounds - Time Domain (', sounds_method, ')'], 'Interpreter', 'none');
xlabel('Time (s)'); ylabel('Amplitude');
xlim([0, t_sounds(end)]); grid on;

N_sounds = length(speech_sounds);
f_sounds = (-N_sounds/2:N_sounds/2-1) * (fs_target / N_sounds) / 1000; % Convert to kHz
sounds_fft = fftshift(fft(speech_sounds) / N_sounds);
sounds_fft_mag = 20*log10(abs(sounds_fft) + eps);
sounds_fft_phase = unwrap(angle(sounds_fft)) * 180/pi;
subplot(3,1,2);
plot(f_sounds, sounds_fft_mag, 'r', 'LineWidth', 1.5);
title(['Speech Sounds - Frequency Domain - Magnitude (', sounds_method, ')'], 'Interpreter', 'none');
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)');
xlim([-fs_target/2/1000, fs_target/2/1000]); ylim([-80, 0]);
grid on; xticks(-24:4:24); xticklabels(string(-24:4:24));
subplot(3,1,3);
plot(f_sounds, sounds_fft_phase, 'r', 'LineWidth', 1.5);
title(['Speech Sounds - Frequency Domain - Unwrapped Phase (', sounds_method, ')'], 'Interpreter', 'none');
xlabel('Frequency (kHz)'); ylabel('Phase (degrees)');
xlim([-fs_target/2/1000, fs_target/2/1000]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));
saveas(gcf, fullfile(basePath, 'Part1_Step5_Original_Sounds.png'));

%% Filter speech sounds at various cutoff frequencies
test_cutoffs = [2000, 1000, 100, 50, 10];
filtered_speech = cell(length(test_cutoffs), 1);

% --- Time domain plots ---
figure(6); clf;
set(gcf, 'Position', [100, 100, 800, 600]);
for i = 1:length(test_cutoffs)
    cutoff = test_cutoffs(i);
    normalized_cutoff = cutoff / nyquist;
    b = fir1(filter_order, normalized_cutoff, 'low');
    filtered = filter(b, 1, speech_sounds);
    filtered = filtered(filter_order/2+1:end);
    filtered = filtered(:);
    filtered_speech{i} = filtered;

    subplot(length(test_cutoffs), 1, i);
    t_filtered = (0:length(filtered)-1) / fs_target;
    plot(t_filtered, filtered, 'b', 'LineWidth', 1.2);
    title(sprintf('Filtered Speech Sounds (Cutoff = %d Hz) - Time Domain', cutoff));
    xlabel('Time (s)'); ylabel('Amplitude');
    xlim([0, t_filtered(end)]); grid on;
end
saveas(gcf, fullfile(basePath, 'Part1_Step5_Time_Domain.png'));

% --- Frequency domain plots ---
figure(7); clf;
set(gcf, 'Position', [100, 100, 800, 1200]);
for i = 1:length(test_cutoffs)
    filtered = filtered_speech{i};
    N_filtered = length(filtered);
    f_filtered = (-N_filtered/2:N_filtered/2-1) * (fs_target / N_filtered) / 1000; % Convert to kHz
    filtered_fft = fftshift(fft(filtered) / N_filtered);
    filtered_fft_mag = 20*log10(abs(filtered_fft) + eps);
    filtered_fft_phase = unwrap(angle(filtered_fft)) * 180/pi;

    subplot(length(test_cutoffs), 2, 2*i-1);
    plot(f_filtered, filtered_fft_mag, 'r', 'LineWidth', 1.2);
    title(sprintf('Filtered Speech Sounds (Cutoff = %d Hz) - Magnitude', test_cutoffs(i)));
    xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)');
    xlim([-fs_target/2/1000, fs_target/2/1000]); ylim([-80, 0]);
    grid on; xticks(-24:4:24); xticklabels(string(-24:4:24));

    subplot(length(test_cutoffs), 2, 2*i);
    plot(f_filtered, filtered_fft_phase, 'r', 'LineWidth', 1.2);
    title(sprintf('Filtered Speech Sounds (Cutoff = %d Hz) - Unwrapped Phase', test_cutoffs(i)));
    xlabel('Frequency (kHz)'); ylabel('Phase (degrees)');
    xlim([-fs_target/2/1000, fs_target/2/1000]); grid on;
    xticks(-24:4:24); xticklabels(string(-24:4:24));
end
saveas(gcf, fullfile(basePath, 'Part1_Step5_Frequency_Domain.png'));

% --- Playback of filtered speech sounds ---
for i = 1:length(test_cutoffs)
    filtered = filtered_speech{i} / max(abs(filtered_speech{i}));
    fprintf('Playing filtered speech sounds at %d Hz...\n', test_cutoffs(i));
    soundsc(filtered, fs_target);
    pause(length(filtered) / fs_target + 0.5);
end

% Save original speech sounds
audiowrite(fullfile(basePath, 'speech_sounds.wav'), speech_sounds, fs_target);

%% Step 6: DSB-LC Modulation
Am = max(abs(filtered_voice));
Ac = Am / mod_index;

t = (0:length(filtered_voice)-1)/fs;
modulated = (Ac + mod_index * filtered_voice) .* cos(2*pi*fc*t);
modulated = modulated / max(abs(modulated)); % Normalize

% Spectrum of Modulated Signal
N_mod = length(modulated);
f_mod = (-N_mod/2:N_mod/2-1)*(fs/N_mod)/1000; % Convert to kHz
fft_modulated = fftshift(fft(modulated)/N_mod);
fft_modulated_mag = 20*log10(abs(fft_modulated) + eps);
fft_modulated_phase = unwrap(angle(fft_modulated)) * 180/pi;

figure('Name', 'Modulated Signal', 'Position', [100, 100, 800, 900]);
subplot(3,1,1); plot(t, modulated, 'b', 'LineWidth', 1.5);
title('AM Modulated Signal - Ascending - Time Domain'); 
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(3,1,2); plot(f_mod, fft_modulated_mag, 'r', 'LineWidth', 1.5);
title('AM Modulated Signal - Frequency Domain - Magnitude'); 
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)'); 
xlim([-fs/2/1000, fs/2/1000]); ylim([-80, 0]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));
subplot(3,1,3); plot(f_mod, fft_modulated_phase, 'r', 'LineWidth', 1.5);
title('AM Modulated Signal - Frequency Domain - Unwrapped Phase'); 
xlabel('Frequency (kHz)'); ylabel('Phase (degrees)'); 
xlim([-fs/2/1000, fs/2/1000]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));
saveas(gcf, fullfile(basePath, 'Modulated_Signal.png'));

audiowrite(fullfile(basePath, 'modulated_signal.wav'), modulated, fs);

%% Step 7: Envelope Detection (Rectifier + LPF)
delay_samples = filter_order / 2;
rectified = abs(modulated);  % Full-wave rectification
b_env = fir1(filter_order, cutoff_freq/nyquist);  % Reuse existing cutoff
recovered_env = filter(b_env, 1, rectified);
recovered_env = recovered_env(delay_samples+1:end);  % Compensate filter delay
recovered_env = recovered_env - mean(recovered_env);  % DC offset removal

% Time and Frequency plots
N_env = length(recovered_env);
t_env = (0:N_env-1)/fs;
f_env = (-N_env/2:N_env/2-1)*(fs/N_env)/1000; % Convert to kHz
fft_env = fftshift(fft(recovered_env)/N_env);
fft_env_mag = 20*log10(abs(fft_env) + eps);
fft_env_phase = unwrap(angle(fft_env)) * 180/pi;

% Determine y-axis limits for time-domain plot to be consistent across recovered and scaled signals
if N_env == 0
    error('Recovered signal is empty after filtering. Check modulated signal or filter parameters.');
end
start_idx = delay_samples + 1;
end_idx = delay_samples + N_env;
if end_idx > length(voice_data)
    end_idx = length(voice_data);
    N_env = end_idx - start_idx + 1;
    recovered_env = recovered_env(1:N_env);
    t_env = (0:N_env-1)/Fs;
    fft_env = fftshift(fft(recovered_env)/N_env);
    fft_env_mag = 20*log10(abs(fft_env) + eps);
    fft_env_phase = unwrap(angle(fft_env)) * 180/pi;
end
voice_data_trimmed = voice_data(start_idx:end_idx);
if isempty(voice_data_trimmed) || isempty(recovered_env)
    max_amplitude = 1; % Default to 1 if signals are invalid
elseif all(abs(recovered_env) < eps) && all(abs(voice_data_trimmed) < eps)
    max_amplitude = 0.1; % Default to 0.1 if both signals are effectively zero
else
    max_amplitude = max(abs([recovered_env; voice_data_trimmed]));
end
if isempty(max_amplitude) | isnan(max_amplitude) | max_amplitude <= 0
    max_amplitude = 0.1; % Ensure a positive value
end
y_limit = [-max_amplitude * 1.1, max_amplitude * 1.1];

figure('Name', 'Recovered Envelope (Rectifier + LPF)', 'Position', [100, 100, 800, 900]);
subplot(3,1,1); plot(t_env, recovered_env, 'b', 'LineWidth', 1.5);
title('Recovered Message - Time Domain'); 
xlabel('Time (s)'); ylabel('Amplitude'); %ylim(y_limit); grid on;

subplot(3,1,2); plot(f_env, fft_env_mag, 'r', 'LineWidth', 1.5);
title('Recovered Message - Frequency Domain - Magnitude'); 
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)'); 
xlim([-fs/2000, fs/2000]); ylim([-80, 0]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));

subplot(3,1,3); plot(f_env, fft_env_phase, 'r', 'LineWidth', 1.5);
title('Recovered Message - Frequency Domain - Unwrapped Phase'); 
xlabel('Frequency (kHz)'); ylabel('Phase (degrees)'); ylim auto; grid on;

saveas(gcf, fullfile(basePath, 'Recovered_Message.png'));

soundsc(recovered_env, fs);

%%
% Normalize only for playback to avoid clipping
% Energy Matching
% Remove DC component before scaling
recovered_env_nodc = recovered_env - mean(recovered_env);

% Match energy to original recorded signal
energy_original = sum(voice_data_trimmed.^2);
energy_recovered = sum(recovered_env_nodc.^2);

if energy_recovered < eps
    warning('Recovered signal energy is too low. Skipping energy scaling.');
    scaled_env = recovered_env_nodc;
else
    scale_factor = sqrt(energy_original / energy_recovered);
    scaled_env = recovered_env_nodc * scale_factor;
end

% Playback version (normalized to avoid clipping)
max_env = max(abs(scaled_env));
if max_env < eps
    max_env = 1;
end
recovered_env_playback = scaled_env / max_env;
audiowrite(fullfile(basePath, 'recovered_message.wav'), recovered_env_playback, fs);
audiowrite(fullfile(basePath, 'recovered_message_scaled.wav'), scaled_env, fs);
soundsc(recovered_env_playback, fs);

%% Step 9: Plot Demodulated Signal
N_env = length(recovered_env_scaled);
t_env = (0:N_env-1)/fs;
f_env = (-N_env/2:N_env/2-1)*(fs/N_env)/1000; % Convert to kHz
fft_env = fftshift(fft(recovered_env_scaled)/N_env);
fft_env_mag = 20*log10(abs(fft_env) + eps);
fft_env_phase = unwrap(angle(fft_env)) * 180/pi;

figure('Name', 'Demodulated Signal (Envelope Detection)', 'Position', [100, 100, 800, 900]);
subplot(3,1,1); plot(t_env, recovered_env_scaled, 'b', 'LineWidth', 1.5);
title('Demodulated Signal - Time Domain');
xlabel('Time (s)'); ylabel('Amplitude'); grid on;
subplot(3,1,2); plot(f_env, fft_env_mag, 'r', 'LineWidth', 1.5);
title('Demodulated Signal - Frequency Domain - Magnitude');
xlabel('Frequency (kHz)'); ylabel('Magnitude (dB)'); 
xlim([-fs/2/1000, fs/2/1000]); ylim([-80, 0]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));
subplot(3,1,3); plot(f_env, fft_env_phase, 'r', 'LineWidth', 1.5);
title('Demodulated Signal - Frequency Domain - Unwrapped Phase');
xlabel('Frequency (kHz)'); ylabel('Phase (degrees)'); 
xlim([-fs/2/1000, fs/2/1000]); grid on;
xticks(-24:4:24); xticklabels(string(-24:4:24));
saveas(gcf, fullfile(basePath, 'Demodulated_Signal_Time_Freq.png'));

%% Utility Function
function audio = recordAudio(fs, dur_min, dur_max)
    recObj = audiorecorder(fs, 16, 1);
    fprintf('Recording for %d seconds...\n', dur_min);
    recordblocking(recObj, dur_min);
    audio = getaudiodata(recObj);
    audio = audio / max(abs(audio));
end