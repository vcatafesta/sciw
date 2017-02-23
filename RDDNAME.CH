//#DEFINE FOXPRO
//#DEFINE DBFNTX
#DEFINE DBFCDX
//#DEFINE DBFNSX
//#DEFINE DBFMDX
//#DEFINE DBPX

	//REQUEST DBFNTX
   //REQUEST DBFCDX
   //REQUEST DBFMDX
   //REQUEST DBPX

#IFDEF FOXPRO
  #include "SIXNSX.CH"
  #define MEMOEXT  ".SMT"
  #define INDEXEXT ".NSX"
  #define RDDNAME  "SIXNSX"
  #Define CEXT     "NSX"
#ENDIF
#IFDEF DBFNSX
  #include "HBSIX.CH"
  #include "DBINFO.CH"
  REQUEST dbfnsx
  #define FOXPRO
  #define MEMOEXT  ".SMT"
  #define INDEXEXT ".NSX"
  #define RDDNAME  "DBFNSX"
  #define REQNAME  "DBFNSX"
  #Define CEXT     "NSX"
#ENDIF
#IFDEF DBFNTX
  #include "DBINFO.CH"
  REQUEST dbfntx
  #define MEMOEXT  ".DBT"
  #define INDEXEXT ".NTX"
  #define RDDNAME  "DBFNTX"
  #define REQNAME  "DBFNTX"
  #Define CEXT     "NTX"
#ENDIF
#IFDEF DBFCDX
  #include "DBINFO.CH"
  REQUEST dbfcdx
  #define FOXPRO
  #define MEMOEXT  ".DBT"
  #define INDEXEXT ".CDX"
  #define RDDNAME  "DBFCDX"
  #define REQNAME  "DBFCDX"
  #Define CEXT     "CDX"
#ENDIF
#IFDEF DBFMDX
  #include "DBINFO.CH"
  REQUEST dbfmdx
  #define FOXPRO
  #define MEMOEXT  ".DBT"
  #define INDEXEXT ".MDX"
  #define RDDNAME  "DBFMDX"
  #define REQNAME  "DBFMDX"
  #Define CEXT     "MDX"
#ENDIF
#IFDEF DBPX
  #include "DBINFO.CH"
  REQUEST dbpx
  #define FOXPRO
  #define MEMOEXT  ".DBT"
  #define INDEXEXT ".PX"
  #define RDDNAME  "DBPX"
  #define REQNAME  "DBPX"
  #Define CEXT     "PX"
#ENDIF
