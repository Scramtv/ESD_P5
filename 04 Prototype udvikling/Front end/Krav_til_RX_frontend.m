clc
clear all;
close all;

samp = 61.44e6;
disp("Samp rate")
disp(samp/2)


R = 2483.5e6- 2400.00e6 ;
disp("Range")
disp(R)

B_Size = R/3;

B1 = 2400.00e6 + B_Size;
disp("bucket one size")
disp(num2str(B1, '%.2f'))
disp("cent freq")
CF = ((B_Size)/2)+2400.00e6;
disp(num2str(CF))



B2 = B1 + B_Size;
disp("bucket two size")
disp(num2str(B2, '%.2f'))
disp("cent freq")
CF = ((B_Size)/2)+B1;
disp(num2str(CF))
BP = (B2-B1);
disp("BP")
disp(num2str(BP, '%.2f'))




B3 = B2 +B_Size;
disp("bucket three size")
disp(num2str(B3, '%.2f'))
disp("cent freq")
CF = ((B_Size)/2)+B2;
disp(num2str(CF))

