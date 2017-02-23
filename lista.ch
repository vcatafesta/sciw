#include "translate.ch"
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
// #Define	SCP
// #Define	DEF_CEREAIS 	  OK
// #Define  MICROBRAS        OK // RO-PIMENTA BUENO
// #Define  SYBERNET         OK // RO-PIMENTA BUENO
#Define  VILMAR           OK // RO-PIMENTA BUENO
// #Define  TURBONET         OK // RO-PIMENTA BUENO
// #Define  VILADELA         OK // RO-PIMENTA BUENO // 30/08/2000
// #Define	CONTATOINFO 	  OK // RO-PIMENTA BUENO
// #Define	SOBMEDIDA		  OK // RO-PIMENTA BUENO // 18/09/2006
// #Define	ESCOLA			  OK // RO-PIMENTA BUENO
// #Define  DEMO             OK // RO-PIMENTA BUENO // DEMOSTRACAO
// #Define	CICLO 			  OK // RO-PIMENTA BUENO
// #Define	APPI				  OK // RO-PIMENTA BUENO
// #Define	AMAZON			  OK // RO-PIMENTA BUENO // AMAZON MALHAS
// #Define	KONCICLOS		  OK // RO-PIMENTA BUENO // AGROVALE
// #Define	BARROS			  OK // RO-PIMENTA BUENO
// #Define	BRISA 			  OK // RO-PIMENTA BUENO
// #Define	SANCHES			  OK // RO-PIMENTA BUENO
// #Define	BRASTEXTIL		  OK // RO-PIMENTA BUENO
// #Define	BRASTRACTOR 	  OK // RO-PIMENTA BUENO
// #Define	CAMILA			  OK // RO-PIMENTA BUENO
// #Define	CASTILHO 		  OK // RO-PIMENTA BUENO
// #Define	CANOPUS			  OK // RO-PIMENTA BUENO//
// #Define	MOREIRACESAR	  OK // RO-PIMENTA BUENO // 11-11-2006
// #Define	CENTRONORTE 	  OK // RO-PIMENTA BUENO
// #Define	CENTRAL			  OK // RO-PIMENTA BUENO // FOTO CENTRAL
// #Define	CENTRALPB		  OK // RO-PIMENTA BUENO // CENTRAL CALCADOS-PB
// #Define	CENTRALC 		  OK // RO-PIMENTA BUENO // CENTRAL CALCADOS-CACOAL
// #Define	CENTRAL3 		  OK // RO-PIMENTA BUENO // CENTRAL CALCADOS-CACOAL/
// #Define	COLCHOES 		  OK // RO-PIMENTA BUENO
// #Define	DECORART 		  OK // RO-PIMENTA BUENO	// 27/08/2005
// #Define	GUAPORE			  OK // RO-PIMENTA BUENO // R. C. FERRO - ME
// #Define	LINHARES 		  OK // RO-PIMENTA BUENO
// #Define	COMVEN			  OK // RO-PIMENTA BUENO
// #Define	CRISTAL			  OK // RO-PIMENTA BUENO // JOSE BATISTA DOS SANTOS - ME
// #Define	SIMONE			  OK // RO-PIMENTA BUENO
// #Define	CREMONESE		  OK // RO-PIMENTA BUENO
// #Define	DESTAK			  OK // RO-PIMENTA BUENO
// #Define	DOMINGOS 		  OK // RO-PIMENTA BUENO
// #Define	ELETROCENTER	  OK // RO-PIMENTA BUENO
// #Define	ELETROCENTERESP  OK // RO-ESPIGAO DO OESTE  // 08/10/03
// #Define	ELETROCENTERCHU  OK // RO-CHUPINGUAIA		  // 12/06/04
// #Define	ESQUEMA			  OK // RO-PIMENTA BUENO
// #Define	EXTINSUL 		  OK // RO-PIMENTA BUENO	  // PEDRO PORTEL - ME
// #Define	FAVALECA 		  OK // RO-PIMENTA BUENO	  // COMERCIAL FAVALECA LTDA - ME
// #Define	POSTOGAROTINHO   OK // RO-PIMENTA BUENO	  // AUTO POSTO GAROTINHO LTDA - ME
// #Define	JRS				  OK // RO-PIMENTA BUENO
// #Define	LINDAGUA 		  OK // RO-PIMENTA BUENO			 // AGUA MINERAL LIND'AGUA LTDA
// #Define	LINDOLAR 		  OK // RO-PIMENTA BUENO
// #Define	LONDRIFIO	OK // RO-PIMENTA BUENO
// #Define	ITAPORANGA	OK // RO-PIMENTA BUENO
// #Define	INDAL 		OK // RO-PIMENTA BUENO
// #Define	MAILLIW		OK // RO-PIMENTA BUENO // E.V.FABIANO - ME
// #Define	MIYABARA 	OK // RO-PIMENTA BUENO // AUTO ELETRICA MIYABARA LTDA
// #Define	SCHINCARIOL OK // RO-PIMENTA BUENO // DIST DE BEBIDAS COIMBRA LTDA
// #Define	MOTOSERRAS	OK // RO-PIMENTA BUENO // COMERCIO DE MOTOSERRAS PIMENTA BUENO LTDA
// #Define	METODO		OK // RO-PIMENTA BUENO
// #Define	MEIRELES 	OK // RO-PIMENTA BUENO
// #Define	MICHAELIS	OK // RO-PIMENTA BUENO
// #Define	OXI			OK // RO-PIMENTA BUENO // AMAZON-OXI AMAZONIA OXIGENIO LTDA
// #Define	PAJE			OK // RO-PIMENTA BUENO
// #Define	PECOAGRO 	OK // RO-PIMENTA BUENO
// #Define	GOIAS 		OK // RO-PIMENTA BUENO // DROGARIA GOIAS
// #Define	PLANO 		OK // RO-PIMENTA BUENO // PLANO DA ECONOMIA
// #Define	POPINHAK 	OK // RO-PIMENTA BUENO
// #Define	RONDOPB		OK // RO-PIMENTA BUENO
// #Define	RONDOMETAL	OK // RO-PIMENTA BUENO
// #Define	RONDOMETALFE  OK // RO-PIMENTA BUENO
// #Define	RONDONORTE	OK // RO-PIMENTA BUENO // AUTO ELETRICA RONDONORTE LTDA - SERGIO
// #Define	RONDOLENE	OK // RO-PIMENTA BUENO // G. BERNARDO PEREIRA - ME
// #Define	RETIMAR		OK // RO-PIMENTA BUENO
// #Define	SAOPAULO 	OK // RO-PIMENTA BUENO
// #Define	SANTAMARIA	OK // RO-PIMENTA BUENO
// #Define	TECPLAN		OK // RO-PIMENTA BUENO	  // TEC PLAN TERRAPLENAGEM
// #Define	SEFAZ 		OK // RO-PIMENTA BUENO		// SEC DE ESTADO DA FAZENDA
// #Define	RONDOTUBOS	OK // RO-PIMENTA BUENO		// RONDOTUBOS ARTEFATOS DE CIMENTO LTDA
// #Define	CAMBE 		OK // RO-PIMENTA BUENO		// VANTINA FAVALESSA
// #Define	YPIRANGA 	OK // RO-PIMENTA BUENO		// YPIRANGA MATERIAIS P/CONSTRUCAO LTDA
// #Define	SKALA 		OK // RO-PIMENTA BUENO		// SILVANA MARCELINO & CIA LTDA
// #Define	LORENA		OK // RO-PIMENTA BUENO		// LORENA E LORENA LTDA - ME EPP
// #Define	SANTALUCIA	OK // RO-PIMENTA BUENO		// SANTA LUCIA ACESSORIOS & TAPECARIA LTDA
// #Define	CONSTRULARPB OK // RO-PIMENTA BUENO 	 // C. MAGALHARES - ME
// #Define	PLANALTO 	OK // RO-PIMENTA BUENO		//
// #Define	PLANALTOII	  OK // RO-PIMENTA BUENO		// 21/06/2005
// #Define	HIPERPB		OK // RO-PIMENTA BUENO		//
// #Define	BRILHANTE	OK // RO-PIMENTA BUENO		//
// #Define	LOVATTO		OK // RO-PIMENTA BUENO		//
// #Define	H2O			OK // RO-PIMENTA BUENO		// H2O PISCINAS E ACESSORIOS LTDA - ME
// #Define	TUTTO 		OK // RO-PIMENTA BUENO
// #Define	KOGAKE		OK // RO-PIMENTA BUENO		// 03/01/2000
// #Define	RANITE		OK // RO-PIMENTA BUENO		// 11/01/2000
// #Define	JACO			OK // RO-PIMENTA BUENO		// 19/01/2000
// #Define	FERMINO		OK // RO-PIMENTA BUENO		// 25/01/2000
// #Define	Q_DELICIA	OK // RO-PIMENTA BUENO		// 17/02/2000
// #Define	ROSSI 		OK // RO-PIMENTA BUENO		// 29/02/2000
// #Define	OBOTICARIO	OK // RO-PIMENTA BUENO		// 05/06/2000
// #Define	ALTO_ALEGRE OK // RO-PIMENTA BUENO		// 29/02/2000
// #Define	CICLO_CASTANHAL  OK // PA-CASTANHAL 	// 06/09/2000
// #Define	CICLO_SANTAREM   OK // PA-SANTAREM		// 06/09/2000
// #Define	CICLO_COROATA	  OK // MA-COROATA		// 06/09/2000
// #Define	CICLO_IMPERATRIZ OK // MA-IMPERATRIZ	// 06/09/2000
// #Define	CICLO_CUIABA	  OK // MT-CUIABA 		// 06/09/2000
// #Define	CICLO_BOAVISTA   OK // RR-BOA VISTA 	// 06/09/2000
// #Define	VELOSO			  OK // RR-BOA VISTA 	// 21/02/2002
// #Define	PNEUAR			  OK // RO-PIMENTA BUENO  // 29/11/2000
// #Define	INTERCOOLER 	  OK // RO-PIMENTA BUENO  // 14/12/2000
// #Define	LEME				  OK // RO-PIMENTA BUENO  // 04/06/2001
// #Define	PRADO 			  OK // RO-PIMENTA BUENO  // 04/10/2001
// #Define	MAGIA 			  OK // RO-PIMENTA BUENO  // 14/01/2002
// #Define	BOR_MEC_ITA 	  OK // RO-PIMENTA BUENO  // 02/04/2002
// #Define	ANGELICA 		  OK // RO-PIMENTA BUENO  // 15/08/2002
// #Define	KINKAS			  OK // RO-PIMENTA BUENO  // 11/10/2002
// #Define	TRANSILVA		  OK // RO-PIMENTA BUENO  // 13/01/2003
// #Define	MILLENIUM		  OK // RO-PIMENTA BUENO  // 28/11/2003
// #Define	ANMELY			  OK // RO-PIMENTA BUENO  // 17/12/2003
// #Define	MATT				  OK // RO-PIMENTA BUENO  // 17/02/2004
// #Define	FONSECA			  OK // RO-PIMENTA BUENO  // 14/04/2004
// #Define	MOYSES			  OK // RO-PIMENTA BUENO  // 14/04/2004
// #Define	VSVIDROS 		  OK // RO-PIMENTA BUENO  // 04/06/2004
// #Define	COIMBRA			  OK // RO-PIMENTA BUENO  // 02/12/2004
// #Define	MARIVANI 		  OK // RO-PIMENTA BUENO  // 03/01/2005
// #Define	ZEROHORA 		  OK // RO-PIMENTA BUENO  // 04/07/2005
// #Define	LOOK				  OK // RO-PIMENTA BUENO  // 09/08/2005
// #Define	AGRONORTE		  OK // RO-PIMENTA BUENO  // 13/09/2005
// #Define	LOJABRASILEIRA   OK // RO-PIMENTA BUENO  // 23/02/2005
// #Define	CASADOAGROPECUARIO  OK // RO-PRIMAVERA DO RONDONIA  // 25/02/2006
// #Define	NOSSALOJACALCADOS   OK // RO-PIMENTA BUENO  // 08/06/2006
// #Define	MOTORACAPBW 		  OK // RO-PIMENTA BUENO  // 28/09/2006
// #Define	LAWFOUR				  OK // RO-PIMENTA BUENO  // 07/01/2007
// #Define	GPMOTOS1 			  OK // RO-PIMENTA BUENO  // 23/04/07
// #Define	ROMANA				  OK // RO-PIMENTA BUENO  // 22/06/07
// #Define	VIARTEX				  OK // RO-PIMENTA BUENO  // 05/07/07
// #Define	JAMANTAO 			  OK // RO-PIMENTA BUENO  // 22/07/08
//  =========================================================================
// #Define	BALAO 		OK // RO-ESPIGAO DO OESTE	// BALAO PECAS E ACESSORIOS LTDA
// #Define	CIMAPE		OK // RO-ESPIGAO DO OESTE
// #Define	CORTAPAU 	OK // RO-CORTA PAU COM DE MAQ AGRICOLAS LTDA
// #Define	MATSANT		OK // RO-ESPIGAO DO OESTE
// #Define	KOTINHA		OK // RO-ESPIGAO DO OESTE
// #Define	AGUIA_CDO	OK // RO-COLORADO DO OESTE
// #Define	PRESTES		OK // RO-COLORADO DO OESTE
// #Define	MORENA		OK // RO-ESPIGAO DO OESTE	// 22/08/00
// #Define	BEMAC 		OK // RO-ESPIGAO DO OESTE	// 19/01/01
// #Define	IMPERIAL 	OK // RO-ESPIGAO DO OESTE	// 04/12/01
// #Define	NOELMOTOS	OK // RO-ESPIGAO DO OESTE	// 14/01/02
// #Define	DIMATEL		OK // RO-ESPIGAO DO OESTE	// 21/03/02
// #Define	RONDOMOTO	OK // RO-ESPIGAO DO OESTE	// 21/03/02
// #Define	ALIANCA		OK // RO-ESPIGAO DO OESTE	// 21/03/02
// #Define	ROZIRAN		OK // RO-ESPIGAO DO OESTE	// 09/09/03
// #Define	MARLENE		OK // RO-ESPIGAO DO OESTE	// 08/10/03
// #Define	GPMOTOS		OK // RO-ESPIGAO DO OESTE	// 11/06/06
// #Define	EUDACK		OK // RO-ESPIGAO DO OESTE	// 26/04/06
//  =========================================================================
// #Define	ARIEL 		 OK // RO-NOVA BRASILANDIA
// #Define	TRENTO		 OK // RO-NOVA BRASILANDIA
// #Define	ANOSSA		 OK // RO-VILHENA
// #Define	ROVER 		 OK // RO-VILHENA
// #Define	ATLANTICA	 OK // RO-VILHENA  // 02/06/2001
// #Define	TENDTUDO 	 OK // RO-VILHENA  // 16/07/2004
// #Define	RODRIGOMOTOS OK // RO-VILHENA  // 04/11/2004
// =========================================================================
// #Define	GAROTINHO	 OK // RO-PARECIS  // R. C. CABRAL - ME
// #Define	AGROREAL 	 OK // RO-PARECIS  // RUSCHEL & GUIMARAES LTDA
// #Define	PINEDA		 OK // RO-PARECIS  // 26/12/2006
// #Define	DOURADOS 	 OK // RO-ALTO ALEGRE DOS PARECIS // D. B. DE MATOS - ME
// #Define	SOBREIRA 	 OK // RO-ALVORADA DO OESTE // J. SOBREIRA DE OLIVEIRA - ME
// #Define	PRODUZA		 OK // RO-ALVORADA DO OESTE // DIDI
// #Define	GIO			 OK // RO-ALVORADA DO OESTE // GIL & CIA COM E REPRES LTDA
// #Define	CARIMBOS 	 OK // RO-ALVORADA DO OESTE // CARIMBOS MILLENIUM LTDA
// #Define	OPCAOMODAS	 OK // RO-ALVORADA DO OESTE // A. L. M. COM DE ART DO VESTUARIO LTDA - ME
// #Define	AUTOCAR		 OK // RO-ALVORADA DO OESTE // 02/10/2006
//  =========================================================================
// #Define	ROMA			 OK // RO-PRESIDENTE MEDICE // 09/10/99
// #Define	AGROPAMPA	 OK // RO-PRESIDENTE MEDICE // 15/09/98
// #Define	DISNORTE 	 OK // RO-PRESIDENTE MEDICE // 27/12/97
// #Define	MORUMBI		 OK // RO-PRESIDENTE MEDICE
// #Define	RIOBRANCO	 OK // RO-PRESIDENTE MEDICE
// #Define	SAOVICENTE	 OK // RO-PRESIDENTE MEDICE
// #Define	SAOVICENTE_CUJUBIM  OK // RO-COJUBIM
// #Define	LEONE 		 OK // RO-PRESIDENTE MEDICE // 18/05/2001
// #Define	PAROQUIA 	 OK // RO-PRESIDENTE MEDICE
// #Define	CAMAGRIL 	 OK // RO-PRESIDENTE MEDICE // CAMAGRIL - IND E COM DE MADEIRAS LTDA
//  =========================================================================
// #Define	POSTOCENTRAL OK // RO-OURO PRETO DO OESTE
// #Define	POSTOAVENIDA OK // RO-OURO PRETO DO OESTE
// #Define	TESTONI		 OK // RO-OURO PRETO DO OESTE
// #Define	SOMAC 		 OK // RO-OURO PRETO DO OESTE
// #Define	MONTENEGRO	 OK // RO-MONTE NEGRO
// #Define	JOPNEUS		 OK // RO-MONTE NEGRO // 25/10/2000
// #Define	CAMPONOVO	 OK // RO-CAMPO DE RONDONIA
// #Define	BURITIS		 OK // RO-BURITIS
// #Define	MADEIRO		 OK // RO-OURO PRETO DO OESTE // 24/03/2000
// #Define	PARAISO		 OK // RO-VALE DO PARAISO // 28/02/2004
//  =========================================================================
// #Define	MARUZA		 OK // RO-MOGI GUACU // 06/09/2000
// #Define	CAROL 		 OK // RO-MOGI GUACU // 06/09/2000
// #Define	SAUDE 		 OK // RO-MOGI GUACU // 06/09/2000
//  =========================================================================
// #Define	BRASTRACTORCC	OK // RO-CACOAL
// #Define	AIBARA			OK // RO-CACOAL // AIBARA & FUJISAWA LTDA
// #Define	ATACADO			OK // RO-CACOAL // ATACADO DE CONFECCOES CACOAL LTDA
// #Define	AUDCONT			OK // RO-CACOAL // AUDCONT CONTABILIDADE
// #Define	BUTISILOFF		OK // RO-CACOAL // CASA DOS COLCHOES
// #Define	CENTRALII		OK // RO-CACOAL // CENTRAL CALCADOS II
// #Define	KARRETAO 		OK // RO-CACOAL // POSTO DE MOLAS CACOAL LTDA
// #Define	DECORALAR		OK // RO-CACOAL // DECORALAR MOVEIS E DECORACOES LTDA
// #Define	DOMAQUINO		OK // RO-CACOAL // DOM AQUINO ADM E CORR DE SEGUROS
// #Define	DROGAMIL 		OK // RO-CACOAL // DROGARIA DROGAMIL
// #Define	DROGAMILII		OK // RO-CACOAL // FERREIRA & OCAMPOS LTDA - ME
// #Define	ELETROMOVEIS	OK // RO-CACOAL // COMERCIAL CACOAL LTDA
// #Define	ITAPUA			OK // RO-CACOAL // ITAPUA COM ATAC DE BIJ E VARIEDADES LTDA"
// #Define	JAIR				OK // RO-CACOAL
// #Define	MEGAB 			OK // RO-CACOAL
// #Define	ELEPARAISO		OK // RO-CACOAL
// #Define	POSTO 			OK // RO-CACOAL
// #Define	LUBRIFILTROS	OK // RO-CACOAL
// #Define	MEDIFARMA		OK // RO-CACOAL
// #Define	MICRONEWS		OK // RO-CACOAL
// #Define	MICROSTAR		OK // RO-CACOAL
// #Define	RADIOS			OK // RO-CACOAL // CASA DOS RADIOS LTDA
// #Define	RONDOMOCA		OK // RO-CACOAL // RONDOMOTO
// #Define	RONDOCA			OK // RO-CACOAL // RONDOBRAS
// #Define	RONDOSOM 		OK // RO-CACOAL // LUCIMAR MARIANO FERREIRA & CIA LTDA - ME
// #Define	STOANTONIO		OK // RO-CACOAL // J. V. COSTA QUARESMA
// #Define	SETEMBRO 		OK // RO-CACOAL // AUTO POSTO 7 DE SETEMBRO LTDA
// #Define	VENUS 			OK // RO-CACOAL // PAPELARIA VENUS
// #Define	VIDEOSOM 		OK // RO-CACOAL // VIDEO SOM SHOP COM E IMP LTDA
// #Define	YUNES 			OK // RO-CACOAL // PAPELARIA YUNES LTDA
// #Define	MODELO			OK // RO-CACOAL // D. A. DE OLIVEIRA - ME
// #Define	RONDONIA 		OK // RO-CACOAL // FARMACIA RONDONIA // 22/02/2002
// #Define	COCICAL			OK // RO-CACOAL // 22/03/99
// #Define	CRISTALDOCES	OK // RO-CACOAL // 12/04/99
// #Define	PIRAMIDE 		OK // RO-CACOAL // 12/04/99
// #Define	COPICENTER		OK // RO-PIMENTA BUENO		// 05/01/2000
// #Define	_CONSTRUCENTER OK // RO-CACOAL				// 03/04/2000
// #Define	ARCOIRIS 		OK // RO-CACOAL // 25/04/01
// #Define	BRDIESEL 		OK // RO-CACOAL // 09/01/02
// #Define	SOCRAM			OK // RO-CACOAL // 21/02/02
// #Define	CASADOCAMPO 	OK // RO-CACOAL // 28/11/02
// #Define	MEDSEGLABOR 	OK // RO-CACOAL // 29/04/03
// #Define	NACIONAL 		OK // RO-CACOAL // 21/07/03
// #Define	MOTORACA 		OK // RO-CACOAL // 03/09/03
// #Define	MOTOGARRACWL	OK // RO-CACOAL // 03/09/03
// #Define	SPEEDMOTOS		OK // RO-CACOAL // 26/08/05
// #Define	TIGRAO			OK // RO-CACOAL // 07/04/06
// #Define	CASAMAQUINAS	OK // RO-CACOAL // 28/12/06
// #Define	AGATA 			OK // RO-CACOAL // 15/08/08
//  =========================================================================
// #Define	FERNANDES		OK // RO-JI PARANA // 25/04/2000
// #Define	MORUMBIJI		OK // RO-JI PARANA // 31/01/2000
// #Define	DOISABRIL		OK // RO-JI PARANA // 31/01/2000
// #Define	CAIARI			OK // RO-JI PARANA
// #Define	SURUI 			OK // RO-JI PARANA
// #Define	RONDOJI			OK // RO-JI PARANA // RONDOBRAS JI PARANA
// #Define	ELETROAIBARA	OK // RO-JI PARANA // 20/02/2002
// #Define	PILAR 			OK // RO-JI PARANA // 09/10/2003
// #Define	MOTOGARRA		OK // SP-MONTE ALTO // 26/11/2002
//  =========================================================================
// #Define	BELLADONNA		 OK // MT-JUINA //  SUPORTE OK
// #Define	HENICKA			 OK // MT-JUINA //  SUPORTE OK
// #Define	COMETA			 OK // MT-JUINA //  SUPORTE OK
// #Define	COVAL 			 OK // MT-JUINA //  SUPORTE OK
// #Define	DIMAG 			 OK // MT-JUINA //  SUPORTE OK
// #Define	HERMES			 OK // MT-JUINA //  SUPORTE OK
// #Define	JADERCEREALISTA OK // MT-JUINA //  SUPORTE OK
// #Define	JADERVEICULOS	 OK // MT-JUINA //  SUPORTE OK
// #Define	KEOPS 			 OK // MT-JUINA //  SUPORTE OK
// #Define	PANORAMA 		 OK // MT-JUINA //  SUPORTE OK
// #Define	PASQUALOTTO 	 OK // MT-JUINA //  SUPORTE OK
// #Define	RIBEIRO			 OK // MT-JUINA //  SUPORTE OK
// #Define	RONDOJU			 OK // MT-JUINA //  SUPORTE OK
// #Define	SANTAGEMA		 OK // MT-JUINA //  SUPORTE OK
// #Define	UNIAO 			 OK // MT-JUINA //  SUPORTE OK
// #Define	AUTOSOM			 OK // MT-JUINA //
// #Define	BOASAFRA 		 OK // MT-JUINA //
// #Define	CONSTRULAR		 OK // MT-JUINA //
// #Define	CONSTRUCENTER	 OK // MT-JUINA //
// #Define	COTRASA			 OK // MT-JUINA //
// #Define	DISBORAUTO		 OK // MT-JUINA //
// #Define	GLAUBER			 OK // MT-JUINA //
// #Define	LAVOURA			 OK // MT-JUINA //
// #Define	KAROLINE 		 OK // MT-JUINA //
// #Define	OSKAR 			 OK // MT-JUINA //
// #Define	REIDOPANO		 OK // MT-JUINA //
// #Define	SAO_PAULO		 OK // MT-JUINA //
// #Define	SAOPEDRO 		 OK // MT-JUINA //
// #Define	SAOFRANCISCO	 OK // MT-JUINA //
// #Define	TINTAS			 OK // MT-JUINA //
// #Define	TRAMA 			 OK // MT-JUINA //
// #Define	VERONESE 		 OK // MT-JUINA //
// #Define	AMALIA			 OK // MT-JUINA	// FAZENDA AMALIA
// #Define	RAINHA			 OK // MT-JUINA	// 05/05/2000
// #Define	TOKIO 			 OK // MT-JUINA	// 24/05/2004
// #Define	FAMA				 OK // MT-JUINA	// 16/06/2004
// #Define	PAPELARIABRASIL OK // MT-JUINA	// 18/10/2004
// #Define	MECANICA4RAMOS  OK // MT-JUINA	// 09/04/2005
//  =========================================================================
// #Define	RONDOARIPUANA	 OK // MT-ARIPUANA	 // RONDOBRAS ARIPUANA
// #Define	TRUCKAO			 OK // MT-ARIPUANA	 // VARZEA GRANDE TOYOTA
// #Define	AUTOPECASTOKIO  OK // MT-ARIPUANA	 // M. MEIRE CARDOSO - ME
//  =========================================================================
// #Define	_PANORAMA		 OK // MT-TANGARA DA SERRA
// #Define	PAULISTA 		 OK // MT-TANGARA DA SERRA
// #Define	BIKE				 OK // MT-TANGARA DA SERRA
// #Define	RELAMPAGO		 OK // MT-NOVA OLIMPIA
//  =========================================================================
// #Define	APJURUENA		 OK // MT-JURUENA 	 // A. L. MOREIRA LTDA - ME
// #Define	LUISCARLOS		 OK // MT-JURUENA 	 // LUIS CARLOS DA SILVA - ME
//  =========================================================================
// #Define	CLAUDAIR 		 OK // MT-COLNIZA 	 // CLAUDAIR M. DA SILVA - ME
// #Define	BRASILFERRA 	 OK // MT-COLNIZA 	 // 02/06/2001
// #Define	AGRONIZA 		 OK // MT-COLNIZA 	 // 17/07/2002
// #Define	MER_PRIMAVERA	 OK // MT-COLNIZA 	 // 12/07/2004
//  =========================================================================
// #Define	SAOMATEUS		 OK // MT-CUIABA
// #Define	RONDOMETALVG	 OK // MT-VARZEA GRANDE
//  =========================================================================
// #Define	JUREMAQ			 OK // MT-CASTANHEIRA // LUIS CARLOS DA SILVA COM - ME
// #Define	SUPIMPA			 OK // MT-CASTANHEIRA // T.F. DA SILVA MERCEARIA - ME
// #Define	HERMES_CT		 OK // MT-CASTANHEIRA // 05/01/2000
// #Define	LILA				 OK // MT-CASTANHEIRA // 20/01/2000
// #Define	VIZIOLI			 OK // MT-CASTANHEIRA // 05/05/2000
// #Define	AIDA				 OK // MT-CASTANHEIRA // 05/05/2000
//  =========================================================================
// #Define	CENTERDROGAS	 OK // MT-JUARA // CARLOS BORDINHAO - ME
// #Define	GRIFFE			 OK // MT-JUARA // R. DA SILVA BOUTIQUE - ME
// #Define	JAMAR 			 OK // MT-JUARA // J. S. DE OLIVEIRA FERRAGEM - ME
// #Define	CAMPOELAVOURA	 OK // MT-JUARA // AGROPECUARIA HERMES LTDA
// #Define	KRMOTOS			 OK // MT-JUARA // NOZAKI & NOZAKI LTDA
// #Define	CHAMAGAS 		 OK // MT-JUARA // C. O. DE ARAUJO MORAES - ME
// #Define	TAKEDA			 OK // MT-JUARA // S. SCHMITZ TAKEDA - ME
// #Define	LIBERAL			 OK // MT-JUARA // DROGARIA LIBERAL LTDA.
// #Define	DETALHES 		 OK // MT-JUARA // DETALHES MODAS
// #Define	PARAFUSOS		 OK // MT-JUARA // JUARA COM DE FERRAGENS LTDA - ME
// #Define	MULTIMARCA		 OK // MT-JUARA // AUED & SILVA LTDA - ME
// #Define	SAULMOTOS		 OK // MT-JUARA // SAULI P. DOBBINS - ME
// #Define	TUTTY 			 OK // MT-JUARA //
// #Define	ZUZU				 OK // MT-JUARA // CONFECCOES SOUZA RODRIGUES LTDA - ME
// #Define	AGROSOL			 OK // MT-JUARA // J. H. BORGES CIA LTDA
// #Define	JUDISBEL 		 OK // MT-JUARA // JUARA DIST DE BEBIDAS LTDA
// #Define	CANTON			 OK // MT-JUARA // COMERCIAL VALE DO ARINOS LTDA
// #Define	NEIDROGAS		 OK // MT-JUARA // V. H. MORAIS - ME
// #Define	HOLANDA			 OK // MT-JUARA // LOJA PAULISTA
// #Define	DENI				 OK // MT-JUARA // DENI MAT. P/ CONSTRUCOES LTDA.
// #Define	DIMACO			 OK // MT-JUARA // DIMACO MAT. P/ CONSTRUCOES LTDA.
// #Define	JUVEL 			 OK // MT-JUARA // JUVEL VEICULOS
// #Define	STAHELENA		 OK // MT-JUINA // J. S. R. BAGANHA - ME
// #Define	SANTAROSA		 OK // MT-JUARA // C. M. DA SILVA COMERCIO - ME
// #Define	QUILES			 OK // MT-JUARA // MOVEIS QUILES LTDA
// #Define	MARISSOL 		 OK // MT-JUARA // 13/10/98 / L. GON€ALVES BAZAR
// #Define	CONCEICAO		 OK // MT-JUARA // 13/10/98 / MARIA DA CONCEI€AO C. PEREIRA - ME
// #Define	PAIVA 			 OK // MT-JUARA // 15/12/98 / DIST DE BEBIDAS PAIVA
// #Define	PANTANAL 		 OK // MT-JUARA // 01/03/99 / B. M. DALLA COSTA DA SILVA-ME
// #Define	AQUARIUS 		 OK // MT-JUARA // 22/03/99 / ALEIXO & ALEIXO LTDA
// #Define	VAREJAO			 OK // MT-JUARA // 20/05/99
// #Define	SCARIOT			 OK // MT-PORTO DO GAUCHOS 13/04/98
// #Define	HERMESS			 OK // MT-SINOP
// #Define	APARECIDA		 OK // MT-JUARA // 20/01/2000
// #Define	ESTUDANTIL		 OK // MT-JUARA // 29/02/2000
// #Define	AGROTERRA		 OK // MT-JUARA // 18/08/2000
// #Define	BETEL 			 OK // MT-JUARA // 04/09/2000
//  =========================================================================
// #Define	METALVIDRO		 OK // RO-ALTA FLORESTA DO OESTE // 29/09/2000
// #Define	RESICAL			 OK // RO-ALTA FLORESTA DO OESTE
//  =========================================================================
// #Define	COMAM 		  OK // RO-ROLIM DE MOURA
// #Define	POLLYMODAS	  OK // RO-ROLIM DE MOURA // ELENICE DE FREITAS MODAS
// #Define	KARLACALCADOS OK // RO-ROLIM DE MOURA // MANOEL DE SOUZA E SILVA TECIDO - ME
// #Define	VANTAJOSA	  OK // RO-ROLIM DE MOURA // A VANTAJOSA TEC. E CONF. LTDA.
// #Define	GAUCHA		  OK // RO-ROLIM DE MOURA
// #Define	MIRIAM		  OK // RO-ROLIM DE MOURA
// #Define	MOTOSUL		  OK // RO-ROLIM DE MOURA
// #Define  TRADICAO      OK // RO-ROLIM DE MOURA
// #Define	RONDORM		  OK // RO-ROLIM DE MOURA
// #Define	SAOLUCAS 	  OK // RO-ROLIM DE MOURA
// #Define	SUPORTE		  OK // RO-ROLIM DE MOURA
// #Define	ROLAO 		  OK // RO-ROLIM DE MOURA // 23/12/99
// #Define	ORIENT		  OK // RO-ROLIM DE MOURA // 15/02/01//
// #Define  AGROMATEC     OK // NOVA ESTRELA      // 30/06/05
// #Define  DOCELAR       OK // RO-ROLIM DE MOURA // 19/10/09
//  =========================================================================
// #Define	TRADICAOSA		 OK // RO-SANTA LUZIA DO OESTE
//  =========================================================================
// #Define	MAXMOTORS	OK // RO-PORTO VELHO
// #Define	MONJOLO		OK // RO-PORTO VELHO // MONJOLO MOVEIS LTDA
// #Define	VERONA		OK // RO-PORTO VELHO // 26/01/98
// #Define	NUTRIFRITAS OK // RO-PORTO VELHO // 19/01/01
// #Define	SIDINEZ		OK // RO-PORTO VELHO // 26/06/01
// #Define	AIBARAPVH	OK // RO-PORTO VELHO // R. S. AIBARA LTDA
//  =========================================================================
// #Define	AMAZONAS 	OK // RO-ARIQUEMES
// #Define	MOTAO1		OK // RO-ARIQUEMES
// #Define	MOTAO2		OK // RO-ARIQUEMES
// #Define	MOTAO3		OK // RO-JARU
// #Define	MOTAO4		OK // RO-BURITI
// #Define	MOTAO5		OK // RO-CACOAL
// #Define	MORTENE		OK // RO-ARIQUEMES
// #Define	RONDOAR		OK // RO-ARIQUEMES
// #Define	TESTONE		OK // RO-ARIQUEMES  // 13/04/98
// #Define	TELESERVE	OK // RO-ARIQUEMES  // 03/02/2002
// #Define	JACIARA		OK // RO-ARIQUEMES  // 29/04/2006
// #Define	SANTOS		OK // RO-ARIQUEMES  // 01/07/2006
//  =========================================================================
// #Define	RONDORE		OK // PA-REDENCAO
// #Define	RUCELIA		OK // MS-CAMPO GRANDE
// #Define	ALVORADENSE OK // MS-NOVA ALVORADA DO SUL  // 13/08/96
// #Define	MINICICLO	OK // AC-RIO BRANCO				 // 22/11/02
// #Define	PALACIO		OK // AC-RIO BRANCO
// #Define	SOBRECIL 	OK // AC-RIO BRANCO
// #Define	CEMIL 		OK // AC-RIO BRANCO
// #Define	SMCOM 		OK // RO-SAO MIGUEL DO GUAPORE // 07/10/03
//  =========================================================================
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
#Define	BEGIN 			WHILE .T.
#Define  BEGOUT         ENDDO
//  =========================================================================
#IFDEF APPI
	#Undef TESTELAN
	#Undef RECELAN
	#Undef PAGALAN
	#Undef VENLAN
	#Undef ORCALAN
	#Undef PONTO
	#Define XFONE		"(69)451-2827" // LUIS ANTONIO APPI
	#Define ENCRYPT	"AGROP PICA PAU DO IGARAPE"
	#Define XFANTA 	"AGROP PICA PAU DO IGARAPE"
	#Define XENDEFIR	"LOTE 46 - LINHA 37"
	#Define XCGCFIR	"000.000.000-00"
	#Define XINSCFIR	"ISENTO"
	#Define XCCIDA 	"SAO FELIPE DO OESTE"
	#Define XCESTA 	"RO"
	#Define XCEPCIDA	"78986-000/SAO FELIPE DO OESTE"
	#Define XCCEP		"78986-000"
