/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Oct 24, 2021 at 12:56:00 PM
 *********************************************/
/*********************************************
 * OPL 20.1.0.0 Model
 * Author: gunjan
 * Creation Date: Sep 27, 2021 at 8:00:29 PM
 *********************************************/
using CP;


execute{
  cp.param.TimeLimit = 300;
}

int nbResidents = ...;
int minPatients = ...;
int maxPatients = ...;
int maxLoad = ...;
range Residents = 1..nbResidents;
int nbPatients = ...;
range Patients = 1..nbPatients;

tuple PatientData {
  int load;
  int zone;
}

PatientData patientData[Patients] = ...;

int patientLoad[p in Patients] = patientData[p].load;
int patientZone[p in Patients] = patientData[p].zone;

int nbPatientsZ1 = sum(p in Patients)(patientZone[p]==1);

int totalLoad = sum(p in Patients) patientLoad[p];

dvar int ResidentAllot[Patients] in Residents; //resident alloted to each patient 
dvar int Rload[Residents] in (min (p in Patients)patientLoad[p])..maxLoad; 
//dvar int Zone[Residents] in 1..2;
dexpr int a = max(o in Patients: nbPatientsZ1>=o>=1) ResidentAllot[o];

minimize standardDeviation(Rload);

constraints{
  
  
  // Constraint on max load of a resident 
  pack(Rload, ResidentAllot,patientLoad);   
 
  // Constraint on number of patients to each resident
  forall(r in Residents)
    (count(ResidentAllot,r) >= minPatients) && (count(ResidentAllot,r) <= maxPatients);
     
  // Each resident works only in one zone
  forall(ordered i,j in Patients){  
    if (patientZone[i]!= patientZone[j]){
      ResidentAllot[i] != ResidentAllot[j];
    } 
  }
  
  //redundant constraint on Rload
  sum(r in Residents)Rload[r] == totalLoad; 
  
  //symmetry breaking
  ResidentAllot[1] == 1; 
  forall(p in Patients: p>1)
    ResidentAllot[p] <= max(o in Patients: o<p) ResidentAllot[o] + 1;
    
  forall(p in Patients: nbPatientsZ1<p)
    ResidentAllot[p] > a;
}

{int} residentPatients[r in Residents] = { p | p in Patients: ResidentAllot[p]==r};

execute{
  writeln(residentPatients)
}
