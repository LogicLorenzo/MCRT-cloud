PROGRAM main
  use utils
  use ray_tracing
  use photon_impact
  use omp_lib
  implicit none

  real(8), allocatable :: coor(:,:), radii(:)
  real(8) :: agg_bound = 0.0
  real(8) :: theta, phi, beta
  real(8) :: p_phase(:), p_atten(:)
  real(8), allocatable :: total_dist(:),  num_contact(:), phase_shift(:)
  real(8), allocatable :: intensity(:), direction(:, 3)
  integer :: i, num_samples = 1000

  ! Read sphere data from file
  call read_data('data/spheres_data.txt', coor, radii)

  ! Calculate the aggregate boundary
  do i = 1, size(radii)
    if (norm2(coor(i, :)) > agg_bound) then
      agg_bound = norm2(coor(i, :))
    end if
  end do

  ! Allocate memory for the arrays
  allocate(total_dist(num_samples))
  allocate(num_contact(num_samples))
  allocate(phase_shift(num_samples))
  allocate(intensity(num_samples))
  allocate(direction(num_samples, 3))

  !$omp parallel do private(theta, phi, beta)
  do i = 1, num_samples
    ! Initialize Monte Carlo ray tracing process
    call trace_photon(coor, radii, agg_bound, p_phase, p_atten, total_dist(i), &
      num_contact(i), phase_shift(i), intensity(i), direction(i, :))

  PRINT *, "Monte Carlo Ray Tracing completed."
  !$omp end parallel do

END PROGRAM main