#ENDIF
#IFDEF RANITE
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)451-2862"
	#Define	ENCRYPT	 "VIEIRA & RANITE LTDA"
	#Define	XFANTA	 "POSTO UNIAO"
	#Define	XENDEFIR  "ROD BR 364 - KM 194 - QD 2"
	#Define	XCGCFIR	 "03.566.347/0001-94"
	#Define	XINSCFIR  "407.90869-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CICLO
	#Define	NOTACICLO OK
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(069)451-3922"
	#Define	ENCRYPT	 "CICLO CAIRU LTDA"
	#Define	XFANTA	 "CICLO CAIRU"
	#Define	XENDEFIR  "AV BRASIL, 574 - CENTRO"
	#Define	XCGCFIR	 "02.513.526/0001-09"
	#Define	XINSCFIR  "407.90766-9"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CICLO_CASTANHAL
	#Define	CICLO
	#Define	NOTACICLO OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(91)721-3526" // ELANDIA RAMOS CHAGAS
	#Define	ENCRYPT	 "CICLO CAIRU LTDA - CASTANHAL/PA"
	#Define	XFANTA	 "CICLO CAIRU - CASTANHAL/PA"
	#Define	XENDEFIR  "AV WCS, 62 - CJ JD TOKIO"
	#Define	XCGCFIR	 "02.513.526/0001-09"
	#Define	XINSCFIR  "407.90766-9"
	#Define	XCCIDA	 "CASTANHAL"
	#Define	XCESTA	 "PA"
	#Define	XCEPCIDA  "68745-000/CASTANHAL"
	#Define	XCCEP 	 "68745-000"
#ENDIF
#IFDEF CICLO_SANTAREM
	#Define	CICLO
	#Define	NOTACICLO  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(91)9965-2686" // RAIMUNDO GOMES DE FREITAS
	#Define	ENCRYPT	 "CICLO CAIRU LTDA - SANTAREM/PA"
	#Define	XFANTA	 "CICLO CAIRU - SANTAREM/PA"
	#Define	XENDEFIR  "TRAVESSA 23, 51 - N. REPUBLICA"
	#Define	XCGCFIR	 "02.513.526/0001-09"
	#Define	XINSCFIR  "407.90766-9"
	#Define	XCCIDA	 "SANTAREM"
	#Define	XCESTA	 "PA"
	#Define	XCEPCIDA  "68025-470/SANTAREM"
	#Define	XCCEP 	 "68025-470"
#ENDIF
#IFDEF CICLO_COROATA
	#Define	CICLO
	#Define	NOTACICLO  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(98)641-1558" // RADJAELSON JOAQUIM ARRAES
	#Define	ENCRYPT	 "CICLO CAIRU LTDA - COROATA/MA"
	#Define	XFANTA	 "CICLO CAIRU - COROATA/MA"
	#Define	XENDEFIR  "RUA DA PRAINHA, 360 - B. DOS AMERICANOS"
	#Define	XCGCFIR	 "02.513.526/0001-09"
	#Define	XINSCFIR  "407.90766-9"
	#Define	XCCIDA	 "COROATA"
	#Define	XCESTA	 "MA"
	#Define	XCEPCIDA  "65415-000/COROATA"
	#Define	XCCEP 	 "65415-000"
#ENDIF
#IFDEF CICLO_IMPERATRIZ
	#Define	CICLO
	#Define	NOTACICLO  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(98)526-3007" // TECIO ARAUJO MIRANDA
	#Define	ENCRYPT	 "CICLO CAIRU LTDA - IMPERATRIZ/MA"
	#Define	XFANTA	 "CICLO CAIRU - IMPERATRIZ/MA"
	#Define	XENDEFIR  "RUA MARLY SARNEY, 108 - CENTRO"
	#Define	XCGCFIR	 "02.513.526/0001-09"
	#Define	XINSCFIR  "407.90766-9"
	#Define	XCCIDA	 "IMPERATRIZ"
	#Define	XCESTA	 "MA"
	#Define	XCEPCIDA  "65900-970/IMPERATRIZ"
	#Define	XCCEP 	 "65900-970"
#ENDIF
#IFDEF CICLO_CUIABA
	#Define	CICLO
	#Define	NOTACICLO  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(65)621-4685" // JOAOZITO TAVARES GOMES
	#Define	ENCRYPT	 "CICLO CAIRU LTDA - CUIBA/MT"
	#Define	XFANTA	 "CICLO CAIRU - CUIABA/MT"
	#Define	XENDEFIR  "RUA POCHOREO, 175 - ALVORADA"
	#Define	XCGCFIR	 "02.513.526/0001-09"
	#Define	XINSCFIR  "407.90766-9"
	#Define	XCCIDA	 "CUIABA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78048-400/CUIBA"
	#Define	XCCEP 	 "78048-400"
#ENDIF
#IFDEF CICLO_BOAVISTA
	#Define	CICLO
	#Define	NOTACICLO  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(95)627-1674" // RUBENS BENICIO DE CARVALHO
	#Define	ENCRYPT	 "CICLO CAIRU LTDA - BOA VISTA/RR"
	#Define	XFANTA	 "CICLO CAIRU - BOA VISTA/RR"
	#Define	XENDEFIR  "RUA C5, 385 - JD FLORESTA II"
	#Define	XCGCFIR	 "02.513.526/0001-09"
	#Define	XINSCFIR  "407.90766-9"
	#Define	XCCIDA	 "BOA VISTA"
	#Define	XCESTA	 "RR"
	#Define	XCEPCIDA  "69310-000/BOA VISTA"
	#Define	XCCEP 	 "69310-000"
#ENDIF
#IFDEF VELOSO
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)451-3922" // VITINHO
	#Define	ENCRYPT	 "RIBEIRO & VELOSO LTDA"
	#Define	XFANTA	 "RIBEIRO & VELOSO"
	#Define	XENDEFIR  "AV 27 S/N - LOTE 07/14 Q-42 - CENTRO"
	#Define	XCGCFIR	 "02.614.223/0001-46"
	#Define	XINSCFIR  "407.52069-1"
	#Define	XCCIDA	 "CHUPINGUAIA"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/CHUPINGUAIA"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF INTERCOOLER
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(92)3646-6062" // VITINHO
	#Define	ENCRYPT	 "FUZARI & FUZARI LTDA"
	#Define	XFANTA	 "MANAUS MARMORES E GRANITOS"
	#Define	XENDEFIR  "AV TANCREDO NEVES, 07 - PARQUE 10"
	#Define	XCGCFIR	 "84.570.985/0001-80"
	#Define	XINSCFIR  "36336-7"
	#Define	XCCIDA	 "MANAUS"
	#Define	XCESTA	 "AM"
	#Define	XCEPCIDA  "69054-700/MANAUS"
	#Define	XCCEP 	 "69054-700"
#ENDIF
#IFDEF PNEUAR
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)451-2787" // RONALDO SUCKER
	#Define	ENCRYPT	 "SUCKEL & SUCKEL LTDA"
	#Define	XFANTA	 "PNEUAR"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1307 - CENTRO"
	#Define	XCGCFIR	 "02.635.451/0001-20"
	#Define	XINSCFIR  "0000000090774-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CENTRONORTE
	#Define	XFONE 	 "451-3524" // CRISTIANO
	#Define	ENCRYPT	 "CENTRONORTE LUBRIFICANTES LTDA"
	#Define	XFANTA	 "CENTRONORTE LUBRIFICANTES"
	#Define	XENDEFIR  "AV. MARECHAL RONDON, SN - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF SANTALUCIA
	#Define	XFONE 	 "(069)451-2645" // PEDRO
	#Define	ENCRYPT	 "SANTA LUCIA ACESSORIOS & TAPECARIA LTDA"
	#Define	XFANTA	 "AUTO CAPAS KENDYCAR"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 779 - CENTRO"
	#Define	XCGCFIR	 "22.843.734/0001-75"
	#Define	XINSCFIR  "407.19790-4"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MEIRELES
	#Define	XFONE 	 "(069)451-2166" // DANTE
	#Define	ENCRYPT	 "MEIRELES FOTO COLOR LTDA"
	#Define	XFANTA	 "MEIRELES FOTO COLOR"
	#Define	XENDEFIR  "AV PRESIDENTE KENNEDY, 804 - CENTRO"
	#Define	XCGCFIR	 "04.937.769/0001-91"
	#Define	XINSCFIR  "407.04789-9"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF EXTINSUL
	#Define	XFONE 	 "(069)451-2206" // PEDRO
	#Define	ENCRYPT	 "PEDRO PORTEL - ME"
	#Define	XFANTA	 "EXTINSUL EXTINTORES"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 308 - CENTRO"
	#Define	XCGCFIR	 "63.785.356/0001-06"
	#Define	XINSCFIR  "407.37567-5"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF FAVALECA
	#Define	XFONE 	 "(69)451-2481" // CRISTIANO
	#Define	ENCRYPT	 "COMERCIAL FAVALECA LTDA - ME"
	#Define	XFANTA	 "COMERCIAL FAVALECA"
	#Define	XENDEFIR  "BR 364 - KM 504 - PQ ITAPORANGA"
	#Define	XCGCFIR	 "05.118.468/0001-07"
	#Define	XINSCFIR  "0000000000759-5"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF BOR_MEC_ITA
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)3451-3366"
	#Define	ENCRYPT	 "VALDEMAR FAVALESSA - ME"
	#Define	XFANTA	 "BORRACHARIA E MECANICA ITAPORANGA"
	#Define	XENDEFIR  "BR 364 - KM 202 - ITAPORANGA"
	#Define	XCGCFIR	 "03.859.153/0001-87"
	#Define	XINSCFIR  "0000000080290-5"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF  BRISA
	#Undef	FANTACODEBAR
	#Undef	CODEBAR
	#Undef	MULTI
	#Define	FANTACODEBAR  "DIORON"
	#Define	EMPRECODEBAR  "23"
	#Define	CODEBAR		  OK
	#Define	SCP
	#Define	MULTI 		  OK
	#Define	ANO2000		  OK
	#Define	XFONE 		  "(69)451-2440" // JAIR
	#Define	ENCRYPT		  "BRISA INDUSTRIA DE CONFECCOES LTDA"
	#Define	XFANTA		  "BRISA"
	#Define	XENDEFIR 	  "RUA ALCINDA RIBEIRO DE SOUZA, 160 - CENTRO"
	#Define	XCGCFIR		  "01.095.378/0001-89"
	#Define	XINSCFIR 	  "0000000052052-7"
	#Define	XCCIDA		  "PIMENTA BUENO"
	#Define	XCESTA		  "RO"
   #Define  XCEPCIDA      "76970-000/PIMENTA BUENO"
   #Define  XCCEP         "76970-000"
#ENDIF
#IFDEF  SANCHES
	#Undef	FANTACODEBAR
	#Undef	CODEBAR
	#Undef	MULTI
	#Define	FANTACODEBAR  "DGRIFF"
	#Define	EMPRECODEBAR  "23"
	#Define	CODEBAR		  OK
	#Define	SCP			  OK
	#Define	MULTI 		  OK
	#Define	ANO2000		  OK
	#Define	XFONE 		  "(69)451-2440" // JAIR
	#Define	ENCRYPT		  "SANCHES & CUBA LTDA"
	#Define	XFANTA		  "D'GRIFF IND E COM DE CONFECCOES LTDA"
	#Define	XENDEFIR 	  "AV CASTELO BRANCO, 44 - CENTRO"
	#Define	XCGCFIR		  "03.927.484/0001-07"
	#Define	XINSCFIR 	  "0000000080284-1"
	#Define	XCCIDA		  "PIMENTA BUENO"
	#Define	XCESTA		  "RO"
   #Define  XCEPCIDA      "76970-000/PIMENTA BUENO"
   #Define  XCCEP         "76970-000"
#ENDIF
#IFDEF  MAGIA
	#Define	SCP
	#Define	ANO2000		  OK
	#Define	XFONE 		  "(69)214-3828" // WILSON
	#Define	ENCRYPT		  "MAGIA INDUSTRIA E COMERCIO LTDA - ME"
	#Define	XFANTA		  "MAGIA CONFECCOES"
	#Define	XENDEFIR 	  "AV GUAPORE, 3206 - AGENOR DE CARVALHO"
	#Define	XCGCFIR		  "05.266.849/0001-25"
	#Define	XINSCFIR 	  "0000000113149-4"
	#Define	XCCIDA		  "PORTO VELHO"
	#Define	XCESTA		  "RO"
	#Define	XCEPCIDA 	  "78909-661/PORTO VELHO"
	#Define	XCCEP 		  "78909-661"
#ENDIF
#IFDEF FERMINO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)9986-3498"
	#Define	ENCRYPT	 "RICARDO FERMINO DA SILVA"
	#Define	XFANTA	 "RICARDO FERMINO DA SILVA"
	#Define	XENDEFIR  "RUA ALCINDA RIBEIRO DE SOUZA, 214 - CENTRO"
	#Define	XCGCFIR	 "282.316.602-59"
	#Define	XINSCFIR  "290.064 SSP/RO"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF KOGAKE
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3303" // MIGUEL
	#Define	ENCRYPT	 "KOGAKE AGROINDUSTRIAL LTDA"
	#Define	XFANTA	 "PALMITO SAMARA"
	#Define	XENDEFIR  "BR 364 - KM 506 - BELA VISTA"
	#Define	XCGCFIR	 "02.208.527/0001-31"
	#Define	XINSCFIR  "407.90715-4"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF RONDOLENE
	#Undef	FANTACODEBAR
	#Undef	CODEBAR
	#Undef	MULTI
	#Define	FANTACODEBAR  "TOPPO"
	#Define	EMPRECODEBAR  "24"
	#Define	CODEBAR		  OK
	#Undef	MULTI
	#Define	MULTI 	 OK
	#Define	SCP		 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3868"
	#Define	ENCRYPT	 "G. BERNARDO PEREIRA - ME"
	#Define	XFANTA	 "RONDOLENE CONFECCOES"
	#Define	XENDEFIR  "AV MARECHAL DEODORO, 33 - CENTRO"
	#Define	XCGCFIR	 "84.554.542/0001-04"
	#Define	XINSCFIR  "0000000036342-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF BRASTRACTOR
	#Define	XFONE 	 "(069)451-3224" // FAEDO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ENCRYPT	 "C. F. FAEDO - ME"
	#Define	XFANTA	 "BRASTRACTOR"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 463 - CENTRO"
	#Define	XCGCFIR	 "05.953.716/0001-27"
	#Define	XINSCFIR  "407.09078-6"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF COPICENTER
	#Define	XFONE 	 "69)441-4258"
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ENCRYPT	 "FRANCISCO ALVES DE ALMEIDA - ME"
	#Define	XFANTA	 "COPICENTER"
	#Define	XENDEFIR  "AV PORTO VELHO, 2142 - CENTRO"
	#Define	XCGCFIR	 "63.757.710/0001-80"
	#Define	XINSCFIR  "ISENTO"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF BRASTRACTORCC
	#Define	XFONE 	 "(069)441-4806" // FAEDO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ENCRYPT	 "C. F. FAEDO - ME"
	#Define	XFANTA	 "BRASTRACTOR PECAS P/ TRATORES"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 1388 - CENTRO"
	#Define	XCGCFIR	 "05.953.716/0001-27"
	#Define	XINSCFIR  "407.09078-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF  ANOSSA
	#Undef	FANTACODEBAR
	#Undef	CODEBAR
	#Define	FANTACODEBAR  "A NOSSA"
	#Define	EMPRECODEBAR  "22"
	#Define	CODEBAR		  OK
	#Define	XFONE 		  "(69)321-2273" // ADAIR
	#Define	ENCRYPT		  "D. S. CARVALHO CONFECCOES"
	#Define	XFANTA		  "A NOSSA CONFECCOES"
	#Define	XENDEFIR 	  "AV MAJOR AMARANTES, 3349-A - CENTRO"
	#Define	XCGCFIR		  "02.282.988/0001-54"
	#Define	XINSCFIR 	  "305.90419-8"
	#Define	XCCIDA		  "VILHENA"
	#Define	XCESTA		  "RO"
	#Define	XCEPCIDA 	  "78995-000/VILHENA"
	#Define	XCCEP 		  "78995-000"
#ENDIF
#IFDEF  ATLANTICA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 		  "(69)321-2977"
	#Define	ENCRYPT		  "M. A. PEIXOTO - ME"
	#Define	XFANTA		  "BRASMETAL"
	#Define	XENDEFIR 	  "AV CELSO MAZUTTI, 7245 - SETOR INDUSTRIAL"
	#Define	XCGCFIR		  "04.666.098/0001-71"
	#Define	XINSCFIR 	  "0000000113523-6"
	#Define	XCCIDA		  "VILHENA"
	#Define	XCESTA		  "RO"
	#Define	XCEPCIDA 	  "78995-000/VILHENA"
	#Define	XCCEP 		  "78995-000"
#ENDIF
#IFDEF BRASILFERRA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(66)571-2100"
	#Define	ENCRYPT	 "M. R. COMERCIO DE FERRAMENTAS LTDA"
	#Define	XFANTA	 "UNIVERSAL FERRAMENTAS"
	#Define	XENDEFIR  "AV SETE DE SETEMBRO, S/N - CENTRO"
	#Define	XCGCFIR	 "06.119.385/0001-97"
	#Define	XINSCFIR  "13.247.166-3"
	#Define	XCCIDA	 "COLNIZA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78335-000/COLNIZA"
	#Define	XCCEP 	 "78335-000"
#ENDIF
#IFDEF AGRONIZA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(66)571-1425"
	#Define	ENCRYPT	 "NIVALDO S. GARCIA AGROPECUARIA"
	#Define	XFANTA	 "AGRONIZA PROD. VETERINARIOS E AGRICOLAS"
	#Define	XENDEFIR  "AV DAS ROSEIRAS, SN - CENTRO"
	#Define	XCGCFIR	 "36.907.418/0001-24"
	#Define	XINSCFIR  "13208507-0"
	#Define	XCCIDA	 "COLNIZA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78335-000/COLNIZA"
	#Define	XCCEP 	 "78335-000"
#ENDIF
#IFDEF  RUCELIA
	#Define	SCP
	#Define	XFONE 	 "(067)751-2964" // CLAUDEIR
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	ENCRYPT	 "RUCELIA IND E COM DE CONFECCOES LTDA"
	#Define	XFANTA	 "RUCELIA"
	#Define	XENDEFIR  "RUA DA ILHA, 1276 - B. COPA VILLA II"
	#Define	XCGCFIR	 "01.776.758/0001-89"
	#Define	XINSCFIR  "28.299.193-0"
	#Define	XCCIDA	 "CAMPO GRANDE"
	#Define	XCESTA	 "MS"
	#Define	XCEPCIDA  "79097-030/CAMPO GRANDE"
	#Define	XCCEP 	 "79097-030"
#ENDIF
#IFDEF  BRASTEXTIL
	#Define	XFONE 	 "451-2789" // ADEILSON
	#Define	ENCRYPT	 "IND E COM DE CONFECCOES BRASTEXTIL LTDA"
	#Define	XFANTA	 "BRASTEXTIL"
	#Define	XENDEFIR  "AV. JK, 166 - CENTRO"
	#Define	XCGCFIR	 "63.758.817/0001-43"
	#Define	XINSCFIR  "407.34676-4"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF LONDRIFIO
	#Define	XFONE 	 "451-0000" // ISMAEL
	#Define	ENCRYPT	"LONDRIFIO"
	#Define	XFANTA	 "LONDRIFIO"
	#Define	XENDEFIR  "AV. ALCINDA RIBEIRO DE SOUZA, SN - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF  SEFAZ
	#Define	XFONE 	 "441-2818" // ROBERTO\WAGNER
	#Define	ENCRYPT	"SECRETARIA DE ESTADO DA FAZENDA"
	#Define	XFANTA	 "SEFAZ"
	#Define	XENDEFIR  "RUA ANISIO SERRAO, 2432 - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF AMAZON
	#Define SCP
	#Define	XFONE 	 "451-3427" // GENIVALDO
	#Define	ENCRYPT	 "AMAZON MALHAS IND DE CONFECCOES LTDA"
	#Define	XFANTA	 "AMAZON"
	#Define	XENDEFIR  "AV. CASTELO BRANCO, 432 - CENTRO"
	#Define	XCGCFIR	 "84.578.293/0001-89"
	#Define	XINSCFIR  "407.37561-6"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF YPIRANGA
	#Define	XFONE 	 "(069)451-2021" // MARCIO
	#Define	ENCRYPT	 "COM DE MAT P/ CONST YPIRANGA LTDA"
	#Define	XFANTA	 "YPIRANGA MAT P/ CONSTRUCAO"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 635 - CENTRO"
	#Define	XCGCFIR	 "84.609.700/0001-78"
	#Define	XINSCFIR  "407.37602-7"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF POLLYMODAS
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)442-2335"
	#Define	ENCRYPT	 "ELENICE DE FREITAS MODAS"
	#Define	XFANTA	 "POLLY MODA'S"
	#Define	XENDEFIR  "AV GUAPORE, 5072 - CENTRO"
	#Define	XCGCFIR	 "03.382.016/0001-02"
	#Define	XINSCFIR  "ISENTO"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF KARLACALCADOS
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)442-3264" // MANOEL
	#Define	ENCRYPT	 "MANOEL DE SOUZA E SILVA TECIDO - ME"
	#Define	XFANTA	 "CARLA'S CAL€ADOS"
	#Define	XENDEFIR  "AV NORTE SUL, 4918 - CENTRO"
	#Define	XCGCFIR	 "84.579.804/0001-87"
	#Define	XINSCFIR  "0000000032655-1"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF ROLAO
	#UNDEF	MULTI
	#Define	GRUPO_COCICAL OK
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)442-2009" // ODAIR
	#Define	ENCRYPT	 "ROLAO COM MAT DE CONSTRUCAO LTDA"
	#Define	XFANTA	 "ROLAO MAT DE CONSTRUCAO"
	#Define	XENDEFIR  "AV 25 DE AGOSTO, 5273 - CENTRO"
	#Define	XCGCFIR	 "03.052.955/0001-80"
	#Define	XINSCFIR  "409.92390-7"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
	#Define	XEMAIL	 "ROLAO@RMTURBO.COM.BR"
#ENDIF
#IFDEF COMAM
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)442-1563" // JEREMIAS
	#Define	ENCRYPT	 "J. OLIVEIRA & CIA LTDA"
	#Define	XFANTA	 "COMAM"
	#Define	XENDEFIR  "AV NORTE SUL, 4905 - CENTRO"
	#Define	XCGCFIR	 "34.458.240/0001-56"
	#Defexit
	#Define	XINSCFIR  "409.25145-3"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF ORIENT
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3442-2137"
	#Define	ENCRYPT	 "JULIO CESAR ALVES CARDOSO - ME"
	#Define	XFANTA	 "JOALHERIA E RELOJOARIA BRILHANTE"
	#Define	XENDEFIR  "AV 25 DE AGOSTO, 4872 - CENTRO"
	#Define	XCGCFIR	 "22.852.685/0001-37"
	#Define	XINSCFIR  "19706-6"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF AGROMATEC
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
   #Define  XFONE     "(69)3432-2260" // MARCELO
	#Define	ENCRYPT	 "M. V. RIGONATO DA SILVA & CIA LTDA"
	#Define	XFANTA	 "AGROMATEC"
	#Define	XENDEFIR  "AV TANCREDO NEVES, 3027 - CENTRO"
	#Define	XCGCFIR	 "05.350.711/0001-00"
	#Define	XINSCFIR  "0000000114874-5"
	#Define	XCCIDA	 "NOVA ESTRELA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/NOVA ESTRELA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF DOCELAR
	#Define	ANO2000	  OK
   #Define  XFONE     "(69)3442-4255" // DINALVA
   #Define  ENCRYPT   "COMERCIAL T C ARTIGOS DE DECORACAO LTDA"
   #Define  XFANTA    "DOCE LAR"
   #Define  XENDEFIR  "AV 25 DE AGOSTO, 4848 - CENTRO"
   #Define  XCGCFIR   "01.671.182/0001-95"
   #Define  XINSCFIR  "52481-6"
   #Define  XCCIDA    "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76940-000/ROLIM DE MOURA"
   #Define  XCCEP     "76940-000"
