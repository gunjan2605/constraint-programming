/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Nov 5, 2021 at 6:41:35 PM
 *********************************************/

using CP; 

int nbStations = ...;
range Stations = 1..nbStations;
tuple stationData {
   int service;
   int start;
   int end;
};

stationData data[Stations] = ...;
int time[Stations,Stations] = ...;

dvar interval task[s in Stations] in data[s].start..data[s].end + data[s].service size data[s].service;
dvar sequence r2d2Seq in all(s in Stations)task[s] types all(s in Stations)s;

tuple triplet {int loc1; int loc2; int value;};
{triplet} transitionTimes = {<i,j,time[i,j]> | i in Stations, j in Stations};

execute {
  var f = cp.factory;
  cp.setSearchPhases(f.searchPhase(task),f.searchPhase(r2d2Seq));
   }
   
minimize sum(s in Stations)time[s,typeOfNext(r2d2Seq,task[s],s)];

constraints{
  noOverlap(r2d2Seq, transitionTimes);
} 

int nextStation[s in Stations] = typeOfNext(r2d2Seq,task[s],1);
int serviceTime[s in Stations] = startOf(task[s]);

execute{
  writeln(nextStation)
  writeln(serviceTime)
}
