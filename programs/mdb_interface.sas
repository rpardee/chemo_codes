/*********************************************
* Roy Pardee
* Group Health Research Institute
* (206) 287-2078
* pardee.r@ghc.org
*
* c:\Documents and Settings\pardre1\My Documents\vdw\chemo_codes\programs\mdb_out.sas
*
* Handles data transfer to and from the mdb file.
* I am treating the mdb file as the authoritative store b/c it makes it easy
* to enforce no-duplication rules, and gives a decent UI for managing the lists.
*
*********************************************/

options
  linesize  = 150
  msglevel  = i
  formchar  = '|-++++++++++=|-/|<>*'
  dsoptions = note2err
  nocenter
  noovp
  nosqlremerge
;

** For inspecting SQL sent to a server. ;
** options sastrace = ',,,d' sastraceloc = saslog nostsuffix ;

%let out_folder   = C:\Documents and Settings\pardre1\My Documents\vdw\chemo_codes\data\ ;
%let mdb_file     = &out_folder.chemo_codes.mdb ;
%let table_names  = drugs procedures diagnoses ;

libname mdb ODBC required = "DRIVER=Microsoft Access Driver (*.mdb);DBQ=&mdb_file" ;
libname out "&out_folder" ;

%macro from_mdb ;
  %local i ;
  %local tname ;
  %** No doubt there is a more graceful way to do this, but I am not going to take the time. ;
  %do i = 1 %to 9 ;
    %let tname = %scan(&table_names, &i) ;
    %if %length(&tname) > 0 %then %do ;
      %put working on &tname ;
      data out.&tname ;
        set mdb.&tname ;
      run ;
      %** This was a high hit in the help file, but seems to be dependant on sas/intrnet or some such. ;
      %**ds2csv(csvfile = "&out_folder.&tname..csv", openmode=REPLACE, colhead=Y, data = out.&tname) ;
      %** Thanks to http://studysas.blogspot.com/2009/02/how-to-create-comma-separated-file-csv.html for this approach. ;
      proc export
        data = out.&tname
        file = "&out_folder.&tname..csv"
        REPLACE
      ;
    %end ;
  %end ;

%mend from_mdb ;

%macro to_mdb ;
  %** I assume at some point someone will update not the mdb, but either the sas dset or csv file(s).  ;
  %** The task here is to move any codes in these files that is not already in the appropriate table into ;
  %** a new table, for perusing and manual inclusion. ;
  %local i ;
  %local tname ;
  %** No doubt there is a more graceful way to do this, but I am not going to take the time. ;
  %do i = 1 %to 9 ;
    %let tname = %scan(&table_names, &i) ;
    %if %length(&tname) > 0 %then %do ;
      %put working on &tname ;
      %put reading csv. ;
      proc import
        datafile  = "&out_folder.&tname..csv"
        out       = &tname._csv
        dbms      = dlm
        replace
      ;
        delimiter     =  "," ;
        getnames      = yes ;
        guessingrows  = 900 ;
      run ;
      %** Kludge--import thinks NDC is a numeric.  Sad face. ;
      %if &tname = drugs %then %do ;
        data &tname._csv ;
          length ndc $ 11 ;
          set &tname._csv(rename = (ndc = _ndc)) ;
          ndc = put(_ndc, z11.0) ;
          drop _ndc ;
        run ;
      %end ;
      proc sql ;
        create table all_&tname as
        select * from &tname._csv
        UNION
        select * from out.&tname
        ;
      quit ;
      proc contents noprint data = all_&tname out = delete_me ;
      run ;
      ** proc print ;
      run ;
      proc sql noprint ;
        select name into :key
        from delete_me
        where varnum = 1
        ;
        drop table delete_me
        ;
        create table new_&tname as
        select *
        from all_&tname
        where &key not in (select &key from mdb.&tname)
        ;

        %if &SQLOBS > 0 %then %do ;
          %put There are new %trim(&key)s to add to &tname!!! ;
          %if %sysfunc(exist(mdb.new_&tname)) %then %do ;
            drop table mdb.new_&tname ;
          %end ;
          create table mdb.new_&tname as
          select *
          from new_&tname
          ;
        %end ;
        %else %do ;
          %put There are no new %trim(&key)s to bring into the mdb. ;
        %end ;

      quit ;
    %end ;
  %end ;


%mend to_mdb ;

%to_mdb ;