# PPPH-VA

[![Paper](https://img.shields.io/badge/GPS%20Solutions-10.1007%2Fs10291--023--01560--z-blue)](https://doi.org/10.1007/s10291-023-01560-z)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24530230.svg)](https://doi.org/10.5281/zenodo.24530230)
![MATLAB](https://img.shields.io/badge/MATLAB-App%20Designer-orange)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**PPPH-VA: An open-source software for real-time multi-GNSS variometric approach using single- and dual-frequency observations**

PPPH-VA is a MATLAB-based open-source tool that applies the variometric approach (VA) to detect short-term dynamic displacements in real-time mode, using a stand-alone GNSS receiver. Since no reference station or internet connection is needed, it is well suited to applications such as GNSS seismology and structural health monitoring.

## ✨ Features

- **Multi-GNSS:** Processes GPS, GLONASS, Galileo, BeiDou-2 and BeiDou-3 observations simultaneously.
- **Single- and dual-frequency VA:** Supports both single-frequency (SF-VA) and ionosphere-free dual-frequency (DF-VA) solutions.
- **Real-time processing:** Runs the variometric process epoch by epoch as the data flow.
- **Flexible orbit and clock sources:** Broadcast ephemeris, IGS real-time service (RTS) corrections, or ultra-rapid products.
- **Extended error modelling:** Accounts for systematic effects that the traditional VA technique ignores, and offers additional parameters for high-noise receivers.
- **Graphical user interface:** Processing options, models and parameters can be set from a user-friendly GUI.
- **Built-in analysis tools:** Horizontal and vertical displacement plots in addition to the output file.

## 🛰️ Error Modelling

| Error source | Mitigation strategy |
|---|---|
| Satellite orbits and clocks | Broadcast ephemeris, IGS RTS or ultra-rapid products |
| Satellite antenna phase center | IGS absolute antenna model (with ultra-rapid products) |
| Receiver antenna phase center | IGS absolute antenna model |
| Phase wind-up | Corrected (Wu et al. 1993) |
| Troposphere | User-selectable; Saastamoinen model with GPT3/VMF3 by default |
| Relativistic effects | Corrected (Kouba 2015) |
| Solid Earth tide and atmospheric loading | Corrected (IERS Conventions 2010) |

## 📁 Repository Structure

```
PPPH_VA/
├── PPPH_VA.mlapp          # Graphical user interface (main entry point)
├── vds_process.m          # Main processing function (for script-based use)
├── sfv_options.mat        # Default options for single-frequency VA
├── dfv_options.mat        # Default options for dual-frequency VA
├── PPPH-VA_manual.pdf     # User manual
├── 1.DataHandling/        # RINEX, navigation, SP3, clock, SSR and ATX readers
├── 2.PreProcessing/       # Satellite positions, cycle-slip detection, elevation cut-off
├── 3.Modelling/           # Correction models (troposphere, tides, wind-up, APC, ...)
├── 4.Filtering/           # Least-squares estimation and output writing
├── 5.Icons/               # GUI icons
└── 6.Example/             # Example scripts (data are downloaded from Zenodo)
```

## 📊 Example Dataset

Due to GitHub's file size limitations, the example GNSS data and required products (RINEX observation and navigation files, SP3, SSR corrections, ATX) are hosted on **Zenodo**.

**Download the dataset here:** [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24530230.svg)](https://doi.org/10.5281/zenodo.24530230)

The dataset contains two examples:

| Example | Data | Scripts |
|---|---|---|
| **1** | BRUX station, 2021 DOY 259, 5-second sampling | `EX1_BRD.m` (broadcast ephemeris), `EX1_RTS.m` (IGS RTS corrections), `EX1_URP.m` (ultra-rapid products) |
| **2** | Shake table experiment at Gebze Technical University, 27 July 2021, 20 Hz, with LVDT reference displacements (`LVDT.mat`) | `EX2_BRD.m`, `EX2_URP.m` |

## 🚀 Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/BerkayBahadur/PPPH-VA.git
   ```
2. Download the example dataset from [Zenodo](https://doi.org/10.5281/zenodo.24530230).
3. Extract the files and place them into the `6.Example/1` and `6.Example/2` directories.
4. In MATLAB, add the software folders to the path:
   ```matlab
   addpath(genpath('path/to/PPPH-VA'))
   ```
5. Either:
   - **GUI:** open `PPPH_VA.mlapp` and select your files and options, or
   - **Script:** change the current folder to an example directory and run a script, e.g.
     ```matlab
     cd 6.Example/2
     EX2_BRD
     ```

For detailed descriptions of all options, see [`PPPH-VA_manual.pdf`](PPPH-VA_manual.pdf).

## 🧪 Validation

PPPH-VA was validated with shake table experiments using a Leica GR30 receiver and CGA60 antenna (20 Hz, 10° cut-off), with an LVDT sensor as reference. Six harmonic oscillations between 0.3 and 1.2 Hz with 5 and 10 mm amplitudes were tested.

- The dominant frequency was detected correctly for all events with both SF-VA and DF-VA.
- Peak amplitudes agreed with the LVDT at the sub-millimeter level.
- In the time domain, RMSE values were 1.5–2.3 mm for SF-VA and 1.8–2.8 mm for DF-VA.

See the paper for full results.

## 🔭 Future Work

Currently, PPPH-VA processes RINEX observation data. Support for real-time RTCM observation streams is planned for future versions.

## 📜 Citation

If you use PPPH-VA in your research, please cite the following paper:

> Bahadur, B., Bezcioglu, M., Yigit, C.O. **PPPH-VA: an open-source software for real-time multi-GNSS variometric approach using single- and dual-frequency observations.** *GPS Solut* 28, 31 (2024). https://doi.org/10.1007/s10291-023-01560-z

```bibtex
@article{Bahadur2024PPPHVA,
  author  = {Bahadur, Berkay and Bezcioglu, Mert and Yigit, Cemal Ozer},
  title   = {{PPPH-VA}: an open-source software for real-time multi-{GNSS} variometric approach using single- and dual-frequency observations},
  journal = {GPS Solutions},
  volume  = {28},
  pages   = {31},
  year    = {2024},
  doi     = {10.1007/s10291-023-01560-z}
}
```

## 🙏 Acknowledgements

This work was supported by the Scientific and Technological Research Council of Türkiye (TÜBİTAK) ARDEB 1001 program (Project No: 122Y100).

The example dataset includes GNSS products provided by the International GNSS Service (IGS), CNES, DLR and Wuhan University. We thank these institutions for making their products publicly available.

## ⚖️ License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

Copyright (c) 2026 Berkay Bahadur

## 📬 Contact

Comments and suggestions are welcome. Please open an [issue](https://github.com/BerkayBahadur/PPPH-VA/issues) or contact the authors:

- Berkay Bahadur — Hacettepe University, Department of Geomatics Engineering
- Mert Bezcioglu — Gebze Technical University, Department of Geomatics Engineering
- Cemal Ozer Yigit — Gebze Technical University, Department of Geomatics Engineering (cyigit@gtu.edu.tr)
