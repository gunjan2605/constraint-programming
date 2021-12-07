/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Sep 14, 2021 at 5:29:10 PM
 *********************************************/
using CP;

int nbPeriods= ...;
int minCourses= ...; /* minimum amount of courses necessary per period */
int maxCourses= ...; /* maximum amount of courses allowed per period */
int minUnit= ...; /* minimum number of units necessary per period */
int maxUnit= ...; /* maximum number of units allowed per period */

{string} Courses = ...;

int unit[Courses] = ...;

tuple prec {
  string after;
  string before;
}
{prec} Prerequisites = ...;

range Periods = 1..nbPeriods;

dvar int period[Courses] in Periods;

minimize max(t in Periods)(sum(c in Courses)(period[c]==t));

constraints{
//Pre-requisite contraint
forall(p in Prerequisites)
  period[p.before] < period[p.after];
    
//Amount of courses constraint 
forall(i in Periods)
  (sum(c in Courses)(period[c]==i)>=minCourses) + (sum(c in Courses)(period[c]==i)<=maxCourses) == 2;

// Units of  constraint 
forall(j in Periods)
  (sum(c in Courses)((period[c]==j)*unit[c])>=minUnit) + (sum(c in Courses)((period[c]==j)*unit[c])<=maxUnit) == 2; 
}
 