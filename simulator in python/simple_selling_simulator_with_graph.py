import numpy as np
import matplotlib.pyplot as plt
import math
from matplotlib.patches import Polygon

def PolygonArea(corners):
    n = len(corners) # of corners
    area = 0.0
    for i in range(n):
        j = (i + 1) % n
        area += corners[i][0] * corners[j][1]
        area -= corners[j][0] * corners[i][1]
    area = abs(area) / 2.0
    return area

def func(x):
    return x**(1/2)


n = float(input("Enter the amount of token you are selling:"))
s = float(input("Enter the current supply of the token:"))


a, b = s-n, s  # integral limits
x = np.linspace(0, s*2)
y = func(x)

fig, ax = plt.subplots()
ax.plot(x, y, 'r', linewidth=2)
ax.set_ylim(bottom=0)

# Make the shaded region
# Taking 1000000 step to be more accurate for integral
ix = np.arange(a, b, (b-a)/1000000)
iy = func(ix)
verts = [(a, 0), *zip(ix, iy), (b, 0)]
poly = Polygon(verts, facecolor='0.9', edgecolor='0.5')

#calculate AOC with the verticles
area = PolygonArea(verts)
ax.add_patch(poly)

ax.text(0.5 * (a + b), area/(b-a)*0.5, r"$\int_a^b f(x)\mathrm{d}x$="+str(area),
        horizontalalignment='center', fontsize=20)

fig.text(0.9, 0.05, '$x$')
fig.text(0.1, 0.9, '$y$')

ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.xaxis.set_ticks_position('bottom')

ax.set_xticks((a, b))
ax.set_xticklabels(('$a$', '$b$'))
ax.set_yticks([])

print("Amount in USDT you get by integral: " +str(area))
print("The current supply after you sold is: "+str(a))
    
plt.show()
