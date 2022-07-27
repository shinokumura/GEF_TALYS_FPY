set term postscript eps enhanced color solid
set size 0.8,1.0

set tics font "Helvetica,18"
set xlabel font "Helvetica,18"
set ylabel font "Helvetica,18"
set key font "Helvetica,18"
set title font "Helvetica,18"

set ylabel "Energy"
set xlabel "Mass"
set title  en  . "MeV"
set xrange [60:200]
set output outpath . ffmodel ."/" . selection . "/" . nuclide . "_" . en . ".eps"


plot outpath . ffmodel . "/" . selection . "/" . nuclide . "_" . en . ".dat" u 2:3 w p title nuclide . ": ". en  . "MeV"