clc;
clear all;
close all;

azi_table = readtable('Max_speed_azi_motor.txt');

azi_time = azi_table{:,1};
azi_val = azi_table{:,2};


azi_vel = gradient(azi_val, azi_time);

plot(azi_time, azi_vel)