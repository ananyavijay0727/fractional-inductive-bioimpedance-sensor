# fractional-inductive-bioimpedance-sensor
Final-year project: fractional-order modeling and an inductive sensor for IoT-based bioimpedance analysis in a compact wearable system. 
# Nanocomposite-Based Fractional-Order Inductive Sensor for Non-Invasive Sweat Bio-Impedance Analysis

Final-year project (B.E. Electronics & Communication Engineering, Dayananda Sagar College of Engineering). A passive, low-cost fractional-order inductive sensor made from a CuO-Al2O3 nanocomposite, characterised over 1 kHz to 10 MHz, with a MATLAB pipeline to extract its fractional parameters. The long-term goal is to estimate sweat electrolyte levels non-invasively, with IoT-based remote monitoring.

> **Status: Phase I complete (fabrication and preliminary characterisation). Phase II (calibration, validation, IoT) is in progress.** Results below are preliminary. This is a research prototype, not a medical device.

## Idea
Sweat carries sodium, chloride and potassium, whose levels reflect hydration and electrolyte balance (and chloride is the basis for cystic fibrosis screening). Higher ionic content lowers sweat impedance. Conventional bio-impedance models use integer-order RC networks, which cannot describe the dispersive behaviour of biological interfaces. A fractional element has impedance Z = L_alpha (jw)^alpha with 0 < alpha < 1 and a constant phase of alpha x 90 degrees. The fractional parameters (alpha, L_alpha, |Z|) are used as the sensing signal.

## Sensors
- **CuO-Al2O3 nanocomposite** (66 mg : 33 mg) on a glass substrate with electrodes
- **Graphite film** for comparison

Fabrication and set-up details: [docs/fabrication_and_setup.md](docs/fabrication_and_setup.md)

## Measurement
The sensor is placed in series with a load resistor R to form a voltage divider. A RIGOL function generator drives it with a swept sinusoid and a Scientific SMO502 oscilloscope records Vin, Vout and the phase shift.

## Preliminary results (Phase I)
CuO-Al2O3 sensor, 1 kHz to 10 MHz:

| Observation | Result |
|---|---|
| Pass band | Gain stays within 0.26 to 0.75 dB up to 30 kHz |
| Roll-off, 100 kHz to 1 MHz | -18.2 dB/decade (alpha_S about 0.91) |
| Roll-off, 1 MHz to 10 MHz | -14.0 dB/decade (alpha_S about 0.70) |
| Constant phase zone | Phase settles near -72 degrees from 1 MHz to 10 MHz |
| Fractional order | alpha about 0.80 (from the phase plateau) |
| Graphite sensor | Mostly resistive up to about 1 MHz; erratic above a few MHz |

Both roll-off slopes are gentler than the -20 dB/decade of an integer-order network, which is the signature of a fractional element.

![Bode plot](images/cuo_al2o3_bode.png)

Measured data: [data/cuo_al2o3_sweep.csv](data/cuo_al2o3_sweep.csv). The 100 kHz phase reading (-86.72 degrees) is an outlier flagged for re-measurement.

## Code
| File | Purpose |
|---|---|
| `matlab/analyze_sweep.m` | Gain, roll-off slope, constant phase zone, alpha estimate, optional fractional-model fit and |Z| |
| `matlab/diagnose_electrolytes.m` | Threshold lookup that flags Na+, K+, Cl- as Normal / Borderline / Abnormal |
| `matlab/synthetic_sweat_calc.m` | Concentrations of the synthetic sweat formulations |

Run in MATLAB: open the `matlab/` folder and run `analyze_sweep`. To enable the model fit and |Z| calculation, set `R_load` (your load resistor in ohms) at the top of the script.

## Planned work (Phase II)
- Repeatability testing and sensor optimisation
- Electrolyte calibration with synthetic sweat (10 to 150 mM Na+, K+, Cl-)
- Validation against a reference bio-impedance instrument
- Pilot trials with human sweat (non-invasive, with informed consent)
- IoT integration with a Wi-Fi microcontroller and remote dashboard

## Known limitations
- Results come from one sensor and a single sweep (20 points); repeatability is not yet tested.
- The graphite readings above a few MHz are unreliable (lead parasitics, phase wrapping) and will be re-measured.
- The oscilloscope bandwidth (50 MHz) limits the useful sweep to about 10 MHz.
- A full-sweep model fit gives a different alpha than the phase-plateau estimate (see `analyze_sweep.m`); the fitting procedure is being refined.
- Diagnostic thresholds are those used in the project report and are not clinically validated.

## Repository structure
```
├── data/cuo_al2o3_sweep.csv
├── docs/fabrication_and_setup.md
├── images/cuo_al2o3_bode.png
├── matlab/
│   ├── analyze_sweep.m
│   ├── diagnose_electrolytes.m
│   └── synthetic_sweat_calc.m
└── README.md
```

## Team
Ananya Vijay, Noor E Tanzeem, Ruchitha M, Srushti M P
Guide: Dr. Sumit Swain, Assistant Professor, Dept. of ECE, DSCE

## Disclaimer
Research prototype for education. Not intended for diagnosis or medical decisions.
