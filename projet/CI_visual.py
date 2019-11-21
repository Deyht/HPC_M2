import numpy as np
from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.animation

#data = np.loadtxt("nbody_out.dat") #out1 0.01 10.0

nb_part = 2048
omega = 0.01
dt = 0.1
end_t = 20.0

Writer = matplotlib.animation.writers['ffmpeg']
writer = Writer(fps=30, metadata=dict(artist='Me'), bitrate=1800)


CI_part = np.zeros((nb_part,3)) #r,theta,z
data = np.zeros([nb_part*int(end_t/dt),3])

for i in range (0,nb_part):
	while True:
		x = np.random.uniform()*2 - 1.0
		y = np.random.uniform()*2 - 1.0
		z = np.random.uniform()*2 - 1.0
		if((x*x + y*y + z*z) < 1.0):
			break;
	CI_part[i,:] = (np.sqrt(x*x+y*y),2*np.arctan(y/x),z);

for i in range(0,int(end_t/dt)):
	data[i*nb_part:(i+1)*nb_part,0] = CI_part[:,0] * np.cos(CI_part[:,1]+i*omega) 
	data[i*nb_part:(i+1)*nb_part,1] = CI_part[:,0] * np.sin(CI_part[:,1]+i*omega) 
	data[i*nb_part:(i+1)*nb_part,2] = CI_part[:,2]


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

ani.save("test.mp4", writer = writer)

plt.show()
