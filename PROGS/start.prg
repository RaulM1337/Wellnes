*** 
*** ReFox XII  #NC125846  admin  reverse [VFP90]
***
 DECLARE INTEGER CreateEvent IN win32api INTEGER, SHORT, SHORT, STRING @
 DECLARE INTEGER GetLastError IN win32api
 DECLARE CloseHandle IN win32api INTEGER
 LOCAL nume_program, neh
 nume_program = "wellness"
 neh = createevent(0, 0, 1, nume_program)
 IF getlasterror()=183 .OR. neh=0
    = closehandle(neh)
    = MESSAGEBOX("Programul "+nume_program+" ruleaza !", 64, "Info...")
    QUIT
 ENDIF
 _SCREEN.visible = .F.
 _SCREEN.width = 10
 _SCREEN.height = 10
 _SCREEN.autocenter = .T.
 DO admin_var
 IF -1=check_lic(9920)
    QUIT
 ENDIF
 ON SHUTDOWN DO EXIT 
 ON KEY LABEL ALT+x DO EXIT 
 SET REPORTBEHAVIOR 80
 SET SYSMENU OFF
 SET TALK OFF
 SET DELETED ON
 SET NEAR ON
 SET EXACT ON
 SET DATE TO dmy
 SET CENTURY ON
 SET STATUS BAR OFF
 AGETFILEVERSION(atemp, SYS(16, 1))
 _SCREEN.addproperty('app_version', atemp(11))
 _SCREEN.caption = "Wellness Access Mod RM- Ver:"+atemp(11)
 _SCREEN.icon = '2shell.ICO'
 _SCREEN.windowstate = 2
 _SCREEN.addproperty('user_level', 0)
 _SCREEN.addproperty('user_name', '')
 DO FORM splash
 READ EVENTS
 ON SHUTDOWN
 SET SYSMENU TO DEFAULT
 
**
PROCEDURE noerror
*! this procedure is empty !*
ENDPROC
**
*** 
*** ReFox - all is not lost 
***
