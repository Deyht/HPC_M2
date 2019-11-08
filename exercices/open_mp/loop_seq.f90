program main
	implicit none
	integer :: i, j, k, dx, dy, dz
	integer, parameter :: v_size = 128, rad = 2
	real, allocatable :: A(:,:,:), B(:,:,:)
	allocate(A(v_size,v_size,v_size))
	allocate(B(v_size,v_size,v_size))

	do i = 1, v_size
		do j = 1, v_size
			do k = 1,v_size
				A(k,j,i) = i+j+k
			end do
		end do
	end do	

	B(:,:,:) = 0.0

	do i = 1+rad, v_size-rad
		do j = 1+rad, v_size-rad
			do k = 1+rad,v_size-rad
				do dx = -rad, rad
					do dy = -rad, rad
						do dz = -rad, rad
							B(k,j,i) = B(k,j,i) + A(k+dz, j+dy, i+dx)
						end do
					end do				
				end do			
			end do
		end do
	end do

	write(*,*) B(v_size/2,v_size/2,v_size/2)
end program main
