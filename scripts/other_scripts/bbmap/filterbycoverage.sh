#!/bin/bash

usage(){
echo "
Written by Brian Bushnell
Last modified May 3, 2016

Description:  Filters an assembly by contig coverage.
The coverage stats file can be generated by BBMap or Pileup.

Usage:  filterbycoverage.sh in=<assembly> cov=<coverage stats> out=<filtered assembly> mincov=5

Parameters:
in=<file>       File containing input assembly.
cov=<file>      File containing coverage stats generated by pileup.
cov0=<file>     Optional file containing coverage stats before normalization.
out=<file>      Destination of clean output assembly.
outd=<file>     (outdirty) Destination of dirty output containing only removed contigs.
minc=5          (mincov) Discard contigs with lower average coverage.
minp=40         (minpercent) Discard contigs with a lower percent covered bases.
minr=0          (minreads) Discard contigs with fewer mapped reads.
minl=1          (minlength) Discard contigs shorter than this (after trimming).
trim=0          (trimends) Trim the first and last X bases of each sequence.
ratio=0         If cov0 is set, contigs will not be removed unless the coverage ratio (of cov to cov0) is at least this (0 disables it).
ow=t            (overwrite) Overwrites files that already exist.
app=f           (append) Append to files that already exist.
zl=4            (ziplevel) Set compression level, 1 (low) to 9 (max).

Java Parameters:
-Xmx            This will set Java's memory usage, overriding autodetection.
                -Xmx20g will specify 20 gigs of RAM, and -Xmx200m will specify 200 megs.
                    The max is typically 85% of physical memory.
-eoom           This flag will cause the process to exit if an out-of-memory
                exception occurs.  Requires Java 8u92+.
-da             Disable assertions.

Please contact Brian Bushnell at bbushnell@lbl.gov if you encounter any problems.
"
}

#This block allows symlinked shellscripts to correctly set classpath.
pushd . > /dev/null
DIR="${BASH_SOURCE[0]}"
while [ -h "$DIR" ]; do
  cd "$(dirname "$DIR")"
  DIR="$(readlink "$(basename "$DIR")")"
done
cd "$(dirname "$DIR")"
DIR="$(pwd)/"
popd > /dev/null

#DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
CP="$DIR""current/"

z="-Xmx800m"
set=0

if [ -z "$1" ] || [[ $1 == -h ]] || [[ $1 == --help ]]; then
	usage
	exit
fi

calcXmx () {
	source "$DIR""/calcmem.sh"
	setEnvironment
	parseXmx "$@"
	if [[ $set == 1 ]]; then
	return
	fi
	freeRam 800m 84
	z="-Xmx${RAM}m"
	z2="-Xms${RAM}m"
}
calcXmx "$@"

function filterbycoverage() {
	local CMD="java $EA $EOOM $z -cp $CP jgi.FilterByCoverage $@"
	echo $CMD >&2
	eval $CMD
}

filterbycoverage "$@"
