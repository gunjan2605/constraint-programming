/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Nov 15, 2021 at 9:54:27 AM
 *********************************************/
using CP;

//data declarations
int nbPlanets = ...;
range Planets = 0..nbPlanets-1;
int nbFighters = ...;
range Fighters = 1..nbFighters;
int capacity = ...;
int nbReliefPlanets = nbPlanets-1;
range ReliefPlanets = 1..nbReliefPlanets;

tuple Site {
int demand;
int x;
int y;
};

Site siteData[Planets] = ...;

//distance between i, j location
int dist[i in Planets,j in Planets] =
ftoi(round(sqrt((siteData[i].x - siteData[j].x)^2 + (siteData[i].y - siteData[j].y)^2)));

//transition time triplet
tuple triplet{int loc1; int loc2; int value;};
{triplet} ttimes = {<i,j,dist[i,j]> | i in Planets, j in Planets};

int demandp[p in ReliefPlanets] = siteData[p].demand;

//dvar
dvar interval task[p in Planets] size 0; 
dvar interval fighterTask[p in Planets, f in Fighters] optional;
dvar sequence fighterSeq[f in Fighters] in all(p in Planets)fighterTask[p,f] types all(p in Planets)p;
dvar int Load[f in Fighters] in 0..capacity;
dvar int vehicles[p in ReliefPlanets] in Fighters;
dvar int fighterOrder[f in Fighters] in Fighters;


execute {
  var f = cp.factory;
  cp.param.DefaultInferenceLevel = 6; 
  cp.param.NoOverlapInferenceLevel = 6;
  cp.param.CumulFunctionInferenceLevel = 6;
  cp.param.SequenceInferenceLevel = 6;
  cp.param.SequenceExpressionInferenceLevel = 6
  cp.setSearchPhases(f.searchPhase(fighterTask), f.searchPhase(fighterSeq));
   }
   
   
//objective 
minimize max(p in Planets, f in Fighters)endOf(fighterTask[p,f]); 

constraints
{
  //fighter planes start from HOLO
  startOf(task[0]) == 0;
  
  // task[0] must be present in all sequences 
  forall(f in Fighters)
    presenceOf(fighterTask[0,f]) == 1; 
   
  //the first task in all sequences should be task[0]
  forall(f in Fighters)
    first(fighterSeq[f],fighterTask[0,f]);
  
  //no overlap in a sequence 
  forall(f in Fighters)
    noOverlap(fighterSeq[f], ttimes);
  
  forall(f in Fighters)
    noOverlap(all(p in ReliefPlanets) fighterTask[p,f]);
  
  //alternative constraint
  forall(p in ReliefPlanets)
    alternative(task[p],all(f in Fighters)fighterTask[p,f]);
    
  //capacity constraint 
  forall(f in Fighters)
    sum(p in Planets)stepAtStart(fighterTask[p,f], siteData[p].demand)<=capacity;
  
  //link vehicles with sequence variable
  forall(p in ReliefPlanets, f in Fighters)
    (vehicles[p] == f) == (presenceOf(fighterTask[p,f]));
    
  pack(Load,vehicles,demandp);
  
  //symmetry breaking 
  forall(f in Fighters:f>1)
    Load[f-1] < Load[f];
  
  forall(f in Fighters: f>1)
    fighterOrder[f] == f;
}

tuple Task {
int reliefPlanet;
key int distance;
}
sorted {Task} vt[v in Fighters] = {<p, startOf(fighterTask[p,v])> | p in ReliefPlanets : presenceOf(fighterTask[p,v]) == 1};

execute{
  writeln(vt)
}




