%% Figure generation code for google trend analystics, amazon review tabulation, and ingredient breakdown
% Author: Jeremy Chang
% Team: SCF
% Purpose: PYCPC 2023 Case Competition

% Snuggle (topic) interest over time (smoothed with a 12 week window)
scale_factor = 192000;
data = readmatrix('C:\Users\Jeremy\Downloads\snuggle.csv');
data = data(:, 2);
data = renormalize_data(data, scale_factor);
smoothed_data = smoothdata(data, 'movmean', 12);
plot(smoothed_data, 'LineWidth', 2)
xticks(1:52:260)
xticklabels(2018:2022)
xlabel('Start of calendar year')
ylabel('Searches')
legend('Snuggle (topic)')
curYTick = get(gca,'YTick');
YLabel = cellstr( num2str( curYTick(:), '%d') );
set(gca, 'YTickLabel', YLabel);

%% Normalized annual revenue of Snuggle from 2018 - 2022 vs snuggle interest (smoothed data downsampled by a factor of 52)

yearly_smoothed_data = downsample(smoothed_data, 52);
ann_rev_snuggle = [329005909, 328508413, 325567730, 329174532, 304936541];
plot(ann_rev_snuggle/max(ann_rev_snuggle), 'o-','LineWidth', 2,'MarkerSize', 5)
hold on
plot(yearly_smoothed_data/max(yearly_smoothed_data), 'o-','LineWidth', 2,'MarkerSize', 5)
xticks(1:5)
xticklabels(2018:2022)
xlabel('Year')
ylabel('Normalized value')
legend('Normalized annual revenue of Snuggle fabric finisher category', ...
    'Normalized search volume of Snuggle search topic', 'Location', 'southwest')

%% Keyword search "sunggle scent booster" vs "downy..." vs "gain..."
scale_factor = [500 11000 2100];
data = readmatrix('C:\Users\Jeremy\Downloads\snuggle_vs_competitors.csv');
data = data(:, 2:end);
data = renormalize_data(data, scale_factor);
smoothed_data = smoothdata(data, 'movmean', 12);
plot(smoothed_data, 'LineWidth', 2)
xticks(1:52:260)
xticklabels(2018:2022)
xlabel('Start of calendar year')
ylabel('Searches')
legend('Snuggle', 'Downy', 'Gain', 'Location', 'northwest')

%% Keyword search "scent booster" vs "liquid fabric softener"
scale_factor = [30000 4500];
data = readmatrix('C:\Users\Jeremy\Downloads\scent_vs_softener.csv');
data = data(:, 2:end);
data = renormalize_data(data, scale_factor);
smoothed_data = smoothdata(data, 'movmean', 12);
plot(smoothed_data, 'LineWidth', 2)
xticks(1:52:260)
xticklabels(2018:2022)
xlabel('Start of calendar year')
ylabel('Searches')
legend('Scent booster', 'Liquid fabric softener', 'Location', 'northwest')

%% Amazon reviews
snuggle_labels = ["Pack Exhilirations Blue Iris", "Pack Exhilirations Lavender", ...
    "Pack Exhilirations Island", "Bead Exhilirations Blue Sparkle", "SuperCare Sea Breeze", ...
    "ScentShakes Original", "ScentShakes Spring Burst", "Snuggle Total"];
snuggle = [12926 13819 6370 2570 849 2537 3641];
snuggle(length(snuggle) + 1) = sum(snuggle);
n_snuggle = length(snuggle);

downy_labels = ["Infusions Calm", "Infusions Bliss", "Infusions Refresh", ...
    "Unstoppables Fresh", "Unstoppables Lush", "Unstoppables Tide", ...
    "Light Ocean", "Light Shea", "Light Woodland", "Light White Lavender", ...
    "Cool Cotton", "Fresh Protect", "Downy Total"];
downy = [29794 7080 6657 43898 15117 9660 3570 1944 1231 15117 26322 6329];
downy(length(downy) + 1) = sum(downy);
n_downy = length(snuggle) + length(downy);

gain_labels = ["Super Fresh", "Standard Original", "Standard Moonlight", "Standard Blissful", ....
    "Standard Spring", "Standard Island", "Gain Total"];
gain = [163 78320 24899 2878 297, 2679];
gain(length(gain) + 1) = sum(gain);
n_gain = n_downy + length(gain);

n_products = length([snuggle downy gain]);

%%
cmap = colormap(lines(3));

all_reviews = [snuggle downy gain];
all_review_labels = [snuggle_labels downy_labels gain_labels];
b = bar(all_reviews, 'facecolor', 'flat');
clr = [repmat(cmap(1, :), length(snuggle), 1); repmat(cmap(2, :), length(downy), 1); ...
    repmat(cmap(3, :), length(gain), 1)];
b.CData = clr;
set(gca, 'XTick', [n_snuggle n_downy n_gain], 'XTickLabel', ...
    ["Snuggle Total" "Downy Total" "Gain Total"])
xtickangle(45);
xlabel('Scent boosters')
ylabel('Number of Amazon reviews')
curYTick = get(gca,'YTick');
YLabel = cellstr( num2str( curYTick(:), '%d') );
set(gca, 'YTickLabel', YLabel);

%% Ingredients from Mrs. Meyers Lemon Verbena Scent Booster
labels = ["Plant-derived fragrance" "Synthetic fragrance" "Water softening agent" "Anti-clumping agent" "Fragrance mix (plant + synthetic)"];
colormap winter
proportions = [24/37 9/37 1/37 2/37 1/37];
p = pie(proportions, labels);

%% Renormalization function
function rn_data = renormalize_data(data, scale_factor)
    rn_data = data;
    for i = 1:size(data, 2)
        renormalized_data = (rn_data(:, i)/max(rn_data(:, i)));
        rn_data(:, i) = renormalized_data * scale_factor(i);
    end
end
