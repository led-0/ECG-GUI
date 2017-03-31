clear;close;
load('ecg_data.mat');
ecg=M_1(1:2000);
fs=300;
[qrs_amp_raw,qrs_c,qrs_i_raw,qrs_i,ecg_h,ecg_m,delay]=pan_tompkin(ecg,300,0);
% Calculate Heart Rate
length(qrs_i_raw)*fs/length(ecg)*60
t=1:1/fs:length(ecg)/fs;

figure,az(1)=subplot(311);plot(ecg_h);title('QRS on Filtered Signal');axis tight;
    hold on,scatter(qrs_i_raw,qrs_amp_raw,'m');
    az(2)=subplot(312);plot(ecg_m);title('QRS on MVI signal and Noise level(black),Signal Level (red) and Adaptive Threshold(green)');axis tight;
    hold on,scatter(qrs_i,qrs_c,'m');
    az(3)=subplot(313);plot(ecg-mean(ecg));title('Pulse train of the found QRS on ECG signal');axis tight;
    line(repmat(qrs_i_raw,[2 1]),repmat([min(ecg-mean(ecg))/2; max(ecg-mean(ecg))/2],size(qrs_i_raw)),'LineWidth',2.5,'LineStyle','-.','Color','r');
    linkaxes(az,'x');
    zoom on;
