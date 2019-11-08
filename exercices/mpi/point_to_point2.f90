program main

	USE MPI
	IMPLICIT NONE
	
	integer :: nb_procs, rank, error, target_rank
	integer, dimension(MPI_STATUS_SIZE) :: stat
	integer :: requete
	!integer :: requete2
	real, dimension(4) :: send, recv;
	integer, dimension(:), allocatable :: seed
	integer :: n
	
	call MPI_INIT(error)
	
	call MPI_COMM_SIZE(MPI_COMM_WORLD, nb_procs, error)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, error)
	
	target_rank = abs(rank - (nb_procs-1))
	
	call RANDOM_SEED(size = n)
	allocate(seed(n))
	seed = rank
	call RANDOM_SEED(PUT = seed)
	call RANDOM_NUMBER(send)
	deallocate(seed)
	
	print *,'Processus numero', rank, 'a pour cible', target_rank, 'et contient', send
	
	call MPI_ISEND(send, 4, MPI_REAL, target_rank, rank, MPI_COMM_WORLD, requete, error)
	call MPI_RECV(recv, 4, MPI_REAL, target_rank, target_rank, MPI_COMM_WORLD, stat, error)

	! alternative entierement non bloquante
	! call MPI_IRECV(recv, 4, MPI_REAL, target_rank, target_rank, MPI_COMM_WORLD, requete2, error)
	
	!call MPI_WAIT(requete, stat, error)
	!call MPI_WAIT(requete2, stat, error)

	print *,'Processus numero', rank, 'de la part de ', target_rank, 'a recu', recv

	call MPI_FINALIZE(error)

end program main
