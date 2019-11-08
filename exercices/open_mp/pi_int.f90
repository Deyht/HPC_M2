module utils
	implicit none
contains
	function func(x)
		real(kind=8), intent(in) :: x
		real(kind=8) :: func
		func = 4.0_8/(1.0_8 + x*x)
	end function func
end module utils


program main
	use utils
	implicit none
	integer, parameter :: n=600000000
	real(kind=8) :: pi, pi_other, h, x, pi_loc
	integer :: i

	pi_other = acos(-1.0_8)
	h = 1.0_8 / real(n,kind=8)
	pi = 0.0
	pi_loc = 0.0

	!$OMP PARALLEL PRIVATE(x) FIRSTPRIVATE(pi_loc)
	!$OMP DO SCHEDULE(STATIC)
	do i=1, n
		x = h * (real(i,kind=8) - 0.5_8)
		pi_loc = pi_loc + func(x)
	end do
	!$OMP END DO

	!$OMP ATOMIC
	pi = pi + pi_loc

	!$OMP END PARALLEL
	pi = pi*h

	write(*,*) "Integral methode :", pi, "Cos methode :", pi_other

end program main













