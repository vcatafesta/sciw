/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 Ý³                                                                         ³
 Ý³   Programa.....: SCI.PRG                                                ³
 Ý³   Aplicacao....: SCI - SISTEMA COMERCIAL INTEGRADO SCI                  ³
 Ý³   Versao.......: 6.2.30                                                 ³
 Ý³   Escrito por..: Vilmar Catafesta                                       ³
 Ý³   Empresa......: Macrosoft Sistemas de Informatica Ltda.                ³
 Ý³   Inicio.......: 12 de Novembro de 1991.                                ³
 Ý³   Ult.Atual....: 25 de Julho de 2016.                                   ³
 Ý³   Linguagem....: Clipper 5.2e/C/Assembler                               ³
 Ý³   Linker.......: Blinker 6.00                                           ³
 Ý³   Bibliotecas..: Clipper/Funcoes/Mouse/Funcky15/Funcky50/Classe/Classic ³
 Ý³   Bibliotecas..: Oclip/Six3                                             ³
 ÝÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#Include "lista.ch"
#Include "inkey.ch"
#Include "Directry.Ch"
#Include "Permissao.Ch"
#Include "Indice.Ch"
#Include "FileIO.Ch"
#Include "Picture.ch"
#Include "RddName.ch"
#Include "DbInfo.ch"
//#Include "Pragma.ch"

REQUEST HB_CODEPAGE_PT850
REQUEST HB_CODEPAGE_PTISO
REQUEST HB_CODEPAGE_PT860
REQUEST HB_CODEPAGE_UTF8

REQUEST HB_LANG_PT_BR
REQUEST HB_LANG_PT

Function Main()
***************
LOCAL lOk		 := OK
LOCAL Opc		 := 1
LOCAL cTela
LOCAL ph1     
PUBL aLpt1		 := {}
PUBL aLpt2		 := {}
PUBL aLpt3		 := {}
PUBL aMensagem  := {}
PUBL aItemNff	 := {}
PUBL aPermissao := {}
PUBL aInscMun	 := {}
PUBL aIss		 := {}
PUBL XCFGPIRACY := MsEncrypt( ENCRYPT )

//Altd()        //Debug
PUBL oAmbiente  := TAmbiente():New()
//PUBL oMenu		 := TMenuNew()
PUBL oMenu      := oAmbiente
PUBL oIni		 := TIniNew( oAmbiente:xBase + "\SCI0001.INI")
PUBL oIndice	 := TIndiceNew()
PUBL oProtege	 := TProtegeNew()
PUBL oReindexa
PUBL oSci
PUBL oIni
PUBL cCaixa
*:----------------------------------------------------------------------------
//Eval( oAmbiente:TabelaFonte[ oAmbiente:Fonte ])
hb_langSelect( "pt_br" )       // Default language is now Portuguese
hb_cdpSelect( "PT860" )
hb_langSelect( "pt_br" )       // Default language is now 
*:----------------------------------------------------------------------------
SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
//Turbo(OK)
//OL_AutoYield(OK)
SetColor("")
Cls
SetaIni()
*:----------------------------------------------------------------------------
REQUEST HB_LANG_PT
REQUEST HB_CODEPAGE_PT850  
RddSetDefa( RDDNAME )
Acesso()
SetKey( F8, 		  {|| AcionaSpooler()})
//SetKey( F10,		  {|| FT_Adder()})
SetKey( F10,		  {|| Calc()})
SetKey( F12,		  {|| ConfigurarEtiqueta()})
SetKey( TECLA_ALTC, {|| Altc() })
SetKey( K_CTRL_END, {|| GravaDisco() })
SetKey( K_SH_F10,   {|| AutorizaVenda() })
*:----------------------------------------------------------------------------
#IFDEF DEMO
	oMenu:Limpa()
	ErrorBeep()
	Alerta( oIni:ReadString("string", "string4") + ;
           oIni:ReadString("string", "string5") + ;
		     oIni:ReadString("string", "string6") + ;
		     oIni:ReadString("string", "string7") + ;
		     oIni:ReadString("string", "string8") )
#ENDIF
*:----------------------------------------------------------------------------
oAmbiente:Clock           := Time() 
oAmbiente:HoraCerta       := Array(100)
oAmbiente:TarefaConcluida := Array(100)
Afill( oAmbiente:HoraCerta, Time())
Afill( oAmbiente:TarefaConcluida, FALSO )
ph1 := hb_idleAdd( {|| CronTab()})
Empresa()
FechaTudo()
IF !VerIndice()
	Alert("ERRO Tente mais tarde.")
	FChDir( oAmbiente:xBase )
	SalvaMem()
	SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
	Cls
	Quit
EndIF
IF AbreUsuario()
	Usuario()
Else
	SalvaMem()
	ResTela()
	SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
	Quit
EndIF
SetaIni()
oMenu:Limpa()
SetaClasse()
RefreshClasse()
WHILE lOk
	BEGIN Sequence
		SetKey( F5, {|| PrecosConsulta()})
		oMenu:Limpa()
		Opc := oMenu:Show()
		Do Case
		Case opc = 0.0 .OR. opc = 1.01
			ErrorBeep()
			IF Conf("Pergunta: Deseja finalizar esta sessao ?" )
				lOk := FALSO
				Break
			EndIF
		Case opc = 1.03
			Empresa()
			IF !VerIndice()
				Alert("ERRO: Arquivos nao disponivel para indexacao. Tente mais tarde.")
				SalvaMem()
				ResTela()
				SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
				Quit
			EndIF
			oMenu:Limpa()
			IF AbreUsuario()
				Usuario()
			Else
				SalvaMem()
				SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
				Quit
			EndIF
			SetaClasse()
			RefreshClasse()
		Case opc = 1.04
			IF AbreUsuario()
				SetKey( F5, NIL )
				Usuario()
				SetaClasse()
				FechaTudo()
			EndIF
			RefreshClasse()
			SetKey( F5, {|| PrecosConsulta()})
		Case opc = 1.06
			MacroBackup()
		Case opc = 1.07
			MacroRestore()
		Case opc = 2.01
			#IFDEF TESTELAN
            //Acesso(OK)
				ListaLan()
				RefreshClasse()
			#ENDIF
		Case opc = 2.02
			#IFDEF RECELAN
            //Acesso(OK)
				Recelan()
				RefreshClasse()
			#ENDIF
		Case opc = 2.03
			#IFDEF PAGALAN
            //Acesso(OK)
				PagaLan()
				RefreshClasse()
			#ENDIF
		Case opc = 2.04
			#IFDEF CHELAN
            //Acesso(OK)
				Chelan()
				RefreshClasse()
			#ENDIF
		Case Opc = 2.05
			#IFDEF SCP
            //Acesso(OK)
				ScpLan()
				RefreshClasse()
			#ENDIF
		Case Opc = 2.06
			#IFDEF PONTO
            //Acesso(OK)
				PontoLan()
				RefreshClasse()
			#ENDIF
		Case Opc = 2.07
			Carta()
		Case Opc = 2.08
			#IFDEF VENLAN
            //Acesso(OK)
				Venlan()
				RefreshClasse()
			#ENDIF
		Case opc = 3.01
			#IFDEF ORCALAN
            //Acesso(OK)
				Orcamento( FALSO )
			#ENDIF
		Case opc = 3.02
			IF !UsaArquivo("LISTA") ; Break ; EndiF
			IF !UsaArquivo("GRUPO") ; Break ; EndiF
			IF !UsaArquivo("SUBGRUPO") ; Break ; EndiF
			IF !UsaArquivo("PAGAR") ; Break ; EndiF
			IF !UsaArquivo("REPRES") ; Break ; EndiF
			TermPrecos()
		Case opc = 3.03
			cTela := Mensagem("Aguarde, Abrindo Arquivos.")
			IF !UsaArquivo("SAIDAS")  ; Break ; EndiF
			IF !UsaArquivo("RECEBER") ; Break ; EndiF
			IF !UsaArquivo("FORMA")   ; Break ; EndiF
			IF !UsaArquivo("LISTA")   ; Break ; EndiF
			IF !UsaArquivo("CEP")     ; Break ; EndiF
			IF !UsaArquivo("REGIAO")  ; Break ; EndiF
			ResTela( cTela )
			VendasTipo()
			FechaTudo()
		Case opc = 3.04
			cTela := Mensagem("Aguarde, Abrindo Arquivos.")
			IF !UsaArquivo("SAIDAS")  ; Break ; EndiF
			IF !UsaArquivo("RECEBER") ; Break ; EndiF
			IF !UsaArquivo("FORMA")   ; Break ; EndiF
			IF !UsaArquivo("REGIAO")  ; Break ; EndiF
			IF !UsaArquivo("RECEMOV") ; Break ; EndiF
			IF !UsaArquivo("CEP")     ; Break ; EndiF
			ResTela( cTela )
			WHILE OK
				oMenu:Limpa()
				M_Title("TIPO DE RELATORIO")
				nChoice := FazMenu( 03, 20, {"Por Vencimento", "Por Emissao *"})
				Do Case
				Case nChoice = 0
					Exit
				Case nChoice = 1
					PrnAlfabetica(1)
				Case nChoice = 2
					PrnAlfabetica(2)
				EndCase
			EndDo
			FechaTudo()
		Case opc = 3.05
			cTela := Mensagem("Aguarde, Abrindo Arquivos.")
			IF !UsaArquivo("SAIDAS")  ; Break ; EndiF
			IF !UsaArquivo("RECEBER") ; Break ; EndiF
			IF !UsaArquivo("RECEBIDO"); Break ; EndiF
			IF !UsaArquivo("VENDEDOR"); Break ; EndiF
			IF !UsaArquivo("FORMA")   ; Break ; EndiF
			IF !UsaArquivo("REGIAO")  ; Break ; EndiF
			ResTela( cTela )
			RelRecebido()
			FechaTudo()
		Case opc = 3.06
			IF UsaArquivo("VENDEDOR" )
				CadastraSenha()
				FechaTudo()
			EndIF
		Case opc = 3.08
			IF !UsaArquivo("RECEBIDO") ; Break ; EndiF
			IF !UsaArquivo("VENDEDOR") ; Break ; EndiF
			IF !UsaArquivo("CHEMOV")   ; Break ; EndiF
			IF !UsaArquivo("RECEMOV")  ; Break ; EndiF
			IF !UsaArquivo("RECEBER")  ; Break ; EndiF
			IF !UsaArquivo("SAIDAS")   ; Break ; EndiF
			DetalheCaixa(, FALSO )
			FechaTudo()
		Case opc = 3.09
			IF !UsaArquivo("RECEBIDO") ; Break ; EndiF
			IF !UsaArquivo("VENDEDOR") ; Break ; EndiF
			IF !UsaArquivo("CHEMOV")   ; Break ; EndiF
			IF !UsaArquivo("RECEMOV")  ; Break ; EndiF
			IF !UsaArquivo("RECEBER")  ; Break ; EndiF
			IF !UsaArquivo("SAIDAS")  ; Break ; EndiF
			DetalheCaixa(, OK )
			FechaTudo()
		Case opc = 3.10
			IF !UsaArquivo("RECEBIDO") ; Break ; EndiF
			IF !UsaArquivo("VENDEDOR") ; Break ; EndiF
			IF !UsaArquivo("CHEMOV")   ; Break ; EndiF
			IF !UsaArquivo("RECEMOV")  ; Break ; EndiF
			IF !UsaArquivo("RECEBER")  ; Break ; EndiF
			IF !UsaArquivo("CHEQUE")   ; Break ; EndiF
			IF !UsaArquivo("SAIDAS")   ; Break ; EndiF
			DetalheCaixa(, OK, Opc )
			FechaTudo()
		Case opc = 3.11
			IF !UsaArquivo("VENDEDOR") ; Break ; EndiF
         IF !UsaArquivo("RECIBO")   ; Break ; EndiF
         DetalheRecibo(,1)
			FechaTudo()
      Case opc = 3.12
			IF !UsaArquivo("VENDEDOR") ; Break ; EndiF
         IF !UsaArquivo("RECIBO")   ; Break ; EndiF
         DetalheRecibo(,2)
			FechaTudo()
      Case opc = 3.13
			IF !UsaArquivo("VENDEDOR") ; Break ; EndiF
         IF !UsaArquivo("RECIBO")   ; Break ; EndiF
         DetalheRecibo(,3)
			FechaTudo()
      Case opc = 3.15
			IF UsaArquivo("SAIDAS")
				IF UsaArquivo("LISTA")
					IF UsaArquivo("RECEBER")
						ImprimeDebito()
						FechaTudo()
					EndIF
				EndIF
			EndIF
      Case opc = 3.16
			IF UsaArquivo("SAIDAS")
				IF UsaArquivo("LISTA")
					IF UsaArquivo("RECEBER")
						IF UsaArquivo("CHEQUE")
							IF UsaArquivo("CHEMOV")
								MostraDebito()
								FechaTudo()
							EndIF
						EndIF
					EndIF
				EndIF
			EndIF
      Case opc = 3.17
			IF UsaArquivo("SAIDAS")
				IF UsaArquivo("LISTA")
					IF UsaArquivo("RECEBER")
						DebitoC_C()
						FechaTudo()
					EndIF
				EndIF
			EndIF
      Case opc = 3.18
			IF !UsaArquivo("LISTA")    ; Break ; EndiF
			IF !UsaArquivo("RECEBER")  ; Break ; EndiF
			IF !UsaArquivo("SAIDAS")   ; Break ; EndiF
			IF !UsaArquivo("CHEMOV")   ; Break ; EndiF
			IF !UsaArquivo("CHEQUE")   ; Break ; EndiF
			IF !UsaArquivo("VENDEDOR") ; Break ; EndiF
			BaixaDebitoc_c()
			FechaTudo()
      Case opc = 3.20
         EcfComandos()
		Case opc = 4.01
			MacroBackup()
		Case opc = 4.02
			MacroRestore()
			oMenu:Limpa()
			ErrorBeep()
			IF Conf("Pergunta: Reindexar os Arquivos Agora ?")
				IF MenuIndice()
					CriaIndice()
				EndIF
			EndIF
		Case Opc = 4.03
			GeraBatch()
		Case Opc = 4.05
			 IF MenuIndice()
				 CriaIndice()
			 EndIF
		Case Opc = 4.06
			 IF MenuIndice()
				 FechaTudo()
				 IF AbreArquivo()
					 Duplicados()
					 CriaIndice()
				 EndIF
			 EndIF
		Case Opc = 4.07
			 IF MenuIndice()
				 Reindexar()
				 oIndice:Compactar	 := FALSO
				 oIndice:ProgressoNtx := FALSO
			 EndIF
		Case Opc = 4.08
			ExcluirTemporarios()
		Case Opc = 5.01
			Edicao()
		Case Opc = 5.02
			Impressao()
		Case oPc = 6.01
			Spooler()
		Case oPc = 6.02
			oMenu:SetaFonte()
			SalvaMem()
		Case oPc = 6.04
			oMenu:SetaCor( 3 )
		Case oPc = 6.05
			oMenu:SetaCor( 1 )
			SalvaMem()
		Case oPc = 6.06
			oMenu:SetaCor( 2 )
			SalvaMem()
		Case oPc = 6.07
			oMenu:SetaCorAlerta(8)
			oAmbiente:CorAlerta := oMenu:CorAlerta
			SalvaMem()
		Case oPc = 6.08
			oMenu:SetaCorBorda(10)
			SalvaMem()
		Case oPc = 6.09
			oMenu:SetaCor( 4 )
			SalvaMem()
		Case oPc = 6.10
			oMenu:SetaCorMsg(9)
			oAmbiente:CorMsg := oMenu:CorMsg
			SalvaMem()
		Case oPc = 6.11
			oMenu:SetaCor( 5 ) // ::CorLigthBar
			SalvaMem()
		Case oPc = 6.12
			oMenu:SetaCor( 6 ) // ::CorHotKey
	   	SalvaMem()			
		Case oPc = 6.13
			oMenu:SetaCor( 7 ) // ::CorLightBarHotKey
			SalvaMem()	
		Case oPc = 6.15
			oMenu:SetaPano()
			SalvaMem()
		Case oPc = 6.16
			oMenu:SetaFrame()
			SalvaMem()
		Case oPc = 6.17
			oMenu:Sombra	  := !(oIni:ReadBool( oAmbiente:xUsuario, 'sombra', FALSO ))
			oAmbiente:Sombra := oMenu:Sombra
			oMenu:SetaSombra()
         oMenu:Menu := oSciMenuSci()
			SalvaMem()
		Case oPc = 6.18
			oAmbiente:Get_Ativo := !(oIni:ReadBool( oAmbiente:xUsuario, 'get_ativo', FALSO ))
         oMenu:Menu := oSciMenuSci()
			SalvaMem()
		Case oPc = 6.19
			IF !UsaArquivo("USUARIO") ; Break ; EndIF
			IF !UsaArquivo("PRINTER") ; Break ; EndIF
			AltSenha()
			FechaTudo()
		Case Opc = 7.01
			oMenu:Limpa()
			Diretorio( 03, 05, LastRow() - 2, "W+/B,N/W,,,W+/N")
		Case Opc = 7.02
			TbDemo()
		Case Opc = 7.04
			 IF MenuIndice()
				 CriaIndice()
			 EndIF
		Case Opc = 7.05
			 IF MenuIndice()
				 FechaTudo()
				 IF AbreArquivo()
					 Duplicados()
					 CriaIndice()
				 EndIF
			 EndIF
		Case Opc = 7.07
			 ExcluirTemporarios()
		Case opc = 7.08
			IF !UsaArquivo("USUARIO") ; Break ; EndIF
			IF !UsaArquivo("PRINTER") ; Break ; EndIF
			CadastraUsuario()
			RefreshClasse()
			FechaTudo()
		Case opc = 7.09
			ConfBaseDados()
			FechaTudo()
		Case opc = 7.10
         #IFDEF MICROBRAS
				IF !UsaArquivo("RETORNO") ; Break ; EndIF
				IF !UsaArquivo("RECEBER") ; Break ; EndIF
				IF !UsaArquivo("RECEMOV") ; Break ; EndIF
				IF !UsaArquivo("CEP")     ; Break ; EndIF
				IF !UsaArquivo("REGIAO")  ; Break ; EndIF
				Retorno()
				FechaTudo()
			#ENDIF
		Case opc = 7.11
			Alerta("Informa: Em implantacao.")
			/*
			IF !UsaArquivo("CHEMOV") ; Break ; EndIF
			MoviAnual()
			FechaTudo()
			*/
		Case opc = 7.12
			AutoCaixa()
			FechaTudo()
		Case opc = 7.13
			ZeraCaixa()
			FechaTudo()
		Case oPc = 7.14
			CadastroImpressoras()
			FechaTudo()
		Case oPc =7.15
			PrinterDbedit()
			FechaTudo()
		Case oPc = 7.16
			CenturyOn()
			Hard( 3 )
			oMenu:Limpa()
			oMenu:CorCabec := Roloc( oMenu:CorCabec )
			oMenu:StatSup("SOBRE O " + SISTEM_NA1 + " " + SISTEM_VERSAO )
         Info(2)
			CenturyOff()
		Case opc = 8.01
			IntBaseDados()
		Case opc = 8.02
			CriaNewNota()
		Case oPc = 8.03
			 ErrorBeep()
			 IF Conf("Pergunta: Continuar com a opera‡ao ?")
				 CriaNewPrinter()
				 FechaTudo()
				 IF AbreArquivo('PRINTER')
					 oIndice:ProgressoNtx := OK
					 CriaIndice('PRINTER')
					 oIndice:ProgressoNtx := FALSO
					 FechaTudo()
				 EndIF
			 EndIF
		Case oPc = 8.04
			 ErrorBeep()
			 IF Conf("Pergunta: Continuar com a opera‡ao ?")
				 CriaNewEnt()
				 FechaTudo()
				 IF AbreArquivo('ENTNOTA')
					 oIndice:ProgressoNtx := OK
					 CriaIndice('ENTNOTA')
					 oIndice:ProgressoNtx := FALSO
					 FechaTudo()
				 EndIF
			 EndIF
		Case oPc = 8.05
			 ErrorBeep()
			 IF Conf("Pergunta: Continuar com a opera‡ao ?")
				 Fechatudo()
				 IF AbreArquivo('PREVENDA')
					 oIndice:ProgressoNtx := OK
					 oIndice:Compactar	 := OK
					 CriaIndice('PREVENDA')
					 oIndice:ProgressoNtx := FALSO
					 oIndice:Compactar	 := FALSO
                FechaTudo()
				 EndIF
			 EndIF
		Case Opc = 9.01
			Dos()
		Case Opc = 9.02
			Comandos()
		Case opc = 10.01
			oMenu:Limpa()
			oMenu:CorCabec := Roloc( oMenu:CorCabec )
			oMenu:StatSup("SOBRE O " + SISTEM_NA1 + " " + SISTEM_VERSAO )
         Info(2)
		Case oPc = 10.02
			Novidades()
		Case oPc = 10.03
			Help()
		EndCase
	Recover
		//NNetTtsAb()
		FechaTudo()
	End Sequence
EndDo
Encerra()

Proc SetaClasse()
*****************
LOCAL cSn1 := SISTEM_NA1
LOCAL cSn2 := SISTEM_NA2
LOCAL cSn3 := SISTEM_NA3
LOCAL cSn4 := SISTEM_NA4
LOCAL cSn5 := SISTEM_NA5
LOCAL cSn6 := SISTEM_NA6
LOCAL cSv  := SISTEM_VERSAO
LOCAL cSp  := Space(1)
LOCAL cSt1 := "F1-HELP³F5-PRECOS³F10-CALC³"
LOCAL cSt2 := "F1-HELP³F5-LISTA³F8-SPOOL³ESC-RETORNA³"
LOCAL cSt3 := "F1-HELP³F5-LISTA³F8-SPOOL³ESC-RETORNA³"
LOCAL cSt4 := "F1-HELP³F5-LISTA³F8-SPOOL³ESC-RETORNA³"
LOCAL cSt5 := "F1-HELP³F5-LISTA³F8-SPOOL³ESC-RETORNA³"
LOCAL cSt6 := "F1-HELP³F5-LISTA³F8-SPOOL³ESC-RETORNA³"

oMenu:StSupArray               := { cSn1+cSp+cSv, cSn2+cSp+cSv,cSn3+cSp+cSv,cSn4+cSp+cSv,cSn5+cSp+cSv,cSn6+cSp+cSv }
oMenu:StInfArray               := { cSt1, cSt2, cSt3, cSt4, cSt5, cSt6 }
oMenu:MenuArray                := { oSciMenuSci(), oMenuTesteLan(),   oMenuRecelan(),   oMenuPagaLan(),   oMenuChelan(),   oMenuVenLan() }
oMenu:DispArray                := { aDispSci(),    aDispTesteLan(),   aDispRecelan(),   aDispPagaLan(),   aDispChelan(),   aDispVenLan() }
//oMenu:LetraHotKeyArray         := { aLtHKSci(),    aLtHKTesteLan(),   aLtHKRecelan(),   aLtHKPagaLan(),   aLtHKChelan(),   aLtHKVenLan() }
//oMenu:LetraLightBarHotKeyArray := { aLtLBHKSci(),  aLtLBHKTesteLan(), aLtLBHKRecelan(), aLtLBHKPagaLan(), aLtLBHKChelan(), aLtLBHKVenLan() }
Return

Proc RefreshClasse()
********************
oMenu:StatusSup		          := oMenu:StSupArray[1]
oMenu:StatusInf	           	 := oMenu:StInfArray[1]
oMenu:Menu		           	 	 := oMenu:MenuArray[1]
oMenu:Disp				          := oMenu:DispArray[1]
//oMenu:LetraHotKeyArray         := oMenu:LetraHotKeyArray[1]
//oMenu:LetraLightBarHotKeyArray := oMenu:LetraLightBarHotKeyArray[1]
Return

Function SetaIni()
******************
oMenu:Frame 				 := oIni:ReadString( oAmbiente:xUsuario,  'frame',         oAmbiente:Frame )
oMenu:PanoFundo			 := oIni:ReadString( oAmbiente:xUsuario,  'panofundo',     oAmbiente:PanoFundo )
oMenu:CorMenu				 := oIni:ReadInteger( oAmbiente:xUsuario, 'cormenu',       oAmbiente:CorMenu )
oMenu:CorMsg				 := oIni:ReadInteger( oAmbiente:xUsuario, 'cormsg',        oAmbiente:CorMsg )
oMenu:CorFundo 			 := oIni:ReadInteger( oAmbiente:xUsuario, 'corfundo',      oAmbiente:Corfundo )
oMenu:CorCabec 			 := oIni:ReadInteger( oAmbiente:xUsuario, 'corcabec',      oAmbiente:CorCabec )
oMenu:CorDesativada		 := oIni:ReadInteger( oAmbiente:xUsuario, 'cordesativada', oAmbiente:CorDesativada )
oMenu:CorBox				 := oIni:ReadInteger( oAmbiente:xUsuario, 'corbox',        oAmbiente:CorBox )
oMenu:CorCima				 := oIni:ReadInteger( oAmbiente:xUsuario, 'corcima',       oAmbiente:CorCima )
oMenu:Selecionado 		 := oIni:ReadInteger( oAmbiente:xUsuario, 'selecionado',   oAmbiente:Selecionado )
oMenu:CorAntiga			 := oIni:ReadInteger( oAmbiente:xUsuario, 'corantiga',     oAmbiente:CorAntiga )
oMenu:CorBorda 			 := oIni:ReadInteger( oAmbiente:xUsuario, 'corborda',      oAmbiente:CorBorda )
oMenu:CorAlerta			 := oIni:ReadInteger( oAmbiente:xUsuario, 'coralerta',     oAmbiente:CorAlerta )
oMenu:Fonte 				 := oIni:ReadInteger( oAmbiente:xUsuario, 'fonte',         oAmbiente:Fonte )
oMenu:FonteManualAltura  := oIni:ReadInteger( oAmbiente:xUsuario, 'FonteManualAltura', oAmbiente:FonteManualAltura )
oMenu:FonteManualLargura := oIni:ReadInteger( oAmbiente:xUsuario, 'FonteManualLargura', oAmbiente:FonteManualLargura )
oMenu:Sombra				:= oIni:ReadBool( oAmbiente:xUsuario,	  'sombra',        oAmbiente:Sombra )
oMenu:CorLightBar       := oIni:ReadInteger( oAmbiente:xUsuario, 'CorLightBar',   oAmbiente:CorLightBar )
oMenu:CorHotKey         := oIni:ReadInteger( oAmbiente:xUsuario, 'CorHotKey',     oAmbiente:CorHotKey )
oMenu:CorHKLightBar     := oIni:ReadInteger( oAmbiente:xUsuario, 'CorHKLightBar', oAmbiente:CorHKLightBar)
oMenu:SetaSombra()

oAmbiente:Get_Ativo           := oIni:ReadBool( oAmbiente:xUsuario,    'get_ativo',     oAmbiente:Get_Ativo )
oAmbiente:Mostrar_Desativados := oIni:ReadBool( "sistema",'Mostrar_Desativados', oAmbiente:Mostrar_Desativados )
oAmbiente:Mostrar_Recibo      := oIni:ReadBool( "sistema",'Mostrar_Recibo', oAmbiente:Mostrar_Recibo )
oAmbiente:Frame               := oMenu:Frame
oAmbiente:PanoFundo     		:= oMenu:PanoFundo
oAmbiente:CorMenu 	      	:= oMenu:CorMenu
oAmbiente:CorLightBar         := oMenu:CorLightBar
oAmbiente:CorHotKey           := oMenu:CorHotKey
oAmbiente:CorHKLightBar       := oMenu:CorHKLightBar
oAmbiente:CorMsg			      := oMenu:CorMsg
oAmbiente:CorFundo		      := oMenu:CorFundo
oAmbiente:CorCabec		      := oMenu:CorCabec
oAmbiente:CorDesativada       := oMenu:CorDesativada
oAmbiente:CorBox			      := oMenu:CorBox
oAmbiente:CorCima 		      := oMenu:CorCima
oAmbiente:Selecionado	      := oMenu:Selecionado
oAmbiente:CorAntiga		      := oMenu:CorAntiga
oAmbiente:CorBorda		      := oMenu:CorBorda
oAmbiente:CorAlerta		      := oMenu:CorAlerta
oAmbiente:Fonte			      := oMenu:Fonte
oAmbiente:FonteManualAltura   := oMenu:FonteManualAltura
oAmbiente:FonteManualLargura  := oMenu:FonteManualLargura
oAmbiente:Sombra			      := oMenu:Sombra
IF oAmbiente:Fonte > 1
	Eval( oAmbiente:TabelaFonte[ oAmbiente:Fonte] )
EndIF
return( NIL)

Proc GeraBatch()
****************
LOCAL Handle
LOCAL xBatch := oAmbiente:xBase + "\SALVA.BAT"

oMenu:Limpa()
Alerta("Este procedimento ira gerar um arquivo para copia;de seguranca externa se porventura tiver algum ;problema ao fazer copia de seguranca interna.")
Ferase( xBatch )
handle := FCreate( xBatch )
IF ( Ferror() != 0 )
	Alert("Erro de Criacao de " + xBatch )
	Return
EndIF
MsWriteLine( Handle, "@ECHO OFF")
MsWriteLine( Handle, "CLS")
MsWriteLine( Handle, Left( oAmbiente:xBase, 2 ))
MsWriteLine( Handle, "CD " + oAmbiente:xBase )
MsWriteLine( Handle, "ECHO ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸")
MsWriteLine( Handle, "ECHO ³ ÝÝÝÝ  ÝÝÝÝMacrosoft           ³Av Castelo Branco, 693 - Pioneiros           ³")
MsWriteLine( Handle, "ECHO ³ ÝÝ ÝÝÝÝ ÝÝ   Informatica      ³Fone (69)3451-3085                           ³")
MsWriteLine( Handle, "ECHO ³ ÝÝ  ÝÝ  ÝÝ      Ltda          ³76976-000/Pimenta Bueno - Rondonia           ³")
MsWriteLine( Handle, "ECHO ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾")
MsWriteLine( Handle, "ECHO ")
MsWriteLine( Handle, "ECHO ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸")
MsWriteLine( Handle, "ECHO ³ Insira o disco de backup no drive A: e tecle ENTER para iniciar             ³")
MsWriteLine( Handle, "ECHO ³                                                                             ³")
MsWriteLine( Handle, "ECHO ³ CUIDADO!! Os dados do drive A: serao todos apagados.                        ³")
MsWriteLine( Handle, "ECHO ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ")
MsWriteLine( Handle, "PAUSE >NUL")
MsWriteLine( Handle, "COMPRIME -EX -RP -SMSIL -&F A:\SCI *.DBF + *.CFG + *.DOC + *.TXT + *.BAT + *.ETI + *.NFF + *.COB + *.DUP")
FClose( Handle )
Alerta("Arquivo criado: " + xBatch + ";Finalize a execucao do sistema e digite SALVA [enter].")
Return

Proc Impressao()
****************
LOCAL GetList := {}
LOCAL cScreen := SaveScreen()
LOCAL Files   := '*.DOC'
LOCAL lCancel := FALSO
LOCAL nTam	  := MaxCol()
LOCAL Arquivo
LOCAL nCopias
LOCAL x
LOCAL Campo
LOCAL Linha
LOCAL Linhas
LOCAL Imprime

Arquivo := Space( 24 )
MaBox( 16, 10, 18, 61 )
@ 17, 11 Say "Arquivo a Imprimir..:" Get Arquivo PICT "@!"
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
FChDir( oAmbiente:xBaseDoc )
Set Defa To ( oAmbiente:xBaseDoc )
IF Empty( Arquivo )
	M_Title( "Setas CIMA/BAIXO Move")
	Arquivo := Mx_PopFile( 03, 10, 15, 61, Files, Cor())
	IF Empty( Arquivo )
		FChDir( oAmbiente:xBaseDados )
		Set Defa To ( oAmbiente:xBaseDados )
		ErrorBeep()
		ResTela( cScreen )
		Return
  EndIF
Else
	IF !File( Arquivo )
		FChDir( oAmbiente:xBaseDados )
		Set Defa To ( oAmbiente:xBaseDados )
		ErrorBeep()
		ResTela( cScreen )
		Alert( Rtrim( Arquivo ) + " Nao Encontrado... " )
		ResTela( cScreen )
		Return
	EndIF
EndIF
nCopias := 1
MaBox( 19, 10, 21, 31 )
@ 20, 11 SAY "Qtde Copias...:" Get nCopias PICT "999" Valid nCopias > 0
Read
IF LastKey() = 27 .OR. !Instru80()
	FChDir( oAmbiente:xBaseDados )
	Set Defa To ( oAmbiente:xBaseDados )
	ResTela( cScreen )
	Return
EndIF
Mensagem("Aguarde, Imprimindo", Cor())
PrintOn()
SetPrc( 0, 0 )
For X := 1 To nCopias
	 Campo	  := MemoRead( Arquivo )
	 Linhas	  := MlCount( Campo, 80 )
	 For Linha := 1 To Linhas
		 Imprime := MemoLine( Campo, 80, linha )
		 Write( 0 + Linha -1, 0, Imprime )
	 Next
	 __Eject()
Next
PrintOff()
FChDir( oAmbiente:xBaseDados )
Set Defa To ( oAmbiente:xBaseDados )
ResTela( cScreen )
Return

Function Seta( Mode, Line, Col )
********************************
Do Case
Case Mode = 0
	Return(0)

Case LastKey() = -1	 && F2	GRAVA E SAI
	Return( 23 )

OtherWise
	Return(0)

EndCase

Function ArrayIndices()
**********************
LOCAL aArquivos := {}
Aadd( aArquivos, { "NOTA",      "NOTA1", "NOTA2", "NOTA3"})
Aadd( aArquivos, { "LISTA",     "LISTA1", "LISTA2", "LISTA3","LISTA4","LISTA5","LISTA6","LISTA7","LISTA8","LISTA9","LISTA10","LISTA11"})
Aadd( aArquivos, { "SAIDAS",    "SAIDAS1","SAIDAS2","SAIDAS3","SAIDAS4","SAIDAS5","SAIDAS6","SAIDAS7"})
Aadd( aArquivos, { "RECEBER",   "RECEBER1","RECEBER2","RECEBER3", "RECEBER4", "RECEBER5","RECEBER6","RECEBER7","RECEBER8"})
Aadd( aArquivos, { "REPRES",    "REPRES1","REPRES2","REPRES3"})
Aadd( aArquivos, { "GRUPO",     "GRUPO1","GRUPO2"})
Aadd( aArquivos, { "SUBGRUPO",  "SUBGRUPO1"})
Aadd( aArquivos, { "VENDEDOR",  "VENDEDO1","VENDEDO2"})
Aadd( aArquivos, { "VENDEMOV",  "VENDEMO1","VENDEMO2","VENDEMO3","VENDEMO4", "VENDEMO5", "VENDEMO6"})
Aadd( aArquivos, { "RECEMOV",   "RECEMOV1","RECEMOV2","RECEMOV3","RECEMOV4","RECEMOV5","RECEMOV6","RECEMOV7", "RECEMOV8","RECEMOV9", "RECEMOV10"})
Aadd( aArquivos, { "ENTRADAS",  "ENTRADA1","ENTRADA2","ENTRADA3","ENTRADA4"})
Aadd( aArquivos, { "PAGAR",     "PAGAR1","PAGAR2","PAGAR3"})
Aadd( aArquivos, { "PAGAMOV",   "PAGAMOV1","PAGAMOV2","PAGAMOV3","PAGAMOV4"})
Aadd( aArquivos, { "TAXAS",     "TAXAS1","TAXAS2"})
Aadd( aArquivos, { "PAGO",      "PAGO1","PAGO2","PAGO3"})
Aadd( aArquivos, { "RECEBIDO",  "RECEBID1","RECEBID2","RECEBID3","RECEBID4","RECEBID5","RECEBID6","RECEBID7","RECEBID8","RECEBID9","RECEBID10","RECEBID11"})
Aadd( aArquivos, { "CHEQUE",    "CHEQUE1","CHEQUE2","CHEQUE3"})
Aadd( aArquivos, { "CHEMOV",    "CHEMOV1","CHEMOV2","CHEMOV3","CHEMOV4","CHEMOV5","CHEMOV6"})
Aadd( aArquivos, { "CHEPRE",    "CHEPRE1","CHEPRE2","CHEPRE3","CHEPRE4", "CHEPRE5"})
Aadd( aArquivos, { "USUARIO",   "USUARIO1"})
Aadd( aArquivos, { "FORMA",     "FORMA1"})
Aadd( aArquivos, { "CURSOS",    "CURSOS1"})
Aadd( aArquivos, { "CURSADO",   "CURSADO1","CURSADO2","CURSADO3"})
Aadd( aArquivos, { "REGIAO",    "REGIAO1", "REGIAO2"})
Aadd( aArquivos, { "CEP",       "CEP1", "CEP2"})
Aadd( aArquivos, { "PONTO",     "PONTO1", "PONTO2", "PONTO3"})
Aadd( aArquivos, { "SERVIDOR",  "SERVIDO1", "SERVIDO2"})
Aadd( aArquivos, { "PRINTER",   "PRINTER1", "PRINTER2"})
Aadd( aArquivos, { "ENTNOTA",   "ENTNOTA1", "ENTNOTA2", "ENTNOTA3","ENTNOTA4"})
Aadd( aArquivos, { "CONTA",     "CONTA1"})
Aadd( aArquivos, { "SUBCONTA",  "SUBCONT1", "SUBCONT2"})
Aadd( aArquivos, { "RETORNO",   "RETORNO1"})
Aadd( aArquivos, { "PREVENDA",  "PREVEND1","PREVEND2","PREVEND3"})
Aadd( aArquivos, { "CORTES",    "CORTES1"})
Aadd( aArquivos, { "SERVICO",   "SERVICO1", "SERVICO2"})
Aadd( aArquivos, { "MOVI",      "MOVI1", "MOVI2","MOVI3","MOVI4"})
Aadd( aArquivos, { "FUNCIMOV",  "FUNCIMO1", "FUNCIMO2","FUNCIMO3"})
Aadd( aArquivos, { "GRPSER",    "GRPSER1", "GRPSER2"})
Aadd( aArquivos, { "RECIBO",    "RECIBO1","RECIBO2","RECIBO3", "RECIBO4", "RECIBO5", "RECIBO6","RECIBO7","RECIBO8","RECIBO9","RECIBO10"})
Aadd( aArquivos, { "AGENDA",    "AGENDA1","AGENDA2","AGENDA3", "AGENDA4", "AGENDA5", "AGENDA6", "AGENDA7"})
Aadd( aArquivos, { "CM",        "CM1","CM2","CM2","CM3"})
//Aadd( aArquivos, { "EMPRESA",   "EMPRESA1"})
Return( aArquivos )

Function VerIndice()
********************
LOCAL lReindexar := FALSO
LOCAL aIndice	  := ArrayIndices()
LOCAL cDbf
LOCAL cLocalDbf
LOCAL cIndice
LOCAL nTodos
LOCAL nX

oReindexa := TIniNew( oAmbiente:xBaseDados + "\REINDEXA.INI")
oMenu:Limpa()
nTodos := Len( aIndice )
#IFDEF FOXPRO
	For nX := 1 To nTodos
		cDbf		 := aIndice[nX,1]
		cLocalDbf := cDbf + '.DBF'
		cIndice	 := cDbf + '.' + CEXT
		IF !File( cIndice )
			IF !AbreArquivo( cDbf )
				Return( FALSO )
			EndIF
			CriaIndice( cDbf )
		Else
			IF !oReindexa:ReadBool('reindexando', cLocalDbf, FALSO )
				ErrorBeep()
				IF Conf('Erro: Arquivo ' + cDbf + ' nao foi reindexado com sucesso. Reindexar agora ?')
					IF !AbreArquivo( cDbf )
						Return( FALSO )
					EndIF
				  CriaIndice( cDbf )
				EndIF
			EndIF
		EndIF
	Next
#ELSE
	For nX := 1 To nTodos
		cDbf		 := aIndice[nX,1]
		cLocalDbf := cDbf + '.DBF'
		nLen		 := Len(aIndice[nX])
		For nY := 2 To nLen
			cIndice := aIndice[nX, nY ]
			IF !File( cIndice + '.' + CEXT )
				IF !AbreArquivo( cDbf )
					Return( FALSO )
				EndIF
				CriaIndice( cDbf )
				Exit
			Else
				IF !oReindexa:ReadBool('reindexando', cLocalDbf, FALSO )
					IF !AbreArquivo( cDbf )
						Return( FALSO )
					EndIF
					CriaIndice( cDbf )
					Exit
				EndIF
			EndIF
		Next
	Next
#ENDIF
IF oIndice:Reindexado
	Return(OK)
EndIF
ErrorBeep()
IF !Conf("Pergunta: Deseja entrar sem reindexar ?")
	IF MenuIndice()
		CriaIndice()
	Else
		Return( FALSO )
	EndIF
EndIF
Return(OK)

Function AbreArquivo( cArquivo )
********************************
LOCAL cTela  := Mensagem(" Aguarde... Verificando Arquivos.", WARNING, _LIN_MSG )
LOCAL nQt
LOCAL nPos
LOCAL nQtArquivos
LOCAL aArquivos

// FechaTudo()
aArquivos := ArrayArquivos()
IF cArquivo != NIL
	nPos := Ascan( aArquivos,{ |oBloco|oBloco[1] = cArquivo })
	IF nPos != 0
		cArquivo := aArquivos[nPos,1]
		IF !NetUse( cArquivo, MONO )
			ResTela( cTela )
			Return(FALSO)
		EndIF
		Return( OK )
	EndIF
	Return( FALSO )
EndIF
nQtArquivos := Len( aArquivos )
For nQt := 1 To nQtArquivos
	cArquivo := aArquivos[nQt,1]
	IF !NetUse( cArquivo, MONO )
		ResTela( cTela )
		Return(FALSO)
	EndIF
Next
ResTela( cTela )
Return( OK )

Function CriaIndice( cDbf )
***************************
LOCAL cScreen						:= SaveScreen()
LOCAL nY 							:= 0
LOCAL lRetornaArrayDeArquivos := OK
LOCAL nTodos						:= 0
LOCAL nPos							:= 0
LOCAL cLocalDbf					:= ''
LOCAL cLocalNtx					:= ''
LOCAL aProc 						:= {}
		Aadd( aProc, {"CHEMOV",   {||Re_Chemov()}})
		Aadd( aProc, {"SAIDAS",   {||Re_Saidas()}})
		Aadd( aProc, {"RECEBIDO", {||Re_Recebido()}})
		Aadd( aProc, {"LISTA",    {||Re_Lista()}})
		Aadd( aProc, {"CEP",      {||Re_Cep()}})
		Aadd( aProc, {"CHEQUE",   {||Re_Cheque()}})
		Aadd( aProc, {"CHEPRE",   {||Re_Chepre()}})
		Aadd( aProc, {"CONTA",    {||Re_Conta()}})
		Aadd( aProc, {"CORTES",   {||Re_Cortes()}})
		Aadd( aProc, {"CURSOS",   {||Re_Cursos()}})
		Aadd( aProc, {"CURSADO",  {||Re_Cursado()}})
		Aadd( aProc, {"ENTRADAS", {||Re_Entradas()}})
		Aadd( aProc, {"FORMA",    {||Re_Forma()}})
		Aadd( aProc, {"FUNCIMOV", {||Re_Funcimov()}})
		Aadd( aProc, {"GRUPO",    {||Re_Grupo()}})
		Aadd( aProc, {"GRPSER",   {||Re_GrpSer()}})
		Aadd( aProc, {"MOVI",     {||Re_Movi()}})
		Aadd( aProc, {"ENTNOTA",  {||Re_EntNota()}})
		Aadd( aProc, {"NOTA",     {||Re_Nota()}})
		Aadd( aProc, {"PAGAR",    {||Re_Pagar()}})
		Aadd( aProc, {"PAGAMOV",  {||Re_Pagamov()}})
		Aadd( aProc, {"PAGO",     {||Re_Pago()}})
		Aadd( aProc, {"PREVENDA", {||Re_Prevenda()}})
		Aadd( aProc, {"PRINTER",  {||Re_Printer()}})
		Aadd( aProc, {"PONTO",    {||Re_Ponto()}})
		Aadd( aProc, {"RECEMOV",  {||Re_Recemov()}})
		Aadd( aProc, {"REGIAO",   {||Re_Regiao()}})
		Aadd( aProc, {"RECEBER",  {||Re_Receber()}})
		Aadd( aProc, {"REPRES",   {||Re_Representante()}})
		Aadd( aProc, {"RETORNO",  {||Re_Retorno()}})
		Aadd( aProc, {"SERVICO",  {||Re_Servico()}})
		Aadd( aProc, {"SERVIDOR", {||Re_Servidor()}})
		Aadd( aProc, {"SUBCONTA", {||Re_SubConta()}})
		Aadd( aProc, {"SUBGRUPO", {||Re_SubGrupo()}})
		Aadd( aProc, {"TAXAS",    {||Re_Taxas()}})
		Aadd( aProc, {"USUARIO",  {||Re_Usuario()}})
		Aadd( aProc, {"VENDEDOR", {||Re_Vendedor()}})
		Aadd( aProc, {"VENDEMOV", {||Re_Vendemov()}})
      Aadd( aProc, {"RECIBO",   {||Re_Recibo()}})
      Aadd( aProc, {"AGENDA",   {||Re_Agenda()}})
      Aadd( aProc, {"CM",       {||Re_Cm()}})

nTodos := Len( aProc )
//----------------------------------------------------------------//
Aeval( Directory( "*.$$$"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.TMP"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.BAK"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.MEM"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T0*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T1*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T2*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*."),    { | aFile | Ferase( aFile[ F_NAME ] )})
//-----------------------------------------------------------------//
oMenu:Limpa()
oReindexa := TIniNew( oAmbiente:xBaseDados + "\REINDEXA.INI")
cDbf		 := IF( cDbf != NIL, Upper( cDbf ), NIL )
IF cDbf = NIL
	Aeval( Directory( "*.NSX"), { | aFile | Ferase( aFile[ F_NAME ] )})
	Aeval( Directory( "*.CDX"), { | aFile | Ferase( aFile[ F_NAME ] )})
	Aeval( Directory( "*.NTX"), { | aFile | Ferase( aFile[ F_NAME ] )})
EndIF
IF cDbf != NIL
	nPos := Ascan( aProc,{ |oBloco|oBloco[1] = cDbf })
	IF nPos != 0
		cLocalDbf := aProc[nPos,1] + '.DBF'
		cLocalNtx := aProc[nPos,1] + '.' + CEXT
		Ferase( cLocalNtx )
		oReindexa:WriteBool('reindexando', cLocalDbf, FALSO )
		Eval( aProc[ nPos, 2 ] )
		oReindexa:WriteBool('reindexando', cLocalDbf, OK )
		ResTela( cScreen )
		Mensagem("Aguarde, Fechando Arquivos.", WARNING, _LIN_MSG )
		ResTela( cScreen )
		FechaTudo()
		return(nil)
	EndIF
EndIF
FechaTudo()
oIndice:Limpa()
For nY := 1 To nTodos
	cDbf		 := aProc[ nY, 1 ]
	cLocalDbf := cDbf + '.DBF'
	IF AbreArquivo( cDbf )
		oReindexa:WriteBool('reindexando', cLocalDbf, FALSO )
		Eval( aProc[ nY, 2 ] )
		oReindexa:WriteBool('reindexando', cLocalDbf, OK )
	EndIF
Next
ResTela( cScreen )
Mensagem("Aguarde, Fechando Arquivos.", WARNING, _LIN_MSG )
ResTela( cScreen )
FechaTudo()
return(nil)

Proc Re_Cortes()
****************
oIndice:DbfNtx("CORTES")
oIndice:PackDbf("CORTES")
oIndice:AddNtx("Tabela", "CORTES1", "CORTES" )
oIndice:CriaNtx()
Return

Proc Re_GrpSer()
****************
oIndice:DbfNtx("GRPSER")
oIndice:PackDbf("GRPSER")
oIndice:AddNtx("Grupo",    "GRPSER1", "GRPSER" )
oIndice:AddNtx("DesGrupo", "GRPSER2", "GRPSER" )
oIndice:CriaNtx()
Return

Proc Re_Servico()
*****************
oIndice:DbfNtx("SERVICO")
oIndice:PackDbf("SERVICO")
oIndice:AddNtx("CodiSer", "SERVICO1", "SERVICO" )
oIndice:AddNtx("Nome",    "SERVICO2", "SERVICO" )
oIndice:CriaNtx()
Return

Proc Re_Movi()
**************
oIndice:DbfNtx("MOVI")
oIndice:PackDbf("MOVI")
oIndice:AddNtx("Tabela",  "MOVI1", "MOVI" )
oIndice:AddNtx("Codiven+Left(Tabela,4)+CodiSer", "MOVI2", "MOVI" )
oIndice:AddNtx("Data",     "MOVI3", "MOVI" )
oIndice:AddNtx("Codiven+DateToStr(Data)", "MOVI4", "MOVI" )
oIndice:CriaNtx()
Return

Proc Re_Funcimov()
******************
oIndice:DbfNtx("FUNCIMOV")
oIndice:PackDbf("FUNCIMOV")
oIndice:AddNtx("Data",    "FUNCIMO1", "FUNCIMOV" )
oIndice:AddNtx("Docnr",   "FUNCIMO2", "FUNCIMOV" )
oIndice:AddNtx("Codiven+DateToStr(Data)", "FUNCIMO3", "FUNCIMOV" )
oIndice:CriaNtx()
Return

Proc Re_Retorno()
*****************
oIndice:DbfNtx("RETORNO")
oIndice:PackDbf("RETORNO")
oIndice:AddNtx("Codi", "RETORNO1", "RETORNO" )
oIndice:CriaNtx()
Return

Proc Re_Conta()
***************
oIndice:DbfNtx("CONTA")
oIndice:PackDbf("CONTA")
oIndice:AddNtx("Codi", "CONTA1", "CONTA" )
oIndice:CriaNtx()
Return

Proc Re_SubConta()
***************
oIndice:DbfNtx("SUBCONTA")
oIndice:PackDbf("SUBCONTA")
oIndice:AddNtx("Codi",   "SUBCONT1", "SUBCONTA" )
oIndice:AddNtx("SubCodi","SUBCONT2", "SUBCONTA" )
oIndice:CriaNtx()
Return

Proc Re_Cep()
*************
oIndice:DbfNtx("CEP")
oIndice:PackDbf("CEP")
oIndice:AddNtx("Cep",  "CEP1", "CEP" )
oIndice:AddNtx("Cida", "CEP2", "CEP" )
oIndice:CriaNtx()
Return

Proc Re_Usuario()
*****************
oIndice:DbfNtx("USUARIO")
oIndice:PackDbf("USUARIO")
oIndice:AddNtx("Nome", "USUARIO1", "USUARIO" )
oIndice:CriaNtx()
Return

Proc Re_Forma()
**************
oIndice:DbfNtx("FORMA")
oIndice:PackDbf("FORMA")
oIndice:AddNtx("Forma", "FORMA1", "FORMA" )
oIndice:CriaNtx()
Return

Proc Re_Cursos()
****************
oIndice:DbfNtx("CURSOS")
oIndice:PackDbf("CURSOS")
oIndice:AddNtx("Curso", "CURSOS1", "CURSOS" )
oIndice:CriaNtx()
Return

Proc Re_Cursado()
*****************
oIndice:DbfNtx("CURSADO")
oIndice:PackDbf("CURSADO")
oIndice:AddNtx( "Curso",   "CURSADO1", "CURSADO" )
oIndice:AddNtx( "Codi",    "CURSADO2", "CURSADO" )
oIndice:AddNtx( "Fatura",  "CURSADO3", "CURSADO" )
oIndice:CriaNtx()
Return

Proc Re_Regiao()
****************
oIndice:DbfNtx("REGIAO")
oIndice:PackDbf("REGIAO")
oIndice:AddNtx("Regiao", "REGIAO1", "REGIAO" )
oIndice:AddNtx("Nome",   "REGIAO2", "REGIAO" )
oIndice:CriaNtx()
Return

Proc Re_SubGrupo()
*******************
oIndice:DbfNtx("SUBGRUPO")
oIndice:PackDbf("SUBGRUPO")
oIndice:AddNtx("codsgrupo","SUBGRUPO1", "SUBGRUPO" )
oIndice:CriaNtx()
Return

Proc Re_Nota()
**************
oIndice:DbfNtx("NOTA")
oIndice:PackDbf("NOTA")
oIndice:AddNtx("Numero", "NOTA1", "NOTA" )
oIndice:AddNtx("Codi",   "NOTA2", "NOTA" )
oIndice:AddNtx("Data",   "NOTA3", "NOTA" )
oIndice:CriaNtx()
Return

Proc Re_EntNota()
*****************
oIndice:DbfNtx("ENTNOTA")
oIndice:PackDbf("ENTNOTA")
oIndice:AddNtx("Data",   "ENTNOTA1", "ENTNOTA" )
oIndice:AddNtx("Codi",   "ENTNOTA2", "ENTNOTA" )
oIndice:AddNtx("Numero", "ENTNOTA3", "ENTNOTA" )
oIndice:AddNtx("Entrada","ENTNOTA4", "ENTNOTA" )
oIndice:CriaNtx()
Return

Proc Re_Printer()
*****************
oIndice:Limpa()
oIndice:DbfNtx("PRINTER")
oIndice:PackDbf("PRINTER")
oIndice:AddNtx("Codi", "PRINTER1", "PRINTER" )
oIndice:AddNtx("Nome", "PRINTER2", "PRINTER" )
oIndice:CriaNtx()
Return

Proc Re_Grupo()
***************
oIndice:DbfNtx("GRUPO")
oIndice:PackDbf("GRUPO")
oIndice:AddNtx("CodGrupo","GRUPO1", "GRUPO" )
oIndice:AddNtx("DesGrupo","GRUPO2", "GRUPO" )
oIndice:CriaNtx()
Return

Proc Re_Taxas()
***************
oIndice:DbfNtx("TAXAS")
oIndice:PackDbf("TAXAS")
oIndice:AddNtx("Dini", "TAXAS1", "TAXAS" )
oIndice:AddNtx("DFim", "TAXAS2", "TAXAS" )
oIndice:CriaNtx()
Return

Proc Re_Vendedor()
******************
oIndice:DbfNtx("VENDEDOR")
oIndice:PackDbf("VENDEDOR")
oIndice:AddNtx("Codiven", "VENDEDO1", "VENDEDOR" )
oIndice:AddNtx("nome",    "VENDEDO2", "VENDEDOR" )
oIndice:CriaNtx()
Return

Proc Re_Ponto()
***************
oIndice:DbfNtx("PONTO")
oIndice:PackDbf("PONTO")
oIndice:AddNtx("Codi",  "PONTO1",             "PONTO" )
oIndice:AddNtx("Data",  "PONTO2",             "PONTO" )
oIndice:AddNtx("Codi + DateToStr( Data)","PONTO3", "PONTO" )
oIndice:CriaNtx()
Return

Proc Re_Cheque()
****************
oIndice:DbfNtx("CHEQUE")
oIndice:PackDbf("CHEQUE")
oIndice:AddNtx("Codi",    "CHEQUE1", "CHEQUE" )
oIndice:AddNtx("Titular", "CHEQUE2", "CHEQUE" )
oIndice:AddNtx("Horario", "CHEQUE3", "CHEQUE" )
oIndice:CriaNtx()
Return

Proc Re_Receber()
*****************
oIndice:DbfNtx("RECEBER")
oIndice:PackDbf("RECEBER")
oIndice:AddNtx("nome",                "RECEBER1", "RECEBER" )
oIndice:AddNtx("codi",                "RECEBER2", "RECEBER" )
oIndice:AddNtx("cida",                "RECEBER3", "RECEBER" )
oIndice:AddNtx("Regiao",              "RECEBER4", "RECEBER" )
oIndice:AddNtx("Esta+DateToStr(Data)","RECEBER5", "RECEBER" )
oIndice:AddNtx("Fanta",               "RECEBER6", "RECEBER" )
oIndice:AddNtx("Bair+Ende",           "RECEBER7", "RECEBER" )
oIndice:AddNtx("Ende",                "RECEBER8", "RECEBER" )
oIndice:CriaNtx()
Return

Proc Re_Representante()
***********************
oIndice:DbfNtx("REPRES")
oIndice:PackDbf("REPRES")
oIndice:AddNtx("nome",      "REPRES1", "REPRES" )
oIndice:AddNtx("Repres",    "REPRES2", "REPRES" )
oIndice:AddNtx("cida+nome", "REPRES3", "REPRES" )
oIndice:CriaNtx()
Return

Proc Re_Pagar()
***************
oIndice:DbfNtx("PAGAR")
oIndice:PackDbf("PAGAR")
oIndice:AddNtx("nome",      "PAGAR1", "PAGAR")
oIndice:AddNtx("codi",      "PAGAR2", "PAGAR")
oIndice:AddNtx("cida+nome", "PAGAR3", "PAGAR")
oIndice:CriaNtx()
Return

Proc Re_Pagamov()
*****************
oIndice:DbfNtx("PAGAMOV")
oIndice:PackDbf("PAGAMOV")
oIndice:AddNtx("Docnr",              "PAGAMOV1", "PAGAMOV" )
oIndice:AddNtx("Vcto",               "PAGAMOV2", "PAGAMOV" )
oIndice:AddNtx("Codi + DateToStr(Vcto)", "PAGAMOV3", "PAGAMOV" )
oIndice:AddNtx("Codi + DateToStr(Emis)", "PAGAMOV4", "PAGAMOV" )
oIndice:CriaNtx()
Return

Proc Re_Chepre()
****************
oIndice:DbfNtx("CHEPRE")
oIndice:PackDbf("CHEPRE")
oIndice:AddNtx("Codi  + DateToStr(Vcto)",  "CHEPRE1", "CHEPRE" )
oIndice:AddNtx("Docnr + DateToStr(Vcto)",  "CHEPRE2", "CHEPRE" )
oIndice:AddNtx("Praca + DateToStr(Vcto)",  "CHEPRE3", "CHEPRE" )
oIndice:AddNtx("Banco + DateToStr(Vcto)",  "CHEPRE4", "CHEPRE" )
oIndice:AddNtx("DateToStr(Vcto)",          "CHEPRE5", "CHEPRE" )
oIndice:CriaNtx()
Return

Proc Re_Pago()
**************
oIndice:DbfNtx("PAGO")
oIndice:PackDbf("PAGO")
oIndice:AddNtx("Docnr",   "PAGO1", "PAGO" )
oIndice:AddNtx("Datapag", "PAGO2", "PAGO" )
oIndice:AddNtx("Codi + DateToStr( Datapag )", "PAGO3", "PAGO")
oIndice:CriaNtx()
Return

Proc Re_Servidor()
******************
oIndice:DbfNtx("SERVIDOR")
oIndice:PackDbf("SERVIDOR")
oIndice:AddNtx("Nome", "SERVIDO1", "SERVIDOR"  )
oIndice:AddNtx("Codi", "SERVIDO2", "SERVIDOR"  )
oIndice:CriaNtx()
Return

Proc Re_Entradas()
******************
oIndice:DbfNtx("ENTRADAS")
oIndice:PackDbf("ENTRADAS")
oIndice:AddNtx("Codigo+DateToStr(Data)","ENTRADA1", "ENTRADAS" )
oIndice:AddNtx("Fatura",                "ENTRADA2", "ENTRADAS"  )
oIndice:AddNtx("Data",                  "ENTRADA3", "ENTRADAS"  )
oIndice:AddNtx("Codi",                  "ENTRADA4", "ENTRADAS" )
oIndice:CriaNtx()
Return

Proc Re_Vendemov()
******************
oIndice:DbfNtx("VENDEMOV")
oIndice:PackDbf("VENDEMOV")
oIndice:AddNtx("data",    "VENDEMO1", "VENDEMOV" )
oIndice:AddNtx("docnr",   "VENDEMO2", "VENDEMOV" )
oIndice:AddNtx("Codiven+DateToStr(Data)", "VENDEMO3", "VENDEMOV" )
oIndice:AddNtx("Fatura",  "VENDEMO4", "VENDEMOV"  )
oIndice:AddNtx("Forma",   "VENDEMO5", "VENDEMOV"  )
oIndice:AddNtx("Regiao",  "VENDEMO6", "VENDEMOV"  )
oIndice:CriaNtx()
Return

Proc Re_Recibo()
******************
oIndice:DbfNtx("RECIBO")
oIndice:PackDbf("RECIBO")
oIndice:AddNtx("tipo",       "RECIBO1", "RECIBO" )
oIndice:AddNtx("codi",       "RECIBO2", "RECIBO" )
oIndice:AddNtx("docnr",      "RECIBO3", "RECIBO" )
oIndice:AddNtx("vcto",       "RECIBO4", "RECIBO" )
oIndice:AddNtx("data",       "RECIBO5", "RECIBO" )
oIndice:AddNtx("usuario",    "RECIBO6", "RECIBO"  )
oIndice:AddNtx("caixa",      "RECIBO7", "RECIBO"  )
oIndice:AddNtx("nome",       "RECIBO8", "RECIBO"  )
oIndice:AddNtx("codi+docnr", "RECIBO9", "RECIBO"  )
oIndice:AddNtx("fatura",     "RECIBO10", "RECIBO"  )
oIndice:CriaNtx()
Return

Proc Re_Agenda()
****************
oIndice:DbfNtx("AGENDA")
oIndice:PackDbf("AGENDA")
oIndice:AddNtx("codi",    "AGENDA1", "AGENDA" )
oIndice:AddNtx("hist",    "AGENDA2", "AGENDA" )
oIndice:AddNtx("data",    "AGENDA3", "AGENDA" )
oIndice:AddNtx("usuario", "AGENDA4", "AGENDA"  )
oIndice:AddNtx("caixa",   "AGENDA5", "AGENDA"  )
oIndice:AddNtx("Codi+DateToStr(Data)", "AGENDA6", "AGENDA" )
oIndice:AddNtx("DateToStr(Data)+Codi", "AGENDA7", "AGENDA" )
oIndice:CriaNtx()
Return

Proc Re_Cm()
************
oIndice:DbfNtx("CM")
oIndice:PackDbf("CM")
oIndice:AddNtx("inicio",  "CM1", "CM" )
oIndice:AddNtx("fim",     "CM2", "CM" )
oIndice:AddNtx("DateToStr(inicio)", "CM3", "CM" )
oIndice:AddNtx("DateToStr(fim)",    "CM4", "CM" )
oIndice:CriaNtx()
Return

Proc Re_Chemov()
****************
oIndice:DbfNtx("CHEMOV")
oIndice:PackDbf("CHEMOV")
oIndice:AddNtx("docnr",  "CHEMOV1", "CHEMOV"  )
oIndice:AddNtx("data",   "CHEMOV2", "CHEMOV"  )
oIndice:AddNtx("Codi + DateToStr( Data )", "CHEMOV3", "CHEMOV" )
oIndice:AddNtx("Fatura", "CHEMOV4", "CHEMOV"  )
oIndice:AddNtx("Codi + DateToStr( Baixa )", "CHEMOV5", "CHEMOV" )
oIndice:AddNtx("DateToStr( Data ) + Docnr", "CHEMOV6", "CHEMOV" )
oIndice:CriaNtx()
Return

Proc Re_Recemov()
*****************
oIndice:DbfNtx("RECEMOV")
oIndice:PackDbf("RECEMOV")
oIndice:AddNtx("Docnr",      "RECEMOV1", "RECEMOV" )
oIndice:AddNtx("Codi",       "RECEMOV2", "RECEMOV"  )
oIndice:AddNtx("Vcto",       "RECEMOV3", "RECEMOV"  )
oIndice:AddNtx("Fatura",     "RECEMOV4", "RECEMOV"  )
oIndice:AddNtx("Regiao+Codi","RECEMOV5", "RECEMOV"  )
oIndice:AddNtx("Emis",       "RECEMOV6", "RECEMOV"  )
oIndice:AddNtx("Codiven",    "RECEMOV7", "RECEMOV"  )
oIndice:AddNtx("Tipo+Codi",  "RECEMOV8", "RECEMOV"  )
oIndice:AddNtx("Datapag",    "RECEMOV9", "RECEMOV"  )
oIndice:AddNtx("Codi + DateToStr( Vcto )", "RECEBID10", "RECEMOV" )
oIndice:CriaNtx()
Return

Proc Re_Recebido()
******************
oIndice:DbfNtx("RECEBIDO")
oIndice:PackDbf("RECEBIDO")
oIndice:AddNtx("Docnr",    "RECEBID1", "RECEBIDO"  )
oIndice:AddNtx("DataPag",  "RECEBID2", "RECEBIDO"  )
oIndice:AddNtx("Fatura",   "RECEBID3", "RECEBIDO"  )
oIndice:AddNtx("Codi + DateToStr( Vcto )", "RECEBID4", "RECEBIDO" )
oIndice:AddNtx("CodiVen",  "RECEBID5", "RECEBIDO"  )
oIndice:AddNtx("Port",     "RECEBID6", "RECEBIDO"  )
oIndice:AddNtx("Forma",    "RECEBID7", "RECEBIDO"  )
oIndice:AddNtx("Baixa",    "RECEBID8", "RECEBIDO"  )
oIndice:AddNtx("Regiao",   "RECEBID9", "RECEBIDO"  )
oIndice:AddNtx("Vcto",     "RECEBID10","RECEBIDO"  )
oIndice:AddNtx("Tipo+Codi","RECEBID11","RECEBIDO"  )
oIndice:CriaNtx()
Return

Proc Re_Saidas()
****************
oIndice:DbfNtx("SAIDAS")
oIndice:PackDbf("SAIDAS")
oIndice:AddNtx("Codigo",        "SAIDAS1", "SAIDAS" )
oIndice:AddNtx("Regiao",        "SAIDAS2", "SAIDAS" )
oIndice:AddNtx("Fatura+Codigo", "SAIDAS3", "SAIDAS" )
oIndice:AddNtx("Emis",          "SAIDAS4", "SAIDAS" )
oIndice:AddNtx("Codi",          "SAIDAS5", "SAIDAS" )
oIndice:AddNtx("CodiVen",       "SAIDAS6", "SAIDAS" )
oIndice:AddNtx("Forma",         "SAIDAS7", "SAIDAS" )
oIndice:CriaNtx()
Return

Proc Re_prevenda()
****************
oIndice:DbfNtx("PREVENDA")
oIndice:PackDbf("PREVENDA")
oIndice:AddNtx("Fatura", "PREVEND1", "PREVENDA" )
oIndice:AddNtx("Emis",   "PREVEND2", "PREVENDA" )
oIndice:AddNtx("Codigo", "PREVEND3", "PREVENDA" )
oIndice:CriaNtx()
Return

Proc Re_Lista()
***************
oIndice:DbfNtx("LISTA")
oIndice:PackDbf("LISTA")
oIndice:AddNtx("CodGrupo",                         "LISTA1", "LISTA" )
oIndice:AddNtx("Codigo",                           "LISTA2", "LISTA" )
oIndice:AddNtx("Descricao",                        "LISTA3", "LISTA" )
oIndice:AddNtx("CodGrupo + CodSgrupo + Descricao", "LISTA4", "LISTA" )
oIndice:AddNtx("CodGrupo + CodSgrupo + Codigo",    "LISTA5", "LISTA" )
oIndice:AddNtx("Data",                             "LISTA6", "LISTA")
oIndice:AddNtx("CodGrupo + CodSgrupo + N_Original","LISTA7", "LISTA" )
oIndice:AddNtx("CodsGrupo",                        "LISTA8", "LISTA" )
oIndice:AddNtx("Codi + Descricao",                 "LISTA9", "LISTA" )
oIndice:AddNtx("N_Original",                       "LISTA10","LISTA" )
oIndice:AddNtx("CodeBar",                          "LISTA11","LISTA" )
oIndice:CriaNtx()
Return

Proc FechaTudo()
****************
DbCloseAll()
Return

Function Empresa( cTela	)
*************************
LOCAL cScreen := SaveScreen()
LOCAL GetList := {}
LOCAL cCodi   := Space(4)
LOCAL cScr
LOCAL cCmd
LOCAL cSpooler
LOCAL cHtm
LOCAL cTxt
LOCAL cDoc
LOCAL Var1
LOCAL Var2
LOCAL nTela

oMenu:Limpa()
Info(2)
FechaTudo()
FChDir( oAmbiente:xBase )
Set Defa To ( oAmbiente:xBase )
BcoDados()
WHILE OK
	nTela := MaBox( 02, 10, 06, MaxCol()-15, "SELECIONE EMPRESA" )
	@ 03, 11 Say "Site Dados.: " + oAmbiente:xBase
	@ 04, 11 Say "Codigo.....:" Get cCodi Pict "9999" Valid EmpErrada( @cCodi,,Row()+1, 24 )
	@ 05, 11 Say "Empresa....:"
	Read
	IF LastKey() = ESC
		IF Conf("Pergunta: Encerrar a Execucao do Sistema ?")
			Encerra()
		EndIF
		Loop
	EndIF
	IF Conf('Pergunta: Selecao de Empresa Correta ?')
	   oIni       := TIniNew( oAmbiente:xBase + '\SCI' + oAmbiente:_EMPRESA + '.INI')
		cScr		  := Mensagem("Informa: Aguarde...", Cor())
		Var1		  := oAmbiente:xBase
		cCmd		  := Var1 + '\CMD'
		cDoc		  := Var1 + '\DOC'
      cSpooler   := Var1 + '\SPOOLER'
      cTxt       := Var1 + '\TXT'
      cHtm       := Var1 + '\HTM'
		Var2		  := Var1 + '\EMP' + cCodi

      oMenu:CodiFirma      := cCodi
		oMenu:NomeFirma		:= AllTrim( Empresa->Nome )		
      oAmbiente:RelatorioCabec   := oIni:ReadString('sistema','relatoriocabec', XFANTA   + Space(40-Len(XFANTA)))
      oAmbiente:xFanta           := oIni:ReadString('sistema','fantasia',       XFANTA   + Space(40-Len(XFANTA)))
      oAmbiente:xEmpresa         := oIni:ReadString('sistema','nomeempresa',    XNOMEFIR + Space(40-Len(XNOMEFIR)))
      oAmbiente:xNomefir         := oIni:ReadString('sistema','nomeempresa',    XNOMEFIR + Space(40-Len(XNOMEFIR)))
      oAmbiente:xJuroMesSimples  := oIni:ReadInteger('financeiro','JuroMesSimples', 0)
      oAmbiente:xJuroMesComposto := oIni:ReadInteger('financeiro','JuroMesComposto', 0)
      oAmbiente:xBaseDoc         := cDoc
      oAmbiente:xBaseDados       := Var2		
      oAmbiente:aSciArray[1,SCI_JUROMESSIMPLES]  := Empresa->Juro
      oAmbiente:aSciArray[1,SCI_DIASAPOS]        := Empresa->DiasApos
      oAmbiente:aSciArray[1,SCI_DESCAPOS]        := Empresa->DescApos
      oAmbiente:aSciArray[1,SCI_MULTA]           := Empresa->Multa
      oAmbiente:aSciArray[1,SCI_DIAMULTA]        := Empresa->DiaMulta
      oAmbiente:aSciArray[1,SCI_CARENCIA]        := Empresa->Carencia
      oAmbiente:aSciArray[1,SCI_DESCONTO]        := Empresa->Desconto
      oAmbiente:aSciArray[1,SCI_JUROMESCOMPOSTO] := oAmbiente:xJuroMesComposto		
		aMensagem  := { Empresa->Mens1, Empresa->Mens2, Empresa->Mens3, Empresa->Mens4 }
		aItemNff   := { Empresa->ItemNff }
		aInscMun   := { Empresa->InscMun  }
		aIss		  := { Empresa->Iss	}
		FechaTudo()
      Set Defa To (Var2)
		MkDir( Var2 )
		MkDir( cCmd )
		MkDir( cDoc )
      MkDir( cSpooler )
      MkDir( cTxt )
      MkDir( cHtm )
		ResTela( cScr )

      FChDir( Var2 )
      CriaArquivo()
      return( nil)

      /*
      IF FChDir( Var2 )
			CriaArquivo()
			Exit
		Else
			ErrorBeep()
			ResTela( cScreen )
			Alerta("Erro: Na Criacao do Diretorio de Trabalho...")
			Loop
		EndIF
      */

	EndIF
Enddo

Function EmpErrada( cCodi, cNome, nRow, nCol )
**********************************************
LOCAL aRotina := {{|| CadastraEmpresa() }}
LOCAL Arq_Ant := Alias()
LOCAL Ind_Ant := IndexOrd()
LOCAL Var1
LOCAL Var2

Area("Empresa")
IF !DbSeek( cCodi )
   Escolhe( 00, 00, MaxRow(), "Codi + ' ' + Nome", "CODI NOME DA EMPRESA", aRotina )
EndIF
cCodi := Empresa->Codi
cNome := Empresa->Nome
IF nRow != Nil
	Write( nRow  , nCol, Empresa->Nome )
EndiF
oAmbiente:_Empresa := cCodi
oAmbiente:xEmpresa := Empresa->Nome
oAmbiente:xNomefir := Empresa->Nome
AreaAnt( Arq_Ant, Ind_Ant )
return( OK )

Function CadastraEmpresa()
**************************
LOCAL cScreen := SaveScreen()
LOCAL GetList := {}
LOCAL cCodi   := Space(4)
LOCAL cNome   := Space(40)
LOCAL Var1
LOCAL Var2

Area("Empresa")
WHILE OK
	oMenu:Limpa()
	MaBox( 10, 10, 13, 60 )
	Empresa->(DbGoBoTTom())
	cCodi   := StrZero( Val( Codi ) + 1, 4 )
	cNome   := Space(40)
	@ 11, 11 Say "Codigo :" Get cCodi Pict "9999" Valid EmpCerto( cCodi )
	@ 12, 11 Say "Empresa:" Get cNome Pict "@!"
	Read
	IF LastKey() = ESC
		ResTela( cScreen )
		Exit
	EndIF
	IF Conf("Pergunta: Confirma Inclusao da Empresa ?")
		Area("Empresa")
		DbAppend()
		Empresa->Codi		 := cCodi
		Empresa->Nome		 := cNome
		Empresa->ItemNff	 := 99
	EndIF
EndDo

Function EmpCerto( cCodi )
**************************
LOCAL Arq_Ant := Alias()
LOCAL Ind_Ant := IndexOrd()
LOCAL RetVal  := OK
IF Empty( cCodi )
	ErrorBeep()
   Alerta("ERRO: Codigo Invalido.")
	Return( FALSO )
EndIF
Area("Empresa")
IF DbSeek( cCodi )
	ErrorBeep()
   Alerta("ERRO: Codigo Ja Registrado." )
	RetVal := FALSO
EndIF
AreaAnt( Arq_Ant, Ind_Ant )
Return(RetVal)

Proc BcoDados()
***************
LOCAL cScreen	:= SaveScreen()
LOCAL Dbf1

Dbf1 := {{ "CODI",     "C", 04, 0 },;
			{ "NOME",     "C", 40, 0 },;
			{ "DESCONTO", "N", 06, 2 },;
			{ "DESCAPOS", "N", 06, 2 },;
			{ "MENS1",    "C", 40, 0 },;
			{ "MENS2",    "C", 40, 0 },;
			{ "MENS3",    "C", 40, 0 },;
			{ "MENS4",    "C", 40, 0 },;
			{ "JURO",     "N", 03, 0 },;
			{ "MULTA",    "N", 03, 0 },;
			{ "DIAMULTA", "N", 03, 0 },;
			{ "ITEMNFF",  "N", 03, 0 },; // Quantidade de Items na nff
			{ "INSCMUN",  "C", 15, 0 },; // Inscricao Municipal do Usuario
			{ "ISS",      "N", 05, 2 },; // Percentual do ISS
			{ "CARENCIA", "N", 03, 0 },;
			{ "DIASAPOS", "N", 03, 0 }}
IF !File("EMPRESA.DBF" )
	oMenu:Limpa()
	Mensagem("Aguarde... Gerando o Arquivo EMPRESA", WARNING )
	DbCreate("EMPRESA", Dbf1 )
Else
	IF NetUse("EMPRESA", MULTI )
		Integridade( Dbf1, WARNING, _LIN_MSG )
	Else
		SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
		Cls		
		Quit
	EndIF
EndIF
#IFDEF FOXPRO
	IF !File("EMPRESA." + CEXT )
		oMenu:Limpa()
		Mensagem(" Aguarde... Verificando Arquivos.", WARNING )
		DbCloseAll()
		IF !NetUse("Empresa", FALSO )
			SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
			Cls
			Quit
		EndIF
		MaBox( 10, 10, 13, 42, "EMPRESA" )
		Write( 12, 11, "CODIGO ÄÄÄÄÄÄÄÛ" )
		oIndice:DbfNtx("EMPRESA")
		oIndice:AddNtx("Codi","EMPRESA", "EMPRESA" )
		oIndice:CriaNtx()
	EndIF
	oMenu:Limpa()
	ErrorBeep()
	Mensagem("Aguarde... Verificando os Arquivos.", Cor())
	DbCloseAll()
	Mensagem("Aguarde... Abrindo o Arquivo EMPRESA.", WARNING )
	IF NetUse("Empresa", MULTI )
		DbSetIndex("EMPRESA")
	Else
		SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
		Cls
		Quit
	EndIF
	ResTela( cScreen )
	Return
#ELSE
	IF !File("EMPRESA1." + CEXT )
		oMenu:Limpa()
		Mensagem(" Aguarde... Verificando Arquivos.", WARNING )
		DbCloseAll()
		IF !NetUse("Empresa", FALSO )
			SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
			Cls
			Quit
		EndIF
		oIndice:DbfNtx("EMPRESA")
		oIndice:AddNtx("Codi","EMPRESA1", "EMPRESA" )
		oIndice:CriaNtx()
	EndIF
	oMenu:Limpa()
	ErrorBeep()
	Mensagem("Aguarde... Verificando os Arquivos.", Cor())
	DbCloseAll()
	Mensagem("Aguarde... Abrindo o Arquivo EMPRESA.", WARNING )
	IF NetUse("Empresa", MULTI )
		DbSetIndex("EMPRESA1")
	Else
		SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
		Cls
		Quit
	EndIF
	ResTela( cScreen )
	Return
#ENDIF

Proc PrecosAltera()
*******************
IF !UsaArquivo("PAGAR") ; Break ; EndIF
IF !UsaArquivo("LISTA") ; Break ; EndIF
ConLista()
FechaTudo()
Return

Proc PrecosConsulta()
*********************
LOCAL cScreen := SaveScreen()

#IFDEF CENTRALCALCADOS
	 Return
#ENDIF
IF !UsaArquivo("LISTA")    ; Break ; EndIF
IF !UsaArquivo("ENTRADAS") ; Break ; EndIF
IF !UsaArquivo("SAIDAS")   ; Break ; EndIF
IF !UsaArquivo("PAGAR")    ; Break ; EndIF
SetKey( F5, NIL )
TabPreco()
FechaTudo()
SetKey( F5, {|| PrecosConsulta()})
ResTela( cScreen )
Return

Function Usuario()
******************
LOCAL cScreen   := SaveScreen()
LOCAL cLogin    := Space(10)
LOCAL cPassword := Space(10)

Area("Usuario")
Usuario->(Order( USUARIO_NOME ))
oAmbiente:lGreenCard := FALSO
oMenu:Limpa()
WHILE OK
   cPassword := Space(10)
	MaBox( 10, 20, 13, 48 )
   @ 11, 21 Say "Usuario.:  " Get cLogin    Pict "@!" Valid UsuarioErrado( @cLogin )
   @ 12, 21 Say "Senha...:  " Get cPassWord Pict "@S" Valid SenhaErrada(cLogin, cPassWord)
	Read
	IF LastKey() = ESC
		IF Conf("Pergunta: Encerrar a Execucao do Sistema ?")
         Encerra()
		EndIF
		Loop
	EndIF
   ResTela( cScreen )
   return
EndDo

Function SenhaErrada(cLogin, cPassWord)
***************************************
LOCAL cSenha  := Usuario->( AllTrim( Senha ))
LOCAL cSenha1 := MSEncrypt(StrTran(Dtoc(Date()),'/'))
LOCAL Passe   := MSEncrypt(Alltrim(Upper(cPassword)))
LOCAL xAdmin  := AllTrim( Passe )
LOCAL cLpt1
LOCAL cLpt2
LOCAL cLpt3

IF Alltrim( cLogin ) == "ADMIN" .AND. !Empty( Passe ) .AND. cSenha1 == xAdmin
   oAmbiente:lGreenCard := OK
   Passe                := cSenha
EndIF
IF !Empty( Passe) .AND. cSenha == Passe
   aPermissao := {}
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel1)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel2)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel3)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel4)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel5)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel6)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel7)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel8)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel9)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( Nivel0)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelA)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelB)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelC)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelD)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelE)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelF)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelG)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelH)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelI)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelJ)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelK)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelL)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelM)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelN)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelO)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelP)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelQ)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelR)) = "S", OK, FALSO ))
   Aadd( aPermissao, IF( Usuario->(MSDecrypt( NivelS)) = "S", OK, FALSO ))

   cLpt1 := Usuario->Lpt1
   cLpt2 := Usuario->Lpt2
   cLpt3 := Usuario->Lpt3
   IF Empty( cLpt1 )
      IF Usuario->(TravaReg())
         Usuario->Lpt1 := "06"
         Usuario->Lpt2 := "06"
         Usuario->Lpt3 := "06"
         Usuario->(Libera())
      EndIF
      cLpt1 := "06"
      cLpt2 := "06"
      cLpt3 := "06"
   EndIF
   aLpt1 := {}
   aLpt2 := {}
   aLpt3 := {}
   IF UsaArquivo("PRINTER")
      Printer->(Order( PRINTER_CODI ))
      Printer->(DbGoTop())
      IF Printer->(Eof())
         ArrPrinter()
      EndIF
      IF Printer->(DbSeek( cLpt1 ))
         Aadd( aLpt1, { Printer->Codi, Printer->Nome, Printer->_Cpi10, Printer->_Cpi12, Printer->Gd, Printer->Pq, Printer->Ng, Printer->Nr, ;
                        Printer->Ca, Printer->c18, Printer->LigSub, Printer->DesSub, Printer->_SaltoOff, Printer->_Spaco1_8, ;
                        Printer->_Spaco1_6, Printer->Reseta })
      Else
         Aadd( aLpt1, { NIL, NIL, NIL, NIL, NIL, NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL })
      EndIF
      IF Printer->(DbSeek( cLpt2 ))
         Aadd( aLpt2, { Printer->Codi, Printer->Nome, Printer->_Cpi10, Printer->_Cpi12, Printer->Gd, Printer->Pq, Printer->Ng, Printer->Nr, ;
                        Printer->Ca, Printer->c18, Printer->LigSub, Printer->DesSub, Printer->_SaltoOff, Printer->_Spaco1_8, ;
                        Printer->_Spaco1_6, Printer->Reseta })
      Else
         Aadd( aLpt2, { NIL, NIL, NIL, NIL, NIL, NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL })
      EndIF
      IF Printer->(DbSeek( cLpt3 ))
         Aadd( aLpt3, { Printer->Codi, Printer->Nome, Printer->_Cpi10, Printer->_Cpi12, Printer->Gd, Printer->Pq, Printer->Ng, Printer->Nr, ;
                        Printer->Ca, Printer->c18, Printer->LigSub, Printer->DesSub, Printer->_SaltoOff, Printer->_Spaco1_8, ;
                        Printer->_Spaco1_6, Printer->Reseta })
      Else
         Aadd( aLpt3, { NIL, NIL, NIL, NIL, NIL, NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL })
      EndIF
      Printer->(DbCloseArea())
   EndIF
   oAmbiente:xUsuario := AllTrim( cLogin )
   oAmbiente:ConfAmbiente( oAmbiente:xBase )
   SetaIni()
   Return(OK)
EndIF
cPassword := Space(10)
ErrorBeep()
Alert("ERRO: Senha nao confere.")
Return(FALSO)

Function UsuarioErrado( cNome )
******************************
LOCAL aRotinaInclusao  := NIL
LOCAL aRotinaAlteracao := {{||AltSenha() }}
LOCAL cScreen	        := SaveScreen()
LOCAL Arq_Ant          := Alias()
LOCAL Ind_Ant          := IndexOrd()

Area("Usuario")
( Usuario->(Order( USUARIO_NOME )), Usuario->(DbGoTop()))
IF Usuario->(Eof()) .OR. Usuario->(!DbSeek("ADMIN"))
   GravaSenhaAdmin(OK)
Else
	IF Empty(Usuario->Senha) 
	   GravaSenhaAdmin(FALSO)
	EndIF	
EndIF

IF Usuario->(!DbSeek( cNome ))
   Usuario->(Escolhe( 00, 00, MaxRow(), "Nome", "USUARIO", aRotinaInclusao, NIL, aRotinaAlteracao, NIL, NIL, NIL ))
	cNome := Usuario->Nome
EndIF

AreaAnt( Arq_Ant, Ind_Ant )
return( OK )

Function GravaSenhaAdmin(lIncluirOuAlterar)
*******************************************
LOCAL Arq_Ant := Alias()
LOCAL Ind_Ant := IndexOrd()
LOCAL lDone   := FALSO
LOCAL cPasse
LOCAL cSim

Area("Usuario")
(Usuario->(Order( USUARIO_NOME )), Usuario->(DbGoTop()))
IF lIncluirOuAlterar              // Incluir
	lDone := Usuario->(Incluiu())
Else                              // Alterar
   lDone := Usuario->(TravaReg())		
EndIF
WHILE lDone
	cPasse			 := MSEncrypt("280966")
	cSim				 := MSEncrypt("S")
	Usuario->Nome	 := "ADMIN"
	Usuario->Senha  := cPasse
	Usuario->Nivel1 := cSim
	Usuario->Nivel2 := cSim
	Usuario->Nivel3 := cSim
	Usuario->Nivel4 := cSim
	Usuario->Nivel5 := cSim
	Usuario->Nivel6 := cSim
	Usuario->Nivel7 := cSim
	Usuario->Nivel8 := cSim
	Usuario->Nivel9 := cSim
	Usuario->Nivel0 := cSim
	Usuario->NivelA := cSim
	Usuario->NivelB := cSim
	Usuario->NivelC := cSim
	Usuario->NivelD := cSim
	Usuario->NivelE := cSim
	Usuario->NivelF := cSim
	Usuario->NivelG := cSim
	Usuario->NivelH := cSim
	Usuario->NivelI := cSim
	Usuario->NivelJ := cSim
	Usuario->NivelK := cSim
	Usuario->NivelL := cSim
	Usuario->NivelM := cSim
	Usuario->NivelN := cSim
	Usuario->NivelO := cSim
	Usuario->NivelP := cSim
	Usuario->NivelQ := cSim
	Usuario->NivelR := cSim
	Usuario->NivelS := cSim
	lDone := FALSO
EndDo	
Usuario->(Libera())
AreaAnt( Arq_Ant, Ind_Ant )
return lDone

Function UsuarioCerto( cNome )
******************************
LOCAL Arq_Ant := Alias()
LOCAL Ind_Ant := IndexOrd()

Area("Usuario")
Usuario->(Order( USUARIO_NOME ))
Usuario->(DbGoTop())
IF Usuario->(Eof())
   GravaSenhaAdmin(OK)
EndIF
Return( OK )

Function AbreUsuario()
**********************
Return( UsaArquivo("USUARIO") )

Function Encerra()
******************
FechaTudo()
ScrollDir()
F_Fim( SISTEM_NA1 + " " + SISTEM_VERSAO )
FChDir( oAmbiente:xBase )
SalvaMem()
SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
Cls
DevPos( 24, 0 )
return( __Quit())

Function VerificarUsuario( cNome )
**********************************
LOCAL Arq_Ant := Alias()
LOCAL Ind_Ant := IndexOrd()

Area("Usuario")
Usuario->(Order( USUARIO_NOME ))
IF Usuario->(DbSeek( cNome ))
	ErrorBeep()
	Alerta("Erro: Usuario Ja Registrado.")
	Return( FALSO )
EndIF
Return( OK )

Proc IncluirUsuario( cNome, cSenha1, lOk )
******************************************
LOCAL cScreen := SaveScreen()
LOCAL GetList := {}
LOCAL cSenha2

oMenu:Limpa()
Area("Usuario")
Usuario->(Order( USUARIO_NOME ))
MaBox( 00, 10, 04, 50 )
@ 01, 11 Say "Nome Usuario........: " Get cNome   Pict "@!" Valid VerificarUsuario( cNome ) .AND. !Empty( cNome )
Read
IF LastKey() = ESC
	lOk := FALSO
	ResTela( cScreen )
	Return
EndIF
WHILE OK
	Write( 02, 11, "Nova Senha...........: " )
	Write( 03, 11, "Confirme a Senha.....: " )
	cSenha1 := Senha( 02, 34, 11 )
	cSenha2 := Senha( 03, 34, 11 )
	IF LastKey() = ESC
		ResTela( cScreen )
		Return
	EndIF
	IF Empty( cSenha1 )
		Loop
	EndIF
	IF cSenha1 == cSenha2
		lOk := OK
		ResTela( cScreen )
		Return
	EndIF
	ErrorBeep()
	IF Conf("Erro: Senha nao Confere. Novamente ?")
		Loop
	EndIF
	cNome   := Space(10)
	cSenha1 := ""
	lOk	  := FALSO
	ResTela( cScreen )
	Return
EndDo
ResTela( cScreen )
Return

Proc AltSenha()
***************
LOCAL cNome   := Space(10)
LOCAL lOk     := FALSO
LOCAL Passe   := ''
LOCAL oVenlan := TIniNew( oAmbiente:xBaseDados + "\" + oAmbiente:xUsuario + ".INI")
LOCAL lAdmin  := oVenlan:ReadBool('permissao','usuarioadmin', FALSO )
LOCAL lDireto := FALSO

lDireto := lAdmin
AlterarUsuario( @cNome, @Passe, @lOk, lAdmin, lDireto )
IF !lOK
	Return
Else
  ErrorBeep()
  IF Conf( "Pergunta: Alterar Senha ?")
	  Passe := MSEncrypt( AllTrim( Passe ))
	  IF Usuario->(TravaReg())
		  Usuario->Nome  := cNome
		  Usuario->Senha := Passe
		  Usuario->(Libera())
		  Alerta("Informa: Senha Alterada com sucesso.")
	  EndIF
  EndIF
  Return
EndIF

Proc AlterarUsuario( cNome, cSenha1, lOk, lAdmin, lDireto )
***********************************************************
LOCAL GetList := {}
LOCAL cScreen := SaveScreen()
LOCAL cSenha
LOCAL cSenha2

oMenu:Limpa()
Area("Usuario")
IfNil( lAdmin, FALSO )
IfNil( lDireto, FALSO )
Usuario->(Order( USUARIO_NOME ))
MaBox( 00, 10, 04, 50 )
@ 01, 11 Say "Nome Usuario........: " Get cNome   Pict "@!" Valid UsuarioErrado( @cNome )
Read
IF LastKey() = ESC
	lOk := FALSO
	ResTela( cScreen )
	Return
EndIF
cNome := Alltrim(cNome)
IF !lDireto
   cSenha := Usuario->( AllTrim( Senha ))
   IF lAdmin
      cSenha1 := MSDecrypt( AllTrim( cSenha ))
      lOk     := OK
      ResTela( cScreen )
      Return
   EndIF
EndIF
WHILE OK
   IF !lDireto
      Write( 02, 11, "Verificacao de Senha.: " )
      cSenha1 := Senha( 02, 34, 11 )
      IF LastKey() = ESC
         ResTela( cScreen )
         Return
      EndIF
   EndIF
   IF cSenha == MSEncrypt( AllTrim( cSenha1 )) .OR. lDireto
		WHILE OK
			Write( 02, 11, "Nova Senha...........: " )
			Write( 03, 11, "Confirme a Senha.....: " )
			cSenha1 := Senha( 02, 34, 11 )
			cSenha2 := Senha( 03, 34, 11 )
			IF LastKey() = ESC
				ResTela( cScreen )
				Return
			EndIF
			IF Empty( cSenha1 )
				Loop
			EndIF
			IF cSenha1 == cSenha2
				lOk := OK
				ResTela( cScreen )
				Return
			EndIF
			ErrorBeep()
			IF Conf("Erro: Senha nao Confere. Novamente ?")
				Loop
			EndIF
			cNome   := Space(10)
			cSenha1 := ""
			lOk	  := FALSO
			ResTela( cScreen )
			Return
		EndDo
	EndIF
	ErrorBeep()
	IF Conf("Erro: Senha nao Confere. Novamente ?")
		Loop
	EndIF
	cNome   := Space(10)
	cSenha1 := ""
	lOk	  := FALSO
	ResTela( cScreen )
	Return
EndDo
Return
ResTela( cScreen )

Proc CadastraUsuario( cCodi )
*****************************
LOCAL GetList	  := {}
LOCAL oVenlan	  := TIniNew( oAmbiente:xBaseDados + "\" + oAmbiente:xUsuario + ".INI")
LOCAL lAdmin	  := oVenlan:ReadBool('permissao','usuarioadmin', FALSO )
LOCAL cScreen	  := SaveScreen()
LOCAL aMenu 	  := {" Incluir Usuario",;
							" Alterar Usuario",;
							" Excluir Usuario",;
							" Alterar Senha",;
							" Impressoras Fiscais",;
							" Opcoes de Faturamento",;
							" Controle de Vendedores ",;
							" Controle de Ponto",;
							" Contas a Receber",;
							" Contas a Pagar",;
							" Contas Correntes",;
							" Controle de Producao",;
							" Controle de Estoque",;
							" Menu Principal"}
LOCAL cSenha
LOCAL Arq_Ant	  := Alias()
LOCAL Ind_Ant	  := IndexOrd()
LOCAL lParametro := FALSO
LOCAL lRegistro  := FALSO
LOCAL cEs		  := "S"
LOCAL cRe		  := "S"
LOCA	cPa		  := "S"
LOCAL cCo		  := "S"
LOCAL cVe		  := "S"
LOCAL cVn		  := "S"
LOCAL cUs		  := "S"
LOCAL cPr		  := "S"
LOCAL cInc		  := "S"
LOCAL cDel		  := "S"
LOCAL cDev		  := "S"
LOCAL cEnt		  := "S"
LOCAL cPag		  := "S"
LOCAL cRec		  := "S"
LOCAL cAlt		  := "S"
LOCAL cEmp		  := "S"
LOCAL cTro		  := "S"
LOCAL cFaz		  := "S"
LOCAL cRes		  := "S"
LOCAL cCom		  := "S"
LOCAL cZero 	  := "S"
LOCAL cVista	  := "N"
LOCAL cCadas	  := "S"
LOCAL cLimite	  := "S"
LOCAL cEstorado  := "S"
LOCAL cDescMax   := "S"
LOCAL cFat		  := "S"
LOCAL cDtRec	  := "S"
LOCAL cAtra 	  := "S"
LOCAL nChoice	  := 1
LOCAL cLpt1 	  := "06"
LOCAL cLpt2 	  := "06"
LOCAL cLpt3 	  := "06"

LOCAL cNome 	  := Space(10)
LOCAL Passe
LOCAL lOk

WHILE OK
	lOk := FALSO
	oMenu:Limpa()
	M_Title("INCLUSAO/ALTERACAO DE USUARIO")
	nChoice := FazMenu( 02, 10, aMenu, Cor())
	Do Case
	Case nChoice = 0
		Return

	Case nChoice = 1
		IncluirUsuario( @cNome, @Passe, @lOk )
		IF !lOK
			Return
		EndIF

	Case nChoice = 2
		AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF !lOK
			Return
		EndIF
		cEs		 := MSDecrypt( Nivel1 )
		cRe		 := MSDecrypt( Nivel2 )
		cPa		 := MSDecrypt( Nivel3 )
		cCo		 := MSDecrypt( Nivel4 )
		cVe		 := MSDecrypt( Nivel5 )
		cVn		 := MSDecrypt( Nivel6 )
		cUs		 := MSDecrypt( Nivel7 )
		cPr		 := MSDecrypt( Nivel8 )
		cInc		 := MSDecrypt( Nivel9 )
		cAlt		 := MSDecrypt( Nivel0 )
		cDel		 := MSDecrypt( NivelA )
		cDev		 := MSDecrypt( NivelB )
		cPag		 := MSDecrypt( NivelC )
		cRec		 := MSDecrypt( NivelD )
		cEmp		 := MSDecrypt( NivelE )
		cTro		 := MSDecrypt( NivelF )
		cFaz		 := MSDecrypt( NivelG )
		cRes		 := MSDecrypt( NivelH )
		cCom		 := MSDecrypt( NivelI )
		cZero 	 := MSDecrypt( NivelJ )
		cEstorado := MSDecrypt( NivelK )
		cVista	 := MSDecrypt( NivelL )
		cCadas	 := MSDecrypt( NivelM )
		cLimite	 := MSDecrypt( NivelN )
		cDescMax  := MSDecrypt( NivelO )
		cEnt		 := MSDecrypt( NivelP )
		cFat		 := MSDecrypt( NivelQ )
		cDtRec	 := MSDecrypt( NivelR )
		cAtra 	 := MSDecrypt( NivelS )
		cLpt1 	 := Usuario->Lpt1
		cLpt2 	 := Usuario->Lpt2
		cLpt3 	 := Usuario->Lpt2

	Case nChoice = 3
		Area("USUARIO")
      Escolhe( 00, 00, MaxRow(), "Nome", "USUARIO", {{|| IncluirUsuario( @cNome, @Passe, @lOk)}}, {{|| AlterarUsuario( @cNome, @Passe, @lOk)}})
		Return

	Case nChoice = 4
		AltSenha()
		Loop

	Case nChoice = 5 // Impressoras Fiscais
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfFiscal( cNome )
		EndIF
		Loop

	Case nChoice = 6 // Opcoes de Faturamento
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfOpcoesFaturamento( cNome )
		EndIF
		Loop

	Case nChoice = 7
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfIniVendedores( cNome )
		EndIF
		Loop

	Case nChoice = 8
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfIniPonto( cNome )
		EndIF
		Loop

	Case nChoice = 9 // Contas a Receber
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfIniReceber( cNome )
		EndIF
		Loop
	Case nChoice = 10 // Contas a Pagar
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfIniPagar( cNome )
		EndIF
		Loop
	Case nChoice = 11 // Contas Correntes
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfIniCorrentes( cNome )
		EndIF
		Loop
	Case nChoice = 12 // Controle de Producao
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfIniProducao( cNome )
		EndIF
		Loop
	Case nChoice = 13 // Controle de Estoque
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfIniEstoque( cNome )
		EndIF
		Loop
	Case nChoice = 14 // Menu Principal
      AlterarUsuario( @cNome, @Passe, @lOk, lAdmin )
		IF lOK
			ConfIniSci( cNome )
		EndIF
		Loop
	EndCase
	oMenu:Limpa()
	Area("Usuario")
	Usuario->(Order( USUARIO_NOME ))
	IF CadPermissao( cNome, @cEs, @cRe, @cPa, @cCo, @cVe, @cVn, @cUs, @cPr, @cInc, @cDel, @cDev, @cPag, @cRec, @cAlt, @cEmp, @cTro, @cFaz, @cRes, @cCom, @cZero, @cVista, @cCadas, @cLimite, @cEstorado, @cLpt1, @cLpt2, @cLpt3, @cDescMax, @cEnt, @cFat, @cDtRec, @cAtra )
		ErrorBeep()
		IF Conf( "Pergunta: Incluir/Alterar Usuario ?")
			Passe := MSEncrypt( AllTrim( Passe ))
			IF nChoice = 1
				IF Usuario->(Incluiu())
					Usuario->Nome	:= cNome
					Usuario->Senha := Passe
				EndIF
			Else
				IF Usuario->(TravaReg())
					Usuario->Nome	:= cNome
					Usuario->Senha := Passe
				EndIF
			EndIF
			Usuario->Nivel1 := MSEncrypt( cEs )		 //	1
			Usuario->Nivel2 := MSEncrypt( cRe )		 //	2
			Usuario->Nivel3 := MSEncrypt( cPa )		 //	3
			Usuario->Nivel4 := MSEncrypt( cCo )		 //	4
			Usuario->Nivel5 := MSEncrypt( cVe )		 //	5
			Usuario->Nivel6 := MSEncrypt( cVn )		 //	6
			Usuario->Nivel7 := MSEncrypt( cUs )		 //	7
			Usuario->Nivel8 := MSEncrypt( cPr )		 //	8
			Usuario->Nivel9 := MSEncrypt( cInc )		 //	9
			Usuario->Nivel0 := MSEncrypt( cAlt )		 //  10
			Usuario->NivelA := MSEncrypt( cDel )		 //  11
			Usuario->NivelB := MSEncrypt( cDev )		 //  12
			Usuario->NivelC := MSEncrypt( cPag )		 //  13
			Usuario->NivelD := MSEncrypt( cRec )		 //  14
			Usuario->NivelE := MSEncrypt( cEmp )		 //  15
			Usuario->NivelF := MSEncrypt( cTro )		 //  16
			Usuario->NivelG := MSEncrypt( cFaz )		 //  17
			Usuario->NivelH := MSEncrypt( cRes )		 //  18
			Usuario->NivelI := MSEncrypt( cCom )		 //  19
			Usuario->NivelJ := MSEncrypt( cZero ) 	 //  20
			Usuario->NivelK := MSEncrypt( cEstorado ) //  21
			Usuario->NivelL := MSEncrypt( cVista )	 //  22
			Usuario->NivelM := MSEncrypt( cCadas )	 //  23
			Usuario->NivelN := MSEncrypt( cLimite )	 //  24
			Usuario->NivelO := MSEncrypt( cDescMax )  //  25
			Usuario->NivelP := MSEncrypt( cEnt 	 )  //  26
			Usuario->NivelQ := MSEncrypt( cFat 	 )  //  27
			Usuario->NivelR := MSEncrypt( cDtRec	 )  //  28
			Usuario->NivelS := MSEncrypt( cAtra	 )  //  29
			Usuario->Lpt1	 := cLpt1
			Usuario->Lpt2	 := cLpt2
			Usuario->Lpt3	 := cLpt3
			Usuario->(Libera())

			aPermissao := {}
			Aadd( aPermissao, IF( cEs	= "S", OK, FALSO ))      //   1
			Aadd( aPermissao, IF( cRe	= "S", OK, FALSO ))      //   2
			Aadd( aPermissao, IF( cPa	= "S", OK, FALSO ))      //   3
			Aadd( aPermissao, IF( cCo	= "S", OK, FALSO ))      //   4
			Aadd( aPermissao, IF( cVe	= "S", OK, FALSO ))      //   5
			Aadd( aPermissao, IF( cVn	= "S", OK, FALSO ))      //   6
			Aadd( aPermissao, IF( cUs	= "S", OK, FALSO ))      //   7
			Aadd( aPermissao, IF( cPr	= "S", OK, FALSO ))      //   8
			Aadd( aPermissao, IF( cInc = "S", OK, FALSO ))      //   9
			Aadd( aPermissao, IF( cAlt = "S", OK, FALSO ))      //  10
			Aadd( aPermissao, IF( cDel = "S", OK, FALSO ))      //  11
			Aadd( aPermissao, IF( cDev = "S", OK, FALSO ))      //  12
			Aadd( aPermissao, IF( cPag = "S", OK, FALSO ))      //  13
			Aadd( aPermissao, IF( cRec = "S", OK, FALSO ))      //  14
			Aadd( aPermissao, IF( cEmp = "S", OK, FALSO ))      //  15
			Aadd( aPermissao, IF( cTro = "S", OK, FALSO ))      //  16
			Aadd( aPermissao, IF( cFaz = "S", OK, FALSO ))      //  17
			Aadd( aPermissao, IF( cRes = "S", OK, FALSO ))      //  18
			Aadd( aPermissao, IF( cCom = "S", OK, FALSO ))      //  19
			Aadd( aPermissao, IF( cZero = "S", OK, FALSO ))     //  20
			Aadd( aPermissao, IF( cEstorado = "S", OK, FALSO )) //  21
			Aadd( aPermissao, IF( cVista = "S", OK, FALSO ))    //  22
			Aadd( aPermissao, IF( cCadas = "S", OK, FALSO ))    //  23
			Aadd( aPermissao, IF( cLimite = "S", OK, FALSO ))   //  24
			Aadd( aPermissao, IF( cDescMax = "S", OK, FALSO ))  //  25
			Aadd( aPermissao, IF( cEnt 	 = "S", OK, FALSO ))  //  26
			Aadd( aPermissao, IF( cFat 	 = "S", OK, FALSO ))  //  27
			Aadd( aPermissao, IF( cDtRec	 = "S", OK, FALSO ))  //  28
			Aadd( aPermissao, IF( cAtra	 = "S", OK, FALSO ))  //  29
		EndIF
	EndIF
	ResTela( cScreen )
	AreaAnt( Arq_Ant, Ind_Ant )
	Exit
EndDo

Function CadPermissao( cNome, cEs, cRe, cPa, cCo, cVe, cVn, cUs, cPr, cInc, cDel, cDev, cPag, cRec, cAlt, cEmp, cTro, cFaz, cRes, cCom, cZero, cVista, cCadas, cLimite, cEstorado, cLpt1, cLpt2, cLpt3, cDescMax, cEnt, cFat, cDtRec, cAtra )
*********************************************************************************************************************************************************************************************************************************************
LOCAL nChoice       := 1
LOCAL cScreen       := SaveScreen ()
LOCAL GetList       := {}
LOCAL oVenlan       := TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
LOCAL cCtrlP        := IF( oVenlan:ReadBool('permissao','usarteclactrlp', OK ), "S", "N")
LOCAL cCaix         := IF( oVenlan:ReadBool('permissao','visualizardetalhecaixa', OK ), "S", "N")
LOCAL cAdmin        := IF( oVenlan:ReadBool('permissao','usuarioadmin', FALSO ), "S", "N")
LOCAL cDebAtr       := IF( oVenlan:ReadBool('permissao','vendercomdebito', FALSO ), "S", "N")
LOCAL cRolCob       := IF( oVenlan:ReadBool('permissao','imprimirrolcobranca', FALSO ), "S", "N")
LOCAL cAutoVenda    := IF( oVenlan:ReadBool('permissao','autovenda', FALSO), "S", "N")
LOCAL cReciboZerado := IF( oVenlan:ReadBool('permissao','recibozerado', FALSO), "S", "N")

LOCAL nCol1
LOCAL nCol2
LOCAL nOpcao

WHILE OK
	nCol1 := 02
	nCol2 := 40
	MaBox( 02, 01, 11, 38, "ESCOLHA O ACESSO DE " + AllTrim( cNome ))
	@ 03, 	  nCol1 Say "CONTROLE DE ESTOQUE...:" Get cEs  Pict "@!" Valid PickSimNao( @cEs )
	@ Row()+1, nCol1 Say "CONTAS A RECEBER......:" Get cRe  Pict "@!" Valid PickSimNao( @cRe )
	@ Row()+1, nCol1 Say "CONTAS A PAGAR........:" Get cPa  Pict "@!" Valid PickSimNao( @cPa )
	@ Row()+1, nCol1 Say "CONTAS CORRENTES......:" Get cCo  Pict "@!" Valid PickSimNao( @cCo )
	@ Row()+1, nCol1 Say "VENDEDORES............:" Get cVe  Pict "@!" Valid PickSimNao( @cVe )
	@ Row()+1, nCol1 Say "VENDAS NO VAREJO......:" Get cVn  Pict "@!" Valid PickSimNao( @cVn )
	@ Row()+1, nCol1 Say "MANUTENCAO DE USUARIO.:" Get cUs  Pict "@!" Valid PickSimNao( @cUs )
	@ Row()+1, nCol1 Say "CONTROLE DE PRODUCAO..:" Get cPr  Pict "@!" Valid PickSimNao( @cPr )

	MaBox( 12, 01, 23, 38, "CONFIGURACAO GERAL DO SISTEMA" )
   @ 13,      nCol1 Say "BAIXAR TITULO QDO VENDA A VISTA.:" Get cVista     Pict "@!" Valid PickSimNao( @cVista )
   @ Row()+1, nCol1 Say "VERIFICAR LIMITE DE CREDITO.....:" Get cLimite    Pict "@!" Valid PickSimNao( @cLimite )
   @ Row()+1, nCol1 Say "VERIFICAR DEBITO EM ATRASO......:" Get cAtra      Pict "@!" Valid PickSimNao( @cAtra )
   @ Row()+1, nCol1 Say "VENDER COM DEBITO EM ATRASO.....:" Get cDebAtr    Pict "@!" Valid PickSimNao( @cDebAtr )
   @ Row()+1, nCol1 Say "VENDER COM LIMITE ESTOURADO.....:" Get cEstorado  Pict "@!" Valid PickSimNao( @cEstorado )
   @ Row()+1, nCol1 Say "IMPRESSORA EM LPT1..............:" Get cLpt1      Pict "99" Valid PrinterErrada( @cLpt1 )
   @ Row()+1, nCol1 Say "IMPRESSORA EM LPT2..............:" Get cLpt2      Pict "99" Valid PrinterErrada( @cLpt2 )
   @ Row()+1, nCol1 Say "IMPRESSORA EM LPT3..............:" Get cLpt3      Pict "99" Valid PrinterErrada( @cLpt3 )
   @ Row()+1, nCol1 Say "AUTOMATIZAR VENDA...............:" Get cAutoVenda Pict "!"     Valid PickSimNao( @cAutoVenda )

   MaBox( 02, 39, 24, MaxCol()-1, "ESCOLHA A PERMISSAO DE " + AllTrim( cNome ))
	@ 03, 	  nCol2 Say "PODE INCLUIR REGISTROS........:" Get cInc      Pict "@!" Valid PickSimNao( @cInc )
	@ Row()+1, nCol2 Say "PODE ALTERAR REGISTROS........:" Get cAlt      Pict "@!" Valid PickSimNao( @cAlt )
	@ Row()+1, nCol2 Say "PODE EXCLUIR REGISTROS........:" Get cDel      Pict "@!" Valid PickSimNao( @cDel )
	@ Row()+1, nCol2 Say "PODE DEVOLVER FATURA SAIDAS...:" Get cDev      Pict "@!" Valid PickSimNao( @cDev )
	@ Row()+1, nCol2 Say "PODE DEVOLVER FATURA ENTRADAS.:" Get cEnt      Pict "@!" Valid PickSimNao( @cEnt )
	@ Row()+1, nCol2 Say "PODE FAZER PAGAMENTOS.........:" Get cPag      Pict "@!" Valid PickSimNao( @cPag )
	@ Row()+1, nCol2 Say "PODE FAZER RECEBIMENTOS.......:" Get cRec      Pict "@!" Valid PickSimNao( @cRec )
	@ Row()+1, nCol2 Say "PODE INCLUIR EMPRESAS.........:" Get cEmp      Pict "@!" Valid PickSimNao( @cEmp )
	@ Row()+1, nCol2 Say "PODE TROCAR DE EMPRESA........:" Get cTro      Pict "@!" Valid PickSimNao( @cTro )
	@ Row()+1, nCol2 Say "PODE FAZER COPIA SEGURANCA....:" Get cFaz      Pict "@!" Valid PickSimNao( @cFaz )
	@ Row()+1, nCol2 Say "PODE RESTAURAR COPIA SEGURANCA:" Get cRes      Pict "@!" Valid PickSimNao( @cRes )
	@ Row()+1, nCol2 Say "PODE ALTERAR COMISSAO VENDA...:" Get cCom      Pict "@!" Valid PickSimNao( @cCom )
	@ Row()+1, nCol2 Say "FATURAR COM ESTOQUE NEGATIVO..:" Get cZero     Pict "@!" Valid PickSimNao( @cZero )
	@ Row()+1, nCol2 Say "PODE EXCEDER DESC MAXIMO......:" Get cDescMax  Pict "@!" Valid PickSimNao( @cDescMax )
	@ Row()+1, nCol2 Say "PODE ALTERAR EMISSAO DA FATURA:" Get cFat      Pict "@!" Valid PickSimNao( @cFat )
	@ Row()+1, nCol2 Say "PODE ALTERAR DATA RECEBIMENTO.:" Get cDtRec    Pict "@!" Valid PickSimNao( @cDtRec )
	@ Row()+1, nCol2 Say "PODE USAR TECLA CLTR+P........:" Get cCtrlP    Pict "@!" Valid PickSimNao( @cCtrlP )
	@ Row()+1, nCol2 Say "PODE VISUALIZAR CAIXA.........:" Get cCaix     Pict "@!" Valid PickSimNao( @cCaix  )
	@ Row()+1, nCol2 Say "PODE IMPRIMIR ROL COBRANCA....:" Get cRolCob   Pict "@!" Valid PickSimNao( @cRolCob )
   @ Row()+1, nCol2 Say "PODE IMPRIMIR RECIBO ZERADO...:" Get cReciboZerado Pict "@!" Valid PickSimNao( @cReciboZerado )
	@ Row()+1, nCol2 Say "USUARIO ADMINISTRADOR.........:" Get cAdmin    Pict "@!" Valid PickSimNao( @cAdmin )
	Read
	IF LastKey() = ESC
		ResTela( cScreen )
		Return( FALSO )
	EndIF
	ErrorBeep()
	nOpcao := Alerta(" Pergunta: Voce Deseja ? ", {" Continuar ", " Alterar ", " Sair " })
	IF nOpcao = 1
		oVenlan:WriteBool('permissao', 'usarteclactrlp',         IF( cCtrlP  = "S", OK, FALSO ))
		oVenlan:WriteBool('permissao', 'visualizardetalhecaixa', IF( cCaix   = "S", OK, FALSO ))
		oVenlan:WriteBool('permissao', 'usuarioadmin',           IF( cAdmin  = "S", OK, FALSO ))
		oVenlan:WriteBool('permissao', 'vendercomdebito',        IF( cDebAtr = "S", OK, FALSO ))
		oVenlan:WriteBool('permissao', 'imprimirrolcobranca',    IF( cRolCob = "S", OK, FALSO ))
      oVenlan:WriteBool('permissao', 'autovenda',              IF( cAutoVenda = "S", OK, FALSO ))
      oVenlan:WriteBool('permissao', 'recibozerado',           IF( cReciboZerado = "S", OK, FALSO ))
      oVenlan:WriteBool('permissao', 'PodeExcluirRegistros',   IF( cDel          = "S", OK, FALSO ))
		Return( OK )
	ElseIF nOpcao = 2
		Loop
	ElseIf nOpcao = 3
		Return( FALSO )
	EndIF
END

Function Permissao( cVariavel )
*******************************
LOCAL cScreen := SaveScreen()
LOCAL aMenu   := { " Com Permissao de Acesso ", " Sem Permissao de Acesso " }
LOCAL aSimNao := { "SIM", "NAO" }
LOCAL nChoice := 1

MaBox( 10, 49, 13, 79 )
nChoice	 := Achoice( 11, 50, 16, 78, aMenu )
IF nChoice = 0
	nChoice = 2
EndIF
cVariavel := aSimNao[ nChoice ]
Keyb Chr( ENTER )
ResTela( cScreen )
Return OK

Proc MostraPermissao()
**********************
LOCAL lNenhum := OK
LOCAL cSTring := ""
LOCAL aMostra := { "Modulo de {Estoque}      ",;
						 ";Modulo de {Receber}      ",;
						 ";Modulo de {Pagar}        ",;
						 ";Modulo de {C. Correntes} ",;
						 ";Modulo de {Vendedores}   " ,;
						 ";Modulo de {Vendas}       ",;
						 ";Modulo de {Usuario}      ",;
						 ";Modulo de {Producao}     " }
For nX := 1 To 8
	IF aPermissao[nX]
		cString += aMostra[nX]
		lNenhum := FALSO
	EndIF
Next
ErrorBeep()
IF lNenhum
	cString := "Nenhum Modulo {...}"
EndIF
Alert("Erro: Usuario Com Acesso Restrito ao:;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ;" + cString )
Return( NIL )

Proc Carta( lFecharTudo )
*************************
LOCAL GetList		:= {}
LOCAL cScreen		:= SaveScreen()
LOCAL Files 	  := '*.DOC'
LOCAL lNovoCodigo := OK
LOCAL cUltCodigo	:= ""
LOCAL aMenu 		:= {"Individual", "Por Cidade", "Por Estado", "Por Regiao", "Por Aniversario", "Parcial", "Geral" }
LOCAL aTipo 		:= {"Normal", "Ultima Compra"}
LOCAL oBloco
LOCAL Campo
LOCAL Linha
LOCAL Linhas
LOCAL Imprime
LOCAL cDebitos 	:= "N"
LOCAL nTipo 		:= 0
LOCAL nDias 		:= 0
LOCAL nChoice		:= 0
LOCAL nFormulario := 66

lFechartudo := IF( lFecharTudo = NIL, OK, FALSO )
WHILE OK
	M_Title("IMPRESSAO DE MALA DIRETA")
	nChoice := FazMenu( 03, 02, aMenu, Cor())
	IF nChoice = 0
		ResTela( cScreen )
		Return
	EndIF
	M_Title("TIPO DE MALA DIRETA")
	nTipo := FazMenu( 04, 03, aTipo, Cor())
	IF nTipo = 0
		ResTela( cScreen )
		Return
	EndIF
	Arq := "CARTA.DOC" + Space(03)
	MaBox( 03 , 39 , 06 , 79 )
	@ 04, 40 Say  "Tamanho Formulario..:" Get nFormulario Pict "99" Valid PickTam({"33 Colunas", "66 Colunas"}, {33,66}, @nFormulario )
	@ 05, 40 Say  "Arquivo a imprimir..:" Get Arq Pict "@!"
	Read
	IF LastKey( ) = ESC
		IF lFecharTudo
			FechaTudo()
		EndIf
		ResTela( cScreen )
		Loop
	EndIF
	FChdir( oAmbiente:xBaseDoc )
	Set Defa To ( oAmbiente:xBaseDoc )
	IF !File( Arq ) .OR. Empty( Arq )
		M_Title( "Setas CIMA/BAIXO Move")
		Arq := Mx_PopFile( 07, 39, 22, 79, Files, Cor())
		IF Empty( Arq )
			FChdir( oAmbiente:xBaseDados )
			Set Defa To ( oAmbiente:xBaseDados )
			ErrorBeep()
			ResTela( cScreen )
			Return
		EndIF
	EndIF
	FChdir( oAmbiente:xBaseDados )
	Set Defa To ( oAmbiente:xBaseDados )
	IF !Selecao( nChoice, @oBloco )
		IF lFecharTudo
			FechaTudo()
		EndIF
		ResTela( cScreen )
		Loop
	EndiF
	IF nTipo = 2
		oMenu:Limpa()
		MaBox( 10, 10, 13, 45 )
		@ 11, 11 Say "Dias da Ultima Compra........:" Get nDias    Pict "999"
		@ 12, 11 Say "Imprimir Carta se tem debitos:" Get cDebitos Pict "!" Valid cDebitos $ "SN"
		Read
		IF LastKey() = ESC
			ResTela( cScreen )
			Loop
		EndIF
	EndIF
	IF !InsTru80() .OR. !LptOk()
		IF lFecharTudo
			FechaTudo()
		EndIF
		ResTela( cScreen )
		Loop
	EndIF
	oMenu:Limpa()
	cTela 		:= Mensagem("Informa: Aguarde... Imprimindo Mala Direta.", Cor())
	cUltCodigo	:= Codi
	lNovoCodigo := OK
	PrintOn()
	Fprint( Chr(ESC) + "C" + Chr( nFormulario ))
	SetPrc( 0 , 0 )
	Recemov->(Order( RECEMOV_CODI ))
	WHILE Eval( oBloco ) .AND. REL_OK( )
		IF nTipo = 2
			IF ( Date() - UltCompra ) >= nDias
				IF cDebitos = "N"
					IF Recemov->(DbSeek( cUltCodigo ))
						cUltCodi := Codi
						DbSkip(1)
						Loop
					EndIF
				EndIF
			Else
				cUltCodi := Codi
				DbSkip(1)
				Loop
			EndIF
		EndIF
		IF lNovoCodigo
			lNovoCodigo := FALSO
			Write( 02 , 0, DataExt( Date()))
			Write( 06 , 0, "A" )
			Write( 07 , 0, NG + Codi + ' ' + Nome + NR )
			Write( 08 , 0, Ende )
			Write( 09 , 0, LIGSUB + Cep + "/" + Rtrim( Cida )  + "/" + Esta + DESSUB )
			FChdir( oAmbiente:xBaseDoc )
			Set Defa To ( oAmbiente:xBaseDoc )
			Campo  := MemoRead( Arq )
			Linhas := MlCount( Campo , 80 )
			FOR Linha  :=	1 TO Linhas
				Imprime :=	MemoLine( Campo , 80 , Linha )
				Write( 14 + Linha -1 , 0, Imprime )
			Next
			FChdir( oAmbiente:xBaseDados )
			Set Defa To ( oAmbiente:xBaseDados )
		EndIF
		cUltCodi := Codi
		DbSkip(1)
		IF cUltCodi != Codi .OR. Eof()
			lNovoCodigo := OK
			__Eject()
		EndIF
	EndDo
	DbClearFilter()
	DbGoTop()
	IF lFecharTudo
		FechaTudo()
	EndIF
	Fprint( Chr(ESC) + "C" + Chr( 66 ))
	PrintOff()
	ResTela( cScreen )
EndDo

Function Selecao( nChoice, oBloco )
***********************************
LOCAL cScreen	:= SaveScreen()
LOCAL cCodi 	:= Space(05)
LOCAL cCodi1	:= Space(05)
LOCAL cCida 	:= Space(25)
LOCAL cEsta 	:= Space(02)
LOCAL dIni		:= Space(05)
LOCAL xArquivo := FTempName(".TMP")
LOCAL dFim		:= Space(05)
LOCAL cRegiao	:= Space(02)

IF !UsaArquivo("RECEBER") ; FechaTudo() ; Break ; EndIF
IF !UsaArquivo("REGIAO")  ; FechaTudo() ; Break ; EndIF
IF !UsaArquivo("RECEMOV") ; FechaTudo() ; Break ; EndIF
Area("Receber")
Receber->( Order( RECEBER_CODI ))
Do Case
	Case nChoice = 1
		MaBox( 15, 02, 17, 63 )
		@ 16, 03 Say "Cliente...:" Get cCodi Pict PIC_RECEBER_CODI Valid RecErrado( @cCodi,, Row(), Col()+1 )
		Read
		IF LastKey() = ESC
			ResTela( cScreen )
			Return( FALSO )
		EndIF
		Receber->( Order( RECEBER_CODI ))
		Receber->(DbSeek( cCodi ))
		oBloco := {|| Receber->Codi = cCodi }
		Return( OK )

	Case nChoice = 2
		MaBox( 15, 02, 17, 63 )
		@ 16, 03 Say "Cidade....:" Get cCida Pict "@!" Valid !Empty( cCida )
		Read
		IF LastKey() = ESC
			ResTela( cScreen )
			Return( FALSO )
		EndIF
		Receber->( Order( RECEBER_CIDA ))
		IF Receber->(!DbSeek( cCida ))
			Nada()
			Return( FALSO )
		EndIF
		oBloco := {|| Receber->Cida = cCida }
		Return( OK )

	Case nChoice = 3
		MaBox( 15, 02, 17, 63 )
		@ 16, 03 Say "Estado....:" Get cEsta Pict "@!" Valid !Empty( cEsta )
		Read
		IF LastKey() = ESC
			ResTela( cScreen )
			Return( FALSO )
		EndIF
		Receber->( Order( RECEBER_ESTA ))
		IF Receber->(!DbSeek( cEsta ))
			Nada()
			Return( FALSO )
		EndIF
		oBloco := {|| Receber->Esta = cEsta }
		Return( OK )

	Case nChoice = 4
		MaBox( 15, 02, 17, 63 )
		@ 16, 03 Say "Regiao....:" Get cRegiao Pict "@!" Valid Regiao->(RegiaoErrada( @cRegiao ))
		Read
		IF LastKey() = ESC
			ResTela( cScreen )
			Return( FALSO )
		EndIF
		Receber->( Order( RECEBER_REGIAO ))
		IF Receber->(!DbSeek( cRegiao ))
			Nada()
			Return( FALSO )
		EndIF
		oBloco := {|| Receber->Regiao = cRegiao }
		Return( OK )

	Case nChoice = 5
		MaBox( 15, 02, 18, 63 )
		@ 16, 03 Say "Dia/Mes do Aniversario Inicial.:" Get dIni Pict "##/##"
		@ 17, 03 Say "Dia/Mes do Aniversario Final...:" Get dFim Pict "##/##" Valid dFim >= dIni
		Read
		IF LastKey() = ESC
			ResTela( cScreen )
			Return( FALSO )
		EndIF
		IF Conf("Informa: Procura podera demorar. Continua ?")
			oMenu:Limpa()
			cTela := Mensagem("Informa: Aguarde, Localizando Registros.", Cor())
			Copy Stru To ( xArquivo )
			Use ( xArquivo) Exclusive Alias xAlias New
			nConta := 0
			cIni1  := Left(StrTran( dIni, "/"),2)
			cIni2  := Right(StrTran( dIni, "/"),2)
			cFim1  := Left(StrTran( dFim, "/"),2)
			cFim2  := Right(StrTran( dFim, "/"),2)
			Receber->( Order( RECEBER_CODI ))
			Receber->(DbGoTop())
			WHILE Receber->(!Eof())
				cData  := Receber->(Left(DToc( Nasc ), 5 ))
				cData1 := Left( StrTran( cData, "/"), 2 )
				cData2 := Right( StrTran( cData, "/"), 2 )
				IF cData1 >= cIni1 .AND. cData1 <= cFim1
					IF cData2 >= cIni2 .AND. cData2 <= cFim2
						nConta++
						xAlias->(DbAppend())
						For nField := 1 To FCount()
							xAlias->(FieldPut( nField, Receber->(FieldGet( nField ))))
						Next
					EndIF
				EndIF
				Receber->(DbSkip(1))
			EnDdo
			IF nConta = 0
				xAlias->(DbCloseArea())
				Ferase( xArquivo )
				oMenu:Limpa()
				Alerta("Informa: Nenhum Registro atende a Condicao.")
			Else
				Sele xAlias
				xAlias->(DbGoTop())
				oBloco := {|| !Eof() }
				ResTela( cTela )
				Return( OK )
			EndIF
		EndIF
		Return( FALSO )

	Case nChoice = 6
		MaBox( 15, 02, 18, 63 )
		@ 16, 03 Say "Codigo Ini:" Get cCodi  Pict PIC_RECEBER_CODI Valid RecErrado( @cCodi,, Row(), Col()+1 )
		@ 17, 03 Say "Codigo Fim:" Get cCodi1 Pict PIC_RECEBER_CODI Valid RecErrado( @cCodi1,, Row(), Col()+1 )
		Read
		IF LastKey() = ESC
			ResTela( cScreen )
			Return( FALSO )
		EndIF
		Receber->( Order( RECEBER_CODI ))
		oBloco := {|| Receber->Codi >= cCodi .AND. Receber->Codi <= cCodi1 }
		Receber->(DbSeek( cCodi ))
		Return( OK )

	Case nChoice = 7
		Receber->( Order( RECEBER_CODI ))
		Receber->(DbGoTop())
		oBloco := {|| !Eof() }
		Return( OK )
EndCase

Proc Novidades()
****************
LOCAL cFile := oAmbiente:xBase + "\SCI.NEW"
oMenu:Limpa()
IF File( cFile )
	M_Title("ULTIMAS ALTERACOES NO SISTEMA")
	M_View( 00, 00, LastRow(), LastCol(), cFile,  Cor())
Else
	ErrorBeep()
	Alerta("Erro: Arquivo " + cFile + " nao localizado.", Cor())
EndIF

Proc ImprimeDebito()
********************
LOCAL GetList		:= {}
LOCAL cScreen		:= SaveScreen()
LOCAL cCodi 		:= Space(05)
LOCAL nSubTotal	:= 0
LOCAL nTotal		:= 0
LOCAL Col			:= 0
LOCAL Pagina		:= 0
LOCAL nSobra		:= 0
LOCAL nJuro 		:= 0
LOCAL nSubJuros	:= 0
LOCAL nCarencia	:= 30
LOCAL nTotalJuros := 0
LOCAL Tam			:= 132
LOCAL nTamForm 	:= 33
LOCAL dIni			:= Date()-30
LOCAL dFim			:= Date()
LOCAL cMensagem	:= "AGRADECEMOS A SUA PREFERENCIA."
LOCAL cNome
LOCAL cEnde
LOCAL cFone
LOCAL oBloco

cMensagem += Space(40 - Len( cMensagem ))
WHILE OK
	oMenu:Limpa()
	MaBox( 10, 05, 18, 78 )
	@ 11, 06 Say "Codigo Cliente..... : " Get cCodi       Pict PIC_RECEBER_CODI Valid RecErrado( @cCodi,, Row(), Col()+1 )
	@ 12, 06 Say "Data Inicial....... : " Get dIni        Pict "##/##/##"
	@ 13, 06 Say "Data Final......... : " Get dFim        Pict "##/##/##"
	@ 14, 06 Say "Taxa Juros Mes..... : " Get nJuro       Pict "99.99"
	@ 15, 06 Say "Dias Carencia...... : " Get nCarencia   Pict "99"
	@ 16, 06 Say "Mensagem............: " Get cMensagem   Pict "@1"
	@ 17, 06 Say "Comp do Formulario..: " Get nTamForm    Pict "99" Valid nTamForm >= 20 .AND. nTamForm <= 66
	Read
	IF LastKey() = ESC
		ResTela( cScreen )
		Exit
	EndIF
	IF !Instru80() .OR. !LptOk()
		Loop
	EndIF
	cEnde := Receber->Ende
	cFone := Receber->Fone
	cNome := Receber->(AllTrim( Nome ))
	Lista->(Order( LISTA_CODIGO ))
	Area("Saidas")
	Set Rela To Saidas->Codigo Into Lista
	Saidas->(Order( SAIDAS_CODI ))
	IF Saidas->(!DbSeek( cCodi ))
		Saidas->(DbClearRel())
		Saidas->(DbGoTop())
		ErrorBeep()
		Alerta(" Nenhum Debito aberto em C/C !")
		Loop
	EndIF
	oBloco		:= {|| Saidas->Codi = cCodi }
	oBloco2		:= {|| Saidas->Data >= dIni .AND. Saidas->Data <= dFim }
	nSubTotal	:= 0
	nSubJuros	:= 0
	nTotalJuros := 0
	nTotal		:= 0
	Mensagem(" Aguarde... Verificando e Imprimindo Movimento.", Cor())
	Col			:= 58
	Pagina		:= 0
	nSobra		:= 0
	Tam			:= 132
	PrintOn()
	FPrint( PQ )
	FPrInt( Chr(ESC) + "C" + Chr( nTamForm ))
	SetPrc( 0, 0 )
	WHILE Eval( oBloco ) .AND. !Eof()
		IF Col >= nTamForm
			Write( 00, 00, Linha1( Tam, @Pagina))
			Write( 01, 00, Linha2())
         Write( 02, 00, Padc( oAmbiente:xFanta, Tam ) )
			Write( 03, 00, Linha4(Tam, SISTEM_NA2 ))
			Write( 04, 00, Padc( "RELATORIO DE DEBITO C/C", Tam ) )
			Write( 05, 00, Linha5( Tam ))
			Write( 06, 00, "Data : " + Dtoc( Date()))
			Write( 07, 00, "Nome : " + cCodi + "  " + cNome )
			Write( 08, 00, "End  : " + cEnde )
			Write( 09, 00, "Tel  : " + cFone )
			Write( 10, 00, Linha5( Tam ))
			Write( 11, 00, "DATA           ATRASO   FATURA   CODIGO    QUANT  DESCRICAO DO PRODUTO                         UNITARIO         TOTAL   VLR A PAGAR")
			Write( 12, 00, Linha5(Tam))
			Col := 13
		EndIF
		IF !Saidas->c_c  // Movimento nao eh conta corrente ?
			Saidas->(DbSkip(1))
			Loop
		EndIF
		IF Saidas->Saida = Saidas->SaidaPaga
			Saidas->(DbSkip(1))
			Loop
		EndIF
		IF !Eval( oBloco2 )
			Saidas->(DbSkip(1))
			Loop
		EndIF
		nSobra	:= ( Saidas->Saida - Saidas->SaidaPaga )
		nConta	:= Pvendido * nSobra
		nJurodia := 0
		nJdia 	:= 0
		nAtraso	:= ( Date() - Data ) - nCarencia
		nConta  := Lista->Varejo * nSobra
		IF nAtraso > 1
			nJdia 	  := JuroDia( nConta, nJuro )
			nJuroDia   := nJdia * nAtraso
		EndIF
		Qout( Data, nAtraso, Fatura, Codigo, Str( nSobra, 9, 2), Lista->(Ponto(Descricao,40)),;
				Lista->(Tran( Varejo, "@E 9,999,999.99")),;
				Tran( nConta, "@E 99,999,999.99"),;
				Tran( nConta + nJurodia, "@E 99,999,999.99"))
		nSubTotal	+= nConta
		nTotal		+= nConta
		nSubJuros	+= nConta + nJurodia
		nTotalJuros += nConta + nJurodia
		Saidas->(DbSkip(1))
		Col++
		IF Col >= nTamForm
			nRow1 := 104
			nRow2 := 118
			Write(	Col,	00,	 Linha5(Tam))
			Write( ++Col,	00,	 "** SubTotal ** " )
			Write(	Col,	nRow1, Tran( nSubTotal, "@E 99,999,999.99"))
			Write(	Col,	nRow2, Tran( nSubJuros, "@E 99,999,999.99"))
			nSubTotal := 0
			nSubJuros := 0
			Col++
			__Eject()
		EndIF
	EndDo
	nRow1 := 104
	nRow2 := 118
	Write(	Col,	00,	Linha5(Tam))
	Write( ++Col,	00,	"** SubTotal ** " )
	Write(	Col, nRow1, Tran( nSubTotal,	 "@E 99,999,999.99"))
	Write(	Col, nRow2, Tran( nSubJuros,	 "@E 99,999,999.99"))
	Write( ++Col,	00,	"**    Total ** " )
	Write(	Col, nRow1, Tran( nTotal,		 "@E 99,999,999.99"))
	Write(	Col, nRow2, Tran( nTotalJuros, "@E 99,999,999.99"))
	Qout()
	Qout( NG + GD + cMensagem + CA + NR )
	__Eject()
	PrintOff()
	Saidas->(DbClearRel())
	Saidas->(DbGoTop())
EndDo

Function Linha1( Tam, Pagina )
********************************
LOCAL nDiv := Tam / 2
Return( Padr( "Pagina N§ " + StrZero(++Pagina,5), nDiv ) + Padl(Time(), nDiv ))

Function Linha2()
*****************
Return(Date())

Function Linha3( Tam )
**********************
Return( Padc( XNOMEFIR, Tam ))

Function Linha4( Tam, cSistema )
********************************
Return(Padc( cSistema, Tam ))

Function Linha5( Tam )
**********************
Tam := IF( Tam = Nil, 80, Tam)
Return(Repl( SEP, Tam ))

Proc DebitoC_C()
****************
#DEFINE SP			Space(1)
LOCAL cScreen		:= SaveScreen()
LOCAL cCodi 		:= Space(05)
LOCAL nTotal		:= 0
LOCAL nSubTotal	:= 0
LOCAL nJuro 		:= 0
LOCAL nSubJuros	:= 0
LOCAL nTotalJuros := 0
LOCAL nSobra		:= 0
LOCAL aArray		:= {}
LOCAL nCarencia	:= 30
LOCAL dIni			:= Date()-30
LOCAL dFim			:= Date()
LOCAL cNome
LOCAL oBloco
LOCAL oBloco1

WHILE OK
	oMenu:Limpa()
	aArray := {}
	MaBox( 00, 00, 08, 79 )
	@ 01, 01 Say "Cliente..:" Get cCodi Pict PIC_RECEBER_CODI Valid RecErrado( @cCodi,, Row(), Col()+1 )
	@ 02, 01 Say "Data Ini.:" Get dIni  Pict "##/##/##"
	@ 03, 01 Say "Data Fim.:" Get dFim  Pict "##/##/##"
	@ 04, 01 Say "Juros Mes:" Get nJuro Pict "99.99"
	@ 05, 01 Say "Carencia.:" Get nCarencia Pict "999"
	@ 06, 01 Say "Endereco.:"
	@ 07, 01 Say "Telefone.:"
	Read
	IF LastKey() = ESC
		Saidas->(DbClearRel())
		Exit
	EndIF
	cNome := Receber->(AllTrim( Nome ))
	Write( 06, 12, Receber->Ende )
	Write( 07, 12, Receber->Fone )
	Lista->(Order( LISTA_CODIGO ))
	Area("Saidas")
	Set Rela To Codigo Into Lista
	Saidas->(Order( SAIDAS_CODI ))
	IF !DbSeek( cCodi )
		ErrorBeep()
		Alerta(" Nenhum Debito aberto em C/C !")
		Loop
	EndIF
	oBloco		:= {|| Saidas->Codi = cCodi }
	oBloco1		:= {|| Saidas->Data >= dIni .AND. Saidas->Data <= dFim }
	nTotal		:= 0
	nTotalJuros := 0
	nSobra		:= 0
	cTela := Mensagem(" Aguarde... Verificando Movimento.", Roloc(Cor()))
	WHILE Eval( oBloco ) .AND. !Eof()
		IF !Eval( oBloco1 )
			Saidas->(DbSkip(1))
			Loop
		EndIF
		IF !Saidas->c_c  // Movimento nao eh conta corrente ?
			Saidas->(DbSkip(1))
			Loop
		EndIF
		IF Saidas->Saida = Saidas->SaidaPaga
			Saidas->(DbSkip(1))
			Loop
		EndIF
		nSobra	:= ( Saidas->Saida - Saidas->SaidaPaga )
		nConta	:= ( nSobra * Lista->Varejo)
		nJurodia := 0
		nJdia 	:= 0
		nAtraso	:= ( Date() - Data ) - nCarencia
		IF nAtraso > 1
			nJdia 	  := JuroDia( nConta, nJuro )
			nJuroDia   := nJdia * nAtraso
		EndIF
		nTotal		+= nConta
		nTotalJuros += nConta + nJurodia
		Aadd( aArray, Dtoc( Data) + SP + Fatura + Codigo + SP + ;
				Lista->(Ponto(Left(Descricao,32),31)) + SP + Str( nSobra, 9,2) + SP + ;
				Lista->(Tran( Varejo, "@E 999,999.99")))
		Saidas->(DbSkip(1))
	EndDo
	ResTela( cTela )
	IF Len( aArray ) != 0
		MaBox( 09, 00, 24, 79 )
		Aadd( aArray, Repl("Ä",80))
		Aadd( aArray, Rjust("VALOR TOTAL " + Tran( nTotal, "@E 999,999,999.99"), 78))
		Aadd( aArray, Rjust("  COM JUROS " + Tran( nTotalJuros, "@E 999,999,999.99"), 78))
		Print( 09, 01, "DATA     FATURA   CODIGO DESCRICAO DO PRODUTO                 QUANT   UNITARIO", Roloc( Cor()))
		M_Title("[ESC] RETORNA")
		aChoice( 10, 01, 23, 78, aArray, OK )
	Else
		Alerta("Erro: Nenhum Debito em Aberto.")
	EndIF
	Saidas->(DbClearRel())
	Saidas->(DbGoTop())
EndDo
ResTela( cScreen )
Return

Proc MostraDebito()
*******************
LOCAL cScreen		:= SaveScreen()
LOCAL aTodos		:= {}
LOCAL aFatura		:= {}
LOCAL aValor		:= {}
LOCAL aVlrFatura	:= {}
LOCAL aMenuArray	:= Array(3)
LOCAL aMenu 		:= Array(3)
LOCAL cCodi 		:= Space(05)
LOCAL nPos			:= 0
LOCAL nTam			:= 0
LOCAL nVlrFatura	:= 0
LOCAL nVlrAnt		:= 0
LOCAL nVlrAtu		:= 0
LOCAL nAnt			:= 0
LOCAL nPrecoAtual := 0
LOCAL nBase 		:= 0
LOCAL nChoice		:= 0
LOCAL nCarencia	:= 0
LOCAL nJuro 		:= 0
LOCAL cTipoVenda
LOCAL cTela
LOCAL oBloco
LOCAL cFatura

aMenuArray[1] := " Conforme Preco Varejo  "
aMenuArray[2] := " Conforme Preco Atacado "
aMenuArray[3] := " Conforme Taxa de Juros "
	  aMenu[1] := " Preco Varejo  Atual "
	  aMenu[2] := " Preco Atacado Atual "
	  aMenu[3] := " Preco Vendido       "
WHILE OK
	oMenu:Limpa()
	MaBox( 05, 05, 07, 78 )
	@ 06, 06 Say "Codigo Cliente : " Get cCodi Pict PIC_RECEBER_CODI Valid RecErrado( @cCodi,, Row(), Col()+1 )
	Read
	IF LastKey() = ESC
		Saidas->(DbClearRel())
		ResTela( cScreen )
		Exit
	EndIF
	IF !Saidas->(TravaArq()) ; DbUnLockAll() ; Restela( cScreen ) ; Loop ; EndIf
	IF !Chemov->(TravaArq()) ; DbUnLockAll() ; Restela( cScreen ) ; Loop ; EndIf
	IF !Cheque->(TravaArq()) ; DbUnLockAll() ; Restela( cScreen ) ; Loop ; EndIf
	Lista->(Order( LISTA_CODIGO ))
	Area("Saidas")
	Set Rela To Codigo Into Lista
	Saidas->(Order( SAIDAS_CODI ))
	IF Saidas->(!DbSeek( cCodi ))
		ResTela( cScreen )
		ErrorBeep()
		Alerta(" Nenhum Debito aberto em C/C !")
		ResTela( cScreen )
		Loop
	EndIF
	M_Title("ESCOLHA O TIPO DE REAJUSTE")
	nChoice := FazMenu( 08, 05, aMenuArray, Cor())
	IF nChoice = 0
		Saidas->(DbClearRel())
		ResTela( cScreen )
		Loop
	EndIF
	nCarencia := 0
	nJuro 	 := 0
	IF nChoice = 3
		MaBox( 15, 05, 18, 33 )
		@ 16, 06 Say "Dias de Carencia :" Get nCarencia Pict "999"
		@ 17, 06 Say "Juro Mes.........:" Get nJuro     Pict "999.99"
		Read
		IF LastKey() = ESC
			ResTela( cScreen )
			Loop
		EndIF
		M_Title("TOMAR POR BASE O")
		nBase := FazMenu( 15, 34, aMenu, Cor())
		IF nBase = 0
			Saidas->(DbClearRel())
			ResTela( cScreen )
			Loop
		EndIF
	EndIF
	IF Conf("Pergunta: Confirma Atualizacao do Movimento ?")
		oBloco	  := {|| Saidas->Codi = cCodi }
		cTipoVenda := OK
		aTodos	  := {}
		aFatura	  := {}
		aValor	  := {}
		aVlrFatura := {}
		nTam		  := 0
		nAnt		  := 0
		nVlrAnt	  := 0
		nVlrAtu	  := 0
		nVlrFatura := 0
		nPrecoAtual := 0
		Mensagem(" Aguarde... Verificando e atualizando Movimento.", Cor())
		WHILE Eval( oBloco ) .AND. !Eof()
			nVlrFatura += ( Saidas->Saida * Saidas->Pvendido )
			cFatura	  := Saidas->Fatura
			nPos		  := Ascan( aFatura, cFatura )
			IF Saidas->c_c  // Movimento eh conta corrente ?
				nSobra	  := ( Saidas->Saida - Saidas->SaidaPaga )
				nVlrAnt	  := ( nSobra * Saidas->Pvendido )
				IF nChoice		= 1 // Varejo
					nVlrAtu	  := ( nSobra * Lista->Varejo )
					Saidas->Pvendido := Lista->Varejo
				ElseIF nChoice = 2 // Atacado
					nVlrAtu	  := ( nSobra * Lista->Atacado )
					Saidas->Pvendido := Lista->Atacado
				ElseIF nChoice = 3 // Juro Mensal
					IF nBase = 1 // Base o Varejo
						nAtraso			  := (( Date() - Data ) - nCarencia )
						nAtraso			  := IF( nAtraso >= 0, nAtraso, 0 )
						nJdia 			  := JuroDia( Lista->Varejo, nJuro )
						nJTotal			  := nJdia * nAtraso
						nVlrAtu			  := ( nSobra * ( Lista->Varejo + nJTotal ))
						Saidas->Pvendido := nVlrAtu
					ElseIF nBase = 2 // Base o Atacado
						nAtraso			  := (( Date() - Data ) - nCarencia )
						nAtraso			  := IF( nAtraso >= 0, nAtraso, 0 )
						nJdia 			  := JuroDia( Lista->Atacado, nJuro )
						nJTotal			  := nJdia * nAtraso
						nVlrAtu			  := ( nSobra * ( Lista->Atacado + nJTotal ))
						Saidas->Pvendido := nVlrAtu
					ElseIF nBase = 3 // Base o Vendido
						nAtraso			  := (( Date() - Data ) - nCarencia )
						nAtraso			  := IF( nAtraso >= 0, nAtraso, 0 )
						nJdia 			  := JuroDia( Saidas->Pvendido, nJuro )
						nJTotal			  := nJdia * nAtraso
						nVlrAtu			  := ( nSobra * ( Saidas->Pvendido + nJTotal ))
						Saidas->Pvendido := nVlrAtu
					EndIF
				EndIF
				nPrecoAtual := Saidas->Pvendido
				Aadd( aTodos, Codigo + " " + Lista->Descricao + " " +;
								  Str( nSobra,6 ) + " " + Lista->(Tran( nPrecoAtual, "@E 99,999,999,999.99")))
			EndIF
			IF nPos = 0
				Aadd( aFatura, 	cFatura )
				Aadd( aValor,		( nVlrAtu - nVlrAnt) )
				Aadd( aVlrFatura, nVlrFatura )
			Else
				aValor[nPos]	  += ( nVlrAtu - nVlrAnt )
				aVlrFatura[nPos] +=	nVlrFatura
			EndIF
			nVlrAnt	  := 0
			nVlrAtu	  := 0
			nVlrFatura := 0
			nSobra	  := 0
			Saidas->(Dbskip(1))
		EndDo
		Saidas->(Libera())
		nTam := Len( aFatura )
		IF nTam != 0
			ResTela( cScreen )
			Chemov->(Order( CHEMOV_FATURA ))
			For nX := 1 To nTam
				IF Chemov->(DbSeek( aFatura[nX]))
					nAnt			  := Chemov->Saldo
					Chemov->Deb   := aVlrFatura[ nX ]
					Chemov->Deb   += aValor[ nX ]
					Chemov->Saldo -= aValor[ nX ]
				EndIf
			Next
			Chemov->(Libera())
			IndexarData( cCodi )
		Else
			Chemov->(Libera())
			ResTela( cScreen )
			ErrorBeep()
			Alerta("Nenhum Debito aberto em C/C !")
		EndIF
	EndIF
	ResTela( cScreen )
EndDo

Function UsaArquivo( cArquivo, cAlias )
***************************************
STATI lJahAcessou := FALSO
LOCAL cScreen		:= SaveScreen()
LOCAL nY 			:= 0
LOCAL aArquivos	:= ArrayIndices()

nTodos	:= Len( aArquivos )
cArquivo := Upper( cArquivo )
IF !lJahAcessou
	lJahAcessou := OK
	Mensagem("Aguarde, Compartilhando o Arquivos. ", WARNING, _LIN_MSG )
EndIF
IF cArquivo != NIL
	IF cAlias = NIL
		IF DbfEmUso( cArquivo )
			ResTela( cScreen )
			Return( OK )
		EndIf
	EndIf
	nPos := Ascan( aArquivos,{ |oBloco|oBloco[1] = cArquivo })
	IF nPos != 0
		nLen := Len(aArquivos[nPos])
		IF NetUse( cArquivo, MULTI,, cAlias )
			#IFDEF FOXPRO
				DbSetIndex( aArquivos[ nPos, 1 ] )
			#ELSE
				For nY := 2 To nLen
					DbSetIndex( aArquivos[ nPos, nY ] )
				Next
			#ENDIF
	  EndIF
	Else
		Alerta("Erro: Arquivo nao localizado: " + cArquivo )
		ResTela( cScreen )
		Return( FALSO )
	EndIF
	ResTela( cScreen )
	Return( OK )
Else
	For nX := 1 To nTodos
		cArquivo := aArquivos[nX, 1 ]
		nLen		:= Len(aArquivos[nX])
		IF !DbfEmUso( cArquivo )
			IF NetUse( cArquivo, MULTI )
				#IFDEF FOXPRO
					DbSetIndex( aArquivos[ nX, 1 ] )
				#ELSE
					For nY := 2 To nLen
						DbSetIndex( aArquivos[ nX, nY ] )
					Next
				#ENDIF
			 Else
				Alerta("Erro: Arquivo nao localizado: " + cArquivo )
				ResTela( cScreen )
				Return( FALSO )
			EndIF
		EndIF
	Next
	ResTela( cScreen )
	Return( OK )
EndIF

Proc MensFecha()
****************
Mensagem("Aguarde, Fechando Arquivos.", WARNING, _LIN_MSG )
FechaTudo()
Break
Return

Function ArrayArquivos()
************************
LOCAL aArquivos := {}
Aadd( aArquivos, {"LISTA.DBF",{{ "CODIGO",   "C", 06, 0 }, ; // Codigo do Produto
										 { "CODGRUPO",   "C", 03, 0 }, ;
										 { "CODSGRUPO",  "C", 06, 0 }, ;
										 { "DESCRICAO",  "C", 40, 0 }, ;
										 { "UN",         "C", 02, 0 }, ;
										 { "EMB",        "N", 03, 0 }, ;
										 { "QUANT",      "N", 09, 2 }, ;
										 { "VENDIDA",    "N", 09, 2 }, ;
										 { "PEDIDO",     "N", 09, 2 }, ; // Quant Mercadoria Pedida
										 { "ATACADO",    "N", 11, 2 }, ;
										 { "PCOMPRA",    "N", 11, 2 }, ;
										 { "CUSTODOLAR", "N", 11, 2 }, ;
										 { "PCUSTO",     "N", 11, 2 }, ;
										 { "DATA",       "D", 08, 0 }, ;
										 { "N_ORIGINAL", "C", 15, 0 }, ;
										 { "CODEBAR",    "C", 15, 0 }, ;
										 { "SIGLA",      "C", 10, 0 }, ;
										 { "QMAX",       "N", 09, 2 }, ;
										 { "QMIN",       "N", 09, 2 }, ;
										 { "CODI",       "C", 04, 0 }, ; // Codigo do Fabricante/Pagar
										 { "CODI1",      "C", 04, 0 }, ; // Codigo do Fornecedor/Pagar
										 { "CODI2",      "C", 04, 0 }, ; // Codigo do Fornecedor/Pagar
										 { "CODI3",      "C", 04, 0 }, ; // Codigo do Fornecedor/Pagar
										 { "REPRES",     "C", 04, 0 }, ; // Codigo do Representante
										 { "MARCUS",     "N", 06, 2 }, ; // Margem do Pcusto
										 { "MARVAR",     "N", 06, 2 }, ; // Margem do Varejo
										 { "MARATA",     "N", 06, 2 }, ; // Margem do Atacado
										 { "IMPOSTO",    "N", 06, 2 }, ; // Percentual de Imposto
										 { "FRETE",      "N", 06, 2 }, ; // Percentual de Frete
										 { "VAREJO",     "N", 11, 2 }, ;
										 { "BX_CON",     "L", 01, 0 }, ;
										 { "UFIR",       "N", 07, 2 }, ;
										 { "IPI",        "N", 05, 2 }, ;
										 { "II",         "N", 05, 2 }, ;
										 { "SITUACAO",   "C", 01, 0 }, ;
										 { "CLASSE",     "C", 02, 0 }, ;
										 { "TX_ICMS",    "N", 03, 0 }, ; // Aliquota Icms Substituicao
										 { "REDUCAO",    "N", 03, 0 }, ; // Reducao da Base de Calculo
										 { "LOCAL",      "C", 10, 0 }, ;
										 { "TAM",        "C", 06, 0 }, ;
										 { "DESCONTO",   "N", 06, 2 }, ;
										 { "ATUALIZADO", "D", 08, 0 }, ;
										 { "SERVICO",    "L", 01, 0 }, ;
										 { "RO",         "N", 06, 2 }, ;
										 { "AC",         "N", 06, 2 }, ;
										 { "MT",         "N", 06, 2 }, ;
										 { "AM",         "N", 06, 2 }, ;
										 { "RR",         "N", 06, 2 }, ;
										 { "USA",        "L", 01, 0 }, ;
										 { "PORC",       "N", 05, 2 }}})

Aadd( aArquivos, { "SAIDAS.DBF", {{ "CODIGO",     "C", 06, 0 }, ; // Produto
											 { "DOCNR",      "C", 09, 0 }, ;
											 { "CODIVEN",    "C", 04, 0 }, ;
                                  { "TECNICO",    "C", 04, 0 }, ;
                                  { "CAIXA",      "C", 04, 0 }, ;
											 { "FORMA",      "C", 02, 0 }, ;
											 { "CODI",       "C", 05, 0 }, ; // Cliente
											 { "FATURA",     "C", 09, 0 }, ;
											 { "PEDIDO",     "C", 07, 0 }, ;
											 { "REGIAO",     "C", 02, 0 }, ;
											 { "PLACA",      "C", 08, 0 }, ;
											 { "TIPO",       "C", 06, 0 }, ;
											 { "EMIS",       "D", 08, 0 }, ;
											 { "DATA",       "D", 08, 0 }, ;
											 { "DESCONTO",   "N", 05, 2 }, ;
											 { "DIFERENCA",  "N", 11, 2 }, ;
											 { "PORC",       "N", 05, 2 }, ;
											 { "PVENDIDO",   "N", 11, 2 }, ;
											 { "SAIDA",      "N", 09, 2 }, ;
											 { "SAIDAPAGA",  "N", 09, 2 }, ;
											 { "QTD_D_FATU", "N", 02, 0 }, ;
											 { "ATACADO",    "N", 11, 2 }, ;
											 { "VAREJO",     "N", 11, 2 }, ;
											 { "PCUSTO",     "N", 11, 2 }, ;
											 { "PCOMPRA",    "N", 11, 2 }, ;
											 { "VLRFATURA",  "N", 13, 2 },;
											 { "ATUALIZADO", "D", 08, 0 },;
											 { "IMPRESSO",   "L", 01, 0 },;
											 { "SERIE",      "C", 10, 0 },;
											 { "EXPORTADO",  "L", 01, 0 },;
											 { "SITUACAO",   "C", 08, 0 },;
											 { "C_C",        "L", 01, 0 }}})

Aadd( aArquivos, { "ENTRADAS.DBF",  {{ "CODIGO",     "C", 06, 0 }, ; // Produto
												 { "PCUSTO",     "N", 11, 2 }, ;
												 { "CUSTOFINAL", "N", 11, 2 }, ;
												 { "DATA",       "D", 08, 0 }, ;
												 { "DENTRADA",   "D", 08, 0 }, ;
												 { "ENTRADA",    "N", 09, 2 }, ;
												 { "IMPOSTO",    "N", 06, 2 }, ; // Percentual de Imposto
												 { "FRETE",      "N", 06, 2 }, ; // Percentual de Frete
												 { "CONDICOES",  "C", 23, 0 }, ;
												 { "CODI",       "C", 04, 0 }, ; // Fornecedor
												 { "FATURA",     "C", 09, 0 }, ;
												 { "VLRFATURA",  "N", 13, 2 }, ;
												 { "ICMS",       "N", 02, 0 }, ;
												 { "ATUALIZADO", "D", 08, 0 },;
												 { "CFOP",       "C", 05, 0 },;
												 { "VLRNFF",     "N", 13, 2 }}})

Aadd( aArquivos, { "RECEBER.DBF", {{ "CODI",      "C", 05, 0 }, ; // Cliente
											  { "NOME",      "C", 40, 0 }, ;
											  { "ENDE",      "C", 30, 0 }, ;
											  { "CIDA",      "C", 25, 0 }, ;
											  { "ESTA",      "C", 02, 0 }, ;
											  { "CEP",       "C", 09, 0 }, ;
											  { "PRACA",     "C", 09, 0 }, ;
											  { "CPF",       "C", 14, 0 }, ;
											  { "CGC",       "C", 18, 0 }, ;
											  { "INSC",      "C", 15, 0 }, ;
											  { "RG",        "C", 18, 0 }, ;
											  { "BAIR",      "C", 20, 0 }, ;
											  { "DATA",      "D", 08, 0 }, ;
											  { "FONE",      "C", 14, 0 }, ;
											  { "OBS",       "C", 60, 0 }, ;
											  { "OBS1",      "C", 60, 0 }, ;
											  { "OBS2",      "C", 60, 0 }, ;
											  { "OBS3",      "C", 60, 0 }, ;
											  { "OBS4",      "C", 60, 0 }, ;
											  { "OBS5",      "C", 60, 0 }, ;
											  { "OBS6",      "C", 60, 0 }, ;
											  { "OBS7",      "C", 60, 0 }, ;
											  { "OBS8",      "C", 60, 0 }, ;
											  { "OBS9",      "C", 60, 0 }, ;
											  { "OBS10",     "C", 60, 0 }, ;
											  { "OBS11",     "C", 60, 0 }, ;
											  { "OBS12",     "C", 60, 0 }, ;
											  { "OBS13",     "C", 60, 0 }, ;
											  { "FANTA",     "C", 40, 0 }, ;
											  { "FAX",       "C", 14, 0 }, ;
											  { "MEDIA",     "N", 11, 2 }, ;
											  { "REFBCO",    "C", 40, 0 }, ;
											  { "REFCOM",    "C", 40, 0 }, ;
											  { "IMOVEL",    "C", 40, 0 }, ;
											  { "REGIAO",    "C", 02, 0 }, ;
											  { "MATRASO",   "N", 03, 0 }, ;   // Maior Atraso
											  { "VLRCOMPRA", "N", 13, 2 }, ;   // Vlr da Ultima compra
											  { "EMIS",      "D", 08, 0 }, ;
											  { "CIVIL",     "C", 15, 0 }, ;
											  { "NATURAL",   "C", 30, 0 }, ;
											  { "NASC",      "D", 08, 0 }, ;
											  { "ESPOSA",    "C", 40, 0 }, ;
											  { "DEPE",      "N", 02, 0 }, ;
											  { "PAI",       "C", 40, 0 }, ;
											  { "MAE",       "C", 40, 0 }, ;
											  { "ENDE1",     "C", 30, 0 }, ;
											  { "FONE1",     "C", 14, 0 }, ;
											  { "FONE2",     "C", 14, 0 }, ;
											  { "PROFISSAO", "C", 30, 0 }, ;
											  { "CARGO",     "C", 20, 0 }, ;
											  { "TRABALHO",  "C", 30, 0 }, ;
											  { "TEMPO",     "C", 20, 0 }, ;
											  { "VEICULO",   "C", 40, 0 }, ;
											  { "CONHECIDA", "C", 40, 0 }, ;
											  { "ENDE3",     "C", 30, 0 }, ;
											  { "CIDAAVAL",  "C", 25, 0 }, ;
											  { "ESTAAVAL",  "C", 02, 0 }, ;
											  { "BAIRAVAL",  "C", 20, 0 }, ;
											  { "FONEAVAL",  "C", 14, 0 }, ;
											  { "FAXAVAL",   "C", 14, 0 }, ;
											  { "CPFAVAL",   "C", 14, 0 }, ;
											  { "RGAVAL",    "C", 18, 0 }, ;
											  { "SPC",       "L", 01, 0 }, ;
											  { "DATASPC",   "D", 08, 0 }, ;
											  { "BANCO",     "C", 30, 0 }, ;
											  { "LIMITE",    "N", 13, 2 }, ;  // Limite de Credito
											  { "CANCELADA",  "L", 01, 0 }, ;  // Ficha Cancelada
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "FABRICANTE", "C", 40, 0 },;
											  { "PRODUTO",    "C", 40, 0 },;
											  { "MODELO",     "C", 30, 0 },;
											  { "VALOR",      "N", 13, 2 },;
											  { "LOCAL",      "C", 30, 0 },;
											  { "PRAZO",      "N", 03, 0 },;
											  { "DATAVCTO",   "N", 02, 0 },;
											  { "PRAZOEXT",   "N", 03, 0 },;
											  { "SCI",        "L", 01, 0 },;
											  { "SUPORTE",    "L", 01, 0 },;
											  { "AUTORIZACA", "L", 01, 0 },;
											  { "ASSAUTORIZ", "L", 01, 0 },;
											  { "PROXCOB",    "D", 08, 0 },;
											  { "EXPORTADO",  "L", 01, 0 },;
											  { "ROL",        "L", 01, 0 },;
											  { "CFOP",       "C", 05, 0 },;
											  { "TX_ICMS",    "N", 05, 2 },;
											  { "ULTCOMPRA",  "D",  8, 0 }}})  // Ultima Compra

Aadd( aArquivos, { "REPRES.DBF",;
											{{ "REPRES", "C",  4, 0 }, ;
											 { "NOME",   "C", 40, 0 }, ;
											 { "ENDE",   "C", 30, 0 }, ;
											 { "CIDA",   "C", 25, 0 }, ;
											 { "ESTA",   "C",  2, 0 }, ;
											 { "CEP",    "C",  9, 0 }, ;
											 { "CGC",    "C", 18, 0 }, ;
											 { "INSC",   "C", 15, 0 }, ;
											 { "BAIR",   "C", 20, 0 }, ;
											 { "FONE",   "C", 14, 0 }, ;
											 { "CON",    "C", 20, 0 }, ;
											 { "OBS",    "C", 60, 0 }, ;
											 { "FAX",    "C", 14, 0 }, ;
											 { "ATUALIZADO", "D", 08, 0 },;
											 { "CAIXA",  "C",  3, 0 }}})

Aadd( aArquivos, { "RECEMOV.DBF", {{ "CODI",       "C", 05, 0 }, ; // Cliente
											  { "CODIVEN",    "C", 04, 0 }, ;
											  { "CAIXA",      "C", 04, 0 }, ;
											  { "DOCNR",      "C", 09, 0 }, ;
											  { "FATURA",     "C", 09, 0 }, ;
											  { "PORT",       "C", 10, 0 }, ;
											  { "TIPO",       "C", 06, 0 }, ;
											  { "NOSSONR",    "C", 13, 0 }, ;
											  { "BORDERO",    "C", 09, 0 }, ;
											  { "FORMA",      "C", 02, 0 }, ;
											  { "COBRADOR",   "C", 04, 0 }, ;
											  { "REGIAO",     "C", 02, 0 }, ;
											  { "VLR",        "N", 13, 2 }, ;
											  { "VLRPAG",     "N", 13, 2 }, ;											  
											  { "VLRDOLAR",   "N", 13, 2 }, ;
                                   { "JURODIA",    "N", 16, 5 }, ;
                                   { "JUROTOTAL",  "N", 16, 5 }, ;
                                   { "JURO",       "N", 09, 5 }, ;
											  { "QTD_D_FATU", "N", 02, 0 }, ;
											  { "VLRFATU",    "N", 13, 2 }, ;
											  { "PORC",       "N", 05, 2 }, ;
											  { "EMIS",       "D", 08, 0 }, ;
											  { "VCTO",       "D", 08, 0 }, ;
											  { "DATAPAG",    "D", 08, 0 }, ;											  
											  { "TITULO",     "L", 01, 0 }, ;
											  { "ATUALIZADO", "D", 08, 0 }, ;
											  { "STPAG",      "L", 01, 0 }, ;
											  { "CODGRUPO",   "C", 03, 0 }, ;
											  { "EXPORTADO",  "L", 01, 0 }, ; 
											  { "RELCOB",     "L", 01, 0 }, ;   // Relatorio Cobranca Emitido ?
                                   { "OBS",        "C", 80, 0 }, ;
                                   { "COMISSAO",   "L", 01, 0 }}})  // Lancar Comissao ?

Aadd( aArquivos, { "GRUPO.DBF",   {{ "CODGRUPO",   "C", 03, 0 },;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "SERVICO",    "L", 01, 0 },;
											  { "DESGRUPO",   "C", 40, 0 }}})

Aadd( aArquivos, { "SUBGRUPO.DBF", {{ "CODSGRUPO",  "C", 06, 0 },;
												{ "ATUALIZADO", "D", 08, 0 },;
												{ "DESSGRUPO",  "C", 40, 0 }}})

Aadd( aArquivos, { "VENDEDOR.DBF",;
											 {{ "CODIVEN",  "C",  4, 0 }, ;
											  { "NOME",     "C", 40, 0 }, ;
											  { "ENDE",     "C", 25, 0 }, ;
											  { "SENHA",    "C", 10, 0 }, ;
											  { "CIDA",     "C", 25, 0 }, ;
											  { "ESTA",     "C",  2, 0 }, ;
											  { "CEP",      "C",  9, 0 }, ;
											  { "CPF",      "C", 14, 0 }, ;
											  { "RG",       "C", 18, 0 }, ;
											  { "CT",       "C", 10, 0 }, ;
											  { "BAIR",     "C", 20, 0 }, ;
											  { "DATA",     "D",  8, 0 }, ;
                                   { "FONE",     "C", 14, 0 }, ;
											  { "CON",      "C", 20, 0 }, ;
											  { "OBS",      "C", 30, 0 }, ;
											  { "PORCCOB",  "N", 05, 2 }, ;
											  { "COMDISP",  "N", 13, 2 }, ;
											  { "COMBLOQ",  "N", 13, 2 }, ;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "ROL",        "L", 01, 0 },;
											  { "COMISSAOS", "N", 13, 3 },;
											  { "COMISSAO", "N", 13, 2 }}})

Aadd( aArquivos, { "VENDEMOV.DBF",;
											 {{ "CODIVEN",    "C", 04, 0 }, ;
											  { "CODI",       "C", 05, 0 }, ; // Cliente
											  { "VLR",        "N", 13, 2 }, ;
											  { "DC",         "C", 01, 0 }, ;
											  { "DOCNR",      "C", 09, 0 }, ;
											  { "DATA",       "D", 08, 0 }, ;
											  { "VCTO",       "D", 08, 0 }, ;
											  { "PORC",       "N", 05, 2 }, ;
											  { "COMDISP",    "N", 13, 2 }, ;
											  { "COMBLOQ",    "N", 13, 2 }, ;
											  { "COMISSAO",   "N", 13, 2 }, ;
											  { "PEDIDO",     "C", 07, 0 }, ;
											  { "DATAPED",    "D", 08, 0 }, ;
											  { "FATURA",     "C", 09, 0 }, ;
											  { "FORMA",      "C", 02, 0 }, ;
											  { "DESCRICAO",  "C", 40, 0 },;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "REGIAO",     "C", 02, 0 }}})

Aadd( aArquivos, { "ENTNOTA.DBF",;
											{{ "NUMERO",     "C", 07, 0 },;
											 { "CODI",       "C", 04, 0 },; // Fornecedor
											 { "VLRFATURA",  "N", 13, 2 },;
											 { "VLRNFF",     "N", 13, 2 },;
											 { "ICMS",       "N", 02, 0 },;
											 { "ENTRADA",    "D", 08, 0 },;
											 { "ATUALIZADO", "D", 08, 0 },;
											 { "CONDICOES",  "C", 23, 0 }, ;
											 { "CONDICOES",  "C", 23, 0 }, ;
											 { "DATA",       "D", 08, 0 }}})

Aadd( aArquivos, { "NOTA.DBF",;
											{{ "NUMERO",     "C", 07, 0 },;
											 { "ATUALIZADO", "D", 08, 0 },;
											 { "DATA",       "D", 08, 0 },;  // Data Nota Fiscal
											 { "SITUACAO",   "C", 08, 0 },;
                                  { "CAIXA",      "C", 04, 0 },;
											 { "CODI",       "C", 05, 0 }}}) // Cliente

Aadd( aArquivos, { "PAGAMOV.DBF",;
											 {{ "CODI",       "C", 04, 0 }, ; // Fornecedor
											  { "DESC",       "C", 04, 0 }, ;
											  { "VLR",        "N", 13, 2 }, ;
											  { "JURODIA",    "N", 13, 2 }, ;
											  { "DESCONTO",   "N", 06, 2 }, ;
											  { "JURO",       "N", 06, 2 }, ;
											  { "EMIS",       "D", 08, 0 }, ;
											  { "VCTO",       "D", 08, 0 }, ;
											  { "DOCNR",      "C", 09, 0 }, ;
											  { "PORT",       "C", 10, 0 }, ;
											  { "TIPO",       "C", 06, 0 }, ;
											  { "FATURA",     "C", 09, 0 }, ;
											  { "VLRFATU",    "N", 13, 2 }, ;
											  { "OBS1",       "C", 60, 0 }, ;
											  { "OBS2",       "C", 60, 0 }, ;
											  { "ATUALIZADO", "D", 08, 0 }}})

Aadd( aArquivos, { "PAGAR.DBF",;
											{{ "CODI",   "C",  4, 0 }, ; // Fornecedor
											 { "REPRES", "C",  4, 0 }, ; // Codigo do Representante
											 { "NOME",   "C", 40, 0 }, ;
											 { "SIGLA",  "C", 10, 0 }, ; // Sigla do Fornecedor
											 { "ENDE",   "C", 30, 0 }, ;
											 { "CIDA",   "C", 25, 0 }, ;
											 { "ESTA",   "C",  2, 0 }, ;
											 { "CEP",    "C",  9, 0 }, ;
											 { "CPF",    "C", 14, 0 }, ;
											 { "CGC",    "C", 18, 0 }, ;
											 { "INSC",   "C", 15, 0 }, ;
											 { "RG",     "C", 18, 0 }, ;
											 { "BAIR",   "C", 20, 0 }, ;
											 { "DATA",   "D",  8, 0 }, ;
											 { "FONE",   "C", 14, 0 }, ;
											 { "CON",    "C", 20, 0 }, ;
											 { "OBS",    "C", 30, 0 }, ;
											 { "TIPO",   "C",  6, 0 }, ;
											 { "FANTA",  "C", 40, 0 }, ;
											 { "FAX",    "C", 14, 0 }, ;
											 { "ATUALIZADO", "D", 08, 0 },;
											 { "CAIXA",  "C",  3, 0 }}})

Aadd( aArquivos, { "TAXAS.DBF",;
											 {{ "DINI",    "D", 08, 0 }, ;
											  { "DFIM",    "D", 08, 0 }, ;
											  { "TXATU",   "N", 06, 2 }, ;
											  { "JURATA",  "N", 06, 2 }, ;
											  { "UFIR",    "N", 07, 2 }, ;
											  { "JURVAR",  "N", 06, 2 }, ;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "COTACAO", "N", 11, 2 }}})

Aadd( aArquivos, { "PAGO.DBF",;
											 {{ "CODI",       "C", 04, 0 },; // Fornecedor
											  { "VLR",        "N", 13, 2 },;
											  { "EMIS",       "D", 08, 0 },;
											  { "VCTO",       "D", 08, 0 },;
											  { "DOCNR",      "C", 09, 0 },;
											  { "FATURA",     "C", 09, 0 }, ;
											  { "DATAPAG",    "D", 08, 0 },;
											  { "VLRPAG",     "N", 13, 2 },;
											  { "PORT",       "C", 10, 0 },;
											  { "TIPO",       "C", 06, 0 },;
											  { "JURO",       "N", 06, 2 },;
											  { "OBS1",       "C", 60, 0 }, ;
											  { "OBS2",       "C", 60, 0 }, ;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "NDEB",       "C", 03, 0 }}})

Aadd( aArquivos, { "RECEBIDO.DBF",;
                                  {{ "CODI" ,    "C",  05 , 0 },; // Cliente
                                   { "REGIAO",   "C",  02 , 0 },;
                                   { "CAIXA",    "C",  04 , 0 }, ;
											  { "CODIVEN",  "C" , 04 , 0 },;
											  { "DOCNR" ,   "C" , 09 , 0 },;
											  { "FATURA",   "C" , 09 , 0 },;
											  { "PORT" ,    "C" , 10 , 0 },;
											  { "TIPO" ,    "C" , 06 , 0 },;
											  { "NOSSONR" , "C" , 13 , 0 },;
											  { "BORDERO" , "C" , 09 , 0 },;
											  { "FORMA",    "C",  02 , 0 },;
											  { "OBS",      "C",  40 , 0 },;
											  { "DATAPAG" , "D" , 08 , 0 },;
											  { "BAIXA",    "D",  08 , 0 },;
											  { "EMIS" ,    "D" , 08 , 0 },;
											  { "VCTO" ,    "D" , 08 , 0 },;
											  { "VLR" ,     "N" , 13 , 2 },;
											  { "VLRPAG" ,  "N" , 13 , 2 },;
											  { "ATUALIZADO", "D", 08, 0 },;
                                   { "EXPORTADO","L", 01, 0 },;
											  { "PARCIAL",  "C",  01, 0 },;
											  { "JURO" ,    "N",  06, 2 }}})
Aadd( aArquivos, { "CHEQUE.DBF",;
											 {{ "CODI",     "C", 04, 0 },; // Conta
											  { "BANCO",    "C", 10, 0 },;
											  { "TITULAR",  "C", 40, 0 },;
											  { "AG",       "C", 25, 0 },;
											  { "CGC",      "C", 18, 0 },;
											  { "CONTA",    "C",  8, 0 },;
											  { "DATA",     "D",  8, 0 },;
											  { "SALDO",    "N", 17, 2 },;
											  { "DEBITOS",  "N", 18, 2 },;
											  { "CREDITOS", "N", 18, 2 },;
                                   { "FONE",     "C", 14, 0 },;
											  { "MENS",     "L", 01, 0 },;
											  { "OBS",      "C", 40, 0 },;
											  { "CPF",      "C", 15, 0 },;
											  { "CPF1",     "C", 15, 0 },;
											  { "RG",       "C", 18, 0 },;
											  { "RG1",      "C", 18, 0 },;
											  { "NASCI",    "D", 08, 0 },;
											  { "ENDE",     "C", 35, 0 },;
											  { "ENDE1",    "C", 35, 0 },;
											  { "CIDA",     "C", 25, 0 },;
											  { "ESTA",     "C", 02, 0 },;
											  { "PROFISSAO","C", 15, 0 },;
											  { "TRABALHO", "C", 40, 0 },;
                                   { "FONE1",    "C", 14, 0 },;
                                   { "FONE2",    "C", 14, 0 },;
											  { "RESP",     "C", 40, 0 },;
											  { "HORARIO",  "C", 11, 0 },;
											  { "DIAS",     "C", 15, 0 },;
											  { "C_C",      "L", 01, 0 },;
											  { "EXTERNA",  "L", 01, 0 },;
											  { "ATIVO",    "L", 01, 0 },;
											  { "CURSO",    "C", 04, 0 },;
											  { "RENOVADO", "L", 01, 0 },;
											  { "POUPANCA", "L", 01, 0 },;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "DEB_DEB",    "C", 01, 0 },;
											  { "DEB_CRE",    "C", 01, 0 },;
											  { "CRE_DEB",    "C", 01, 0 },;
											  { "CRE_CRE",    "C", 01, 0 },;
											  { "DURACAO",    "N", 02, 0 }}})

Aadd( aArquivos, { "CHEMOV.DBF",;
											{{ "CODI",   "C", 04, 0 } , ; // Conta
											 { "DATA",   "D", 08, 0 } , ;
											 { "EMIS",   "D", 08, 0 } , ;
											 { "BAIXA",  "D", 08, 0 } , ;
											 { "SALDO",  "N", 15, 2 } , ;
											 { "HIST",   "C", 40, 0 } , ;
											 { "DOCNR",  "C", 09, 0 } , ;
											 { "FATURA", "C", 09, 0 } , ;
											 { "CAIXA",  "C", 04, 0 } , ;
											 { "CRE",    "N", 15, 2 } , ;
											 { "DEB",    "N", 15, 2 } , ;
											 { "ATUALIZADO", "D", 08, 0 },;
											 { "CPARTIDA", "L", 01, 0 },;
											 { "TIPO",     "C", 06, 0 }}})

Aadd( aArquivos, { "CHEPRE.DBF",;
											 {{ "CODI",       "C", 04, 0 } , ; // Conta
											  { "BANCO",      "C", 10, 0 } , ;
											  { "CONTA",      "C", 08, 0 } , ;
											  { "DATA",       "D", 08, 0 } , ;
											  { "VCTO",       "D", 08, 0 } , ;
											  { "SALDO",      "N", 15, 2 } , ;
											  { "HIST",       "C", 40, 0 } , ;
											  { "DOCNR",      "C", 09, 0 } , ;
											  { "VALOR",      "N", 15, 2 } , ;
											  { "PRACA",      "C", 20, 0 } , ;
											  { "AGENCIA",    "C", 10, 0 } , ;
											  { "CPFCGC",     "C", 14, 0 } , ;
											  { "DEBCRE",     "C", 01, 0 } , ;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "OBS",        "C", 40, 0 }}})

Aadd( aArquivos, { "REGIAO.DBF",;
											 {{ "REGIAO",  "C", 02, 0 },;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "NOME",    "C", 40, 0 }}})

Aadd( aArquivos, { "USUARIO.DBF",;
											 {{ "NOME",    "C", 10, 0 },;
											  { "SENHA",   "C", 10, 0 },;
											  { "NIVEL1",  "C", 01, 0 },;
											  { "NIVEL2",  "C", 01, 0 },;
											  { "NIVEL3",  "C", 01, 0 },;
											  { "NIVEL4",  "C", 01, 0 },;
											  { "NIVEL5",  "C", 01, 0 },;
											  { "NIVEL6",  "C", 01, 0 },;
											  { "NIVEL7",  "C", 01, 0 },;
											  { "NIVEL8",  "C", 01, 0 },;
											  { "NIVEL9",  "C", 01, 0 },;
											  { "NIVEL0",  "C", 01, 0 },;
											  { "NIVELA",  "C", 01, 0 },;
											  { "NIVELB",  "C", 01, 0 },;
											  { "NIVELC",  "C", 01, 0 },;
											  { "NIVELD",  "C", 01, 0 },;
											  { "NIVELE",  "C", 01, 0 },;
											  { "NIVELF",  "C", 01, 0 },;
											  { "NIVELG",  "C", 01, 0 },;
											  { "NIVELH",  "C", 01, 0 },;
											  { "NIVELI",  "C", 01, 0 },;
											  { "NIVELJ",  "C", 01, 0 },;
											  { "NIVELK",  "C", 01, 0 },;
											  { "NIVELL",  "C", 01, 0 },;
											  { "NIVELM",  "C", 01, 0 },;
											  { "NIVELN",  "C", 01, 0 },;
											  { "NIVELO",  "C", 01, 0 },;
											  { "NIVELP",  "C", 01, 0 },;
											  { "NIVELQ",  "C", 01, 0 },;
											  { "NIVELR",  "C", 01, 0 },;
											  { "NIVELS",  "C", 01, 0 },;
											  { "LPT1",    "C", 02, 0 },;
											  { "LPT2",    "C", 02, 0 },;
											  { "LPT3",    "C", 02, 0 },;
											  { "LPT4",    "C", 02, 0 },;
											  { "COM1",    "C", 02, 0 },;
											  { "COM2",    "C", 02, 0 },;
											  { "COM3",    "C", 02, 0 },;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "COM4",    "C", 02, 0 }}})

Aadd( aArquivos, { "CURSOS.DBF",;
											 {{ "CURSO",   "C", 04, 0 } , ;
											  { "OBS",     "C", 40, 0 } , ;
											  { "MENSAL",  "N", 13, 2 } , ;
											  { "RENOVA",  "N", 13, 2 } , ;
											  { "TAXA",    "N", 13, 2 } , ;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "DURACAO", "N", 03, 0 }}})
Aadd( aArquivos, { "CURSADO.DBF",;
											 {{ "CURSO",       "C", 04, 0 } , ;
											  { "CODI",        "C", 05, 0 } , ; // Cliente
											  { "FATURA",      "C", 09, 0 } , ;
											  { "MENSALIDAD",  "N", 13, 2 } , ;
											  { "MATRICULA",   "N", 13, 2 } , ;
											  { "INICIO",      "D", 08, 0 } , ;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "TERMINO",     "D", 08, 0 }}})

Aadd( aArquivos, { "FORMA.DBF",;
											 {{ "FORMA",      "C", 02, 0 },;
											  { "CONDICOES",  "C", 40, 0 },;
											  { "DESCRICAO",  "C", 40, 0 },;
											  { "COMISSAO",   "N", 05, 2 },;
											  { "IOF",        "N", 08, 4 },;
											  { "DESDOBRAR",  "L", 01, 0 },;
											  { "VISTA",      "L", 01, 0 },;
											  { "PARCELAS",   "N", 02, 0 },;
											  { "DIAS",       "N", 03, 0 },;
											  { "ATUALIZADO", "D", 08, 0 }}})

Aadd( aArquivos, { "CEP.DBF",;
											 {{ "CEP",        "C", 09, 0 }, ;
											  { "CIDA",       "C", 25, 0 }, ;
											  { "ESTA",       "C", 02, 0 }, ;
											  { "ATUALIZADO", "D", 08, 0 }, ;
											  { "BAIR",       "C", 20, 0 }}})

Aadd( aArquivos, { "SERVIDOR.DBF",;
											 {{ "CODI",    "C", 04, 0 }, ;
											  { "NOME",    "C", 40, 0 }, ;
											  { "SENHA",   "C", 10, 0 },;
											  { "CARGO",   "C", 30, 0 }, ;
											  { "QUANT",   "N", 09, 2 }, ;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "CARGA",   "N", 09, 2 }}})

Aadd( aArquivos, { "PONTO.DBF",;
											 {{ "CODI",    "C", 04, 0 }, ;
											  { "DATA",    "D", 08, 0 }, ;
											  { "QUANT",   "N", 09, 2 }, ;
											  { "MANHA1",  "C", 05, 0 }, ;
											  { "MANHA2",  "C", 05, 0 }, ;
											  { "TARDE1",  "C", 05, 0 }, ;
											  { "ATUALIZADO", "D", 08, 0 },;
											  { "TARDE2",  "C", 05, 0 }}})

Aadd( aArquivos, { "PRINTER.DBF",;
											 {{ "CODI",      "C", 02, 0 },;
											  { "NOME",      "C", 40, 0 },;
											  { "_CPI10",    "C", 40, 0 },;
											  { "_CPI12",    "C", 40, 0 },;
											  { "GD",        "C", 40, 0 },;
											  { "PQ",        "C", 40, 0 },;
											  { "NG",        "C", 40, 0 },;
											  { "NR",        "C", 40, 0 },;
											  { "CA",        "C", 40, 0 },;
											  { "C18",       "C", 40, 0 },;
											  { "LIGSUB",    "C", 40, 0 },;
											  { "DESSUB",    "C", 40, 0 },;
											  { "_SALTOOFF", "C", 40, 0 },;
											  { "_SPACO1_8", "C", 40, 0 },;
											  { "_SPACO1_6", "C", 40, 0 },;
											  { "RESETA",    "C", 40, 0 },;
											  { "ATUALIZADO", "D", 08, 0 }}})
Aadd( aArquivos, { "CONTA.DBF",;
											 {{ "CODI",       "C", 02, 0 },;
											  { "HIST",       "C", 40, 0 },;
											  { "ATUALIZADO", "D", 08, 0 }}})
Aadd( aArquivos, { "SUBCONTA.DBF",;
											 {{ "CODI",       "C", 02, 0 },;
											  { "SUBCODI",    "C", 04, 0 },;
											  { "DEBCRE",     "C", 01, 0 },;
											  { "ATUALIZADO", "D", 08, 0 }}})

Aadd( aArquivos, { "RETORNO.DBF",;
											  {{"ID",         "N", 07, 0 },;
												{"CODI",       "C", 05, 0 },; // Cliente
												{"EMPRESA",    "C", 40, 0 },;
												{"INTERNO",    "C", 12, 0 },;
												{"CODIGO",     "C", 13, 0 },;
												{"HORA",       "C", 08, 0 },;
												{"VERSAO",     "N", 01, 0 },;
												{"LIMITE",     "D", 08, 0 },;
												{"DATA",       "D", 08, 0 },;
												{"NOME",       "C", 10, 0 },;
												{"ATUALIZADO", "D", 08, 0 }}})

Aadd( aArquivos, { "PREVENDA.DBF",{{ "CODIGO",     "C", 06, 0 }, ; // Codigo do Produto
											  { "CODIVEN",    "C", 04, 0 }, ;
											  { "CODI",       "C", 05, 0 }, ;
											  { "NOME",       "C", 40, 0 }, ;
											  { "FATURA",     "C", 07, 0 }, ;
											  { "EMIS",       "D", 08, 0 }, ;
											  { "PVENDIDO",   "N", 11, 2 }, ;
											  { "UNITARIO",   "N", 11, 2 }, ;
											  { "DESCONTO",   "N", 05, 2 }, ;
											  { "DESCMAX",    "N", 06, 2 }, ;
											  { "SAIDA",      "N", 09, 2 }, ;
											  { "QUANT",      "N", 09, 2 }, ;
											  { "ATACADO",    "N", 11, 2 }, ;
											  { "VAREJO",     "N", 11, 2 }, ;
											  { "PCUSTO",     "N", 11, 2 }, ;
											  { "VLRFATURA",  "N", 13, 2 },;
											  { "DESCRICAO",  "C", 40, 0 },;
											  { "UN",         "C", 02, 0 },;
											  { "TAM",        "C", 06, 0 },;
                                   { "SIGLA",      "C", 10, 0 },;
											  { "PORC",       "N", 05, 2 },;
											  { "TOTAL",      "N", 13, 2 },;
											  { "SERIE",      "C", 10, 0 },;
											  { "FORMA",      "C", 02, 0 },;
											  { "APARELHO",   "C", 20, 0 },;
											  { "MARCA",      "C", 20, 0 },;
											  { "MODELO",     "C", 20, 0 },;
											  { "NRSERIE",    "C", 20, 0 },;
											  { "OBS",        "C", 40, 0 },;
											  { "OBS1",       "C", 40, 0 },;
											  { "OBS2",       "C", 40, 0 },;
											  { "ENDE",       "C", 25, 0 },;
                                   { "FONE",       "C", 14, 0 },;
											  { "REGIAO",     "C", 02, 0 },;
											  { "ANO",        "C", 04, 0 },;
											  { "COR",        "C", 20, 0 },;
											  { "PLACA",      "C", 08, 0 },;
											  { "ESTADO",     "C", 20, 0 },;
											  { "ATUALIZADO", "D", 08, 0 }}})

Aadd( aArquivos, { "GRPSER.DBF",;
			  {{ "GRUPO",      "C", 03, 0 }, ;
				{ "DESGRUPO",   "C", 40, 0 }, ;
				{ "ATUALIZADO", "D", 08, 0 }}})

Aadd( aArquivos, { "SERVICO.DBF",;
			  {{ "CODISER",    "C", 03, 0 }, ;
				{ "NOME",       "C", 40, 0 }, ;
				{ "GRUPO",      "C", 03, 0 }, ;
				{ "ATUALIZADO", "D", 08, 0 },;
				{ "VALOR",      "N", 13, 4 }}})

Aadd( aArquivos, { "CORTES.DBF",;
			  {{ "TABELA",     "C", 08, 0 }, ;
				{ "QTD",        "N", 05, 0 }, ;
				{ "SOBRA",      "N", 05, 0 }, ;
				{ "CODISER",    "C", 03, 0 }, ;
				{ "CODIGO",     "C", 06, 0 }, ;
				{ "ATUALIZADO", "D", 08, 0 },;
				{ "DATA",       "D", 08, 0 }}})

Aadd( aArquivos, { "MOVI.DBF",;
			  {{ "TABELA",     "C", 08, 0 },;
				{ "QTD",        "N", 05, 0 },;
				{ "CODIVEN",    "C", 04, 0 },;
				{ "CODISER",    "C", 03, 0 },;
				{ "CODIGO",     "C", 06, 0 },;
				{ "BAIXADO",    "L", 01, 0 },;
				{ "ATUALIZADO", "D", 08, 0 },;
				{ "DATA",       "D", 08, 0 }}})

Aadd( aArquivos, { "FUNCIMOV.DBF",;
			  {{ "CODIVEN",   "C", 04, 0 }, ;
				{ "CODI",      "C", 04, 0 }, ;
				{ "CRE",       "N", 11, 4 }, ;
				{ "DEB",       "N", 11, 4 }, ;
				{ "VLR",       "N", 11, 4 }, ;
				{ "DOCNR",     "C", 09, 0 }, ;
				{ "DATA",      "D", 08, 0 }, ;
				{ "DESCRICAO", "C", 40, 0 }, ;
				{ "ATUALIZADO","D", 08, 0 },;
				{ "COMISSAO",  "N", 13, 4 }}})

Aadd( aArquivos, { "RECIBO.DBF",;
           {{ "TIPO",       "C", 06, 0 }, ;
            { "CODI",       "C", 05, 0 }, ;
            { "NOME",       "C", 40, 0 }, ;
            { "VLR",        "N", 13, 2 }, ;
            { "FATURA",     "C", 09, 0 }, ;
            { "DOCNR",      "C", 09, 0 }, ;
            { "VCTO",       "D", 08, 0 }, ;
            { "DATA",       "D", 08, 0 }, ;
            { "HORA",       "C", 08, 0 }, ;
            { "USUARIO",    "C", 10, 0 }, ;
            { "CAIXA",      "C", 04, 0 }, ;
            { "ATUALIZADO", "D", 08, 0 }, ;
            { "HIST",       "C", 120, 0 }}})

Aadd( aArquivos, { "AGENDA.DBF",;
           {{ "CODI",       "C", 05, 0 }, ;
            { "HIST",       "C", 132, 0 }, ;
            { "DATA",       "D", 08, 0 }, ;
            { "HORA",       "C", 08, 0 },;
            { "USUARIO",    "C", 10, 0 }, ;
            { "CAIXA",      "C", 04, 0 }, ;
            { "ULTIMO",     "L", 01, 0 }, ;
            { "ATUALIZADO", "D", 08, 0 }}})

Aadd( aArquivos, { "CM.DBF",;
           {{ "CODI",       "C", 05, 0 }, ;
            { "INICIO",     "D", 08, 0 }, ;
            { "FIM",        "D", 08, 0 },;
            { "INDICE",     "N", 09, 4 }, ;
            { "OBS",        "C", 40, 0 }, ;
            { "ULTIMO",     "L", 01, 0 }, ;
            { "ATUALIZADO", "D", 08, 0 }}})

Return( aArquivos )

Proc CriaArquivo( cArquivo )
****************************
LOCAL cScreen := SaveScreen()
LOCAL aArquivos := {}
LOCAL cTela
LOCAL nQtArquivos
LOCAL nQt
LOCAL nTam
LOCAL nX
LOCAL nPos

aArquivos := ArrayArquivos()
IF cArquivo != NIL
	nPos := Ascan( aArquivos,{ |oBloco|oBloco[1] = cArquivo })
	IF nPos != 0
		cArquivo := aArquivos[nPos,1]
		IF !File( cArquivo )
			Mensagem( "Aguarde, Gerando Arquivo " + cArquivo, Cor())
			DbCreate( cArquivo, aArquivos[ nPos, 2] )
			Return( OK )
		EndIF
	EndIF
	Return( FALSO )
EndIF
nQtArquivos := Len( aArquivos )
For nQt := 1 To nQtArquivos
	cArquivo := aArquivos[nQt,1]
	IF !File( cArquivo )
		Mensagem( "Aguarde, Gerando Arquivo " + cArquivo, Cor())
		DbCreate( cArquivo, aArquivos[nQt,2] )
	Else
		IF NetUse( cArquivo, MULTI )
			Integridade( aArquivos[nQt, 2], Cor())
		Else
			SetMode(oAmbiente:AlturaFonteDefaultWindows, oAmbiente:LarguraFonteDefaultWindows)
			Cls
			Quit
		EndIF
	EndIF
Next
ResTela( cScreen )
cTela := Mensagem("Aguarde, Fechando Base de Dados.", Cor())
FechaTudo()
ResTela( cTela )
Return

Function ExcluirTemporarios()
*****************************
LOCAL cTela := Mensagem("Aguarde, Excluindo Arquivos Temporarios.")

Aeval( Directory( "*.$*"),  { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.$$$"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.TMP"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.BAK"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.MEM"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T0*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T1*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T2*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T3*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T4*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T5*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T6*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T7*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T8*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "T9*.*"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*."),    { | aFile | Ferase( aFile[ F_NAME ] )})
return(ResTela(cTela))

Proc Duplicados()
*****************
LOCAL cFile
LOCAL xDbf
LOCAL xNtx
LOCAL nx

Mensagem("Informa: Aguarde, Excluindo Arquivos Temporarios.")
oMenu:Limpa()
Aeval( Directory( "*.CDX"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.NTX"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.NSX"), { | aFile | Ferase( aFile[ F_NAME ] )})
Aeval( Directory( "*.LIX"), { | aFile | Ferase( aFile[ F_NAME ] )})
ExcluirTemporarios()
/*************************************************************************************************/
cFile := "SAIDAS"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Saidas
Inde On Codigo + Docnr + CodiVen + Codi + Fatura + Pedido + DateToStr( Data ) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "RECEMOV"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Recemov
Inde On Docnr + Fatura + Codi + CodiVen + Caixa + Str( Vlr, 13,2 ) + DateToStr( Vcto ) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "VENDEMOV"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Vendemov
Inde On Fatura + CodiVen + Codi + Str( Vlr, 13,2 ) + DateToStr( Data ) To ( xNtx) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "NOTA"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Nota
Inde On Numero To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "PAGO"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Pago
Inde On Codi + Str( Vlr, 13, 2 ) + DateToStr( Vcto ) + Docnr + DateToStr( DataPag) + Str( VlrPag, 13, 2 ) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "CHEQUE"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Cheque
Inde On Codi To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "LISTA"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Lista
Inde On Codigo + Descricao + Codi + CodGrupo + CodSgrupo To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "REGIAO"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Regiao
Inde On Regiao + Nome To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "CURSOS"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Cursos
Inde On Curso + Obs To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "FORMA"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Forma
Inde On Forma + Condicoes To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "RECEBER"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Receber
Inde On Codi To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "PAGAR"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Pagar
Inde On Codi To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "USUARIO"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Usuario
Inde On Nome To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "GRUPO"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Grupo
Inde On CodGrupo + DesGrupo To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "SUBGRUPO"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele SubGrupo
Inde On CodsGrupo + DesSgrupo To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "VENDEDOR"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Vendedor
Inde On CodiVen + Nome To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "CHEMOV"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Chemov
Inde On Codi + DateToStr( Data ) + DateToStr( Emis ) + Hist + Docnr + Fatura + Caixa + Str( Cre, 13,2) + Str(Deb, 13,2) + Tipo To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "RECEBIDO"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Recebido
Inde On Codi + Str(Vlr,13,2) + DateToStr(Emis) + DateToStr(Vcto) + Docnr + Fatura + DateToStr( DataPag ) + Str(VlrPag, 13,2 ) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "ENTRADAS"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Entradas
Inde On Codi + DateToStr( Data ) + Codigo + Fatura + Str(VlrFatura,13,2) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
cFile := "CHEPRE"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Chepre
Inde On Codi + Docnr + DateToStr( Data ) + DateToStr( Vcto ) + Hist + DebCre + Str( Valor, 13 ,2 ) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
/*************************************************************************************************/
FechaTudo()
ResTela( cTela )
Return

Proc RenDup( cFile, xDbf, xNtx )
********************************
DbCloseArea()
IF !MsRename( cFile + ".DBF", cFile + ".LIX")
	Ferase( cFile + ".LIX")
	MsRename( cFile + ".DBF", cFile + ".LIX")
EndIF
IF !MsRename( xDbf, cFile + ".DBF")
	oMenu:Limpa()
	ErrorBeep()
	Alerta("Erro # " + AllTrim( Str( Ferror())) + " : Erro ao renomear arquivo " + cFile + ".DBF.")
	FechaTudo()
	Return
EndIF
Ferase( xNtx )

Proc DupSaidas()
****************
LOCAL cFile
LOCAL xDbf
LOCAL xNtx
LOCAL nx

Mensagem("Informa: Aguarde, Excluindo Arquivos Temporarios.")
oMenu:Limpa()
ExcluirTemporarios()
/*************************************************************************************************/
IF !UsaArquivo("SAIDAS") ; Break ; EndiF
cFile := "SAIDAS"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Saidas
Inde On Codigo + Docnr + CodiVen + Codi + Fatura + Pedido + DateToStr( Data ) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
ResTela( cTela )
Return

Proc DupRecemov()
****************
LOCAL cFile
LOCAL xDbf
LOCAL xNtx
LOCAL nx

Mensagem("Informa: Aguarde, Excluindo Arquivos Temporarios.")
oMenu:Limpa()
ExcluirTemporarios()
/*************************************************************************************************/
IF !UsaArquivo("RECEMOV") ; Break ; EndiF
cFile := "RECEMOV"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Recemov
Inde On Docnr + Fatura + Codi + CodiVen + Caixa + Str( Vlr, 13,2 ) + DateToStr( Vcto) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
ResTela( cTela )
Return

Proc DupRecebido()
******************
LOCAL cFile
LOCAL xDbf
LOCAL xNtx
LOCAL nx

Mensagem("Informa: Aguarde, Excluindo Arquivos Temporarios.")
oMenu:Limpa()
ExcluirTemporarios()
/*************************************************************************************************/
IF !UsaArquivo("RECEBIDO") ; Break ; EndiF
cFile := "RECEBIDO"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Recebido
Inde On Codi + DateToStr( DataPag ) + DateToStr( Emis ) + Docnr + Fatura + Str( VlrPag, 13, 2 ) + Tipo  To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
ResTela( cTela )
Return

Proc DupChemov()
****************
LOCAL cFile
LOCAL xDbf
LOCAL xNtx
LOCAL nx

Mensagem("Informa: Aguarde, Excluindo Arquivos Temporarios.")
oMenu:Limpa()
ExcluirTemporarios()
/*************************************************************************************************/
IF !UsaArquivo("CHEMOV") ; Break ; EndiF
cFile := "CHEMOV"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Chemov
Inde On Codi + DateToStr( Data ) + DateToStr( Emis ) + Hist + Docnr + Fatura + Caixa + Str( Cre, 13,2) + Str(Deb, 13,2) + Tipo To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
ResTela( cTela )
Return

Proc DupLista()
***************
LOCAL cFile
LOCAL xDbf
LOCAL xNtx
LOCAL nx

Mensagem("Informa: Aguarde, Excluindo Arquivos Temporarios.")
oMenu:Limpa()
ExcluirTemporarios()
/*************************************************************************************************/
IF !UsaArquivo("LISTA") ; Break ; EndiF
cFile := "LISTA"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Lista
Inde On Codigo + Descricao + Codi + CodGrupo + CodSgrupo To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
ResTela( cTela )
Return

Proc DupReceber()
*****************
LOCAL cFile
LOCAL xDbf
LOCAL xNtx
LOCAL nx

Mensagem("Informa: Aguarde, Excluindo Arquivos Temporarios.")
oMenu:Limpa()
ExcluirTemporarios()
/*************************************************************************************************/
IF !UsaArquivo("RECEBER") ; Break ; EndiF
cFile := "RECEBER"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Receber
Inde On Codi To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
ResTela( cTela )
Return

Proc DupEntradas()
*****************
LOCAL cFile
LOCAL xDbf
LOCAL xNtx
LOCAL nx

Mensagem("Informa: Aguarde, Excluindo Arquivos Temporarios.")
oMenu:Limpa()
ExcluirTemporarios()
/*************************************************************************************************/
IF !UsaArquivo("ENTRADAS") ; Break ; EndiF
cFile := "ENTRADAS"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Entradas
Inde On Codi + DateToStr( Data ) + Codigo + Fatura + Str(VlrFatura,13,2) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
ResTela( cTela )
Return

Proc DupPagamov()
*****************
LOCAL cFile
LOCAL xDbf
LOCAL xNtx
LOCAL nx

Mensagem("Informa: Aguarde, Excluindo Arquivos Temporarios.")
oMenu:Limpa()
ExcluirTemporarios()
/*************************************************************************************************/
IF !UsaArquivo("PAGAMOV") ; Break ; EndiF
cFile := "PAGAMOV"
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem("Verificando: " + cFile )
xDbf := ""

Sele Pagamov
Inde On Docnr + Fatura + Codi + Str( Vlr, 13,2 ) + DateToStr( Vcto) + DateToStr( Emis ) To ( xNtx ) Unique
nX := 0
WHILE File(( xDbf := cFile + "." + StrZero( ++nX, 3 )))
EndDo
Copy To ( xDbf )
RenDup( cFile, xDbf, xNtx )
ResTela( cTela )
Return

Function Acesso( lNaoMostrarConfig )
********************************
IfNil( lNaoMostrarConfig, FALSO )
#IFDEF ANO2000
	oAmbiente:Ano2000On()
#ELSE
	oAmbiente:Ano2000Off()
#ENDIF
oAmbiente:lComCodigoAcesso := FALSO
#IFDEF MICROBRAS
	Configuracao( OK, lNaoMostrarConfig )
	Return nil
#ENDIF
#IFDEF AGROMATEC
	Configuracao( OK, lNaoMostrarConfig )
	Return nil
#ENDIF
oAmbiente:lComCodigoAcesso := OK
Configuracao(NIL, lNaoMostrarConfig )
Return nil

Function CriaNewNota( lSimNao )
*******************************
LOCAL GetList := {}
LOCAL cScreen := SaveScreen()
LOCAL cFatura := ""
LOCAL xNtx
LOCAL cTela

IF lSimNao = NIL
	ErrorBeep()
	IF !Conf("Pergunta: Verificacao podera demorar. Continuar ?")
		return(ResTela( cScreen))
	EndIF
EndIF
xNtx	:= FTempName("T*.TMP")
cTela := Mensagem(" Aguarde... Verificando Arquivos.", WARNING, _LIN_MSG )
FechaTudo()
IF !NetUse("Saidas",  MONO )   ; ResTela( cTela ); Return(FALSO) ; EndIF
IF !NetUse("Nota",    MONO )   ; ResTela( cTela ); Return(FALSO) ; EndIF
IF !NetUse("Recemov", MONO )   ; ResTela( cTela ); Return(FALSO) ; EndIF
ResTela( cTela )
cTela := Mensagem("Verificando: SAIDAS.DBF")
Area("Recemov")
Area("Saidas")
Area("Nota")
Nota->(__DbZap())
Inde On Nota->Numero To ( xNtx )
Saidas->(Order( SAIDAS_FATURA ))
Saidas->(DbGoTop())
WHILE Saidas->(!Eof()) .AND. lCancelou() .AND. oMenu:ContaReg()    
	cFatura := Saidas->Fatura
	IF Nota->(!DbSeek( cFatura ))
		Nota->(DbAppend())
		Nota->Codi		  := Saidas->Codi
		Nota->Numero	  := Saidas->Fatura
		Nota->Atualizado := Date()
		Nota->Data		  := Saidas->Data
		Nota->Situacao   := Saidas->Situacao
      Nota->Caixa      := Saidas->Caixa
	EndIF
	Saidas->(DbSkip(1))
EndDo

cTela := Mensagem("Verificando: RECEMOV.DBF")
Recemov->(Order(RECEMOV_FATURA))
Recemov->(DbGotop())
while Recemov->(!Eof()) .AND. lCancelou() .AND. oMenu:ContaReg() 
	cFatura := Recemov->Fatura
	IF Nota->(!DbSeek( cFatura ))
		Nota->(DbAppend())
		Nota->Codi		  := Recemov->Codi
		Nota->Numero	  := Recemov->Fatura
		Nota->Atualizado := Date()
		Nota->Data		  := Recemov->Emis
		Nota->Situacao   := 'RECEBER'
      Nota->Caixa      := Recemov->Caixa
	EndIF
	Recemov->(DbSkip(1))
enddo
Nota->(Order( NATURAL ))
Sort On Numero To NewNota
Nota->(__DbZap())
Nota->(__DbPack())
Appe From NewNota
FechaTudo()
Ferase('NOTA.' + CEXT)
VerIndice()
oReindexa:WriteBool('reindexando', 'NOTA.DBF', OK )
FechaTudo()
ResTela( cTela )
Return

Proc CriaNewEnt()
*****************
LOCAL cFatura := ""
LOCAL xNtx	  := FTempName("T*.TMP")
LOCAL cTela   := Mensagem(" Aguarde... Verificando Arquivos.", WARNING, _LIN_MSG )
FechaTudo()
IF !NetUse("Entradas", MONO )   ; ResTela( cTela ); Return(FALSO) ; EndIF
IF !NetUse("ENTNOTA",  MONO )   ; ResTela( cTela ); Return(FALSO) ; EndIF
ResTela( cTela )

cTela := Mensagem("Verificando: ENTRADAS.DBF")
Area("Entradas")
Area("ENTNOTA")
ENTNOTA->(__DbZap())
Inde On ENTNOTA->Numero To ( xNtx )
Entradas->(DbGoTop())
WHILE Entradas->(!Eof())
	cFatura := Entradas->Fatura
	IF ENTNOTA->(!DbSeek( cFatura ))
		ENTNOTA->(DbAppend())
		ENTNOTA->Codi		  := Entradas->Codi
		ENTNOTA->Numero	  := Entradas->Fatura
		ENTNOTA->VlrFatura  := Entradas->VlrFatura
		ENTNOTA->VlrNff	  := Entradas->VlrNFF
		ENTNOTA->Icms		  := Entradas->Icms
		ENTNOTA->Entrada	  := Entradas->DEntrada
		ENTNOTA->Data		  := Entradas->Data
		ENTNOTA->Condicoes  := Entradas->Condicoes
		ENTNOTA->Atualizado := Date()
	EndIF
	Entradas->(DbSkip(1))
EndDo
FechaTudo()
ResTela( cTela )
Return

Function lCancelou()
********************
	if LastKey() = ESC
	   if alerta("INFO: Tarefa n„o concluida. Banco de Dados poder  ficar inconsitente.;; Deseja cancelar mesmo assim?", {" Sim ", " Nao "}) == 1
			FechaTudo()
			return FALSO			
		endif
	endif
	return OK


Proc CriaNewPrinter()
*********************
LOCAL cTela   := Mensagem("Aguarde, Verificando Arquivos.", WARNING, _LIN_MSG )
FechaTudo()
IF !NetUse("PRINTER", MONO ) ; ResTela( cTela ); Return(FALSO) ; EndIF
ResTela( cTela )

cTela := Mensagem("Verificando: PRINTER.DBF")
Area("Printer")
Printer->(__DbZap())
ArrPrinter()
FechaTudo()
ResTela( cTela )
Return

Proc DetalheRecibo( cCaixa, cTipoDetalhe )
******************************************
LOCAL GetList         := {}
LOCAL cScreen			 := SaveScreen()
LOCAL Arq_Ant			 := Alias()
LOCAL Ind_Ant			 := IndexOrd()
LOCAL aMenu 	       := {"Normal", "Somente Creditos", "Somente Debitos" }
LOCAL nRolCaixa		 := oIni:ReadInteger('relatorios','rolcaixa', 1 )
LOCAL nTipoCaixa		 := oIni:ReadInteger('relatorios','tipocaixa', 2 )
LOCAL nPartida 		 := oIni:ReadInteger('relatorios','rolcontrapartida', 2 )
LOCAL lVisualizarDetalheCaixa := oSci:ReadBool('permissao','visualizardetalhecaixa', OK )
LOCAL Pagina			 := 0
LOCAL nTamArray		 := 0
LOCAL Tam				 := 132
LOCAL dIni				 := Date()
LOCAL dFim				 := Date()
LOCAL nDif				 := 0
LOCAL lDetalhe        := OK
LOCAL nOpcao          := NIL
LOCAL nSoma           := 0
LOCAL nSomaRec        := 0 
LOCAL nPagDia         := 0
LOCAL nPagDiv         := 0   
LOCAL nQtDocumento    := 0
LOCAL nQtRec          := 0 
LOCAL nQtPagDiv       := 0
LOCAL nQtPagDia       := 0
LOCAL cTitular
LOCAL oRelato
FIELD Caixa
FIELD Tipo
FIELD Cre
FIELD Deb
FIELD Data
FIELD Hist
FIELD Docnr
FIELD Codi
FIELD Vlr
FIELD Vcto

oMenu:Limpa()
IF nOpcao = NIL
	IF cCaixa = Nil
		cCaixa := Space(4)
		IF !VerSenha( @cCaixa )
			AreaAnt( Arq_Ant, Ind_Ant )
			ResTela( cScreen )
			Return
		EndIF
	EndIF
EndIF
IF !lVisualizarDetalheCaixa
	IF !PedePermissao( SCI_VISUALIZAR_DETALHE_CAIXA )
		Restela( cScreen )
		Return
	EndIF
EndIF

WHILE OK
	oMenu:Limpa()
	M_Title("ESCOLHA UMA OPCAO")
	nChoice := FazMenu( 03, 10, aMenu )
	
	if nChoice = 0
		Return NIL
	endif

   MaBox( 10, 10, 13, 37 )
   @ 11, 11 Say "Data Inicial : " Get dIni Pict PIC_DATA
   @ 12, 11 Say "Data Final   : " Get dFim Pict PIC_DATA Valid dFim >= dIni
   Read
   IF LasTkey() = ESC
      Loop
   EndIF
   IF nOpcao = NIL
      Vendedor->(Order( VENDEDOR_CODIVEN ))
      Vendedor->(DbSeek( cCaixa ))
      cTitular := Vendedor->Nome
   EndIF
   cIni    := Dtoc( dIni )
   cFim    := Dtoc( dFim )
   IF cTipoDetalhe = 1
      cTitulo := "RELATORIO EMISSAO DE RECIBO EM CARTEIRA REF &cIni. A &cFim. EMITIDO POR: " + cCaixa + " - " + Trim( cTitular )
   ElseIF cTipoDetalhe = 2
      cTitulo := "RELATORIO EMISSAO DE RECIBO EM BANCO REF &cIni. A &cFim. EMITIDO POR: " + cCaixa + " - " + Trim( cTitular )
   ElseIF cTipoDetalhe = 3
      cTitulo := "RELATORIO EMISSAO DE RECIBO DE OUTROS REF &cIni. A &cFim. EMITIDO POR: " + cCaixa + " - " + Trim( cTitular )
   EndIF
   Mensagem("Aguarde... Verificando Movimento.")
   Area("Recibo")
   Recibo->(Order( RECIBO_DATA ))
   Sx_ClrScope( S_TOP )
   Sx_ClrScope( S_BOTTOM )
   Recibo->(DbGoTop())
   Sx_SetScope( S_TOP, dIni)
   Sx_SetScope( S_BOTTOM, dFim )
   Recibo->(DbGoTop())	
   IF !Instru80()
      Sx_ClrScope( S_TOP )
      Sx_ClrScope( S_BOTTOM )
      AreaAnt( Arq_Ant, Ind_Ant )
      ResTela( cScreen )
      Return
   EndIF
   nSoma        := 0
	nSomaRec     := 0
	nPagDia      := 0
	nPagDiv      := 0
	nQtRec       := 0
   nQtDocumento := 0
	nQtPagDiv    := 0
	nQtPagDia    := 0
	
	oMenu:Limpa()
   Mensagem("Aguarde, Imprimindo Relatorio de Recibos.")
	oRelato				:= TRelatoNew()	
	oRelato:Tamanho	:= 132
	oRelato:NomeFirma := AllTrim(oAmbiente:xFanta)
	oRelato:Sistema	:= SISTEM_NA3
	oRelato:Titulo 	:= cTitulo
	oRelato:PrintOn(Chr(ESC) + "C" + Chr(33) + PQ )
	oRelato:Cabecalho := "TIPO    CODI NOME CLIENTE                     DOCTO N§     VCTO    PAGTO     HORA  RECEBIDO CAIXA HISTORICO"
	oRelato:Inicio()         
	WHILE Recibo->(!Eof()) .AND. Rel_Ok()      
		IF oRelato:RowPrn = 0
			oRelato:Cabec()         
      EndIF
		
      IF Recibo->Tipo == "BAIXAS"
         Recibo->(DbSkip(1))
         Loop
      EndIF

      IF cTipoDetalhe == 1
         IF Recibo->Tipo == "RECBCO" .OR. Recibo->Tipo == "RECOUT"
            Recibo->(DbSkip(1))
            Loop
         EndIF
      EndIF

      IF cTipoDetalhe == 2
         IF Recibo->Tipo != "RECBCO"
            Recibo->(DbSkip(1))
            Loop
         EndIF
      EndIF

      IF cTipoDetalhe == 3
         IF Recibo->Tipo != "RECOUT"
            Recibo->(DbSkip(1))
            Loop
         EndIF
      EndIF
		
		nVlr := Recibo->Vlr
		
		if nChoice = 2 // Somente Creditos
		   if nVlr < 0
				Recibo->(DbSkip(1))
				Loop
			endif
		endif	
		if nChoice = 3 // Somente Debitos
		   if nVlr >= 0
				Recibo->(DbSkip(1))
				Loop
			endif
		endif	

      nQtDocumento++
      nSoma += nVlr
		
		if     Recibo->Tipo = "PAGDIA"
		   nQtPagDia++
		   nPagDia += nVlr
		elseif Recibo->Tipo = "PAGDIV"
		   nQtPagDiv++
		   nPagDiv += nVlr
		else
		   nQtRec++
		   nSomaRec += nVlr
		endif			
		Recibo->( Qout( Tipo, Codi, Left(Nome,31), Docnr, Vcto, Data, Hora, Tran( nVlr, "@E 99,999.99"), Left(Usuario,5), Left(Hist,34)))
		Recibo->(DbSkip(1))
      IF ++oRelato:RowPrn >= 25
		   oRelato:Eject()
		endif	
   EndDo
   Qout()
   Qout("TOTAL RECEBIMENTOS......:", StrZero( nQtRec,       4) + Space(48) + NG + Tran( nSomaRec, "@E 9,999,999.99") + NR)
	Qout("TOTAL DIARIAS PAGAS.....:", StrZero( nQtPagDia,    4) + Space(48) + NG + Tran( nPagDia,  "@E 9,999,999.99") + NR)
	Qout("TOTAL DESPESAS DIVERSAS.:", StrZero( nQtPagDiv,    4) + Space(48) + NG + Tran( nPagDiv,  "@E 9,999,999.99") + NR)
	Qout("TOTAL REGISTROS.........:", StrZero( nQtDocumento, 4) + Space(48) + NG + Tran( nSoma,    "@E 9,999,999.99") + NR)
   Qout()
   Qout()
   Qout(Repl("_",40))
   Qqout(Space(06) + Repl("_",40))
   Qqout(Space(06) + Repl("_",40))
   Qout(Space(16) + "CAIXA")
   Qqout(Space(42) + "CONFERENTE")
   Qqout(Space(34) + "TESOUREIRO")
	oRelato:Eject()
   ORelato:PrintOff(Chr(ESC) + "C" + Chr(66))
   Sx_ClrScope( S_TOP )
   Sx_ClrScope( S_BOTTOM )
EndDO
AreaAnt( Arq_Ant, Ind_Ant )
ResTela( cScreen )
Return


Proc Retorno()
**************
LOCAL cCodigo
LOCAL Data_Limite
LOCAL cExecucoes
LOCAL nNumero
LOCAL nTemp
LOCAL cSenha
LOCAL nCrc
LOCAL cEmpresa
LOCAL lTemDebito := FALSO
LOCAL cCodi      := Space(05)
LOCAL nVersao    := 2  //1=Velha 2=Nova
LOCAL cDia       := "01"
LOCAL cMesRet    := StrZero( Month( Date())+1,2)
LOCAL cAno       := StrZero( Year( Date()), 4 )
LOCAL aDias      := {'28','29','30','31'}

WHILE OK
   oMenu:Limpa()
   SetKey( F5, NIL )
   MaBox( 10, 01, 14, MaxCol()-1 )
   lTemDebito  := FALSO
   cCodi       := Space(05)
   cDia        := "01"
   cMesRet     := StrZero( Month( Date())+1,2)
   cAno        := StrZero( Year( Date()), 4 )
   cEmpresa    := Space(40)
   cCodigo     := Space(10)
   cDia        := StrZero(Day(Date()),2)
   cMesRet     := Month( Date())+1
   cAno        := Year( Date())
   IF Ascan( aDias, cDia ) > 0
      cMesRet ++
      IF cMesRet > 12
         cMesRet = 1
         cAno  ++
      EndIF
   EndIF
   cDia        := '01'
   cMesRet     := StrZero( cMesRet, 2 )
   cAno        := StrZero( cAno, 4)
   cData       := cDia + "/" + cMesRet +  "/" + cAno
	Data_Limite := Ctod( cData )
	cExecucoes	:= Right( StrTran( Time(), ":"),2)
	cExecucoes	+= Right( StrTran( Time(), ":"),2)
	@ 11, 02 Say "Cliente..................:" Get cCodi Pict PIC_RECEBER_CODI Valid ;
															RecErrado( @cCodi,, Row(), Col()+1 ) .AND. ;
															ClienteSci( cCodi ) .AND. ;
															PosicaoDebito( cCodi, @lTemDebito, @Data_Limite ) .AND. ;
															UltRetorno( cCodi )
	@ 12, 02 Say "Codigo Interno Fornecido.:" Get cCodigo  Pict "@R 999.999.9999" Valid VerRetorno( cCodigo )
	@ 13, 02 Say "Data Limite de Execucoes.:" Get Data_Limite Pict PIC_DATA Valid RetLimite( @Data_Limite, lTemDebito  )
	Read
	IF LastKey() = ESC
		SetKey( F5, {|| PrecosConsulta()})
		Return
	EndIF

	// Monte a Senha Para calculo

	cData_Limite := StrTran( Dtoc( Data_Limite ), "/" )
	cSenha		 := cData_Limite + cExecucoes

	// Calcula o Crc

	nCrc := 0
	nX   := 0
	/*
	For Contador := 1 To 10
		nCrc += Val( SubStr( cCodigo, Contador, 1 )) * ;
				  Val( SubStr( cSenha, Contador, 1 )) + ;
				  Val( SubStr( cSenha, Contador, 1 ))
	Next
	*/
	For nX := 1 To 10
		nCrc += Val( SubStr( cSenha,	nX, 1 )) * ;
				  Val( SubStr( cSenha,	nX, 1 )) + ;
				  Val( SubStr( cCodigo, nX, 1 ))
	Next
	cCrc := Right( StrZero( nCrc, 10),3)
	cSenha += cCrc
	Alert( "Codigo de Retorno " + Transform( cSenha, "@R 999.999.999.999.9"))
	Retorno->(DbGoBottom())
	nId := Retorno->Id
	nId++
	Receber->(Order( RECEBER_CODI ))
	Receber->(DbSeek( cCodi ))
	IF Retorno->(Incluiu())
		Retorno->Id 	  := nId
		Retorno->Codi	  := cCodi
		Retorno->Empresa := Receber->Nome
		Retorno->Interno := cCodigo
		Retorno->Codigo  := cSenha
		Retorno->Limite  := Data_Limite
		Retorno->Data	  := Date()
		Retorno->Versao  := nVersao
		Retorno->Hora	  := Time()
		Retorno->Nome	  := oAmbiente:xUsuario
		Retorno->Atualizado := Date()
		Retorno->(Libera())
	EndIF
EndDo

Function RetLimite( Data_Limite, lTemDebito )
*********************************************
IF LastKey() = UP
	Return( OK )
ElseIF lTemDebito
	Data_Limite := Date() + 1
	Return( OK )
ElseIF Data_Limite < Date()
	ErrorBeep()
	Alerta("Erro: Data Limite nao pode ser antes de Hoje.")
	Return( FALSO )
EndIF
Return( OK )

Function UltRetorno( xCliente )
*******************************
LOCAL cScreen			:= SaveScreen()
LOCAL Arq_Ant			:= Alias()
LOCAL Ind_Ant			:= IndexOrd()
LOCAL nSoma 			:= 0
LOCAL nChoice			:= 0
LOCAL lAtraso			:= FALSO

Retorno->(Order( RETORNO_CODI ))
IF Retorno->(DbSeek( xCliente ))
	While Retorno->Codi = xCliente
		IF Retorno->Limite > Date()
			ErrorBeep()
			MaBox( 00, 00, 09, MaxCol())
			Write( 01, 01, "Ja foi fornecido Codigo para " + Dtoc( Retorno->Limite ) + ". Verifique com o cliente as opcoes.")
			Write( 03, 01, "1 - O SCI esta sendo instalado pela 1¦ vez ?")
			Write( 04, 01, "2 - Esta atualizando a versao do SCI ?")
			Write( 05, 01, "3 - Esta instalando um novo terminal ?")
			Write( 06, 01, "4 - A data do Sistema Operacional esta correta ?")
			Write( 07, 01, "5 - O arquivo SCI.EXE esta com data diferente do DOS ?")
			Write( 08, 01, "6 - Antecipacao de Codigo de Acceso.")
			Return( OK )
		EndIF
		Retorno->(DbSkip(1))
	EndDo
EndIF
Return( OK )

Function ClienteSci( xCliente )
*******************************
LOCAL cScreen			:= SaveScreen()
LOCAL Arq_Ant			:= Alias()
LOCAL Ind_Ant			:= IndexOrd()
LOCAL lRetVal			:= FALSO

Receber->(Order( RECEBER_CODI ))
IF Receber->(DbSeek( xCliente ))
	IF Receber->Sci = OK
		lRetVal := OK
	Else
		ErrorBeep()
		Alerta('Erro: Nao nao tem Sistema Registrado.')
	EndIF
EndIF
Return( lRetVal )

Function PosicaoDebito( xCliente, lTemDebito, Data_Limite )
***********************************************************
LOCAL cScreen			:= SaveScreen()
LOCAL Arq_Ant			:= Alias()
LOCAL Ind_Ant			:= IndexOrd()
LOCAL nSoma 			:= 0
LOCAL nChoice			:= 0
LOCAL lAtraso			:= FALSO
LOCAL aMenu 			:= {"Cancelar", "Continuar", "Consultar"}

Recemov->(Order( RECEMOV_CODI ))
IF Recemov->(DbSeek( xCliente ))
	While Recemov->Codi = xCliente
		IF Recemov->Vcto < Date()
			lAtraso := OK
			Exit
		EndIF
		Recemov->(DbSkip(1))
	EndDo
EndIF
IF lAtraso
	Data_Limite := Date() + 1
	lTemDebito	:= OK
	MaBox( 00, 00, 04, MaxCol())
	Write( 01, 01, "1-Informe ao cliente que ele se encontra em atraso")
	Write( 02, 01, "  e que o sistema so permite liberar codigo de acesso")
	Write( 03, 01, "  somente para 1 dia, ate regularizacao do debito.")
	ErrorBeep()
	WHILE OK
		M_Title("INFORMA: CLIENTE EM ATRASO. ESCOLHA UMA OPCAO")
		nChoice := FazMenu( 15, 10, aMenu)
		Do Case
		Case nChoice = 0 .OR. nChoice = 1
		  ResTela( cScreen )
		  Return( FALSO )
		Case nChoice = 2
			ResTela( cScreen )
			Return( OK )
		Case nChoice = 3
			PosiReceber( 1, xCliente )
		EndCase
	EndDo
EndIF
Return( OK )

Function VerRetorno( cCodigo )
******************************
LOCAL nLen := Len( AllTrim( StrTran( cCodigo, ".")))

IF LastKey() = UP
	Return( OK )
ElseIF Empty( cCodigo )
	ErrorBeep()
	Alerta("Erro: Campo nao Pode ser Vazio")
	Return( FALSO )
ElseIF nLen < 10
	ErrorBeep()
	Alerta("Erro: Codigo Interno Invalido.")
	Return( FALSO )
EndIF
Return( OK )

Function Velho()
****************
LOCAL cCodigo
LOCAL Data_Limite
LOCAL cExecucoes
LOCAL nNumero
LOCAL nTemp
LOCAL cSenha
LOCAL nCrc
LOCAL cEmpresa
LOCAL nVersao := 2 //1=Velha 2=Nova

Area("Retorno")
SetColor("W+/R")
@ 10, 01 Clear To 14, MaxCol()-1
DispBox( 10, 01, 14, MaxCol() -1 )
WHILE OK
	cEmpresa  := Space(40)
	Ntemp 	 := Val(Strtran(Time(), ":"))
	//Seed(Ntemp)
	Ccodigo	 := ""
	For Nx := 1 To 5
		Nnumero := Random()
		Nnumero := Alltrim(Str(Nnumero))
		Ccodigo := Ccodigo + Left(Nnumero, 2)
	Next
	cCodigo		:= Space(10)
	cData 		:= "30/" + StrZero( Month( Date()),2 ) +  "/" + StrZero( Year( Date()), 4 )
	cData 		:= "30/09/98"
	Data_Limite := Ctod( cData )
	cExecucoes	:= Right( StrTran( Time(), ":"),2)
	cExecucoes	+= Right( StrTran( Time(), ":"),2)
	@ 11, 02 Say "Empresa........................:" Get cEmpresa    Pict "@!"
	@ 12, 02 Say "Codigo Interno Fornecido.......:" Get cCodigo     Pict "@R 999.999.9999"
	@ 13, 02 Say "Data Limite de Execucoes.......:" Get Data_Limite Pict PIC_DATA
	Read
	IF LastKey() = ESC
		Return
	EndIF

	// Monte a Senha Para calculo

	cData_Limite := StrTran( Dtoc( Data_Limite ), "/" )
	cSenha		 := cData_Limite + cExecucoes

	// Calcula o Crc

	nCrc := 0
	For Contador := 1 To 10
		nCrc += Val( SubStr( cCodigo, Contador, 1 )) * ;
				  Val( SubStr( cSenha, Contador, 1 )) + ;
				  Val( SubStr( cSenha, Contador, 1 ))
	Next
	cCrc	 := Right( StrZero( nCrc, 10),3)
	cSenha += cCrc
	Alert( "Codigo de Retorno " + Transform( cSenha, "@R 999.999.999.999.9"))
	Retorno->(DbGoBottom())
	nId := Retorno->Id
	nId++
	IF Retorno->(Incluiu())
		Retorno->Id 	  := nId
		Retorno->Codi	  := cCodi
		Retorno->Empresa := cEmpresa
		Retorno->Interno := cCodigo
		Retorno->Codigo  := cSenha
		Retorno->Limite  := Data_Limite
		Retorno->Data	  := Date()
		Retorno->Versao  := nVersao
		Retorno->Hora	  := Time()
		Retorno->Nome	  := oAmbiente:xUsuario
		Retorno->(Libera())
		Return( OK )
	EndIF
EndDo
Return( FALSO )

Function AbreEmpresa()
**********************
SET DEFA TO  ( oAmbiente:xBase )
IF !UsaArquivo("EMPRESA")
	SET DEFA TO ( oAmbiente:xBaseDados )
	Return( FALSO )
EndIF
SET DEFA TO ( oAmbiente:xBaseDados )
Return( OK )

Proc MoviAnual()
****************
LOCAL GetList := {}
LOCAL cScreen := SaveScreen()
LOCAL nAnoIni := 1990
LOCAL nAnoFim := Year( Date()-1)

WHILE OK
	MaBox( 10, 10, 12, 40 )
	@ 11, 11 Say "Ano..........." Get nAnoIni Pict "9999" Valid nAnoIni >= 1
	Read
	IF LastKey() = ESC
		ResTela( cScreen )
		Return
  EndIF
  IF !AbreEmpresa()
	  ResTela( cScreen )
	  Return
  EndIF
  Empresa->(DbGoBottom())
  cCodi := StrZero( Val( Empresa->Codi)+1,4)
  IF Empresa->(!Incluiu())
	  Loop
  EndIF
  Empresa->Codi := cCodi
  Empresa->Nome := "MOVIMENTO DO ANO " + StrZero( nAnoIni,4 )
  Empresa->(Libera())
  CriaEmpresa( cCodi )
  Area("Chemov")
EndDo

Proc CriaEmpresa( cCodi )
*************************
Var1		  := oAmbiente:xBase
Var2		  := Var1 + "\EMP" + cCodi
oAmbiente:xBaseDados := Var2
SET DEFA TO ( Var2 )
MkDir( Var2 )
SET DEFA TO ( oAmbiente:xBaseDados )
Return

*:----------------------------------------------------------------------------
Proc AutoCaixa()
****************
LOCAL GetList	:= {}
LOCAL cScreen	:= SaveScreen()
LOCAL cDeb_Deb := ""
LOCAL cDeb_Cre := ""
LOCAL cCre_Deb := ""
LOCAL cCre_Cre := ""
LOCAL xDbf		:= FTempName("T*.TMP")
LOCAL cCaixa	:= Space(04)
LOCAL cCodiIni := Space(04)
LOCAL cCodiFim := Space(04)

IF !UsaArquivo("CHEQUE") ; Break ; EndIF
IF !UsaArquivo("CHEMOV") ; Break ; EndIF

MaBox( 10, 10, 14, 40 )
@ 11, 11 Say "Conta Caixa...." Get cCaixa   Pict "####" Valid Cheerrado( @cCaixa )
@ 12, 11 Say "Conta Inicial.." Get cCodiIni Pict "####" Valid Cheerrado( @cCodiIni )
@ 13, 11 Say "Conta Final...." Get cCodiFim Pict "####" Valid Cheerrado( @cCodiFim )
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
ErrorBeep()
IF !Conf("Pergunta: Deseja continuar a operacao ?")
	ResTela( cScreen )
	Return
EndIF
Area("CHEMOV")
Copy Stru To ( xDbf )
Use ( xDbf ) Alias xAlias Exclusive New
Chemov->(Order( CHEMOV_CODI ))
Area("Cheque")
Cheque->(Order( CHEQUE_CODI ))
Cheque->(DbSeek( cCodiIni ))
Mensagem("Informa: Processando Movimento")
WHILE Cheque->Codi >= cCodiIni .AND. Cheque->Codi <= cCodiFim .AND. Rel_Ok()
	cCodi := Cheque->Codi
	IF cCodi == cCaixa
		Cheque->(DbSkip(1))
		Loop
	EndIF
	cDeb_Deb := Cheque->Deb_Deb
	cDeb_Cre := Cheque->Deb_Cre
	cCre_Deb := Cheque->Cre_Deb
	cCre_Cre := Cheque->Cre_Cre
	IF Empty( cDeb_Deb )
		IF Empty( cDeb_Cre )
			IF Empty( cCre_Deb )
				IF Empty( cCre_Cre )
					Cheque->(DbSkip(1))
					Loop
				EndIF
			EndIF
		EndIF
	EndIF
	IF Chemov->(DbSeek( cCodi ))
		WHILE Chemov->Codi = cCodi
			nReg := Chemov->(Recno())
			IF Chemov->Deb <> 0
				nVlr := Chemov->Deb
				IF !Empty( cDeb_Cre )
					Deb_Cre( cCaixa, nVlr )
				EndIF
				IF !Empty( cDeb_Deb )
					Deb_Deb( cCaixa, nVlr )
				EndIF
			ElseIF Chemov->Cre <> 0
				nVlr := Chemov->Cre
				IF !Empty( cCre_Cre )
					Cre_Cre( cCaixa, nVlr )
				EndIF
				IF !Empty( cCre_Deb )
					Cre_Deb( cCaixa,	nVlr )
				EndIF
			EndIF
			Chemov->(DbgoTo( nReg ))
			Chemov->(DbSkip(1))
		EndDo
	EndIF
	Cheque->(DbSkip(1))
EndDo

Proc Deb_Cre( cCaixa, nVlr )
****************************
xAlias->(DbAppend())
For nField := 1 To Chemov->(FCount())
	xAlias->(FieldPut( nField, Chemov->(FieldGet( nField ))))
Next
xAlias->Codi := cCaixa
xAlias->Deb  := 0
xAlias->Cre  := nVlr
Chemov->(DbAppend())
For nField := 1 To xAlias->(FCount())
	Chemov->(FieldPut( nField, xAlias->(FieldGet( nField ))))
Next
xAlias->(__DbZap())
Return

Proc Deb_Deb( cCaixa, nVlr )
****************************
xAlias->(DbAppend())
For nField := 1 To Chemov->(FCount())
	xAlias->(FieldPut( nField, Chemov->(FieldGet( nField ))))
Next
xAlias->Codi := cCaixa
xAlias->Cre  := 0
xAlias->Deb  := nVlr
Chemov->(DbAppend())
For nField := 1 To xAlias->(FCount())
	Chemov->(FieldPut( nField, xAlias->(FieldGet( nField ))))
Next
xAlias->(__DbZap())
Return

Proc Cre_Cre( cCaixa, nVlr )
****************************
xAlias->(DbAppend())
For nField := 1 To Chemov->(FCount())
	xAlias->(FieldPut( nField, Chemov->(FieldGet( nField ))))
Next
xAlias->Codi := cCaixa
xAlias->Cre  := nVlr
xAlias->Deb  := 0
Chemov->(DbAppend())
For nField := 1 To xAlias->(FCount())
	Chemov->(FieldPut( nField, xAlias->(FieldGet( nField ))))
Next
xAlias->(__DbZap())
Return

Proc Cre_Deb( cCaixa, nVlr )
****************************
xAlias->(DbAppend())
For nField := 1 To Chemov->(FCount())
	xAlias->(FieldPut( nField, Chemov->(FieldGet( nField ))))
Next
xAlias->Codi := cCaixa
xAlias->Cre  := 0
xAlias->Deb  := nVlr
Chemov->(DbAppend())
For nField := 1 To xAlias->(FCount())
	Chemov->(FieldPut( nField, xAlias->(FieldGet( nField ))))
Next
xAlias->(__DbZap())
Return

Proc ZeraCaixa()
****************
LOCAL GetList	:= {}
LOCAL cScreen	:= SaveScreen()
LOCAL cCaixa	:= Space(04)

IF !UsaArquivo("CHEQUE") ; Break ; EndIF
IF !UsaArquivo("CHEMOV") ; Break ; EndIF
MaBox( 10, 10, 12, 40 )
@ 11, 11 Say "Codigo Conta..." Get cCaixa   Pict "####" Valid Cheerrado( @cCaixa ) .AND. VerZeraTem( @cCaixa )
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
ErrorBeep()
IF !Conf("Pergunta: Deseja continuar a operacao ?")
	ResTela( cScreen )
	Return
EndIF
ErrorBeep()
IF !Conf("Pergunta: Tem Certeza ?")
	ResTela( cScreen )
	Return
EndIF
Area("CHEMOV")
Chemov->(Order( CHEMOV_CODI ))
IF Chemov->(DbSeek( cCaixa ))
	oMenu:Limpa()
	IF Chemov->(TravaArq())
		Mensagem("Aguarde, Zerando conta : " + cCaixa )
		WHILE Chemov->Codi == cCaixa
			Chemov->(DbDelete())
			Chemov->(DbSkip(1))
		EndDo
		Chemov->(Libera())
		Alerta("Informa: Zeramento Completado.")
	EndIF
Else
	oMenu:Limpa()
	Alerta("Informa: Nenhum movimento a zerar.")
EndIF
ResTela( cScreen )
Return

Function VerZeraTem( cCaixa )
*****************************
LOCAL cScreen := SaveScreen()

Chemov->(Order( CHEMOV_CODI ))
IF Chemov->(!DbSeek( cCaixa ))
	cCaixa := Space( 04 )
	oMenu:Limpa()
	ErrorBeep()
	Alerta("Informa: Nenhum movimento a zerar.")
	ResTela( cScreen )
	Return( FALSO )
EndIF
Return( OK )

Proc ProtegerDbf( lProteger, lSemPergunta )
*******************************************
LOCAL cScreen	  := SaveScreen()
LOCAL aBase 	  := {}
LOCAL aBaseDados := {}
LOCAL OldDir	  := FCurdir()
LOCAL nX
LOCAL nLen

oMenu:Limpa()
IF lSemPergunta = NIL
	MaBox( 10, 20, 12, 48 )
	@ 11, 21 Say "Senha...: "
	Passe := Senha( 11, 33, 11 )
	IF Empty( Passe) .OR. Passe != '63771588'
		ErrorBeep()
		Alerta('Erro: Senha invalida. Verifique com o supervisor.')
		Restela( cScreen )
		Return
	EndIF
	ErrorBeep()
	IF !Conf('Pergunta: Tem Certeza ?')
		ResTela( cScreen )
		Return
	EndIF
EndIF
Mensagem('Aguarde, Alterando dados.')
Aadd( aBaseDados, "LISTA.DBF")
Aadd( aBaseDados, "SAIDAS.DBF")
Aadd( aBaseDados, "RECEBER.DBF")
Aadd( aBaseDados, "REPRES.DBF")
Aadd( aBaseDados, "GRUPO.DBF")
Aadd( aBaseDados, "SUBGRUPO.DBF")
Aadd( aBaseDados, "VENDEDOR.DBF")
Aadd( aBaseDados, "VENDEMOV.DBF")
Aadd( aBaseDados, "RECEMOV.DBF")
Aadd( aBaseDados, "NOTA.DBF")
Aadd( aBaseDados, "ENTRADAS.DBF")
Aadd( aBaseDados, "PAGAR.DBF")
Aadd( aBaseDados, "PAGAMOV.DBF")
Aadd( aBaseDados, "TAXAS.DBF")
Aadd( aBaseDados, "PAGO.DBF")
Aadd( aBaseDados, "RECEBIDO.DBF")
Aadd( aBaseDados, "CHEQUE.DBF")
Aadd( aBaseDados, "CHEMOV.DBF")
Aadd( aBaseDados, "CHEPRE.DBF")
Aadd( aBaseDados, "FORMA.DBF")
Aadd( aBaseDados, "CURSOS.DBF")
Aadd( aBaseDados, "CURSADO.DBF")
Aadd( aBaseDados, "REGIAO.DBF")
Aadd( aBaseDados, "CEP.DBF")
Aadd( aBaseDados, "PONTO.DBF")
Aadd( aBaseDados, "SERVIDOR.DBF")
Aadd( aBaseDados, "PRINTER.DBF")
Aadd( aBaseDados, "ENTNOTA.DBF")
Aadd( aBaseDados, "CONTA.DBF")
Aadd( aBaseDados, "SUBCONTA.DBF")
Aadd( aBaseDados, "RETORNO.DBF")
Aadd( aBaseDados, "FUNCIMOV.DBF")
Aadd( aBaseDados, "GRPSER.DBF")
Aadd( aBaseDados, "SERVICO.DBF")
Aadd( aBaseDados, "CORTES.DBF")
Aadd( aBaseDados, "MOVI.DBF")
Aadd( aBaseDados, "RECIBO.DBF")
Aadd( aBaseDados, "AGENDA.DBF")
Aadd( aBaseDados, "CM.DBF")
//Aadd( aBase, "EMPRESA.DBF")
//Aadd( aBase, "SCI.DBF")

FechaTudo()
FChDir( oAmbiente:xBaseDados )
nLen := Len( aBaseDados )
For nX := 1 To nLen
//  oProtege:Protege( aBaseDados[nX])
  IF lProteger
	  oProtege:Encryptar( aBaseDados[nX])
  Else
	  oProtege:Decryptar( aBaseDados[nX])
  EndIF
Next
FChDir( oAmbiente:xBase )
nLen := Len( aBase )
For nX := 1 To nLen
//  oProtege:Protege( aBase[nX])
  IF lProteger
	  oProtege:Encryptar( aBase[nX])
  Else
	  oProtege:Decryptar( aBase[nX])
  EndIF
Next
FChDir( OldDir )
FechaTudo()
ResTela( cScreen )
Return

Function MenuIndice()
*********************
LOCAL cScreen := SaveScreen()
LOCAL aMenu   := {"Cancelar",;
						"Sem grafico progresso (recomendado)",;
						"Com grafico de progresso",;
						"Com compactacao e sem grafico (periodicamente)",;
						"Com compactacao e com grafico (periodicamente)"}

oMenu:Limpa()
M_Title("ESCOLHA O TIPO DE REINDEXACAO")
nChoice := FazMenu( 07, 15, aMenu, Cor())
IF nChoice = 0 .OR. nChoice = 1
	oIndice:ProgressoNtx := FALSO
	ResTela( cScreen )
	Return( FALSO )
ElseIF nChoice = 2
  oIndice:ProgressoNtx := FALSO
ElseIF nChoice = 3
  oIndice:ProgressoNtx := OK
ElseIF nChoice = 4
  oIndice:Compactar := OK
ElseIF nChoice = 5
  oIndice:Compactar := OK
  oIndice:ProgressoNtx := OK
EndIF
ResTela( cScreen )
Return( OK )

Function SalvaMem()
******************
oIni:WriteString(  oAmbiente:xUsuario,	'frame',         oMenu:Frame )
oIni:WriteString(  oAmbiente:xUsuario,	'panofundo',     oMenu:PanoFundo )

oIni:WriteInteger( oAmbiente:xUsuario, 'selecionado',   oMenu:Selecionado )
oIni:WriteInteger( oAmbiente:xUsuario, 'cormenu',       oMenu:CorMenu )
oIni:WriteInteger( oAmbiente:xUsuario, 'CorLightBar',   oMenu:CorLightBar )
oIni:WriteInteger( oAmbiente:xUsuario, 'CorHotKey',     oMenu:CorHotKey )
oIni:WriteInteger( oAmbiente:xUsuario, 'CorHKLightBar', oMenu:CorHKLightBar)
oIni:WriteInteger( oAmbiente:xUsuario, 'corfundo',      oMenu:Corfundo )
oIni:WriteInteger( oAmbiente:xUsuario, 'corcabec',      oMenu:CorCabec )
oIni:WriteInteger( oAmbiente:xUsuario, 'cordesativada', oMenu:CorDesativada )
oIni:WriteInteger( oAmbiente:xUsuario, 'corbox',        oMenu:CorBox )
oIni:WriteInteger( oAmbiente:xUsuario, 'corcima',       oMenu:CorCima )
oIni:WriteInteger( oAmbiente:xUsuario, 'corantiga',     oMenu:CorAntiga )
oIni:WriteInteger( oAmbiente:xUsuario, 'corborda',      oMenu:CorBorda )
oIni:WriteInteger( oAmbiente:xUsuario, 'fonte',         oMenu:Fonte )
oIni:WriteInteger( oAmbiente:xUsuario, 'fonte',         oMenu:Fonte )
oIni:WriteInteger( oAmbiente:xUsuario, 'FonteManualAltura', oMenu:FonteManualAltura )
oIni:WriteInteger( oAmbiente:xUsuario, 'FonteManualLargura', oMenu:FonteManualLargura )
oIni:WriteInteger( oAmbiente:xUsuario, 'coralerta',     oAmbiente:CorAlerta )
oIni:WriteInteger( oAmbiente:xUsuario, 'cormsg',        oAmbiente:CorMsg )
oIni:WriteBool(    oAmbiente:xUsuario, 'sombra',        oMenu:Sombra )
oIni:WriteBool(    oAmbiente:xUsuario, 'get_ativo',     oAmbiente:Get_Ativo )
SetaIni()
return NIL

Function PickTipoVenda( cPick )
********************************
LOCAL aList 	 := { "Normal", "Conta Corrente"}
LOCAL aSituacao := { "N", "S" }
LOCAL cScreen	 := SaveScreen()
LOCAL nChoice

IF Ascan( aSituacao, cPick ) != 0
	Return( OK )
EndIF
MaBox( 11, 01, 14, 44, NIL, NIL, Roloc( Cor()) )
IF (nChoice := AChoice( 12, 02, 13, 43, aList )) != 0
	cPick := aSituacao[ nChoice ]
EndIf
ResTela( cScreen )
Return( OK )

Function lPickSimNao( lPick )
****************************
LOCAL aList 	 := { "Sim", "Nao"}
LOCAL aSituacao := { .T., .F. }
LOCAL cScreen	 := SaveScreen()
LOCAL nPos		 := 0
LOCAL nChoice

nPos := Ascan( aSituacao, lPick )
/*
IF nPos != 0
	Return( OK )
EndIF
*/
MaBox( 11, 01, 14, 44, NIL, NIL, Roloc( Cor()) )
IF (nChoice := AChoice( 12, 02, 13, 43, aList, NIL, NIL, NIL, 2 )) != 0
	lPick := aSituacao[ nChoice ]
EndIf
ResTela( cScreen )
Return( OK )

Function PickSimNao( cPick )
****************************
LOCAL aList 	 := { "Sim", "Nao"}
LOCAL aSituacao := { "S", "N" }
LOCAL cScreen	 := SaveScreen()
LOCAL nChoice

IF Ascan( aSituacao, cPick ) != 0
	Return( OK )
EndIF
MaBox( 11, 01, 14, 44, NIL, NIL, Roloc( Cor()) )
IF (nChoice := AChoice( 12, 02, 13, 43, aList )) != 0
	cPick := aSituacao[ nChoice ]
EndIf
ResTela( cScreen )
Return( OK )

Function ConfBaseDados()
************************
LOCAL cScreen		:= SaveScreen()
LOCAL GetList		:= {}
LOCAL aMenu 		:= {"Saidas", "Entradas", "financeiro", "Nota Fiscal", "ECF Cupom Fiscal","Relatorios", "Arquivos de Impressao", "Prevenda","Geral"}
LOCAL nChoice		:= 0

WHILE OK
	oMenu:Limpa()
	M_Title("Configuracao da Base de Dados")
	nChoice := FazMenu( 05, 10, aMenu )
	Do Case
	Case nChoice = 0
		ResTela( cScreen )
		Return
	Case nChoice = 1
		ConfFaturamento()
	Case nChoice = 2
		ConfEntradas()
	Case nChoice = 3
		ConfReceber()
	Case nChoice = 4
		ConfNota()
	Case nChoice = 5
		ConfEcf()
	Case nChoice = 6
		ConfRelatorios()
	Case nChoice = 7
		ConfImpressao()
	Case nChoice = 8
		ConfPrevenda()
	Case nChoice = 9
		ConfGeral()
	EndCase
EndDo

Proc ConfFaturamento()
**********************
LOCAL cScreen		:= SaveScreen()
LOCAL GetList		:= {}
LOCAL cMens1		:= Space(40)
LOCAL cMens2		:= Space(40)
LOCAL cMens3		:= Space(40)
LOCAL cMens4		:= Space(40)
LOCAL cCodi 		:= Right( oAmbiente:xBaseDados, 4 )
LOCAL xIndiceNtx	:= "EMPRESA1." + CEXT
LOCAL xIndiceNsx	:= "EMPRESA." + CEXT
LOCAL nSegundos	:= 2
LOCAL lFechado 	:= OK
LOCAL cPath 		:= FCurdir()
LOCAL nItens		:= 20
LOCAL cInscMun 	:= Space(15)
LOCAL nIss			:= 0
LOCAL cAutoFatura
LOCAL cAutoDocumento
LOCAL cAltDescricao
LOCAL cTipoVenda
LOCAL cPrecoTicket
LOCAL cPrecoPrevenda
LOCAL cSerieProduto
LOCAL cDuplicidade
LOCAL nOrderTicket
LOCAL cZerarDesconto
LOCAL cRamo
LOCAL cPvRamo
LOCAL cPvCabec
LOCAL cCabecIni
LOCAL cMinimoMens
LOCAL cAutoEmissao
LOCAL cAutoDesconto
LOCAL cAutoLiquido
LOCAL cAutoFecha
LOCAL cEditarQuant
LOCAL cFantaCodebar
LOCAL cEndeFir  := XENDEFIR + ' - ' + XFONE + ' - ' + XCCIDA + '/' + XCESTA

Set Defa To ( oAmbiente:xBase )
IF !NetUse("EMPRESA", MULTI, nSegundos, lFechado )
	Set Defa To ( cPath )
	ResTela( cScreen )
	Return
EndIF
#IFDEF FOXPRO
	DbSetIndex( xIndiceNsx )
#ELSE
	DbSetIndex( xIndiceNtx )
#ENDIF
WHILE OK
	Area("Empresa")
	Empresa->(Order( EMPRESA_CODI ))
	Empresa->(DbSeek( cCodi ))
	oMenu:Limpa()
	cMens1			:= Empresa->Mens1
	cMens2			:= Empresa->Mens2
	cMens3			:= Empresa->Mens3
	cMens4			:= Empresa->Mens4
	nItemNff 		:= Empresa->ItemNff
	cInscMun 		:= Empresa->InscMun
	nIss				:= Empresa->Iss
   cEditarQuant   := IF( oIni:ReadBool('sistema','editarquant', FALSO), "S", "N")
	cAutoFecha		:= IF( oIni:ReadBool('sistema','autofecha', FALSO), "S", "N")
	cAutoLiquido	:= IF( oIni:ReadBool('sistema','autoliquido', FALSO ), "S", "N")
	cAutoDesconto	:= IF( oIni:ReadBool('sistema','autodesconto', FALSO ), "S", "N")
	cAutoEmissao	:= IF( oIni:ReadBool('sistema','autoemissao', FALSO ), "S", "N")
	cAutoFatura 	:= IF( oIni:ReadBool('sistema','autofatura', OK ), "S", "N")
	cAutoDocumento := IF( oIni:ReadBool('sistema','autodocumento', OK ), "S", "N")
	cAltDescricao	:= IF( oIni:ReadBool('sistema','alterardescricao', FALSO ), "S", "N")
	cTipoVenda		:= oIni:ReadString('sistema',  'tipovenda', "N")
	cPrecoTicket	:= IF( oIni:ReadBool('sistema','precoticket', OK ), "S", "N")
	cPrecoPrevenda := IF( oIni:ReadBool('sistema','precoprevenda', OK ), "S", "N")
	cSerieProduto	:= IF( oIni:ReadBool('sistema','serieproduto', FALSO ), "S", "N")
	cDuplicidade	:= IF( oIni:ReadBool('sistema','duplicidade', FALSO ), "S", "N")
	nOrderTicket	:= oIni:ReadInteger('sistema','orderticket', 1 )
	cZerarDesconto := IF( oIni:ReadBool('sistema','zerardesconto', FALSO ), "S", "N")
	cMinimoMens 	:= IF( oIni:ReadBool('sistema','minimomens', FALSO ), "S", "N")
   cPvCabec       := Trim( oIni:ReadString('sistema', 'prilinpv', Left( oAmbiente:xFanta,40)))
   cPvCabec       += Space( 40 - Len( Trim( cPvCabec )))
   cPvRamo        := Trim( oIni:ReadString('sistema', 'seglinpv', Left( cEndefir,40)))
   cPvRamo        += Space( 40 - Len( Trim( cPvRamo )))
   cRamo          := Trim( oIni:ReadString('sistema', 'ramo', Left( cEndefir,40)))
   cRamo          += Space( 40 - Len( Trim( cRamo )))
   cCabecIni      := Trim( oIni:ReadString('sistema', 'cabec', Left( oAmbiente:xFanta,40)))
   cCabecIni      += Space( 40 - Len( Trim( cCabecIni )))
   cFantaCodeBar  := oIni:ReadString('sistema', 'fantacodebar', FANTACODEBAR + Space(10-Len(FANTACODEBAR)))
   oMenu:MaBox( 01, 01, 21, 78, "CONFIGURACAO - SAIDAS")
	@ 02, 	  02 Say "N§ Fatura Automatica.: " Get cAutoFatura    Pict "!"     Valid PickSimNao( @cAutoFatura )
	@ Row(),   41 Say "N§ Docto Automatico..: " Get cAutoDocumento Pict "!"     Valid PickSimNao( @cAutoDocumento )
	@ Row()+1, 02 Say "Data Emis Automatica.: " Get cAutoEmissao   Pict "!"     Valid PickSimNao( @cAutoEmissao )
	@ Row(),   41 Say "Desconto Automatico..: " Get cAutoDesconto  Pict "!"     Valid PickSimNao( @cAutoDesconto )
	@ Row()+1, 02 Say "Liquido Automatico...: " Get cAutoLiquido   Pict "!"     Valid PickSimNao( @cAutoLiquido )
	@ Row(),   41 Say "Fechamento Automatico: " Get cAutoFecha     Pict "!"     Valid PickSimNao( @cAutoFecha )
	@ Row()+1, 02 Say "Alterar Descricao....: " Get cAltDescricao  Pict "!"     Valid PickSimNao( @cAltDescricao  )
	@ Row(),   41 Say "Qtde Items Nff.......: " Get nItemNff       Pict "999"   Valid nItemNff > 0
	@ Row()+1, 02 Say "Tipo Venda Preferen..: " Get cTipoVenda     Pict "!"     Valid PickTipoVenda( @cTipoVenda )
	@ Row(),   41 Say "Preco Ticket Venda...: " Get cPrecoTicket   Pict "!"     Valid PickSimNao( @cPrecoTicket )
	@ Row()+1, 02 Say "N§ Serie Produto.....: " Get cSerieProduto  Pict "!"     Valid PickSimNao( @cSerieProduto )
	@ Row(),   41 Say "Permitir Duplicidade.: " Get cDuplicidade   Pict "!"     Valid PickSimNao( @cDuplicidade )
	@ Row()+1, 02 Say "Percentual ISS.......: " Get nIss           Pict "99.99"
	@ Row(),   41 Say "Inscricao Municipal..: " Get cInscMun       Pict "@!"
	@ Row()+1, 02 Say "Ordem Ticket Venda...: " Get nOrderTicket   Pict "9"     Valid PickTam({"Ordem Cadastro", "Ordem Codigo"}, {1,2}, @nOrderTicket )
	@ Row(),   41 Say "Zerar Desconto.......: " Get cZerarDesconto Pict "!"     Valid PickSimNao( @cZerarDesconto )
	@ Row()+1, 02 Say "Avisar Estoque Min...: " Get cMinimoMens    Pict "!"     Valid PickSimNao( @cMinimoMens )
	@ Row(),   41 Say "Preco Ticket Prevenda: " Get cPrecoPrevenda Pict "!"     Valid PickSimNao( @cPrecoPrevenda )
	@ Row()+1, 02 Say "Editar Quant Saida...: " Get cEditarQuant   Pict "!"     Valid PickSimNao( @cEditarQuant )
	@ Row()+1, 02 Say "Mens 1 Posicao Fat...: " Get cMens1         Pict "@!"
	@ Row()+1, 02 Say "Mens 2 Posicao Fat...: " Get cMens2         Pict "@!"
	@ Row()+1, 02 Say "Mens 3 Posicao Fat...: " Get cMens3         Pict "@!"
	@ Row()+1, 02 Say "Mens 4 Posicao Fat...: " Get cMens4         Pict "@!"
   @ Row()+1, 02 Say "Mens 1§ Lin Ticket...: " Get cCabecIni      Pict "@!"
   @ Row()+1, 02 Say "Mens 2§ Lin Ticket...: " Get cRamo          Pict "@!"
   @ Row()+1, 02 Say "Mens 1§ Lin Ticket PV: " Get cPvCabec       Pict "@!"
   @ Row()+1, 02 Say "Mens 2§ Lin Ticket PV: " Get cPvRamo        Pict "@!"
	@ Row()+1, 02 Say "Fantasia Codigo Barra: " Get cFantaCodeBar  Pict "@!"
	Read
	IF LastKey() = ESC
		Fechatudo()
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		IF Empresa->(TravaReg())
			Empresa->Mens1 	 := cMens1
			Empresa->Mens2 	 := cMens2
			Empresa->Mens3 	 := cMens3
			Empresa->Mens4 	 := cMens4
			Empresa->ItemNff	 := nItemNff
			Empresa->InscMun	 := cInscMun
			Empresa->Iss		 := nIss
			aMensagem			 := { cMens1, cMens2, cMens3, cMens4 }
			aItemNff 			 := { nItemNff }
			aInscMun 			 := { cInscMun }
			aIss					 := { nIss }
			oAmbiente:RelatorioCabec := cCabecIni
			
         oIni:WriteBool( 'sistema',   'editarquant',    IF( cEditarQuant   = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'autofecha',      IF( cAutoFecha     = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'autoliquido',    IF( cAutoLiquido   = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'autodesconto',   IF( cAutoDesconto  = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'autoemissao',    IF( cAutoEmissao   = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'autofatura',     IF( cAutoFatura     = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'autodocumento',  IF( cAutoDocumento  = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'alterardescricao', IF( cAltDescricao = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'precoticket',   IF( cPrecoTicket  = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'precoprevenda', IF( cPrecoprevenda  = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'serieproduto',  IF( cSerieProduto = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'duplicidade',   IF( cDuplicidade  = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'zerardesconto', IF( cZerarDesconto = "S", OK, FALSO ))
			oIni:WriteBool( 'sistema',   'minimomens',    IF( cMinimoMens = "S", OK, FALSO ))
			oIni:WriteInteger( 'sistema','orderticket',    nOrderTicket )
			oIni:WriteString('sistema',  'tipovenda',      cTipoVenda )
         oIni:WriteString('sistema',  'cabec',          cCabecIni )
			oIni:WriteString('sistema',  'relatoriocabec', cCabecIni )
         oIni:WriteString('sistema',  'ramo',           cRamo )
         oIni:WriteString('sistema',  'prilinpv',       cPvCabec )
         oIni:WriteString('sistema',  'seglinpv',       cPvRamo )
			oIni:WriteString('sistema',  'fantacodebar',   cFantaCodebar )
			
			
			Empresa->(Libera())
		EndIF
	EndIF
EndDo
Set Defa To ( cPath )

Proc ConfReceber()
******************
LOCAL cScreen          := SaveScreen()
LOCAL GetList          := {}
LOCAL nCarencia        := 0
LOCAL nDesconto        := 0
LOCAL nDescApos        := 0
LOCAL nDiasApos        := 0
LOCAL nJuroMesSimples  := 0
LOCAL nJuroMesComposto := 0
LOCAL cMens1           := Space(40)
LOCAL cMens2           := Space(40)
LOCAL cMens3           := Space(40)
LOCAL cMens4           := Space(40)
LOCAL cCodi            := Right( oAmbiente:xBaseDados, 4 )
LOCAL xIndiceNtx       := "EMPRESA1." + CEXT
LOCAL xIndiceNsx       := "EMPRESA." + CEXT
LOCAL nSegundos        := 2
LOCAL lFechado         := OK
LOCAL cPath            := FCurdir()
LOCAL aLista           := {"Dinheiro","Nota Promissoria","Duplicata", "Cheque a Vista",;
                           "Requisicao","Bonus","Cheque Predatado","Diferenca Rec/Pag",;
                           "Direta Livre", "Cartao"}
LOCAL aTipo            := {"DH    ", "NP    ","DM    ","CH    ","RQ    ", "BN    ", "CP    ", "DF    ", "DL    ", "CT    " }
LOCAL cAutoTipo
LOCAL nBloqueio
LOCAL cInativo

Set Defa To ( oAmbiente:xBase )
IF !NetUse("EMPRESA", MULTI, nSegundos, lFechado )
	Set Defa To ( cPath )
	ResTela( cScreen )
	Return
EndIF
#IFDEF FOXPRO
	DbSetIndex( xIndiceNsx )
#ELSE
	DbSetIndex( xIndiceNtx )
#ENDIF
WHILE OK
	Area("Empresa")
	Empresa->(Order( EMPRESA_CODI ))
	Empresa->(DbSeek( cCodi ))
	oMenu:Limpa()
   nCarencia        := Empresa->Carencia
   nJuroMesSimples  := Empresa->Juro
   nJuroMesComposto := 0
   nDesconto        := Empresa->Desconto
   nDescApos        := Empresa->DescApos
   nDiasApos        := Empresa->DiasApos
   nMulta           := Empresa->Multa
   nDiaMulta        := Empresa->DiaMulta
   cInativo         := IF( oIni:ReadBool('sistema','MostrarClientesInativos'), "S", "N" )
   cAutoTipo        := oIni:ReadString('sistema','autotipo', 'NP    ')
   nBloqueio        := oIni:ReadInteger('sistema','bloqueio', 0 )
   nJuroMesComposto := oIni:ReadInteger('financeiro', 'JuroMesComposto', 0 )
   nComissao1       := oIni:ReadInteger('comissaoperiodo1','comissao', 2.5 )
   nDiaIni1         := oIni:ReadInteger('comissaoperiodo1','diaini',   0   )
   nDiaFim1         := oIni:ReadInteger('comissaoperiodo1','diafim',   15  )
   nComissao2       := oIni:ReadInteger('comissaoperiodo2','comissao', 4.0 )
   nDiaIni2         := oIni:ReadInteger('comissaoperiodo2','diaini',   16  )
   nDiaFim2         := oIni:ReadInteger('comissaoperiodo2','diafim',   30  )
   nComissao3       := oIni:ReadInteger('comissaoperiodo3','comissao', 4.0 )
   nDiaIni3         := oIni:ReadInteger('comissaoperiodo3','diaini',   31  )
   nDiaFim3         := oIni:ReadInteger('comissaoperiodo3','diafim',   999 )

   oMenu:MaBox( 01, 01, 11, 78, "CONFIGURACAO - FINANCEIRO")
   @ 02,      02 Say "Carencia em dias......:" Get nCarencia        Pict "999"
   @ Row(),   33 Say "Perc Juros Composto.:"   Get nJuroMesComposto Pict "99.99"
   @ Row()+1, 02 Say "Perc Juros ao Mes.....:" Get nJuroMesSimples  Pict "99.99"
   @ Row(),   33 Say "Perc Desc ate Vcto..:"   Get nDesconto        Pict "99.99"
   @ Row()+1, 02 Say "Perc Desc apos Vcto...:" Get nDescApos        Pict "99.99"
   @ Row(),   33 Say "Dias apos Vencido...:"   Get nDiasApos        Pict "999"
   @ Row()+1, 02 Say "Perc Multa............:" Get nMulta           Pict "99.99"
   @ Row(),   33 Say "Dias de Vencido.....:"   Get nDiaMulta        Pict "999"
   @ Row()+1, 02 Say "Tipo Docto Automatico.:" Get cAutoTipo        Pict "@!"  Valid PickTam( aLista, aTipo, @cAutoTipo )
   @ Row(),   33 Say "Bloqueio em Dias....:"   Get nBloqueio        Pict "99"
   @ Row()+1, 02 Say "Comissao Cobrador.....:" Get nComissao1       Pict "99.99"
   @ Row(),   33 Say "Dia(s) de Vencido...:"   Get nDiaIni1         Pict "999"
   @ Row(),   60 Say "Ate dia(s).:"            Get nDiaFim1         Pict "999"
   @ Row()+1, 02 Say "Comissao Cobrador.....:" Get nComissao2       Pict "99.99"
   @ Row(),   33 Say "Dia(s) de Vencido...:"   Get nDiaIni2         Pict "999"
   @ Row(),   60 Say "Ate dia(s).:"            Get nDiaFim2         Pict "999"
   @ Row()+1, 02 Say "Comissao Cobrador.....:" Get nComissao3       Pict "99.99"
   @ Row(),   33 Say "Dia(s) de Vencido...:"   Get nDiaIni3         Pict "999"
   @ Row(),   60 Say "Ate dia(s).:"            Get nDiaFim3         Pict "999"
   @ Row()+1, 02 Say "Ver Clientes Inativos.:" Get cInativo         Pict "@!" Valid PickSimNao(@cInativo)
	Read
	IF LastKey() = ESC
		FechaTudo()
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		IF Empresa->(TravaReg())
			Empresa->Carencia  := nCarencia
			Empresa->Desconto  := nDesconto
			Empresa->DescApos  := nDescApos
			Empresa->DiasApos  := nDiasApos
         Empresa->Juro      := nJuroMesSimples
			Empresa->Multa 	 := nMulta
			Empresa->DiaMulta  := nDiaMulta
			Empresa->(Libera())
         oAmbiente:aSciArray[1,SCI_JUROMESSIMPLES]  := nJuroMesSimples
         oAmbiente:aSciArray[1,SCI_DIASAPOS]        := nDiasApos
         oAmbiente:aSciArray[1,SCI_DESCAPOS]        := nDescApos
         oAmbiente:aSciArray[1,SCI_MULTA]           := nMulta
         oAmbiente:aSciArray[1,SCI_DIAMULTA]        := nDiaMulta
         oAmbiente:aSciArray[1,SCI_CARENCIA]        := nCarencia
         oAmbiente:aSciArray[1,SCI_DESCONTO]        := nDesconto
         oAmbiente:aSciArray[1,SCI_JUROMESCOMPOSTO] := nJuroMesComposto

         oIni:WriteInteger( 'financeiro', 'juromes', nJuroMesSimples )
         oIni:WriteInteger( 'financeiro', 'JuroMesSimples', nJuroMesSimples )
         oIni:WriteInteger( 'financeiro', 'JuroMesComposto', nJuroMesComposto )
         oIni:WriteString( 'sistema', 'autotipo', cAutoTipo )
			oIni:WriteInteger('sistema', 'bloqueio', nBloqueio )
         oIni:WriteBool('sistema', 'MostrarClientesInativos', IF( cInativo = "S", OK, FALSO ))
         oIni:WriteInteger('comissaoperiodo1','comissao', nComissao1 )
			oIni:WriteInteger('comissaoperiodo1','diaini',   nDiaIni1 )
			oIni:WriteInteger('comissaoperiodo1','diafim',   nDiaFim1 )
			oIni:WriteInteger('comissaoperiodo2','comissao', nComissao2 )
			oIni:WriteInteger('comissaoperiodo2','diaini',   nDiaIni2 )
			oIni:WriteInteger('comissaoperiodo2','diafim',   nDiaFim2 )
			oIni:WriteInteger('comissaoperiodo3','comissao', nComissao3 )
			oIni:WriteInteger('comissaoperiodo3','diaini',   nDiaIni3 )
			oIni:WriteInteger('comissaoperiodo3','diafim',   nDiaFim3 )
		EndIF
	EndIF
EndDo
Set Defa To ( cPath )

Proc ConfEntradas()
*******************
LOCAL cScreen		:= SaveScreen()
LOCAL GetList		:= {}
LOCAL cPath 		:= FCurdir()
LOCAL cAutoPreco
LOCAL cMedia
LOCAL cIndexador
LOCAL cIpi
LOCAL cAutoProducao

Set Defa To ( oAmbiente:xBase )
WHILE OK
	oMenu:Limpa()
	cAutoPreco		:= IF( oIni:ReadBool('sistema','autopreco',      OK    ), "S", "N")
	cMedia			:= IF( oIni:ReadBool('sistema','mediaponderada', FALSO ), "S", "N")
	cIndexador		:= IF( oIni:ReadBool('sistema','indexador',      FALSO ), "S", "N")
	cIpi				:= IF( oIni:ReadBool('sistema','ipi',            FALSO ), "S", "N")
	cAutoProducao	:= IF( oIni:ReadBool('sistema','autoproducao',   FALSO ), "S", "N")

	oMenu:MaBox( 01, 01, 05, 78, "CONFIGURACAO - ENTRADAS")
	@ 02, 	  02 Say "Calcular Pvenda.....: " Get cAutoPreco    Pict "!"  Valid PickSimNao( @cAutoPreco )
	@ Row(),   41 Say "Pcusto Ponderado....: " Get cMedia        Pict "!"  Valid PickSimNao( @cMedia )
	@ Row()+1, 02 Say "Usar Indexadores....: " Get cIndexador    Pict "!"  Valid PickSimNao( @cIndexador )
	@ Row(),   41 Say "Entrar com IPI/II...: " Get cIpi          Pict "!"  Valid PickSimNao( @cIpi )
	@ Row()+1, 02 Say "Producao Automatica.: " Get cAutoProducao Pict "!"  Valid PickSimNao( @cAutoProducao )
	Read
	IF LastKey() = ESC
		Set Defa To ( cPath )
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		oIni:WriteBool( 'sistema',   'autopreco',      IF( cAutoPreco    = "S", OK, FALSO ))
		oIni:WriteBool( 'sistema',   'mediaponderada', IF( cMedia        = "S", OK, FALSO ))
		oIni:WriteBool( 'sistema',   'indexador',      IF( cIndexador    = "S", OK, FALSO ))
		oIni:WriteBool( 'sistema',   'ipi',            IF( cIpi          = "S", OK, FALSO ))
		oIni:WriteBool( 'sistema',   'autoproducao',   IF( cAutoProducao = "S", OK, FALSO ))
	EndIF
EndDo

Proc ConfNota()
***************
LOCAL cScreen		  := SaveScreen()
LOCAL GetList		  := {}
LOCAL cPath 		  := FCurdir()
LOCAL cObs1 		  := Space(50)
LOCAL cObs2 		  := Space(50)
LOCAL cObs3 		  := Space(50)
LOCAL cIsento		  := Space(1)
LOCAL cMinimoIndice := Space(1)

Set Defa To ( oAmbiente:xBase )
cObs1 		  := oIni:ReadString('notafiscal','obs1', 'ESTE DOCUMENTO NAO GERA DIREITO A CREDITO FISCAL  ')
cObs2 		  := oIni:ReadString('notafiscal','obs2', 'CONTRIBUINTE ENQUADRADO NO SIMPLES. LEI FEDERAL N§')
cObs3 		  := oIni:ReadString('notafiscal','obs3', '9317/96 E DECRETO ESTADUAL N§ 8570/98.            ')
cIsento		  := IF( oIni:ReadBool('notafiscal','isento', FALSO ), "S", "N")
cMinimoIndice := IF( oIni:ReadBool('notafiscal','minimoindice', FALSO ), "S", "N")
WHILE OK
	oMenu:Limpa()
	oMenu:MaBox( 01, 01, 07, 78, "CONFIGURACAO - NOTA FISCAL")
	@ 02, 	  02 Say "Observacao Linha 1..: " Get cObs1 Pict "@!"
	@ Row()+1, 02 Say "Observacao Linha 2..: " Get cObs2 Pict "@!"
	@ Row()+1, 02 Say "Observacao Linha 3..: " Get cObs3 Pict "@!"
	@ Row()+1, 02 Say "Emitir Nota Isenta..: " Get cIsento Pict "!"  Valid PickSimNao( @cIsento )
	@ Row()+1, 02 Say "Respeitar Indice....: " Get cMinimoIndice Pict "!"  Valid PickSimNao( @cMinimoIndice )
	Read
	IF LastKey() = ESC
		Set Defa To ( cPath )
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		oIni:WriteString('notafiscal', 'obs1', cObs1 )
		oIni:WriteString('notafiscal', 'obs2', cObs2 )
		oIni:WriteString('notafiscal', 'obs3', cObs3 )
		oIni:WriteBool( 'notafiscal',  'isento', IF( cIsento = "S", OK, FALSO ))
		oIni:WriteBool( 'notafiscal',  'minimoindice', IF( cMinimoIndice = "S", OK, FALSO ))
	EndIF
EndDo

Proc ConfGeral()
****************
LOCAL cScreen		:= SaveScreen()
LOCAL GetList		:= {}
LOCAL cPath 		:= FCurdir()
LOCAL cEmail
LOCAL cSmtp
LOCAL nScreenSaver
LOCAL nRecibo
LOCAL nAutenticar
LOCAL nNenhum
LOCAL cCampoDesconto
LOCAL nTipoBusca
LOCAL cNrMarcaTicket
LOCAL cPvMarcaTicket
LOCAL cTrocarVendedor
LOCAL cNomeEmpresa
LOCAL cFantasia
LOCAL cCgcEmpresa
LOCAL cNomeSocio
LOCAL cCpfSocio

Set Defa To ( oAmbiente:xBase )
WHILE OK
	oMenu:Limpa()
   nScreenSaver    := oIni:ReadInteger('sistema', 'screensaver', 60 )
   cEmail          := oIni:ReadString('sistema', 'email', Space(40) )
   cSmtp           := oIni:ReadString('sistema', 'smtp', 'SMTP.MICROBRAS.COM.BR' + Space(19))
   cNomeEmpresa    := oIni:ReadString('sistema', 'nomeempresa', XNOMEFIR + Space(40-Len(XNOMEFIR)))
   cFantasia       := oIni:ReadString('sistema', 'fantasia',    XFANTA   + Space(40-Len(XFANTA)))
   cCgcEmpresa     := oIni:ReadString('sistema', 'cgcempresa', XCGCFIR )
   cNomeSocio      := oIni:ReadString('sistema', 'nomesocio', XNOMESOCIO + Space(40-Len(XNOMESOCIO)))
   cCpfSocio       := oIni:ReadString('sistema', 'cpfsocio', XCPFSOCIO )
   nRecibo         := oIni:ReadInteger('baixasrece', 'recibo', 1 )
   nAutenticar     := oIni:ReadInteger('baixasrece', 'autenticar', 2 )
   nNenhum         := oIni:ReadInteger('baixasrece', 'nenhum', 3 )
   nTipoBusca      := oIni:ReadInteger('sistema', 'tipobusca', 1 )	
	cNrMarcaTicket  := IF( oIni:ReadBool('sistema','nrmarcaticket', FALSO ), "S", "N")
   cPvMarcaTicket  := IF( oIni:ReadBool('sistema','pvmarcaticket', FALSO ), "S", "N")
   cCampoDesconto  := IF( oIni:ReadBool('baixasrece','campodesconto', OK ), "S", "N")
   cTrocarVendedor := IF( oIni:ReadBool('sistema','trocarvendedor', OK ), "S", "N")

   MaBox( 01, 01, 18, 79, "CONFIGURACAO - GERAL")
	@ 02, 02 Say "Tempo Protetor Tela.: " Get nScreenSaver   Pict "9999"
	@ 03, 02 Say "Email...............: " Get cEmail         Pict "@!"
	@ 04, 02 Say "Servidor SMTP.......: " Get cSmtp          Pict "@!"
   @ 05, 02 Say "Nome Empresa........: " Get cNomeEmpresa   Pict "@!"
   @ 06, 02 Say "Nome Fantasia.......: " Get cFantasia      Pict "@!"
   @ 07, 02 Say "Cnpj/CPF Empresa....: " Get cCgcEmpresa    Pict "@!"
   @ 08, 02 Say "Nome Socio..........: " Get cNomeSocio     Pict "@!"
   @ 09, 02 Say "CPF Socio...........: " Get cCpfSocio      Pict "999.999.999-99"
   @ 10, 02 Say "Posicao Menu [Recibo] apos Recebimento.....:" Get nRecibo         Pict "9" Valid PickTam({'Primeiro','Segundo','Terceiro'}, {1,2,3}, @nRecibo)
   @ 11, 02 Say "Posicao Menu [Autenticar] apos Recebimento.:" Get nAutenticar     Pict "9" Valid PickTam({'Primeiro','Segundo','Terceiro'}, {1,2,3}, @nAutenticar)
   @ 12, 02 Say "Posicao Menu [Nenhum] apos Recebimento.....:" Get nNenhum         Pict "9" Valid PickTam({'Primeiro','Segundo','Terceiro'}, {1,2,3}, @nNenhum)
   @ 13, 02 Say "Mostrar Campo Desconto ao receber titulo...:" Get cCampoDesconto  Pict "!" Valid PickSimNao( @cCampoDesconto )
   @ 14, 02 Say "Tipo Menu de Procura Produto...............:" Get nTipoBusca      Pict "9" Valid PickTam({'Ordem Codigo','Ordem Fabricante'}, {1,2}, @nTipoBusca)
   @ 15, 02 Say "Imprimir Marca Produto Ticket Venda........:" Get cNrMarcaTicket  Pict "!" Valid PickSimNao( @cNrMarcaTicket )
   @ 16, 02 Say "Imprimir Marca Produto Ticket PreVenda.....:" Get cPvMarcaTicket  Pict "!" Valid PickSimNao( @cPvMarcaTicket )
   @ 17, 02 Say "Permitir faturar comissao outro vendedor...:" Get cTrocarVendedor Pict "!" Valid PickSimNao( @cTrocarVendedor )
   Read
	IF LastKey() = ESC
		Set Defa To ( cPath )		
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		oIni:WriteInteger('sistema', 'screensaver', nScreenSaver )
		oIni:WriteString('sistema', 'email', cEmail )
		oIni:WriteString('sistema', 'smtp', cSmtp )
      oIni:WriteString('sistema', 'nomeempresa', cNomeEmpresa )
      oIni:WriteString('sistema', 'fantasia', cFantasia )
      oIni:WriteString('sistema', 'cgcempresa', cCgcEmpresa )
      oIni:WriteString('sistema', 'tipobusca', nTipoBusca )
      oIni:WriteString('sistema', 'nomesocio', cNomeSocio )
      oIni:WriteString('sistema', 'cpfsocio',  cCpfSocio )
      oIni:WriteBool('sistema','nrmarcaticket', IF( cNrMarcaTicket = "S", OK, FALSO ))
      oIni:WriteBool('sistema','pvmarcaticket', IF( cPvMarcaTicket = "S", OK, FALSO ))
      oIni:WriteInteger('baixasrece', 'recibo', nRecibo )
		oIni:WriteInteger('baixasrece', 'autenticar', nAutenticar )
		oIni:WriteInteger('baixasrece', 'nenhum', nNenhum )
		oIni:WriteBool('baixasrece','campodesconto', IF( cCampoDesconto = "S", OK, FALSO ))
      oIni:WriteBool('sistema','trocarvendedor', IF( cTrocarVendedor = "S", OK, FALSO ))
      oAmbiente:xFanta   := cFantasia
      oAmbiente:xNomefir := cNomeEmpresa
	EndIF
EndDo

Proc ConfRelatorios()
*********************
LOCAL cScreen				:= SaveScreen()
LOCAL GetList				:= {}
LOCAL cPath 				:= FCurdir()
LOCAL nRolVendas			:= 1
LOCAL nRolRecemov 		:= 1
LOCAL nRolCaixa			:= 1
LOCAL nRolRecebido		:= 1
LOCAL nRolContraPartida := 2
LOCAL nTipoCaixa			:= 2
LOCAL nTamPromissoria	:= 33

Set Defa To ( oAmbiente:xBase )
WHILE OK
	oMenu:Limpa()
	nRolVendas			:= oIni:ReadInteger('relatorios','rolvendas', 1)
	nRolRecemov 		:= oIni:ReadInteger('relatorios','rolrecemov', 1 )
	nRolCaixa			:= oIni:ReadInteger('relatorios','rolcaixa', 1 )
	nRolRecebido		:= oIni:ReadInteger('relatorios','rolrecebido', 1 )
	nRolContraPartida := oIni:ReadInteger('relatorios','rolcontrapartida', 2 )
	nTipoCaixa			:= oIni:ReadInteger('relatorios','tipocaixa', 2 )
	nTamPromissoria	:= oIni:ReadInteger('relatorios','tampromissoria', 33 )
	oMenu:MaBox( 01, 01, 09, 78, "CONFIGURACAO - RELATORIOS")
	@ 02, 02 Say "Tipo Relatorio Vendas...: " Get nRolVendas        Pict "9" Valid PickTam({"Normal", "Ecf"}, {1,2}, @nRolVendas )
	@ 03, 02 Say "Tipo Relatorio Receber..: " Get nRolRecemov       Pict "9" Valid PickTam({"Normal", "Ecf"}, {1,2}, @nRolRecemov )
	@ 04, 02 Say "Tipo Relatorio Caixa....: " Get nRolCaixa         Pict "9" Valid PickTam({"Normal", "Ecf"}, {1,2}, @nRolCaixa )
	@ 05, 02 Say "Tipo Relatorio Recebido.: " Get nRolRecebido      Pict "9" Valid PickTam({"Normal", "Ecf"}, {1,2}, @nRolRecebido )
	@ 06, 02 Say "Tipo Rol Contra Partida.: " Get nRolContraPartida Pict "9" Valid PickTam({"Sem Contra Partida", "Com Contra Partida"}, {1,2}, @nRolContraPartida )
	@ 07, 02 Say "Ordem Relatorio Caixa...: " Get nTipoCaixa        Pict "9" Valid PickTam({"Data Lancamento", "Data Baixa"}, {1,2}, @nTipoCaixa )
	@ 08, 02 Say "Tamanho Form Promissoria: " Get nTamPromissoria   Pict "99" Valid PickTam({"22 Linhas","33 Linhas","66 Linhas"}, {22,33,66}, @nTamPromissoria )
	Read
	IF LastKey() = ESC
		Set Defa To ( cPath )
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		oIni:WriteInteger('relatorios', 'rolvendas',        nRolVendas )
		oIni:WriteInteger('relatorios', 'rolrecemov',       nRolRecemov )
		oIni:WriteInteger('relatorios', 'rolcaixa',         nRolCaixa )
		oIni:WriteInteger('relatorios', 'rolrecebido',      nRolRecebido )
		oIni:WriteInteger('relatorios', 'rolcontrapartida', nRolContraPartida )
		oIni:WriteInteger('relatorios', 'tipocaixa',        nTipoCaixa )
		oIni:WriteInteger('relatorios', 'tampromissoria',   nTamPromissoria )
	EndIF
EndDo

Proc ConfPrevenda()
*******************
LOCAL cScreen				:= SaveScreen()
LOCAL GetList				:= {}
LOCAL cPath 				:= FCurdir()
LOCAL cAparelhoMarca
LOCAL cModeloSerie
LOCAL cAnoCor
LOCAL cPlacaEstado
LOCAL cObs2
LOCAL cObs3

Set Defa To ( oAmbiente:xBase )
WHILE OK
	oMenu:Limpa()
	cAparelhoMarca := IF( oIni:ReadBool('prevenda','aparelhomarca', FALSO ), "S", "N")
	cModeloSerie	:= IF( oIni:ReadBool('prevenda','modeloserie', FALSO ), "S", "N")
	cAnoCor			:= IF( oIni:ReadBool('prevenda','anocor', FALSO ), "S", "N")
	cPlacaEstado	:= IF( oIni:ReadBool('prevenda','placaestado', FALSO ), "S", "N")
	cObs2 			:= IF( oIni:ReadBool('prevenda','obs2', FALSO ), "S", "N")
	cObs3 			:= IF( oIni:ReadBool('prevenda','obs3', FALSO ), "S", "N")
	oMenu:MaBox( 01, 01, 08, 78, "CONFIGURACAO - PREVENDA")
	@ 02, 	  02 Say "Imprimir Linha Aparelho e Marca..: " Get cAparelhoMarca Pict '!' Valid PickSimNao( @cAparelhoMarca )
	@ Row()+1, 02 Say "Imprimir Linha Modelo e Serie....: " Get cModeloSerie   Pict '!' Valid PickSimNao( @cModeloSerie )
	@ Row()+1, 02 Say "Imprimir Linha Ano e Cor.........: " Get cAnoCor        Pict '!' Valid PickSimNao( @cAnoCor )
	@ Row()+1, 02 Say "Imprimir Placa e Estado..........: " Get cPlacaEstado   Pict '!' Valid PickSimNao( @cPlacaEstado )
	@ Row()+1, 02 Say "Imprimir Linha 2 de Observacoes..: " Get cObs2          Pict '!' Valid PickSimNao( @cObs2 )
	@ Row()+1, 02 Say "Imprimir Linha 3 de Observacoes..: " Get cObs3          Pict '!' Valid PickSimNao( @cObs3 )
	Read
	IF LastKey() = ESC
		Set Defa To ( cPath )
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		oIni:WriteBool( 'prevenda',  'aparelhomarca', IF( cAparelhoMarca = "S", OK, FALSO ))
		oIni:WriteBool( 'prevenda',  'modeloserie',   IF( cModeloSerie   = "S", OK, FALSO ))
		oIni:WriteBool( 'prevenda',  'anocor',        IF( cAnoCor        = "S", OK, FALSO ))
		oIni:WriteBool( 'prevenda',  'placaestado',   IF( cPlacaEstado   = "S", OK, FALSO ))
		oIni:WriteBool( 'prevenda',  'obs2',          IF( cObs2          = "S", OK, FALSO ))
		oIni:WriteBool( 'prevenda',  'obs3',          IF( cObs3          = "S", OK, FALSO ))
	EndIF
EndDo

Proc ConfEcf()
**************
LOCAL cScreen	 := SaveScreen()
LOCAL GetList	 := {}
LOCAL cPath 	 := FCurdir()
LOCAL nModelo	 := 1
LOCAL nPorta	 := 2
LOCAL nIndice	 := 1
LOCAL nUfIcms	 := 17
LOCAL nIss      := 5
LOCAL cPos1Icms := Space(02)
LOCAL cPos2Icms := Space(02)
LOCAL cPos3Icms := Space(02)
LOCAL cPos4Icms := Space(02)
LOCAL cPos5Icms := Space(02)
LOCAL cPos6Icms := Space(02)
LOCAL cPos7Icms := Space(02)
LOCAL cPos8Icms := Space(02)
LOCAL cPos9Icms := Space(02)
LOCAL cIcmsIss1 := Space(01)
LOCAL cIcmsIss2 := Space(01)
LOCAL cIcmsIss3 := Space(01)
LOCAL cIcmsIss4 := Space(01)
LOCAL cIcmsIss5 := Space(01)
LOCAL cIcmsIss6 := Space(01)
LOCAL cIcmsIss7 := Space(01)
LOCAL cIcmsIss8 := Space(01)
LOCAL cIcmsIss9 := Space(01)
LOCAL nSigLinha := 1
LOCAL cVista	 := 'S'
LOCAL cNomeEcf  := 'N'
LOCAL cAutoEcf  := 'N'
LOCAL cEcfRede  := 'N'
LOCAL nAtiva	 := 2
LOCAL cPathrede := Space(30)
LOCAL cDrive	 := oAmbiente:xBase
LOCAL cPathStr  := cDrive + '\CMD'
LOCAL aEcf      := {"Zanthus IZ-11", "Bematech MP-20 FI II", "Zanthus IZ-20", "Sigtron FS345", 'Sweda FS 7000I', 'Daruma FS 2000'}

Set Defa To ( oAmbiente:xBase )
WHILE OK
	oMenu:Limpa()
	cPathrede  := oIni:ReadString('ecf', 'pathrede', cPathStr )
	cPathRede  += Space(30-Len(cPathRede))
	nModelo	  := oIni:ReadInteger('ecf', 'modelo', 1 )
	nPorta	  := oIni:ReadInteger('ecf', 'porta', 2 )
	nIndice	  := oIni:ReadInteger('ecf', 'indice', 1.25 )
	nUfIcms	  := oIni:ReadInteger('ecf', 'uficms', 17 )
   nIss       := oIni:ReadInteger('ecf', 'iss', 5 )
	nAtiva	  := oIni:ReadString('ecf',  'ativa', 2 )
	nSigLinha  := oIni:ReadInteger('ecf',  'siglinha', 1 )

	cPos1Icms := oIni:ReadString('ecf', 'pos1icms', '07.00', 1 ) ; cPos1Icms += IF( Len( cPos1Icms ) = 2, '.00','')
	cPos2Icms := oIni:ReadString('ecf', 'pos2icms', '12.00', 1 ) ; cPos2Icms += IF( Len( cPos2Icms ) = 2, '.00','')
	cPos3Icms := oIni:ReadString('ecf', 'pos3icms', '17.00', 1 ) ; cPos3Icms += IF( Len( cPos3Icms ) = 2, '.00','')
	cPos4Icms := oIni:ReadString('ecf', 'pos4icms', '25.00', 1 ) ; cPos4Icms += IF( Len( cPos4Icms ) = 2, '.00','')
	cPos5Icms := oIni:ReadString('ecf', 'pos5icms', '05.00', 1 ) ; cPos5Icms += IF( Len( cPos5Icms ) = 2, '.00','')
	cPos6Icms := oIni:ReadString('ecf', 'pos6icms', '00.00', 1 ) ; cPos6Icms += IF( Len( cPos6Icms ) = 2, '.00','')
	cPos7Icms := oIni:ReadString('ecf', 'pos7icms', '00.00', 1 ) ; cPos7Icms += IF( Len( cPos7Icms ) = 2, '.00','')
	cPos8Icms := oIni:ReadString('ecf', 'pos8icms', '00.00', 1 ) ; cPos8Icms += IF( Len( cPos8Icms ) = 2, '.00','')
	cPos9Icms := oIni:ReadString('ecf', 'pos9icms', '00.00', 1 ) ; cPos9Icms += IF( Len( cPos9Icms ) = 2, '.00','')

	cIcmsIss1 := oIni:ReadString('ecf', 'pos1icms', '1', 2 )
	cIcmsIss2 := oIni:ReadString('ecf', 'pos2icms', '1', 2 )
	cIcmsIss3 := oIni:ReadString('ecf', 'pos3icms', '1', 2 )
	cIcmsIss4 := oIni:ReadString('ecf', 'pos4icms', '1', 2 )
	cIcmsIss5 := oIni:ReadString('ecf', 'pos5icms', '1', 2 )
	cIcmsIss6 := oIni:ReadString('ecf', 'pos6icms', '1', 2 )
	cIcmsIss7 := oIni:ReadString('ecf', 'pos7icms', '1', 2 )
	cIcmsIss8 := oIni:ReadString('ecf', 'pos8icms', '1', 2 )
	cIcmsIss9 := oIni:ReadString('ecf', 'pos9icms', '1', 2 )

	cVista	  := IF( oIni:ReadBool('ecf','vista', OK ), "S", "N")
	cNomeEcf   := IF( oIni:ReadBool('ecf','nomeecf', OK ), "S", "N")
	cAutoEcf   := IF( oIni:ReadBool('ecf','autoecf', FALSO ), "S", "N")
	cEcfRede   := IF( oIni:ReadBool('ecf','ecfrede', FALSO ), "S", "N")

   oMenu:MaBox( 00, 01, 18, 78, "ECF CUPOM FISCAL - CONFIGURACAO")
   @ 01, 02 Say "Impressora Ativa....... " Get nAtiva     Pict "9"    Valid PickSimNao( @nAtiva )
   @ 01, 40 Say "Modelo Impressora ECF.: " Get nModelo    Pict "9"    Valid PickTam( aEcf, {1,2,3,4,5,6}, @nModelo )
   @ 02, 02 Say "Porta de comunicacao..: " Get nPorta     Pict "9"    Valid PickTam({"Com1","Com2","Com3","Com4",'Com5','Com6','Com7','Com8','Com9'}, {1,2,3,4,5,6,7,8,9}, @nPorta )
   @ 02, 40 Say "ECF Monitorada/Rede...: " Get cEcfRede   Pict "!"    Valid PickSimNao( @cEcfRede ) When nModelo = 2 .OR. nModelo = 6
	@ 03, 02 Say "Diretorio Driver Rede.: " Get cPathRede  Pict "@!"
	@ 04, 02 Say "Indice................: " Get nIndice    Pict "9.99"
	@ 04, 40 Say "Icms Estadual.........: " Get nUfIcms    Pict "99.99"
   @ 05, 02 Say "Iss Municipal.........: " Get nIss       Pict "99.99"
	@ 05, 40 Say "Emitir Cupom a Vista..: " Get cVista     Pict "!"  Valid PickSimNao( @cVista )
	@ 06, 02 Say "Emitir Nome Cliente...: " Get cNomeEcf   Pict "!"  Valid PickSimNao( @cNomeEcf )
	@ 06, 40 Say "Auto Emitir Cupom.....: " Get cAutoEcf   Pict "!"  Valid PickSimNao( @cAutoEcf )
	@ 07, 02 Say "Imprimir CF em Linhas.: " Get nSigLinha  Pict "9"  Valid PickTam({'1 Linha', '2 Linhas'}, {1,2}, @nSigLinha )
//   Write( 08, 02, Repl("Ä",77))
   oMenu:MaBox( 08, 01, 18, 78, 'CONFIGURACAO ADICIONAL PARA: ' + aEcf[2])
   @ 09, 02 Say "Aliquota Posicao 01...: " Get cPos1Icms  Pict "99.99" when nModelo == 2
   @ 09, 40 Say "Icms/Iss..............: " Get cIcmsIss1  Pict "9" Valid PickTam({'Icms', 'Iss'}, {'1','2'}, @cIcmsIss1 ) when nModelo = 2
   @ 10, 02 Say "Aliquota Posicao 02...: " Get cPos2Icms  Pict "99.99" when nModelo == 2
   @ 10, 40 Say "Icms/Iss..............: " Get cIcmsIss2  Pict "9" Valid PickTam({'Icms', 'Iss'}, {'1','2'}, @cIcmsIss2 ) when nModelo == 2
   @ 11, 02 Say "Aliquota Posicao 03...: " Get cPos3Icms  Pict "99.99" when nModelo = 2
   @ 11, 40 Say "Icms/Iss..............: " Get cIcmsIss3  Pict "9" Valid PickTam({'Icms', 'Iss'}, {'1','2'}, @cIcmsIss3 ) when nModelo = 2
   @ 12, 02 Say "Aliquota Posicao 04...: " Get cPos4Icms  Pict "99.99" when nModelo = 2
   @ 12, 40 Say "Icms/Iss..............: " Get cIcmsIss4  Pict "9" Valid PickTam({'Icms', 'Iss'}, {'1','2'}, @cIcmsIss4 ) when nModelo = 2
   @ 13, 02 Say "Aliquota Posicao 05...: " Get cPos5Icms  Pict "99.99" when nModelo = 2
   @ 13, 40 Say "Icms/Iss..............: " Get cIcmsIss5  Pict "9" Valid PickTam({'Icms', 'Iss'}, {'1','2'}, @cIcmsIss5 ) when nModelo = 2
   @ 14, 02 Say "Aliquota Posicao 06...: " Get cPos6Icms  Pict "99.99" when nModelo = 2
   @ 14, 40 Say "Icms/Iss..............: " Get cIcmsIss6  Pict "9" Valid PickTam({'Icms', 'Iss'}, {'1','2'}, @cIcmsIss6 ) when nModelo = 2
   @ 15, 02 Say "Aliquota Posicao 07...: " Get cPos7Icms  Pict "99.99" when nModelo = 2
   @ 15, 40 Say "Icms/Iss..............: " Get cIcmsIss7  Pict "9" Valid PickTam({'Icms', 'Iss'}, {'1','2'}, @cIcmsIss7 ) when nModelo = 2
   @ 16, 02 Say "Aliquota Posicao 08...: " Get cPos8Icms  Pict "99.99" when nModelo = 2
   @ 16, 40 Say "Icms/Iss..............: " Get cIcmsIss8  Pict "9" Valid PickTam({'Icms', 'Iss'}, {'1','2'}, @cIcmsIss8 ) when nModelo = 2
   @ 17, 02 Say "Aliquota Posicao 09...: " Get cPos9Icms  Pict "99.99" when nModelo = 2
   @ 17, 40 Say "Icms/Iss..............: " Get cIcmsIss9  Pict "9" Valid PickTam({'Icms', 'Iss'}, {'1','2'}, @cIcmsIss9 ) when nModelo = 2
	Read
	IF LastKey() = ESC
		Set Defa To ( cPath )
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		oIni:WriteInteger('ecf', 'modelo', nModelo )
		oIni:WriteInteger('ecf', 'porta', nPorta )
		oIni:WriteInteger('ecf', 'indice', nIndice )
		oIni:WriteInteger('ecf', 'uficms', nUfIcms )
		oIni:WriteInteger('ecf', 'ativa', nAtiva )
      oIni:WriteInteger('ecf', 'iss', nIss )
		oIni:WriteString('ecf',  'pos1icms', cPos1Icms + ';' + cIcmsIss1 )
		oIni:WriteString('ecf',  'pos2icms', cPos2Icms + ';' + cIcmsIss2 )
		oIni:WriteString('ecf',  'pos3icms', cPos3Icms + ';' + cIcmsIss3 )
		oIni:WriteString('ecf',  'pos4icms', cPos4Icms + ';' + cIcmsIss4 )
		oIni:WriteString('ecf',  'pos5icms', cPos5Icms + ';' + cIcmsIss5 )
		oIni:WriteString('ecf',  'pos6icms', cPos6Icms + ';' + cIcmsIss6 )
		oIni:WriteString('ecf',  'pos7icms', cPos7Icms + ';' + cIcmsIss7 )
		oIni:WriteString('ecf',  'pos8icms', cPos8Icms + ';' + cIcmsIss8 )
		oIni:WriteString('ecf',  'pos9icms', cPos9Icms + ';' + cIcmsIss9 )
		oIni:WriteBool(  'ecf',  'vista',   IF( cVista   = "S", OK, FALSO ))
		oIni:WriteBool(  'ecf',  'nomeecf', IF( cNomeEcf = "S", OK, FALSO ))
		oIni:WriteBool(  'ecf',  'autoecf', IF( cAutoEcf = "S", OK, FALSO ))
		oIni:WriteBool(  'ecf',  'ecfrede', IF( cEcfRede = "S", OK, FALSO ))
		oIni:WriteString('ecf',  'pathrede', cPathRede )
		oIni:WriteInteger('ecf', 'siglinha', nSigLinha )
	EndIF
EndDo

Proc TermPrecos()
*****************
LOCAL GetList	:= {}
LOCAL cScreen	:= SaveScreen()
LOCAL xCodigo	:= 0
LOCAL nCol		:= LastRow()
LOCAL nTam		:= MaxCol()
LOCAL nPos		:= 0
LOCAL cString1 := "³ENTER=CONSULTA³ESC=SAIR"

SetKey( F5, NIL )
oMenu:Limpa()
WHILE OK
	xCodigo := 0
	aPrint( 00, 00,  Padc("TERMINAL DE CONSULTA DE PRECOS",MaxCol()), oMenu:CorCabec, MaxCol() )
	MaBox( 02, 01, 10, 78 )
	MaBox( 12, 01, 22, 78 )
	nPos := ( nTam - Len( cString1 ))
	aPrint( nCol, 00, "³CLIQUE COM O SCANNER OU DIGITE O CODIGO DO PRODUTO", oMenu:CorCabec, MaxCol() )
	aPrint( nCol, nPos, cString1, oMenu:CorCabec )
	Set Conf On
	@ 04, 10 Say "Codigo...: " Get xCodigo Pict "9999999999999" Valid TermProduto( @xCodigo )
	@ 06, 10 Say "Produto..: "
	Read
	Set Conf Off
	IF LastKey() = ESC
		SetKey( F5, {|| PrecosConsulta()})
		Return
	EndIF
	Inkey(5)
EndDo

Function TermProduto( xCodigo)
******************************
LOCAL aRotina			  := {{|| InclusaoProdutos() }}
LOCAL aRotinaAlteracao := {{|| InclusaoProdutos(OK) }}
LOCAL GetList			  := {}
LOCAL Arq_Ant			  := Alias()
LOCAL Ind_Ant			  := IndexOrd()
LOCAL nTam				  := 6
LOCAL cTemp
LOCAL cScreen

cTemp   := IF( ValType(xCodigo) = "N", Str(xCodigo, 13), xCodigo)
nTam	  := Len( AllTrim( cTemp ))
IF nTam <= 6
	nTam	  := 6
	xCodigo :=IF( ValType(xCodigo) = "N", StrZero(xCodigo, nTam), xCodigo)
ElseIF nTam = 8
	nTam	  := 8
	xCodigo := IF( ValType(xCodigo) = "N", StrZero(xCodigo, nTam), xCodigo)
 Else
	nTam	  := 13
	xCodigo := IF( ValType(xCodigo) = "N", StrZero(xCodigo, nTam), xCodigo)
EndIF
Area("Lista")
IF nTam = 6
	Lista->(Order( LISTA_CODIGO ))
ElseIF nTam = 13 .OR. nTam = 8
	Lista->(Order( LISTA_CODEBAR ))
EndIF
IF Lista->( !DbSeek( xCodigo ))
	Lista->(Order( LISTA_DESCRICAO ))
	Escolhe( 12, 01, 22, "Codigo + 'Ý' + Sigla + 'Ý' + Descricao + 'Ý' + Tran( Varejo, '@E 9999,999,999.99')","CODI  MARCA      DESCRICAO DO PRODUTO                      PRECO", aRotina, NIL, aRotinaAlteracao, NIl, FALSO)
EndIF
xCodigo := Lista->CodeBar
Write( 06, 22,  Lista->Descricao )
MaBox( 12, 01, 22, 78 )
Num( 14, Lista->Varejo)
AreaAnt( Arq_Ant, Ind_Ant )
Return( .T. )

Function Num( nRow, nValor )
****************************
LOCAL aNum := {{" ÛÛÛ " ,;
					 "Û  ÛÛ" ,;
					 "Û Û Û" ,;
					 "ÛÛ  Û" ,;
					 " ÛÛÛ "},;
					{"  ÛÛ" ,;
					 " Û Û" ,;
					 "Û  Û" ,;
					 "   Û" ,;
					 "ÛÛÛÛ"},;
					{"ÛÛÛÛÛ" ,;
					 "    Û" ,;
					 "ÛÛÛÛÛ" ,;
					 "Û    " ,;
					 "ÛÛÛÛÛ"},;
					{"ÛÛÛÛÛ" ,;
					 "    Û" ,;
					 " ÛÛÛÛ" ,;
					 "    Û" ,;
					 "ÛÛÛÛÛ"},;
					{"Û   Û" ,;
					 "Û   Û" ,;
					 "ÛÛÛÛÛ" ,;
					 "    Û" ,;
					 "    Û"},;
					{"ÛÛÛÛÛ" ,;
					 "Û    " ,;
					 "ÛÛÛÛÛ" ,;
					 "    Û" ,;
					 "ÛÛÛÛÛ"},;
					{"ÛÛÛÛÛ" ,;
					 "Û    " ,;
					 "ÛÛÛÛÛ" ,;
					 "Û   Û" ,;
					 "ÛÛÛÛÛ"},;
					{"ÛÛÛÛÛ" ,;
					 "   ÛÛ" ,;
					 "  ÛÛ " ,;
					 " ÛÛ  " ,;
					 "ÛÛ   "},;
					{"ÛÛÛÛÛ" ,;
					 "Û   Û" ,;
					 "ÛÛÛÛÛ" ,;
					 "Û   Û" ,;
					 "ÛÛÛÛÛ"},;
					{"ÛÛÛÛÛ" ,;
					 "Û   Û" ,;
					 "ÛÛÛÛÛ" ,;
					 "    Û" ,;
					 "ÛÛÛÛÛ"},;
					{"   " ,;
					 "   " ,;
					 "   " ,;
					 "   " ,;
					 "  "},;
					{"   " ,;
					 "   " ,;
					 "   " ,;
					 "   " ,;
					 "  "}}

LOCAL aDig	  := {"0","1","2","3","4","5","6","7","8","9",".",","}
LOCAL cNumero := AllTrim(Tran(nValor, "99,9999.99"))
LOCAL nTam	  := Len( cNumero )
LOCAL nX 	  := 0
LOCAL nY 	  := 0
LOCAL cDig	  := ""
LOCAL nPos	  := 0
LOCAL nConta  := 0

For nX := 1 To nTam
	cDig	 := SubStr( cNumero, nX, 1 )
	nPos	 := Ascan( aDig, cDig )
	nConta ++
	For nY := 1 To 5
		Write( nRow+nY, 5*nConta+nConta, aNum[nPos,nY])
	Next
Next

Proc ConfOpcoesFaturamento( cNome )
***********************************
LOCAL cScreen := SaveScreen()
LOCAL GetList := {}
LOCAL oVenlan	:= TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
LOCAL c2_01
LOCAL c2_02
LOCAL c2_03
LOCAL c2_04
LOCAL c2_05
LOCAL c2_06

WHILE OK
	oMenu:Limpa()
	c2_01 := IF( oVenlan:ReadBool('opcoesfaturamento','#2.01', OK ), "S", "N")
	c2_02 := IF( oVenlan:ReadBool('opcoesfaturamento','#2.02', OK ), "S", "N")
	c2_03 := IF( oVenlan:ReadBool('opcoesfaturamento','#2.03', OK ), "S", "N")
	c2_04 := IF( oVenlan:ReadBool('opcoesfaturamento','#2.04', OK ), "S", "N")
	c2_05 := IF( oVenlan:ReadBool('opcoesfaturamento','#2.05', OK ), "S", "N")
	c2_06 := IF( oVenlan:ReadBool('opcoesfaturamento','#2.06', OK ), "S", "N")

	oMenu:MaBox( 00, 01, 07, 78, "CONFIGURACAO - OPCOES DE FATURAMENTO")
	@ 01, 		02 Say "Manualmente - Varejo..........: " Get c2_01 Pict "!"  Valid PickSimNao( @c2_01 )
	@ Row()+01, 02 Say "Manualmente - Atacado.........: " Get c2_02 Pict "!"  Valid PickSimNao( @c2_02 )
	@ Row()+01, 02 Say "Manualmente - Custo...........: " Get c2_03 Pict "!"  Valid PickSimNao( @c2_03 )
	@ Row()+01, 02 Say "Codigo Barra - Varejo.........: " Get c2_04 Pict "!"  Valid PickSimNao( @c2_04 )
	@ Row()+01, 02 Say "Codigo Barra - Atacado........: " Get c2_05 Pict "!"  Valid PickSimNao( @c2_05 )
	@ Row()+01, 02 Say "Codigo Barra - Custo..........: " Get c2_06 Pict "!"  Valid PickSimNao( @c2_06 )
	Read
	IF LastKey() = ESC
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		oVenlan:WriteBool( 'opcoesfaturamento', '#2.01', IF( c2_01 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'opcoesfaturamento', '#2.02', IF( c2_02 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'opcoesfaturamento', '#2.03', IF( c2_03 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'opcoesfaturamento', '#2.04', IF( c2_04 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'opcoesfaturamento', '#2.05', IF( c2_05 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'opcoesfaturamento', '#2.06', IF( c2_06 = "S", OK, FALSO ))
	EndIF
EndDo

Proc ConfFiscal( cNome )
************************
LOCAL cScreen := SaveScreen()
LOCAL GetList := {}
LOCAL oVenlan	:= TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
LOCAL c2_01
LOCAL c2_02
LOCAL c2_03
LOCAL c2_04
LOCAL c2_05
LOCAL c2_06
LOCAL c2_07
LOCAL c2_08
LOCAL c2_09

WHILE OK
	oMenu:Limpa()
	c2_01 := IF( oVenlan:ReadBool('impressorasfiscais','#2.01', OK ), "S", "N")
	c2_02 := IF( oVenlan:ReadBool('impressorasfiscais','#2.02', OK ), "S", "N")
	c2_03 := IF( oVenlan:ReadBool('impressorasfiscais','#2.03', OK ), "S", "N")
	c2_04 := IF( oVenlan:ReadBool('impressorasfiscais','#2.04', OK ), "S", "N")
	c2_05 := IF( oVenlan:ReadBool('impressorasfiscais','#2.05', OK ), "S", "N")
	c2_06 := IF( oVenlan:ReadBool('impressorasfiscais','#2.06', OK ), "S", "N")
	c2_07 := IF( oVenlan:ReadBool('impressorasfiscais','#2.07', OK ), "S", "N")
	c2_08 := IF( oVenlan:ReadBool('impressorasfiscais','#2.08', OK ), "S", "N")
	c2_09 := IF( oVenlan:ReadBool('impressorasfiscais','#2.09', OK ), "S", "N")

	oMenu:MaBox( 00, 01, 10, 78, "CONFIGURACAO - IMPRESSORAS FISCAIS")
	@ 01, 		02 Say "Cadastrar Forma de Pagamento..: " Get c2_01 Pict "!"  Valid PickSimNao( @c2_01 )
	@ Row()+01, 02 Say "Emissao da Reducao Z - Fim Dia: " Get c2_02 Pict "!"  Valid PickSimNao( @c2_02 )
   @ Row()+01, 02 Say "Emissao da Leitura X..........: " Get c2_03 Pict "!"  Valid PickSimNao( @c2_03 )
	@ Row()+01, 02 Say "Leitura Memoria Fiscal - Data.: " Get c2_04 Pict "!"  Valid PickSimNao( @c2_04 )
	@ Row()+01, 02 Say "Leitura Memoria Fiscal - Redu.: " Get c2_05 Pict "!"  Valid PickSimNao( @c2_05 )
	@ Row()+01, 02 Say "Relatorio Gerencial...........: " Get c2_06 Pict "!"  Valid PickSimNao( @c2_06 )
	@ Row()+01, 02 Say "Inicio Dia Fiscal.............: " Get c2_07 Pict "!"  Valid PickSimNao( @c2_07 )
	@ Row()+01, 02 Say "Verificacao do Modulo Fiscal..: " Get c2_08 Pict "!"  Valid PickSimNao( @c2_08 )
	@ Row()+01, 02 Say "Verificacao Dia Livre.........: " Get c2_09 Pict "!"  Valid PickSimNao( @c2_09 )
	Read
	IF LastKey() = ESC
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma  ?")
		oVenlan:WriteBool( 'impressorasfiscais', '#2.01', IF( c2_01 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'impressorasfiscais', '#2.02', IF( c2_02 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'impressorasfiscais', '#2.03', IF( c2_03 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'impressorasfiscais', '#2.04', IF( c2_04 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'impressorasfiscais', '#2.05', IF( c2_05 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'impressorasfiscais', '#2.06', IF( c2_06 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'impressorasfiscais', '#2.07', IF( c2_07 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'impressorasfiscais', '#2.08', IF( c2_08 = "S", OK, FALSO ))
		oVenlan:WriteBool( 'impressorasfiscais', '#2.09', IF( c2_09 = "S", OK, FALSO ))
	EndIF
EndDo

Proc EcfComandos()
******************
LOCAL cScreen := SaveScreen()
LOCAL nChoice := 0
LOCAL aEcf    := {"Zanthus IZ-11", "Bematech MP-20 FI II", "Zanthus IZ-20", "Sigtron FS345", 'Sweda FS 7000I', 'Daruma FS 2000'}
LOCAL nIniEcf := oIni:ReadInteger('ecf','modelo', 1 )

WHILE OK
	oMenu:Limpa()
	M_Title("COMANDOS DE IMPRESSORA FISCAL")
   nChoice := FazMenu( 05, 10, aEcf )
	Do Case
	Case nChoice = 0
      Exit
   Otherwise
      IF nIniEcf != nChoice
         ErrorBeep()
         Alerta('Erro: ECF configurada na base de dados ‚: ' + aEcf[nIniEcf])
         Loop
      EndIF
      Ecf(nChoice, aEcf)
   EndCase
EndDO

Proc Ecf( nTipo, aEcf )
***********************
LOCAL cScreen		:= SaveScreen()
LOCAL nChoice		:= 0
LOCAL aEcfPermite := {}
LOCAL aMenu       := {"Cadastrar Forma de Pagto",;
                      "Cadastrar Aliquotas",;
                      "Emissao Reducao Z",;
                      "Emissao Leitura X",;
                      "Leitura Memoria Fiscal por Data",;
                      "Leitura Memoria Fiscal por Reducao",;
                      "Relatorio Gerencial",;
                      "Inicio Dia Fiscal",;
                      "Verificacao Modulo Fiscal",;
                      "Verificacao Dia Livre"}
oAmbiente:aFiscalIni := FiscalRegedit()
aEcfPermite          := { SnFiscal(2.01),SnFiscal(2.02),SnFiscal(2.03),;
                          SnFiscal(2.04),SnFiscal(2.05),SnFiscal(2.06),;
                          SnFiscal(2.07),SnFiscal(2.08),SnFiscal(2.09) }


// LOCAL aEcf    := {"Zanthus IZ-11", "Bematech MP-20 FI II", "Zanthus IZ-20", "Sigtron FS345", 'Sweda FS 7000I', 'Daruma FS 2000'}

WHILE OK
	M_Title("COMANDOS DE IMPRESSORA FISCAL")
   nChoice := FazMenu( 07, 12, aMenu, Cor(), aEcfPermite )
	Do Case
	Case nChoice = 0
		Return
	Case nChoice = 1
      IF nTipo = 2
         EcfForma_Bema()
      Else
			ErrorBeep()
         Alerta('Erro: Nao disponivel para: ' + aEcf[nTipo])
      EndIF
   Case nChoice = 2
      IF nTipo = 2
			Aliquota_Bema()
      ElseIF nTipo = 5
			Aliquota_Sigtron()
      Else
			ErrorBeep()
         Alerta('Erro: Nao disponivel para: ' + aEcf[nTipo])
      EndIF
	Case nChoice = 3
      ErrorBeep()
      IF Conf('Warning! Reducao Z encerra o dia. Abortar?')
         Loop
      EndIF
		IF nTipo = 1
			LeituraZ_Zanthus()
		ElseIF nTipo = 2
			LeituraZ_Bema()
      ElseIF nTipo = 3
			LeituraZ_Zanthus()
      ElseIF nTipo = 4
			LeituraZ_Sigtron()
      ElseIF nTipo = 5
         Z_Sweda()
      ElseIF nTipo = 6
         Z_Daruma()
		EndIF
	Case nChoice = 4
      ErrorBeep()
      IF Conf('Pergunta: Impressao de Leitura X. Abortar?')
         Loop
      EndIF
		IF nTipo = 1
			LeituraX_Zanthus()
		ElseIF nTipo = 2
			LeituraX_Bema()
      ElseIF nTipo = 3
			LeituraX_Zanthus()
      ElseIF nTipo = 4
			LeituraX_SigTron()
      ElseIF nTipo = 5
         X_Sweda()
      ElseIF nTipo = 6
         X_Daruma()
		EndIF
	Case nChoice = 5
		IF nTipo = 1
			MeFisDat_Zanthus()
		ElseIF nTipo = 2
			MeFisDat_Bema()
      ElseIF nTipo = 3
			MeFisDat_Zanthus()
      ElseIF nTipo = 4
			MeFisDat_Sigtron()
      Else
			ErrorBeep()
         Alerta('Erro: Nao disponivel para: ' + aEcf[nTipo])
      EndIF
	Case nChoice = 6
		IF nTipo = 1
			MeFisInt_Zanthus()
		ElseIF nTipo = 2
			MeFisInt_Bema()
      ElseIF nTipo = 3
			MeFisInt_Zanthus()
      ElseIF nTipo = 4
			MeFisInt_SigTron()
      Else
			ErrorBeep()
         Alerta('Erro: Nao disponivel para: ' + aEcf[nTipo])
      EndIF
	Case nChoice = 7
      IF nTipo = 2
			ReGerenc_Bema()
      ElseIF nTipo = 4
			ReGerenc_Sigtron()
      Else
			ErrorBeep()
         Alerta('Erro: Nao disponivel para: ' + aEcf[nTipo])
		EndIF
	Case nChoice = 8
      IF nTipo = 1 .OR. nTipo = 3
         DiaInicio_Zanthus()
      Else
			ErrorBeep()
         Alerta('Erro: Nao disponivel para: ' + aEcf[nTipo])
      EndIF
	Case nChoice = 9
      IF nTipo = 1 .OR. nTipo = 3
         VerModulo_Zanthus()
      Else
			ErrorBeep()
         Alerta('Erro: Nao disponivel para: ' + aEcf[nTipo])
      EndIF
   Case nChoice = 10
      IF nTipo = 1 .OR. nTipo = 3
         DiaLivre_Zanthus()
      Else
			ErrorBeep()
         Alerta('Erro: Nao disponivel para: ' + aEcf[nTipo])
      EndIF
   EndCase
EndDo

Proc EcfForma_Bema()
********************
LOCAL cScreen := SaveScreen()
LOCAL Arq_Ant	  := Alias()
LOCAL Ind_Ant	  := IndexOrd()
LOCAL nPorta	  := 0
LOCAL cIni		  := chr(27) + chr(251)
LOCAL cFim		  := "|"+ chr(27)
LOCAL cBuffer	  := ""
LOCAL Retorno	  := 0
LOCAL lEcfRede   := oIni:ReadBool('ecf','ecfrede', FALSO )


IF !UsaArquivo("FORMA")
	Return
EndIF
Forma->(Order( FORMA_FORMA ))
Forma->(DbGoTop())
nPorta := BemaIniciaDriver()
Mensagem("Aguarde, Registrando formas de Pgto")
WHILE Forma->(!Eof())
	 cForma		:= Forma->Forma
	 cDescForma := Left( Forma->Condicoes, 16 )
	 IF cForma = "01"
		 Forma->(DbSkip(1))
	EndIF
   IF lEcfRede
      cBuffer    := "148|" + cDescForma + '|1|'
   Else
      cBuffer    := cIni + "71|" + cDescForma + cFim
   EndIF
	Comunica_Com_Impressora( nPorta, cBuffer, Retorno )
	Forma->(DbSkip(1))
EndDo
FClose( nPorta )
ResTela( cScreen )
Return

Proc ReGerenc_Bema()
********************
LOCAL cScreen := SaveScreen()
LOCAL Arq_Ant	  := Alias()
LOCAL Ind_Ant	  := IndexOrd()
LOCAL nPorta	  := 0
LOCAL cIni		  := chr(27) + chr(251)
LOCAL cFim		  := "|"+ chr(27)
LOCAL cBuffer	  := ""
LOCAL Retorno	  := 0

nPorta := BemaIniciaDriver()
Mensagem("Aguarde, Emitindo Relatorio Gerencial")
cBuffer	:= cIni + "20|" + "ANTES DA IMPRESSAO DESTE RELATORIO, SERA IMPRESSO A LEITURA 'X'" + cFim
Comunica_Com_Impressora( nPorta, cBuffer, Retorno )
cBuffer	:= cIni + "21|" + cFim
Comunica_Com_Impressora( nPorta, cBuffer, Retorno )
FClose( nPorta )
ResTela( cScreen )
Return

Function SwedaOn()
******************
Set Cons Off
Set Devi To Print
Set Print To IfSweda
Set Print On
SetPrc(0,0)
Return Nil

Function SwedaOff()
******************
Set Devi To Screen
Set Prin Off
Set Cons On
Set Print to
CloseSpooler()
Return Nil

Proc X_Sweda()
**************
SwedaOn()
Write( Prow(), Pcol(), Chr(27) + ".13N}" )
SwedaOff()
Return

Proc Z_Sweda()
**************
SwedaOn()
Write( Prow(), Pcol(), Chr(27) + ".14N}" )
SwedaOff()
Return

Proc LeituraX_Bema()
********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cIni		:= chr(27) + chr(251)
LOCAL cFim		:= "|"+ chr(27)
LOCAL cBuffer	:= ""
LOCAL Retorno	:= 0
LOCAL lEcfRede := oIni:ReadBool('ecf','ecfrede', FALSO )

nPorta := BemaIniciaDriver()
Mensagem("Aguarde, Emitindo Leitura X")
IF lEcfRede
   cBuffer := "045|"
Else
   cBuffer := cIni + "06" + cFim
EndIF
Comunica_Com_Impressora( nPorta, cBuffer, Retorno )
FClose( nPorta )
ResTela( cScreen )
Return

Proc LeituraZ_Bema()
********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cIni		:= chr(27) + chr(251)
LOCAL cFim		:= "|"+ chr(27)
LOCAL cBuffer	:= ""
LOCAL Retorno	:= 0
LOCAL lEcfRede := oIni:ReadBool('ecf','ecfrede', FALSO )

oMenu:Limpa()
nPorta := BemaIniciaDriver()
Mensagem("Aguarde, Emitindo Reducao Z")
IF lEcfRede
   cBuffer := '071|'
Else
   cBuffer := cIni + "05" + cFim
EndIF
Comunica_Com_Impressora( nPorta, cBuffer, Retorno )
FClose( nPorta )
ResTela( cScreen )
Return

Proc MeFisDat_Bema()
********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cIni		:= chr(27) + chr(251)
LOCAL cFim		:= "|"+ chr(27)
LOCAL cPipe 	:= "|"
LOCAL cBuffer	:= ""
LOCAL Retorno	:= 0
LOCAL dIni		:= Date()
LOCAL dFim		:= Date()
LOCAL cSaida	:= "I"
LOCAL cDataIni := ""
LOCAL cDataFim := ""

MaBox( 10, 10, 13, 40 )
@ 11, 11 Say "Data Inicial..:" Get dIni Pict "##/##/##"
@ 12, 11 Say "Data Final....:" Get dFim Pict "##/##/##"
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
cDataIni := StrTran( Dtoc( dIni ), "/")
cDataFim := StrTran( Dtoc( dFim ), "/")
cDiaIni	:= Left( cDataIni, 2)
cMesIni	:= SubStr( cDataIni, 3, 2 )
cAnoIni	:= Right( cDataIni, 2 )
cDiaFim	:= Left( cDataFim, 2)
cMesFim	:= SubStr( cDataFim, 3, 2 )
cAnoFim	:= Right( cDataFim, 2 )

nPorta := BemaIniciaDriver()
Mensagem("Aguarde, Emitindo Leitura Memoria Fiscal")
cBuffer := cIni + "08" + cPipe
cBuffer += cDiaIni + cPipe
cBuffer += cMesIni + cPipe
cBuffer += cAnoIni + cPipe
cBuffer += cDiaFim + cPipe
cBuffer += cMesFim + cPipe
cBuffer += cAnoFim + cPipe
cBuffer += cSaida + cPipe + cFim
Comunica_Com_Impressora( nPorta, cBuffer, Retorno )
FClose( nPorta )
Return

Proc MeFisInt_Bema()
********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cIni		:= chr(27) + chr(251)
LOCAL cFim		:= "|"+ chr(27)
LOCAL cBuffer	:= ""
LOCAL Retorno	:= 0
LOCAL nIni		:= 0
LOCAL nFim		:= 0
LOCAL cSaida	:= "I"
LOCAL cPipe 	:= "|"

MaBox( 10, 10, 13, 40 )
@ 11, 11 Say "Reducao Inicial.:" Get nIni Pict "9999"
@ 12, 11 Say "Reducao Final...:" Get nFim Pict "9999"
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
nPorta := BemaIniciaDriver()
Mensagem("Aguarde, Emitindo Leitura Memoria Fiscal")
cBuffer := cIni + "08" + cPipe + "00" + cPipe + ;
			  StrZero( nIni, 4, 0 ) + cPipe + "00" + cPipe + ;
			  StrZero( nFim, 4, 0 ) + cPipe + cSaida + cPipe + cfim
Comunica_Com_Impressora( nPorta, cBuffer, Retorno )
FClose( nPorta )
Return

Proc LeituraZ_Zanthus()
***********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Space(134)

nPorta := Fopen("ECF$ZANT", FO_READWRITE )
if ferror () != 0
	Alert("Zanthus : Problemas de comunicacao.")
	Return
EndIF

Mensagem("Aguarde, Emitindo Leitura Z")
FWrite( nPorta, "~1/4/",5 )
FRead( nPorta, @cBuffer, 134 )
Response_Zanthus( nPorta, cBuffer )
// Espacejamento
cBuffer := "~2/U/$08$"
FWrite( nPorta, @cBuffer, Len( cBuffer ))
FClose( nPorta )
ResTela( cScreen )
Return

Proc Z_Daruma()
***************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer  := '1100';

nPorta := DarumaIniciaDriver(cBuffer)
Mensagem("Aguarde, Emitindo Leitura X")
FWrite( nPorta, cBuffer, Len(cBuffer))
FClose( nPorta )
ResTela( cScreen )
Return

Proc X_Daruma()
***************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer  := '1101';

nPorta := DarumaIniciaDriver(cBuffer)
Mensagem("Aguarde, Emitindo Leitura Z")
FWrite( nPorta, cBuffer, Len(cBuffer))
FClose( nPorta )
ResTela( cScreen )
Return

Proc LeituraZ_Sigtron()
***********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Chr(27) + Chr(208)

nPorta := Fopen("SIGFIS", FO_READWRITE )
if ferror () != 0
	Alert("Sigtron : Problemas de comunicacao.")
	Return
EndIF

Mensagem("Aguarde, Emitindo Leitura Z")
FWrite( nPorta, cBuffer, 2 )
FClose( nPorta )
ResTela( cScreen )
Return

Proc ReGerenc_Sigtron()
***********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Chr(27) + Chr(211)

nPorta := Fopen("SIGFIS", FO_READWRITE )
if ferror () != 0
	Alert("Sigtron : Problemas de comunicacao.")
	Return
EndIF

Mensagem("Aguarde, Emitindo Relatorio Gerencial.")
FWrite( nPorta, @cBuffer, Len( cBuffer ))
FClose( nPorta )
ResTela( cScreen )
Return

Proc LeituraX_Sigtron()
***********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Space(134)
LOCAL Esc207	:= Chr(27) + Chr(207)

nPorta := Fopen("SIGFIS", FO_READWRITE )
if ferror () != 0
	Alert("SigTron : Problemas de comunicacao.")
	Return
EndIF

Mensagem("Aguarde, Emitindo Leitura X")
FWrite( nPorta, Esc207, 2 )
FClose( nPorta )
ResTela( cScreen )
Return

Proc LeituraX_Zanthus()
***********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Space(134)

nPorta := Fopen("ECF$ZANT", FO_READWRITE )
if ferror () != 0
	Alert("Zanthus : Problemas de comunicacao.")
	Return
EndIF

Mensagem("Aguarde, Emitindo Leitura X")
FWrite( nPorta, "~1/3/",5 )
FRead( nPorta, @cBuffer, 134 )
Response_Zanthus( nPorta, cBuffer )
// Espacejamento
cBuffer := "~2/U/$08$"
FWrite( nPorta, @cBuffer, Len( cBuffer ))
FClose( nPorta )
ResTela( cScreen )
Return

Proc DiaInicio_Zanthus()
************************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Space(134)

nPorta := Fopen("ECF$ZANT", FO_READWRITE )
if ferror () != 0
	Alert("Zanthus : Problemas de comunicacao.")
	Return
EndIF
Mensagem("Aguarde, Iniciando Dia Fiscal")
FWrite( nPorta, "~1/1/")
FRead( nPorta, @cBuffer, 134 )
// Espacejamento
cBuffer := "~2/U/$08$"
FWrite( nPorta, @cBuffer, Len( cBuffer ))
IF Response_Zanthus( nPorta, cBuffer )
	Alerta("OK")
EndIF
FClose( nPorta )
ResTela( cScreen )
Return

Proc DiaLivre_Zanthus()
************************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Space(134)

nPorta := Fopen("ECF$ZANT", FO_READWRITE )
if ferror () != 0
	Alert("Zanthus : Problemas de comunicacao.")
	Return
EndIF

Mensagem("Aguarde, Verificando Dia Livre")
FWrite( nPorta, "~1/K/")
FRead( nPorta, @cBuffer, 134 )
IF Response_Zanthus( nPorta, cBuffer )
	Alerta("OK")
EndIF
FClose( nPorta )
ResTela( cScreen )
Return

Proc VerModulo_Zanthus()
************************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Space(134)

nPorta := Fopen("ECF$ZANT", FO_READWRITE )
if ferror () != 0
	Alert("Zanthus : Problemas de comunicacao.")
	Return
EndIF

Mensagem("Aguarde, Verificando Modulo Fiscal")
FWrite( nPorta, "~1/5/")
FRead( nPorta, @cBuffer, 134 )
IF Response_Zanthus( nPorta, cBuffer )
	Alerta("OK")
EndIF
FClose( nPorta )
ResTela( cScreen )
Return

Proc MeFisDat_Zanthus()
***********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Space(134)
LOCAL dIni		:= Date()
LOCAL dFim		:= Date()
LOCAL cSaida	:= "I"
LOCAL cDataIni := ""
LOCAL cDataFim := ""
LOCAL cString	:= ""

oMenu:Limpa()
MaBox( 10, 10, 13, 40 )
@ 11, 11 Say "Data Inicial..:" Get dIni Pict "##/##/##"
@ 12, 11 Say "Data Final....:" Get dFim Pict "##/##/##"
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
cDataIni := StrTran( Dtoc( dIni ), "/")
cDataFim := StrTran( Dtoc( dFim ), "/")

nPorta := Fopen("ECF$ZANT", FO_READWRITE )
if ferror () != 0
	Alert("Zanthus : Problemas de comunicacao.")
	Return
EndIF
Mensagem("Aguarde, Emitindo Relatorio Fiscal")
cString := "~2/G/$" + cDataIni + cDataFim + "$"
FWrite( nPorta, cString)
FRead( nPorta, @cBuffer, 134 )
Response_Zanthus( nPorta, cBuffer )
FClose( nPorta )
ResTela( cScreen )
Return

Proc MeFisDat_SigTron()
***********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL cBuffer	:= Space(134)
LOCAL dIni		:= Date()
LOCAL dFim		:= Date()
LOCAL cSaida	:= "I"
LOCAL cDataIni := ""
LOCAL cDataFim := ""
LOCAL cString	:= ""

oMenu:Limpa()
MaBox( 10, 10, 13, 40 )
@ 11, 11 Say "Data Inicial..:" Get dIni Pict "##/##/##"
@ 12, 11 Say "Data Final....:" Get dFim Pict "##/##/##"
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
cDataIni := StrTran( Dtoc( dIni ), "/")
cDataFim := StrTran( Dtoc( dFim ), "/")

nPorta := Fopen("SIGFIS", FO_READWRITE )
if ferror () != 0
	Alert("SigTron : Problemas de comunicacao.")
	Return
EndIF
Mensagem("Aguarde, Emitindo Relatorio Fiscal")
cString := Chr(27) + Chr(209) + 'x' + cDataIni + cDataFim
FWrite( nPorta, @cString, Len( cString ))
FClose( nPorta )
ResTela( cScreen )
Return

Proc MeFisInt_Zanthus()
***********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL nIni		:= 0
LOCAL nFim		:= 0
LOCAL cBuffer	:= Space(134)
LOCAL cString	:= ""

oMenu:Limpa()
MaBox( 10, 10, 13, 40 )
@ 11, 11 Say "Reducao Inicial.:" Get nIni Pict "9999"
@ 12, 11 Say "Reducao Final...:" Get nFim Pict "9999"
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
cIni := StrZero( nIni, 4 )
cFim := StrZero( nFim, 4 )

nPorta := Fopen("ECF$ZANT", FO_READWRITE )
if ferror () != 0
	Alert("Zanthus : Problemas de comunicacao.")
	Return
EndIF
Mensagem("Aguarde, Emitindo Relatorio Fiscal")
cString := "~2/G/$" + cIni + cFim + "$"
//cString := "~1/G/$" + cIni + cFim + " $"
FWrite( nPorta, cString)
FRead( nPorta, @cBuffer, 134 )
Response_Zanthus( nPorta, cBuffer )
FClose( nPorta )
ResTela( cScreen )
Return

Proc MeFisInt_SigTron()
***********************
LOCAL cScreen	:= SaveScreen()
LOCAL nPorta	:= 0
LOCAL nIni		:= 0
LOCAL nFim		:= 0
LOCAL cBuffer	:= Space(134)
LOCAL cString	:= ""

oMenu:Limpa()
MaBox( 10, 10, 13, 40 )
@ 11, 11 Say "Reducao Inicial.:" Get nIni Pict "999999"
@ 12, 11 Say "Reducao Final...:" Get nFim Pict "999999"
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
cIni := StrZero( nIni, 6 )
cFim := StrZero( nFim, 6 )

nPorta := Fopen("SIGFIS", FO_READWRITE )
if ferror () != 0
	Alert("SigTron : Problemas de comunicacao.")
	Return
EndIF
Mensagem("Aguarde, Emitindo Relatorio Fiscal")
cString := Chr(27) + Chr(29) + 'x' + cIni + cFim
FWrite( nPorta, @cString, Len(cString ))
FClose( nPorta )
ResTela( cScreen )
Return

Function TiraString( cBuffer )
******************************
Return( SubStr( cBuffer, 4, 1))

Function Response_Zanthus( nPorta, cBuffer )
********************************************
FWrite( nPorta, "~6/", 3)       // Retorno em ASCII da ultima resposta.
FRead( nPorta, @cBuffer, 134 )
Return( Erro_Zanthus( TiraString( cBuffer )))

Function Erro_Zanthus( nRetorno )
*********************************
nIniEcf	:= oIni:ReadInteger('ecf','modelo', 1 )
IF nIniEcf = 1
	Erro_Iz11( nRetorno )
ElseIF nIniEcf = 2
	Erro_Iz20( nRetorno )
EndIF
Return

Function Erro_Iz20( nRetorno )
******************************
LOCAL aResposta := {}
LOCAL nPos		 := 0

Aadd( aResposta, { "0", "Sucesso" })
Aadd( aResposta, { "1", "Comando nao pode ser executado no presente estado do Modulo Fiscal" })
Aadd( aResposta, { "2", "Argumento de Entrada sao inconsistente"})
Aadd( aResposta, { "3", "Comando nao executado porque o valor passado e muito elevado"})
Aadd( aResposta, { "4", "Configuracao do Modulo Fiscal nao permite a execucao do comando"})
Aadd( aResposta, { "5", "Memoria Fiscal Esgotada"})
Aadd( aResposta, { "6", "Memoria Fiscal ja inicializada"})
Aadd( aResposta, { "7", "Falha ao inicializar memoria fiscal"})
Aadd( aResposta, { "8", "Memoria Fiscal ja tem numero de serie"})
Aadd( aResposta, { "9", "Memoria Fiscal nao esta inicializada"})
Aadd( aResposta, { ":", "Falha ao gravar na Memoria Fiscal"})
Aadd( aResposta, { ";", "Papel no fim"})
Aadd( aResposta, { "<", "Falha na impressora Fiscal"})
Aadd( aResposta, { "=", "Memoria do Modulo Fiscal Violada"})
Aadd( aResposta, { ">", "Falta Memoria Fiscal"})
Aadd( aResposta, { "?", "Comando Inexistente"})
Aadd( aResposta, { "@", "Deve fazer Reducao"})
Aadd( aResposta, { "A", "Memoria do Modulo Fiscal desprotegida (lacre rompido)"})
Aadd( aResposta, { "B", "Data nao permite operacao"})
Aadd( aResposta, { "C", "Fim de Tabela (de CGC/IE ou de dias)"})
Aadd( aResposta, { "D", "Dados Fixos do Modulo Fiscal estao inconsistentes"})
Aadd( aResposta, { "E", "Falha ao configurar dimensoes de cheque para impressao"})
Aadd( aResposta, { "F", "Falha ao imprimir cheque"})
Aadd( aResposta, { "O", "Indica que a mensagem foi recebida com byte de verificacao incorreto"})
Aadd( aResposta, { "P", "Indica erro nos argumentos passados"})
Aadd( aResposta, { "Q", "Indica erro no numero de controle de passagem"})
Aadd( aResposta, { "R", "Indica que a resposta recebida nao e valida"})
Aadd( aResposta, { "S", "Indica que ultrapassou o maximo de tentativas de comunicacao com a impressora"})
Aadd( aResposta, { "T", "Indica falha na transmissao de dados para a impressora"})
Aadd( aResposta, { "U", "Indica que ultrapassou tempo maximo de espera de uma resposta da impressora"})
Aadd( aResposta, { "V", "Indica que o comando enviado nao foi reconhecido pela impressora"})
Aadd( aResposta, { "W", "Indica que a impressora deve estar desligada"})
Aadd( aResposta, { "X", "Indica que a serial detectou algum erro na recepcao (overrun, framing,etc)"})
Aadd( aResposta, { "Y", "Indica que a resposta recebida esta fora do protocolo"})
Aadd( aResposta, { "Z", "Indica que o comando foi enviado, mas a resposta foi perdida"})
Aadd( aResposta, { "[", "Indica que o comando foi enviado, mas os dados de retorno foram perdidos"})
Aadd( aResposta, { "m", "Indica que o a operacao solicitada nao e permitida no dispositivo ECF controlado"})
Aadd( aResposta, { "v", "Indica que os parametros enviados ao Device Drive estao incompletos"})
Aadd( aResposta, { "w", "Indica que os parametros passados ultrapassaram o tamanho maximo permitido"})
Aadd( aResposta, { "x", "Indica que os dados solicitados ultrapassaram o tamanho maximo permitido"})
Aadd( aResposta, { "y", "Indica que o banco passado como parametro nao esta na faixa de 1 a 999"})
Aadd( aResposta, { "z", "Indica que o banco cujos dados foram solicitados nao esta cadastrado"})

nPos := Ascan2( aResposta, nRetorno, 1 )
IF nPos = 0 .OR. nPos = 1
	Return( OK )
EndIF
Alerta( aResposta[nPos, 2])
Return( FALSO )

Function Erro_Iz11( nRetorno )
******************************
LOCAL aResposta := {}
LOCAL nPos		 := 0

Aadd( aResposta, { "0", "Sucesso" })
Aadd( aResposta, { "1", "Comando nao pode ser executado no presente estado do Modulo Fiscal" })
Aadd( aResposta, { "2", "Argumento de Entrada sao inconsistente"})
Aadd( aResposta, { "3", "Comando nao executado porque o valor passado e muito elevado"})
Aadd( aResposta, { "4", "Configuracao do Modulo Fiscal nao permite a execucao do comando"})
Aadd( aResposta, { "5", "Memoria Fiscal Esgotada"})
Aadd( aResposta, { "6", "Memoria Fiscal ja inicializada"})
Aadd( aResposta, { "7", "Falha ao inicializar memoria fiscal"})
Aadd( aResposta, { "8", "Memoria Fiscal ja tem numero de fabricacao"})
Aadd( aResposta, { "9", "Memoria Fiscal nao esta inicializada"})
Aadd( aResposta, { "10", "Falha ao gravar na Memoria Fiscal"})
Aadd( aResposta, { "11", "Papel no fim"})
Aadd( aResposta, { "12", "Falha na impressora Fiscal"})
Aadd( aResposta, { "13", "Memoria do Modulo Fiscal Violada"})
Aadd( aResposta, { "14", "Falta Memoria Fiscal"})
Aadd( aResposta, { "15", "Comando Inexistente"})
Aadd( aResposta, { "16", "Deve fazer Reducao"})
Aadd( aResposta, { "17", "Memoria do Modulo Fiscal desprotegida (lacre rompido)"})
Aadd( aResposta, { "18", "Data nao permite operacao"})
Aadd( aResposta, { "19", "Fim de Tabela (de CGC/IE ou de dias)"})
Aadd( aResposta, { "20", "Dados Fixos do Modulo Fiscal estao inconsistentes"})
Aadd( aResposta, { "21", "Falha ao configurar dimensoes de cheque para impressao"})
Aadd( aResposta, { "22", "Falha ao imprimir cheque"})
Aadd( aResposta, { "23", "Falha ao alterar relogio"})
Aadd( aResposta, { "24", "Linha nao pode ser impressa"})
Aadd( aResposta, { "25", "Item ja foi cancelado"})
Aadd( aResposta, { "26", "Item nao tem descritivo armazenado"})
Aadd( aResposta, { "27", "Tempo Excedido"})
Aadd( aResposta, { "28", "Modulo Fiscal sem Forma de Pgto Cadastrado"})
Aadd( aResposta, { "29", "Versao do Modulo Fiscal difere da gaveta"})

Pos := Ascan2( aResposta, nRetorno, 1 )
IF nPos = 0 .OR. nPos = 1
	Return( OK )
EndIF
Alerta( aResposta[nPos, 2])
Return( FALSO )

Proc FiscalRegedit()
********************
LOCAL cScreen	:= SaveScreen()
LOCAL aFiscal	:= {}
LOCAL oFiscal	:= AbreIniFiscal()

Mensagem("Aguarde, Verificando Direitos do Usuario.")
Aadd( aFiscal, { 2.01, oFiscal:ReadBool( 'impressorasfiscais', '#2.01', OK )})
Aadd( aFiscal, { 2.02, oFiscal:ReadBool( 'impressorasfiscais', '#2.02', OK )})
Aadd( aFiscal, { 2.03, oFiscal:ReadBool( 'impressorasfiscais', '#2.03', OK )})
Aadd( aFiscal, { 2.04, oFiscal:ReadBool( 'impressorasfiscais', '#2.04', OK )})
Aadd( aFiscal, { 2.05, oFiscal:ReadBool( 'impressorasfiscais', '#2.05', OK )})
Aadd( aFiscal, { 2.06, oFiscal:ReadBool( 'impressorasfiscais', '#2.06', OK )})
Aadd( aFiscal, { 2.07, oFiscal:ReadBool( 'impressorasfiscais', '#2.07', OK )})
Aadd( aFiscal, { 2.08, oFiscal:ReadBool( 'impressorasfiscais', '#2.08', OK )})
Aadd( aFiscal, { 2.09, oFiscal:ReadBool( 'impressorasfiscais', '#2.09', OK )})
Aadd( aFiscal, { 2.10, oFiscal:ReadBool( 'impressorasfiscais', '#2.10', OK )})
Aadd( aFiscal, { 2.11, oFiscal:ReadBool( 'impressorasfiscais', '#2.11', OK )})
ResTela( cScreen )
Return( aFiscal )

Function AbreIniFiscal()
*************************
Return( oFiscal := TIniNew( oAmbiente:xBaseDados + "\" + oAmbiente:xUsuario + ".INI"))

Function SnFiscal( nChoice )
*****************************
LOCAL nPos := 0

nPos := Ascan2( oAmbiente:aFiscalIni, nChoice, 1 )
IF nPos = 0
	Return( FALSO )
EndIF
Return( oAmbiente:aFiscalIni[nPos, 2])

Proc Reindexar()
****************
LOCAL cScreen := SaveScreen()
LOCAL GetList := {}
LOCAL aMenu   := {"Limpar Marcacao de Arquivos", "Marcar Arquivos para reindexar"}
LOCAL nChoice := 0

WHILE OK
	oMenu:Limpa()
	M_Title("ESCOLHA SUA OPCAO")
	nChoice := FazMenu( 05, 10, aMenu )
	Do Case
	Case nChoice = 0
		ResTela( cScreen )
		Return
	Case nChoice = 1
		LimparMarcacao()
	Case nChoice = 2
		ReindParcial()
	EndCase
EndDo

Proc LimparMarcacao()
*********************
LOCAL cScreen		:= SaveScreen()
LOCAL aArquivos	:= ArrayArquivos()
LOCAL nTam			:= Len( aArquivos )
LOCAL nNx			:= 0

Mensagem("Aguarde, Limpando marcacao de Arquivos")
For nX := 1 To nTAm
	oIni:WriteString('indices', aArquivos[nX,1], '1' )
Next
Alerta("Informa: Limpeza efetudada com sucesso.")
ResTela( cScreen )
Return

Proc ReindParcial()
*******************
LOCAL cScreen		:= SaveScreen()
LOCAL aMenu 		:= {}
LOCAL aTemp 		:= {}
LOCAL aDisponivel := {}
LOCAL aEscolhido	:= {}
LOCAL aArquivos	:= ArrayArquivos()
LOCAL nTam			:= 0
LOCAL nNx			:= 0
LOCAL nPosicao 	:= 1
LOCAL nQuant		:= 0
LOCAL cBuffer		:= ''
LOCAL cUser 		:= ''
LOCAL cData 		:= ''
LOCAL cFim			:= ''

WHILE OK
	aEscolhido := {}
	nQuant	  := 0
	aTemp 	  := {}
	nTam		  := Len( aArquivos )
	WHILE OK
		aMenu 		:= {}
		aDisponivel := {}
		For nX := 1 To nTAm
			lOk	:= oIni:ReadString('indices', aArquivos[nX,1], '1', 1 )
			cUser := oIni:ReadString('indices', aArquivos[nX,1], space(10), 2 )
			cData := oIni:ReadString('indices', aArquivos[nX,1], Space(08), 3 )
			cTime := oIni:ReadString('indices', aArquivos[nX,1], Space(08), 4 )
			cFim	:= oIni:ReadString('indices', aArquivos[nX,1], Space(08), 5 )
			Aadd( aDisponivel, IF( lOk == '1', OK, FALSO ))
			Aadd( aMenu, aArquivos[nX,1] + Space(14-Len(AllTrim(aArquivos[nX,1]))) + '³' + AllTrim( cUser ) + Space(10-Len(AllTrim(cUser))) + '³' + cData + '³' + cTime  + '³' + cFim )
			Aadd( aTemp, aArquivos[nX,1])
		Next
		oMenu:Limpa()
		MaBox( 02, 09, 21, 66, 'ARQUIVO        USUARIO    DATA     INICIO   FIM     ' )
		nChoice := Achoice( 03, 10, 20, 65, aMenu, aDisponivel, nPosicao )
		IF nChoice = 0
			Exit
		EndIF
		lOk	:= oIni:ReadString('indices', aArquivos[nChoice,1], '1', 1 )
		cUser := oIni:ReadString('indices', aArquivos[nChoice,1], space(10), 2 )
		IF lOk = '0'
			Alerta('Erro: Marcado Por :' + cUser )
			Loop
		EndIF
		cBuffer := '0'
		cBuffer += ';'
		cBuffer += oAmbiente:xUsuario
		cBuffer += ';'
		cBuffer += Dtoc( Date())
		cBuffer += ';'
		cBuffer += 'MARCADO '
		oIni:WriteString('indices', aArquivos[nChoice,1], cBuffer )
		Aadd( aEscolhido, AllTrim(StrTran( aTemp[nChoice],'.DBF')))
		nQuant++
		aMenu[nChoice] 		 += " û "
		aDisponivel[nChoice]  := FALSO
		nPosicao 				 := nChoice + 1
	EndDo
	oMenu:Limpa()
	IF nQuant > 0
		nTam := Len( aEscolhido )
		IF Conf('Pergunta: Reindexar arquivos marcados ?')
			FechaTudo()
			For nX := 1 To nTam
				IF !NetUse( aEscolhido[nX], MONO ) ; ResTela( cScreen ); Return(FALSO) ; EndIF
				cTime := Time()
				oIni:WriteString('indices', aEscolhido[nX] + '.DBF', cBuffer )
				CriaIndice( aEscolhido[nX] )
				cBuffer	:= '0'
				cBuffer += ';'
				cBuffer += oAmbiente:xUsuario
				cBuffer += ';'
				cBuffer += Dtoc( Date())
				cBuffer += ';'
				cBuffer += cTime
				cBuffer += ';'
				cBuffer += Time()
				oIni:WriteString('indices', aEscolhido[nX] + '.DBF', cBuffer )
			Next
		Else
			For nX := 1 To nTam
				oIni:WriteString('indices', aEscolhido[nX] + '.DBF', '1' )
			Next
		EndIF
	Else
		Exit
	EndiF
EndDo
ResTela( cScreen )
Return

Proc Aliquota_Sigtron()
***********************
LOCAL cScreen	 := SaveScreen()
LOCAL GetList	 := {}
LOCAL cAliquota := Space(04)
LOCAL nTipo 	 := 0
LOCAL nPorta	 := 0
LOCAL cBuffer	 := ''
LOCAL cRetorno  := ''

oMenu:Limpa()
cAliquota := Space(04)
MaBox( 10, 10, 13, 40 )
@ 11, 11 Say "Aliquota..." Get cAliquota Pict "9999" Valid IF( Empty( cAliquota ), ( ErrorBeep(), Alerta("Erro: Entrada Invalida"), FALSO ), OK )
@ 12, 11 Say "Tipo......." Get nTipo     Pict "9"    Valid PickTam({"Icms", "Iss"}, {1,2}, @nTipo )
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
ErrorBeep()
IF Conf("Pergunta: Registrar Aliquota ?")
	nPorta  := SigtronIniciaDriver(cBuffer)
	cBuffer := Chr(27) + Chr(220)
	IF nTipo = 2
	  cBuffer += 'S'
	EndIF
	cBuffer += cAliquota
	FWrite( nPorta, @cBuffer, Len( cBuffer ))
	FClose( nPorta )
EndIF
Restela( cScreen )
Return

Proc Aliquota_Bema()
********************
LOCAL cScreen	 := SaveScreen()
LOCAL GetList	 := {}
LOCAL cAliquota := Space(04)
LOCAL nTipo 	 := 0
LOCAL nPorta	 := 0
LOCAL cBuffer	 := ''
LOCAL cIcms 	 := '0'
LOCAL cIss		 := '1'
LOCAL lEcfRede  := oIni:ReadBool('ecf','ecfrede', FALSO )
LOCAL Retorno

oMenu:Limpa()
cAliquota := Space(04)
MaBox( 10, 10, 13, 40 )
@ 11, 11 Say "Aliquota..." Get cAliquota Pict "9999" Valid !Empty( cAliquota ) //Bema_VerAliquota( cAliquota )
@ 12, 11 Say "Tipo......." Get nTipo     Pict "9"    Valid PickTam({"Icms", "Iss"}, {1,2}, @nTipo )
Read
IF LastKey() = ESC
	ResTela( cScreen )
	Return
EndIF
ErrorBeep()
IF Conf("Pergunta: Registrar Aliquota ?")
	nPorta := BemaIniciaDriver()
	IF Ferror () != 0
		Alerta("Bematech : Problemas de comunicacao.")
		Restela( cScreen )
		Return
	EndIF
   IF lEcfRede
      cBuffer    := '063|' + cAliquota + '|' + IF( nTipo = 1, '0', '1' ) + '|'
   Else
      cBuffer    := Chr(27) + Chr(251) + "07|" + cAliquota + IF( nTipo = 1, cIcms, cIss ) + '|' + Chr(27)
   EndIF
	Fwrite( nPorta, @cBuffer, Len( cBuffer ))
   Comunica_Com_Impressora( nPorta, cBuffer, Retorno )
	FClose( nPorta )
EndIF
Restela( cScreen )
Return

Function Bema_VerAliquota( cAliquota )
**************************************
	LOCAL aAliquota := {}
	LOCAL cBuffer	 := Chr(27) + Chr(251) + "26" + '|' + Chr(27)
	LOCAL cRetorno  := ''
	LOCAL cString	 := ''
	LOCAL nX 		 := 0
	LOCAL nPos		 := 0
	LOCAL nPorta	 := 0

	nPorta := BemaIniciaDriver()
	IF Ferror () != 0
		Alerta("BEMATECH: Problemas de comunicacao.")
		ResTela( cScreen )
		Return( FALSO )
	EndIF

	cRetorno := Comunica_Com_Impressora( nPorta, cBuffer, 66 )
	FClose( nPorta )
	For nX := 1 To 16
		 cString := SubStr( cRetorno,((nX*4)-3)+2,4)
		 Aadd( aAliquota, cString )
	Next
	nPos := Ascan( aAliquota, cAliquota )
	IF nPos <> 0
		ErrorBeep()
		IF Conf("Erro : Aliquota ja registrada. Posicao # " + StrZero(nPos, 2) + '. Continuar ?')
			Return( OK )
		Else
			Return( FALSO )
		EndIF
	EndIF
Return( OK )

Function LigaDisp()
*******************
	LOCAL aDisp := {}
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
	Aadd( aDisp,{ LIG,  LIG,  LIG,  LIG,  LIG ,	LIG,	LIG,	LIG,	LIG,	LIG, LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG,  LIG, LIG, LIG,	LIG,	LIG })
Return( aDisp )

Proc ConfIniReceber( cNome )
****************************
LOCAL cScreen	:= SaveScreen()
LOCAL GetList	:= {}
LOCAL oRecelan := TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
LOCAL oConf 	:= TAmbienteNew()
LOCAL aDisp 	:= aDispRecelan()
LOCAL nMaior	:= 1
LOCAL nMenor	:= 1
LOCAL cMaior	:= ''
LOCAL cMenor	:= ''
LOCAL cRegra	:= ''
LOCAL op 		:= 1

oConf:Disp		 := aDisp
oConf:Ativo 	 := 1
oConf:Menu		 := oMenuRecelan()
oConf:NomeFirma := oMenu:NomeFirma
oConf:CodiFirma := oMenu:CodiFirma
oConf:StatusSup := SISTEM_NA3 + " " + SISTEM_VERSAO
oConf:StatusInf := "USE A BARRA DE ESPACO PARA DESABILITAR OPCAO"
oConf:Alterando := OK
WHILE OK
	Op := oConf:Show()
	Do Case
	Case Op = 0.0 .OR. Op = 1.01
		ErrorBeep()
		IF Conf("Pergunta: Gravar Alteracoes ?")
			For i := 1 To 7
				For x := 1 To 22
               cMaior  := Strzero(i, 2)
               cMenor  := Strzero(x, 2)
					cRegra  := '#' + cMaior + '.' + cMenor
					oRecelan:WriteBool('recelan', cRegra, aDisp[i, x])
				Next
			Next
		EndIF
		Return
	OtherWise
		nMenor := Val(Right(Tran( Op, '99.99'),2))
		nMaior := Int( Op )
		aDisp[nMaior,nMenor] := If( aDisp[nMaior][nMenor] = OK, FALSO, OK )
	EndCase
EndDo

Proc ConfIniPagar( cNome )
**************************
LOCAL cScreen	:= SaveScreen()
LOCAL GetList	:= {}
LOCAL oPagalan := TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
LOCAL oConf 	:= TAmbienteNew()
LOCAL aDisp 	:= aDispPagaLan()
LOCAL nMaior	:= 1
LOCAL nMenor	:= 1
LOCAL cMaior	:= ''
LOCAL cMenor	:= ''
LOCAL cRegra	:= ''
LOCAL op 		:= 1

oConf:Disp		 := aDisp
oConf:Ativo 	 := 1
oConf:Menu		 := oMenuPagalan()
oConf:NomeFirma := oMenu:NomeFirma
oConf:CodiFirma := oMenu:CodiFirma
oConf:StatusSup := SISTEM_NA4 + " " + SISTEM_VERSAO
oConf:StatusInf := "USE A BARRA DE ESPACO PARA DESABILITAR OPCAO"
oConf:Alterando := OK
WHILE OK
	Op := oConf:Show()
	Do Case
	Case Op = 0.0 .OR. Op = 1.01
		ErrorBeep()
		IF Conf("Pergunta: Gravar Alteracoes ?")
			For i := 1 To 7
				For x := 1 To 22
               cMaior  := StrZero(i,2)
               cMenor  := Strzero(x,2)
					cRegra  := '#' + cMaior + '.' + cMenor
					oPagalan:WriteBool('pagalan', cRegra, aDisp[i, x])
				Next
			Next
		EndIF
		Return
	OtherWise
		nMenor := Val(Right(Tran( Op, '99.99'),2))
		nMaior := Int( Op )
		aDisp[nMaior,nMenor] := If( aDisp[nMaior][nMenor] = OK, FALSO, OK )
	EndCase
EndDo

Proc ConfIniCorrentes( cNome )
******************************
LOCAL cScreen	:= SaveScreen()
LOCAL GetList	:= {}
LOCAL oPagalan := TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
LOCAL oConf 	:= TAmbienteNew()
LOCAL aDisp 	:= aDispChelan()
LOCAL nMaior	:= 1
LOCAL nMenor	:= 1
LOCAL cMaior	:= ''
LOCAL cMenor	:= ''
LOCAL cRegra	:= ''
LOCAL op 		:= 1

oConf:Disp		 := aDisp
oConf:Ativo 	 := 1
oConf:Menu		 := oMenuChelan()
oConf:NomeFirma := oMenu:NomeFirma
oConf:CodiFirma := oMenu:CodiFirma
oConf:StatusSup := SISTEM_NA5 + " " + SISTEM_VERSAO
oConf:StatusInf := "USE A BARRA DE ESPACO PARA DESABILITAR OPCAO"
oConf:Alterando := OK
WHILE OK
	Op := oConf:Show()
	Do Case
	Case Op = 0.0 .OR. Op = 1.01
		ErrorBeep()
		IF Conf("Pergunta: Gravar Alteracoes ?")
			For i := 1 To 8
				For x := 1 To 22
               cMaior  := Strzero(i,2)
               cMenor  := Strzero(x,2)
					cRegra  := '#' + cMaior + '.' + cMenor
					oPagalan:WriteBool('chelan', cRegra, aDisp[i, x])
				Next
			Next
		EndIF
		Return
	OtherWise
		nMenor := Val(Right(Tran( Op, '99.99'),2))
		nMaior := Int( Op )
		aDisp[nMaior,nMenor] := If( aDisp[nMaior][nMenor] = OK, FALSO, OK )
	EndCase
EndDo

Proc ConfIniProducao( cNome )
*****************************
LOCAL cScreen	:= SaveScreen()
LOCAL GetList	:= {}
LOCAL oScpLan	:= TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
LOCAL oConf 	:= TAmbienteNew()
LOCAL aDisp 	:= aDispScpLan()
LOCAL nMaior	:= 1
LOCAL nMenor	:= 1
LOCAL cMaior	:= ''
LOCAL cMenor	:= ''
LOCAL cRegra	:= ''
LOCAL op 		:= 1

oConf:Disp		 := aDisp
oConf:Ativo 	 := 1
oConf:Menu		 := oMenuScpLan()
oConf:NomeFirma := oMenu:NomeFirma
oConf:CodiFirma := oMenu:CodiFirma
oConf:StatusSup := SISTEM_NA7 + " " + SISTEM_VERSAO
oConf:StatusInf := "USE A BARRA DE ESPACO PARA DESABILITAR OPCAO"
oConf:Alterando := OK
WHILE OK
	Op := oConf:Show()
	Do Case
	Case Op = 0.0 .OR. Op = 1.01
		ErrorBeep()
		IF Conf("Pergunta: Gravar Alteracoes ?")
			For i := 1 To 9
				For x := 1 To 22
               cMaior  := Strzero(i,2)
               cMenor  := Strzero(x,2)
					cRegra  := '#' + cMaior + '.' + cMenor
					oScpLan:WriteBool('scplan', cRegra, aDisp[i, x])
				Next
			Next
		EndIF
		Return
	OtherWise
		nMenor := Val(Right(Tran( Op, '99.99'),2))
		nMaior := Int( Op )
		aDisp[nMaior,nMenor] := If( aDisp[nMaior][nMenor] = OK, FALSO, OK )
	EndCase
EndDo

Proc ConfIniEstoque( cNome )
****************************
LOCAL cScreen	 := SaveScreen()
LOCAL GetList	 := {}
LOCAL oTestelan := TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
LOCAL oConf 	 := TAmbienteNew()
LOCAL aDisp 	 := aDispTestelan()
LOCAL nMaior	 := 1
LOCAL nMenor	 := 1
LOCAL cMaior	 := ''
LOCAL cMenor	 := ''
LOCAL cRegra	 := ''
LOCAL op 		 := 1

oConf:Disp		 := aDisp
oConf:Ativo 	 := 1
oConf:Menu		 := oMenuTestelan()
oConf:NomeFirma := oMenu:NomeFirma
oConf:CodiFirma := oMenu:CodiFirma
oConf:StatusSup := SISTEM_NA2 + " " + SISTEM_VERSAO
oConf:StatusInf := "USE A BARRA DE ESPACO PARA DESABILITAR OPCAO"
oConf:Alterando := OK
WHILE OK
	Op := oConf:Show()
	Do Case
	Case Op = 0.0 .OR. Op = 1.01
		ErrorBeep()
		IF Conf("Pergunta: Gravar Alteracoes ?")
			For i := 1 To 8
				For x := 1 To 22
               cMaior  := StrZero(i,2)
               cMenor  := Strzero(x,2)
					cRegra  := '#' + cMaior + '.' + cMenor
					oTestelan:WriteBool( 'testelan', cRegra, aDisp[i, x])
				Next
			Next
		EndIF
		Return
	OtherWise
		nMenor := Val(Right(Tran( Op, '99.99'),2))
		nMaior := Int( Op )
		aDisp[nMaior,nMenor] := If( aDisp[nMaior][nMenor] = OK, FALSO, OK )
	EndCase
EndDo

Proc ConfIniSci( cNome )
************************
LOCAL cScreen	 := SaveScreen()
LOCAL GetList	 := {}
LOCAL oConf 	 := TAmbienteNew() // TMenuNew()
LOCAL aDisp 	 := aDispSci()
LOCAL nMaior	 := 1
LOCAL nMenor	 := 1
LOCAL cMaior	 := ''
LOCAL cMenor	 := ''
LOCAL cRegra	 := ''
LOCAL op 		 := 1

oSci				 := TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
oConf:Disp		 := aDisp
oConf:Ativo 	 := 1
oConf:Menu		 := oSciMenuSci()
oConf:NomeFirma := oMenu:NomeFirma
oConf:CodiFirma := oMenu:CodiFirma
oConf:StatusSup := SISTEM_NA1 + " " + SISTEM_VERSAO
oConf:StatusInf := "USE A BARRA DE ESPACO PARA DESABILITAR OPCAO"
oConf:Alterando := OK
WHILE OK
	Op := oConf:Show()
	Do Case
	Case Op = 0.0 .OR. Op = 1.01
		ErrorBeep()
		IF Conf("Pergunta: Gravar Alteracoes ?")
			For i := 1 To 10
				For x := 1 To 22
               cMaior  := Strzero(i,2)
               cMenor  := Strzero(x,2)
					cRegra  := '#' + cMaior + '.' + cMenor
					oSci:WriteBool( 'sci', cRegra, aDisp[i, x])
				Next
			Next
		EndIF
		Return
	OtherWise
		nMenor := Val(Right(Tran( Op, '99.99'),2))
		nMaior := Int( Op )
		aDisp[nMaior,nMenor] := If( aDisp[nMaior][nMenor] = OK, FALSO, OK )
	EndCase
EndDo

Function oSciMenuSci()
**********************
LOCAL AtPrompt := {}
LOCAL cStr_Get
LOCAL cStr_Sombra

IF oAmbiente:Get_Ativo
	cStr_Get := "Desativar Get Tela Cheia"
Else
	cStr_Get := "Ativar Get Tela Cheia"
EndIF
IF oMenu:Sombra
	cStr_Sombra := "DesLigar Sombra"
Else
	cStr_Sombra := "Ligar Sombra"
EndIF
AADD( AtPrompt, {"E^ncerrar",    {"E^ncerrar Execucao do SCI","","T^rocar de Empresa","Trocar de U^suario","","C^opia de Seguranca","R^estaurar Copia de Seguranca"}})
AADD( AtPrompt, {"M^odulos",     {"Controle de E^stoque","Contas a R^eceber","Contas a P^agar","Contas C^orrentes","Controle de P^roducao","Controle de P^onto","Mala D^ireta","V^endedores"}})
AADD( AtPrompt, {"V^endas",      {"Terminal PDV","Terminal Consulta de Precos","Relatorio Vendas *","Relatorio Receber *","Relatorio Recebido *","Cadastra Senha Caixa","","Resumo Caixa Individual", "Detalhe Caixa Individual","Detalhe Diario Caixa Geral *","Detalhe Emissao Recibos em Carteira","Detalhe Emissao Recibos Banco", "Detalhe Emissao Recibos Outros","","Rol Debito C/C Cliente","Reajuste Debito C/C Cliente","Consulta Debito C/C","Baixar Debito C/C","","Comandos de Impressora Fiscal"}})
AADD( AtPrompt, {"B^ackup",      {"Copia de Seguranca","Restaurar Copia de Seguranca","Gerar Arquivo Batch de Copia Seguranca","", "Reindexar Normal", "Reindexar Verificando Duplicidade","Reindexar Parcialmente", "Eliminar Arquivos Temporarios"}})
AADD( AtPrompt, {"E^ditor",      {"Editar Arquivo","Imprimir Arquivo"}})
AADD( AtPrompt, {"A^mbiente",    {"Spooler de Impressao","Layout Janela","", "Cor Pano de Fundo","Cor de Menu","Cor Cabecalho","Cor Alerta","Cor Borda","Cor Item Desativado","Cor Box Mensagem", "Cor Light Bar", "Cor HotKey", "Cor LightBar HotKey","", "Pano de Fundo","Frame", cStr_Sombra, cStr_Get, "Alterar Senha"}})

AADD( AtPrompt, {"ArQ^uivos",    {"Manutencao Diretorios","Arquivos da Base de Dados","","Reindexar Normal","Reindexar Verificando Duplicidade","","Eliminar Arquivos Temporarios","Cadastra e Altera Usuario","Configuracao de Base Dados","Retorno Acesso","Separar Movimento Anual","Caixa Automatico","Zerar Movimento de Conta","Cadastrar Impressora","Alterar Impressora", "Renovar Codigo de Acesso"}})
AADD( AtPrompt, {"R^econstruir ", {"Base de Dados", "Arquivo Nota", "Arquivo Printer", "Arquivo EntNota","Arquivo Prevenda"}})
AADD( AtPrompt, {"S^hell",       {"Shell         ALT D","Comandos DOS  ALT X"}})
AADD( AtPrompt, {"H^elp",        {"Sobre o Sistema","Ultimas Alteracoes","Help"}})
Return( AtPrompt )


Proc ConfIniVendedores( cNome )
*******************************
LOCAL cScreen	:= SaveScreen()
LOCAL GetList	:= {}
LOCAL oVenlan	:= TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
LOCAL oConf 	:= TAmbienteNew()
LOCAL aDisp 	:= aDispVenLan()
LOCAL nMaior	:= 1
LOCAL nMenor	:= 1
LOCAL cMaior	:= ''
LOCAL cMenor	:= ''
LOCAL cRegra	:= ''
LOCAL op 		:= 1

oConf:Disp		 := aDisp
oConf:Ativo 	 := 1
oConf:Menu		 := oMenuVenlan()
oConf:NomeFirma := oMenu:NomeFirma
oConf:CodiFirma := oMenu:CodiFirma
oConf:StatusSup := SISTEM_NA6 + " " + SISTEM_VERSAO
oConf:StatusInf := "USE A BARRA DE ESPACO PARA DESABILITAR OPCAO"
WHILE OK
	Op := oConf:Show()
	Do Case
	Case Op = 0.0 .OR. Op = 1.01
		ErrorBeep()
		IF Conf("Pergunta: Gravar Alteracoes ?")
			For i := 1 To 7
				For x := 1 To 22
               cMaior  := Strzero(i,2)
               cMenor  := Strzero(x,2)
					cRegra  := '#' + cMaior + '.' + cMenor
					oVenlan:WriteBool( 'venlan', cRegra, aDisp[i, x])
				Next
			Next
		EndIF
		Return
	OtherWise
		nMenor := Val(Right(Tran( Op, '99.99'),2))
		nMaior := Int( Op )
		aDisp[nMaior,nMenor] := If( aDisp[nMaior][nMenor] = OK, FALSO, OK )
	EndCase
EndDo

Proc ConfImpressao()
********************
LOCAL cScreen		:= SaveScreen()
LOCAL GetList		:= {}
LOCAL cPath 		:= FCurdir()
LOCAL cPro
LOCAL cDup
LOCAL cCob
LOCAL cDiv
LOCAL cNff

Set Defa To ( oAmbiente:xBase )
WHILE OK
	oMenu:Limpa()
	cPro := oIni:ReadString('impressao','pro', 'NOTA.PRO')    ; cPro += Space(38 - Len(cPro))
	cDup := oIni:ReadString('impressao','dup', 'DUP.DUP')     ; cDup += Space(38 - Len(cDup))
	cCob := oIni:ReadString('impressao','cob', 'BOLETO.COB')  ; cCob += Space(38 - Len(cCob))
	cDiv := oIni:ReadString('impressao','div', 'DIVERSO.DIV') ; cDiv += Space(38 - Len(cDiv))
	cNff := oIni:ReadString('impressao','nff', 'NOTA.NFF')    ; cNff += Space(38 - Len(cNff))

	oMenu:MaBox( 01, 01, 07, 78, "CONFIGURACAO - ARQUIVOS DE IMPRESSAO")
	@ 02, 	  02 Say "Arquivo Padrao Nota Promissoria....: " Get cPro Pict "@!" Valid PickArquivo( @cPro, '*.PRO' )
	@ Row()+1, 02 Say "Arquivo Padrao Duplicata Mercantil.: " Get cDup Pict "@!" Valid PickArquivo( @cDup, '*.DUP' )
	@ Row()+1, 02 Say "Arquivo Padrao Boleto Bancario.....: " Get cCob Pict "@!" Valid PickArquivo( @cCob, '*.COB' )
	@ Row()+1, 02 Say "Arquivo Padrao Documentos Diversos.: " Get cDiv Pict "@!" Valid PickArquivo( @cDiv, '*.DIV' )
	@ Row()+1, 02 Say "Arquivo Padrao Nota Fiscal.........: " Get cNff Pict "@!" Valid PickArquivo( @cNff, '*.NFF' )
	Read
	IF LastKey() = ESC
		Set Defa To ( cPath )
		ResTela( cScreen )
		Exit
	EndIF
	ErrorBeep()
	IF Conf("Pergunta: Confirma ?")
		oIni:WriteString('impressao', 'pro', AllTrim(cPro ))
		oIni:WriteString('impressao', 'dup', AllTrim(cDup ))
		oIni:WriteString('impressao', 'cob', AllTrim(cCob ))
		oIni:WriteString('impressao', 'div', AllTrim(cDiv ))
		oIni:WriteString('impressao', 'nff', AllTrim(cNff ))
	EndIF
EndDo

Function PickArquivo( cFile, cCuringa, lNovo )
**********************************************
	LOCAL cScreen := SaveScreen()
	LOCAL aProc   := {}
	LOCAL nPos	  := 0

	Aadd( aProc, {"*.PRO",  {||GravaPromissoria()}})
	Aadd( aProc, {"*.DUP",  {||GravaDuplicata()}})
	Aadd( aProc, {"*.COB",  {||GravaBoleto()}})
	Aadd( aProc, {"*.DIV",  {||GravaDiversos()}})
	Aadd( aProc, {"*.NFF",  {||GravaNota()}})

	FChDir( oAmbiente:xBaseDoc )
	Set Defa To ( oAmbiente:xBaseDoc )
	IF !File( cCuringa )
		nPos := Ascan( aProc, {| oBloco | oBloco[1] = cCuringa })
		IF nPos != 0
			Eval( aProc[ nPos, 2 ] )
		EndIF
	EndIF
	IF !File( Trim( cFile ))
		IF lNovo != NIL
			ErrorBeep()
			IF Conf('Pergunta: Arquivo digitado inexistente. Criar ?')
				FChDir( oAmbiente:xBaseDados )
				Set Defa To ( oAmbiente:xBaseDados )
				Return( OK )
			EndIF
		EndIF
		M_Title("ESCOLHA O ARQUIVO DE CONFIGURACAO")
		cFile := Mx_PopFile( 08, 01, 20, 78, cCuringa, Cor() )
	EndIF
	FChDir( oAmbiente:xBaseDados )
	Set Defa To ( oAmbiente:xBaseDados )
	ResTela( cScreen )
Return( OK )

Proc ConfIniPonto( cNome )
**************************
	LOCAL cScreen	 := SaveScreen()
	LOCAL GetList	 := {}
	LOCAL oPontoLan := TIniNew( oAmbiente:xBaseDados + "\" + cNome + ".INI")
	LOCAL oConf 	 := TAmbienteNew()
	LOCAL aDisp 	 := aDispPontoLan()
	LOCAL nMaior	 := 1
	LOCAL nMenor	 := 1
	LOCAL cMaior	 := ''
	LOCAL cMenor	 := ''
	LOCAL cRegra	 := ''
	LOCAL op 		 := 1
	LOCAL nMenuH	 := 7
	LOCAL aMenuV	 := {01,03,03,02,02,02,01}

	oConf:Ativo 	 := 1
	oConf:Menu		 := oMenuPontoLan()
	oConf:Disp		 := aDisp
	oConf:NomeFirma := oMenu:NomeFirma
	oConf:CodiFirma := oMenu:CodiFirma
	oConf:StatusSup := SISTEM_NA8 + " " + SISTEM_VERSAO
	oConf:StatusInf := "USE A BARRA DE ESPACO PARA DESABILITAR OPCAO"
	oConf:Alterando := OK
	WHILE OK
		Op := oConf:Show()
		Do Case
		Case Op = 0.0 .OR. Op = 1.01
			ErrorBeep()
			IF Conf("Pergunta: Gravar Alteracoes ?")
				For i := 1 To nMenuH
					For x := 1 To aMenuV[i]
						cMaior  := Strzero(i,2)
						cMenor  := Strzero(x,2)
						cRegra  := '#' + cMaior + '.' + cMenor
						oPontoLan:WriteBool('pontolan', cRegra, aDisp[i, x])
					Next
				Next
			EndIF
			Return
		OtherWise
			nMenor := Val(Right(Tran( Op, '99.99'),2))
			nMaior := Int( Op )
			aDisp[nMaior,nMenor] := If( aDisp[nMaior][nMenor] = OK, FALSO, OK )
		EndCase
	EndDo

Function aDispSci()
*******************
	LOCAL AtPrompt := oSciMenuSci()
	LOCAL nMenuH   := Len(AtPrompt)
	LOCAL aDisp    := Array(nMenuH, 22 )
	LOCAL aMenuV   := {}
			oSci     := TIniNew( oAmbiente:xBaseDados + "\" + oAmbiente:xUsuario + ".INI")

	Mensagem("Aguarde, Verificando Diretivas do Sistema DO MENU PRINCIPAL.")
	aDisp := ReadIni('sci', nMenuH, aMenuV, AtPrompt, aDisp, oSci)

	IF !aPermissao[SCI_CONTROLE_DE_ESTOQUE]
		aDisp[02,01] := FALSO
	EndIF

	IF !aPermissao[SCI_CONTAS_A_RECEBER]
		aDisp[02,02] := FALSO
	EndIF
	IF !aPermissao[SCI_CONTAS_A_PAGAR]
		aDisp[02,03] := FALSO
	EndIF
	IF !aPermissao[SCI_CONTAS_CORRENTES]
		aDisp[02,04] := FALSO
	EndIF
	IF !aPermissao[SCI_CONTROLE_DE_PRODUCAO]
		aDisp[02,05] := FALSO
	EndIF
	IF !aPermissao[SCI_VENDEDORES]
		aDisp[02,08] := FALSO
	EndIF
	IF !aPermissao[SCI_VENDAS_NO_VAREJO]
		aDisp[03,01] := FALSO
	EndIF
	IF !aPermissao[SCI_MANUTENCAO_DE_USUARIO]
		aDisp[07,08] := FALSO
	EndIF
	IF !oAmbiente:lGreenCard
		#IFDEF SCP
			aDisp[02,05] := OK
		#ELSE
			aDisp[02,05] := FALSO
		#ENDIF
		aDisp[01,07] := FALSO
		aDisp[04,02] := FALSO
		aDisp[04,06] := FALSO
		aDisp[07,01] := FALSO
		aDisp[07,02] := FALSO
		aDisp[07,05] := FALSO
		aDisp[08,01] := FALSO
		aDisp[09,01] := FALSO
	EndIF
Return( aDisp )

Function ReadIni( cSistema, nMenuH, aMenuV, AtPrompt, aDisp, xIni)
******************************************************************
	LOCAL cMaior
	LOCAL cMenor
	LOCAL cRegra
	LOCAL i
	LOCAL x

	For y := 1 To nMenuH
		Aadd(aMenuV, Len(AtPrompt[y][2]))
	Next

	For i := 1 To nMenuH
		For x := 1 To aMenuV[i]
			cMaior     := Strzero(i,2)
			cMenor     := Strzero(x,2)
			cRegra	  := '#' + cMaior + '.' + cMenor
			aDisp[i,x] := xIni:ReadBool(cSistema, cRegra, OK)
		Next
	Next
Return( aDisp )
