% Readable export of the original MATLAB Live Script.
% Only input/output paths were adapted for this repository.
% 1. Read the Data from Excel
projectRoot = fileparts(fileparts(mfilename('fullpath')));
filename = fullfile(projectRoot, 'data', 'WT S.B Growth Curve Data.xlsx');
if ~exist(fullfile(projectRoot, 'output'), 'dir')
    mkdir(fullfile(projectRoot, 'output'));
end % replace with your file path
[data, text] = xlsread(filename, 3); % Read from the third sheet

time = data(:, 1); % Time data from column A
conditions = data(:, 2:5); % OD values for the 2 sugar conditions

% 2. Define the Colors for Plotting
colors = ['b', 'r']; % Colors for groups A&B, C&D

% 3.1 Calculate Standard Deviations
numGroups = 2; % Since you have 8 columns and want to group every two columns
stdValues = zeros(length(time), numGroups); % Pre-allocate for efficiency

for i = 1:numGroups
    col1 = conditions(:, 2*i-1); % First column of the group
    col2 = conditions(:, 2*i);   % Second column of the group
    stdValues(:, i) = std([col1, col2], 0, 2); % Standard deviation along rows
end

% 3.2 Plot the Growth Curves with Connected Dots and Error Bars
figure;
hold on;

for i = 1:numGroups
    groupMean = mean([conditions(:, 2*i-1), conditions(:, 2*i)], 2); % Average for each time point
    errorbar(time, groupMean, stdValues(:, i), '-o', 'Color', colors(i), 'MarkerSize', 1, 'LineWidth', 2.5);
end

% Custom legend with dummy plots
h(1) = plot(NaN,NaN,'-b', 'MarkerSize', 1, 'LineWidth', 2.5); % dummy plot for A & B
h(2) = plot(NaN,NaN,'-r', 'MarkerSize', 1, 'LineWidth', 2.5); % dummy plot for C & D
legendEntries = {
    [text{1, 2}];
    [text{1, 4}]
};

legend(h, legendEntries, 'Location', 'northwest');

% 4. Customize the Graph
%title('S.B Growth Curve under Different Temperature Conditions');
xlabel('Time(h)');
ylabel('OD Values');
ylim([0 18]); % Set y-axis limits from 0 to 18
grid on;

% Set x-axis limits and ticks
xlim([0 48]);
xticks(0:12:48);

% 5. Save the Graph (optional)
saveas(gcf, fullfile(projectRoot, 'output', 'WT_S.B_growth_curve_plot_temp.png')); % saves the graph as a PNG image
