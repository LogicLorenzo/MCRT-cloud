! Here a more probability based approach is used. However, another approach could be a
! randomized selection of photon paths calculated in the MCRT1 model. 
module photon_impact
  implicit none

  contains

  function calculate_phase_shift(p_phase) result(phase_shift)
    ! Estimate the phase shift of a photon after a scattering event using MCRT1.
    ! Inputs:
    !   p_phase: probability distribution of phase-shift after scattering event
    real(8), intent(in) :: p_phase(:)
    ! Outputs:
    !   phase_shift: total phase-shift of the photon
    real(8), intent(out) :: phase_shift
    ! Local variables:
    real(8) :: random
    call random_number(random)
    random = nint(random * size(p_phase))
    phase_shift = p_phase(random)
  end function calculate_phase_shift

  function calculate_attenuation(p_atten) result(attenuation)
    ! Estimate the attenuation of a photon after a scattering event using MCRT1.
    ! Inputs:
    !   p_atten: probability distribution of attenuation after scattering event
    real(8), intent(in) :: p_atten(:)
    ! Outputs:
    !   attenuation: total attenuation of the photon
    real(8) :: attenuation
    ! Local variables:
    real(8) :: random
    call random_number(random)
    random = nint(random * size(p_atten))
    attenuation = p_atten(random)
  end function calculate_attenuation

  function calculate_new_direction(direction) result(new_direction)
    ! Estimate the new direction of the photon after scattering. Currently, a 
    ! uniform distribution is used to estimate the new direction. This can be changed
    ! by a better model in the future for selecting the direction randomly.
    ! Inputs:
    !   direction: direction of the photon
    real(8), intent(in) :: direction(3)
    ! Outputs:
    !   new_direction: new direction of the photon
    real(8), intent(out) :: new_direction(3)
    ! Local variables:
    real(8) :: random1, random2, theta, phi
    ! Constants:
    real(8), parameter :: PI = 3.14159265
    call random_number(random1)
    theta = 2 * PI * random1
    call random_number(random2)
    phi = 2 * PI * random2
    new_direction = [cos(theta) * sin(phi), &
                     sin(theta) * sin(phi), &
                     cos(phi)]
  end function calculate_new_direction

end module photon_impact

    