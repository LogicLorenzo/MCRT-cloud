FC := gfortran
FFLAGS := -fopenmp
OBJS := src/main.f90 src/utils.f90 src/ray_tracing.f90 src/photon_impact.f90

all: MCRT-cloud

MCRT-cloud: $(OBJS)
    $(FC) $(FFLAGS) -o $@ $(OBJS)

%.o: %.f90
    $(FC) $(FLAGS) -c $<

clean:
    rm -f *.o *.mod MCRT-cloud