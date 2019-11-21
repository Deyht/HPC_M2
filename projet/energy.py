import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt("nbody_energy.dat")

plt.plot(data[:,0], data[:,1], label="Ec")
plt.plot(data[:,0], data[:,2], label="Ep")
plt.plot(data[:,0], data[:,1] + data[:,2], label="Em")

plt.legend()

plt.show()
