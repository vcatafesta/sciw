/*
��������������������������������������������������������������������������͸
� Source file: SIXNSX2.CH                                                  ��
� Description: #Include file for the SIx Driver - NSX for Clipper 5.2x     ��
� Notes      : Include this file (#include "SIXNSX2.CH") in your program's ��
�              source code INSTEAD of the SIXNSX.CH file to use EXTENDED   ��
�              EXPRESSIONS with The SIx Driver - NSX.                      ��
� Notice     : Copyright 1992-1995 - SuccessWare 90, Inc.                  ��
��������������������������������������������������������������������������;�
  ���������������������������������������������������������������������������
*/

//Automatically include obsolete function header
#include "obsolete.ch"

REQUEST SIXNSX

#command CLEAR ORDER <order>                                               ;
      => Sx_ClearOrder( <order> )

#command PACK                                                              ;
      => __dbPack()                                                        ;
       ; Sx_MemoPack()

#command SET TAGORDER TO <order>                                           ;
      => ordSetFocus( <order> )

#command SET TAGORDER TO                                                   ;
      => ordSetFocus( 0 )

#command MEMOPACK [BLOCK <size>] [OPTION <opt> [STEP <step>]]              ;
      => Sx_MemoPack( <size>, <{opt}>, <step> )

#command SET ORDER TO TAG <(tag)> [OF <(cdx)>]                             ;
      => ordSetFocus( <(tag)> [, <(cdx)>] )

#command SET TAG TO <tag> [OF <(cdx)>]                                     ;
      => ordSetFocus( <(tag)> [, <(cdx)>] )

#command SET TAG TO                                                        ;
      => ordSetFocus( 0 )

#command SUBINDEX ON <key> TO <(file)>                                     ;
         [FOR <for>]                                                       ;
         [<all:   ALL>]                                                    ;
         [WHILE   <while>]                                                 ;
         [NEXT    <next>]                                                  ;
         [RECORD  <rec>]                                                   ;
         [<rest:  REST>]                                                   ;
         [<asc:   ASCENDING>]                                              ;
         [<dec:   DESCENDING>]                                             ;
         [<u:     UNIQUE>]                                                 ;
         [<empty: EMPTY>]                                                  ;
         [OPTION  <opt> [STEP <step>]]                                     ;
         [EVAL    <opt> [EVERY <step>]]                                    ;
         [<add:   ADDITIVE>]                                               ;
         [<filt:  FILTERON>]                                               ;
         [NOOPTIMIZE]                                                      ;
                                                                           ;
      => ordCondSet( <(for)>, NIL,                                         ;
                      if( <.all.>, .t., NIL ),                             ;
                      <{while}>,                                           ;
                      <{opt}>, <step>    ,                                 ;
                      RECNO(), <next>, <rec>,                              ;
                      if( <.rest.>, .t., NIL ),                            ;
                      if( (<.dec.> .AND. !<.asc.>), .t., NIL ),            ;
                      .f., NIL, .t., <.empty.>, NIL, <.add.>, NIL,         ;
                      <.filt.>)                                            ;
       ; dbCreateIndex(<(file)>, <(key)>, NIL,                             ;
                        if(<.u.>, .t., NIL))                               ;


#command SUBINDEX ON <key> TAG <(tag)> [OF <(nsx)>]                        ;
         [FOR <for>]                                                       ;
         [<all:   ALL>]                                                    ;
         [WHILE   <while>]                                                 ;
         [NEXT    <next>]                                                  ;
         [RECORD  <rec>]                                                   ;
         [<rest:  REST>]                                                   ;
         [<asc:   ASCENDING>]                                              ;
         [<dec:   DESCENDING>]                                             ;
         [<u:     UNIQUE>]                                                 ;
         [<empty: EMPTY>]                                                  ;
         [OPTION  <opt> [STEP <step>]]                                     ;
         [EVAL    <opt> [EVERY <step>]]                                    ;
         [<add:   ADDITIVE>]                                               ;
         [<filt:  FILTERON>]                                               ;
         [NOOPTIMIZE]                                                      ;
                                                                           ;
      => ordCondSet(<(for)>, NIL,                                          ;
                      if( <.all.>, .t., NIL ),                             ;
                      <{while}>,                                           ;
                      <{opt}>, <step>    ,                                 ;
                      RECNO(), <next>, <rec>,                              ;
                      if( <.rest.>, .t., NIL ),                            ;
                      if( (<.dec.> .AND. !<.asc.>), .t., NIL ),            ;
                      .t., <(nsx)>, .t., <.empty.>, NIL, <.add.>, NIL,     ;
                      <.filt.>)                                            ;
       ; ordCreate(<(nsx)>, <(tag)>, <(key)>, NIL,                         ;
                        if(<.u.>, .t., NIL))                               ;

