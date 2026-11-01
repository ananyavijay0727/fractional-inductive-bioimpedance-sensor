% synthetic_sweat_calc.m
% Concentrations of the three synthetic sweat formulations
% (project report Table 3.6), using C = m / (M * V) * 1000  [mmol/L].
%
% Each formulation is prepared in 100 mL of distilled water.

V_L = 0.100;                                   % litres

M_NaCl = 58.44;  M_KCl = 74.55;  M_NaHCO3 = 84.01;  M_glucose = 180.16;   % g/mol

names      = {'Normal'; 'Moderate'; 'Unhealthy'};
mass_NaCl  = [0.60; 0.90; 1.20];               % g (only NaCl changes)
mass_KCl   = 0.04;
mass_NaHCO3 = 0.05;
mass_glucose = 0.10;

conc = @(m, Mw) m ./ (Mw * V_L) * 1e3;         % mmol/L (Eq. 3.18)

NaCl_mM    = conc(mass_NaCl, M_NaCl);
KCl_mM     = conc(mass_KCl, M_KCl) * ones(3, 1);
NaHCO3_mM  = conc(mass_NaHCO3, M_NaHCO3) * ones(3, 1);
glucose_mM = conc(mass_glucose, M_glucose) * ones(3, 1);

Na_total = NaCl_mM + NaHCO3_mM;
Cl_total = NaCl_mM + KCl_mM;

T = table(names, NaCl_mM, KCl_mM, NaHCO3_mM, glucose_mM, Na_total, Cl_total);
T{:, 2:end} = round(T{:, 2:end}, 1);
disp(T);
