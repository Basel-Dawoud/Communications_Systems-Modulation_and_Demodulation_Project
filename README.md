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

### Original Signal
![Original_Signal](https://github.com/user-attachments/assets/5d76d21f-38e2-4395-bd6e-c75d8017ae74)

### Filtered Signal
![Filtered_Signal](https://github.com/user-attachments/assets/a0e0eafc-44e3-4a03-9cd3-d590c32481a7)


### Part 2: DSB-SC and SSB-SC Modulation
- **File**: `Part2.m`
- **Description**:
  - Implements Double Sideband Suppressed Carrier (DSB-SC) modulation
  - Demonstrates coherent detection with and without frequency offsets
  - Implements Single Sideband (SSB) modulation using Hilbert transform
  - Shows SSB demodulation and sensitivity to frequency offsets

### Part 3: FM Modulation and Demodulation
- **File**: `Part3.m`
- **Description**:
  - Implements Frequency Modulation (FM) with different modulation indices (β)
  - Demonstrates FM demodulation using phase differentiation
  - Includes experiments with tone modulation to visualize FM characteristics
  - Provides spectral analysis of FM signals

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

## Results

All generated plots and audio files are automatically saved to a user-selected directory, including:
- Time and frequency domain representations
- Filtered signals at various cutoff frequencies
- Modulated and demodulated signals
- Performance under different noise conditions

## Author

Basel Dawoud - Baseldawoudengineer@gmail.com
