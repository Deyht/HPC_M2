program main
	implicit none

	integer :: omp_get_num_threads, omp_get_thread_num
	integer :: i, ind, limit
	real :: val
	real :: rand

	i = 0
	limit = 4
	val = 1.4
	
	!$OMP PARALLEL SHARED(limit, val) private(i, ind)
	ind = omp_get_thread_num()
	
	do i = 0, limit
		write(*,*) "Core", ind, "loop state", i, "/", limit
	end do

	val = val + 1	

	!$OMP END PARALLEL

	write(*,*) "val = ", val, "/ i = ", i, "ind = ", ind
end program main
