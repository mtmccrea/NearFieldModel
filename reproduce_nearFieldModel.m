%% Distance rendering and perception of nearby virtual sound sources with a near-field filter model
% by S. Spagnol, E. Tavazzi, and F. Avanzini
% in Applied Acoustics, vol. 115, pp. 61-73, Jan. 2017.
%
% *Reproduce in Code*
% (c) Sebastian Jiro Schlecht:  20. November 2018
% Modification of visualization, Michael McCrea, April 2020

%% Introduction
% In this tutorial, we reproduce Fig. 1. However in contrast to the
% publication, we use the filter approximation suggest in the paper.

%% Initialization
clear; clc; close all;
fftSize = 2^12;

addpath('/Users/dyne/src/NearFieldModel'); %TODO: generalize

%% Create plots
rhos = [1.25, 1.5, 2.0, 4.0];
dirs = 0:5:180;
hlEvery = 6;
fs = 48000;

ndirs = length(dirs);
nrhos = length(rhos);

% set up colors
cols = repmat(0.5*[1 1 1], ndirs, 1);
numhls = floor(ndirs/hlEvery);
hlcols = genColors(0.1, 0.1, numhls, 0.97);
hlixs = 1:hlEvery:ndirs;
for i = 1:numhls
    cols(hlixs(i),:) = hlcols(i, :);
end

figure(1);
set(gcf,'pos',[10 10 900 400])
for pltix = 1:nrhos
    H = [];
    rho = rhos(pltix);
    for alpha = deg2rad(dirs)
        % Compute filter 
        [num,den] = nearFieldModel(alpha, rho, fs);
        [H(:,end+1),w] = freqz(num, den, fftSize, fs);
    end
    
    % plot
    subplot(1, length(rhos), pltix);
    hold on; grid on;
    plt = plot(w, mag2db(abs(H)));
    yline(0, '--r', 'LineWidth', 1.2); % horiz line at 0 dB
    set(gca,'XScale','log');
    
    % line properties
    hllines = findobj(gcf, 'type', 'line');
    set(hllines(hlixs), 'LineWidth',2);
    set(plt(hlixs), 'LineWidth', 2);
    colororder(cols);
    
    % labels, legend
    if pltix == 1
        ylabel('Magnitude [dB]');
    elseif pltix == nrhos
        legend(plt(hlixs), sprintfc('%d',dirs(hlixs)));
    end
    title(['\rho = ' num2str(rho)]) 
    xlabel('Frequency [Hz]');
    
    % axes span
    xlim([50 15000]);
    ylim([-20 20]);
end
