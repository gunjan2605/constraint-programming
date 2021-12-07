/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Sep 20, 2021 at 5:34:43 PM
 *********************************************/

using CP;

int nbControlCenters = ...;
range ControlCenters = 0..nbControlCenters-1;
int nbLocations = ...;
range Locations = 0..nbLocations-1;
int nbTogether = ...;
range RTogether = 1..nbTogether;
{int} Together[RTogether] = ...;
int nbSeparated = ...;
range RSeparated = 1..nbSeparated;
{int} Separated[RSeparated] = ...;
int f[ControlCenters,ControlCenters] = ...;
int hop[Locations,Locations] = ...;

dvar int location[ControlCenters] in Locations;

minimize sum(i in 0..nbControlCenters-2)sum(j in i+1..nbControlCenters-1)((hop[location[i]][location[j]])*(f[i][j]));

constraints{
  
//separated constraints
forall(s in RSeparated)
  forall(ordered i,j in Separated[s])
    location[i]!= location[j];
    
//together constraints
forall(t in RTogether)
  forall(ordered u,v in Together[t])
    location[u]== location[v];
    }

