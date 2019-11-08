program main
	real, dimension(4) :: send
	integer, dimension(:), allocatable :: seed
	integer :: n, rank, clock
	call SYSTEM_CLOCK(count=clock)
	call RANDOM_SEED(size = n)
	allocate(seed(n)); seed = clock
	call RANDOM_SEED(PUT = seed)
	call RANDOM_NUMBER(send)
	deallocate(seed)
	print *, send
end program main
