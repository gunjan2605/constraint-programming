/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Aug 29, 2021 at 11:10:27 PM
 *********************************************/

 using CP;
 
 {string} Letters = {"D","O","N","A","L","G","E","R","B","T"};
 range Digits = 0..9;
 dvar int value[Letters] in Digits;
 dvar int carry[1..5] in 0..1; 
 
 constraints {
   forall(ordered i,j in Letters)
     value[i] != value[j];
   value["D"] != 0;
   value["G"] != 0;
   2 * value["D"] == value["T"] + 10 * carry[1];
   carry[1] + 2 * value["L"] == value["R"] + 10 * carry[2];
   carry[2] + 2 * value["A"] == value["E"] + 10 * carry[3];
   carry[3] + value["N"] + value["R"] == value["B"] + 10 * carry[4];
   carry[4] + value["O"] + value["E"] == value["O"] + 10 * carry[5];
   carry[5] + value["D"] + value["G"] == value["R"];
 }