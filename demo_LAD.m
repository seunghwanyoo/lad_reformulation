% OLS_vs_LAD - wrapper containing simple experiment and comparison of
% (Ordinary) Least Squares and Least Absolute Deviations.
%
% The experiment: A number of points is generated approximately on
% the line y = x.  A small number of the points then have a large noise
% added to them so that they can be considered outliers.  Least Squares and
% Least Absolute Deviations are then applied to fit linear models to the
% data and are compared in print outs.
%
% LS : min_x ||Ax-b||2
% LAD: min_x ||Ax-b||1
%
% Written by Jeremy Watt
% Modified by Seunghwan Yoo

clear;
%%% Variables to play with %%%
num_pts = 20;      % Number of points for experiment
num_outliers = 5;  % Number of outliers (to make from original pts)

% Generate points on the line y=x with small noise added
x_in = sort(randn(num_pts,1));
eps = 1/10*randn(num_pts,1);
y_in = x_in + eps;

% Generate outlier points
outliers = randsample(length(y_in),num_outliers);
out_vals = randsample(4:7,num_outliers,'true').*randsample(-1:2:1,num_outliers,'true');
y_in(outliers) = y_in(outliers) + out_vals';


%% Generate LS coeff
xls = pinv(x_in'*x_in)*x_in'*y_in;


%% Generate LAD coeff 
% Setup reformulated LP variables
A = x_in;
b = y_in;

% LAD-TO-LP REFORMULATION with suppression trick
len_x = size(A,2);
c = [zeros(len_x,1);ones(size(b))];
F = [A -eye(size(b,1)); -A -eye(size(b,1))];
g = [b; -b];
%F = [A -eye(size(b,1)); -A -eye(size(b,1));zeros(size(A)) -eye(size(b,1))];
%g = [b ; -b; zeros(length(b),1)];

% Run the LP solver
z = linprog(c,F,g);
xlad = z(1);


%% Plot points 
figure,
plot(x_in,y_in,'o','MarkerFaceColor','b','MarkerEdgeColor','b')
hold on
p = zeros(3,3);

% Plot true line
x_line = -2.5:.1:2.5;
y_line = x_line;
p(:,1) = plot(x_line,y_line,'--r');
set(p(:,1),'LineWidth',1)
hold on

% Plot LS Line
x_line = -2.5:.1:2.5;
y_line = xls*x_line;
p(:,2) = plot(x_line,y_line,'m');
set(p(:,2),'LineWidth',1.2)
hold on

% Plot LAD Line
x_line = -2.5:.1:2.5;
y_line = xlad*x_line;
p(:,3) = plot(x_line,y_line,'g');
set(p(:,3),'LineWidth',1.2)
legend(p(1,:), {'Original','LS','LAD'})


