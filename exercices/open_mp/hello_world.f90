

program main
	implicit none

	integer :: OMP_GET_NUM_THREADS, OMP_GET_THREAD_NUM
	
	!$OMP PARALLEL

	write(*,*) "I am thread", omp_get_thread_num(), "/", omp_get_num_threads()

	!$OMP END PARALLEL

	write(*,*) "Message outside of the parallel region"

end program main
