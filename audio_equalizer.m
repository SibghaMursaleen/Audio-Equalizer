% Audio Equalizer with GUI in MATLAB
clear all; close all; clc;

% Load WAV file
wavFile = 'sample.wav'; 
[audio, Fs] = audioread(wavFile);
if size(audio, 2) > 1
    audio = mean(audio, 2); 
end

% Initial gain values
bassGain = 1.0;
midGain = 1.0;
trebleGain = 1.0;

% Design IIR filters (improved with sharper cutoff)
dBass = designfilt('bandpassiir', 'FilterOrder', 10, ...
    'HalfPowerFrequency1', 20, 'HalfPowerFrequency2', 250, ...
    'SampleRate', Fs, 'DesignMethod', 'butter');

dMid = designfilt('bandpassiir', 'FilterOrder', 10, ...
    'HalfPowerFrequency1', 250, 'HalfPowerFrequency2', 4000, ...
    'SampleRate', Fs, 'DesignMethod', 'butter');

dTreble = designfilt('bandpassiir', 'FilterOrder', 10, ...
    'HalfPowerFrequency1', 4000, 'HalfPowerFrequency2', 20000, ...
    'SampleRate', Fs, 'DesignMethod', 'butter');

% Create GUI
fig = figure('Name', 'Audio Equalizer', 'Position', [100, 100, 600, 400]);

% Sliders
uicontrol('Style', 'text', 'Position', [50, 350, 100, 20], 'String', 'Bass Gain (0-2)');
bassSlider = uicontrol('Style', 'slider', 'Position', [50, 320, 100, 20], ...
    'Min', 0, 'Max', 2, 'Value', bassGain, 'Callback', @updateGains);

uicontrol('Style', 'text', 'Position', [200, 350, 100, 20], 'String', 'Mid Gain (0-2)');
midSlider = uicontrol('Style', 'slider', 'Position', [200, 320, 100, 20], ...
    'Min', 0, 'Max', 2, 'Value', midGain, 'Callback', @updateGains);

uicontrol('Style', 'text', 'Position', [350, 350, 100, 20], 'String', 'Treble Gain (0-2)');
trebleSlider = uicontrol('Style', 'slider', 'Position', [350, 320, 100, 20], ...
    'Min', 0, 'Max', 2, 'Value', trebleGain, 'Callback', @updateGains);

% Button
uicontrol('Style', 'pushbutton', 'Position', [250, 280, 100, 30], ...
    'String', 'Process & Play', 'Callback', @processAudio);

% Frequency response plot
axFreq = axes('Position', [0.1, 0.1, 0.8, 0.35]);

% Store variables
setappdata(fig, 'audio', audio);
setappdata(fig, 'Fs', Fs);
setappdata(fig, 'dBass', dBass);
setappdata(fig, 'dMid', dMid);
setappdata(fig, 'dTreble', dTreble);
setappdata(fig, 'bassSlider', bassSlider);
setappdata(fig, 'midSlider', midSlider);
setappdata(fig, 'trebleSlider', trebleSlider);
setappdata(fig, 'axFreq', axFreq);
setappdata(fig, 'bassGain', bassGain);
setappdata(fig, 'midGain', midGain);
setappdata(fig, 'trebleGain', trebleGain);

% Plot frequency response
updateFreqResponse();

% --- Callback Functions ---

function updateGains(~, ~)
    bassGain = get(getappdata(gcf, 'bassSlider'), 'Value');
    midGain = get(getappdata(gcf, 'midSlider'), 'Value');
    trebleGain = get(getappdata(gcf, 'trebleSlider'), 'Value');
    setappdata(gcf, 'bassGain', bassGain);
    setappdata(gcf, 'midGain', midGain);
    setappdata(gcf, 'trebleGain', trebleGain);
    updateFreqResponse();
end

function processAudio(~, ~)
    % Retrieve data
    audio = getappdata(gcf, 'audio');
    Fs = getappdata(gcf, 'Fs');
    dBass = getappdata(gcf, 'dBass');
    dMid = getappdata(gcf, 'dMid');
    dTreble = getappdata(gcf, 'dTreble');
    bassGain = getappdata(gcf, 'bassGain');
    midGain = getappdata(gcf, 'midGain');
    trebleGain = getappdata(gcf, 'trebleGain');

    % Apply filters with gains
    bassOut = filter(dBass, audio) * bassGain;
    midOut = filter(dMid, audio) * midGain;
    trebleOut = filter(dTreble, audio) * trebleGain;

    % Combine and normalize output
    output = bassOut + midOut + trebleOut;
    output = output / max(abs(output)); % Normalize

    % Save and play
    audiowrite('output.wav', output, Fs);
    sound(output, Fs);

    % Spectral plot
    figure('Name', 'Input vs Output Spectra');
    subplot(2,1,1);
    [Pxx, f] = periodogram(audio, [], [], Fs);
    plot(f, 10*log10(Pxx)); title('Input Spectrum'); xlabel('Hz'); ylabel('Power (dB)'); grid on;

    subplot(2,1,2);
    [PxxOut, fOut] = periodogram(output, [], [], Fs);
    plot(fOut, 10*log10(PxxOut), 'r'); title('Output Spectrum'); xlabel('Hz'); ylabel('Power (dB)'); grid on;
end

function updateFreqResponse()
    Fs = getappdata(gcf, 'Fs');
    dBass = getappdata(gcf, 'dBass');
    dMid = getappdata(gcf, 'dMid');
    dTreble = getappdata(gcf, 'dTreble');
    bassGain = getappdata(gcf, 'bassGain');
    midGain = getappdata(gcf, 'midGain');
    trebleGain = getappdata(gcf, 'trebleGain');
    ax = getappdata(gcf, 'axFreq');

    [hBass, f] = freqz(dBass, 1024, Fs);
    hMid = freqz(dMid, 1024, Fs);
    hTreble = freqz(dTreble, 1024, Fs);

    axes(ax); cla;
    plot(f, 20*log10(abs(hBass)*bassGain), 'b', 'DisplayName', 'Bass'); hold on;
    plot(f, 20*log10(abs(hMid)*midGain), 'g', 'DisplayName', 'Mid');
    plot(f, 20*log10(abs(hTreble)*trebleGain), 'r', 'DisplayName', 'Treble');
    title('Filter Frequency Response'); xlabel('Frequency (Hz)'); ylabel('Gain (dB)');
    grid on; legend('show');
    set(gca, 'XScale', 'log'); xlim([20 20000]);
end