#ENDIF
#IFDEF MAPIN
	#Define	XFONE 	 "(069)442-1960" // ADEMIR
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ENCRYPT	 "MAPIN MAT PARA PINTURAS E TINTAS LTDA"
	#Define	XFANTA	 "MAPIN MATERIAIS PARA CONSTRUCAO"
	#Define	XENDEFIR  "AV. NORTE SUL, 5051 - CENTRO"
	#Define	XCGCFIR	 "34.458.695/0001-71"
	#Define	XINSCFIR  "409.241130-0"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF CASATINTAS
	#Define	XFONE 	 "(069)442-1187" // ADEMIR
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ENCRYPT	 "JOAO LOPES & CIA LTDA"
	#Define	XFANTA	 "CASA DAS TINTAS"
	#Define	XENDEFIR  "RUA BARAO DO MELGACO, 5082 - CENTRO"
	#Define	XCGCFIR	 "22.831.788/0001-10"
	#Define	XINSCFIR  "409.18607-4"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF TRADICAO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)442-2012" // BERNARDO
	#Define	ENCRYPT	 "TRADICAO MATERIAIS PARA CONSTRUCAO LTDA"
	#Define	XFANTA	 "TRADICAO"
	#Define	XENDEFIR  "AV 25 DE AGOSTO, 5333 - CENTRO"
	#Define	XCGCFIR	 "01.643.086/0001-33"
	#Define	XINSCFIR  "409.52473-5"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF TRADICAOSA
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)434-2796" // BERNARDO
	#Define	ENCRYPT	 "TRADICAO MATERIAIS PARA CONSTRUCAO LTDA"
	#Define	XFANTA	 "TRADICAO"
	#Define	XENDEFIR  "RUA JORGE T. DE OLIVEIRA, 2552 - CENTRO"
	#Define	XCGCFIR	 "01.643.086/0002-14"
	#Define	XINSCFIR  "0000000122424-7"
	#Define	XCCIDA	 "SANTA LUZIA D'OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78993-000/SANTA LUZIA D'OESTE"
	#Define	XCCEP 	 "78993-000"
#ENDIF
#IFDEF MEDIFARMA
	#Define	XFONE 	 "441-0000" // CRISTIANO
	#Define	ENCRYPT	 "DROGARIA MEDIFARMA"
	#Define	XFANTA	 "DROGARIA MEDIFARMA"
	#Define	XENDEFIR  "RUA SAO LUIZ, 1566  - CENTRO"
	#Define	XCGCFIR	 "05.211.412/0001-94"
	#Define	XINSCFIR  "403.00539-8"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF GOIAS
	#Define	XFONE 	 "451-2160" // JULLES
	#Define	ENCRYPT	 "J. RIDON BORGES"
	#Define	XFANTA	 "DROGARIA GOIAS"
	#Define	XENDEFIR  "AV. CARLOS DONERGE, 03  - CENTRO"
	#Define	XCGCFIR	 "05.560.768/0001-33"
	#Define	XINSCFIR  "407.04834-8"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MICHAELIS
	#Define SCP
	#Define	XFONE 	 "451-3401" // CRISTIANO
	#Define	ENCRYPT	 "MICHAELIS IND E COM DE CONFECCOES LTDA"
	#Define	XFANTA	 "SONAR"
	#Define	XENDEFIR  "AV. MARECHAL RONDON, 1080A - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF METODO
	#Undef TESTELAN
	#Undef RECELAN
	#Undef PAGALAN
	#Undef VENLAN
	#Undef ORCALAN
	#Undef PONTO
	#Define	XFONE 	 "(69)451-2525"
	#Define	XDOLAR	  OK
	#Define	ENCRYPT	 "METODO AGROPECUARIA LTDA"
	#Define	XFANTA	 "METODO"
	#Define	XENDEFIR  "RUA TENENTE PORTELA, 131 - CENTRO"
	#Define	XCGCFIR	 "02.074.979/0001-59"
	#Define	XINSCFIR  "407.67110-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CAMAGRIL
	#Define	XFONE 	 "(069)441-5036"
	#Define	ENCRYPT	 "CAMAGRIL - IND E COM DE MADEIRAS LTDA"
	#Define	XFANTA	 "CAMAGRIL"
	#Define	XENDEFIR  "ROD BR 364 - KM 462"
	#Define	XCGCFIR	 "04.777.157/0001-46"
	#Define	XINSCFIR  "403.02120-2"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF RIOBRANCO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)471-2555"
	#Define	ENCRYPT	 "RIO BRANCO SUPERMERCADOS LTDA"
	#Define	XFANTA	 "SUPERMERCADO RIO BRANCO"
	#Define	XENDEFIR  "RUA JOSE VIDAL, 2536 - CENTRO"
	#Define	XCGCFIR	 "02.844.704/0001-76"
	#Define	XINSCFIR  "0000000043254-7"
	#Define	XCCIDA	 "PRESIDENTE MEDICE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78968-000/PRESIDENTE MEDICE"
	#Define	XCCEP 	 "78968-000"
#ENDIF
#IFDEF PAROQUIA
	#Undef TESTELAN
	#Undef RECELAN
	#Undef PAGALAN
	#Undef VENLAN
	#Undef ORCALAN
	#Define	_XPOUPANCA OK
	#Define	XFONE 	 "471-2387" // ADALTO
	#Define	ENCRYPT	 "PAROQUIA SAO JOAO BATISTA"
	#Define	XFANTA	 "PAROQUIA SAO JOAO BATISTA"
	#Define	XENDEFIR  "RUA OTAVIO RODRIGUES DE MATOS, 2044 - CENTRO"
	#Define	XCGCFIR	 "04.128.765/0009-10"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PRESIDENTE MEDICE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78968-000/PRESIDENTE MEDICE"
	#Define	XCCEP 	 "78968-000"
#ENDIF
#IFDEF MORUMBIJI
	#Define	XFONE 	 "(69)421-3085"
	#Define	ENCRYPT	 "MORUMBI MATERIAIS P/ CONSTRUCAO LTDA"
	#Define	XFANTA	 "MORUMBI MAT P/ CONSTRUCAO"
	#Define	XENDEFIR  "RUA CASCALHEIRA, 118 - N.BRASILIA"
	#Define	XCGCFIR	 "05.953.641/0001-84"
	#Define	XINSCFIR  "205.12137-1"
	#Define	XCCIDA	 "JI PARANA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78960-000/JI PARANA"
	#Define	XCCEP 	 "78960-000"
#ENDIF
#IFDEF DOISABRIL
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)421-2860"
	#Define	ENCRYPT	 "DOIS DE ABRIL COM DE MAT DE CONST LTDA"
	#Define	XFANTA	 "DEPOSITO DOIS DE ABRIL"
	#Define	XENDEFIR  "RUA MENEZES FILHO, 236 - 02 DE ABRIL"
	#Define	XCGCFIR	 "05.784.319/0001-79"
	#Define	XINSCFIR  "205.19241-4"
	#Define	XCCIDA	 "JI PARANA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78960-000/JI PARANA"
	#Define	XCCEP 	 "78960-000"
#ENDIF
#IFDEF FERNANDES
	#Define	XFONE 	 "(69)421-0630"
	#Define	ENCRYPT	 "FERNANDES E ARAUJO LTDA"
	#Define	XFANTA	 "AUTO POSTO AVENIDA"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1238"
	#Define	XCGCFIR	 "02.964.862/0001-60"
	#Define	XINSCFIR  "205.95525-6"
	#Define	XCCIDA	 "JI PARANA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78960-000/JI PARANA"
	#Define	XCCEP 	 "78960-000"
#ENDIF
#IFDEF CAIARI
	#Define	NOTACAIARI OK
	#Define	XFONE 	 "421-5455"
	#Define	XCHEQUE_PRE  OK
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ENCRYPT	 "CAIARI MATERIAIS P/ CONSTRUCAO LTDA"
	#Define	XFANTA	 "MERCANTIL CAIARI"
	#Define	XENDEFIR  "AV. BRASIL, 520 - NOVA BRASILIA"
	#Define	XCGCFIR	 "14.586.770/0001-72"
	#Define	XINSCFIR  "205.13365-5"
	#Define	XCCIDA	 "JI PARANA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78958-000/JI PARANA"
	#Define	XCCEP 	 "78958-000"
#ENDIF
#IFDEF KONCICLOS
	#Define	XFONE 	 "(69)321-3500"
	#Define	ENCRYPT	 "FELIX & RIBEIRO COM BICICLETAS P ACES LTDA"
	#Define	XFANTA	 "CICLO RIBEIRO"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 3388 - CENTRO"
	#Define	XCGCFIR	 "03.230.659/0001-22"
	#Define	XINSCFIR  "305.90464-3"
	#Define	XCCIDA	 "VILHENA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78995-000/VILHENA"
	#Define	XCCEP 	 "78995-000"
#ENDIF
#IFDEF GUAPORE
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)451-2839"
	#Define	ENCRYPT	 "R. C. FERRO - ME"
	#Define	XFANTA	 "R. C. FERRO"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 568 - CENTRO"
	#Define	XCGCFIR	 "02.363.827/0001-95"
	#Define	XINSCFIR  "0000000051725-9"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF KEOPS
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(65)566-2337"
	#Define	ENCRYPT	 "KEOPS MATERIAL DE CONSTRUCAO LTDA"
	#Define	XFANTA	 "CONSTRULIMA"
	#Define	XENDEFIR  "AV. DOS JAMBOS, SN - CENTRO"
	#Define	XCGCFIR	 "02.976.108/0001-40"
	#Define	XINSCFIR  "13.040.586-8"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF CONSTRULAR
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)566-1204"
	#Define	ENCRYPT	 "COM DE MAT DE CONSTR HOFFMANN LTDA"
	#Define	XFANTA	 "CONSTRULAR"
	#Define	XENDEFIR  "RUA GABRIEL MULLER, S/N - CENTRO"
	#Define	XCGCFIR	 "26.787.747/0001-25"
	#Define	XINSCFIR  "13.125.808-7"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF GLAUBER
	#Define	XFONE 	 "(065)566-2304"
	#Define	ENCRYPT	 "V. L. CHAVES & CIA LTDA"
	#Define	XFANTA	 "DISTRIBUIDORA GLAUBER"
	#Define	XENDEFIR  "AV TANCREDO NEVES, 6283 - CENTRO"
	#Define	XCGCFIR	 "02.106.654/0001-20"
	#Define	XINSCFIR  "13.177.382-8"
	#Define	XCCIDA	 "VILHENA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF CONSTRUCENTER
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)566-1223"
	#Define	ENCRYPT	 "HOFFMANN & PAPPEN LTDA"
	#Define	XFANTA	 "CONSTRUCENTER"
	#Define	XENDEFIR  "AV DOS JAMBOS, 642 - CENTRO"
	#Define	XCGCFIR	 "01.479.509/0001-21"
	#Define	XINSCFIR  "13.171.176-8"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF REIDOPANO
	#Define	XFONE 	 "(66)3566-1727"
	#Define	ENCRYPT	 "GEREMIAS DA SILVA LIMA - ME"
	#Define	XFANTA	 "REI DO PANO"
	#Define	XENDEFIR  "AV DOS JAMBOS, 1360 - CENTRO"
	#Define	XCGCFIR	 "03.220.654/0001-19"
	#Define	XINSCFIR  "13.051950-2"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF SANTAGEMA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(065)566-2204"
	#Define	ENCRYPT	 "MARQUES LUIZ & MARTINS LTDA"
	#Define	XFANTA	 "PHARMACIA SANTA GEMA"
	#Define	XENDEFIR  "AV 9 DE MAIO, 267 - CENTRO"
	#Define	XCGCFIR	 "36.876.993/0001-07"
	#Define	XINSCFIR  "13.136.227-5"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
	#Define	XRAMO 	 "MEDICAMENTOS E PERFUMARIAS"
#ENDIF
#IFDEF HERMESS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)531-3232"
	#Define	ENCRYPT	 "AGROPECUARIA HERMES'S LTDA"
	#Define	XFANTA	 "SINOP AGROPECUARIA"
	#Define	XENDEFIR  "AV GOV JULIO CAMPOS, 655 - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0000-00"
	#Define	XINSCFIR  "00.000.000-0"
	#Define	XCCIDA	 "SINOP"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78550-000/SINOP"
	#Define	XCCEP 	 "78550-000"
#ENDIF
#IFDEF BETEL
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1366" // JANETE
	#Define	ENCRYPT	 "A. J. FRANCISCO - ME"
	#Define	XFANTA	 "LIVRARIA E PAPELARIA BETEL"
	#Define	XENDEFIR  "RUA SOROCABA, 521 - CENTRO"
	#Define	XCGCFIR	 "01.980.903/0001-49"
	#Define	XINSCFIR  "13.047.760-5"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF AGROTERRA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1218" // ELIANE
	#Define	ENCRYPT	 "TOFFOLO & TOFFOLO LTDA"
	#Define	XFANTA	 "AGROTERRA"
	#Define	XENDEFIR  "AV RIO GRANDE DO SUL, 362 - CENTRO"
	#Define	XCGCFIR	 "86.915.055/0001-47"
	#Define	XINSCFIR  "13.1527.066-0"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF ESTUDANTIL
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1077" // Carlos
	#Define	ENCRYPT	 "M. T. P. DE MORAES"
	#Define	XFANTA	 "ESTUDANTIL LIVRARIA E PAPELARIA"
	#Define	XENDEFIR  "AV RIO ARINOS, 1135 - CENTRO"
	#Define	XCGCFIR	 "03.568.934/0001-12"
	#Define	XINSCFIR  "13.047.828-8"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF GRIFFE
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1385"
	#Define	ENCRYPT	 "R. DA SILVA BOUTIQUE - ME"
	#Define	XFANTA	 "GRIFFE BOUTIQUE"
	#Define	XENDEFIR  "AV RIO ARINOS, 1732 - CENTRO"
	#Define	XCGCFIR	 "02.478.587/0001-74"
	#Define	XINSCFIR  "13.181.067-7"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF CENTERDROGAS
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1263" // CARLOS
	#Define	ENCRYPT	 "CARLOS BORDINHAO - ME"
	#Define	XFANTA	 "CENTER DROGAS"
	#Define	XENDEFIR  "AV RIO ARINOS, 879 - CENTRO"
	#Define	XCGCFIR	 "37.474.731/0001-89"
	#Define	XINSCFIR  "13.144.889-7"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF JAMAR
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1653" // Jair
	#Define	ENCRYPT	 "J. S. DE OLIVEIRA FERRAGEM - ME"
	#Define	XFANTA	 "JAMAR"
	#Define	XENDEFIR  "AV RIO ARINOS, 1350 - CENTRO"
	#Define	XCGCFIR	 "70.429.188/0001-73"
	#Define	XINSCFIR  "13.146.410-8"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF CAMPOELAVOURA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1381"
	#Define	ENCRYPT	 "AGROPECUARIA HERMES LTDA"
	#Define	XFANTA	 "CAMPO E LAVOURA"
	#Define	XENDEFIR  "AV RIO ARINOS, 1242 - CENTRO"
	#Define	XCGCFIR	 "03.268.083/0003-54"
	#Define	XINSCFIR  "13.179.149-4"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF KRMOTOS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1782"
	#Define	ENCRYPT	 "NOZAKI & NOZAKI LTDA"
	#Define	XFANTA	 "KR MOTOS"
	#Define	XENDEFIR  "AV RIO ARINOS, 1602 - CENTRO"
	#Define	XCGCFIR	 "24.967.234/0001-70"
	#Define	XINSCFIR  "13.046.334-5"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF VAREJAO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)556-1150"
	#Define	ENCRYPT	 "J. CARLOS DA SILVA & CIA LTDA"
	#Define	XFANTA	 "VAREJAO SAO PAULO"
	#Define	XENDEFIR  "AV RIO ARINOS, 1174 - CENTRO"
	#Define	XCGCFIR	 "24.698.623/0001-48"
	#Define	XINSCFIR  "51.200.258-24"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF PAIVA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1480"
	#Define	ENCRYPT	 "DIST DE BEBIDAS PAIVA LTDA"
	#Define	XFANTA	 "DIST DE BEBIDAS PAIVA"
	#Define	XENDEFIR  "RUA SANTO ANTONIO, 125 - CENTRO"
	#Define	XCGCFIR	 "37.438.306/0001-34"
	#Define	XINSCFIR  "13.137.278-5"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF CONCEICAO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)556-2316"
	#Define	ENCRYPT	 "MARIA DA CONCEI€AO C. PEREIRA - ME"
	#Define	XFANTA	 "BAZAR CONCEI€AO"
	#Define	XENDEFIR  "RUA RIO DE JANEIRO, 919 - CENTRO"
	#Define	XCGCFIR	 "26.609.925/0001-28"
	#Define	XINSCFIR  "13.096.353-4"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF MARISSOL
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)556-1319"
	#Define	ENCRYPT	 "L. GON€ALVES BAZAR"
	#Define	XFANTA	 "BAZAR MARISSOL"
	#Define	XENDEFIR  "RUA SOROCABA, 539 - CENTRO"
	#Define	XCGCFIR	 "14.941.710/0001-20"
	#Define	XINSCFIR  "13.113.343-8"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF QUILES
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1116"
	#Define	ENCRYPT	 "MOVEIS QUILES LTDA"
	#Define	XFANTA	 "MOVEIS QUILES"
	#Define	XENDEFIR  "AV RIO ARINOS, 1134 - CENTRO"
	#Define	XCGCFIR	 "03.241.585/0001-20"
	#Define	XINSCFIR  "13.041.253-8"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF CANTON
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1326"
	#Define	ENCRYPT	 "COMERCIAL VALE DO ARINOS LTDA"
	#Define	XFANTA	 "SUPERMERCADO CANTON"
	#Define	XENDEFIR  "AV RIO ARINOS, 934 - CENTRO"
	#Define	XCGCFIR	 "02.384.149/0001-47"
	#Define	XINSCFIR  "13.179.934-7"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF SANTAROSA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1235"
	#Define	ENCRYPT	 "C. M. DA SILVA COMERCIO - ME"
	#Define	XFANTA	 "COMERCIAL SANTA ROSA"
	#Define	XENDEFIR  "RUA NITEROI, 20 - CENTRO"
	#Define	XCGCFIR	 "01.596.390/0001-77"
	#Define	XINSCFIR  "13.172.382-0"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF JUDISBEL
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1413"
	#Define	ENCRYPT	 "JUDISBEL - JUARA DIST DE BEBIDAS LTDA"
	#Define	XFANTA	 "JUDISBEL"
	#Define	XENDEFIR  "RUA SERGIPE, 271 - CENTRO"
	#Define	XCGCFIR	 "03.225.077/0001-58"
	#Define	XINSCFIR  "13.188.123-0"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF NEIDROGAS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1278"
	#Define	ENCRYPT	 "V. H. MORAIS - ME"
	#Define	XFANTA	 "NEI DROGAS"
	#Define	XENDEFIR  "RUA SOROCABA, 522-C - CENTRO"
	#Define	XCGCFIR	 "37.429.917/0001-16"
	#Define	XINSCFIR  "131.37164-9"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF PARAFUSOS
	#Define	XFONE 	 "(65)556-1408"
	#Define	ENCRYPT	 "JUARA COM DE FERRAGENS LTDA - ME"
	#Define	XFANTA	 "CASA DOS PARAFUSOS"
	#Define	XENDEFIR  "PRACA DOS COLONIZADORES, 450 - CENTRO"
	#Define	XCGCFIR	 "01.427.715/0001-98"
	#Define	XINSCFIR  "13.024977-7"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF TUTTY
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)556-1089"
	#Define	ENCRYPT	 "PAULO CESAR MALLMANN - ME"
	#Define	XFANTA	 "TUTTY SPORT"
	#Define	XENDEFIR  "AV RIO ARINOS, 1332 - CENTRO"
	#Define	XCGCFIR	 "01.270.402/0001-79"
	#Define	XINSCFIR  "13.169.249-6"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF AQUARIUS
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(065)556-1986"
	#Define	ENCRYPT	 "ALEIXO & ALEIXO LTDA"
	#Define	XFANTA	 "BOUTIQUE AQUARIUS"
	#Define	XENDEFIR  "AV NELSON T. LACERDA, 725 - CENTRO"
	#Define	XCGCFIR	 "01.174.820/0001-62"
	#Define	XINSCFIR  "13.024.965-3"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF PANTANAL
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(065)556-1037"
	#Define	ENCRYPT	 "B. M. DALLA COSTA DA SILVA-ME"
	#Define	XFANTA	 "SUPERMERCADO PANTANAL"
	#Define	XENDEFIR  "AV RIO ARINOS, 1105 - CENTRO"
	#Define	XCGCFIR	 "00.509.944/0001-99"
	#Define	XINSCFIR  "13.160.873-8"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF AGROSOL
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(65)556-1539"
	#Define	ENCRYPT	 "J. H. BORGES CIA LTDA"
	#Define	XFANTA	 "AGROSOL"
	#Define	XENDEFIR  "PRACA DOS COLONIZADORES, 460 - CENTRO"
	#Define	XCGCFIR	 "37.431.186/0001-43"
	#Define	XINSCFIR  "13.137.082-0"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF TAKEDA
	#Define	XFONE 	 "(65)556-1396"
	#Define	ENCRYPT	 "S. SCHMITZ TAKEDA - ME"
	#Define	XFANTA	 "DROGARIA TOKIO"
	#Define	XENDEFIR  "AV RIO ARINOS, 962 - CENTRO"
	#Define	XCGCFIR	 "00.356.938/0001-49"
	#Define	XINSCFIR  "13.159.185-1"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF LIBERAL
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)556-1424"
	#Define	ENCRYPT	 "DROGARIA LIBERAL LTDA."
	#Define	XFANTA	 "DROGARIA LIBERAL"
	#Define	XENDEFIR  "PRACA SAO JOSE, S/N - CENTRO"
	#Define	XCGCFIR	 "00.938.969/0001-08"
	#Define	XINSCFIR  "13.018.068-8"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF HOLANDA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1422"
	#Define	ENCRYPT	 "HOLANDA & GON€ALVES LTDA."
	#Define	XFANTA	 "LOJA PAULISTA - HOLANDA CALCADOS"
	#Define	XENDEFIR  "RUA SOROCABA, 604 - CENTRO"
	#Define	XCGCFIR	 "26.782.441/0001-86"
	#Define	XINSCFIR  "13.126.745-0"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF ZUZU
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)556-1213"
	#Define	ENCRYPT	 "CONFECCOES SOUZA RODRIGUES LTDA - ME"
	#Define	XFANTA	 "ZUZU MODAS"
	#Define	XENDEFIR  "RUA SOROCABA, 578 - CENTRO"
	#Define	XCGCFIR	 "00.208.291/0001-08"
	#Define	XINSCFIR  "13.156.826-4"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF CHAMAGAS
	#Define	XFONE 	 "(065)556-1660"
	#Define	ENCRYPT	 "C. O. DE ARAUJO MORAES - ME"
	#Define	XFANTA	 "CHAMA GAS/OURO GAS/SERVE GAS"
	#Define	XENDEFIR  "AV RIO ARINOS, SN - CENTRO"
	#Define	XCGCFIR	 "00.426.318/0001-39"
	#Define	XINSCFIR  "13.160.925-4"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF MULTIMARCA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)556-2054"
	#Define	ENCRYPT	 "AUED & SILVA LTDA - ME"
	#Define	XFANTA	 "MULTIMARCA"
	#Define	XENDEFIR  "RUA NELSON TABORDA LACERDA, 725-B - CENTRO"
	#Define	XCGCFIR	 "01.464.095/0001-67"
	#Define	XINSCFIR  "13.170.882-1"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF SAULMOTOS
	#Define	XFONE 	 "(065)556-1079"
	#Define	ENCRYPT	 "SAULI P. DOBBINS - ME"
	#Define	XFANTA	 "SAUL MOTOS"
	#Define	XENDEFIR  "RUA NELSON TABORDA LACERDA, 465 - CENTRO"
	#Define	XCGCFIR	 "37.427.705/0001-08"
	#Define	XINSCFIR  "13.137.386-2"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF SCARIOT
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)526-1253"
	#Define	ENCRYPT	 "JOAO FRANCISCO SCARIOT"
	#Define	XFANTA	 "SCAMAT"
	#Define	XENDEFIR  "AV DIAMANTINO, SN - CENTRO"
	#Define	XCGCFIR	 "01.872.035/0001-83"
	#Define	XINSCFIR  "13.030.808-0"
	#Define	XCCIDA	 "PORTO DOS GAUCHOS"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78560-000/PORTO DOS GAUCHOS"
	#Define	XCCEP 	 "78560-000"
#ENDIF
#IFDEF DENI
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)556-1584"
	#Define	ENCRYPT	 "DENI OLIVEIRA DOS SANTOS - ME"
	#Define	XFANTA	 "DENI MAT. P/ CONSTRU€OES"
	#Define	XENDEFIR  "RUA PIRACICABA, 700 - CENTRO"
	#Define	XCGCFIR	 "00.492.460/0001-84"
	#Define	XINSCFIR  "13.160.761-8"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF DETALHES
	#Define	XFONE 	 "(65)556-1805"
	#Define	ENCRYPT	 "M. MIURA KISHINO - ME"
	#Define	XFANTA	 "DETALHES MODAS"
	#Define	XENDEFIR  "RUA BAURU, 600 - CENTRO"
	#Define	XCGCFIR	 "00.371.546/0001-59"
	#Define	XINSCFIR  "13.159.276-9"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
	#Define	XEMAIL	 "KISHINO@VSP.COM.BR"
#ENDIF
#IFDEF BELLADONNA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(065)566-1833"
	#Define	XRAMO 	 "MEDICAMENTOS E PERFUMARIAS"
	#Define	ENCRYPT	 "SONIA R. MARTINS - ME"
	#Define	XFANTA	 "PHARMACIA BELLADONNA"
	#Define	XENDEFIR  "AV MATO GROSSO, 392 - CENTRO"
	#Define	XCGCFIR	 "01.398.583/0001-13"
	#Define	XINSCFIR  "13.170.475-3"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF SAOFRANCISCO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(66)3566-4129"
	#Define	ENCRYPT	 "AMORIM NUNES & OLIVEIRA LTDA"
	#Define	XFANTA	 "DROGARIA VIDA"
	#Define	XRAMO 	 "MEDICAMENTOS E PERFUMARIAS"
	#Define	XENDEFIR  "AV 9 DE MAIO, 154 - SL 02 - CENTRO"
	#Define	XCGCFIR	 "08.927.411/0001-39"
	#Define	XINSCFIR  "133.40757-8"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF RAINHA
	#Define	XFONE 	 "(65)566-2359"
	#Define	ENCRYPT	 "SILAS DE MORAIS & MOTTA LTDA"
	#Define	XFANTA	 "RAINHA DIST DE BEBIDAS SKOL"
	#Define	XENDEFIR  "AV GOV JAIME CAMPOS, SN - CENTRO"
	#Define	XCGCFIR	 "01.334.454/0001-61"
	#Define	XINSCFIR  "13.169.850-0"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF DIMAG
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(65)566-1280"
	#Define	ENCRYPT	 "DMBF MAQUINAS E FERRAMENTAS LTDA"
	#Define	XFANTA	 "DIMAG"
	#Define	XENDEFIR  "AV INT. JAIME CAMPOS, 1005 - CENTRO"
	#Define	XCGCFIR	 "05.500.043/0001-50"
	#Define	XINSCFIR  "13.216.211-3"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF APARECIDA
	#Define	XFONE 	 "(65)556-1502"
	#Define	ENCRYPT	 "O. A. FERREIRA"
	#Define	XFANTA	 "SUPERMERCADO N. SRA APARECIDA"
	#Define	XENDEFIR  "AV RIO ARINOS, 1150 - CENTRO"
	#Define	XCGCFIR	 "02.623.214/0001-40"
	#Define	XINSCFIR  "13.078.239-4"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF STAHELENA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1681"
	#Define	ENCRYPT	 "J. F. R. BAGANHA - ME" // Baganha
	#Define	XFANTA	 "SANTA HELENA A CONSTRUMONTE"
	#Define	XENDEFIR  "PRACA DOS TRABALHADORES, 434 - CENTRO"
	#Define	XCGCFIR	 "03.474.149/0001-09"
	#Define	XINSCFIR  "13.190.551-1"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF SAOMATEUS
	#Undef	MULTI
	#Define	MULTI 		 OK
	#Define	ANO2000		 OK
	#Define	XFONE 		 "(065)000-0000"
	#Define	ENCRYPT		 "AMAURI CARLOS BATISTA - ME"
	#Define	XFANTA		 "ACESSORIOS SAO MATHEUS"
	#Define	XRAMO 		 "RODO-AR,PARABRISAS,TOCA-FITAS"
	#Define	XENDEFIR 	 "BR 364 - KM 401 - DIST INDL"
	#Define	XCGCFIR		 "01.868.154/0001-62"
	#Define	XINSCFIR 	 "13.175.145-0"
	#Define	XCCIDA		 "CUIABA"
	#Define	XCESTA		 "MT"
	#Define	XCEPCIDA 	 "78098-270/CUIABA"
	#Define	XCCEP 		 "78098-270"
#ENDIF
#IFDEF SAO_PAULO
	#Define	XFONE 	 "(069)451-2251"
	#Define	ENCRYPT	 "DIST. DE BEBIDAS SAO PAULO LTDA."
	#Define	XFANTA	 "DIST. DE BEBIDAS SCHINCARIOL"
	#Define	XENDEFIR  "AV. INT. GOV JAIME CAMPOS, SN - CENTRO"
	#Define	XCGCFIR	 "86.939.956/0001-79"
	#Define	XINSCFIR  "13.152.313-9"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF TINTAS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(065)566-1750" // GIDESEL
	#Define	ENCRYPT	 "G. B. DE OLIVEIRA & CIA LTDA"
	#Define	XFANTA	 "CASA DAS TINTAS"
	#Define	XENDEFIR  "AV. MATO GROSSO, SN - CENTRO"
	#Define	XCGCFIR	 "26.578.880/0001-71"
	#Define	XINSCFIR  "13.122.103-5"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF JUREMAQ
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 		 "(65)581-1174"
	#Define	ENCRYPT		 "STOCCO & SILVA LTDA"
	#Define	XFANTA		 "JUREMAQ MOTORES"
	#Define	XENDEFIR 	 "AV. 04 DE JULHO, 547 - CENTRO"
	#Define	XCGCFIR		 "01.213.595/0001-26"
	#Define	XINSCFIR 	 "13.168.630-5"
	#Define	XCCIDA		 "CASTANHEIRA"
	#Define	XCESTA		 "MT"
	#Define	XCEPCIDA 	 "78345-000/CASTANHEIRA"
	#Define	XCCEP 		 "78345-000"
