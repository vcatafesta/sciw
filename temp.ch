#translate IfNil( <var>, <val> )        => IF( <var> = NIL, <var> := <val>, <var> )
#translate IFNIL( <var>, <val> )        => IF( <var> = NIL, <var> := <val>, <var> )
#Translate Try 				 => While
#Translate EndTry           => EndDo
#Translate LastCol          => MaxCol
#Translate LastRow          => MaxRow

#define LD_TYP_IBM9             1   // type definition for IBM Graphic printer with 9 pins
#define LD_TYP_IBM24 			  5	// type definition for IBM Graphic printer with 24 pins
#define LD_TYP_EPSON9			 11	// type definition for EPSON printer with 9 pins
#define LD_TYP_EPSON24			 15   // type definition for EPSON printer with 24 pins
#define LD_TYP_PCL3				 33	// type definition for PCL3 printer pre(HP Deskjet)
#define LD_TYP_PCL3ENH			 34   // type definition for enhanced PCL3 printer(HP DeskjPlus)
#define LD_TYP_PCL4				 35	// type definition for PCL4 printer (HP Laserjet II)
#define LD_TYP_PCL5				 36	// type definition for PCL5 printer (HP Laserjet III)
#define CONTAS_A_RECEBER    3
#define  S_TOP              0
#define	S_BOTTOM 			 1
#Define	_CODIGO				 12
#Define	SUB					 9
#Define	MIL					 1000
#Define	TAXAMACRO_1 		 1.05415  // Taxa para 30 dias
#Define	TAXAMACRO_5 		 0.23616  // Taxa para 5 pgtos
#Define	TAXAMACRO_10		 0.13558  // Taxa para 5 pgtos
#Define	TAXAMACRO_VENDEDOR 1.1		 // Taxa para Vendedor
#Define	CTRL_END_SPECIAL	 .T.
#Define	SWAP					 .T.
#Define	MULTI 				 .F.
#Define	CODEBAR				 .F.
#Define	FANTACODEBAR		 ""
#Define	LIG					 .T.
#Define	DES					 .F.
#Define	XCABEC_FAT1 		 "RELATORIO DE EVENTOS DE FATURAMENTO"
#Define	XCABEC_FAT2 		 "TIP DATA     HORA     USER  CAIX VENDED FATURA"
#Define	XCABEC_PRN1 		 "RELATORIO DE EVENTOS DE IMPRESSAO DE DOCUMENTOS DIVERSOS"
#Define	XCABEC_PRN2 		 "TIP DATA     HORA     USER  CAIX VENDED FATURA"
/**********************************************************/
#define SCI_MAXROW		MaxRow()
#define SCI_MAXCOL 		MaxCol()
/**********************************************************/
#Define XJURODIA        (1/30) // 1mes/30dias=1dia
#Define XJURODIARIO     (1/30) // 1mes/30dias=1dia
#Define XJUROSEMANAL    (1/4)  // 01meses/4semanas=1semana
#Define XJUROQUINZENAL  (1/2)  // 01meses/2semanas=1quinzena
#Define XJUROMENSAL     (1)    // 1mes
#Define XJUROBIMESTRAL  (2/1)  // 02meses/1mes=1bimestre
#Define XJUROTRIMESTRAL (3/1)  // 03meses/1mes=1trimestre
#Define XJUROSEMESTRAL  (6/1)  // 06meses/1mes=1semestre
#Define XJUROANUAL      (12/1) // 12meses/1mes=1ano
/**********************************************************/
#Define SCI_JUROMES          1
#Define SCI_JUROMESSIMPLES   1
#Define SCI_DIASAPOS         2
#Define SCI_DESCAPOS         3
#Define SCI_MULTA            4
#Define SCI_DIAMULTA         5
#Define SCI_CARENCIA         6
#Define SCI_DESCONTO         7
#Define SCI_JUROCOMPOSTO     8
#Define SCI_JUROMESCOMPOSTO  8
/**********************************************************/
#define XTODOS_DOCNR    1
#define XTODOS_EMIS     2
#define XTODOS_VCTO     3
#define XTODOS_ATRASO   4
#define XTODOS_VLR      5
#define XTODOS_DESCONTO 6
#define XTODOS_MULTA    7
#define XTODOS_JUROS    8
#define XTODOS_SOMA     9
#define XTODOS_CODI     10
#define XTODOS_OBS      11
#define XTODOS_DATAPAG_VCTO_DOCNR 12
#define XTODOS_VCTO_DOCNR         13
#define XTODOS_DATAPAG_VCTO       14
#define XTODOS_FATURA             15
#define XTODOS_DATAPAG            16
#define XTODOS_ATIVO              17
#define XTODOS_RECNO              18
#define XTODOS_DATAPAG_DOCNR_VCTO 19
#define XTODOS_DATAPAG_FATURA_DOCNR_VCTO 20

