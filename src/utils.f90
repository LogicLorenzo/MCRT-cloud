module utils
  implicit none

contains

  subroutine read_data(filename, coor, radii) 
    ! Read primary particle data from a file
    ! Input:
    !   filename: name of the file to read
    character(len=*), intent(in) :: filename
    ! Output:
    !   coor: coordinates of the primary particles
    !   radii: radii of the primary particles
    real(8), allocatable, intent(out) :: coor(:, :), radii(:)
    integer :: i, n, ios
    ! First, open the file to count the number of rows (n)
    open(unit=10, file=filename, status='old', action='read')
    n = 0
    do
      ! Read one row; the values are not stored, we only count rows.
      read(10, *, iostat=ios)
      if (ios /= 0) exit
      n = n + 1
    end do
    close(10)
    ! Allocate memory for the arrays
    allocate(coor(n, 3))
    allocate(radii(n))
    open(unit=10, file=filename, status='old', action='read')
    do i = 1, n
      read(10, *) coor(i,1), coor(i,2), coor(i,3), radii(i)
    end do
    close(10)
  end subroutine read_data

  subroutine change_orientation(theta, phi, beta, coor)
  ! Rotate the aggregate around the origin using the rotation matrices
  ! Inputs:
  !   theta: angle of rotation around the x-axis
  !   phi: angle of rotation around the y-axis
  !   beta: angle of rotation around the z-axis
  ! In/out parameters:
  !   coor: coordinates of the primary particles
    real(8), intent(in) :: theta, phi, beta
    real(8), intent(inout) :: coor(:, :)
    real(8) :: Rx(3, 3), Ry(3, 3), Rz(3, 3), R(3, 3)

    ! Rotation matrix around x-axis
    Rx = reshape([1.0, 0.0, 0.0, &
                  0.0, cos(theta), -sin(theta), &
                  0.0, sin(theta), cos(theta)], [3, 3])

    ! Rotation matrix around y-axis
    Ry = reshape([cos(phi), 0.0, sin(phi), &
                  0.0, 1.0, 0.0, &
                  -sin(phi), 0.0, cos(phi)], [3, 3])

    ! Rotation matrix around z-axis
    Rz = reshape([cos(beta), -sin(beta), 0.0, &
                  sin(beta), cos(beta), 0.0, &
                  0.0, 0.0, 1.0], [3, 3])

    ! Combined rotation matrix
    R = matmul(Rz, matmul(Ry, Rx))

    ! Apply rotation to the coordinates
    coor = matmul(R, transpose(coor))
  end subroutine change_orientation

end module utils