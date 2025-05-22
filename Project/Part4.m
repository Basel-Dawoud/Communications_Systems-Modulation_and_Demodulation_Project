%% Part IV: FM Performance in Noise and Threshold Effect
clear; close all; clc;

% Base directory
baseDir = 'G:\Faculty\2nd Sem Communication\Communication Systems\Project\';

% Parameters
Fs = 48000;
upsample_factor = 8;
Fs_up = Fs * upsample_factor;

% Signal parameters
f_tone = 3000;
duration = 0.1;  % 100 ms for more stability
t = (0:1/Fs_up:duration)';
tone = cos(2*pi*f_tone*t);
Fc = 48000;

% Noise experiment
betas = [1, 5]; % Compare low and high β
SNRs = [20, 10, 5, 0];  % dB values

% --- 1. Add Gaussian Noise and Compare Performance ---
figure('Name', 'FM Demodulation in Noise for Different β');
tiledlayout(length(betas), length(SNRs));

for i = 1:length(betas)
    beta = betas(i);
    kf = beta * 2 * pi * f_tone;
    
    % Modulate
    fm_sig = cos(2*pi*Fc*t + kf * cumsum(tone)/Fs_up);

    for j = 1:length(SNRs)
        snr = SNRs(j);

        % Add Gaussian noise
        noisy_fm = awgn_local(fm_sig, snr);

        % Demodulate
        demod_sig = fm_demodulate(noisy_fm, Fs_up);

        % Plot
        nexttile;
        plot(t, demod_sig);
        title(['β = ', num2str(beta), ', SNR = ', num2str(snr), ' dB']);
        xlabel('Time [s]');
        ylabel('Demod Output');
        xlim([0 0.01]); % Zoom for clarity
        grid on;
    end
end

saveas(gcf, fullfile(baseDir, 'FM_Noise_Comparison.png'));

% --- 2. Threshold Effect: Increase β until demodulation fails ---
% Fix SNR and vary β
fixed_SNR = 5;  % dB (near threshold region)
beta_vals = linspace(0.1, 10, 100); % test fine-grained β values
threshold_found = false;

for i = 1:length(beta_vals)
    beta = beta_vals(i);
    kf = beta * 2 * pi * f_tone;

    % Modulate
    fm_sig = cos(2*pi*Fc*t + kf * cumsum(tone)/Fs_up);

    % Add noise
    noisy_fm = awgn_local(fm_sig, snr);

    % Demodulate
    demod_sig = fm_demodulate(noisy_fm, Fs_up);

    % Estimate demod SNR
    signal_power = bandpower(tone);
    noise_power = bandpower(demod_sig - tone);
    output_snr = 10*log10(signal_power / noise_power);

    % If SNR suddenly drops → threshold effect
    if output_snr < 3 && ~threshold_found
        threshold_beta = beta;
        threshold_found = true;
    end
end

if threshold_found
    fprintf('Threshold effect occurs at β ≈ %.2f (SNR = %d dB)\n', threshold_beta, fixed_SNR);
else
    fprintf('No threshold effect observed up to β = %.2f\n', max(beta_vals));
end

function noisySignal = awgn_local(signal, SNR_dB)
    signalPower = mean(abs(signal).^2);
    SNR_linear = 10^(SNR_dB/10);
    noisePower = signalPower / SNR_linear;
    noise = sqrt(noisePower) * randn(size(signal));
    noisySignal = signal + noise;
end

function demodulated = fm_demodulate(fm_signal, Fs)
    % FM demodulation by differentiating instantaneous phase
    phase = unwrap(angle(hilbert(fm_signal)));  % instantaneous phase
    demodulated = [0; diff(phase)] * Fs / (2*pi);  % derivative of phase scaled
end
