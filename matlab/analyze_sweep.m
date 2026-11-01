% analyze_sweep.m
% Fractional-order analysis of a measured frequency sweep of the sensor
% connected as a voltage divider with a load resistor R.
%
% Part 1 (no load resistor needed): gain, roll-off slope, constant phase
%         zone (CPZ) and fractional order alpha from the phase plateau.
% Part 2 (needs R_load): non-linear least-squares fit of
%         H(jw) = R / (R + L_alpha * (jw)^alpha)  ->  alpha, L_alpha, |Z|.
%
% Run:  analyze_sweep

clear; clc; close all;

%% ---------------- Settings ----------------
here        = fileparts(mfilename('fullpath'));
data_file   = fullfile(here, '..', 'data', 'cuo_al2o3_sweep.csv');
cpz_range   = [1e6 1e7];            % Hz, band treated as the constant phase zone
slope_bands = [1e5 1e6; 1e6 1e7];   % Hz, bands used for the roll-off slope
R_load      = NaN;                  % ohms. Enter your load resistor value to enable Part 2

%% ---------------- Load data ----------------
T       = readtable(data_file);
f       = T.frequency_hz;
ratio   = T.vout_over_vin;
phase   = T.phase_deg;
good    = (T.outlier == 0);         % flagged phase outliers are excluded from phase analysis
gain_db = 20*log10(ratio);          % Eq. 3.16

%% ---------------- Part 1: slope and fractional order ----------------
fprintf('--- Roll-off slope (Eq. 3.15) ---\n');
for k = 1:size(slope_bands, 1)
    f1 = slope_bands(k, 1);
    f2 = slope_bands(k, 2);
    g1 = gain_db(f == f1);
    g2 = gain_db(f == f2);
    S  = (g2 - g1) / log10(f2 / f1);
    fprintf('%9.0f - %9.0f Hz : %6.2f dB/decade  (alpha_S = %.2f)\n', f1, f2, S, -S/20);
end

in_cpz        = good & f >= cpz_range(1) & f <= cpz_range(2);
phase_plateau = median(phase(in_cpz));
alpha_phase   = abs(phase_plateau) / 90;      % Eq. 3.14
fprintf('\n--- Constant phase zone ---\n');
fprintf('CPZ band           : %.0f Hz to %.0f Hz (%.1f decades)\n', ...
        cpz_range(1), cpz_range(2), log10(cpz_range(2)/cpz_range(1)));
fprintf('Phase plateau      : %.2f deg\n', phase_plateau);
fprintf('alpha (from phase) : %.2f\n', alpha_phase);

%% ---------------- Part 2: fractional model fit (needs R_load) ----------------
fit_done = false;
if ~isnan(R_load)
    w    = 2*pi*f;
    Hfun = @(x, ww) R_load ./ (R_load + (10.^x(2)) .* (1i*ww).^x(1));   % x = [alpha, log10(L_alpha)]
    cost = @(x) sum((20*log10(abs(Hfun(x, w))) - gain_db).^2) ...
              + sum(((angle(Hfun(x, w))*180/pi - phase).^2) .* good) ...
              + 1e9 * (x(1) <= 0 || x(1) >= 1);
    x0   = [alpha_phase, log10(R_load / (2*pi*1.5e5)^alpha_phase)];
    opts = optimset('MaxFunEvals', 1e4, 'MaxIter', 1e4, 'TolX', 1e-8, 'TolFun', 1e-8);
    x    = fminsearch(cost, x0, opts);

    alpha_fit = x(1);
    L_alpha   = 10^x(2);
    w_c       = (R_load / L_alpha)^(1/alpha_fit);     % Eq. 3.11
    fprintf('\n--- Fractional model fit ---\n');
    fprintf('alpha (fit)        : %.3f\n', alpha_fit);
    fprintf('L_alpha            : %.4g H.s^(alpha-1)\n', L_alpha);
    fprintf('Corner frequency   : %.4g Hz\n', w_c/(2*pi));

    % Sensor impedance from the measured data (Eq. 3.17)
    Zs = R_load .* (1 ./ (ratio .* exp(1i*phase*pi/180)) - 1);
    disp(table(f, abs(Zs), angle(Zs)*180/pi, ...
        'VariableNames', {'f_Hz', 'Z_ohm', 'Z_phase_deg'}));
    fit_done = true;
end

%% ---------------- Plots ----------------
figure('Name', 'Bode plot');
subplot(2, 1, 1);
semilogx(f, gain_db, 'o-', 'LineWidth', 1.2); hold on; grid on;
if fit_done
    f_fit = logspace(log10(min(f)), log10(max(f)), 200).';
    Hf    = Hfun(x, 2*pi*f_fit);
    semilogx(f_fit, 20*log10(abs(Hf)), '--', 'LineWidth', 1.5);
    legend('Measured', 'Fractional model fit', 'Location', 'southwest');
end
ylabel('Gain (dB)');
title('CuO-Al2O3 sensor: measured frequency response');

subplot(2, 1, 2);
semilogx(f(good), phase(good), 's-', 'LineWidth', 1.2); hold on; grid on;
semilogx(f(~good), phase(~good), 'kx', 'MarkerSize', 10, 'LineWidth', 1.5);
if fit_done
    semilogx(f_fit, angle(Hf)*180/pi, '--', 'LineWidth', 1.5);
end
yl = ylim;
semilogx(cpz_range(1)*[1 1], yl, ':k');
semilogx(cpz_range(2)*[1 1], yl, ':k');
xlabel('Frequency (Hz)');
ylabel('Phase (degrees)');
