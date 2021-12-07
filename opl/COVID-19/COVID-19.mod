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

dvar int ResidentAllot[Patients] in Residents; //resident alloted to each patient 
dvar int Rload[Residents] in 0..maxLoad; 

minimize standardDeviation(Rload);

constraints{
  
  // Constraint on max load of a resident 
  pack(Rload, ResidentAllot,patientLoad);   
 
  // Constraint on number of patients to each resident
  forall(r in Residents)
    (sum(p in Patients)(ResidentAllot[p] == r)<=maxPatients) + (sum(p in Patients)(ResidentAllot[p] == r)>=minPatients) == 2;
     
  // Each resident works only in one zone
  
  forall(ordered i,j in Patients){
    if (patientZone[i]!= patientZone[j]){
      ResidentAllot[i]!= ResidentAllot[j];
    } 
  } 
}

{int} residentPatients[r in Residents] = { p | p in Patients: ResidentAllot[p]==r};

execute{
  writeln(residentPatients)
}
