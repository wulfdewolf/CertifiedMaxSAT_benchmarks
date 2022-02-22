# A Certified MaxSAT solver: benchmarks

This repository contains scripts and binaries to run the benchmarks from  
**_D .Vandesande, W. De Wulf, B. Bogaerts. A Certified MaxSAT solver. (to be submitted at SAT2022)_**

## Usage

Running the [`run.sh`](run.sh) script will initiate the benchmarks.  
The script takes a single argument that is a string of the year of the MaxSAT evaluation for which the benchmarks should be ran.  
For example:

```console
./run.sh 2010
```

will run the 2010 MaxSAT evaluation benchmarks.  
The results are written to a `.csv` with the following columns:
| Instance | vanilla solving time (s) | totalizer generation time (s) | vanilla used memory (MB) | prooflogging solving time (s) | proof size (B) | totalizer generation time (s) | totalizer prooflogging time (s) | verification time (s) | verification used memory (MB) | verification status |
| --- | --- | --- | --- |--- |--- |--- |--- |--- |--- |--- |

## Warning

The memory limits for the 2021 MaxSAT evaluation exceed an average computer's resources (32GB).  
Additionally, verification is always allowed 1.25 times the solving memory limit.  
We therefore strongly advice to run this script on a cluster that has sufficient resources.
