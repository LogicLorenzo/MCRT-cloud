! This module contains the functions that are used to simulate the path of a photon through an aggregate.
module ray_tracing
  use photon_impact
  implicit none

  contains 
  subroutine trace_photon(coor, radii, agg_bound, p_phase, p_atten, total_dist, num_contact, phase_shift, &
                           intensity, direction)
    ! Simulate the entire journey of a photon passing through an aggregate. End the journey of the photon
    ! when it escapes the aggregate, or when the intensity of the photon falls below a certain treshold.
    ! Inputs:
    !   coor: coordinates of the primary particles
    !   radii: radii of the primary particles
    !   p_phase: probability distribution of phase-shift after scattering event
    !   p_atten: probability distribution of attenuation after scattering event
    real(8), intent(in) :: coor(:, :), radii(:), agg_bound, p_phase(:), p_atten(:)
    ! Outputs:
    !   total_dist: distance traveled by the photon
    !   phase_shift: total phase-shift of the photon
    !   intensity: intensity of the photon
    !   direction: direction of the photon
    real(8), intent(out) :: total_dist, phase_shift, intensity, direction(3)
    integer, intent(out) :: num_contact
    ! Local variables:
    integer :: i, n, i_particle, first_contact = 0
    real(8) :: random1, random2, r, theta
    real(8) :: origin(3)
    ! Constants: 
    real(8), parameter :: PI = 3.14159265

    phase_shift = 0.0
    intensity = 1.0
    num_contact = 0

    ! We take the center of the aggregate to be the origin of the coordinate system. All we need to do is 
    ! shoot photons directly at the aggregate at the z-direction, hitting the -z-face. Some photons will just pass
    ! the aggregate by, which are not important for us. We will keep shooting photons until we hit a particle. 
    ! We can understand which particle we hit by drawing a line from the origin of photon to infinity in the photon
    ! direction. Centers which are closer to this line than the radius mean that the photon will reach that particle. 
    ! If there are multiple centers that satisfy this, the closest particle to the origin point will be hit. 
    do while (first_contact == 0)
      ! First shot
      direction = [0.0, 0.0, 1.0]
      call random_number(random1)
      r = agg_bound * random1
      call random_number(random2)
      theta = 2 * PI * random2
      origin(1) = r * cos(theta)
      origin(2) = r * sin(theta)
      origin(3) = -10000.0
      call propagate_photon(origin, direction, coor, radii, distance, i_particle)
      if (i_particle /= 0) then
        first_contact = 1
        total_dist = distance
        do while (intensity > 10 ** -3 .and. i_particle /= 0)
          num_contact = num_contact + 1
          total_dist = total_dist + distance
          ! Calculate the phase shift and attenuation of the photon
          phase_shift = phase_shift + calculate_phase_shift(p_phase)
          intensity = intensity * calculate_attenuation(p_atten)
          ! Calculate the new direction of the photon
          direction = calculate_new_direction(direction)
          ! Propagate the photon 
          call propagate_photon(origin, direction, coor, radii, distance, i_particle)
        end do
      end if
    end do
  end subroutine trace_photon

  subroutine propagate_photon(origin, direction, coor, radii, distance, i_particle)
    ! Propagate a photon through the medium until it hits a primary particle of aggregate. 
    ! In/out parameters:
    !   origin: origin of the photon
    real(8), intent(inout) :: origin(3)
    ! Inputs:
    !   direction: direction of the photon
    !   coor: coordinates of the primary particles
    !   radii: radii of the primary particles
    real(8), intent(in) :: direction(3), coor(:, :), radii(:)
    ! Outputs:
    !   distance: distance traveled by the photon
    real(8), intent(out) :: distance
    integer, intent(out) :: i_particle
    ! Local variables:
    real(8) :: endpoint(3), line(3), a(3), closest_point(3), t
    real(8) :: small_distance = 100000.0, cur_distance = 0.0
    integer :: i

    i_particle = 0
    ! Draw a line from the origin of the photon to infinity in the photon direction. Find the shortest
    ! distance from the line to the center of the primary particles. If this distance is smaller than the
    ! radius, that means that the photon will hit that particle. There might be multiple scatterers in one 
    ! direction. To find which our photon will hit, we will choose the closest scatterer to the origin point
    do i = 1, size(radii)
      ! Calculate the endpoint of the photon
      endpoint = origin + direction * 10000.0
      line = endpoint - origin
      a = coor(i, :) - origin
      ! Calculate the distance from the center of the particle to the light line
      t = dot_product(a, line) / dot_product(line, line)
      t = max(0, min(1.0, t))
      closest_point = origin + t * line
      if (norm2(coor(i, :) - closest_point) <= radii(i)) then
        ! The photon hits the particle
        cur_distance = norm2(origin - coor(i, :))
        ! Checking if the particle is closest to the origin point of the photon
        if (cur_distance < small_distance) then
          small_distance = cur_distance
          i_particle = i
        end if
      end if
    end do
    distance = small_distance
  end subroutine propagate_photon
end module ray_tracing