#command INDEX ON <key> TO <(file)>                                        ;
         [FOR <for>]                                                       ;
         [<all:   ALL>]                                                    ;
         [WHILE   <while>]                                                 ;
         [NEXT    <next>]                                                  ;
         [RECORD  <rec>]                                                   ;
         [<rest:  REST>]                                                   ;
         [<asc:   ASCENDING>]                                              ;
         [<dec:   DESCENDING>]                                             ;
         [<u:     UNIQUE>]                                                 ;
         [<cur:   USECURRENT>]                                             ;
         [<cur:   SUBINDEX>]                                               ;
         [<empty: EMPTY>]                                                  ;
         [OPTION  <opt> [STEP <step>]]                                     ;
         [EVAL    <opt> [EVERY <step>]]                                    ;
         [<add:   ADDITIVE>]                                               ;
         [<filt:  FILTERON>]                                               ;
         [NOOPTIMIZE]                                                      ;
                                                                           ;
      => ordCondSet(<(for)>, NIL,                                          ;
                      if( <.all.>, .t., NIL ),                             ;
                      <{while}>,                                           ;
                      <{opt}>, <step>    ,                                 ;
                      RECNO(), <next>, <rec>,                              ;
                      if( <.rest.>, .t., NIL ),                            ;
                      if( (<.dec.> .AND. !<.asc.>), .t., NIL ),            ;
                      .f., NIL, <.cur.>, <.empty.>, NIL, <.add.>, NIL,     ;
                      <.filt.>)                                            ;
       ; dbCreateIndex(<(file)>, <(key)>, NIL,                             ;
                        if(<.u.>, .t., NIL))                               ;


#command INDEX ON <key> TAG <(tag)> [OF <(nsx)>]                           ;
         [FOR <for>]                                                       ;
         [<all:   ALL>]                                                    ;
         [WHILE   <while>]                                                 ;
         [NEXT    <next>]                                                  ;
         [RECORD  <rec>]                                                   ;
         [<rest:  REST>]                                                   ;
         [<asc:   ASCENDING>]                                              ;
         [<dec:   DESCENDING>]                                             ;
         [<u:     UNIQUE>]                                                 ;
         [<cur:   USECURRENT>]                                             ;
         [<cur:   SUBINDEX>]                                               ;
         [<empty: EMPTY>]                                                  ;
         [OPTION  <opt> [STEP <step>]]                                     ;
         [EVAL    <opt> [EVERY <step>]]                                    ;
         [<add:   ADDITIVE>]                                               ;
         [<filt:  FILTERON>]                                               ;
         [NOOPTIMIZE]                                                      ;
                                                                           ;
      => ordCondSet(<(for)>, NIL,                                          ;
                      if( <.all.>, .t., NIL ),                             ;
                      <{while}>,                                           ;
                      <{opt}>, <step>    ,                                 ;
                      RECNO(), <next>, <rec>,                              ;
                      if( <.rest.>, .t., NIL ),                            ;
                      if( (<.dec.> .AND. !<.asc.>), .t., NIL ),            ;
                      .t., <(nsx)>, <.cur.>, <.empty.>, NIL, <.add.>,      ;
                      NIL, <.filt.>)                                       ;
       ; ordCreate(<(nsx)>, <(tag)>, <(key)>, NIL,                         ;
                        if(<.u.>, .t., NIL))                               ;

#command REINDEX                                                           ;
         [EVAL    <opt> [EVERY <step>]]                                    ;
         [OPTION  <opt> [STEP <step>]]                                     ;
      => ordCondSet(,,,, <{opt}>, <step>,,,,,,,,,,,)                       ;
       ; dbReindex()

#command DELETE TAG <(tag1)> [OF <(cdx1)>]                                 ;
         [, <(tagn)> [OF <(cdxn)>]]                                        ;
      => ordDestroy( <(tag1)>, <(cdx1)> )                                  ;
      [; ordDestroy( <(tagn)>, <(cdxn)> )]

