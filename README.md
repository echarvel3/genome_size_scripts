# scripts and data for genome size estimation.


## Order of scripts to get finalized output.

1. Place your paired fastq files in numbered folder (e.g. folder_1, folder_2, folder_3) for better parallization.
2.  Make sure to put your own account name in the batch script!
3.  Submit .slurm scripts to scheduler and just run .sh scripts on head node.


| Script Title | Use |
|----|----|
| 1_run_kraken.slurm | Decontamination |
| 2_run_jellyfish.slurm | Histogram Generation |
| 3_run_compile_hist_data.sh | Compiling Necessary Data for RESPECT _(do not submit to slurm scheduler)_ |
| 4_run_respect_full.slurm | Runs RESPECT |
| 5_run_downsample.slurm | Uses seqtk to downsample data |
| 6_run_jellyfish_downsampled.slurm  | Histogram Generation on Downsampled Replicates |
| 7_run_compile_downsampled_data.sh | Compiles Necessary Data Again _(do not submit to slurm scheduler)_ |
|8_run_respect_downsampled.slurm | Runs Final RESPECT Run |

