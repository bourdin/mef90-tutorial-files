### Instructions for the surfing example:

* Generate the mesh: `gmsh -2 Surfing.geo`
* Convert the mesh to exodus format for `vDefSurfingBC.py`: `gmsh2exo -geometry Surfing.msh -result Surfing.exo`
Note that this will convert face sets into vertex sets.
* Write the boundary displacement in the _result_ file: `vDefSurfingBC.py -i Surfing.exo -o Surfing_out.exo --time_min 0 --time_max 10 --time_numstep 21 --E 1 --nu 0.3 --initialpos 0 0 0 --vs 20`. 
* Run the example: `srun -n 12 vDef -geometry Surfing.exo -result Surfing_out.exo -options_file Surfing-vs.yaml`.
