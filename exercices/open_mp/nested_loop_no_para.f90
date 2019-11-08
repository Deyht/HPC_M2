

program main
	implicit none

	integer :: omp_get_num_threads, omp_get_thread_num
	integer, parameter :: m=20000, n=20000
	real, allocatable :: mat(:,:)
	real :: trace
	integer :: i, j
	integer :: t1, t2, rate


	allocate(mat(m,n))

	do i=1, n
		do j=1, m
			mat(j,i) = real(i+j)/(m+n)	
		end do
	end do

	call system_clock(t1, rate)

	
	do j=2, n
		do i=2, m
			mat(i, j) = (mat(i,j) + mat(i-1, j) + mat(i, j-1))/3.0
		end do
	end do

	call system_clock(t2, rate)

	write(*,*) mat(m/2, n/2)
	write(*,*) "Compute time:", real(t2-t1)/rate, "sec"


end program main





