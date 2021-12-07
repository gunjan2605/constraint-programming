/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Sep 3, 2021 at 10:46:39 AM
 *********************************************/
using CP;
 
{string} color_set = {"red","green","white","yellow","blue"}; 
{string} animal_set = {"dog","zebra","fox","snail","horse"};
{string} drinks_set = {"juice", "water", "tea", "coffee", "milk"};
{string} person_set = {"english","spaniard","japanese","italian","norwegian"};
{string} job_set = {"painter", "diplomat", "violinist", "doctor", "sculptor"};

 /* 0-> leftmost house, 4-> rightmost house:*/
 
/* {string} features = {"english","spaniard","japanese","italian","norwegian","red",
                      "green","white","yellow","blue","dog","fox","horse","snails","zebra",
                      "milk","fruit juice","tea","water","coffee","painter","sculptor","diplomat","violinist",
                      "doctor"};
                      */
                      
 range house_location = 0..4;
 
 dvar int color[color_set] in house_location;
 dvar int animal[animal_set] in house_location;
 dvar int drinks[drinks_set] in house_location;
 dvar int person[person_set] in house_location;
 dvar int job[job_set] in house_location;
 
 constraints{
   
   forall(ordered i,j in color_set)
     color[i] != color[j];
   
   forall(ordered i,j in animal_set)
     animal[i] != animal[j];
   
   forall(ordered i,j in drinks_set)
     drinks[i] != drinks[j];
   
   forall(ordered i,j in person_set)
     person[i] != person[j];
    
   forall(ordered i,j in job_set)
     job[i] != job[j];
   
     
   person["english"] == color["red"];
   person["spaniard"] == animal["dog"];
   person["japanese"] == job["painter"];
   person["italian"]== drinks["tea"];
   person["norwegian"] == 0;
   color["green"] == drinks["coffee"];
   color["green"] == color["white"] + 1;
   job["sculptor"] == animal["snail"];
   job["diplomat"] == color["yellow"];
   drinks["milk"] == 2;
   (person["norwegian"] == (color["blue"]+1)) + (person["norwegian"] == (color["blue"]-1)) == 1;
   job["violinist"] == drinks["juice"];
   (animal["fox"] == (job["doctor"]+1)) + (animal["fox"] == (job["doctor"]-1)) == 1;
   (animal["horse"] == (job["diplomat"]+1)) + (animal["horse"] == (job["diplomat"]-1)) == 1;
 }