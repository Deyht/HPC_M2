program main
	
	USE MPI
	IMPLICIT NONE
	integer :: nb_procs, rank, error, i, j
	real, dimension(:,:), allocatable :: sendbuf
	real, dimension(4) :: recvbuf

	call MPI_INIT(error)
	call MPI_COMM_SIZE(MPI_COMM_WORLD, nb_procs, error)
	call MPI_COMM_RANK(MPI_COMM_WORLD, rank, error)
	
	if(rank == 0) then
		allocate(sendbuf(4,nb_procs), stat=error)
		if( error /= 0) then
			print *, 'Erreur allocation'
			stop
		endif
		do i = 1, nb_procs
			do j = 1, 4
				sendbuf(j,i) = (i-1)*4 + j
			end do
		end do
	endif
	
	call MPI_SCATTER(sendbuf, 4, MPI_REAL, recvbuf, 4, MPI_REAL, 0, MPI_COMM_WORLD, error)
	
	if(rank == 0) then
		if(allocated(sendbuf)) then
			deallocate(sendbuf)
		endif
	endif
	print *, 'Processus', rank, 'a recut', recvbuf
	
	call MPI_FINALIZE(error)

end program main







