/*********************************************
* Roy Pardee
* Group Health Research Institute
* (206) 287-2078
* pardee.r@ghc.org
*
* \\groups\data\CTRHS\Crn\Pharmacovigilance\programming\programs\chemo_codes_to.sas
*
* Spits out the chemo-signifying procedure and drug code lists to SAS dsets.
*********************************************/

%**include "\\home\pardre1\SAS\Scripts\remoteactivate.sas" ;

options linesize = 150 nocenter msglevel = i NOOVP formchar='|-++++++++++=|-/|<>*' dsoptions="note2err" NOSQLREMERGE ;

%let mdb_file = \\groups\data\ctrhs\crn\Pharmacovigilance\programming\data\chemo_codes.mdb ;
libname mdb ODBC required = "DRIVER=Microsoft Access Driver (*.mdb);DBQ=&mdb_file" ;

libname s '\\ctrhs-sas\SASUser\pardre1\pharmacovigilance\analysis' ;

data s.chemo_procedure_codes ;
  set mdb.procedures ;
  ** where concentration is not null ;
  ** where chemo_type in ('A', 'H') ;
run ;

data s.chemo_drug_codes ;
  set mdb.drugs ;
  ** where concentration is not null ;
  ** where chemo_type in ('A', 'H') ;
run ;
