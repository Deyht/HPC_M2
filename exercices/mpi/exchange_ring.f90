program main

	USE MPI
	IMPLICIT NONE
	 
	integer :: nb_procs, rank, error, next, prev, recv1, recv2, tag1, tag2
	integer, dimension(4) :: reqs
	integer, dimension(MPI_STATUS_SIZE,4) :: stats
	 
	call MPI_INIT(error)
	tag1 = 1
	tag2 = 2
	 
	call MPI_COMM_SIZE(MPI_COMM_WORLD, nb_procs, error)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, error)
	
	prev = rank - 1
	next = rank + 1
	if(rank == 0) then
		prev = nb_procs - 1
	endif
	if(rank == nb_procs - 1) then
		next = 0
	endif
	
	call MPI_IRECV(recv1, 1, MPI_INTEGER, prev, tag1, MPI_COMM_WORLD, reqs(1), error)
	call MPI_IRECV(recv2, 1, MPI_INTEGER, next, tag2, MPI_COMM_WORLD, reqs(2), error)
	
	call MPI_ISEND(rank, 1, MPI_INTEGER, prev, tag2, MPI_COMM_WORLD, reqs(3), error)
	call MPI_ISEND(rank, 1, MPI_INTEGER, next, tag1, MPI_COMM_WORLD, reqs(4), error)
	
	
	call MPI_WAITALL(4, reqs, stats, error)
	
	print *, 'Processus ', rank, ' a recut ', recv1, 'et', recv2
	
	call MPI_FINALIZE(error)

end program main



