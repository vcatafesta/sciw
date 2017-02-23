//#COMMAND PrintPos( <row>, <col>, <xpr> [,<color>] )                   ;
//          => DevPos( <row>, <col> )                                   ;
//           ; DevOut( <xpr> [, <color>] )
#COMMAND Area( <whatever> )                                             ;
          => dbSelectArea( <(whatever)> )
#COMMAND Order( <nOrdem> )						;
	  => DbSetOrder( <nOrdem> )
#COMMAND At <row>, <col> SAY <xpr>                                      ;
            [PICTURE <pic>]                                             ;
            [COLOR <color>]                                             ;
         => DevPos( <row>, <col> )                                      ;
          ; DevOutPict( <xpr>, <pic> [, <color>] )

#COMMAND Print <row>, <col> <xpr>                                       ;
               [PICTURE <pic>]                                          ;
               [COLOR <color>]                                          ;
         => DevPos( <row>, <col> )                                      ;
          ; DevOutPict( <xpr>, <pic> [, <color>] )

#COMMAND Print <row>, <col> <xpr>                                       ;
               [COLOR <color>]                                          ;
          => DevPos( <row>, <col> )                                     ;
           ; DevOut( <xpr> [, <color>] )

#COMMAND @ <row>, <col> GET <var> [PICTURE <pic>] [VALID <valid>]       ;
                        [WHEN <when>]                                   ;
                        [SEND <msg>]                                    ;
         => SetCursor(1)                                                ;
          ; SetPos( <row>, <col> )                                      ;
          ; AAdd( GetList, _GET_( <var>, <(var)>, <pic>, <{valid}>, <{when}>));
          [; ATail(GetList):<msg>]

#COMMAND Print <row>, <col> GET <var> [PICTURE <pic>] [VALID <valid>]   ;
                            [WHEN <when>]                               ;
                            [SEND <msg>]                                ;
          => SetCursor(1)                                               ;
           ; SetPos( <row>, <col> )                                     ;
           ; AAdd( GetList, _GET_( <var>, <(var)>, <pic>, <{valid}>,<{when}>));
           [; ATail(GetList):<msg>]

#COMMAND @ <row>, <col> SAY <sayxpr> [<sayClauses,...>]                 ;
                        GET <var>                                       ;
                        [<getClauses,...>]                              ;
         => SetCursor(1)                                                ;
          ; @ <row>, <col> SAY <sayxpr> [<sayClauses>]                  ;
          ; @ Row(), Col()+1 GET <var> [<getClauses>]

#COMMAND Print <row>, <col> <sayxpr> [<sayClauses,...>]                 ;
                      GET <var>                                         ;
                      [<getClauses,...>]                                ;
         => SetCursor(1)                                                ;
          ; @ <row>, <col> SAY <sayxpr> [<sayClauses>]                  ;
          ; @ Row(), Col()+1 GET <var> [<getClauses>]
#Define  P_DEF(Par, Def)    Par := IF( Par = Nil, Def, Par )
#Define  PA             24
#Define  PB             25
#Define  PC             26
#Define  PD             27
#Define  VOID           Nil

#Define  ULTRAPQ        Chr(30) + "5"
#Define  F2             -1
#Define  F3             -2
#Define  F4             -3
#Define  F5             -4
#Define  F6             -5
#Define  F7             -6
#Define  F8             -7
#Define  F9             -8
#Define  F10            -9
#Define  F11            -10
#Define  ZERO           0
#Define  UM             1
#Define  DOIS           2
#Define  TRES           3
#Define  QUATRO         4
#Define  CINCO          5
#Define  SEIS           6
#Define  SETE           7
#Define  OITO           8
#Define  NOVE           9
#Define  DEZ            10
#Define  ONZE           11
#Define  DOZE           12
#Define  TREZE          13
#Define  SIM            1
#Define  NAO            2
#Define  ESC            27
#Define  ENTER          13
#Define  MAXIMO         1000
#Define  OK             .T.
#Define  FALSO          .F.
#Define  MENU_LINHA     UM
#Define  CPI10132       132
#Define  CPI12132       151
#Define  CPI1080        80
#Define  CPI1280        93
#Define  SEP            "-"
#Define  TECLA_DELETE   7
#Define  TECLA_ENTER    13
#Define  TECLA_INSERT   22
#Define  TECLA_ALTC     302
#define  TELA           22
#define  NORMAL         0
#define  AUTO           1
#Define  COR            IF( FMono(), 7, 31 )
#Define  UP             5
#Define  DOWN           24
#Define  PGUP           18
