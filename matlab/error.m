close all;
clear all;
clc;
resultsc = importdata('resultsc.txt')';
results_la = importdata('results_la.txt')';
results= importdata('results.txt')';
resultsm = importdata('resultsm.txt')';
resultsc_rid = resultsc(1:198);
er = resultsc_rid - results_la;
sum_err = sum(er);
r = thd(results_la);
ind= 0:1:200;
ind_la = 0:1:197;

%% plots
figure
plot(ind,resultsm,'--d');
hold on
plot(ind,resultsc,'r--s');
plot(ind,results, 'g--+');
plot(ind_la, results_la, 'c--o');
xlabel('n');
ylabel('y[n]');
legend('matlab', 'c', 'iir', 'iir look ahead');
