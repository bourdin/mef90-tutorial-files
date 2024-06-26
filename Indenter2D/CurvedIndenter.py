#!/usr/bin/env python
import sys

def parse(args=None):
    import argparse
    ### Get options from the command line
    parser = argparse.ArgumentParser(description='Compute boundary displacement for a surfing computation')
    parser.add_argument('-i','--inputfile',help='input file',default=None)
    parser.add_argument('-o','--outputfile',help='output file',default=None)
    parser.add_argument("--time_min",type=float,help="first time step",default=0.)
    parser.add_argument("--time_max",type=float,help="last time step",default=1.)
    parser.add_argument("--time_numstep",type=int,help="number of time step",default=11)
    parser.add_argument("--radius",type=float,help="indenter radius ",default=5)
    parser.add_argument("--width",type=float,help="indenter width ",default=1)
    parser.add_argument("--cs",type=int,nargs='*',help="list of cell sets where the indenter is applied",default=[])
    parser.add_argument("--vs",type=int,nargs='*',help="list of vertex sets where indenter are applied",default=[])
    parser.add_argument("--plasticity",default=False,action="store_true",help="Add extended variables for plasticity related fields")
    parser.add_argument("--force",action="store_true",default=False,help="Overwrite existing files without prompting")
    return parser.parse_args()
    
def exoformat(e,plasticity=False):
    if plasticity:
        global_variable_name = ["Elastic Energy","Work","Surface Energy","Total Energy","Dissipation Plastic"]
        if e.num_dimensions() == 2: 
            node_variable_name  = ["Temperature","Damage","Displacement_X","Displacement_Y"]
            element_variable_name   = ["External_Temperature","Heat_Flux","Pressure_Force",
                                       "Force_X","Force_Y",
                                       "Stress_XX","Stress_YY","Stress_XY",
                                       "Cumulated_Plastic_Energy","plasticStrain_XX","plasticStrain_YY","plasticStrain_XY"]
        else:
            node_variable_name  = ["Temperature","Damage","Displacement_X","Displacement_Y","Displacement_Z"]
            element_variable_name   = ["External_Temperature","Heat_Flux","Pressure_Force",
                                       "Force_X","Force_Y","Force_Z",
                                       "Stress_XX","Stress_YY","Stress_ZZ","Stress_YZ","Stress_XZ","Stress_XY",
                                       "Cumulated_Plastic_Energy","plasticStrain_XX","plasticStrain_YY","plasticStrain_ZZ","plasticStrain_XY","plasticStrain_YZ","plasticStrain_XZ","plasticStrain_XY"]
    else:
        global_variable_name = ["Elastic Energy","Work","Surface Energy","Total Energy"]
        if e.num_dimensions() == 2: 
            node_variable_name  = ["Temperature","Damage","Displacement_X","Displacement_Y"]
            element_variable_name   = ["External_Temperature","Heat_Flux","Pressure_Force",
                                       "Force_X","Force_Y",
                                       "Stress_XX","Stress_YY","Stress_XY"]
        else:
            node_variable_name  = ["Temperature","Damage","Displacement_X","Displacement_Y","Displacement_Z"]
            element_variable_name   = ["External_Temperature","Heat_Flux","Pressure_Force",
                                       "Force_X","Force_Y","Force_Z",
                                       "Stress_XX","Stress_YY","Stress_ZZ","Stress_YZ","Stress_XZ","Stress_XY"]
    e.set_global_variable_number(0)
    e.set_node_variable_number(len(node_variable_name))
    for i in range(len(node_variable_name)):
        e.put_node_variable_name(node_variable_name[i],i+1)
    e.set_element_variable_number(len(element_variable_name))
    for i in range(len(element_variable_name)):
        e.put_element_variable_name(element_variable_name[i],i+1)
    e.set_element_variable_truth_table([True] * e.numElemBlk.value * len(element_variable_name))
    return(0)

def SphericalIndenter(e,r,w,t,cslist,vslist):
    import exodus as exo
    import numpy as np
    
    dim = e.num_dimensions()
    X,Y,Z=e.get_coords()
    U = np.zeros([3,len(X)],dtype=exo.c_double)
    
    csoffset = [e.elem_blk_info(set)[1] for set in cslist]        
    for set in cslist:
        connect = e.get_elem_connectivity(set)
        for cid in range(connect[1]):
            vertices = [connect[0][cid*connect[2]+c] for c in range(connect[2])]
            for v in vertices:
                if dim == 2:
                    U[0,v-1] = 0.0
                    U[1,v-1] = min(0,np.sqrt(r**2-w**2) - np.sqrt(r**2-X[v-1]**2) - t)
                    U[2,v-1] = 0.0
                else:    
                    U[0,v-1] = 0.0
                    U[1,v-1] = 0.0
                    U[2,v-1] = min(0,np.sqrt(r**2-w**2) - np.sqrt(r**2-X[v-1]**2-Y[v-1]**2) - t)
    for set in vslist:
        for v in e.get_node_set_nodes(set):
            if dim == 2:
                U[0,v-1] = 0.0
                U[1,v-1] = min(0,np.sqrt(r**2-w**2) - np.sqrt(r**2-X[v-1]**2) - t)
                U[2,v-1] = 0.0
            else:    
                U[0,v-1] = 0.0
                U[1,v-1] = 0.0
                U[2,v-1] = min(0,np.sqrt(r**2-w**2) - np.sqrt(r**2-X[v-1]**2-Y[v-1]**2) - t)
    return U

def main():
    import exodus as exo
    import numpy as np
    import os
    import pymef90
    options = parse()
    
    if  os.path.exists(options.outputfile):
        if options.force:
            os.remove(options.outputfile)
        else:
            if pymef90.confirm("ExodusII file {0} already exists. Overwrite?".format(options.outputfile)):
                os.remove(options.outputfile)
            else:
                print '\n\t{0} was NOT generated.\n'.format(options.outputfile)
                return -1
    exoin  = exo.exodus(options.inputfile,mode='r')
    exoout = exoin.copy(options.outputfile)
    exoin.close()
    exoformat(exoout)
    
    dim = exoout.num_dimensions()
    step = 0

    for t in np.linspace(options.time_min,options.time_max,options.time_numstep):
        print "writing step",step+1,t
        exoout.put_time(step+1,t)
        U = SphericalIndenter(exoout,options.radius,options.width,t,options.cs,options.vs)
        X,Y,Z=exoout.get_coords()
        exoout.put_node_variable_values("Displacement_X",step+1,U[0,:])
        exoout.put_node_variable_values("Displacement_Y",step+1,U[1,:])
        if dim == 3:
            exoout.put_node_variable_values("Displacement_Z",step+1,U[2,:])
        step += 1
    exoout.close()
    ### 
    ### compute boundary displacement at vertex sets
    ###
    
if __name__ == "__main__":
        sys.exit(main())

