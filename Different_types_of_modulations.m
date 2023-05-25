clc; close all; clear all;
%% Variables

% Original uniformly distributed random bits [0 1]
bits = randi([0 1], 1, 1e6);
Power = sum(bits.^2) / length(bits);  % Power of the transmitted signal
snr = 0:2:30;  % SNR values in dB
BER_PSK = [];  % Bit Error Rate matrix for PSK
BER_ASK = [];  % Bit Error Rate matrix for ASK
BER_FSK = [];  % Bit Error Rate matrix for FSK
BER_OOK = [];  % Bit Error Rate matrix for OOK
BER_PRK = [];  % Bit Error Rate matrix for PRK
BER_16QAM = [];  % Bit Error Rate matrix for 16QAM

%% Modulations

% PSK modulation and demodulation
for i = 1:length(snr)
    modulated_signal = pskmod(bits, 2);
    noisy_signal = awgn(modulated_signal, snr(i), 'measured');
    demodulated_signal = pskdemod(noisy_signal, 2);
    [num_errors, prob] = biterr(bits, demodulated_signal);
    BER_PSK = [BER_PSK prob];
end

% ASK modulation and demodulation
for i = 1:length(snr)
    carrier = sqrt(2*Power);  % Carrier amplitude
    modulated_signal = bits .* carrier;  % ASK modulation
    noisy_signal = awgn(modulated_signal, snr(i), 'measured');
    demodulated_signal = noisy_signal >= carrier/2;  % Threshold detection
    [num_errors, prob] = biterr(bits, demodulated_signal);
    BER_ASK = [BER_ASK prob];
end

% FSK modulation and demodulation
fs = 100;  % Sampling frequency
freq_sep = 2; % Frequency separation for FSK
nsamp = 8; % number os samples

for i = 1:length(snr)
    modulated_signal = fskmod(bits, 2, freq_sep, nsamp, fs);
    noisy_signal = awgn(modulated_signal, snr(i), 'measured');
    demodulated_signal = fskdemod(noisy_signal, 2, freq_sep, nsamp, fs);
    [num_errors, prob] = biterr(bits, demodulated_signal);
    BER_FSK = [BER_FSK prob];
end

% OOK modulation and demodulation
for i = 1:length(snr)
    carrier = sqrt(2 * Power);  % Carrier amplitude
    modulated_signal = bits .* carrier;  % OOK modulation
    noisy_signal = awgn(modulated_signal, snr(i), 'measured');
    demodulated_signal = noisy_signal >= carrier / 2;  % Threshold detection
    [num_errors, prob] = biterr(bits, demodulated_signal);
    BER_OOK = [BER_OOK prob];
end

% PRK
for i = 1:length(snr)  % SNR values in dB
    % Map the bits to PRK symbols
    prk_symbols = 2 * bits - 1;
    % Calculate the noise power based on the SNR
    noisy_symbols = awgn(prk_symbols, snr(i), 'measured');
    % Threshold detection
    detected_bits = noisy_symbols >= 0;
    % Compare the original bits with the detected bits
    [num_errors, prob] = biterr(bits, detected_bits);
    BER_PRK = [BER_PRK prob];  % Add new probability of error
end

%% 16QAM
for i = 1:length(snr)
    modulated_signal = qammod(bits, 16);  % 16QAM modulation
    noisy_signal = awgn(modulated_signal, snr(i), 'measured');
    demodulated_signal = qamdemod(noisy_signal, 16);  % 16QAM demodulation
    [num_errors, prob] = biterr(bits, demodulated_signal);
    BER_16QAM = [BER_16QAM prob];
end

%% Plotting BER curves
figure;
subplot(2, 3, 1);
semilogy(snr, BER_PSK);
xlim([0 30]);
title('Bit Error Rate (BER) - PSK', 'fontweight', 'bold');
xlabel('SNR (dB)');
ylabel('BER');
grid on;

subplot(2, 3, 2);
semilogy(snr, BER_ASK);
xlim([0 30]);
title('Bit Error Rate (BER) - ASK', 'fontweight', 'bold');
xlabel('SNR (dB)');
ylabel('BER');
grid on;

subplot(2, 3, 3);
semilogy(snr, BER_FSK);
xlim([0 30]);
title('Bit Error Rate (BER) - FSK', 'fontweight', 'bold');
xlabel('SNR (dB)');
ylabel('BER');
grid on;

subplot(2, 3, 4);
semilogy(snr, BER_OOK);
xlim([0 30]);
title('Bit Error Rate (BER) - OOK', 'fontweight', 'bold');
xlabel('SNR (dB)');
ylabel('BER');
grid on;

subplot(2, 3, 5);
semilogy(snr, BER_PRK); 
xlim([0 30]);
title('Bit Error Rate (BER) - PRK', 'fontweight', 'bold');
xlabel('SNR (dB)');
ylabel('BER');
grid on;

subplot(2, 3, 6);
semilogy(snr, BER_16QAM);
xlim([0 30]);
title('Bit Error Rate (BER) - 16QAM', 'fontweight', 'bold');
xlabel('SNR (dB)');
ylabel('BER');
grid on;
