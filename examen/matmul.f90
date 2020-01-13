
program main

	implicit none
	real(kind=8), allocatable :: A(:,:), B(:,:), C(:,:)
	integer, parameter :: m = 1024, n = 2048, o = 1024, max_incr=10
	integer :: i, j, k, l
	real(kind=8) :: fact = 0.9
	
	!####################### #######################
	!              Matrice initialization 
	!####################### #######################
	allocate(A(m,n), B(n,o), C(m,o))
	
	do i = 1, n
		do j = 1, m
			A(j,i) = 0.0001*i*j
		end do
	end do
	
	
	do i = 1, o
		do j = 1, n
			B(j,i) = 0.0001*(i+j)
		end do
	end do
	
	C(:,:) = 0.0
	
	
	!####################### #######################
	!               Incremental loop
	!####################### #######################	
	do l = 1, max_incr

		C(:,:) = fact*C(:,:)
	
		!####################### #######################
		!  				  Calcul loop
		!####################### #######################
		do i = 1, o
			do k = 1, n
				do j = 1, m
					C(j,i) = C(j,i) + A(j,k)*B(k,i)
				end do
			end do
		end do

		! Show the progress of the program
		if(mod(l,20) == 0) then
			write(*,*) "Step :", l, "/", max_incr
		end if
		
	end do
	
	! Control variable for parallelisation
	write(*,*) C(m/2,o/2)
	

end program main
