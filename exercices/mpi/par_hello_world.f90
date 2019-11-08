program main

	USE MPI
	implicit none
	
	integer :: nb_procs, rang, error

	call MPI_INIT(error)

	call MPI_COMM_SIZE(MPI_COMM_WORLD, nb_procs, error)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rang, error)
	
	print *, 'Je suis le processus', rang, 'parmi', nb_procs

	call MPI_FINALIZE(error)
	
end program main
