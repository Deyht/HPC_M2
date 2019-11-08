program main

	USE MPI
	IMPLICIT NONE
	
	integer :: nb_procs, rank, error, target_rank
	integer, dimension(MPI_STATUS_SIZE) :: stat
	real, dimension(4) :: send, recv;
	integer :: tag1, tag2
	integer, dimension(:), allocatable :: seed
	integer :: n
	
	call MPI_INIT(error)
	tag1 = 1
	tag2 = 2
	
	call MPI_COMM_SIZE(MPI_COMM_WORLD, nb_procs, error)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, error)
	
	call RANDOM_SEED(size = n)
	allocate(seed(n))
	seed = rank
	call RANDOM_SEED(PUT = seed)
	call RANDOM_NUMBER(send)
	deallocate(seed)
	
	if(rank == 0) then
		call MPI_SEND(send, 4, MPI_REAL, 1, tag1, MPI_COMM_WORLD, error)
		call MPI_RECV(recv, 4, MPI_REAL, 1, tag2, MPI_COMM_WORLD, stat, error)
	endif
	if(rank == 1) then
		call MPI_RECV(recv, 4, MPI_REAL, 0, tag1, MPI_COMM_WORLD, stat, error)
		call MPI_SEND(send, 4, MPI_REAL, 0, tag2, MPI_COMM_WORLD, error)
	endif

	if(rank < 2) then
		print *,'Processus numero', rank, 'a envoye', send, 'et a recu', recv
	else
		print *,'Processus numero', rank, 'ne fait rien'
	endif
	
	call MPI_FINALIZE(error)

end program main