#ENDIF
#IFDEF SUPIMPA
	#UNDEF	MULTI
	#Define	MULTI 		 OK
	#Define	XFONE 		 "(65)581-1137"
	#Define	ENCRYPT		 "T. F. DA SILVA MERCEARIA - ME"
	#Define	XFANTA		 "SUPERMERCADO SUPIMPA"
	#Define	XENDEFIR 	 "AV GOV JAIME CAMPOS, 1.055 - CENTRO"
	#Define	XCGCFIR		 "01.156.859/0001-57"
	#Define	XINSCFIR 	 "13.167.960-0"
	#Define	XCCIDA		 "CASTANHEIRA"
	#Define	XCESTA		 "MT"
	#Define	XCEPCIDA 	 "78345-000/CASTANHEIRA"
	#Define	XCCEP 		 "78345-000"
#ENDIF
#IFDEF VIZIOLI
	#Define	XFONE 		 "(65)581-1281"
	#Define	ENCRYPT		 "SUPERMERCADO VIZIOLI LTDA - EPP"
	#Define	XFANTA		 "SUPERMERCADO VIZIOLI"
	#Define	XENDEFIR 	 "AV JAIME CAMPOS, SN - CENTRO"
	#Define	XCGCFIR		 "02.157.947/0001-36"
	#Define	XINSCFIR 	 "13.177.821-8"
	#Define	XCCIDA		 "CASTANHEIRA"
	#Define	XCESTA		 "MT"
	#Define	XCEPCIDA 	 "78345-000/CASTANHEIRA"
	#Define	XCCEP 		 "78345-000"
#ENDIF
#IFDEF AIDA
	#Define	XFONE 		 "(65)581-1108"
	#Define	ENCRYPT		 "AIDA MODESTINA COSTA DA SILVA - ME"
	#Define	XFANTA		 "COMERCIAL C & SILVA"
	#Define	XENDEFIR 	 "AV JAIME CAMPOS, SN - CENTRO"
	#Define	XCGCFIR		 "00.770.159/0001-95"
	#Define	XINSCFIR 	 "13.163.995-1"
	#Define	XCCIDA		 "CASTANHEIRA"
	#Define	XCESTA		 "MT"
	#Define	XCEPCIDA 	 "78345-000/CASTANHEIRA"
	#Define	XCCEP 		 "78345-000"
#ENDIF
#IFDEF JADERCEREALISTA
	#UNDEF	MULTI
	#Define	MULTI 		OK
	#Define	ANO2000		OK
	#Define	DEF_CEREAIS OK
	#Define	XFONE 	 "(65)566-1209"
	#Define	ENCRYPT	 "CEREALISTA JADER NORTE LTDA"
	#Define	XFANTA	 "CEREALISTA JADER NORTE"
	#Define	XENDEFIR  "ROD AR 01, SN - SETOR INDL"
	#Define	XCGCFIR	 "24.765.042/0001-81"
	#Define	XINSCFIR  "13.061914-0"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF JADERVEICULOS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(66)566-2003"
	#Define	ENCRYPT	 "NORTE AUTO MOTORES VEICULOS E LOCACAO LTDA"
	#Define	XFANTA	 "JADER NORTE VEICULOS"
	#Define	XENDEFIR  "AV GABRIEL MULLER, 185 - CENTRO"
	#Define	XCGCFIR	 "00.250.228/0001-30"
	#Define	XINSCFIR  "13.158059-0"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF JUVEL
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)556-1400"
	#Define	ENCRYPT	 "O. J. BATISTA & CIA LTDA"
	#Define	XFANTA	 "JUVEL - JUARA VEICULOS"
	#Define	XENDEFIR  "AV RIO ARINOS, 1616 - CENTRO"
	#Define	XCGCFIR	 "02.475.664/0001-32"
	#Define	XINSCFIR  "13.180.691-2"
	#Define	XCCIDA	 "JUARA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78575-000/JUARA"
	#Define	XCCEP 	 "78575-000"
#ENDIF
#IFDEF AUTOSOM
	#Define	XFONE 	 "(065)566-1997"
	#Define	ENCRYPT	 "AUTO SOM JUINA - AUDIO & VIDEO"
	#Define	XFANTA	 "AUTO SOM JUINA - AUDIO & VIDEO"
	#Define	XENDEFIR  "AV MATO GROSSO, SN - CENTRO"
	#Define	XCGCFIR	 "02.421.113/0001-96"
	#Define	XINSCFIR  "13.036.534-3"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF CONSTRULARPB
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3153"
	#Define	ENCRYPT	 "C. MAGALHAES LTDA - ME"
	#Define	XFANTA	 "CONSTRULAR MATERIAS P/ CONSTRUCAO"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 2045 - CENTRO"
	#Define	XCGCFIR	 "01.720.173/0001-47"
	#Define	XINSCFIR  "0000000007034-3"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF COCICAL
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	GRUPO_COCICAL OK
	#Define	ANO2000	 OK
	#Define	XRAMO 	 "USE ESTA CASA PARA CONSTRUIR A SUA"
	#Define	XFONE 	 "(69)3441-2038"
	#Define	ENCRYPT	 "COCICAL COM DE CIMENTO CACOAL LTDA"
	#Define	XFANTA	 "COCICAL MAT P/ CONSTRUCAO"
	#Define	XENDEFIR  "AV PORTO VELHO, 2579 - CENTRO"
	#Define	XCGCFIR	 "84.631.209/0001-43"
	#Define	XINSCFIR  "0000000034580-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF HIPERPB
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)451-2990"
	#Define	ENCRYPT	 "GAUCHA CROSS COM E REPRES LTDA"
	#Define	XFANTA	 "HIPER MOTOS"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 900 - CENTRO"
	#Define	XCGCFIR	 "63.755.946/0001-88"
	#Define	XINSCFIR  "103.32146-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF TUTTO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3521"
	#Define	ENCRYPT	 "NORTBRASIL IND COM E REPRES LTDA"
	#Define	XFANTA	 "TUTTO BELLO"
	#Define	XENDEFIR  "CASSEMIRO DE ABREU, SN - CENTRO"
	#Define	XCGCFIR	 "63.759.864/0001-01"
	#Define	XINSCFIR  "407.34673-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF PLANALTO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)451-2415"
	#Define	ENCRYPT	 "PLANALTO COM MAT P/ CONSTRUCAO LTDA"
	#Define	XFANTA	 "PLANALTO MAT P/ CONSTRUCAO"
	#Define	XENDEFIR  "CASSEMIRO DE ABREU, 44 - CENTRO"
	#Define	XCGCFIR	 "84.576.784/0001-90"
	#Define	XINSCFIR  "407.36339-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF PLANALTOII
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)451-8707"
	#Define	ENCRYPT	 "XAVIER & MOREIRA LTDA - ME"
	#Define	XFANTA	 "PLANALTO MAT P/ CONSTRUCAO"
	#Define	XENDEFIR  "AV CUNHA BUENO, 877 - CENTRO"
	#Define	XCGCFIR	 "07.376.926/0001-25"
	#Define	XINSCFIR  "0000000136534-7"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF KINKAS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-2308"
	#Define	ENCRYPT	 "KINKAS COM DE MAT P/ CONSTRUCAO LTDA"
	#Define	XFANTA	 "KINKAS MAT P/ CONSTRUCAO"
	#Define	XENDEFIR  "AV PRUDENTE DE MORAES, 33 - CENTRO"
	#Define	XCGCFIR	 "06.121.648/0001-00"
	#Define	XINSCFIR  "0000000125151-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF H2O
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3358"
	#Define	ENCRYPT	 "H2O PISCINAS E ACESSORIOS LTDA - ME"
	#Define	XFANTA	 "H2O PISCINAS E ACESSORIOS"
	#Define	XENDEFIR  "PRESIDENTE KENNEDY, 770 - SL11 - CENTRO"
	#Define	XCGCFIR	 "03.222.086/0001-95"
	#Define	XINSCFIR  "407.90481-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF LOVATTO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)451-2892"
	#Define	ENCRYPT	 "COML DE AUTO PECAS LOVATTO LTDA"
	#Define	XFANTA	 "AUTO PECAS LOVATTO"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1397 - CENTRO"
	#Define	XCGCFIR	 "84.633.759/0001-00"
	#Define	XINSCFIR  "407.44148-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF AMALIA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(11)810-3500"
	#Define	ENCRYPT	 "VERCON-VERTENTE GRANDE CONST E AGROP LTDA"
	#Define	XFANTA	 "FAZENDA AMALIA"
	#Define	XENDEFIR  "R JORGE R. M. DE ALMEIDA, SN - BUTANTA"
	#Define	XCGCFIR	 "57.641.854/0001-74"
	#Define	XINSCFIR  "111.860.489.119"
	#Define	XCCIDA	 "SAO PAULO"
	#Define	XCESTA	 "SP"
	#Define	XCEPCIDA  "05397-000/SAO PAULO"
	#Define	XCCEP 	 "05397-000"
#ENDIF
#IFDEF JACO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-2670"
	#Define	ENCRYPT	 "PALACIO DOS PARAFUSOS LTDA"
	#Define	XFANTA	 "CASA DOS PARAFUSOS"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1360 - CENTRO"
	#Define	XCGCFIR	 "84.640.176/0001-06"
	#Define	XINSCFIR  "00000000044161-9"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF Q_DELICIA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3710"
	#Define	ENCRYPT	 "SUPERMERCADO Q. DELICIA LTDA"
	#Define	XFANTA	 "SUPERMERCADO Q. DELICIA"
	#Define	XENDEFIR  "AV CUNHA BUENO, 937 - CENTRO"
	#Define	XCGCFIR	 "84.622.091/0001-97"
	#Define	XINSCFIR  "407.37623-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MARUZA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(19)3862-7088"
	#Define	ENCRYPT	 "LUIZ CARLOS DA SILVA MOGI MIRIM - ME"
	#Define	XFANTA	 "MARUZA CONFECCOES"
	#Define	XENDEFIR  "RUA 15 DE NOVEMBRO, 158 - CENTRO"
	#Define	XCGCFIR	 "00.954.972/0001-15"
	#Define	XINSCFIR  "456.054.030.115-ME"
	#Define	XCCIDA	 "MOGI MIRIM"
	#Define	XCESTA	 "SP"
	#Define	XCEPCIDA  "13870-970/MOGI MIRIM"
	#Define	XCCEP 	 "13870-970"
#ENDIF
#IFDEF CAROL
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(19)3861-5266"
	#Define	ENCRYPT	 "FILOMENA NORONHA DA SILVA MOGI GUACU -ME"
	#Define	XFANTA	 "CAROL MODAS"
	#Define	XENDEFIR  "RUA APOLINARIO, 144 - CENTRO"
	#Define	XCGCFIR	 "59.376.418/0001-40"
	#Define	XINSCFIR  "455.040.504.111-ME"
	#Define	XCCIDA	 "MOGI GUACU"
	#Define	XCESTA	 "SP"
	#Define	XCEPCIDA  "13840-000/MOGI GUACU"
	#Define	XCCEP 	 "13840-000"
#ENDIF
#IFDEF SAUDE
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(19)3841-6677"
	#Define	ENCRYPT	 "MANOEL PEREIRA DA SILVA MOGI GUACU - ME"
	#Define	XFANTA	 "DROGARIA SAUDE"
	#Define	XENDEFIR  "AV PADRE JAIME, 1410 - PLANALTO VERDE"
	#Define	XCGCFIR	 "03.189.337/0001-87"
	#Define	XINSCFIR  "455.087.592.119-ME"
	#Define	XCCIDA	 "MOGI GUACU"
	#Define	XCESTA	 "SP"
	#Define	XCEPCIDA  "13840-000/MOGI GUACU"
	#Define	XCCEP 	 "13840-000"
#ENDIF
#IFDEF METALVIDRO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)641-2576"
	#Define	ENCRYPT	 "ELIOMAR ELLER - ME"
	#Define	XFANTA	 "METALVIDRO"
	#Define	XENDEFIR  "AV AMAZONAS, 4177 - CENTRO"
	#Define	XCGCFIR	 "01.089.175/0001-80"
	#Define	XINSCFIR  "401.50915-9"
	#Define	XCCIDA	 "ALTA FLORESTA DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78994-000/ALTA FLORESTA DO OESTE"
	#Define	XCCEP 	 "78994-000"
#ENDIF
#IFDEF RESICAL
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3641-2305"
	#Define	ENCRYPT	 "RESICAL COM DE MAT DE CONSTRUCOES LTDA"
	#Define	XFANTA	 "RESICAL"
	#Define	XENDEFIR  "AV RONDONIA, 4211 - CENTRO"
	#Define	XCGCFIR	 "07.469.912/0001-56"
	#Define	XINSCFIR  "0000000138345-1"
	#Define	XCCIDA	 "ALTA FLORESTA DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78994-000/ALTA FLORESTA DO OESTE"
	#Define	XCCEP 	 "78994-000"
#ENDIF

#IFDEF LEME
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-8675"
	#Define	ENCRYPT	 "LEME MOTOCENTER"
	#Define	XFANTA	 "LEME MOTOCENTER"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1030 - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "0000000000000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF PRADO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3652"
	#Define	ENCRYPT	  "L. R. DO PRADO - ME"
	#Define	XFANTA	 "FERRARIA PARANA"
	#Define	XENDEFIR  "RUA RUI BARBOSA, 301 - CENTRO"
	#Define	XCGCFIR	 "34.753.798/0001-64"
	#Define	XINSCFIR  "0000000023246-7"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MOTOGARRA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(16)3241-3113"
	#Define	ENCRYPT	 "MOTO GARRA COM DE VEICULOS LTDA"
	#Define	XFANTA	 "MOTO GARRA"
	#Define	XENDEFIR  "RUA NHONHO DO LIVRAMENTO, 1403 - CENTRO"
	#Define	XCGCFIR	 "03.649.063/0001-61"
	#Define	XINSCFIR  "461.089.751.116"
	#Define	XCCIDA	 "MONTE ALTO"
	#Define	XCESTA	 "SP"
	#Define	XCEPCIDA  "15910-000/MONTE ALTO"
	#Define	XCCEP 	 "15910-000"
	#Define	XEMAIL	 "MOTO_GARRA@NETSITE.COM.BR"
	#Define	GARRA_MOTORACA OK
#ENDIF
#IFDEF TRANSILVA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-2847"
	#Define	ENCRYPT	 "TRANSPORTADORA TRANSILVA LTDA"
	#Define	XFANTA	 "TRANSILVA"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 391 - CENTRO"
	#Define	XCGCFIR	 "03.693.432/0001-13"
	#Define	XINSCFIR  "0000000071683-9"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MEDSEGLABOR
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-1469"
	#Define	ENCRYPT	 "MED SEG LABOR ASS MED SEG TRAB COM EQ LT"
	#Define	XFANTA	 "MED SEG LABOR"
	#Define	XENDEFIR  "AV 02 DE JUNHO, 2099/SL 104 - CENTRO"
	#Define	XCGCFIR	 "02.503.455/0001-55"
	#Define	XINSCFIR  "0000000051427-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF NACIONAL
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-9044"
	#Define	ENCRYPT	 "NACIONAL COM DE ARTEFATOS DE BORRACHA LT"
	#Define	XFANTA	 "NACIONAL BORRACHA"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 19285 - CENTRO"
	#Define	XCGCFIR	 "05.690.331/0001-14"
	#Define	XINSCFIR  "0000000119127-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF MILLENIUM
	#Define	XPLACA	 OK
	#Define	XFONE 	 "(69)451-3038"
	#Define	ENCRYPT	 "BENITEZ E SANTANNA LTDA - MEE"
	#Define	XFANTA	 "AUTO ELETRICA MILLENIUM"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1451 - CENTRO"
	#Define	XCGCFIR	 "04.695.775/0001-80"
	#Define	XINSCFIR  "000000103240-2"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MATT
	#Define	XFONE 	 "(69)445-1084"
	#Define	ENCRYPT	 "CAFEEIRA & CEREALISTA SOARES LTDA"
	#Define	XFANTA	 "CEREALISTA MATT"
	#Define	XENDEFIR  "LINHA 45 - LOTE 104"
	#Define	XCGCFIR	 "04.554.245/0001-11"
	#Define	XINSCFIR  "ISENTO"
	#Define	XCCIDA	 "SAO FELIPE DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78986-000/SAO FELIPE DO OESTE"
	#Define	XCCEP 	 "78986-000"
#ENDIF
#IFDEF FAMA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(66)566-2267"
	#Define	ENCRYPT	 "SOZO & FORLIN LTDA"
	#Define	XFANTA	 "GRAFICA FAMA"
	#Define	XENDEFIR  "AV INT GOV JAIME V DE CAMPOS, 3908 - CENTRO"
	#Define	XCGCFIR	 "00.070.595/0001-51"
	#Define	XINSCFIR  "13.153.524-2"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
	#Define	XEMAIL	 "GRAFICAFAMA@JUINA-FOX.COM.BR"
#ENDIF
#IFDEF AUTOPECASTOKIO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(66)565-2002"
	#Define	ENCRYPT	 "M. MEIRA CARDOSO - ME - ARI"
	#Define	XFANTA	 "AUTO PECAS TOKIO"
	#Define	XENDEFIR  "RUA 21 DE ABRIL, 753 - CENTRO"
	#Define	XCGCFIR	 "03.392.794/0002-55"
	#Define	XINSCFIR  "13.263.708-1"
	#Define	XCCIDA	 "ARIPUANA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78325-000/ARIPUANA"
	#Define	XCCEP 	 "78325-000"
	#Define	XEMAIL	 "ANDRE@CENTAUROSISTEMAS.COM.BR"
#ENDIF
#IFDEF PAPELARIABRASIL
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(66)566-5325"
	#Define	ENCRYPT	 "ERIKA R. PAIAO DALE LUCHE - ME"
	#Define	XFANTA	 "PAPELARIA BRASIL"
	#Define	XENDEFIR  "AV NOVE DE MAIO, 232 - CENTRO"
	#Define	XCGCFIR	 "05.431.634/0001-12"
	#Define	XINSCFIR  "13.213.178-1"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
	#Define	XEMAIL	 "ORLI@JUINA-FOX.COM.BR"
#ENDIF
#IFDEF MECANICA4RAMOS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(66)566-2170"
	#Define	ENCRYPT	 "MECANICA 4 RAMOS LTDA"
	#Define	XFANTA	 "AUTO ELETRICA 4 RAMOS"
	#Define	XENDEFIR  "AV INT GOV JAIME V DE CAMPOS, 2333 - CENTRO"
	#Define	XCGCFIR	 "00.884.353/0001-00"
	#Define	XINSCFIR  "13.025.089-9"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF TOKIO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(66)566-2200"
	#Define	ENCRYPT	 "M. MEIRA CARDOSO - ME - JUI"
	#Define	XFANTA	 "AUTO PECAS TOKIO"
	#Define	XENDEFIR  "AV INT GOV JAIME V DE CAMPOS, 3002 - CENTRO"
	#Define	XCGCFIR	 "03.392.794/0001-74"
	#Define	XINSCFIR  "13.190.193-1"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
	#Define	XEMAIL	 "TOKIO@JUINA-FOX.COM.BR"
#ENDIF
#IFDEF VSVIDROS
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-2248"
	#Define	ENCRYPT	 "VS COMERCIO DE VIDROS LTDA"
	#Define	XFANTA	 "VS VIDROS"
	#Define	XENDEFIR  "RUA SANTOS DUMONT, 46 - CENTRO"
	#Define	XCGCFIR	 "06.121.391/0001-89"
	#Define	XINSCFIR  "0000000000000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF RODRIGOMOTOS
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)322-2755"
	#Define	ENCRYPT	 "R. M. COM PECAS ACES MANUT P/ MOTOS LTDA"
	#Define	XFANTA	 "RODRIGO MOTOS"
	#Define	XENDEFIR  "RUA PRINCESA ISABEL, 52-A - CENTRO"
	#Define	XCGCFIR	 "06.218.315/0001-96"
	#Define	XINSCFIR  "0000000127665-4"
	#Define	XCCIDA	 "VILHENA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78995-000/VILHENA"
	#Define	XCCEP 	 "78995-000"
#ENDIF
#IFDEF TENDTUDO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3322-1510"
	#Define	ENCRYPT	 "TEND TUDO ACESS E EST P/ CAMINHOES LTDA"
	#Define	XFANTA	 "TEND TUDO"
	#Define	XENDEFIR  "AV CELSO MAZUTTI, 2443 - BODANESE"
	#Define	XCGCFIR	 "02.221.741/0001-28"
	#Define	XINSCFIR  "0000000050865-9"
	#Define	XCCIDA	 "VILHENA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78995-000/VILHENA"
	#Define	XCCEP 	 "78995-000"
#ENDIF
#IFDEF ZEROHORA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-8407"
	#Define	ENCRYPT	 "QUANZ & CORREA LTDA"
	#Define	XFANTA	 "AUTO POSTO ZEROHORA"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 644 - CENTRO"
	#Define	XCGCFIR	 "05.623.221/0001-30"
	#Define	XINSCFIR  "0000000118864-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF LAWFOUR
	#Define	SCP		 OK
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-8001"
	#Define	ENCRYPT	 "LAW FOUR IND E COM DE CONFECCOES LTDA"
	#Define	XFANTA	 "LAW FOUR"
	#Define	XENDEFIR  "AV IMIGRANTES, 2835 - INDUSTRIAL"
	#Define	XCGCFIR	 "00.000.000/0000-00"
	#Define	XINSCFIR  "0000000000000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF VIARTEX
	#Define	SCP		 OK
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-0000"
	#Define	ENCRYPT	 "VIARTEX INDUSTRIA DE CONFECCOES LTDA"
	#Define	XFANTA	 "INDUSTRIA VIARTEX"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 693 - PIONEIROS"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF LOOK
	#Define	SCP		 OK
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-2370"
	#Define	ENCRYPT	 "INDUSTRIA DE CONFECCOES LOOK LTDA"
	#Define	XFANTA	 "CONFECCOES LOOK"
	#Define	XENDEFIR  "AV DOS IMIGRANTES, 985  - VILA NOVA"
	#Define	XCGCFIR	 "06.171.864/0001-52"
	#Define	XINSCFIR  "0000000137026-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF AGRONORTE
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)3451-8518"
	#Define	ENCRYPT	 "GAMA & ZEN LTDA - ME"
	#Define	XFANTA	 "AGRO NORTE"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1502 - BEIRA RIO"
	#Define	XCGCFIR	 "07.421.248/0001-75"
	#Define	XINSCFIR  "0000000138510-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF AIBARAPVH
	#UNDEF	MULTI
	#Define	XPLACA	 OK
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3223-3133"
	#Define	ENCRYPT	 "R. S. AIBARA & CIA LTDA"
	#Define	XFANTA	 "ELETRO AIBARA"
	#Define	XENDEFIR  "AV NACOES UNIDAS, 1000 - N. S. GRACAS"
	#Define	XCGCFIR	 "07.608.952/0001-31"
	#Define	XINSCFIR  "0000000141063-6"
	#Define	XCCIDA	 "PORTO VELHO"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78915-040/PORTO VELHO"
	#Define	XCCEP 	 "78915-040"
#ENDIF
#IFDEF CASADOAGROPECUARIO
	#Define	XFONE 	 "(69)3446-1207"
	#Define	ENCRYPT	 "F. R. DE LIMA & CIA LTDA - ME"
	#Define	XFANTA	 "CASA DO AGROPECUARIO"
	#Define	XENDEFIR  "AV EFRAIN G. DE BARROS, 3762 - CENTRO"
	#Define	XCGCFIR	 "07.801.331/0001-70"
	#Define	XINSCFIR  "000000014967-1"
	#Define	XCCIDA	 "PRIMAVERA DE RONDONIA"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PRIMAVERA DE RONDONIA"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF LOJABRASILEIRA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-3821"
	#Define	ENCRYPT	 "M. V. DE A. BERTAN & CIA LTDA"
	#Define	XFANTA	 "LOJA BRASILEIRA"
	#Define	XENDEFIR  "AV CUNHA BUENO, 398 - CENTRO"
	#Define	XCGCFIR	 "04.794.616/0001-32"
	#Define	XINSCFIR  "00000003736-2"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF AIBARA
	#UNDEF	MULTI
	#Define	XPLACA	 OK
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3441-5341"
	#Define	ENCRYPT	 "AIBARA & FUJISAWA LTDA"
	#Define	XFANTA	 "ELETRO AIBARA"
	#Define	XENDEFIR  "RUA SAO LUIZ, 1528 - CENTRO"
	#Define	XCGCFIR	 "84.572.650/0001-00"
	#Define	XINSCFIR  "0000000031240-1"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF AGATA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)9238-8931"
	#Define	ENCRYPT	 "AGATA DIST DE CONFECCOES E ACESS LTDA"
	#Define	XFANTA	 "DISTRIBUIDORA AGATA"
	#Define	XENDEFIR  "AV GUAPORE, 2470 - CENTRO"
	#Define	XCGCFIR	 "10.226.186/0001-55"
	#Define	XINSCFIR  "0000000173357-5"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF TIGRAO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3443-6779"
	#Define	ENCRYPT	 "TIGRAO COM DE PECAS P/ MOTOCICLETAS LTDA - ME"
	#Define	XFANTA	 "TIGRAO MOTOS"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 18953 - LIBERDADE"
	#Define	XCGCFIR	 "07.881.184/0001-95"
	#Define	XINSCFIR  "0000000146206-7"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF MOYSES
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-2792"
	#Define	ENCRYPT	 "MOYSES MEDICAMENTOS LTDA"
	#Define	XFANTA	 "FARMACIA DO MOYSES"
	#Define	XENDEFIR  "RUA CASSIMIRO DE ABREU, 113 - CENTRO"
	#Define	XCGCFIR	 "63.778.211/0001-70"
	#Define	XINSCFIR  "0000000034699-3"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF FONSECA
	#Define	XFONE 	 "(69)3451-9435"
	#Define	ENCRYPT	 "SIDNEIA APARECIDA DA FONSECA - MEE"
	#Define	XFANTA	 "POSTO DE MOLAS FONSECA"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1357 - CENTRO"
	#Define	XCGCFIR	 "06.135.754/0001-35"
	#Define	XINSCFIR  "0000000129838-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF AUTOCAR
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3412-2620"
	#Define	ENCRYPT	 "AUTO PECAS AUTOCAR LTDA - ME"
	#Define	XFANTA	 "AUTO PECAS AUTOCAR"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 4783 - CENTRO"
	#Define	XCGCFIR	 "84.603.521/0001-23"
	#Define	XINSCFIR  "0000000031565-6"
	#Define	XCCIDA	 "ALVORADA DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78969-000/ALVORADA DO OESTE"
	#Define	XCCEP 	 "78969-000"
#ENDIF
#IFDEF CARIMBOS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)412-3374"
	#Define	ENCRYPT	 "CARIMBOS MILLENIUM LTDA"
	#Define	XFANTA	 "CARIMBOS MILLENIUM"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 4984 - CENTRO"
	#Define	XCGCFIR	 "05.203.855/0001-33"
	#Define	XINSCFIR  "0000000112737-3"
	#Define	XCCIDA	 "ALVORADA DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78959-000/ALVORADA DO OESTE"
	#Define	XCCEP 	 "78959-000"
#ENDIF
#IFDEF OPCAOMODAS
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)412-3374"
	#Define	ENCRYPT	 "A. L. M. COM DE ART DO VESTUARIO LTDA-ME"
	#Define	XFANTA	 "OPCAO MODAS"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 5105 - CENTRO"
	#Define	XCGCFIR	 "06.814.320/0001-61"
	#Define	XINSCFIR  "0000000129886-1"
	#Define	XCCIDA	 "ALVORADA DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78959-000/ALVORADA DO OESTE"
	#Define	XCCEP 	 "78959-000"
#ENDIF
#IFDEF PILAR
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3424-6686"
	#Define	ENCRYPT	 "S. O. COM DE MAT P/ CONSTRUCAO LTDA"
	#Define	XFANTA	 "PILAR MAT P/ CONSTRUCAO"
	#Define	XENDEFIR  "AV GOV JORGE TEIXEIRA, 1953 - NOVA BRASILIA"
	#Define	XCGCFIR	 "04.234.729/0001-83"
	#Define	XINSCFIR  "0000000097599-1"
	#Define	XCCIDA	 "JI PARANA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78960-000/JI PARANA"
	#Define	XCCEP 	 "78960-000"
	#Define	XEMAIL	 "SOCONST@SYBERNET.COM.BR"
#ENDIF
#IFDEF ANMELY
	#Undef	FANTACODEBAR
	#Undef	CODEBAR
	#Define	FANTACODEBAR  "DIORON"
	#Define	EMPRECODEBAR  "23"
	#Define	CODEBAR		  OK
	#Define	SCP
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-2789"
	#Define	ENCRYPT	 "ANMELY IND E COM DE CONFECCOES LTDA"
	#Define	XFANTA	 "ANMELY IND E COM DE CONFECCOES LTDA"
	#Define	XENDEFIR  "AV. JUSCELINO KUBITSCHECK, 170 - CENTRO"
	#Define	XCGCFIR	 "01.223.914/0001-84"
	#Define	XINSCFIR  "0000000052075-6"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MARLENE
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)481-2095"
	#Define	ENCRYPT	 "MARLENE DE CENA FERNANDES PAULOSSI - ME"
	#Define	XFANTA	 "MARLENE CONFECCOES"
	#Define	XENDEFIR  "RUA PARANA, 2738 - CENTRO"
	#Define	XCGCFIR	 "01.936.935/0001-47"
	#Define	XINSCFIR  "0000000051711-9"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF SMCOM
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)642-2208"
	#Define	ENCRYPT	 "S. M. COM DE BEBIDAS E GENEROS ALIM LTDA "
	#Define	XFANTA	 "PLANALTO COMERCIO DE BEBIDAS"
	#Define	XENDEFIR  "ROD BR. 429 - KM 120 - ZONA RURAL"
	#Define	XCGCFIR	 "02.881.863/0001-40"
	#Define	XINSCFIR  "0000000055941-5"
	#Define	XCCIDA	 "SAO MIGUEL DO GUAPORE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78970-000/CACOAL"
	#Define	XCCEP 	 "78970-000"
	#Define	XEMAIL	 "CRISMACIEL@INTERMEDI.COM.BR"
