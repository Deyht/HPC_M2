program nbody
	implicit none

	integer, parameter :: nb_p = 16384
	real(kind=8), parameter :: eps = 0.04, dt = 0.01, end_t = 40.0
	real(kind=8) :: t = 0.0, m_p = 1.0/nb_p, omega=1.2, dt_2 = dt/2., r, fact, Ep, Ec, pair_acc(3)
	real(kind=8), dimension(3,nb_p) :: pos, vit, acc  
	integer :: i, j, k, l
	
	open(unit = 10, file="nbody_out.dat")
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
	vit(1,:) = -omega*pos(2,:)
	vit(2,:) = omega*pos(1,:)
	vit(3,:) = 0.0
	
	!Shift initial position of dt_2 for leapfrog integrator
	pos(:,:) = pos(:,:) + vit(:,:)*dt_2
	t = t + dt_2
	
	
	!##########################################
	!            MAIN LOOP ON TIME
	!##########################################
	
	!$OMP PARALLEL PRIVATE(i,j,r,fact, pair_acc)
	do while (t < end_t)
		!$OMP SINGLE
		acc(:,:) = 0.0
		Ep = 0.0
		Ec = 0.0
		!$OMP END SINGLE
		
		!$OMP DO reduction(+:Ep,acc)
		do i = 1, nb_p
			do j = i+1, nb_p
				
				r = sqrt(sum( (pos(:,i)-pos(:,j))*(pos(:,i)-pos(:,j)) ) + eps*eps)
				fact = m_p/(r*r*r)
				
				pair_acc(:) = fact*(pos(:,j)-pos(:,i))
				
				acc(:,i) = acc(:,i) + pair_acc(:)
				acc(:,j) = acc(:,j) - pair_acc(:)
				Ep = Ep - m_p*fact*r*r
				
			end do
		end do
		!$OMP END DO
		
		!$OMP SINGLE
		!Ep = 0.5 * Ep
		vit(:,:) = vit(:,:) + acc(:,:)*dt_2
		Ec = Ec + 0.5*m_p*sum(vit(:,:)*vit(:,:))
		vit(:,:) = vit(:,:) + acc(:,:)*dt_2
		
		pos(:,:) = pos(:,:) + vit(:,:)*dt
		
		!Skip some writing intervals 
		if(MOD(INT((t - dt_2)/ dt),5) == 0) then
			write(*,*) "Time :", t, "/ :", end_t
			do i = 1, nb_p
				write(10,*) pos(:,i)
			end do
			write(11,*) t, Ec, Ep
		end if
		
		t = t + dt
		!$OMP END SINGLE
	end do
	!$OMP END PARALLEL
	
	close(10)
	close(11)

end program nbody












