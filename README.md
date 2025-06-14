# 3-Band Audio Equalizer with GUI – MATLAB Project

## 📌 Overview
This project implements a 3-band audio equalizer using MATLAB, capable of adjusting **Bass**, **Mid**, and **Treble** frequencies through an interactive GUI. It uses **10th-order Butterworth IIR filters** for sharp band separation and real-time audio gain control.

---

## 🎯 Objectives
- To design an interactive audio equalizer in MATLAB
- To allow real-time frequency band gain control (Bass, Mid, Treble)
- To visualize the filter frequency response and audio spectrum
- To play and save the processed audio output

---

## 🧪 Features
- 🎛 Real-time gain control using sliders (0–2x amplification)
- 🖥️ GUI-based interface with sliders and live plots
- 🎚 Accurate frequency separation using IIR filters:
  - Bass: 20–250 Hz  
  - Mid: 250–4000 Hz  
  - Treble: 4000–20000 Hz
- 📊 Visual feedback: Frequency response (`freqz`) & Spectrum (`periodogram`)
- 🔊 Output playback and export as `output.wav`

---

## 🛠️ Methodology
1. **Audio Input**: Load `.wav` file, convert stereo to mono (if required).
2. **Filter Design**: Create three bandpass IIR filters using Butterworth design.
3. **GUI Creation**: Design sliders for gain control and a button to apply processing.
4. **Signal Processing**: Filter, amplify, and recombine audio. Normalize to prevent clipping.
5. **Visualization**: Plot frequency response and spectral comparison.

---

## 📐 Mathematics
- **Butterworth IIR Filters**:
  - Designed using `designfilt` with 10th-order bandpass filters.
- **Frequency Bands**:
  - Bass: 20–250 Hz, Mid: 250–4000 Hz, Treble: 4000–20000 Hz
- **Gain Control**:
  - Output = (Bass × Gain₁) + (Mid × Gain₂) + (Treble × Gain₃)
- **Normalization**:
  - Prevents distortion by scaling: `output = output / max(abs(output))`

---

## 💡 Applications
- 🎶 Music & audio production tools
- 📢 Media playback audio enhancement
- 📘 Teaching DSP and filter design concepts
- 📱 Audio customization in smart/embedded devices
- 🦻 Hearing aid and accessibility systems

---

## 📂 How to Run
1. Open `equalizer_gui.m` in MATLAB.
2. Place a `.wav` file in the same folder and rename it to `sample.wav` (or change the code path).
3. Run the script. Use the sliders to adjust gains.
4. Click the "Process & Play" button to apply effects, visualize response, and hear the output.

---

## 📎 Requirements
- MATLAB R2016b or later
- Signal Processing Toolbox

---

## 📚 References
- MATLAB Documentation – `designfilt`, `freqz`, `periodogram`
- DSP Textbooks on IIR Filters & Equalization
- Butterworth Filter Theory and Applications

---

## 👨‍💻 Author
This project was developed as part of a coursework/lab assignment. Feel free to customize and build upon it for educational or personal use.

---
