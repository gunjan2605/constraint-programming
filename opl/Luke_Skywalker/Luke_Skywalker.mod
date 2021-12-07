/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Sep 3, 2021 at 9:21:27 AM
 *********************************************/
 using CP;
 
 /*
 int house_location[1..5] = [1,2,3,4,5];
 string house_color[1..5] = ["Red","Blue","Green","White","Blue"]; 
 string pet[1..5] = ["Dog","Fox","Horse","Snails","Zebra"];
 string drink[1..5] = ["Milk","Fruit Juice","Tea",""]
 */
 
 /* 0-> leftmost house, 4-> rightmost house:*/
 
 {string} features = {"english","spaniard","japanese","italian","norwegian","red",
                      "green","white","yellow","blue","dog","fox","horse","snails","zebra",
                      "milk","fruit juice","tea","water","coffee","painter","sculptor","diplomat","violinist",
                      "doctor"};
                      
 range house_location = 0..4;
 
 dvar int value[features] in house_location;
 
 constraints{
   
   /*forall(ordered i,j in Letters)
     value[i] != value[j];*/
     
   value["english"] == value["red"];
   value["spaniard"] == value["dog"];
   value["japanese"] == value["painter"];
   value["italian"]== value["tea"];
   value["norwegian"] == 0;
   value["green"] == value["coffee"];
   value["green"] == value["white"] + 1;
   value["sculptor"] == value["snails"];
   value["diplomat"] == value["yellow"];
   value["milk"] == 2;
   (value["norwegian"] == value["blue"]+1) + (value["norwegian"] == value["blue"]-1) == 1;
   value["violinist"] == value["fruit juice"];
   (value["fox"] == value["doctor"]+1) + (value["fox"] == value["doctor"]-1) == 1;
   (value["horse"] == value["diplomat"]+1) + (value["horse"] == value["diplomat"]-1) == 1;
 }