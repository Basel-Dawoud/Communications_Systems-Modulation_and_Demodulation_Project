# Communications Systems Project

This repository contains a comprehensive MATLAB project exploring various modulation and demodulation techniques in communication systems. The project is divided into four parts, each focusing on different aspects of analog communication systems.

## Project Structure

### Part 1: AM Modulation and Demodulation
- **File**: `Part1.m`
- **Description**: 
  - Records or loads voice signals
  - Applies low-pass filtering with various cutoff frequencies
  - Implements AM (DSB-LC) modulation
  - Demonstrates envelope detection for demodulation
  - Includes extensive visualization of time and frequency domains

### Original Signal Analysis
![Original_Signal](https://github.com/user-attachments/assets/5d76d21f-38e2-4395-bd6e-c75d8017ae74)

### Filtered Signal Analysis (3400 Hz Cutoff)
![Filtered_Signal](https://github.com/user-attachments/assets/a0e0eafc-44e3-4a03-9cd3-d590c32481a7)

### Step4: Time-Domain Analysis of Filtered Signals at Various Cutoffs
![Part1_Step4_Time_Domain](https://github.com/user-attachments/assets/a4927cd0-152c-43ab-9b2c-4c9cbbeac6fb)

### Step4: F-Domain Analysis of Filtered Signals at Various Cutoffs
![Part1_Step4_Frequency_Domain](https://github.com/user-attachments/assets/4592adaa-3fcd-424a-a194-d00c36a1b03d)

### Step5: Time Domain
![Part1_Step5_Time_Domain](https://github.com/user-attachments/assets/af17cd87-4753-4c1a-8460-f17b9a837cd4)

### Step5: Frequency_Domain
![Part1_Step5_Frequency_Domain](https://github.com/user-attachments/assets/351ad079-0694-4699-8479-687668e3d2df)

### Step5: Time-Domain Analysis of Filtered Speech Sounds at Various Cutoffs
![Part1_Step5_Time_Domain](https://github.com/user-attachments/assets/4cfdb89c-afb9-4ac6-b455-7b2cdc25e67b)

### Step5: F-Domain Analysis of Filtered Signals at Various Cutoffs
![Part1_Step5_Frequency_Domain](https://github.com/user-attachments/assets/bd93d643-9477-42c2-bc48-283e3bd69748)

## Modulated Signal
![Modulated_Signal](https://github.com/user-attachments/assets/3da82bac-74ca-442f-abff-c9b8e0ee46a6)

## Recovered Message
![Recovered_Message](https://github.com/user-attachments/assets/27c4a6b6-5c4e-40a4-9360-aee0d51641c6)

## Demodulated Signal in Time & Freq Domains 
![Demodulated_Signal_Time_Freq](https://github.com/user-attachments/assets/bdf42a14-1b11-4743-bd26-117ecd5451f8)

### Part 2: DSB-SC and SSB-SC Modulation
- **File**: `Part2.m`
- **Description**:
  - Implements Double Sideband Suppressed Carrier (DSB-SC) modulation
  - Demonstrates coherent detection with and without frequency offsets
  - Implements Single Sideband (SSB) modulation using Hilbert transform
  - Shows SSB demodulation and sensitivity to frequency offsets


## DSB_SC_Time_Spectrum
![DSB_SC_Time_Spectrum](https://github.com/user-attachments/assets/4070c223-3820-4dba-9769-0214cf2f9ada)

## DSB_SC_Recovered_Time_Spectrum
![DSB_SC_Recovered_Time_Spectrum](https://github.com/user-attachments/assets/5492072a-cab5-4d08-b60c-8b46aae350df)

## SSB_SC_Modulated_Time_Spectrum
![SSB_SC_Modulated_Time_Spectrum](https://github.com/user-attachments/assets/fe36b4a9-cc9e-4d01-9aaa-c4d3e59405cd)

## SSB_SC_Recovered_Time_Spectrum
![SSB_SC_Recovered_Time_Spectrum](https://github.com/user-attachments/assets/7b1a60e8-2921-4e8f-9755-8c670f63a155)


### Part 3: FM Modulation and Demodulation
- **File**: `Part3.m`
- **Description**:
  - Implements Frequency Modulation (FM) with different modulation indices (β)
  - Demonstrates FM demodulation using phase differentiation
  - Includes experiments with tone modulation to visualize FM characteristics
  - Provides spectral analysis of FM signals


## FM_Modulated_Signal 
![image](https://github.com/user-attachments/assets/bf3f0f75-4f8e-4a9a-a710-2b15e5dfd574)

## FM_Demodulated_Signal 
![FM_Demodulated_Signal](https://github.com/user-attachments/assets/3f514c46-d448-4f78-8f52-1bcf54be0349)


## FM of 3KHz Tone

## Time Domain
![image](https://github.com/user-attachments/assets/23146f50-ae9d-4847-8bcf-dea5daf08df0)

## Frequency Domain
![image](https://github.com/user-attachments/assets/ab2c755e-03d3-4d4b-b25d-51b79a541d9a)


### Part 4: FM Performance in Noise
- **File**: `Part4.m`
- **Description**:
  - Investigates FM performance under different SNR conditions
  - Demonstrates the threshold effect in FM systems
  - Compares performance for different modulation indices
  - Includes custom functions for noise addition and FM demodulation

## Key Features

- **Interactive GUI elements** for file selection and input method choice
- **Comprehensive visualization** including time-domain plots, magnitude spectra, and phase spectra
- **Real-time audio playback** to hear the effects of processing
- **Parameter exploration** with various cutoff frequencies and modulation indices
- **Professional-quality plots** with consistent styling and labeling

## Requirements

- MATLAB R2018b or later
- Signal Processing Toolbox
- Audio System Toolbox (for recording/playback functions)

## Usage

1. Clone the repository
2. Run each part sequentially in MATLAB
3. Follow the on-screen prompts to select input methods and parameters
4. Results will be saved automatically in the selected directory

## FM_Noise_Comparison
![FM_Noise_Comparison](https://github.com/user-attachments/assets/c63c9e5e-2d74-441c-bec0-b1f91ccb6289)


## Results

All generated plots and audio files are automatically saved to a user-selected directory, including:
- Time and frequency domain representations
- Filtered signals at various cutoff frequencies
- Modulated and demodulated signals
- Performance under different noise conditions


## Author

Basel Dawoud - Baseldawoudengineer@gmail.com
