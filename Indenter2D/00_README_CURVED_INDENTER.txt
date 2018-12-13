How to use boundary displacement from an external file:

In this case, the indentation by an indenter consisting of the intersection of 
a sphere of radius R and a cylinder of diameter w.

1. generate the geometry mesh as usual:
   gmsh -2 -format msh2 Indenter2D.geo
   gmsh2exo.py Indenter2D.msh Indenter2D.gen
2. Create the output file and write the boundary displacements in it:
   python CurvedIndenter.py -i Indenter2D.gen -o Indenter2D_out.gen --cs 30 --radius 1.5 --width 1. --time_min 0 --time_max 1 --time_numstep 51

   	--radius denotes the radius of the sphere
    --width  denoted the diameter of the cylinder
    --cs and --vs are the cell and vertex sets at which this fixed displacement is prescribed
    --time_min, --time_max, and time_numstep are explicit
    time 0 is the time at which teh entire surface of the indenter makes contact with the body
3. run as usual:
	vDef -geometry Indenter2D.gen -result Indenter2D_out.gen -options_file_yaml CurvedIndented2D-AltMin.yaml