#ENDIF
#IFDEF ROZIRAN
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)481-2946"
	#Define	ENCRYPT	 "ROZIRAN COM DE MAT P/ CONSTRUCOES LTDA"
	#Define	XFANTA	 "CHICO MATERIAIS P/ CONSTRUCOES"
	#Define	XENDEFIR  "AV SETE SETEMBRO, 1829 - CENTRO"
	#Define	XCGCFIR	 "01.018.451/0001-19"
	#Define	XINSCFIR  "0000000041087-0"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF ROVER
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)321-2628"
	#Define	ENCRYPT	 "ROVER INDUSTRIAL E COMERCIAL LTDA"
	#Define	XFANTA	 "ROVER"
	#Define	XENDEFIR  "AV SABINO B. DE QUEIROZ, 6076 - JARDIM ELDORADO"
	#Define	XCGCFIR	 "04.915.823/0001-06"
	#Define	XINSCFIR  "0000000004602-7"
	#Define	XCCIDA	 "VILHENA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78995-000/VILHENA"
	#Define	XCCEP 	 "78995-000"
	#Define	XEMAIL	 "ROVERCOM@VSP.COM.BR"
#ENDIF
#IFDEF ELETROAIBARA
	#UNDEF	MULTI
	#Define	XPLACA	 OK
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-5341"
	#Define	ENCRYPT	 "AIBARA COMERCIO DE PECAS LTDA"
	#Define	XFANTA	 "ELETRO AIBARA"
	#Define	XENDEFIR  "AV TRANSCONTINENTAL, 614 - VILA JOTAO"
	#Define	XCGCFIR	 "05.128.205/0001-70"
	#Define	XINSCFIR  "110640-6"
	#Define	XCCIDA	 "JI PARANA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78961-410/JI PARANA"
	#Define	XCCEP 	 "78961-410"
#ENDIF
#IFDEF _CONSTRUCENTER
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-1420"
	#Define	ENCRYPT	 "COM DE MAT P/ CONST CONSTRUCENTER LTDA"
	#Define	XFANTA	 "CONSTRUCENTER"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 1399 - CENTRO"
	#Define	XCGCFIR	 "01.173.875/0001-58"
	#Define	XINSCFIR  "0000000051145-5"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF ROSSI
	#Define	XFONE 	 "(69)441-6669"
	#Define	ENCRYPT	 "RICARDO ROSSI COMERCIO"
	#Define	XFANTA	 "ROSSI MOTOPECAS"
	#Define	XENDEFIR  "RUA ALCINDA R. DE SOUZA, 393-B  - CENTRO"
	#Define	XCGCFIR	 "03.313.570/0001-20"
	#Define	XINSCFIR  "0000000090855-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CAMPONOVO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)239-2109"
	#Define	ENCRYPT	 "AUTO POSTO CAMPO NOVO LTDA"
	#Define	XFANTA	 "AUTO POSTO CAMPO NOVO"
	#Define	XENDEFIR  "ROD BR 421 - KM 105 - ST INDL"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "CAMPO DE RONDONIA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78967-000/CAMPO DE RONDONIA"
	#Define	XCCEP 	 "78967-000"
#ENDIF
#IFDEF BURITIS
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)238-2151"
	#Define	ENCRYPT	 "AUTO POSTO BURITIS LTDA"
	#Define	XFANTA	 "AUTO POSTO BURITIS"
	#Define	XENDEFIR  "AV AYRTON SENNA, SN - ST INDL"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "BURITIS"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/BURITIS"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF CASAMAQUINAS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)3441-0029"
	#Define	ENCRYPT	 "F. S. COM DE MAQUINAS DE COSTURAS LTDA"
	#Define	XFANTA	 "CASA DAS MAQUINAS"
	#Define	XENDEFIR  "RUA ANTONIO DE P. NUNES, 1026 - CENTRO"
	#Define	XCGCFIR	 "07.266.983/0001-51"
	#Define	XINSCFIR  "134619-9"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF PIRAMIDE
	#UNDEF	MULTI
	#Define	GRUPO_COCICAL OK
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-4315"
	#Define	ENCRYPT	 "BUSSOLA COM DE MAT P/ CONSTRUCAO LTDA"
	#Define	XFANTA	 "PIRAMIDE MAT P/ CONSTRUCAO"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 2701 - CENTRO"
	#Define	XCGCFIR	 "84.654.102/0001-10"
	#Define	XINSCFIR  "403.37433-4"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
	#Define	XEMAIL	 "PIRAMIDE@NETTRAVEL.COM.BR"
#ENDIF
#IFDEF MOTOGARRACWL
	#Define	ANO2000	 OK
	#Define	XRAMO 	 "PECAS E SERVICOS"
	#Define	XFONE 	 "(69)3441-6367"
	#Define	ENCRYPT	 "E. R. DA CUNHA PEC E ACESS P/ MOTOS - ME"
	#Define	XFANTA	 "MOTO GARRA"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 19590 - CENTRO"
	#Define	XCGCFIR	 "07.462.452/0001-34"
	#Define	XINSCFIR  "0000000137858-9"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF SPEEDMOTOS
	#Define	ANO2000	 OK
	#Define	XRAMO 	 "PECAS E SERVICOS"
	#Define	XFONE 	 "(69)3443-1908"
	#Define	ENCRYPT	 "L.F.SPEED COM PECAS P/ MOTOS LTDA"
	#Define	XFANTA	 "SPEED MOTOS"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 19033 - CENTRO"
	#Define	XCGCFIR	 "07.606.645/0001-11"
	#Define	XINSCFIR  "0000000140463-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF MOTORACAPBW
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XRAMO 	 "PECAS E SERVICOS"
	#Define	XFONE 	 "(69)3451-0000"
	#Define	ENCRYPT	 "LB COMERCIO DE MOTOS LTDA ME"
	#Define	XFANTA	 "MOTORACA"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1114 - CENTRO"
	#Define	XCGCFIR	 "08.303.518/0001-06"
	#Define	XINSCFIR  "0000000156762-4"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
	#Define	XEMAIL	 "MOTORACA@SYBERNET.COM.BR"
	#Define	GARRA_MOTORACA OK
#ENDIF
#IFDEF MOTORACA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XRAMO 	 "PECAS E SERVICOS"
	#Define	XFONE 	 "(69)3441-0828"
	#Define	ENCRYPT	 "RACA COMERCIO DE MOTOS LTDA"
	#Define	XFANTA	 "MOTO RACA"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 18645 - LIBERDADE"
	#Define	XCGCFIR	 "06.695.619/0001-44"
	#Define	XINSCFIR  "0000000136227-5"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
	#Define	XEMAIL	 "MOTORACA@SYBERNET.COM.BR"
	#Define	GARRA_MOTORACA OK
#ENDIF
#IFDEF RONDOMOTO
	#Define	ANO2000	 OK
	#Define	XRAMO 	 "PECAS E SERVICOS"
	#Define	XFONE 	 "(69)481-2423"
	#Define	ENCRYPT	 "A. J. VIANA & CIA LTDA"
	#Define	XFANTA	 "RONDOMOTO"
	#Define	XENDEFIR  "AV 07 DE SETEMBRO, 2972 - CENTRO"
	#Define	XCGCFIR	 "03.204.763/0001-42"
	#Define	XINSCFIR  "0000000051784-4"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF NOELMOTOS
	#Define	ANO2000	 OK
	#Define	XRAMO 	 "PECAS E SERVICOS"
	#Define	XFONE 	 "(69)481-2235"
	#Define	ENCRYPT	 "N. O. DO NASCIMENTO & CIA LTDA - ME"
	#Define	XFANTA	 "NOEL MOTOS"
	#Define	XENDEFIR  "RUA SAO PAULO, 2528 SALA C - CENTRO"
	#Define	XCGCFIR	 "04.518.733/0001-73"
	#Define	XINSCFIR  "0000000086922-8"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF AGUIA_CDO
	#Define	ANO2000	 OK
	#Define	XRAMO 	 "PECAS E SERVICOS"
	#Define	XFONE 	 "(69)341-3328"
	#Define	ENCRYPT	 "AGUIA MOTOS LTDA - ME"
	#Define	XFANTA	 "AGUIA MOTOS"
	#Define	XENDEFIR  "RUA POTIGUARA, 3260 - CENTRO"
	#Define	XCGCFIR	 "04.439.781/0001-76"
	#Define	XINSCFIR  "00000000102342-0"
	#Define	XCCIDA	 "COLORADO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78996-000/COLORADO DO OESTE"
	#Define	XCCEP 	 "78996-000"
#ENDIF
#IFDEF PRESTES
	#Define	ANO2000	 OK
	#Define	XRAMO 	 "DISTRIBUIDORA DE BEBIDAS"
	#Define	XFONE 	 "(69)341-2044"
	#Define	ENCRYPT	 "PRESTES & CIA LTDA"
	#Define	XFANTA	 "DISTRIBUIDORA DE BEBIDAS MULTIMARCAS"
	#Define	XENDEFIR  "AV RIO NEGRO, 4125 - CENTRO"
	#Define	XCGCFIR	 "04.019.846/0001-24"
	#Define	XINSCFIR  "0000000087742-5"
	#Define	XCCIDA	 "COLORADO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78996-000/COLORADO DO OESTE"
	#Define	XCCEP 	 "78996-000"
#ENDIF
#IFDEF KOTINHA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)481-3302"
	#Define	ENCRYPT	 "ANA RUTH QUEIROZ FIGUEIREDO"
	#Define	XFANTA	 "KOTINHA MODAS"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 2346 - CENTRO"
	#Define	XCGCFIR	 "63.627.202/0001-88"
	#Define	XINSCFIR  "0000000029749-6"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF MORENA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)481-2103"
	#Define	ENCRYPT	 "SANDRA DE Q. F. DALMOLIM - ME"
	#Define	XFANTA	 "MORENA COSMETICOS"
	#Define	XENDEFIR  "AV SETE DE SETEMBRO, 2103 - CENTRO"
	#Define	XCGCFIR	 "84.754.159/0001-91"
	#Define	XINSCFIR  "405.37596-5"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF BEMAC
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)481-1472"
	#Define	ENCRYPT	 "WANTUIL BRAUN & CIA LTDA - ME"
	#Define	XFANTA	 "BEMAC MATERIAS P/ CONSTRUCAO"
	#Define	XENDEFIR  "RUA SAO PAULO, 2559 - CENTRO"
	#Define	XCGCFIR	 "02.801.291/0001-42"
	#Define	XINSCFIR  "0000000018488-1"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF GPMOTOS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3481-1447"
	#Define	ENCRYPT	 "PAULO JUNIOR BARRETTO & CIA LTDA - ME"
	#Define	XFANTA	 "GP MOTOS"
	#Define	XENDEFIR  "AV AMAZONAS, 2413 - CENTRO"
	#Define	XCGCFIR	 "08.008.239/0001-10"
	#Define	XINSCFIR  "0000000148225-4"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF EUDACK
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3481-2240"
	#Define	ENCRYPT	 "EUDACK JOSE COLOMBI MOTOCICLETAS"
	#Define	XFANTA	 "CANOPUS MOTOS"
	#Define	XENDEFIR  "RUA SAO PAULO, 2679 - CENTRO"
	#Define	XCGCFIR	 "63.780.589/0001-08"
	#Define	XINSCFIR  "00000000029791-7"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF ROMANA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-2631"
	#Define	ENCRYPT	 "CERAMICA ROMANA LTDA"
	#Define	XFANTA	 "CERAMICA ROMANA"
	#Define	XENDEFIR  "RUA 04 QD 09 LT 01 - ST INDUSTRIAL"
	#Define	XCGCFIR	 "08.746.986/0001-55"
	#Define	XINSCFIR  "90863-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF GPMOTOS1
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-0000"
	#Define	ENCRYPT	 "A. C. MONDARDO MOTOS ME"
	#Define	XFANTA	 "GP MOTOS"
	#Define	XENDEFIR  "AV ALCINDA R. DE SOUZA, 30 - CENTRO"
	#Define	XCGCFIR	 "08.746.986/0001-55"
	#Define	XINSCFIR  "0000000165587-6"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CORMATELE
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)481-2460"
	#Define	ENCRYPT	 "CORMATELE COM REP DE MAT ELETRICOS LTDA"
	#Define	XFANTA	 "CORMATELE"
	#Define	XENDEFIR  "RUA SURUI, 2653 - CENTRO"
	#Define	XCGCFIR	 "63.791.438/0001-55"
	#Define	XINSCFIR  "0000000029807-7"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF DIMATEL
	#UNDEF	MULTI
	#Define	ANO2000	 OK
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)481-3190"
	#Define	ENCRYPT	 "DIMATEL DIST. DE MAT. ELETRICOS LTDA"
	#Define	XFANTA	 "DIMATEL DIST. DE MAT. ELETRICOS"
	#Define	XENDEFIR  "RUA SAO PAULO, 2567 - CENTRO"
	#Define	XCGCFIR	 "02.924.954/0001-16"
	#Define	XINSCFIR  "0000000051770-4"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF IMPERIAL
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)481-1905"
	#Define	ENCRYPT	 "IMPERIAL COMERCIO DE FERRAGENS LTDA"
	#Define	XFANTA	 "REI DOS PARAFUSOS"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 2772 - CENTRO"
	#Define	XCGCFIR	 "04.307.643/0001-33"
	#Define	XINSCFIR  "0000000085678-9"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF ALIANCA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)481-3316"
	#Define	ENCRYPT	 "AUTO ELETRICA WELLINGTON & WESLEY LTDA"
	#Define	XFANTA	 "AUTO ELETRICA ALIANCA"
	#Define	XENDEFIR  "RUA PIAUI, 2805 - CENTRO"
	#Define	XCGCFIR	 "04.739.152/0001-61"
	#Define	XINSCFIR  "0000000086931-7"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF CRISTALDOCES
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-2083"
	#Define	ENCRYPT	 "DISTRIBUIDORA GAONA GUERREIRO LTDA"
	#Define	XFANTA	 "CRISTAL DOCES"
	#Define	XENDEFIR  "RUA PRES VENCESLAU, 2841 - ROSALINO"
	#Define	XCGCFIR	 "01.297.378/0001-61"
	#Define	XINSCFIR  "0000000051175-7"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF ARCOIRIS
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)441-7045"
	#Define	ENCRYPT	 "ADRIANA GOMES DE FARIA - ME"
	#Define	XFANTA	 "DISTRIBUIDORA DE DOCES ARCO IRIS"
	#Define	XENDEFIR  "AV SAO PAULO, 2880 - CENTRAL"
	#Define	XCGCFIR	 "02.122.316/0001-81"
	#Define	XINSCFIR  "0000000051371-7"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF BRDIESEL
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-0896"
	#Define	ENCRYPT	 "BR DIESEL BOMBA INJETORA - ME"
	#Define	XFANTA	 "BR DIESEL BOMBA INJETORA LTDA"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 18101 - CENTRO"
	#Define	XCGCFIR	 "03.680.854/0001-54"
	#Define	XINSCFIR  "0000000071655-3"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF SOCRAM
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-1613"
	#Define	ENCRYPT	 "SOCRAM COMERCIO DE CONFECCOES LTDA - ME"
	#Define	XFANTA	 "SOCRAM CONFECCOES"
	#Define	XENDEFIR  "AV SERGIPE, 258 - NOVO CACOAL"
	#Define	XCGCFIR	 "00.544.134/0001-73"
	#Define	XINSCFIR  "0000000038499-8"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-125/CACOAL"
	#Define	XCCEP 	 "78975-125"
#ENDIF
#IFDEF CASADOCAMPO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-6116"
	#Define	ENCRYPT	 "CASA DO CAMPO LTDA - ME"
	#Define	XFANTA	 "CASA DO CAMPO"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 18791 - CENTRO"
	#Define	XCGCFIR	 "04.565.234/0001-37"
	#Define	XINSCFIR  "0000000036143-0"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF ROMA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)471-2595"
	#Define	ENCRYPT	 "ROMA MATERIAS P/ CONSTRUCAO LTDA"
	#Define	XFANTA	 "ROMA MATERIAIS P/ CONSTRUCAO"
	#Define	XENDEFIR  "AV 30 DE JUNHO, 1693 - CENTRO"
	#Define	XCGCFIR	 "63.614.176/0001-53"
	#Define	XINSCFIR  "211.31614-8"
	#Define	XCCIDA	 "PRESIDENTE MEDICE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78968-000/PRESIDENTE MEDICE"
	#Define	XCCEP 	 "78968-000"
#ENDIF
#IFDEF AGROPAMPA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)471-2386"
	#Define	ENCRYPT	 "AGRO PAMPA COM AGR E VETERINARIA LTDA"
	#Define	XFANTA	 "AGRO PAMPA"
	#Define	XENDEFIR  "RUA DA PAZ, 1104 - SALA C - CENTRO"
	#Define	XCGCFIR	 "02.254.677/0001-81"
	#Define	XINSCFIR  "211.54350-1"
	#Define	XCCIDA	 "PRESIDENTE MEDICE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78968-000/PRESIDENTE MEDICE"
	#Define	XCCEP 	 "78968-000"
#ENDIF
#IFDEF RONDOSOM
	#Define	XFONE 	 "(069)441-5386"
	#Define	ENCRYPT	 "LUCIMAR MARINO FERREIRA & CIA LTDA"
	#Define	XFANTA	 "RONDOSOM"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 319 - CENTRO"
	#Define	XCGCFIR	 "01.231.610/0001-69"
	#Define	XINSCFIR  "403.51166-8"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF MINICICLO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(68)226-3846"
	#Define	ENCRYPT	 "M. S. SILVA DE OLIVEIRA"
	#Define	XFANTA	 "MINI CICLO"
	#Define	XENDEFIR  "AV NACOES UNIDAS, 2903 - EST EXP"
	#Define	XCGCFIR	 "04.691.964/0001-84"
	#Define	XINSCFIR  "01.012.700/001-99"
	#Define	XCCIDA	 "RIO BRANCO"
	#Define	XCESTA	 "AC"
	#Define	XCEPCIDA  "69912-600/RIO BRANCO"
	#Define	XCCEP 	 "69912-600"
#ENDIF
#IFDEF SOBRECIL
	#Define	XFONE 	 "(68)3226-3344"
	#Define	ENCRYPT	 "SOBRECIL CONSTRUCAO COM REPRES LTDA"
	#Define	XFANTA	 "SOBRECIL"
	#Define	XENDEFIR  "RUA RIO DE JANEIRO, 1518 - FLORESTA"
	#Define	XCGCFIR	 "06.229.580/0001-70"
	#Define	XINSCFIR  "01.015.794/001-01"
	#Define	XCCIDA	 "RIO BRANCO"
	#Define	XCESTA	 "AC"
	#Define	XCEPCIDA  "69906-380/RIO BRANCO"
	#Define	XCCEP 	 "69906-380"
#ENDIF
#IFDEF PALACIO
	#Define	XFONE 	 "(68)223-1380"
	#Define	ENCRYPT	 "GERALDO CARDOSO DA SILVA - ME"
	#Define	XFANTA	 "PALACIO DOS PARAFUSOS"
	#Define	XENDEFIR  "RUA QUINTINO BOCAIUVA, 20-C - JOSE AUGUSTO"
	#Define	XCGCFIR	 "01.475.251/0001-95"
	#Define	XINSCFIR  "0140.9018-0"
	#Define	XCCIDA	 "RIO BRANCO"
	#Define	XCESTA	 "AC"
	#Define	XCEPCIDA  "69909-400/RIO BRANCO"
	#Define	XCCEP 	 "69909-400"
#ENDIF
#IFDEF CEMIL
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(68)3221-8558"
	#Define	ENCRYPT	 "CEMIL METALURGICA LTDA"
	#Define	XFANTA	 "CEMIL"
	#Define	XENDEFIR  "BR 364 KM 04 SAIDA P.VELHO - P. INDL"
	#Define	XCGCFIR	 "00.423.871/0001-84"
	#Define	XINSCFIR  "01.009.624/001-37"
	#Define	XCCIDA	 "RIO BRANCO"
	#Define	XCESTA	 "AC"
	#Define	XCEPCIDA  "69909-400/RIO BRANCO"
	#Define	XCCEP 	 "69909-400"
#ENDIF
#IFDEF LUBRIFILTROS
	#Define	XFONE 	 "(069)441-3390"
	#Define	ENCRYPT	 "F. A. COM DE FILTROS E LUBR LTDA"
	#Define	XFANTA	 "LUBRIFILTROS"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 1240 - CENTRO"
	#Define	XCGCFIR	 "01.754.410/0001-90"
	#Define	XINSCFIR  "403.51246-0"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF INDAL
	#Define	XFONE 	 "(069)451-3645"
	#Define	ENCRYPT	 "INDAL INDL MADEIREIRA ALTOE LTDA"
	#Define	XFANTA	 "MADEIREIRA ALTOE"
	#Define	XENDEFIR  "BR 364 - KM 195"
	#Define	XCGCFIR	 "04.774.600/0001-68"
	#Define	XINSCFIR  "407.014788-8"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF COMVEN
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-2971"
	#Define	ENCRYPT	 "MERCANTIL COM-VEN LTDA"
	#Define	XFANTA	 "M. COM-VEN LTDA"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1494 - CENTRO"
	#Define	XCGCFIR	 "04.794.756/0001-00"
	#Define	XINSCFIR  "407.03776-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MIYABARA
	#UNDEF	MULTI
	#Define	XPLACA	 OK
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3625"
	#Define	ENCRYPT	 "MIYABARA PECAS E ACESSORIOS LTDA"
	#Define	XFANTA	 "AUTO ELETRICA MYABARA"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1307 - CENTRO"
	#Define	XCGCFIR	 "63.766.604/0001-63"
	#Define	XINSCFIR  "0000000034686-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF SOBREIRA
	#Define	XFONE 	 "(069)412-2590" // OZIEL
	#Define	ENCRYPT	 "J. SOBREIRA DE OLIVEIRA - ME"
	#Define	XFANTA	 "SOBREIRA MOVEIS"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 5322 - CENTRO"
	#Define	XCGCFIR	 "34.453.696/0001-23"
	#Define	XINSCFIR  "201.20873-4"
	#Define	XCCIDA	 "ALVORADA D'OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78900-000/CACOAL"
	#Define	XCCEP 	 "78900-000"
#ENDIF
#IFDEF GAROTINHO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)000-0000"
	#Define	ENCRYPT	 "R. C. CABRAL - ME"
	#Define	XFANTA	 "MERCADO GAROTINHO"
	#Define	XENDEFIR  "AV BENEDITO LAURINDO GONCALVES, 474 - CENTRO"
	#Define	XCGCFIR	 "03.990.812/0001-10"
	#Define	XINSCFIR  "0000000080308-1"
	#Define	XCCIDA	 "PARECIS"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78989-000/PARECIS"
	#Define	XCCEP 	 "78989-000"
#ENDIF
#IFDEF DOURADOS
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(699)961-1495"
	#Define	ENCRYPT	 "D. B. DE MATOS - ME"
	#Define	XFANTA	 "MERCADO DOURADOS"
	#Define	XENDEFIR  "AV GETULIO VARGAS, 3555 - CENTRO"
	#Define	XCGCFIR	 "03.335.027/0001-23"
	#Define	XINSCFIR  "0000000051127-7"
	#Define	XCCIDA	 "ALTO ALEGRE DOS PARECIS"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78994-800/ALTO ALEGRE DOS PARECIS"
	#Define	XCCEP 	 "78994-800"
#ENDIF
#IFDEF CRISTAL
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)451-2033"
	#Define	ENCRYPT	 "JOSE BATISTA DOS SANTOS - ME"
	#Define	XFANTA	 "SUPERMERCADO CRISTAL"
	#Define	XENDEFIR  "AV DOS IMIGRANTES, 1246 - CTG"
	#Define	XCGCFIR	 "34.473.496/0001-32"
	#Define	XINSCFIR  "0000000023153-3"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF OXI
	#Define	XFONE 	 "(069)451-0000"
	#Define	ENCRYPT	 "AMAZON-OXI AMAZONIA OXIGENIO LTDA"
	#Define	XFANTA	 "AMAZON-OXI"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1562 - CENTRO"
	#Define	XCGCFIR	 "01.256.801/0001-85"
	#Define	XINSCFIR  "400.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CAMBE
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)451-2695"
	#Define	ENCRYPT	 "VALENTINA FAVALESSA - ME"
	#Define	XFANTA	 "POSTO DE MOLAS CAMBE"
	#Define	XENDEFIR  "ROD BR 364 - KM 504 - CENTRO"
	#Define	XCGCFIR	 "01.804.497/0001-63"
	#Define	XINSCFIR  "0000000052174-4"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF JAMANTAO
	#Define	XFONE 	 "(69)451-8619"
	#Define	ENCRYPT	 "POSTO DE MOLAS JAMANTAO LTDA - ME"
	#Define	XFANTA	 "POSTO DE MOLAS JAMANTAO"
	#Define	XENDEFIR  "ROD BR 364 - KM 200 - BELA VISTA"
	#Define	XCGCFIR	 "06.131.904/0001-32"
	#Define	XINSCFIR  "0000000129142-4"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF RETIMAR
	#Define	XFONE 	 "(69)451-2945"
	#Define	ENCRYPT	 "OSMAR DE OLIVEIRA RETIFICA LTDA"
	#Define	XFANTA	 "RETIMAR"
	#Define	XENDEFIR  "RUA RUI BARBOSA, 474 - CENTRO"
	#Define	XCGCFIR	 "34.462.218/0001-80"
	#Define	XINSCFIR  "407.19823-4"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MOTOSERRAS
	#Define	XFONE 	 "(069)451-2933"
	#Define	ENCRYPT	 "COM DE MOTOSERRAS PIMENTA BUENO LTDA"
	#Define	XFANTA	 "COM DE MOTOSERRAS PIMENTA BUENO"
	#Define	XENDEFIR  "AV CUNHA BUENO, 260 - CENTRO"
	#Define	XCGCFIR	 "05.763.198/0001-89"
	#Define	XINSCFIR  "407.07122-6"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MICROSTAR
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(069)441-4233"
	#Define	ENCRYPT	 "MICRO STAR INFORMATICA LTDA"
	#Define	XFANTA	 "MICRO STAR INFORMATICA"
	#Define	XENDEFIR  "RUA GENEREL OSORIO, 1031 - CENTRO"
	#Define	XCGCFIR	 "00.968.821/0001-16"
	#Define	XINSCFIR  "403.39591-9"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF RONDOTUBOS
	#Define	XFONE 	 "(69)451-2915"
	#Define	ENCRYPT	 "RONDOTUBOS ARTEFATOS DE CIMENTO LTDA"
	#Define	XFANTA	 "RONDOTUBOS"
	#Define	XENDEFIR  "RUA SEBASTIAO SOARES MELO, 366 - ST INDL"
	#Define	XCGCFIR	 "02.941.892/0001-50"
	#Define	XINSCFIR  "0000000090798-7"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF VERONA										 // RENATO MARCOLIN
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(069)223-1317"
	#Define	ENCRYPT	 "TAPEJARA TINTAS LTDA"
	#Define	XFANTA	 "VERONA TINTAS"
	#Define	XENDEFIR  "AV AMAZONAS, 1629 - N SRA DAS GRACAS"
	#Define	XCGCFIR	 "01.108.521/0001-20"
	#Define	XINSCFIR  "101.57894-1"
	#Define	XCCIDA	 "PORTO VELHO"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78915-100/PORTO VELHO"
	#Define	XCCEP 	 "78915-100"
	#Define	XRAMO 	 "(069)223-1317"
#ENDIF
#IFDEF NUTRIFRITAS
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)212-1343"
	#Define	ENCRYPT	 "E. CAMELO POSSIDONE"
	#Define	XFANTA	 "NUTRIFRITAS"
	#Define	XENDEFIR  "RUA COLOMBIA, 4196 - EMBRATEL"
	#Define	XCGCFIR	 "04.138.334/0001-87"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PORTO VELHO"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78905-800/PORTO VELHO"
	#Define	XCCEP 	 "78905-800"
#ENDIF
#IFDEF MAXMOTORS
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)221-5753"
	#Define	ENCRYPT	 "MAX MOTORS COM E REPRESENTACOES LTDA"
	#Define	XFANTA	 "MAX MOTOR'S"
	#Define	XENDEFIR  "RUA ELIAS GORAYEB, 910 - N SRA DAS GRACAS"
	#Define	XCGCFIR	 "02.085.592/0001-31"
	#Define	XINSCFIR  "0000000059435-1"
	#Define	XCCIDA	 "PORTO VELHO"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78915-150/PORTO VELHO"
	#Define	XCCEP 	 "78915-150"
#ENDIF
#IFDEF SIDINEZ
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(69)221-5753"
	#Define	ENCRYPT	 "SIDINEZ FAVALESSA - ME"
	#Define	XFANTA	 "MOLAS E FREIOS CAMBE"
	#Define	XENDEFIR  "BR 364 - KM 6,5 - POSTO CATARINENSE"
	#Define	XCGCFIR	 "03.049.242/0001-68"
	#Define	XINSCFIR  "0000000092750-3"
	#Define	XCCIDA	 "PORTO VELHO"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78900-190/PORTO VELHO"
	#Define	XCCEP 	 "78900-190"
#ENDIF
#IFDEF MONJOLO
	#Define	XFONE 	 "(069)222-5729"
	#Define	ENCRYPT	 "MONJOLO MOVEIS LTDA"
	#Define	XFANTA	 "MONJOLO MOVEIS"
	#Define	XENDEFIR  "AV AMAZONAS, 3399 - N. PORTO VELHO"
	#Define	XCGCFIR	 "02.517.808/0001-76"
	#Define	XINSCFIR  "101.91245-0"
	#Define	XCCIDA	 "PORTO VELHO"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78910-000/PORTO VELHO"
	#Define	XCCEP 	 "78910-000"
#ENDIF
#IFDEF SUPORTE
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(069)442-2269"
	#Define	ENCRYPT	 "SUPORTE DISTRIBUIDORA DE BEBIDAS LTDA"
	#Define	XFANTA	 "SUPORTE"
	#Define	XENDEFIR  "AV NORTE SUL, 3537 - CENTRO"
	#Define	XCGCFIR	 "00.692.086/0001-60"
	#Define	XINSCFIR  "409.52346-1"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF CREMONESE
	#Define	XFONE 	 "(069)451-2185"
	#Define	ENCRYPT	 "AMILCAR CREMONESE"
	#Define	XFANTA	 "AMILCAR CREMONESE"
	#Define	XENDEFIR  "RUA JUAREZ TAVORA, 254 - CENTRO"
	#Define	XCGCFIR	 "176.920.839-91"
	#Define	XINSCFIR  "1.220.067"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF ALVORADENSE
	#Define	XFONE 	 "(067)456-1162" //ADEMIR OU SILVIA
	#Define	ENCRYPT	 "LABORATORIO ALVORADENSE"
	#Define	XFANTA	 "LABORATORIO ALVORADENSE"
	#Define	XENDEFIR  "RUA ANTONIA PAULINIA, 89 - CENTRO"
	#Define	XCGCFIR	 "00.531.367/0001-31"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "NOVA ALVORADA DO SUL"
	#Define	XCESTA	 "MS"
	#Define	XCEPCIDA  "00000-000/NOVA ALVORADA DO SUL"
	#Define	XCCEP 	 "00000-000"
