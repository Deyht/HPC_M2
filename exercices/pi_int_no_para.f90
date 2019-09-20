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
	integer, parameter :: n=30000
	real(kind=8) :: pi, pi_other, h, x
	integer :: i

	pi_other = acos(-1.0_8)
	h = 1.0_8 / real(n,kind=8)
	pi = 0.0

	do i=1, n
		x = h * (real(i,kind=8) - 0.5_8)
		pi = pi + func(x)
	end do

	pi = pi*h

	write(*,*) "Integral methode :", pi, "Cos methode :", pi_other

end program main













