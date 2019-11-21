program nbody
	implicit none

	integer, parameter :: nb_p = 4096
	real(kind=8), parameter :: eps = 0.06, dt = 0.01, end_t = 10.0

	real(kind=8) :: t = 0.0, m_p = 1.0/nb_p, dt_2 = dt/2., r, fact, Ep, Ec
	real(kind=8), dimension(3,nb_p) :: pos, vit, acc  
	integer :: i, j, k, l
	
	open(unit = 10, file="nbody_out.dat")
	!WARNING this file could be big depending on simulation setup
	open(unit = 11, file="nbody_energy.dat")
	
	!##########################################
	!              INITIALISATION
	!##########################################
	
	do i = 1, nb_p
		do
			call random_number(pos(:,i))
			pos(:,i) = pos(:,i)*2.0 - 1.0
			if (sum(pos(:,i)*pos(:,i)) < 1.0) then
				exit
			end if
		end do
	end do
	
	!Initialise position based on solid rotation
	vit(1,:) = -pos(2,:)
	vit(2,:) = pos(1,:)
	vit(3,:) = 0.0
	
	!Shift initial position of dt_2 for leapfrog integrator
	pos(:,:) = pos(:,:) + vit(:,:)*dt_2
	t = t + dt_2
	
	
	!##########################################
	!            MAIN LOOP ON TIME
	!##########################################
	
	!$OMP PARALLEL PRIVATE(i,j,r,fact)
	do while (t < end_t)
		!$OMP SINGLE
		write(*,*) "Time :", t, "/ :", end_t
		acc(:,:) = 0.0
		Ep = 0.0
		Ec = 0.0
		!$OMP END SINGLE
		
		!$OMP DO reduction(+:Ep)
		do i = 1, nb_p
			do j = 1, nb_p
			
				if(j == i) then
					cycle
				end if
			
				r = sqrt(sum( (pos(:,i)-pos(:,j))*(pos(:,i)-pos(:,j)) ) + eps*eps)
				fact = m_p/(r*r*r)
				
				acc(:,i) = acc(:,i) + fact*(pos(:,j)-pos(:,i))
				Ep = Ep - m_p*fact*r*r
				
			end do
		end do
		!$OMP END DO
		
		!$OMP SINGLE
		Ep = 0.5 * Ep
		vit(:,:) = vit(:,:) + acc(:,:)*dt_2
		Ec = Ec + 0.5*m_p*sum(vit(:,:)*vit(:,:))
		vit(:,:) = vit(:,:) + acc(:,:)*dt_2
		
		pos(:,:) = pos(:,:) + vit(:,:)*dt
		
		do i = 1, nb_p
			write(10,*) pos(:,i)
		end do
		write(11,*) t, Ec, Ep
		
		t = t + dt
		!$OMP END SINGLE
	end do
	!$OMP END PARALLEL
	
	close(10)
	close(11)

end program nbody