#ENDIF
#IFDEF LAVOURA
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(065)566-1400"
	#Define	ENCRYPT	 "PAGNUSSAT COM PROD AGROVETERINARIOS LTDA"
	#Define	XFANTA	 "CASA DA LAVOURA"
	#Define	XENDEFIR  "AV 09 DE MAIO, SN - CENTRO"
	#Define	XCGCFIR	 "01.523.055/0001-49"
	#Define	XINSCFIR  "13.171561-5"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF HERMES
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK  // 08/02/99
	#Define	XFONE 	 "(65)566-1591"
	#Define	ENCRYPT	 "AGROPECUARIA HERMES'S LTDA"
	#Define	XFANTA	 "CAMPO E LAVOURA"
	#Define	XENDEFIR  "AV NOVE DE MAIO, SN - CENTRO"
	#Define	XCGCFIR	 "03.268.083/0001-92"
	#Define	XINSCFIR  "13.044.805-2"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF LILA
	#Define	XFONE 	 "(65)581-1352"
	#Define	ENCRYPT	 "AMAURI PERES - ME"
	#Define	XFANTA	 "LILA MOTOS"
	#Define	XENDEFIR  "AV 04 DE JULHO, SN - CENTRO"
	#Define	XCGCFIR	 "70.425.723/0001-18"
	#Define	XINSCFIR  "13.146.485-0"
	#Define	XCCIDA	 "CASTANHEIRA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78345-000/CASTANHEIRA"
	#Define	XCCEP 	 "78345-000"
#ENDIF
#IFDEF HERMES_CT
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)581-1232"
	#Define	ENCRYPT	 "AGROPECUARIA HERMES'S LTDA"
	#Define	XFANTA	 "CAMPO E LAVOURA"
	#Define	XENDEFIR  "AV JAIME CAMPOS, SN - CENTRO"
	#Define	XCGCFIR	 "03.268.083/0002-73"
	#Define	XINSCFIR  "13.047.991-8"
	#Define	XCCIDA	 "CASTANHEIRA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78345-000/CASTANHEIRA"
	#Define	XCCEP 	 "78345-000"
#ENDIF
#IFDEF BOASAFRA
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(65)566-1161"
	#Define	ENCRYPT	 "C.A.M. COM E REPRESENTA€OES LTDA"
	#Define	XFANTA	 "BOA SAFRA"
	#Define	XENDEFIR  "AV 9 DE MAIO, S/N - CENTRO"
	#Define	XCGCFIR	 "36.971.778/0001-95"
	#Define	XINSCFIR  "13.130.114-4"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF VIDEOSOM
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(069)441-5481"
	#Define	ENCRYPT	 "VIDEO SOM SHOP COM E IMP LTDA"
	#Define	XFANTA	 "VIDEO SOM"
	#Define	XENDEFIR  "AV 02 DE JUNHO, 2344 - CENTRO"
	#Define	XCGCFIR	 "84.712.082/0001-97"
	#Define	XINSCFIR  "403.39515-3"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF KARRETAO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)441-4405"
	#Define	ENCRYPT	 "POSTO DE MOLAS CACOAL LTDA"
	#Define	XFANTA	 "POSTO DE MOLAS KARRETAO"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 569 - CENTRO"
	#Define	XCGCFIR	 "63.785.406/0001-47"
	#Define	XINSCFIR  "403.31066-2"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF ITAPUA
	#Define	XFONE 	 "(069)441-4890" // DANILLO/DALTON
	#Define	ENCRYPT	 "ITAPUA COM ATAC DE BIJ E VARIEDADES LTDA"
	#Define	XFANTA	 "ATACADO ITAPUA"
	#Define	XENDEFIR  "AV SERGIPE, 471 - NOVO CACOAL"
	#Define	XCGCFIR	 "84.599.869/0001-94"
	#Define	XINSCFIR  "403.34476-1"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF DROGAMIL
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)441-2839"
	#Define	ENCRYPT	 "AMIZAEL A. DE SOUZA & CIA LTDA"
	#Define	XFANTA	 "FARMACIA DROGAREDE"
	#Define	XENDEFIR  "RUA DOS PIONEIROS, 2196 - CENTRO"
	#Define	XCGCFIR	 "84.752.484/0001-15"
	#Define	XINSCFIR  "0000000000557-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
	#Define	XRAMO 	 "MEDICAMENTOS E PERFUMARIAS"
#ENDIF
#IFDEF MODELO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	DROGAMIL  OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-3051"
	#Define	ENCRYPT	 "D. A. DE OLIVEIRA - ME"
	#Define	XFANTA	 "FARMACIA MODELO"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 2238 - CENTRO"
	#Define	XCGCFIR	 "04.914.297/0001-51"
	#Define	XINSCFIR  "0000000003899-5"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
	#Define	XRAMO 	 "MEDICAMENTOS E PERFUMARIAS"
#ENDIF
#IFDEF RONDONIA
	#Define	DROGAMIL  OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)443-5675"
	#Define	ENCRYPT	 "NEMIAS ANDRE DE SOUZA - ME"
	#Define	XFANTA	 "FARMACIA RONDONIA"
	#Define	XENDEFIR  "RUA ALMIRANTE BARROSO, 3456 - NOVO CACOAL"
	#Define	XCGCFIR	 "05.586.235/0001-20"
	#Define	XINSCFIR  "0000000006849-7"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
	#Define	XRAMO 	 "MEDICAMENTOS E PERFUMARIAS"
#ENDIF
#IFDEF DROGAMILII
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#DEFINE	DROGAMIL  OK
	#Define	XFONE 	 "(69)441-4989"
	#Define	ENCRYPT	 "FERREIRA & OCAMPOS LTDA - ME"
	#Define	XFANTA	 "FARMACIA DROGAMIL II"
	#Define	XENDEFIR  "AV PORTO VELHO, 2251 - CENTRO"
	#Define	XCGCFIR	 "05.792.171/0001-14"
	#Define	XINSCFIR  "0000000008982-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
	#Define	XRAMO 	 "MEDICAMENTOS E PERFUMARIAS"
#ENDIF
#IFDEF SAOLUCAS
	#Undef	CHELAN
	#Undef	VENLAN
	#Define	XFONE 	 "(069)442-0000"
	#Define	XVOLUME	 "SAOLUCAS"
	#Define	ENCRYPT	 "FARMACIA SAO LUCAS"
	#Define	XFANTA	 "FARMACIA SAO LUCAS"
	#Define	XENDEFIR  "RUA DOS PIONEIROS, 0000 - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0000-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF STOANTONIO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)441-4284"
	#Define	ENCRYPT	 "J. V. COSTA QUARESMA"
	#Define	XFANTA	 "FARMACIA SANTO ANTONIO"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 476 - CENTRO"
	#Define	XCGCFIR	 "05.987.839/0001-89"
	#Define	XINSCFIR  "403.13105-9"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF SAOPAULO
	#Define	XFONE 	 "(069)451-0000"
	#Define	XFONE 	 451-2249 // CRISTIANO
	#Define	ENCRYPT	 "DROGARIA SAO PAULO LTDA"
	#Define	XFANTA	 "DROGARIA SAO PAULO"
	#Define	XENDEFIR  "AV BRASIL, 905 - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF ELETROMOVEIS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(069)441-4314" // RUI
	#Define	ENCRYPT	 "COMERCIAL CACOAL LTDA"
	#Define	XFANTA	 "CACOAL ELETROMOVEIS"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 656 - CENTRO"
	#Define	XCGCFIR	 "00.957.626/0001-90"
	#Define	XINSCFIR  "403.39598-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF AUDCONT
	#Undef	PAGALAN
	#Define	XFONE 	 "(069)441-3379" // GABRIEL
	#Define	ENCRYPT	 "OLIVEIRA & BENITES LTDA"
	#Define	XFANTA	 "AUDCONT"
	#Define	XENDEFIR  "AV 02 DE JUNHO, 2670 - CENTRO"
	#Define	XCGCFIR	 "34.779.595/0001-47"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF PLANO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(069)451-3941"
	#Define	ENCRYPT	 "PLANO DA ECONOMIA"
	#Define	XFANTA	 "PLANO DA ECONOMIA"
	#Define	XENDEFIR  "RUA CASSEMIRO DE ABREU, 133 - CENTRO"
	#Define	XCGCFIR	 "84.600.253/0001-96"
	#Define	XINSCFIR  "407.37574-8"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF LORENA
	#Define	XFONE 	 "(69)441-2175"
	#Define	ENCRYPT	 "LORENA & LORENA LTDA - ME"
	#Define	XFANTA	 "BEVERLY HILLS"
	#Define	XENDEFIR  "AV PORTO VELHO, 2027 - CENTRO"
	#Define	XCGCFIR	 "05.507.576/0001-63"
	#Define	XINSCFIR  "00000000116182-2"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF VANTAJOSA
	#Define	XFONE 	 "(069)442-1519"
	#Define	ENCRYPT	 "CAMPOS & PRUDENCIO LTDA."
	#Define	XFANTA	 "A VANTAJOSA"
	#Define	XENDEFIR  "AV NORTE SUL, 4884 - CENTRO"
	#Define	XCGCFIR	 "15.304.700/0001-20"
	#Define	XINSCFIR  "409.52471-9"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF DECORALAR
	#Define	XFONE 	 "(069)441-3219"
	#Define	ENCRYPT	 "DECORALAR MOVEIS E DECORACOES LTDA"
	#Define	XFANTA	 "DECORALAR MOVEIS E DECORACOES"
	#Define	XENDEFIR  "AV 02 DE JUNHO, 2111 - CENTRO"
	#Define	XCGCFIR	 "01.297.419/0001-10"
	#Define	XINSCFIR  "403.51167-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF BRILHANTE
	#Define	XFONE 	 "(069)3451-3310"
	#Define	ENCRYPT	 "RELOJOARIA E JOALHERIA ORIENT LTDA - ME"
	#Define	XFANTA	 "OTICA E JOALHERIA BRILHANTE"
	#Define	XENDEFIR  "CASSEMIRO DE ABREU, 91 - CENTRO"
	#Define	XCGCFIR	 "84.641.685/0001-37"
	#Define	XINSCFIR  "0000000044208-9"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF DESTAK
	#Define	XFONE 	 "(69)451-2486"
	#Define	ENCRYPT	 "MARIA JOSE DE SOUZA ARAUJO - ME"
	#Define	XFANTA	 "DESTAK MODAS"
	#Define	XENDEFIR  "RUA CASSEMIRO DE ABREU, 91-C - CENTRO"
	#Define	XCGCFIR	 "05.766.670/0002-18"
	#Define	XINSCFIR  "0000000051992-8"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF SCHINCARIOL
	#UNDEF	MULTI
	#Define	MULTI 	 OK  // 02/10/2002
	#Define	XFONE 	 "(69)451-2431"
	#Define	ENCRYPT	 "DISTRIBUIDORA DE BEBIDAS COIMBRA LTDA"
	#Define	XFANTA	 "SCHINCARIOL"
	#Define	XENDEFIR  "RUA MASCARENHAS DE MORAIS, 152 - CENTRO"
	#Define	XCGCFIR	 "84.707.520/0001-29"
	#Define	XINSCFIR  "0000000051951-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
	#Define	XRAMO 	 "CERVEJAS - REFRIGERANTES"
#ENDIF
#IFDEF ELETROCENTER
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-2540"
	#Define	ENCRYPT	 "FLORES & BORGES LTDA"
	#Define	XFANTA	 "ELETRO CENTER"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 772 - CENTRO"
	#Define	XCGCFIR	 "04.320.445/0001-00"
	#Define	XINSCFIR  "0000000096887-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF ELETROCENTERESP
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)481-2540"
	#Define	ENCRYPT	 "FLORES & BORGES LTDA - ESP"
	#Define	XFANTA	 "ELETRO CENTER"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 2339 - CENTRO"
	#Define	XCGCFIR	 "04.320.445/0003-71"
	#Define	XINSCFIR  "0000000121143-9"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF ELETROCENTERCHU
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)346-1288"
	#Define	ENCRYPT	 "FLORES & BORGES LTDA - CHU"
	#Define	XFANTA	 "ELETRO CENTER"
	#Define	XENDEFIR  "AV TRANCREDO NEVES, 2238-A - CENTRO"
	#Define	XCGCFIR	 "04.320.445/0004-52"
	#Define	XINSCFIR  "0000000125342-5"
	#Define	XCCIDA	 "CHUPINGUAIA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78995-800/CHUPINGUAIA"
	#Define	XCCEP 	 "78995-800"
#ENDIF
#IFDEF CENTRAL
	#Define	XFONE 	 "(69)451-3131"
	#Define	ENCRYPT	 "JUCIMERI GEREMIA - ME"
	#Define	XFANTA	 "FOTO CENTRAL"
	#Define	XENDEFIR  "CASSEMIRO DE ABREU, 113-A - CENTRO"
	#Define	XCGCFIR	 "84.553.767/0001-38"
	#Define	XINSCFIR  "407.36283-2"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CENTRALPB
	#Undef	FANTACODEBAR
	#Undef	CODEBAR
	#Undef	MULTI
	#Define	CENTRALCALCADOS
	#Define	FANTACODEBAR  "CENTRAL"
	#Define	EMPRECODEBAR  "20"
	#Define	CODEBAR		  OK
	#Define	MULTI 		  OK
	#Define	ANO2000		  OK
	#Define	XFONE 	 "(69)451-2062"
	#Define	ENCRYPT	 "CICERO & DELICOLI LTDA"
	#Define	XFANTA	 "CENTRAL CALCADOS - MATRIZ"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 216 - CENTRO"
	#Define	XCGCFIR	 "02.819.817/0001-11"
	#Define	XINSCFIR  "407.90793-6"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CENTRALII
	#Undef	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(069)441-2265"
	#Define	ENCRYPT	 "CENTER NORTE COM CALC E CONF LTDA"
	#Define	XFANTA	 "CENTRAL CALCADOS II"
	#Define	XENDEFIR  "AV 07 DE SETEMBRO, 2135 - CENTRO"
	#Define	XCGCFIR	 "02.534.678/0001-80"
	#Define	XINSCFIR  "403.51434-9"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF CENTRALC
	#Define	CENTRALCALCADOS
	#Define	ANO2000		  OK
	#Undef	FANTACODEBAR
	#Define	FANTACODEBAR  "CENTRAL"
	#Define	EMPRECODEBAR  "20"
	#Undef	CODEBAR
	#Define	CODEBAR		  OK
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	XFONE 	 "(69)441-3316"
	#Define	ENCRYPT	 "I. S. SOUZA CAL€ADOS"
	#Define	XFANTA	 "CENTRAL CAL€ADOS E CONFECCOES"
	#Define	XENDEFIR  "RUA GENERAL OSORIO, 1064 - CENTRO"
	#Define	XCGCFIR	 "02.138.305/0001-90"
	#Define	XINSCFIR  "403.51359-8"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF CENTRAL3
	#Define	CENTRALCALCADOS
	#Define	ANO2000		  OK
	#Undef	FANTACODEBAR
	#Define	FANTACODEBAR  "CENTRAL"
	#Define	EMPRECODEBAR  "20"
	#Undef	CODEBAR
	#Define	CODEBAR	 OK
	#Undef	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)441-8836"
	#Define	ENCRYPT	 "J. A. DE ARAUJO CALCADOS - ME"
	#Define	XFANTA	 "CENTRAL CALCADOS E CONFECCOES"
	#Define	XENDEFIR  "AV 07 DE SETEMBRO, 2135 - CENTRO"
	#Define	XCGCFIR	 "03.473.871/0001-10"
	#Define	XINSCFIR  "403.54786-7"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF ATACADO
	#Define	XFONE 	 "(069)441-0000"
	#Define	XTELE 	 "441.4452"
	#Define	XVOLUME	 "AT CACOAL"
	#Define	ENCRYPT	 "ATACADO DE CONFECCOES CACOAL LTDA"
	#Define	XFANTA	 "ATACADO CACOAL"
	#Define	XENDEFIR  "RUA SERGIPE, 309 - NOVO CACOAL"
	#Define	XCGCFIR	 "63.625.602/0001-54"
	#Define	XINSCFIR  "403.29614-7"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF JRS
	#Define	XFONE 	 "(069)451-0000"
	#Define	XCOMERCIO OK
	#Define	XVOLUME	 "JRS"
	#Define	ENCRYPT	 "JRS CALCADOS LTDA"
	#Define	XFANTA	 "JRS CALCADOS LTDA"
	#Define	XENDEFIR  "RUA CASSEMIRO DE ABREU, SN - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF SANTAMARIA
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)451-2237"
	#Define	XVOLUME	 "SANTA MARIA"
	#Define	ENCRYPT	 "F. A. DE ANDRADE & CIA LTDA"
	#Define	XFANTA	 "CERAMICA SANTA MARIA"
	#Define	XENDEFIR  "BR 364 - KM 196"
	#Define	XCGCFIR	 "22.864.177/0001-79"
	#Define	XINSCFIR  "0000000019776-9"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
	#Define	XEMAIL	 "SANTAMARIA@SYBERNET.COM.BR"
#ENDIF
#IFDEF TECPLAN
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)451-4266"
	#Define	XVOLUME	 "TECPLAN"
	#Define	ENCRYPT	 "TEC PLAN TECNICA DE TERRAP E CONST LTDA"
	#Define	XFANTA	 "TEC PLAN TEC. DE TERRAP E CONST LTDA"
	#Define	XENDEFIR  "RUA BRASILIA, L-01 Q-31 SETOR 04"
	#Define	XCGCFIR	 "63.796.130/0001-00"
	#Define	XINSCFIR  "0000000036277-8"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MATSANT
	#Define	XFONE 	 "(069)481-2168"
	#Define	XVOLUME	 "SANTA MARIA"
	#Define	ENCRYPT	 "SANTA MARIA MAT P/ CONSTRUCOES LTDA"
	#Define	XFANTA	 "SANTA MARIA"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 1791 - CENTRO"
	#Define	XCGCFIR	 "84.645.068/0001-18"
	#Define	XINSCFIR  "407.23216-5"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF CORTAPAU
	#Define	XFONE 	 "(069)481-2800"
	#Define	XVOLUME	 "CORTA PAU"
	#Define	ENCRYPT	 "CORTA PAU COM DE MAQ AGRICOLAS LTDA"
	#Define	XFANTA	 "CORTA PAU"
	#Define	XENDEFIR  "RUA BAHIA, 2634 - CENTRO"
	#Define	XCGCFIR	 "84.572.312/0001-60"
	#Define	XINSCFIR  "405.07242-7"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF SETEMBRO
	#Define	ANO2000	 OK
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(069)441-0000"
	#Define	XVOLUME	 "SETEMBRO"
	#Define	ENCRYPT	 "AUTO POSTO 7 DE SETEMBRO LTDA"
	#Define	XFANTA	 "AUTO POSTO 7 DE SETEMBRO"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 2346 - CENTRO"
	#Define	XCGCFIR	 "63.749.790/0001-22"
	#Define	XINSCFIR  "403.29631-7"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF POSTO
	#Define	XFONE 	 "(069)441-0000"
	#Define	XVOLUME	 "POSTO 2000"
	#Define	ENCRYPT	 "AUTO POSTO 2000 LTDA"
	#Define	XFANTA	 "POSTO 2000"
	#Define	XENDEFIR  "AV PORTO VELHO, 2444 - CENTRO"
	#Define	XCGCFIR	 "84.610.377/0001-52"
	#Define	XINSCFIR  "403.34511-3"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF ALTO_ALEGRE
	#Define	XFONE 	 "(69)9961-1174"
	#Define	ENCRYPT	 "A. F. VIEIRA COMBUSTIVEIS"
	#Define	XFANTA	 "POSTO ALTO ALEGRE"
	#Define	XENDEFIR  "AV TANCREDO NEVES, 3892 - CENTRO"
	#Define	XCGCFIR	 "03.096.030/0001-31"
	#Define	XINSCFIR  "401.51141-2"
	#Define	XCCIDA	 "ALTO ALEGRE DOS PARECIS"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78994-800/ALTO ALEGRE DO PARECIS"
	#Define	XCCEP 	 "78994-800"
#ENDIF
#IFDEF POSTOGAROTINHO
	#Define	XFONE 	 "(69)451-2656"
	#Define	XVOLUME	 "GAROTINHO"
	#Define	ENCRYPT	 "AUTO POSTO GAROTINHO LTDA"
	#Define	XFANTA	 "AUTO POSTO GAROTINHO"
	#Define	XENDEFIR  "RUA ALCINDA RIBEIRO DE SOUZA, 203 - CENTRO"
	#Define	XCGCFIR	 "63.792.592/0001-41"
	#Define	XINSCFIR  "0000000036258-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF SAOVICENTE_CUJUBIM
	#Define	XFONE 	 "(69)582-2650"
	#Define	ENCRYPT	 "EDVALDO P. DOS SANTOS"
	#Define	XFANTA	 "SAO VICENTE AUTO POSTO"
	#Define	XENDEFIR  "RUA SANHACU, SN - CENTRO"
	#Define	XCGCFIR	 "02.274.738/0001-23"
	#Define	XINSCFIR  "0000000128182-8"
	#Define	XCCIDA	 "CUJUBIM"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78945-000/CUJUBIM"
	#Define	XCCEP 	 "78945-000"
#ENDIF
#IFDEF SAOVICENTE
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)471-3040" // JACKELINE MARISTELA TESTONI VICENTE
	#Define	ENCRYPT	 "VICENTE & TESTONI LTDA"
	#Define	XFANTA	 "SAO VICENTE AUTO POSTO"
	#Define	XENDEFIR  "AV 30 DE JUNHO, 1715 - CENTRO"
	#Define	XCGCFIR	 "63.755.391/0001-74"
	#Define	XINSCFIR  "0000000031632-6"
	#Define	XCCIDA	 "PRESIDENTE MEDICE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78968-000/PRESIDENTE MEDICE"
	#Define	XCCEP 	 "78968-000"
#ENDIF
#IFDEF LEONE
	#Define	XFONE 	 "(69)471-0000" // FLAVIO LEONE DE SOUZA
	#Define	ENCRYPT	 "LEONE & ISSLER LTDA"
	#Define	XFANTA	 "LEONE & ISSLER LTDA"
	#Define	XENDEFIR  "AV TRINTA DE JUNHO, S/N - CENTRO"
	#Define	XCGCFIR	 "02.964.866/0001-48"
	#Define	XINSCFIR  "000000000-0"
	#Define	XCCIDA	 "PRESIDENTE MEDICE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78968-000/PRESIDENTE MEDICE"
	#Define	XCCEP 	 "78968-000"
#ENDIF
#IFDEF MADEIRO
	#Define	XFONE 	 "(69)461-2774"
	#Define	ENCRYPT	 "MENDES & MADEIRO LTDA"
	#Define	XFANTA	 "AUTO POSTO CENTRAL"
	#Define	XENDEFIR  "RUA DUQUE DE CAXIAS, 251 - CENTRO"
	#Define	XCGCFIR	 "01.629.614/0001-08"
	#Define	XINSCFIR  "209.49381-3"
	#Define	XCCIDA	 "OURO PRETO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78950-000/OURO PRETO DO OESTE"
	#Define	XCCEP 	 "78950-000"
#ENDIF
#IFDEF PARAISO
	#Define	XFONE 	 "(69)464-1187"
	#Define	ENCRYPT	 "AUTO POSTO PARAISO LTDA"
	#Define	XFANTA	 "AUTO POSTO PARAISO"
	#Define	XENDEFIR  "AV PARANA, 4644 - CENTRO"
	#Define	XCGCFIR	 "03.181.990/0001-08"
	#Define	XINSCFIR  "0000000042651-2"
	#Define	XCCIDA	 "VALE DO PARAISO"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78950-000/VALE DO PARAISO"
	#Define	XCCEP 	 "78950-000"
#ENDIF
#IFDEF TESTONI
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	XFONE 	 "(069)461-3500" // JACKELINE TESTONI
	#Define	XVOLUME	 "SAO VICENTE"
	#Define	ENCRYPT	 "VICENTE & TESTONI LTDA"
	#Define	XFANTA	 "SAO VICENTE CAFE E CEREAIS"
	#Define	XENDEFIR  "AV MAL RONDON, 1428 - CENTRO"
	#Define	XCGCFIR	 "63.755.391/0001-74"
	#Define	XINSCFIR  "211.31632-6"
	#Define	XCCIDA	 "OURO PRETO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78950-000/OURO PRETO DO OESTE"
	#Define	XCCEP 	 "78950-000"
#ENDIF
#IFDEF SOMAC
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	XFONE 	 "(69)461-2154"
	#Define	XVOLUME	 "SOMAC"
	#Define	ENCRYPT	 "H. T. CAVALCANTE DE SOUZA LTDA"
	#Define	XFANTA	 "SOMAC MAT P/ CONSTRUCAO"
	#Define	XENDEFIR  "RUA ANA NERY, 353 - J. TROPICAL"
	#Define	XCGCFIR	 "01.714.736/0001-94"
	#Define	XINSCFIR  "209.49380-5"
	#Define	XCCIDA	 "OURO PRETO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78950-000/OURO PRETO DO OESTE"
	#Define	XCCEP 	 "78950-000"
#ENDIF
#IFDEF TELESERVE // ARIQUEMES-RO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)535-4123"
	#Define	XVOLUME	 "TELESERVE"
	#Define	ENCRYPT	 "TELESERVE TELEF E INF DE ARIQUEMES LTDA"
	#Define	XFANTA	 "TELESERVE TELEF E INF DE ARIQUEMES LTDA"
	#Define	XENDEFIR  "5§ RUA, 2071-ST 03"
	#Define	XCGCFIR	 "84.739.903/0001-89"
	#Define	XINSCFIR  "0000000039988-4"
	#Define	XCCIDA	 "ARIQUEMES"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/ARIQUEMES"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF TESTONE
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)3535-3264"
	#Define	ENCRYPT	 "SAO VICENTE AUTO POSTO LTDA"
	#Define	XFANTA	 "SAO VICENTE AUTO POSTO"
	#Define	XENDEFIR  "BR 421 - KM 50 - CENTRO"
	#Define	XCGCFIR	 "01.788.375/0001-20"
	#Define	XINSCFIR  "0000000047061-9"
	#Define	XCCIDA	 "ARIQUEMES"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/ARIQUEMES"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF MONTENEGRO
	#Define	XFONE 	 "(069)530-2106" // JAQUELINE
	#Define	XVOLUME	 "SAO VICENTE"
	#Define	ENCRYPT	 "SAO VICENTE AUTO POSTO LTDA"
	#Define	XFANTA	 "SAO VICENTE AUTO POSTO"
	#Define	XENDEFIR  "BR 421 - KM 50 - CENTRO"
	#Define	XCGCFIR	 "01.599.997/0001-00"
	#Define	XINSCFIR  "111.57456-2"
	#Define	XCCIDA	 "MONTE NEGRO"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78950-000/MONTE NEGRO"
	#Define	XCCEP 	 "78950-000"
#ENDIF
#IFDEF JOPNEUS
	#Define	XFONE 	 "(69)530-2048"
	#Define	XVOLUME	 "JO PNEUS"
	#Define	ENCRYPT	 "V. M. SEVERIANO - ME"
	#Define	XFANTA	 "JO PNEUS"
	#Define	XENDEFIR  "BR 421 - KM 50 - CENTRO"
	#Define	XCGCFIR	 "02.898.750/0001-58"
	#Define	XINSCFIR  "111.52996-6"
	#Define	XCCIDA	 "MONTE NEGRO"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78965-000/MONTE NEGRO"
	#Define	XCCEP 	 "78965-000"
#ENDIF
#IFDEF POSTOCENTRAL
	#Define	XFONE 	 "(69)461-2774"
	#Define	ENCRYPT	 "CENTRAL AUTO POSTO LTDA"
	#Define	XFANTA	 "CENTRAL AUTO POSTO"
	#Define	XENDEFIR  "AV DUQUE DE CAXIAS, SN - CENTRO"
	#Define	XCGCFIR	 "63.755.391/0001-74"
	#Define	XINSCFIR  "211.31632-6"
	#Define	XCCIDA	 "OURO PRETO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78950-000/OURO PRETO DO OESTE"
	#Define	XCCEP 	 "78950-000"
#ENDIF
#IFDEF POSTOAVENIDA
	#Define	XFONE 	 "(69)461-2574"
	#Define	ENCRYPT	 "SOUZA & VICENTE LTDA"
	#Define	XFANTA	 "POSTO AVENIDA"
	#Define	XENDEFIR  "AV DANIEL COMBONI, 1037 - CENTRO"
	#Define	XCGCFIR	 "01.047.120/0001-07"
	#Define	XINSCFIR  "209.44653-0"
	#Define	XCCIDA	 "OURO PRETO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78950-000/OURO PRETO DO OESTE"
	#Define	XCCEP 	 "78950-000"
#ENDIF
#IFDEF BARROS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "451-9386/2291"
	#Define	XVOLUME	 "BARROS"
	#Define	ENCRYPT	 "ELETROREFRIGERACAO BARROS LTDA"
	#Define	XFANTA	 "ELETROREFRIGERACAO BARROS"
	#Define	XENDEFIR  "R SANTOS DUMONT, 21/37 - CENTRO"
	#Define	XCGCFIR	 "34.783.027/0001-10"
	#Define	XINSCFIR  "0000000028081-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF ANGELICA
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3843"
	#Define	ENCRYPT	 "ANGELICA CARINA LOPES CLOSS"
	#Define	XFANTA	 "ANGELICA"
	#Define	XENDEFIR  "AV BARAO DO MELGACO, 761 - CENTRO"
	#Define	XCGCFIR	 "696.537.802-63"
	#Define	XINSCFIR  "725.101 SSP/RO"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CAMILA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-2773"
	#Define	ENCRYPT	 "CEREALISTA CAMILA LTDA"
	#Define	XFANTA	 "CEREALISTA CAMILA"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1528 - CENTRO"
	#Define	XCGCFIR	 "04.525.205/0001-41"
	#Define	XINSCFIR  "0000000010326-6"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF ESQUEMA
	#Define	XFONE 	 "(069)451-2625"
	#Define	XVOLUME	 "ESQUEMA"
	#Define	ENCRYPT	 "ESQUEMA CONTABILIDADE LTDA"
	#Define	XFANTA	 "ESQUEMA"
	#Define	XENDEFIR  "RUA PRESIDENTE DUTRA, 427 - CENTRO"
	#Define	XCGCFIR	 "05.688.262/0001-04"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF PINEDA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3447-1191"
	#Define	ENCRYPT	 "COM DE PROD VETERINARIOS PINEDA LTDA"
	#Define	XFANTA	 "UNIAO AGROPECUARIA"
	#Define	XENDEFIR  "AV CARLOS GOMES, 384 - CENTRO"
	#Define	XCGCFIR	 "07.109.720/0001-39"
	#Define	XINSCFIR  "132928-6"
	#Define	XCCIDA	 "PARECIS"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78989-000/PARECIS"
	#Define	XCCEP 	 "78989-000"
