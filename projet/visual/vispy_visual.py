import numpy as np

from vispy import app, visuals, scene, gloo

nb_part = 16384
dt = 0.01
end_t = 40.0
nb_t = int(end_t/dt)/5
i = 0

data = np.loadtxt("../nbody_out.dat")       


# build your visuals, that's all
Scatter3D = scene.visuals.create_visual_node(visuals.MarkersVisual)

# The real-things : plot using scene
# build canvas
canvas = scene.SceneCanvas(keys='interactive', show=True)

# Add a ViewBox to let the user zoom/rotate
view = canvas.central_widget.add_view()
view.camera = 'turntable'
view.camera.fov = 70
view.camera.distance = 3
axis = scene.visuals.XYZAxis(parent=view.scene)

# plot ! note the parent parameter
p1 = Scatter3D(parent=view.scene)
p1.set_gl_state('translucent', blend=True, depth_test=True)
p1.set_data(data[0:nb_part,:], face_color="white", symbol='o', size=2,
            edge_width=0.5, edge_color='k')


def update(ev):
	global i
	i += 1
	if(i >= nb_t):
		i = 0
	p1.set_data(data[i*(nb_part):(i+1)*nb_part,:], face_color="white", symbol='o', size=2, edge_width=0.5, edge_color='k')

timer = app.Timer()
timer.connect(update)
timer.start(0.04, -1)  # interval, iterations

canvas.show()
app.run()

	