/**********************************************************/
#Define TESTELAN
#Define RECELAN
#Define PAGALAN
#Define CHELAN
#Define VENLAN
#Define ORCALAN
#Define PONTO
#Define  DBFPROTEGIDO     OK
#Define	_LIN_MSG 		18
#Define	P_DEF(Par, Def)	 Par := IF( Par = Nil, Def, Par )
#Define	PA 				24
#Define	PB 				25
#Define	PC 				26
#Define	PD 				27
#Define	VOID				NIL
#Define	ZERO				0
#Define	UM 				1
#Define	DOIS				2
#Define	TRES				3
#Define	QUATRO			4
#Define	CINCO 			5
#Define	SEIS				6
#Define	SETE				7
#Define	OITO				8
#Define	NOVE				9
#Define	DEZ				10
#Define	ONZE				11
#Define	DOZE				12
#Define	TREZE 			13
#Define	SIM				UM
#Define	NAO				DOIS
#Define	ESC				27
#Define	ENTER 			13
#Define	MAXIMO			1000
#Define	OK 				.T.
#Define	FALSO 			.F.
#Define	MENU_LINHA		UM
#Define	CPI10132 		132
#Define	CPI12132 		151
#Define	CPI1080			80
#Define	CPI1280			93
#Define	SEP				"-"
#Define	TECLA_DELETE	7
#Define	TECLA_ENTER 	13
#Define	TECLA_INSERT	22
#Define	TECLA_ALTC		302
#Define	TECLA_MAIS		43
#Define	CTRL_ENTER		10
#Define	CTRL_F1			-20
#Define	CTRL_F2			-21
#Define	CTRL_F3			-22
#Define	CTRL_F4			-23
#Define	CTRL_F5			-24
#Define	CTRL_Q			17
#Define	CTRL_D			 4
#Define	CTRL_P			16
#Define	ASTERISTICO 	42
#Define	F1 				28
#Define	F2 				-1
#Define	F3 				-2
#Define	F4 				-3
#Define	F5 				-4
#Define	F6 				-5
#Define	F7 				-6
#Define	F8 				-7
#Define	F9 				-8
#Define	F10				-9
#Define	F11				-40
#Define	F12				-41
#Define	TELA				22
#Define	NORMAL			0
#Define	AUTO				1
#Define	COR				IF( FMono(), 7, 31 )
#Define	UP 				5
#Define	DOWN				24
#Define	PGUP				18
#Define	MONO				FALSO
#Define	WARNING			47
//#Define	BEGIN 			WHILE .T.
#Define  BEGOUT         ENDDO
//  =========================================================================

#XCOMMAND DEFAULT <v1> TO <x1> [, <vn> TO <xn> ]								;
			 =>																				;
			 IF <v1> == NIL ; <v1> := <x1> ; END									;
			 [; IF <vn> == NIL ; <vn> := <xn> ; END ]

#XCOMMAND DEFAU <v1> TO <x1> [, <vn> TO <xn> ]								;
			 =>																				;
			 IF <v1> == NIL ; <v1> := <x1> ; END									;
			 [; IF <vn> == NIL ; <vn> := <xn> ; END ]

			 
#COMMAND Print <row>, <col> <xpr>													;
					[PICTURE <pic>]														;
					[COLOR <color>]														;
			=> DevPos( <row>, <col> )													;
			 ; DevOutPict( <xpr>, <pic> [, <color>] )

#COMMAND Print <row>, <col> <xpr>													;
					[COLOR <color>]														;
			 => DevPos( <row>, <col> ) 												;
			  ; DevOut( <xpr> [, <color>] )

#COMMAND @ <row>, <col> GET <var> [PICTURE <pic>] [VALID <valid>] 		;
								[WHEN <when>]												;
								[SEND <msg>]												;
			=> SetCursor(1)																;
			 ; SetPos( <row>, <col> )													;
			 ; AAdd( GetList, _GET_( <var>, <(var)>, <pic>, <{valid}>, <{when}>));
			 [; ATail(GetList):<msg>]

#COMMAND Print <row>, <col> GET <var> [PICTURE <pic>] [VALID <valid>]	;
									 [WHEN <when>] 										;
									 [SEND <msg>]											;
			 => SetCursor(1)																;
			  ; SetPos( <row>, <col> ) 												;
			  ; AAdd( GetList, _GET_( <var>, <(var)>, <pic>, <{valid}>,<{when}>));
			  [; ATail(GetList):<msg>]

#COMMAND @ <row>, <col> SAY <sayxpr> [<sayClauses,...>]						;
								GET <var>													;
								[<getClauses,...>]										;
			=> SetCursor(1)																;
			 ; @ <row>, <col> SAY <sayxpr> [<sayClauses>]						;
			 ; @ Row(), Col()+1 GET <var> [<getClauses>]

#COMMAND Print <row>, <col> <sayxpr> [<sayClauses,...>]						;
							 GET <var>														;
							 [<getClauses,...>]											;
			=> SetCursor(1)																;
			 ; @ <row>, <col> SAY <sayxpr> [<sayClauses>]						;
			 ; @ Row(), Col()+1 GET <var> [<getClauses>]

#COMMAND Area( <whatever> )															;
			 => dbSelectArea( <(whatever)> )
#IFNDEF EMPRECODEBAR
	#Define	EMPRECODEBAR  "20"
#ENDIF
#IFNDEF XSERIE
	#Define XSERIE "0000-0000"
#ENDIF
#IFNDEF NOTAMICROBRAS
	#IFNDEF NOTACAIARI
		#IFNDEF NOTACICLO
			#Define NOTAOUTROS
		#ENDIF
	#ENDIF
#ENDIF
#IFNDEF XRAMO
  #DEFINE XRAMO XFANTA
#ENDIF
#IFNDEF ANO2000
  #DEFINE ANO2000 OK
#ENDIF
