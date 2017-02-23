//#DEFINE MSDOS               OK    // Ambiente MSDOS
#DEFINE MSWINDOWS           OK    // Ambiente MSWINDOWS

#translate IfNil( <var>, <val> )        => IF( <var> = NIL, <var> := <val>, <var> )
#translate IFNIL( <var>, <val> )        => IF( <var> = NIL, <var> := <val>, <var> )
#Translate Try 				 => While
#Translate EndTry           => EndDo
#Translate LastCol			 => MaxCol
#Translate LastRow			 => MaxRow


#IFDEF MSWINDOWS
   #UNDEF MSDOS
	#Translate Beep				 => Tone
	#Translate CapFirst			 => TokenUpper
	#Translate MsRename			 => FRename
	#Translate IsFile			    => File
	#Translate Feof			    => HB_Feof
	//#Translate MsAdvance		    => FAdvance
	#Translate MsWriteLine	    => FWriteLine
	#Translate MsReadLine	    => FReadLine
	#Translate StrCount	    	 => GT_StrCount
	#Translate ChrCount	    	 => GT_StrCount
	#Translate PutKey	  	 	 	 => HB_KeyPut
	#Translate SaveVideo	  	  	 => SaveScreen
	
	//#Translate MkDir		  	  	 => FT_MkDir
	#Translate Atotal		  	  	 => FT_Asum
	#Translate FIsPrinter  	  	 => FT_IsPrint
	#Translate PrnStatus  	  	 => PrintStat
	#Translate MkDir  	 	 	 => FT_MkDir
	#Translate FChDir  	 	 	 => FT_ChDir
	#Translate Argc 	 	 	 	 => HB_Argc
	#Translate Argv 	 	 	 	 => HB_Argv
	#Translate Program 	 	 	 => HB_ProgName
	#Translate Encrypt 	 	 	 => HB_Crypt
	#Translate Decrypt			 => HB_Decrypt
	#Translate Box(				 => MS_Box(
	
	//Versao 3.2/3.4
	//#Translate WaitKey			 => HB_Inkey
	//#Translate Inkey				 => HB_Inkey
	
	//Versao 3.0
	#Translate WaitKey			 => Inkey
		
	//#Translate Roloc			    => FT_InvClr
	#Translate Standard			 => ColorStandard
	#Translate Enhanced			 => ColorEnhanced	
	#Translate Unselected   	 => ColorUnselected

	#xtranslate Single( <t>, <l>, <b>, <r> )               => hb_DispBox( <t>, <l>, <b>, <r>, B_SINGLE )
	#xtranslate Double( <t>, <l>, <b>, <r> )               => hb_DispBox( <t>, <l>, <b>, <r>, B_DOUBLE )
	#xtranslate SingleDouble( <t>, <l>, <b>, <r> )         => hb_DispBox( <t>, <l>, <b>, <r>, B_SINGLE_DOUBLE )
	#xtranslate DoubleSingle( <t>, <l>, <b>, <r> )         => hb_DispBox( <t>, <l>, <b>, <r>, B_DOUBLE_SINGLE )
	#xtranslate SingleUni( <t>, <l>, <b>, <r> )            => hb_DispBox( <t>, <l>, <b>, <r>, HB_B_SINGLE_UNI )
	#xtranslate DoubleUni( <t>, <l>, <b>, <r> )            => hb_DispBox( <t>, <l>, <b>, <r>, HB_B_DOUBLE_UNI )
	#xtranslate SingleDoubleUni( <t>, <l>, <b>, <r> )      => hb_DispBox( <t>, <l>, <b>, <r>, HB_B_SINGLE_DOUBLE_UNI )
	#xtranslate DoubleSingleUni( <t>, <l>, <b>, <r> )      => hb_DispBox( <t>, <l>, <b>, <r>, HB_B_DOUBLE_SINGLE_UNI )
	#xtranslate BkGrnd( <t>, <l>, <b>, <r>, <c> )          => hb_DispBox( <t>, <l>, <b>, <r>, Replicate( <c>, 9 ))
	
	#Translate DiskSize   	 => FT_DskSize
	//#Translate DiskFree   	 => FT_DskFree
	
	#Translate Sx_SetScope   	 => OrdScope
	#Translate Sx_ClrScope   	 => OrdScope

#ENDIF










