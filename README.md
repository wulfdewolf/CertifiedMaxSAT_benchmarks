# A Certified MaxSAT solver: patches & benchmarks

This package contains the patches and benchmark scripts from  
**_D .Vandesande, W. De Wulf, B. Bogaerts. A Certified MaxSAT solver. (to be submitted at SAT2022)_**

## Patches

The [patches](patches) folder contains three patches, underneath a description is given for each of them.

### MiniSAT fix

The [qmaxsat_fix.patch](patches/qmaxsat_fix.patch) patch applies a fix to the Qmaxsat 0.1 source code such that it works with recent C++ compilers.

### Prooflogging

The [prooflogging.patch](patches/prooflogging.patch) patch extends the (fixed) Qmaxsat 0.1 source code with prooflogging.

### VeriPB WCNF extension

The [veripb_wcnf.patch](patches/veripb_wcnf.patch) patch extends the VeriPB source code with the ability to read from `.wcnf` files.  
Use the `-wcnf` flag to indicate that the input file is in the `.wcnf` format.

## Benchmarks

Follow underneath steps to reproduce the experiments.

### Building the tools

Build the required tools using:

```console
./tools/build_tools.sh
```

### Running benchmarks

Run the benchmarks using:

```console
./benchmarks/run.sh 2010
```

The script takes a single argument that is a string of the year of the MaxSAT evaluation for which the benchmarks should be ran.  
The results are written to a `.csv` with the following columns:
| Instance | vanilla solving time (s) | vanilla used memory (MB) | prooflogging solving time (s) | proof size (B) | verification time (s) | verification used memory (MB) | verification status |
| --- | --- |--- |--- |--- |--- |--- |--- |

## Warning

The memory limits for the 2021 MaxSAT evaluation exceed an average computer's resources (32GB).  
Additionally, verification is always allowed 1.25 times the solving memory limit.  
We therefore strongly advice to run this script on a cluster that has sufficient resources.
