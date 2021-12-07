/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Oct 18, 2021 at 8:36:24 PM
 *********************************************/
using CP;
int nbSites = ...;
int nbVehicles = ...;
int capacity = ...;
range Sites = 0..nbSites;
tuple Site {
int demand;
int x;
int y;
};
Site siteData[Sites] = ...;
int nbLocations = nbVehicles + nbSites - 1;
range Locations = 1..nbLocations;
range Depots = 1..nbVehicles;
range Customers = (nbVehicles + 1)..nbLocations;
Site data[l in Locations] = (l <= nbVehicles) ? siteData[0] : siteData[l-nbVehicles];
int dist[i in Locations,j in Locations] =
ftoi(round(sqrt((data[i].x - data[j].x)^2 + (data[i].y - data[j].y)^2)));
int demandl[l in Locations] = data[l].demand;

//dvars
dvar int succ[Locations] in Locations; 
dvar int pred[Locations] in Locations;
dvar int seq[Locations] in Locations;
dvar int time[Locations] in 0..70;
dvar int vehicle[Locations] in Depots;
dvar int Load[Depots] in 0..capacity;

dexpr int timep[l in Locations] = time[pred[l]]; 
dexpr int times[l in Locations] = time[succ[l]]; 
dexpr int vehiclep[l in Locations] = vehicle[pred[l]];
dexpr int vehicles[l in Locations] = vehicle[succ[l]];
dexpr int succs[l in Locations] = succ[seq[l]];
dexpr int predl[l in Locations] = pred[seq[l]];
dexpr int distp[c in Customers] = dist[pred[c],c];

execute {
  cp.param.AllDiffInferenceLevel = 6;
  cp.param.timeLimit = 300;
}

//objective - minimize time to last delivery
minimize max(c in Customers)time[c];

constraints{ 
//time variable 
forall(l in 1..nbVehicles)
  time[l] == 0;
forall(c in Customers)
  time[c] >= distp[c];
forall(c in Customers)
  time[c] >= timep[c];
  
forall(c in Customers)
  time[c] == timep[c] + distp[c];
//circuit constraint, start from location 1
seq[1] == succ[1];
seq[nbLocations] == 1;
seq[nbLocations-1] == pred[1];
forall(l in 2..nbLocations)
  seq[l] == succs[l-1];
forall(l in 1..nbLocations-1)
  seq[l] == predl[l+1];
  
allDifferent(seq);
allDifferent(succ);
allDifferent(pred);
inverse(succ, pred);
  
//vehicle constraint
forall(l in 1..nbVehicles)
  vehicle[l] == l;
forall(c in Customers)
  vehiclep[c] == vehicle[c];
forall(c in Customers)
  vehicle[c] == ((vehicles[c])*(succ[c]>5)) + (((vehicles[c]+4)%5)*(succ[c]<5));
//redundant constraints
//forall(l in 1..nbVehicles)
  //vehicles[l] == l;
forall(l in 2..nbVehicles)
  vehiclep[l] == l-1;
vehicle[pred[1]] == nbVehicles;

//capacity constraint 
pack(Load,vehicle,demandl);
}

int next[l in Locations] = succ[l];

execute{
  writeln(next)
}