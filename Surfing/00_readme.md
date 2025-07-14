### Instructions for the surfing example:
This examples requires mef90 >= 0.4.0 since boundary conditions are now given as expressions"

* Generate the mesh: `gmsh -2 Surfing.geo`
* Run the example: `srun -n 12 vDef -geometry Surfing.exo -result Surfing_out.exo -options_file Surfing-vs.yaml`.
* Compute the J-integral: `visit -cli -nowin -s $MEF90_DIR/bin/JIntegral2Dx2017.py -i Surfing_out.exo --bb 2 -2 6 4 --nint 100 100 --E 1 --nu .3`
