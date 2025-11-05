import numpy as np
c = 3e8
f = 2.4e9
D = 0.04088
wavelength = c/f

d_f = (float(2)*D*D)/wavelength
print(wavelength)

print(d_f)