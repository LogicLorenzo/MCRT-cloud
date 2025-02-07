# Monte Carlo Ray Tracing For a Collection of Spheres

This project implements a Monte Carlo Ray Tracing algorithm that simulates the interaction of photons with a collection of spheres. The spheres' properties, including their coordinates and radii, are read from a text file. The Monte Carlo Ray Tracing algorithm is a statistical method used to simulate the behavior of photons as they interact with objects. This project focuses on modeling the interaction of photons with spheres. 

## Project Structure
```
monte-carlo-ray-tracing 
├── src 
│  ├── main.f90 # Entry point of the application 
│  ├── utils.f90 # Utility functions 
│  ├── spheres.f90 # Module for managing spheres 
│  ├── interaction_modeling.f90 # Placeholder for interaction modeling 
│  ├── rotation_matrices.f90 # Functions for rotation matrices 
│  ├── parallel_computing.f90 # Structure for parallel computing 
│  ├── photon_intensity.f90 # Functions for photon intensity calculations 
│  └── phase_shift.f90 # Functions for phase shift calculations 
├── data 
│  └── spheres_data.txt # Sphere properties data 
├── Makefile # Build instructions for the project 
└── README.md # Project documentation
```
## Setup Instructions

1- Ensure you have a Fortran compiler installed (e.g., gfortran).
2- Clone the repository or download the project files.
3- Navigate to the project directory.


## Running the Program

1. Ensure you have a Fortran compiler installed.
2. Compile the project using the provided Makefile:
```sh
   make
```
3. Run the compiled executable:
```sh
   ./monte_carlo_ray_tracing
```

## Parallel Computing

The project utilizes OpenMP for parallel computing to speed up the Monte Carlo simulations. Ensure that your Fortran compiler supports OpenMP.

## Data File Format

The spheres_data.txt file should contain the coordinates and radii of the spheres in the following format:
```
x1 y1 z1 r1
x2 y2 z2 r2
...
```
Currently, the algorithm expects the data to be given in spheres_dat.txt. The file is read from main.f90, so the user must change the name there if the information is given in a different file. 

## Main Program Logic

The main program performs the following steps:

1. Reads sphere data from the spheres_data.txt file.
2. Determines the bounding radius of the aggregate of spheres.
3. Uses OpenMP to parallelize the Monte Carlo ray tracing process.
4. Calls the trace_photon subroutine to simulate the interaction of photons with the spheres.
5. Outputs the results of the simulation

## Future Work

- Introduce non-uniform scattering profiles to calculate_new_direction subroutine in photon_impact.f90
- Create a Python wrapper with f2py for ease of usage, particularly with multiple files for averaged behavior
- Optimize parallel computing strategies. 

## Contributions

Feel free to contribute to this project by submitting pull requests or opening issues. Your feedback and improvements are welcome!
