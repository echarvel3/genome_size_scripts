# scripts and data for genome size estimation.


## Order of scripts to get finalized output.

| Script Title | Use |
|----|----|
| 1_run_kraken.slurm | Decontamination |

| 2_run_jellyfish.slurm | Histogram Generation |

3_run_compile_hist_data.sh Compiling Necessary Data for RESPECT _(submit to slurm scheduler)_

4_run_respect_full.slurm  Runs RESPECT

5_run_downsample.slurm  Uses seqtk to downsample data

6_run_jellyfish_downsampled.slurm  Histogram Generation on Downsampled Replicates

7_run_compile_downsampled_data.sh  Compiles Necessary Data Again _(do not submit to scheduler)_

8_run_respect_downsampled.slurm  Runs Final RESPECT Run

