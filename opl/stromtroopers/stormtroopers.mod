/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Sep 7, 2021 at 3:22:15 PM
 *********************************************/
using CP;

int n = ...;

{int} legion = {t | t in 1..n};

dvar int s[legion] in 0..n-1;

constraints {
    
    forall(ordered i,j in legion)
      {
        s[i]!=s[j];
        } 
         
    forall(i in 1..n-2)
      {
        forall (j in i..n-2)
          {
        abs(s[i+1]-s[i])!= abs(s[j+2]-s[j+1]);
      }        
    }      
}



