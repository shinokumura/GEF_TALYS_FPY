set term postscript eps enhanced color solid
set size 0.8,1.0

set tics font "Helvetica,18"
set xlabel font "Helvetica,18"
set ylabel font "Helvetica,18"
set key font "Helvetica,18"
set title font "Helvetica,18"
set xrange [60:200]

set ylabel "Yield"
set xlabel "Mass"
set title  en  . "MeV"
set output outpath . ffmodel ."/YA/" . nuclide . "_" . en . ".eps"

plot outpath . ffmodel . "/YA/" . nuclide . "_" . en . ".dat" u 1:2 w lp title nuclide . ": ". en  . "MeV"