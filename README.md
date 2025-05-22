Communications Systems Project

Overview
This project, developed as part of a Communications Systems course, explores various modulation and demodulation techniques used in analog communication systems. It consists of four MATLAB scripts that implement and analyze voice signal processing, amplitude modulation (AM), frequency modulation (FM), and their performance under different conditions, including noise. The project includes visualization of time and frequency domains, audio playback, and user interaction for input selection.
Author: Basel DawoudDate: May 20, 2025Course: Communications SystemsDescription: Voice recording, filtering, AM (DSB-LC, DSB-SC, SSB-SC) modulation/demodulation, FM modulation/demodulation, and noise performance analysis with spectrum visualization.
Project Structure
The project is divided into four main parts, each implemented in a separate MATLAB script:

Part1.m: Voice signal processing, low-pass filtering, and AM (DSB-LC) modulation with envelope detection.

Features: GUI-based folder/file selection, live recording or file upload, time/frequency domain plots, and audio playback.
Key Steps:
Record or upload voice/audio.
Apply low-pass filtering at various cutoff frequencies (3400 Hz, 2000 Hz, 1000 Hz, 100 Hz, 50 Hz, 10 Hz).
Perform DSB-LC modulation and envelope detection.
Visualize signals in time (blue) and frequency (red, magnitude in dB, unwrapped phase in degrees) domains.
Save plots and audio files.




Part2.m: DSB-SC and SSB-SC modulation and coherent demodulation.

Features: Upsampling, modulation with a 48 kHz carrier, coherent detection, and frequency offset experiments.
Key Steps:
Load filtered voice from Part 1.
Perform DSB-SC and SSB-SC modulation.
Apply coherent demodulation with and without frequency offsets (10 Hz, 50 Hz, 100 Hz).
Plot time and frequency domains and save audio outputs.




Part3.m: FM modulation and demodulation.

Features: FM modulation of voice and a 3 kHz tone, varying modulation indices (β = 0.5, 1, 3, 5).
Key Steps:
Load filtered voice from Part 1.
Perform FM modulation with different β values.
Demodulate using phase differentiation and low-pass filtering.
Generate FM modulation for a 3 kHz tone and visualize spectra.
Save plots and audio outputs.




Part4.m: FM performance in noise and threshold effect analysis.

Features: Adds Gaussian noise to FM signals, evaluates demodulation performance, and identifies the threshold effect.
Key Steps:
Modulate a 3 kHz tone with β = 1 and 5.
Add Gaussian noise at SNR levels (20 dB, 10 dB, 5 dB, 0 dB).
Analyze demodulation performance and plot results.
Investigate the threshold effect by varying β at a fixed SNR (5 dB).





Requirements

MATLAB: Version R2018a or later (with Signal Processing Toolbox and Audio Toolbox).
Hardware: Microphone for live recording (optional, as pre-recorded files can be used).
Operating System: Windows, macOS, or Linux.
Storage: Ensure sufficient disk space for saving audio files and plots (e.g., in the specified base directory).

Installation

Clone or download the repository to your local machine.
Ensure MATLAB is installed with the required toolboxes (Signal Processing, Audio).
Place the scripts (Part1.m, Part2.m, Part3.m, Part4.m) in a working directory.
Create a base directory (e.g., G:\Faculty\2nd Sem Communication\Communication Systems\Project\) for saving output files.

Usage

Run Part1.m:

Select a folder to save results using the GUI.
Choose to record live audio or upload a .wav or .mp3 file (5–10 seconds duration).
The script processes the audio, applies filtering, performs DSB-LC modulation, and saves plots/audio.
Note: Ensure the audio file duration is between 5 and 10 seconds to avoid errors.


Run Part2.m:

Ensure filtered_voice.wav from Part 1 is in the base directory.
The script performs DSB-SC and SSB-SC modulation/demodulation and tests frequency offsets.
Outputs include time/frequency plots and audio files.


Run Part3.m:

Requires filtered_voice.wav from Part 1.
Performs FM modulation/demodulation for voice and a 3 kHz tone with varying β.
Saves time/frequency plots and audio outputs.


Run Part4.m:

Analyzes FM performance under noise for a 3 kHz tone.
Generates plots for different β and SNR values and detects the threshold effect.
Outputs are saved as plots in the base directory.



Notes

File Paths: Update the baseDir variable in Part2.m, Part3.m, and Part4.m to match your local directory structure if different from the default.
Audio Playback: Ensure speakers or headphones are connected for audio output.
GUI Interaction: Part 1 uses GUI prompts (uigetdir, uigetfile, menu) for user input.
Dependencies: The awgn_local and fm_demodulate functions are defined in Part4.m. No external dependencies are required beyond MATLAB toolboxes.
Output Files: Plots are saved as .png, and audio files as .wav in the specified base directory.

Output Files

Part 1:
Original_Signal.png, Filtered_Signal.png, Part1_Step4_Time_Domain.png, Part1_Step4_Frequency_Domain.png, Part1_Step5_Original_Sounds.png, Part1_Step5_Time_Domain.png, Part1_Step5_Frequency_Domain.png, Modulated_Signal.png, Recovered_Message.png, Demodulated_Signal_Time_Freq.png
original_voice.wav, speech_sounds.wav, modulated_signal.wav, recovered_message.wav, recovered_message_scaled.wav


Part 2:
DSB_SC_Time_Spectrum.png, DSB_SC_Recovered_Time_Spectrum.png, SSB_SC_Modulated_Time_Spectrum.png, SSB_SC_Recovered_Time_Spectrum.png


Part 3:
FM_Modulated_Signals.png, FM_Demodulated_Signal.png, FM_Tone_Time.png, FM_Tone_Spectrum.png


Part 4:
FM_Noise_Comparison.png



Troubleshooting

Error: "No file selected": Ensure a valid .wav or .mp3 file is selected when prompted.
Error: "Audio too short": Use an audio file with a duration of 5–10 seconds.
File Not Found: Verify that filtered_voice.wav exists in the base directory before running Parts 2–3.
Plot Issues: Ensure MATLAB's plotting functions are not interrupted, and the base directory has write permissions.

License
This project is for educational purposes and is not licensed for commercial use. All code is provided as-is for academic exploration in communications systems.
