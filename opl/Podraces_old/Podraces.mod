/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Oct 5, 2021 at 3:59:19 PM
 *********************************************/
using CP;

int nbCompetitors = ...;

execute{
  cp.param.AllDiffInferenceLevel = 6;
}

range FS = 0..1;
range Days = 1..nbCompetitors-1;
range Tracks = 1..nbCompetitors div 2;
range Competitors = 1..nbCompetitors;

dvar int competitors[Days, Tracks, FS] in Competitors;
//dvar int opponent[Days,Competitors] in Competitors; 

constraints{
  //every competitor races everyday
  forall (d in Days)
    allDifferent(all(t in Tracks, f in FS)competitors[d,t,f]);
    
  //every competitor races atmost twice on a track
  forall (c in Competitors)
    forall(t in Tracks)
      count((all(d in Days, f in FS)competitors[d,t,f]),c)<=2;
      
  //every competitor competes with each other 
  
 forall(d in Days, t in Tracks)
   competitors[d,t,0]<competitors[d,t,1];
  
  forall(ordered c1, c2 in Competitors)
    sum(d in Days, t in Tracks) (competitors[d,t,0]==c1 && competitors[d,t,1]==c2) == 1;  

}