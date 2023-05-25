clc;
close all;
clear all;

% Original uniformly distributed random bits [0 1]
bits = randi([0 1], 1, 1e6);
Power = sum(bits.^2) / length(bits); % Power of the transmitted signal
BER_PSK = []; % Bit Error Rate matrix for PSK
BER_PAM = []; % Bit Error Rate matrix for PAM

snr = 0:2:30; % SNR values in dB

for i = 1:length(snr)
    % PSK modulation
    modulated_signal_psk = pskmod(bits, 2);
    
    % Add noise to PSK modulated signal
    noisy_signal_psk = awgn(modulated_signal_psk, snr(i), 'measured');
    
    % PSK demodulation
    demodulated_signal_psk = pskdemod(noisy_signal_psk, 2);
    
    % Compare the original bits with the detected bits for PSK
    [num_errors_psk, prob_psk] = biterr(bits, demodulated_signal_psk);
    BER_PSK = [BER_PSK prob_psk]; % Add new probability of error for PSK
    
    % PAM modulation
    modulated_signal_pam = pammod(bits, 2);
    
    % Add noise to PAM modulated signal
    noisy_signal_pam = awgn(modulated_signal_pam, snr(i), 'measured');
    
    % PAM demodulation
    demodulated_signal_pam = pamdemod(noisy_signal_pam, 2);
    
    % Compare the original bits with the detected bits for PAM
    [num_errors_pam, prob_pam] = biterr(bits, demodulated_signal_pam);
    BER_PAM = [BER_PAM prob_pam]; % Add new probability of error for PAM
end

% Plotting BER curves for PSK and PAM
figure;
semilogy(snr, BER_PSK, 'b-o', 'LineWidth', 1.5);
hold on;
semilogy(snr, BER_PAM, 'r-o', 'LineWidth', 1.5);
xlim([0 30]);
title('Bit Error Rate (BER)', 'FontWeight', 'bold');
xlabel('SNR (dB)');
ylabel('BER');
legend('PSK', 'PAM');
grid on;
hold off;