#ENDIF
#IFDEF AGROREAL
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3447-1109"
	#Define	ENCRYPT	 "RUSCHEL & GUIMARAES LTDA"
	#Define	XFANTA	 "CAMPO E LAVOURA AGROPECUARIA"
	#Define	XENDEFIR  "AV CARLOS GOMES, 300 - CENTRO"
	#Define	XCGCFIR	 "07.912.158/0002-68"
	#Define	XINSCFIR  "0000000146769-7"
	#Define	XCCIDA	 "PARECIS"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78989-000/PARECIS"
	#Define	XCCEP 	 "78989-000"
#ENDIF
#IFDEF AGRORURAL
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-2325"
	#Define	ENCRYPT	 "CREMONESE & RUSCHEL LTDA"
	#Define	XFANTA	 "AGRO RURAL"
	#Define	XENDEFIR  "AV CUNHA BUENO, 961 - CENTRO"
	#Define	XCGCFIR	 "84.598.937/0001-09"
	#Define	XINSCFIR  "0000000037580-2"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF ESQUEMA
	#Define	XFONE 	 "(069)451-2625"
	#Define	XVOLUME	 "ESQUEMA"
	#Define	ENCRYPT	 "ESQUEMA CONTABILIDADE LTDA"
	#Define	XFANTA	 "ESQUEMA"
	#Define	XENDEFIR  "RUA PRESIDENTE DUTRA, 427 - CENTRO"
	#Define	XCGCFIR	 "05.688.262/0001-04"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF RONDOPB 	// PIMENTA BUENO
	#Define	XFONE 	 "(069)451-2664"
	#Define	XVOLUME	 "RONDOBRAS"
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	RONDOBRAS OK
	#Define	ENCRYPT	 "AUTO PECAS RONDOBRAS LTDA"
	#Define	XFANTA	 "RONDOBRAS"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1458 - CENTRO"
	#Define	XCGCFIR	 "04.288.593/0001-94"
	#Define	XINSCFIR  "407.02515-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF DOMINGOS
	#Define	XFONE 	 "(069)451-2102"
	#Define	XVOLUME	 "DOMINGOS"
	#Define	ENCRYPT	 "DOMINGOS ANGELO DEBARBA"
	#Define	XFANTA	 "DOMINGOS"
	#Define	XENDEFIR  "AV GUARARAPES, 687 - SERINGAL"
	#Define	XCGCFIR	 "00.000.000/0000-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF SAOPEDRO	// JUINA-MT
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(65)566-1113"
	#Define	ENCRYPT	 "PEDRO CARVALHO PERES"
	#Define	XFANTA	 "AUTO PECAS SAO PEDRO"
	#Define	XENDEFIR  "AV INTEGRACAO JAIME CAMPOS, 3501 - CENTRO"
	#Define	XCGCFIR	 "03.948.650/0001-51"
	#Define	XINSCFIR  "13.115.892-9"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF RIBEIRO   // JUINA-MT
	#Define	XFONE 	 "(065)566-1371"
	#Define	XVOLUME	 "RIBEIRO"
	#Define	ANO2000	 OK
	#Define	ENCRYPT	 "J.J.F. PE€AS E SERVI€OS LTDA. - ME"
	#Define	XFANTA	 "POSTO DE MOLAS RIBEIRO"
	#Define	XENDEFIR  "AV GOV. JULIO CAMPOS, 309 - CENTRO"
	#Define	XCGCFIR	 "37.459.559/0001-94"
	#Define	XINSCFIR  "13.141830-0"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF DISBORAUTO   // JUINA-MT
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(66)3566-1757"
	#Define	ENCRYPT	 "DISBORAUTO BORRACHAS E ACESS P/ AUTO LTDA"
	#Define	XFANTA	 "DISBORAUTO"
	#Define	XENDEFIR  "AV JK, 2293 - CENTRO"
	#Define	XCGCFIR	 "32.985.574/0001-52"
	#Define	XINSCFIR  "13.072.616-8"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF CANOPUS
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)3451-3094"
	#Define	XVOLUME	 "CANOPUS"
	#Define	ENCRYPT	 "PIMENTA MOTOS COM E REPRES LTDA"
	#Define	XFANTA	 "CANOPUS MOTOS"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 1080 - CENTRO"
	#Define	XCGCFIR	 "00.857.242/0001-04"
	#Define	XINSCFIR  "0000000052019-5"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
	#Define	XEMAIL	 "CANOPUS@SYBERNET.COM.BR"
#ENDIF
#IFDEF MOREIRACESAR
	#Define	XFONE 	 "(12)3637-4349"
	#Define	ENCRYPT	 "MOREIRA CESAR MOTOS LTDA - ME"
	#Define	XFANTA	 "MOREIRA CESAR"
	#Define	XENDEFIR  "RUA ANTENOR C. DA SILVA, 39 - MOREIRA CESAR"
	#Define	XCGCFIR	 "08.410.130/0001-04"
	#Define	XINSCFIR  "528.138.400.118"
	#Define	XCCIDA	 "PINDAMONHANGABA"
	#Define	XCESTA	 "SP"
	#Define	XCEPCIDA  "12441-050/PINDAMONHANGABA"
	#Define	XCCEP 	 "12441-050"
#ENDIF
#IFDEF ITAPORANGA 	 // PIMENTA BUENO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)451-2099"
	#Define	ENCRYPT	 "CCI COM COMB ITAPORANGA LTDA"
	#Define	XFANTA	 "AUTO POSTO ITAPORANGA"
	#Define	XENDEFIR  "ROD BR 364 - KM 202 - ITAPORANGA"
	#Define	XCGCFIR	 "01.282.343/0001-59"
	#Define	XINSCFIR  "407.52069-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF RONDORE 	// REDENCAO
	#Define	XFONE 	 "(091)424-2145"
	#Define	XVOLUME	 "RONDOBRAS"
	#Define	RONDOBRAS OK
	#Define	ENCRYPT	 "AUTO PECAS RONDOBRAS LTDA"
	#Define	XFANTA	 "RONDOBRAS"
	#Define	XENDEFIR  "AV ARAGUAIA, 624 - CENTRO"
	#Define	XCGCFIR	 "83.210.468/0001-38"
	#Define	XINSCFIR  "151.66881-7"
	#Define	XCCIDA	 "REDENCAO"
	#Define	XCESTA	 "PA"
	#Define	XCEPCIDA  "68551-000/REDENCAO"
	#Define	XCCEP 	 "68551-000"
#ENDIF
#IFDEF ELEPARAISO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(069)441-2664"
	#Define	XCOMERCIO OK
	#Define	XVOLUME	 "PARAISO"
	#Define	ENCRYPT	 "B. S. M. DA SILVA & CIA LTDA"
	#Define	XFANTA	 "PARAISO DO LAR"
	#Define	XENDEFIR  "AV SETE DE SETEMBRO, 2140 - CENTRO"
	#Define	XCGCFIR	 "01.870.116/0001-44"
	#Define	XINSCFIR  "403.51282-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF COMPUSOFT	 // CACOAL
	#Define	XDOLAR	  OK
	#Define	XFONE 	 "(069)441-4258"
	#Define	XVOLUME	 "COMPUSOFT"
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ENCRYPT	 "VIVA INFORMATICA"
	#Define	XFANTA	 "VIVA INFORMATICA"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 2144 - CENTRO"
	#Define	XCGCFIR	 "84.652.288/0001-79"
	#Define	XINSCFIR  "407.02515-1"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF DOMAQUINO
	#Define	XDOLAR	  OK
	#Define	XFONE 	 "(069)441-5480"
	#Define	XVOLUME	 "DOM AQUINO"
	#Define	ENCRYPT	 "DOM AQUINO ADM E CORR DE SEGUROS"
	#Define	XFANTA	 "DOM AQUINO ADM E CORR DE SEGUROS"
	#Define	XENDEFIR  "AV 2 DE JUNHO, 2650 - CENTRO"
	#Define	XCGCFIR	 "84.573.252/0001-08"
	#Define	XINSCFIR  "ISENTO"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF MICRONEWS	 // CACOAL
	#Define	XFONE 	 "(069)441-2025"
	#Define	XVOLUME	 "MICRONEWS"
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ENCRYPT	 "MICRONEWS INFORMATICA LTDA"
	#Define	XFANTA	 "MICRONEWS"
	#Define	XENDEFIR  "AV PORTO VELHO, 2185 - SALA 1"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF MEGAB
	#Define	SCP		 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)441-1090"
	#Define	ENCRYPT	 "MEGA IND E COM DE CONFECCOES LDTA"
	#Define	XFANTA	 "MEGA B"
	#Define	XENDEFIR  "AV GENERAL OSORIO, 1056 - CENTRO"
	#Define	XCGCFIR	 "84.713.353/0001-29"
	#Define	XINSCFIR  "403.39520-0"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF VENUS  // CACOAL
	#Define	XFONE 	"(069)441-2035"
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XVOLUME	 "VENUS"
	#Define	ENCRYPT	 "GOMES DA ROCHA & CIA LTDA"
	#Define	XFANTA	 "PAPELARIA VENUS"
	#Define	XENDEFIR  "AV PORTO VELHO, 2233 - CENTRO"
	#Define	XCGCFIR	 "84.649.805/0001-50"
	#Define	XINSCFIR  "403.37478-4"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF DEMO  // DEMONSTRACAO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	SCP		  OK
	#Define	XFONE 	  "(000)000-0000"
	#Define	XVOLUME	  "MODELO"
	#Define	ENCRYPT	  "COPIA DEMONSTRACAO - REGISTRE-SE!!"
	#Define	XFANTA	  "COPIA DEMONSTRACAO - REGISTRE-SE!!"
	#Define	XENDEFIR   "AV DEMO, 000 - CENTRO"
	#Define	XCGCFIR	  "00.000.000/0001-00"
	#Define	XINSCFIR   "000.00000-0"
	#Define	XCCIDA	  "CIDADE DEMO"
	#Define	XCESTA	  "RO"
	#Define	XCEPCIDA   "00000-000/CIDADE DEMO"
	#Define	XCCEP 	  "00000-000"
#ENDIF
#IFDEF JAIR
	#Define	XFONE 	  "(069)441-4939"
	#Define	ANO2000	  OK
	#Define	ENCRYPT	  "R. J. COML IMP LTDA"
	#Define	XFANTA	  "ROSANGELA JOIAS"
	#Define	XENDEFIR   "AV 7 DE SETEMBRO, 2848 - CENTRO"
	#Define	XCGCFIR	  "02.480.972/0001-56"
	#Define	XINSCFIR   "403.51467-5"
	#Define	XCCIDA	  "CACOAL"
	#Define	XCESTA	  "RO"
	#Define	XCEPCIDA   "78975-000/CACOAL"
	#Define	XCCEP 	  "78975-000"
#ENDIF
#IFDEF LINHARES	// PIMENTA BUENO
	#Define	XFONE 	 "(069)451-2669"
	#Define	ENCRYPT	 "JOSE LINHARES DA SILVA"
	#Define	XFANTA	 "MERCANTIL"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 605 - CENTRO"
	#Define	XCGCFIR	 "15.878.515/0001-66"
	#Define	XINSCFIR  "407.52130-2"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF COIMBRA   // PIMENTA BUENO
	#Define	XFONE 	 "(69)451-5565"
	#Define	ENCRYPT	 "MERCANTIL COIMBRA LTDA"
	#Define	XFANTA	 "MERCANTIL COIMBRA"
	#Define	XENDEFIR  "AV PRESIDENTE KENNEDY, 931 - CENTRO"
	#Define	XCGCFIR	 "05.215.322/0001-71"
	#Define	XINSCFIR  "0000000000739-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF COLCHOES  // PIMENTA BUENO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XCOMERCIO OK
	#Define	XFONE 	 "(69)3451-2765"
	#Define	XVOLUME	 "COLCHOES"
	#Define	ENCRYPT	 "CASA DOS COLCHOES LTDA"
	#Define	XFANTA	 "CASA DOS COLCHOES"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 755 - PIONEIROS"
	#Define	XCGCFIR	 "15.875.594/0001-51"
	#Define	XINSCFIR  "0000000015974-3"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF DECORART
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XCOMERCIO OK
	#Define	XFONE 	 "(69)3451-2765"
	#Define	XVOLUME	 "DECORART"
	#Define	ENCRYPT	 "DECORART COM. DE ART. DECORATIVOS LTDA"
	#Define	XFANTA	 "DECORART"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 755 - CENTRO"
	#Define	XCGCFIR	 "07.516.086/0001-59"
	#Define	XINSCFIR  "00000000138838-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MARIVANI  // PIMENTA BUENO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XCOMERCIO OK
	#Define	XFONE 	 "(69)451-4562"
	#Define	XVOLUME	 "MARIVANI"
	#Define	ENCRYPT	 "MARIVANI BECALLI BORSUK"
	#Define	XFANTA	 "NOSSA LOJA"
	#Define	XENDEFIR  "AV DOM PEDRO SEGUNDO, 53 - CENTRO"
	#Define	XCGCFIR	 "03.727.440/0001-33"
	#Define	XINSCFIR  "0000000090887-8"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF NOSSALOJACALCADOS // PIMENTA BUENO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XCOMERCIO OK
	#Define	XFONE 	 "(69)3451-6906"
	#Define	XVOLUME	 "V. NUNES"
	#Define	ENCRYPT	 "V. NUNES RIBEIRO"
	#Define	XFANTA	 "NOSSA LOJA CALCADOS"
	#Define	XENDEFIR  "RUA RICARDO FRANCO, 21 - CENTRO"
	#Define	XCGCFIR	 "03.089.101/0001-79"
	#Define	XINSCFIR  "0000000090823-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF BUTISILOFF  // CASA DOS COLCHOES - CACOAL
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	COLCHOES  OK
	#Define	XFONE 	 "(69)441-3018"
	#Define	ENCRYPT	 "BUTISILOFF & CIA LTDA"
	#Define	XFANTA	 "CASA DOS COLCHOES"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 2365 - CENTRO"
	#Define	XCGCFIR	 "34.450.965/0001-06"
	#Define	XINSCFIR  "403.19161-2"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF BALAO // ESPIGAO DO OESTE
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(069)481-3363" // WALTER
	#Define	XVOLUME	 "JS"
	#Define	ENCRYPT	 "BALAO PE€AS E ACESSORIOS LTDA"
	#Define	XFANTA	 "BALAO PECAS E ACESSORIOS"
	#Define	XENDEFIR  "AV 7 DE SETEMBRO, 2090-C - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF LINDAGUA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)451-3502"
	#Define	ENCRYPT	 "AGUA MINERAL LIND'AGUA LTDA"
	#Define	XFANTA	 "AGUA MINERAL LIND'AGUA"
	#Define	XENDEFIR  "LINHA 36 - GLEBA TATU - LOTE 07"
	#Define	XCGCFIR	 "05.679.642/0001-82"
	#Define	XINSCFIR  "407.15393-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF LINDOLAR  // PIMENTA BUENO
	#Define	XCOMERCIO OK
	#Define	XFONE 	 "(069)451-2564"
	#Define	XVOLUME	 "LINDOLAR"
	#Define	ENCRYPT	 "J. A. LAUDISSE - ME"
	#Define	XFANTA	 "LINDOLAR MOVEIS E ELETRODOMESTICOS"
	#Define	XENDEFIR  "RUA RICARDO FRANCO, SN - CENTRO"
	#Define	XCGCFIR	 "84.718.915/0001-27"
	#Define	XINSCFIR  "405.41054-3"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF RONDOCA // CACOAL
	#Define	XFONE 	 "(069)441-3280"
	#Define	XVOLUME	 "RONDOBRAS"
	#Define	RONDOBRAS  OK
	#Define	ENCRYPT	 "RONDOBRAS PECAS PARA VEICULOS LTDA"
	#Define	XFANTA	 "RONDOBRAS"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 1039 - CENTRO"
	#Define	XCGCFIR	 "04.935.771/0001-21"
	#Define	XINSCFIR  "403.04981-6"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF RONDORM // ROLIM DE MOURA
	#Define	XFONE 	 "(069)442-1931"
	#Define	XVOLUME	 "RONDOBRAS"
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	RONDOBRAS OK
	#Define	ENCRYPT	 "COMERCIAL DE PECAS RONDOBRAS LTDA"
	#Define	XFANTA	 "RONDOBRAS"
	#Define	XENDEFIR  "AV 25 DE AGOSTO, 4710 - CENTRO"
	#Define	XCGCFIR	 "04.910.337/0001-97"
	#Define	XINSCFIR  "409.03501-7"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF MIRIAM
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)442-2469"
	#Define	ENCRYPT	 "AUTO POSTO MIRIAM LTDA"
	#Define	XFANTA	 "AUTO POSTO MIRIAM"
	#Define	XENDEFIR  "RUA CORUMBIARA, 4566 - CENTRO"
	#Define	XCGCFIR	 "22.845.796/0002-05"
	#Define	XINSCFIR  "409.38824-6"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF RONDOJI // JI PARANA
	#Define	XFONE 	 "(069)421-1661"
	#Define	XVOLUME	 "RONDOBRAS"
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	RONDOBRAS OK
	#Define	ENCRYPT	 "RONDOBRAS COM DE PECAS E ACESS P/ VEICULOS LTDA"
	#Define	XFANTA	 "RONDOBRAS"
	#Define	XENDEFIR  "AV TRANSCONTINENTAL, 1770 - PRIMAVERA"
	#Define	XCGCFIR	 "84.721.711/0001-45"
	#Define	XINSCFIR  "205.48786-4"
	#Define	XCCIDA	 "JI PARANA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78960-000/JI PARANA"
	#Define	XCCEP 	 "78960-000"
#ENDIF
#IFDEF MOTOSUL // ROLIM DE MOURA
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(069)442-2707"
	#Define	XVOLUME	 "MOTOSUL"
	#Define	ENCRYPT	 "MOTOSUL NORTE COM E REPRES LTDA"
	#Define	XFANTA	 "MOTOSUL"
	#Define	XENDEFIR  "AV 25 DE AGOSTO, 4469 - CENTRO"
	#Define	XCGCFIR	 "84.551.043/0001-55"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF GAUCHA // ESTANCIA GAUCHA
	#Define	XFONE 	 "(69)442-1979"
	#Define	XVOLUME	 "GAUCHA"
	#Define	ENCRYPT	 "ESTANCIA GAUCHA"
	#Define	XFANTA	 "ESTANCIA GAUCHA"
	#Define	XENDEFIR  "RUA RIO MADEIRA, 4876 - CENTRO"
	#Define	XCGCFIR	 "074.964.009-04"
	#Define	XINSCFIR  "805.108 SSP/PR"
	#Define	XCCIDA	 "ROLIM DE MOURA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78987-000/ROLIM DE MOURA"
	#Define	XCCEP 	 "78987-000"
#ENDIF
#IFDEF TRAMA // JUINA-MT
	#Define	ANO2000	  OK
	#Define	XFONE 	  "(65)566-2310"
	#Define	ENCRYPT	  "TRAMA - COM PECAS PARA TRATORES LTDA"
	#Define	XFANTA	  "TRAMA"
	#Define	XENDEFIR   "AV GOV JAIME CAMPOS, SN - CENTRO"
	#Define	XCGCFIR	  "37.475.472/0001-00"
	#Define	XINSCFIR   "13.143.819-0"
	#Define	XCCIDA	  "JUINA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78320-000/JUINA"
	#Define	XCCEP 	  "78320-000"
#ENDIF
#IFDEF RONDOJU // JUINA-MT
	#UNDEF	MULTI
	#Define	MULTI 		OK
	#Define	XFONE 		"(065)566-1179" // 566.1976
	#Define	XVOLUME		"RONDOBRAS"
	#Define	RONDOBRAS	OK
	#Define	ENCRYPT	  "AUTO PECAS RONDOBRAS LTDA"
	#Define	XFANTA	  "RONDOBRAS"
	#Define	XENDEFIR   "AV GOV JAIME CAMPOS, 840 - CENTRO"
	#Define	XCGCFIR	  "24.742.520/0001-38"
	#Define	XINSCFIR   "130.61903-5"
	#Define	XCCIDA	  "JUINA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78320-000/JUINA"
	#Define	XCCEP 	  "78320-000"
#ENDIF
#IFDEF COTRASA // JUINA-MT
	#Define	RONDOBRAS	OK
	#Define	XFONE 	  "(65)566-1651"
	#Define	ENCRYPT	  "M. G. DA SILVA PECAS - ME"
	#Define	XFANTA	  "COTRASA COM DE PECAS E TRATORES"
	#Define	XENDEFIR   "AV GOV JAIME CAMPOS, 207 - CENTRO"
	#Define	XCGCFIR	  "01.796.103/0001-72"
	#Define	XINSCFIR   "13.174595-6"
	#Define	XCCIDA	  "JUINA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78320-000/JUINA"
	#Define	XCCEP 	  "78320-000"
	#Define	XEMAIL	  "COTRASA@VSP.COM.BR"
#ENDIF
#IFDEF APJURUENA
	#Undef	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	  "(65)553-1162"
	#Define	ANO2000	  OK
	#Define	XVOLUME	  "APJURUENA"
	#Define	ENCRYPT	  "A. L. MOREIRA - ME"
	#Define	XFANTA	  "AUTO PECAS JURUENA"
	#Define	XENDEFIR   "RUA 24 DE SETEMBRO, 68 - CENTRO"
	#Define	XCGCFIR	  "01.379.395/0001-48"
	#Define	XINSCFIR   "13.021020-0"
	#Define	XCCIDA	  "JURUENA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78340-000/JURUENA"
	#Define	XCCEP 	  "78340-000"
#ENDIF
#IFDEF LUISCARLOS
	#Define	XFONE 	  "(65)553-1122"
	#Define	ANO2000	  OK
	#Define	XVOLUME	  "LUISCARLOS"
	#Define	ENCRYPT	  "LUIS CARLOS DA SILVA & CIA LTDA"
	#Define	XFANTA	  "JUREMAQ MOTORES"
	#Define	XENDEFIR   "RUA 24 DE SETEMBRO, 61 - CENTRO"
	#Define	XCGCFIR	  "37.433.984/0001-04"
	#Define	XINSCFIR   "13.137738-1"
	#Define	XCCIDA	  "JURUENA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78340-000/JURUENA"
	#Define	XCCEP 	  "78340-000"
#ENDIF
#IFDEF MER_PRIMAVERA
	#Define	ANO2000	  OK
	#Define	XFONE 	  "(66)571-1132"
	#Define	ENCRYPT	  "COMERCIO DE ALIMENTOS PRIMAVERA LTDA - ME"
	#Define	XFANTA	  "MERCADO PRIMAVERA"
	#Define	XENDEFIR   "RUA DA GARAPEIRA, 178 - CENTRO"
	#Define	XCGCFIR	  "06.940.658/0001-60"
	#Define	XINSCFIR   "13.270202-9"
	#Define	XCCIDA	  "COLNIZA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78335-000/COLNIZA"
	#Define	XCCEP 	  "78335-000"
#ENDIF
#IFDEF CLAUDAIR
	#Undef	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	  "(66)571-1132"
	#Define	ENCRYPT	  "CLAUDAIR M. DA SILVA - ME"
	#Define	XFANTA	  "CONIMAQ MOTORES"
	#Define	XENDEFIR   "AV DO CONTORNO, SN - CENTRO"
	#Define	XCGCFIR	  "02.364.929/0001-25"
	#Define	XINSCFIR   "13.179613-5"
	#Define	XCCIDA	  "COLNIZA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78335-000/COLNIZA"
	#Define	XCCEP 	  "78335-000"
#ENDIF
#IFDEF RONDOARIPUANA // ARIPUANA-MT
	#Define	XFONE 		"(065)565-1265" // KENNER
	#Define	XVOLUME		"RONDOBRAS"
	#Define	ENCRYPT	  "AUTO PECAS RONDOBRAS LTDA"
	#Define	XFANTA	  "RONDOBRAS"
	#Define	XENDEFIR   "AV 02 DE DEZEMBRO, 557 - CENTRO"
	#Define	XCGCFIR	  "24.742.520/0003-08"
	#Define	XINSCFIR   "13.175331-2"
	#Define	XCCIDA	  "ARIPUANA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78325-000/ARIPUANA"
	#Define	XCCEP 	  "78325-000"
#ENDIF
#IFDEF TRUCKAO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	  "(66)565-1303"
	#Define	ENCRYPT	  "M. ANTONIO OLIVEIRA COMERCIO-ME"
	#Define	XFANTA	  "POSTO TRUCKAO/JM-TOYOTA"
	#Define	XENDEFIR   "RODOVIA AR 1, 270 - ST INDL"
	#Define	XCGCFIR	  "02.393.991/0001-45"
	#Define	XINSCFIR   "13.179.918-5"
	#Define	XCCIDA	  "ARIPUANA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78325-000/ARIPUANA"
	#Define	XCCEP 	  "78325-000"
	#Define	XEMAIL	  "TRUCAOTOYOTA@ARIPUANA.COM.BR"
#ENDIF
#IFDEF DIMACO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	  "(065)556-1433"
	#Define	XVOLUME	  "DIMACO"
	#Define	ENCRYPT	  "FERREIRA & OLIVEIRA & CIA LTDA"
	#Define	XFANTA	  "DIMACO MAT P/ CONSTRUCAO"
	#Define	XENDEFIR   "AV RIO ARINOS, 1162 - CENTRO"
	#Define	XCGCFIR	  "01.321.680/0001-08"
	#Define	XINSCFIR   "13.170.052-9"
	#Define	XCCIDA	  "JUARA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78575-000/JUARA"
	#Define	XCCEP 	  "78575-000"
#ENDIF
#IFDEF OSKAR
	#Define	XFONE 		"(065)566-1640"
	#Define	XVOLUME		"OSKAR"
	#Define	RONDOBRAS	OK
	#Define	ENCRYPT	  "O. ALVES DE QUEIROZ"
	#Define	XFANTA	  "OSKAR MOTOS"
	#Define	XENDEFIR   "AV GABRIEL MULLER, SN - CENTRO"
	#Define	XCGCFIR	  "01.292.994/0001-20"
	#Define	XINSCFIR   "130.25132-1"
	#Define	XCCIDA	  "JUINA"
	#Define	XCESTA	  "MT"
	#Define	XCEPCIDA   "78320-000/JUINA"
	#Define	XCCEP 	  "78320-000"
#ENDIF
#IFDEF COMETA // L. S. LIMA & CIA LTDA. SRTA GERLI
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(065)566-1188"
	#Define	XVOLUME	 "COMETA"
	#Define	RONDOBRAS  OK
	#Define	ENCRYPT	 "L. S. LIMA & CIA LTDA"
	#Define	XFANTA	 "COMERCIAL DE PECAS COMETA"
	#Define	XENDEFIR  "AV GOV JAIME CAMPOS, 1400 - CENTRO"
	#Define	XCGCFIR	 "02.435.659/0001-04"
	#Define	XINSCFIR  "13.036.518-1"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF RONDOAR // ARIQUEMES-RO
	#UNDEF	MULTI
	#Define	MULTI 		OK
	#Define	XFONE 	 "(069)535-5654"
	#Define	XVOLUME	 "RONDOBRAS"
	#Define	ELEBRA	  OK
	#Define	RONDOBRAS  OK
	#Define	ENCRYPT	 "RONDOBRAS AUTO PECAS LTDA"
	#Define	XFANTA	 "RONDOBRAS"
	#Define	XENDEFIR  "AV CANAA, 1616- ST INDUSTRIAL"
	#Define	XCGCFIR	 "84.635.465/0001-09"
	#Define	XINSCFIR  "103.45553-9"
	#Define	XCCIDA	 "ARIQUEMES"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/ARIQUEMES"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF MOTAO5	// CACOAL-RO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)441-6168"
	#Define	ENCRYPT	 "MOTAO PALITO 2 COM DE MOTO PECAS LTDA"
	#Define	XFANTA	 "MOTAO PALITO 5"
	#Define	XENDEFIR  "AV CASTELO BRANCO, 18548 - CENTRO"
	#Define	XCGCFIR	 "63.792.048/0002-80"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF MOTAO2	// ARIQUEMES-RO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)535-4864"
	#Define	XVOLUME	 "MOTAO"
	#Define	ENCRYPT	 "MOTAO PALITO II LTDA"
	#Define	XFANTA	 "MOTAO PALITO II"
	#Define	XENDEFIR  "AV CANAA, 3357 - SETOR C1"
	#Define	XCGCFIR	 "63.792.048/0001-08"
	#Define	XINSCFIR  "103.35765-1"
	#Define	XCCIDA	 "ARIQUEMES"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/ARIQUEMES"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF MOTAO3	// JARU
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)521-1417"
	#Define	ENCRYPT	 "J. J. MORTENE & OLIVEIRA LTDA"
	#Define	XFANTA	 "MOTAO PALITO 3"
	#Define	XENDEFIR  "AV PADRE A. ROHL, 3119 - CENTRO"
	#Define	XCGCFIR	 "03.010.152/0001-63"
	#Define	XINSCFIR  "203.90997-1"
	#Define	XCCIDA	 "JARU"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78940-000/JARU"
	#Define	XCCEP 	 "78940-000"
#ENDIF
#IFDEF MOTAO4	// BURITI
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)535-4864"
	#Define	ENCRYPT	 "CHAPARINI & OLIVEIRA LTDA"
	#Define	XFANTA	 "MOTAO PALITO 4"
	#Define	XENDEFIR  "AV PORTO VELHO S/N - CENTRO"
	#Define	XCGCFIR	 "02.751.210/0001-47"
	#Define	XINSCFIR  "103.91547-5"
	#Define	XCCIDA	 "BURITI"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "38000-000/BURITI"
	#Define	XCCEP 	 "38000-000"
