import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.animation

data = np.loadtxt("nbody_out.dat") #out1 0.01 10.0

nb_part = 4096
dt = 0.01
end_t = 10.0

def update_graph(num):
	val = data[num*nb_part:(num+1)*nb_part]
	graph._offsets3d = (val[:,0], val[:,1], val[:,2])
	title.set_text("t = " + str(num*dt+dt/2.0) +"/" +str(end_t))

fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")
title = ax.set_title("t =")

val = data[0:nb_part]
graph = ax.scatter(val[:,0], val[:,1], val[:,2], s=0.5)


ani = matplotlib.animation.FuncAnimation(fig, update_graph, int(end_t/dt), interval=8, blit=False)

plt.show()
