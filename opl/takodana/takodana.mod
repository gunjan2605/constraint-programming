/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Oct 29, 2021 at 4:10:58 PM
 *********************************************/
using CP;

{string} Tasks = ...;
int nbHouses  = ...;
range Houses = 1..nbHouses;
int duration[Tasks] =  ...;
int releaseDate[Houses] = ...;
tuple Prec { string before; string after; };

{Prec} Precedences = ...;

tuple Deadline { string t; int date; float cost; };
{Deadline} Earliness = ...;
{Deadline} Tardiness = ...;
int maxEarlinessCost = ...;

int horizon = sum(h in Houses, t in Tasks)duration[t];

dvar interval act[h in Houses, t in Tasks] in 0..horizon size duration[t];

minimize sum(d in Tardiness, h in Houses) d.cost*maxl(0, endOf(act[h,d.t]) - d.date);

constraints{
  //precedence 
  forall(h in Houses, p in Precedences)
    endBeforeStart(act[h,p.before], act[h, p.after]);
  //release date
  forall(h in Houses, t in Tasks)
    startOf(act[h,t]) >= releaseDate[h];
  //max earliness cost
  sum(d in Earliness, h in Houses) d.cost*maxl(0,d.date-startOf(act[h,d.t])) <= maxEarlinessCost;
}

int startDate[h in Houses, t in Tasks] = startOf(act[h,t]);

execute{
  writeln(startDate)
}