#command DELETE TAG ALL [OF <(cdx)>]                                       ;
      => Sx_KillTag( .t., <(cdx)> )

// Clear both values
#command CLEAR SCOPE                                                       ;
      => Sx_ClrScope()

// First value, inclusive
#xcommand SET SCOPETOP TO <value>                                          ;
      => Sx_SetScope(0, <value>)

#xcommand SET SCOPETOP TO                                                  ;
      => Sx_ClrScope(0)

// Last value, inclusive
#xcommand SET SCOPEBOTTOM TO <value>                                       ;
      => Sx_SetScope(1, <value>)

#xcommand SET SCOPEBOTTOM TO                                               ;
      => Sx_ClrScope(1)

// Clear both values
#command SET SCOPE TO                                                      ;
      => Sx_ClrScope()

// Both values, inclusive
#command SET SCOPE TO <value>                                              ;
      => Sx_SetScope(0, <value>)                                           ;
       ; Sx_SetScope(1, <value>)

#command SET TURBOREAD ON                                                  ;
      => Sx_SetDirty(.t.)

#command SET TURBOREAD OFF                                                 ;
      => Sx_SetDirty(.f.)

#command SET MEMOBLOCK TO <value>                                          ;
      => Sx_SetMemoBlock(<value>)

#command SORT [TO <(file)>] [ON <fields,...>]                              ;
         [FOR <for>]                                                       ;
         [WHILE <while>]                                                   ;
         [NEXT <next>]                                                     ;
         [RECORD <rec>]                                                    ;
         [<rest:REST>]                                                     ;
         [ALL]                                                             ;
         [<cur: USECURRENT>]                                               ;
                                                                           ;
      => Sx_SortOption(<.cur.>)                                            ;
       ; __dbSort(<(file)>, { <(fields)> },                                ;
                   <{for}>, <{while}>, <next>, <rec>, <.rest.>)

#xcommand WILDSEEK <str>                                                   ;
      => Sx_WildSeek( <str> )

#xcommand WILDSEEKNEXT <str>                                               ;
      => Sx_WildSeek( <str>, .T. )

//Manifest Constants
//Event Constants for Trigger System

#define  EVENT_PREUSE       1
#define  EVENT_POSTUSE      2
#define  EVENT_UPDATE	    3
#define  EVENT_APPEND       4
#define  EVENT_DELETE       5
#define  EVENT_RECALL       6
#define  EVENT_PACK         7
#define  EVENT_ZAP	    8
#define  EVENT_PUT          9
#define  EVENT_GET          10
#define  EVENT_PRECLOSE     11
#define  EVENT_POSTCLOSE    12
#define  EVENT_PREMEMOPACK  13
#define  EVENT_POSTMEMOPACK 14

//===============================
// Trigger Toggle Values

#define  TRIGGER_ENABLE     1
#define  TRIGGER_DISABLE    2
#define  TRIGGER_REMOVE	    3
#define  TRIGGER_INSTALL    4
#define  TRIGGER_PENDING    5  //Internal Use Only


// FPT file types
// ==============================

#define BLOB_FILECOMPRESS   1
#define BLOB_FILEENCRYPT    2

//Redefinition of USE for TRIGGERS and PASSWORDS
#command USE <(db)>                                                     ;
             [VIA <rdd>]                                                ;
             [ALIAS <a>]                                                ;
             [<new: NEW>]                                               ;
             [<ex: EXCLUSIVE>]                                          ;
             [<sh: SHARED>]                                             ;
             [<ro: READONLY>]                                           ;
             [INDEX <(index1)> [, <(indexn)>]]                          ;
             [TRIGGER <trig>]                                           ;
             [PASSWORD <password>]                                      ;
                                                                        ;
       => SX_SETTRIG(TRIGGER_PENDING, <trig>)                           ;
          [;SX_SETPASS( <password>, 1)]                                 ;
          ;dbUseArea(                                                   ;
                    <.new.>, <rdd>, <(db)>, <(a)>,                      ;
                    if(<.sh.> .or. <.ex.>, !<.ex.>, NIL), <.ro.>        ;
                  )                                                     ;
                                                                        ;
      [; dbSetIndex( <(index1)> )]                                      ;
      [; dbSetIndex( <(indexn)> )]

