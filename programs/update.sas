/*********************************************
* Roy Pardee
* Group Health Research Institute
* (206) 287-2078
* pardee.r@ghc.org
*
* c:\Documents and Settings\pardre1\My Documents\vdw\chemo_codes\programs\update.sas
*
* <<purpose>>
*********************************************/

%**include "\\home\pardre1\SAS\Scripts\remoteactivate.sas" ;

options
  linesize = 150
  nocenter
  msglevel = i
  NOOVP
  formchar = '|-++++++++++=|-/|<>*'
  dsoptions="note2err" NOSQLREMERGE
;

%let mdb_file = C:\Documents and Settings\pardre1\My Documents\vdw\chemo_codes\data\chemo_codes.mdb ;
libname mdb ODBC required = "DRIVER=Microsoft Access Driver (*.mdb);DBQ=&mdb_file" ;

libname dat 'C:\Documents and Settings\pardre1\My Documents\vdw\chemo_codes\data' ;

%macro compare ;
  proc sql ;
    title "NDCs we have that arent in Addies dset" ;
    select d.*
    from mdb.drugs as d LEFT JOIN
          dat.rx_codes as r
    on    d.ndc = r.ndc
    where r.ndc IS NULL
    order by chemo_type, ndc
    ;
    title " " ;
    title "Procs we have that arent in Addies dset" ;
    select p.*
    from    mdb.procedures as p LEFT JOIN
            dat.px_codes as a
    on      p.px = a.px AND
            p.code_type = a.code_type
    where   a.px IS NULL and p.code_type ne 'LHGR'
    order by chemo_type, px
    ;

    title "NDCs in Addies dset that arent in ours." ;
    select r.*
    from mdb.drugs as d RIGHT JOIN
          dat.rx_codes as r
    on    d.ndc = r.ndc
    where d.ndc IS NULL
    order by chemo_type, ndc
    ;
    title " " ;
    title "Procs in Addies dset that arent in ours." ;
    select  a.*
    from    mdb.procedures as p RIGHT JOIN
            dat.px_codes as a
    on      p.px = a.px AND
            p.code_type = a.code_type
    where   p.px IS NULL
    order by chemo_type, px
    ;
    title " " ;
  quit ;
%mend compare ;

%macro update ;
  %** Adds anything not already found in Addies dset to our tables. ;
  %** Does not do any deletes--do those manually. ;
  proc sql ;
    create table new_px as
    select  a.*
    from    mdb.procedures as p RIGHT JOIN
            dat.px_codes as a
    on      p.px = a.px AND
            p.code_type = a.code_type
    where   p.px IS NULL
    order by chemo_type, px
    ;

    select max(list_version) + 1 into :new_list_version
    from mdb.procedures
    ;

    insert into mdb.procedures(PX
                          , CODE_TYPE
                          , CHEMO_TYPE
                          , DESCRIPTION
                          , list_version)
    select PX
         , CODE_TYPE
         , CHEMO_TYPE
         , DESCRIPTION
         , &new_list_version
    from new_px
    ;
  quit ;
%mend update ;

options orientation = landscape ;

ods graphics / height = 6in width = 10in ;

%let out_folder = C:\Documents and Settings\pardre1\My Documents\vdw\chemo_codes\output\ ;

ods html path = "&out_folder" (URL=NONE)
         body = "chemo_list_reconciliation.html"
         (title = "Chemo List Reconciliation")
          ;

  %compare ;
ods _all_ close ;