#ENDIF
#IFDEF MORTENE  // ARIQUEMES-RO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)536-1728"
	#Define	ENCRYPT	 "OLIVEIRA E MORTENE LTDA - ME"
	#Define	XFANTA	 "OLIVEIRA E MORTENE LTDA - ME"
	#Define	XENDEFIR  "ALAMEDA DO IPE, 3416 SETOR 1"
	#Define	XCGCFIR	 "15.824.956/0001-85"
	#Define	XINSCFIR  "103.16980-3"
	#Define	XCCIDA	 "ARIQUEMES"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/ARIQUEMES"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF SANTOS
	#Undef	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)3535-5499"
	#Define	ANO2000	 OK
	#Define	ENCRYPT	 "CELIO PEREIRA DA SILVA"
	#Define	XFANTA	 "BICICLETARIA SANTOS"
	#Define	XENDEFIR  "AV JAMARI, 4045 - SETOR 02"
	#Define	XCGCFIR	 "34.730.598/0001-96"
	#Define	XINSCFIR  "00000026384-2"
	#Define	XCCIDA	 "ARIQUEMES"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/ARIQUEMES"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF JACIARA
	#Define	XFONE 	 "(69)3535-2707"
	#Define	ANO2000	 OK
	#Define	ENCRYPT	 "EDENILSON J. DA SILVA"
	#Define	XFANTA	 "BICICLETARIA JACIARA"
	#Define	XENDEFIR  "ALAMEDA PIQUIA, 1937 - SETOR 01"
	#Define	XCGCFIR	 "22.869.192/0001-00"
	#Define	XINSCFIR  "00000021769-7"
	#Define	XCCIDA	 "ARIQUEMES"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/ARIQUEMES"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF AMAZONAS
	#Undef	MULTI
	#Define	MULTI 	 OK
	#Define	XFONE 	 "(69)535-2126"
	#Define	ANO2000	 OK
	#Define	XVOLUME	 "AMAZONAS"
	#Define	ENCRYPT	 "S. DE SOUZA SILVA - ME"
	#Define	XFANTA	 "BICICLETARIA AMAZONAS"
	#Define	XENDEFIR  "ALAMEDA PIQUIA, 1897 - SETOR 01"
	#Define	XCGCFIR	 "84.746.841/0001-32"
	#Define	XINSCFIR  "000000039917-5"
	#Define	XCCIDA	 "ARIQUEMES"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/ARIQUEMES"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF MOTAO1	// ARIQUEMES-RO
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)536-1211"
	#Define	ENCRYPT	 "PALITO MOTOPECAS LTDA"
	#Define	XFANTA	 "PALITO MOTOPECAS"
	#Define	XENDEFIR  "AV CANAA, 3357 - ST COML 1"
	#Define	XCGCFIR	 "03.684.857/0001-66"
	#Define	XINSCFIR  "0000000095801-8"
	#Define	XCCIDA	 "ARIQUEMES"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78932-000/ARIQUEMES"
	#Define	XCCEP 	 "78932-000"
#ENDIF
#IFDEF PANORAMA // JUINA-MT
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(65)566-1227"
	#Define	XVOLUME	 "PANORAMA"
	#Define	ENCRYPT	 "PANORAMA PECAS CICLOS LTDA"
	#Define	XFANTA	 "PANORAMA"
	#Define	XENDEFIR  "MATO GROSSO, 640 - CENTRO"
	#Define	XCGCFIR	 "15.010.622/0001-78"
	#Define	XINSCFIR  "13.116.620-4"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF UNIAO // JUINA-MT
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(65)566-1445"
	#Define	XVOLUME	 "UNIAO"
	#Define	ENCRYPT	 "SUPER LOJAS UNIAO MAGAZINE LTDA"
	#Define	XFANTA	 "SUPER UNIAO"
	#Define	XENDEFIR  "AV MATO GROSSO, 800 - CENTRO"
	#Define	XCGCFIR	 "01.724.509/0001-40"
	#Define	XINSCFIR  "13.303.950-1"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
	#Define	XEMAIL	 "UNIAODOLAR@JUINA-FOX.COM.BR"
#ENDIF
#IFDEF _PANORAMA // TANGARA DA SERRA-MT
	#DEFINE	PANORAMA
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(65)326-4064"
	#Define	XVOLUME	 "PANORAMA"
	#Define	ENCRYPT	 "PANORAMA PECAS CICLOS LTDA"
	#Define	XFANTA	 "PANORAMA"
	#Define	XENDEFIR  "DECIO BURALI, 143-N - CENTRO"
	#Define	XCGCFIR	 "15.010.622/0002-59"
	#Define	XINSCFIR  "13.152.634-0"
	#Define	XCCIDA	 "TANGARA DA SERRA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78300-000/TANGARA DA SERRA"
	#Define	XCCEP 	 "78300-000"
#ENDIF
#IFDEF PAULISTA // TANGARA DA SERRA-MT
	#Define	XFONE 	 "(65)726-4200"
	#Define	XVOLUME	 "PANORAMA"
	#Define	ENCRYPT	 "BICICLETAS PAULISTA LTDA"
	#Define	XFANTA	 "BICICLETA PAULISTA"
	#Define	XENDEFIR  "RUA 06, 411S - CENTRO"
	#Define	XCGCFIR	 "02.021.928/0001-88"
	#Define	XINSCFIR  "13.177.211-2"
	#Define	XCCIDA	 "TANGARA DA SERRA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78300-000/TANGARA DA SERRA"
	#Define	XCCEP 	 "78300-000"
#ENDIF
#IFDEF RELAMPAGO // NOVA OLIMPIA-MT
	#Define	XFONE 	 "(65)332-1155"
	#Define	XVOLUME	 "RELAMPAGO MOTOS"
	#Define	ENCRYPT	 "JOSE BALBINO - ME"
	#Define	XFANTA	 "RELAMPAGO MOTOS"
	#Define	XENDEFIR  "RUA WILSON DE ALMEIDA, 420E - JD OURO VERDE"
	#Define	XCGCFIR	 "06.177.857/0001-68"
	#Define	XINSCFIR  "13.247.870-6"
	#Define	XCCIDA	 "NOVA OLIMPIA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78370-000/NOVA OLIMPIA"
	#Define	XCCEP 	 "78370-000"
#ENDIF
#IFDEF BIKE // TANGARA DA SERRA-MT
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(65)326-3007"
	#Define	ENCRYPT	 "MARLENE BRAGA DIST DE PECAS - ME"
	#Define	XFANTA	 "BIKE PECAS"
	#Define	XENDEFIR  "RUA DECIO BURALI, 147-N - CENTRO"
	#Define	XCGCFIR	 "04.135.400/0001-65"
	#Define	XINSCFIR  "13.197.904-9"
	#Define	XCCIDA	 "TANGARA DA SERRA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78300-000/TANGARA DA SERRA"
	#Define	XCCEP 	 "78300-000"
#ENDIF
#IFDEF RONDOMOCA
	#Define	XFONE 	 "(000)000-0000"
	#Define	XVOLUME	 "RONDOMOTO"
	#Define	ENCRYPT	 "COM DE PECAS E CICLOM RONDOMOTO LTDA"
	#Define	XFANTA	 "RONDOMOTO"
	#Define	XENDEFIR  "AV PORTO VELHO, 2432 - CENTRO"
	#Define	XCGCFIR	 "84.569.169/0001-57"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF SOBMEDIDA
	#Define	GRUPO_MICROBRAS OK
	#Undef	DBFPROTEGIDO
	#Define	SCP
	#Define	MICROBRASPB   OK
	#Define	XRAMO 		  "ATACADO DE ROUPAS"
	#Undef	FANTACODEBAR
	#Define	FANTACODEBAR  "SOBMEDIDA"
	#Define	EMPRECODEBAR  "21"
	#Undef	CODEBAR
	#Define	CODEBAR		  OK
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	ANO2000		  OK
	#Define	NOTAMICROBRAS OK
	#Define	XFONE 	 "(69)3451-2286"
	#Define	ENCRYPT	 "SOBMEDIDA ATACADO"
	#Define	XFANTA	 "SOBMEDIDA ATACADO"
	#Define	XENDEFIR  "AV CARLOS DORNEJE, SN - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0001-00"
	#Define	XINSCFIR  "0000000000000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
	#Define	XEMAIL	 "SOBMEDIDA@SYBERNET.COM.BR"
#ENDIF
#IFDEF CONTATOINFO
	#Define	GRUPO_MICROBRAS OK
	#Undef	DBFPROTEGIDO
	#Define	SCP
	#Define	MICROBRASPB   OK
	#Define	XRAMO 		  "INTERNET A RADIO"
	#Undef	FANTACODEBAR
	#Define	FANTACODEBAR  "CONTATOINFO"
	#Define	EMPRECODEBAR  "21"
	#Undef	CODEBAR
	#Define	CODEBAR		  OK
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	ANO2000		  OK
	#Define	NOTAMICROBRAS OK
	#Define	XFONE 	 "(69)3451-3060"
	#Define	ENCRYPT	 "SANTOS E BUENO COM DE INFORMATICA LTDA"
	#Define	XFANTA	 "CONTATO INFORMATICA"
	#Define	XENDEFIR  "RUA COSTA MARQUES, 160 - CENTRO"
	#Define	XCGCFIR	 "08.472.462/0001-07"
	#Define	XINSCFIR  "163015-6"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
	#Define	XEMAIL	 "CONTATOINFO@BOL.COM.BR"
#ENDIF
#IFDEF MICROBRAS
	#Define	GRUPO_MICROBRAS OK
	#Undef	DBFPROTEGIDO
	#Define	SCP
	#Define	MICROBRASPB   OK
	#Define	XRAMO 		  "COMPUTADORES/PERIFERICOS/ASS TECNICA/SUPORTE"
	#Undef	FANTACODEBAR
	#Define	FANTACODEBAR  "MICROBRAS"
	#Define	EMPRECODEBAR  "21"
	#Undef	CODEBAR
	#Define	CODEBAR		  OK
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	ANO2000		  OK
	#Define	NOTAMICROBRAS OK
	#Define	XFONE 	 "(69)3451-2286"
	#Define	ENCRYPT	 "MICROBRAS COM PROD DE INFORMATICA LTDA"
	#Define	XFANTA	 "MICROBRAS INFORMATICA"
   #Define  XENDEFIR  "AV CASTELO BRANCO, 693 - PIONEIROS"
	#Define	XCGCFIR	 "63.771.588/0001-05"
	#Define	XINSCFIR  "0000000034697-7"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
   #Define  XEMAIL    "SUPORTE@SYBERNET.COM.BR"
#ENDIF
#IFDEF SYBERNET
   #Define  MICROBRAS       OK
   #Define  GRUPO_MICROBRAS OK
	#Undef	DBFPROTEGIDO
	#Define	SCP
	#Define	MICROBRASPB   OK
	#Define	XRAMO 		  "COMPUTADORES/PERIFERICOS/ASS TECNICA/SUPORTE"
	#Undef	FANTACODEBAR
   #Define  FANTACODEBAR  "SYBERNET"
	#Define	EMPRECODEBAR  "21"
	#Undef	CODEBAR
	#Define	CODEBAR		  OK
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	ANO2000		  OK
	#Define	NOTAMICROBRAS OK
   #Define  XFONE     "(69)3451-3085"
   #Define  ENCRYPT   "SYBERNET PROVEDOR E SERVICOS LTDA"
   #Define  XFANTA    "SYBERNET INFORMATICA"
   #Define  XENDEFIR  "AV CASTELO BRANCO, 679 - PIONEIROS"
   #Define  XCGCFIR   "03.052.953/0001-91"
   #Define  XINSCFIR  "ISENTO"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
   #Define  XEMAIL    "SUPORTE@SYBERNET.COM.BR"
#ENDIF
#IFDEF VILMAR
   #Define  MICROBRAS       OK
   #Define  GRUPO_MICROBRAS OK
	#Undef	DBFPROTEGIDO
	#Define	SCP
	#Define	MICROBRASPB   OK
	#Define	XRAMO 		  "COMPUTADORES/PERIFERICOS/ASS TECNICA/SUPORTE"
	#Undef	FANTACODEBAR
   #Define  FANTACODEBAR  "TURBONET"
	#Define	EMPRECODEBAR  "21"
	#Undef	CODEBAR
	#Define	CODEBAR		  OK
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	ANO2000		  OK
	#Define	NOTAMICROBRAS OK
   #Define  XFONE     "(69)3451-3085"
   #Define  ENCRYPT   "VILMAR CATAFESTA"
   #Define  XFANTA    "TURBONET INFORMATICA"
   #Define  XENDEFIR  "AV CASTELO BRANCO, 693 - PIONEIROS"
   #Define  XCGCFIR   "620.269.179-49"
   #Define  XINSCFIR  "3.708.860-9 SSP/PR"
   #Define  XNOMESOCIO "VILMAR CATAFESTA"
   #Define  XCPFSOCIO  "620.269.179-49"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
   #Define  XEMAIL    "VCATAFESTA@GMAIL.COM"
#ENDIF
#IFDEF TURBONET
   #Define  MICROBRAS       OK
   #Define  GRUPO_MICROBRAS OK
	#Undef	DBFPROTEGIDO
	#Define	SCP
	#Define	MICROBRASPB   OK
	#Define	XRAMO 		  "COMPUTADORES/PERIFERICOS/ASS TECNICA/SUPORTE"
	#Undef	FANTACODEBAR
   #Define  FANTACODEBAR  "TURBONET"
	#Define	EMPRECODEBAR  "21"
	#Undef	CODEBAR
	#Define	CODEBAR		  OK
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	ANO2000		  OK
	#Define	NOTAMICROBRAS OK
   #Define  XFONE     "(69)3451-3085"
   #Define  ENCRYPT   "TURBONET PROVEDOR E SERVICOS DE INFO LTDA"
   #Define  XFANTA    "TURBONET INFORMATICA"
   #Define  XENDEFIR  "AV CASTELO BRANCO, 679-A - PIONEIROS"
   #Define  XCGCFIR   "16.928.786/0001-41"
   #Define  XINSCFIR  "ISENTO"
   #Define  XNOMESOCIO "VILMAR CATAFESTA"
   #Define  XCPFSOCIO  "620.269.179-49"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
   #Define  XEMAIL    "TURBONET@SYBERNET.COM.BR"
#ENDIF
#IFDEF VILADELA
	#Undef	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)3451-7070"
	#Define	ENCRYPT	 "VILADELA COMERCIO DE CONFECCOES LTDA"
	#Define	XFANTA	 "VILADELA CONFECCOES"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 766 - CENTRO"
	#Define	XCGCFIR	 "03.892.667/0001-34"
	#Define	XINSCFIR  "0000000059588-8"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF OBOTICARIO
	#Undef PAGALAN
	#Undef CHELAN
	#Undef VENLAN
	#Undef PONTO
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3527"
	#Define	ENCRYPT	 "DO CARMO COSMETICOS E PERF LTDA - ME"
	#Define	XFANTA	 "O BOTICARIO"
	#Define	XENDEFIR  "RUA CASSEMIRO DE ABREU, 03 - CENTRO"
	#Define	XCGCFIR	 "01.751.838/0001-80"
	#Define	XINSCFIR  "407.52123-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF ESCOLA
	#Undef	FANTACODEBAR
	#Define	FANTACODEBAR  "MICROBRAS"
	#Define	EMPRECODEBAR  "21"
	#Undef	CODEBAR
	#Define	CODEBAR		  OK
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	NOTAMICROBRAS OK
	#Define	XFONE 	 "(069)451-2286"
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ENCRYPT	 "MICROBRAS COM DE PROD DE INFORMATICA LTDA"
	#Define	XFANTA	 "MICROBRAS INFORMATICA"
	#Define	XENDEFIR  "RUA CASSIMIRO DE ABREU, 52 - SALA 7 - CENTRO"
	#Define	XCGCFIR	 "63.771.588/0001-05"
	#Define	XINSCFIR  "407.34697-7"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF GIO
	#Define	XRAMO 	 "PRODUTOS AGROPECUARIOS/VETERINARIOS"
	#Define	XFONE 	 "(69)412-2972"
	#Define	ENCRYPT	 "GIL & CIA COM E REPRES LTDA"
	#Define	XFANTA	 "GIO & CIA"
	#Define	XENDEFIR  "AV 05 DE SETEMBRO, 4902 - CENTRO"
	#Define	XCGCFIR	 "03.073.408/0001-81"
	#Define	XINSCFIR  "201.48112-2"
	#Define	XCCIDA	 "ALVORADA DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78969-000/ALVORADA DO OESTE"
	#Define	XCCEP 	 "78969-000"
#ENDIF
#IFDEF PRODUZA
	#Undef	MULTI
	#Define	MULTI 		  OK
	#Define	XRAMO 	 "PRODUTOS AGROPECUARIOS/VETERINARIOS"
	#Define	XFONE 	 "(069)412-2609"
	#Define	XVOLUME	 "PRODUZA"
	#Define	ENCRYPT	 "PRO-COMERCIO DE PROD AGROP LTDA - ME"
	#Define	XFANTA	 "PRODUZA"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 4966-B - CENTRO"
	#Define	XCGCFIR	 "84.754.134/0001-98"
	#Define	XINSCFIR  "201.42625-3"
	#Define	XCCIDA	 "ALVORADA DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78969-000/ALVORADA DO OESTE"
	#Define	XCCEP 	 "78969-000"
#ENDIF
#IFDEF SKALA
	#Define	XSERIE	 "1126-0A03"
	#Define	XCOMERCIO OK
	#Define	XFONE 	 "(069)451-2087" // SILVANA MARCELINO
	#Define	XVOLUME	 "SKALA"
	#Define	ENCRYPT	 "SILVANA MARCELINO & CIA LTDA"
	#Define	XFANTA	 "SKALA MODAS"
	#Define	XENDEFIR  "RUA CASSIMIRO DE ABREU, 155-A - CENTRO"
	#Define	XCGCFIR	 "01.141.336/0001-37"
	#Define	XINSCFIR  "407.52048-9"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF SIMONE
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(069)451-2389"
	#Define	ENCRYPT	 "S. LEMES COMBUSTIVEIS"
	#Define	XFANTA	 "POSTO SIMONE"
	#Define	XENDEFIR  "RUA PETRONIO PORTELA, 50 - CENTRO"
	#Define	XCGCFIR	 "02.988.602/0001-24"
	#Define	XINSCFIR  "407.90818-5"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MAILLIW
	#Define	XSERIE	 "2743-08FB"
	#Define	XFONE 	 "(069)451-3003"
	#Define	XVOLUME	 "MAILLIW"
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ENCRYPT	 "E. V. FABIANO - ME"
	#Define	XFANTA	 "MAILLIW MALHAS"
	#Define	XENDEFIR  "AV PRESIDENTE VARGAS, 304 - CENTRO"
	#Define	XCGCFIR	 "63.622.898/0001-50"
	#Define	XINSCFIR  "407.29852-2"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF RADIOS
	#Define	ANO2000	 OK
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)441-3490"
	#Define	ENCRYPT	 "PROLO & FERRAZ LTDA"
	#Define	XFANTA	 "CASA DOS RADIOS"
	#Define	XENDEFIR  "RUA GAL OSORIO, 1074 - CENTRO"
	#Define	XCGCFIR	 "84.553.742/0001-34"
	#Define	XINSCFIR  "0000000031123-5"
	#Define	XCCIDA	 "CACOAL"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78975-000/CACOAL"
	#Define	XCCEP 	 "78975-000"
#ENDIF
#IFDEF SURUI
	#Define	XFONE 	 "(069)421-0000"
	#Define	XVOLUME	 "SURUI"
	#Define	CAIARI	  OK
	#Define	ENCRYPT	 "SURUI MATERIAIS P/ CONSTR LTDA"
	#Define	XFANTA	 "SURUI"
	#Define	XENDEFIR  "AV TRANSCONTINENTAL, 600 - CENTRO"
	#Define	XCGCFIR	 "05.932.843/0001-00"
	#Define	XINSCFIR  "205.12024-3"
	#Define	XCCIDA	 "JI PARANA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78958-000/JI PARANA"
	#Define	XCCEP 	 "78958-000"
#ENDIF
#IFDEF HENICKA
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(65)566-1285"
	#Define	ENCRYPT	 "HENICKA & HENICKA LTDA"
	#Define	XFANTA	 "SUPERMERCADO CATARINENSE"
	#Define	XENDEFIR  "AV MATO GROSSO, 540 - CENTRO"
	#Define	XCGCFIR	 "01.022.710/0001-85"
	#Define	XINSCFIR  "13.166.430-1"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF PASQUALOTTO
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	ANO2000	  OK
	#Define	XFONE 	 "(065)566-1618"
	#Define	XVOLUME	 "PASQUALOTTO"
	#Define	ENCRYPT	 "SUPERMERCADO E SACOLAO PASQUALOTTO LTDA"
	#Define	XFANTA	 "SUPERMERCADO E SACOLAO PASQUALOTTO"
	#Define	XENDEFIR  "AV GABRIEL MULLER, SN - CENTRO"
	#Define	XCGCFIR	 "37.449.485/0001-05"
	#Define	XINSCFIR  "13.139.002-3"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF VERONESE
	#UNDEF	MULTI
	#Define	MULTI 	  OK	 // 08/02/99
	#Define	ANO2000	  OK	 // 08/02/99
	#Define	XSERIE	 "1D4E-5AADD"
	#Define	XFONE 	 "(065)566-1388"
	#Define	XVOLUME	 "VERONESE"
	#Define	ENCRYPT	 "SUPERMERCADO VERONESE LTDA."
	#Define	XFANTA	 "SUPERMERCADO VERONESE"
	#Define	XENDEFIR  "AV MATO GROSSO, 44 - CX 3 - CENTRO"
	#Define	XCGCFIR	 "02.508.687/0001-04"
	#Define	XINSCFIR  "13.040.545-0"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF CASTILHO
	#UNDEF	MULTI
	#Define	MULTI 	 OK	// 31/05/2001
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-2133"
	#Define	ENCRYPT	 "BIG ACO INDUSTRIA E COMERCIO LTDA"
	#Define	XFANTA	 "CASTILHO ESTRUTURAS"
	#Define	XENDEFIR  "ROD BR 364 - KM 502 - AABB"
	#Define	XCGCFIR	 "03.442.062/0001-41"
	#Define	XINSCFIR  "0000000086969-4"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF RONDOMETALVG
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	XSERIE	 "3A73-1EE5"
	#Define	XFONE 	 "(065)682-2273"
	#Define	XVOLUME	 "RONDOMETAL"
	#Define	ENCRYPT	 "IND E COM DE PROD SIDER RONDOMETAL LTDA"
	#Define	XFANTA	 "RONDOMETAL"
	#Define	XENDEFIR  "AV ULISSES P. DE CAMPOS, 3100 - CENTRO"
	#Define	XCGCFIR	 "00.000.000/0000-00"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "VARZEA GRANDE"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78140-000/VARZEA GRANDE"
	#Define	XCCEP 	 "78140-000"
#ENDIF
#IFDEF RONDOMETAL
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)451-2139"
	#Define	ENCRYPT	 "RONDOMETAL ESTRUTURAS METALICAS LTDA"
	#Define	XFANTA	 "RONDOMETAL"
	#Define	XENDEFIR  "BR 364 - KM 95"
	#Define	XCGCFIR	 "84.754.654/0001-09"
	#Define	XINSCFIR  "000.00000-0"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
	#Define	XEMAIL	 "RONDOMETAL@SYBERNET.COM.BR"
#ENDIF
#IFDEF RONDOMETALFE
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)451-2069"
	#Define	ENCRYPT	 "RONDOMETAL COM DE FERR E REPRES LTDA"
	#Define	XFANTA	 "RONDOMETAL"
	#Define	XENDEFIR  "BR 364 - KM 95"
	#Define	XCGCFIR	 "02.512.067/0001-30"
	#Define	XINSCFIR  "0000000090756-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
	#Define	XEMAIL	 "RONDOMETAL@SYBERNET.COM.BR"
#ENDIF
#IFDEF RONDONORTE
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XFONE 	 "(69)451-3048"
	#Define	ENCRYPT	 "AUTO ELETRICA RONDONORTE - ME"
	#Define	XFANTA	 "AUTO ELETRICA RONDONORTE"
	#Define	XENDEFIR  "AV MARECHAL RONDON, 973 - CENTRO"
	#Define	XCGCFIR	 "34.777.714/0001-22"
	#Define	XINSCFIR  "0000000028080-1"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF MORUMBI 	// PRESIDENTE MEDICE
	#UNDEF	MULTI
	#Define	MULTI 	  OK
	#Define	XFONE 	 "(69)471-2800"
	#Define	ENCRYPT	 "SISER MAT P/ CONSTRUCAO LTDA - ME"
	#Define	XFANTA	 "MORUMBI"
	#Define	XENDEFIR  "AV 30 DE JUNHO, 1588 - CENTRO"
	#Define	XCGCFIR	 "63.764.229/0001-12"
	#Define	XINSCFIR  "000000031646-6"
	#Define	XCCIDA	 "PRESIDENTE MEDICE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78968-000/PRESIDENTE MEDICE"
	#Define	XCCEP 	 "78968-000"
#ENDIF
#IFDEF DISNORTE
	#UNDEF	MULTI
	#Define	MULTI 	 OK
	#Define	ANO2000	 OK
	#Define	XSERIE	 "1CB6-6C6C"
	#Define	XFONE 	 "(069)471-2161"
	#Define	XVOLUME	 "DISNORTE"
	#Define	ENCRYPT	 "DISNORTE COMERCIO E REPRESENTACOES LTDA"
	#Define	XFANTA	 "DISNORTE"
	#Define	XENDEFIR  "AV 30 DE JUNHO, 1478-A - CENTRO"
	#Define	XCGCFIR	 "01.802.684/0001-08"
	#Define	XINSCFIR  "211.54314-6"
	#Define	XCCIDA	 "PRESIDENTE MEDICE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78968-000/PRESIDENTE MEDICE"
	#Define	XCCEP 	 "78968-000"
#ENDIF
#IFDEF KAROLINE
	#Define	XFONE 	 "(65)566-1423"
	#Define	ENCRYPT	 "AGNALDO E. NUNES"
	#Define	XFANTA	 "CAL€ADOS KAROLINE"
	#Define	XENDEFIR  "AV 9 DE MAIO, 150 - CENTRO"
	#Define	XCGCFIR	 "00.936.666/0001-56"
	#Define	XINSCFIR  "13.015938-7"
	#Define	XCCIDA	 "JUINA"
	#Define	XCESTA	 "MT"
	#Define	XCEPCIDA  "78320-000/JUINA"
	#Define	XCCEP 	 "78320-000"
#ENDIF
#IFDEF POPINHAK
	#Define	XFONE 	 "(069)451-0000"
	#Define	XVOLUME	 "POPINHAKI"
	#Define	ENCRYPT	 "MADEIRAS POPINHAK LTDA"
	#Define	XFANTA	 "MADEIRAS POPINHAK"
	#Define	XENDEFIR  "BR 364 - KM 248"
	#Define	XCGCFIR	 "83.459.688/0003-54"
	#Define	XINSCFIR  "407.07031-9"
	#Define	XCCIDA	 "PIMENTA BUENO"
	#Define	XCESTA	 "RO"
   #Define  XCEPCIDA  "76970-000/PIMENTA BUENO"
   #Define  XCCEP     "76970-000"
#ENDIF
#IFDEF CIMAPE
	#Define	XFONE 	 "(069)481-2674"
	#Define	XVOLUME	 "CIMAPE"
	#Define	ENCRYPT	 "CIMAPE COM E IND DE MAD PARANA LTDA"
	#Define	XFANTA	 "CIMAPE"
	#Define	XENDEFIR  "ESTRADA DO AEROPORTO - KM 02"
	#Define	XCGCFIR	 "34.465.815/0001-68"
	#Define	XINSCFIR  "405.21476-1"
	#Define	XCCIDA	 "ESPIGAO DO OESTE"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78983-000/ESPIGAO DO OESTE"
	#Define	XCCEP 	 "78983-000"
#ENDIF
#IFDEF TRENTO	// NOVA BRASILANDIA
	#Define	XFONE 	 "(069)418-2795"
	#Define	XVOLUME	 "TRENTO"
	#Define	ENCRYPT	 "COML. ALIM. H.C. LTDA" // COML. ALIM. H.C LTDA
	#Define	XFANTA	 "TRENTO SUPERMERCADOS"
	#Define	XENDEFIR  "AV J.K, 3064 - CENTRO"
	#Define	XCGCFIR	 "84.625.557/0001-08"
	#Define	XINSCFIR  "207.30732-7"
	#Define	XCCIDA	 "NOVA BRASILANDIA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78974-000/NOVA BRASILANDIA"
	#Define	XCCEP 	 "78974-000"
#ENDIF
#IFDEF ARIEL  // NOVA BRASILANDIA
	#Define	XFONE 	 "(69)418-2519"
	#Define	XVOLUME	 "ARIEL"
	#Define	ENCRYPT	 "MARLENE APARECIDA DE SOUZA & CIA LTDA" // ARIEL ALVES DE SOUZA & CIA lTDA
	#Define	XFANTA	 "AUTO POSTO MODELO"
	#Define	XENDEFIR  "AV J.K, 2738 - SETOR 13"
	#Define	XCGCFIR	 "03.305.635/0001-95"
	#Define	XINSCFIR  "0000000043085-4"
	#Define	XCCIDA	 "NOVA BRASILANDIA"
	#Define	XCESTA	 "RO"
	#Define	XCEPCIDA  "78974-000/NOVA BRASILANDIA"
	#Define	XCCEP 	 "78974-000"
#ENDIF
#IFDEF COVAL
	#UNDEF	MULTI
	#Define	MULTI 		 OK
	#Define	ANO2000		 OK
	#Define	XFONE 		 "(65)566-1659"
	#Define	ENCRYPT		 "COVAL-COML VARZEA GDE AUTO PECAS LTDA"
	#Define	XFANTA		 "VARZEA GRANDE TOYOTA"
	#Define	XENDEFIR 	 "AV GOV CARLOS GOMES, SN - CENTRO"
	#Define	XCGCFIR		 "37.443.751/0001-92"
	#Define	XINSCFIR 	 "13.138.388-4"
	#Define	XCCIDA		 "JUINA"
	#Define	XCESTA		 "MT"
	#Define	XCEPCIDA 	 "78320-000/JUINA"
	#Define	XCCEP 		 "78320-000"
#ENDIF
#IFNDEF XCGCFIR
	#Error Erro: Nao foi definido empresa
#ENDIF
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
