clear all;
clc;
resultsc = importdata('resultsc.txt')';
results = importdata('results.txt')';
er = resultsc - results;
sum_err = sum(er)
r = thd(results)