# Fabrication and Measurement Setup
## Sensing films
| Sensor | Material | Notes |
|---|---|---|
| 1 | CuO-Al2O3 nanocomposite (66 mg CuO : 33 mg Al2O3, 2:1 by mass) | Active sensing film |
| 2 | Conductive graphite thin film | Comparison film |

## Fabrication steps (CuO-Al2O3)
1. Weigh 66 mg CuO and 33 mg Al2O3 nanopowder and disperse in a liquid binder.
2. Stir on a magnetic stirrer at 150 rpm to obtain a uniform suspension.
3. Deposit the suspension as a thin film on a glass substrate over the planar electrode pattern (drop-casting or coating).
4. Place the electrodes and heat-treat on the hot plate for 5-7 minutes.
5. Attach test leads to the electrodes.

The graphite sensor is prepared the same way with a conductive graphite film.

## Measurement set-up
The sensor is connected in series with a load resistor R, forming a voltage divider.

| Instrument | Details |
|---|---|
| Function generator | RIGOL dual-channel arbitrary waveform generator (sinusoidal excitation) |
| Oscilloscope | Scientific SMO502, 2 channels, 50 MHz, 500 MSa/s |
| Stirrer / hot plate | REMI 2MLH |

- CH1 measures Vin, CH2 measures Vout (across R); the oscilloscope reports the phase shift between them.
- Phase I sweep: 1 kHz to 10 MHz, 20 points (1, 2, 3, 5, 7 per decade).
- Planned electrolyte tests: 10 Hz to 100 kHz.

## Model
- Fractional inductor: Z = L_alpha (jw)^alpha, with 0 < alpha < 1; phase = alpha x 90 degrees
- Divider transfer function: H(jw) = R / (R + L_alpha (jw)^alpha)
- At high frequency: phase -> -alpha x 90 degrees and slope -> -20 alpha dB/decade

## Synthetic sweat formulations (per 100 mL distilled water)
| Constituent | Normal | Moderate | Unhealthy |
|---|---|---|---|
| NaCl | 0.60 g | 0.90 g | 1.20 g |
| KCl | 0.04 g | 0.04 g | 0.04 g |
| NaHCO3 | 0.05 g | 0.05 g | 0.05 g |
| Glucose | 0.10 g | 0.10 g | 0.10 g |
| Total Na+ | 108.6 mmol/L | 160.0 mmol/L | 211.3 mmol/L |
| Total Cl- | 108.0 mmol/L | 159.4 mmol/L | 210.7 mmol/L |

These stock solutions are above typical sweat ranges, so graded dilutions with distilled water cover the 10-150 mM calibration window. `matlab/synthetic_sweat_calc.m` reproduces the concentrations.

## Safety and ethics
- The sensor is passive and uses low-amplitude AC excitation.
- Any trials with human sweat must be non-invasive and carried out only with informed consent.
