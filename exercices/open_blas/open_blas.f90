program main
	
	implicit none
	integer, parameter :: N = 8192
	integer :: i, j, t1, t2, rate
	real(kind=8) :: alpha, beta
	real(kind=8), allocatable :: A(:,:), B(:,:), C(:,:)
	allocate(A(N,N))
	allocate(B(N,N))
	allocate(C(N,N))
	
	do i=1, N
		do j=1,N
			A(j,i) = i*0.01 + j*0.2;
			B(j,i) = i*0.2 - j*0.01;
			C(j,i) = 0.0;
		end do
	end do
	
	alpha = 1.0
	beta = 0.0
	
	call system_clock(t1, rate)
	
	!OpenBLAS matrix multiplication
	call dgemm('N','N', N, N, N, alpha, A, N, B, N, beta, C, N)
	
	call system_clock(t2, rate)
	write(*,*) "Compute time OpenBLAS:", real(t2-t1)/rate, "sec"
	
	write(*,*) C(N/2, N/2)

	call system_clock(t1, rate)
	!Fortran matmul comparison
	C = matmul(A,B)
	
	call system_clock(t2, rate)
	write(*,*) "Compute time matmul:", real(t2-t1)/rate, "sec"
	
	write(*,*) C(N/2, N/2)

end program
