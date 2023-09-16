**
FUNCTION esql
 LPARAMETERS _sql, _cursor, _noerr_msg
 IF VARTYPE(_cursor)="U"
    _cur = ""
 ELSE
    IF VARTYPE(_cursor)="L" .AND. _cursor=.F.
       _cur = ""
    ELSE
       _cur = _cursor
    ENDIF
 ENDIF
 IF VARTYPE(_noerr_msg)="U"
    _err_msg = .T.
 ELSE
    IF VARTYPE(_noerr_msg)="L" .AND. _noerr_msg=.F.
       _err_msg = .T.
    ELSE
       _err_msg = .F.
    ENDIF
 ENDIF
 IF ISNULL(_sql)
    MESSAGEBOX("String SQL Null", 16, "Stop 1")
    RETURN -1
 ENDIF
 verror = SQLEXEC(cn, _sql, _cur)
 IF verror=-1
    = AERROR(ae)
    IF LIKE('*server shutdown*', LOWER(ae(3))) .OR. LIKE('*Lost connection to MySQL server*', LOWER(ae(3))) .OR. LIKE('*MySQL server has gone away*', LOWER(ae(3)))
       MESSAGEBOX("S-a pierdut conexiunea cu serverul !!!"+CHR(13)+"Aplicatia trebuie repornita"+CHR(13)+"asigurati-va ca serverul functioneaza inainte de pornire", 16, "Stop")
    ELSE
       IF _err_msg=.T.
          MESSAGEBOX(ae(3), 16, "Error")
       ENDIF
    ENDIF
    IF  .NOT. FILE(DTOS(DATE())+".log")
       FCREATE(DTOS(DATE())+".log")
    ENDIF
    STRTOFILE(TIME()+" - MySQL Error:  "+ae(3)+CHR(13)+CHR(10), DTOS(DATE())+".log", 1)
    STRTOFILE(TIME()+" - MySQL String: "+_sql+CHR(13)+CHR(10), DTOS(DATE())+".log", 1)
    FCLOSE(DTOS(DATE())+".log")
    RETURN -1
 ELSE
    RETURN 1
 ENDIF
ENDFUNC
**
FUNCTION esqlf
 LPARAMETERS _sql, _cursor
 IF VARTYPE(_cursor)="U"
    _cur = ""
 ELSE
    IF VARTYPE(_cursor)="L" .AND. _cursor=.F.
       _cur = ""
    ELSE
       _cur = _cursor
    ENDIF
 ENDIF
 verror = SQLEXEC(cfb, _sql, _cur)
 IF verror=-1
    = AERROR(ae)
    MESSAGEBOX(ae(3), 16, "Error")
    IF  .NOT. FILE(DTOS(DATE())+".log")
       FCREATE(DTOS(DATE())+".log")
    ENDIF
    STRTOFILE(TIME()+" - FIREBIRD Error:  "+ae(3)+CHR(13)+CHR(10), DTOS(DATE())+".log", 1)
    STRTOFILE(TIME()+" - FIREBIRD String: "+_sql+CHR(13)+CHR(10), DTOS(DATE())+".log", 1)
    FCLOSE(DTOS(DATE())+".log")
    RETURN -1
 ELSE
    RETURN 1
 ENDIF
ENDFUNC
**
FUNCTION tostr
 LPARAMETERS val_to_str
 DO CASE
    CASE TYPE('val_to_str')='C'
       IF ISNULL(val_to_str)
          _str = ''
       ELSE
          _str = ALLTRIM(STRTRAN(val_to_str, "'", ""))
       ENDIF
    CASE TYPE('val_to_str')='D'
       _str = ALLTRIM(DTOS(val_to_str))
    CASE TYPE('val_to_str')='T'
       _str = ALLTRIM(TTOC(val_to_str))
    CASE TYPE('val_to_str')='N'
       _str = ALLTRIM(STR(val_to_str, 10, 2))
    CASE TYPE('val_to_str')='L'
       _str = ALLTRIM(val_to_str)
    CASE TYPE('val_to_str')='Y'
       _str = ALLTRIM(MTON(val_to_str))
 ENDCASE
 RETURN _str
ENDFUNC
**
PROCEDURE inchide
 LPARAMETERS curs_de_inchis
 IF USED(curs_de_inchis)
    SELECT &curs_de_inchis
    USE
 ENDIF
ENDPROC
**
FUNCTION tag_is_abon
 LPARAMETERS tagcode
 esql("select COUNT(*) as poz from _abonamente where tag='"+tostr(tagcode)+"' ", "cvertagabon")
 IF VAL(cvertagabon.poz)>0
    RETURN .T.
 ELSE
    RETURN .F.
 ENDIF
ENDFUNC
**
FUNCTION time_to_int
 LPARAMETERS data_ora
 x_ora = PADL(ALLTRIM(STR(HOUR(data_ora), 2, 0)), 2, '0')
 x_minut = PADL(ALLTRIM(STR(MINUTE(data_ora), 2, 0)), 2, '0')
 x_secunda = PADL(ALLTRIM(STR(SEC(data_ora), 2, 0)), 2, '0')
 xoraint = VAL(x_ora+x_minut+x_secunda)
 RETURN xoraint
ENDFUNC
**
FUNCTION date_to_int
 LPARAMETERS data_ora
 x_ora = ALLTRIM(STR(YEAR(data_ora), 4, 0))
 x_minut = PADL(ALLTRIM(STR(MONTH(data_ora), 2, 0)), 2, '0')
 x_secunda = PADL(ALLTRIM(STR(DAY(data_ora), 2, 0)), 2, '0')
 xoraint = (x_ora+x_minut+x_secunda)
 RETURN xoraint
ENDFUNC
**
FUNCTION isexerunning
 LPARAMETERS tcname, tlterminate
 LOCAL lolocator, lowmi, loprocesses, loprocess, llisrunning
 lolocator = CREATEOBJECT('WBEMScripting.SWBEMLocator')
 lowmi = lolocator.connectserver()
 lowmi.security_.impersonationlevel = 3
 loprocesses = lowmi.execquery([SELECT * FROM Win32_Process WHERE Name = ']+tcname+['])
 llisrunning = .F.
 IF loprocesses.count>0
    FOR EACH loprocess IN loprocesses
       llisrunning = .T.
       IF tlterminate
          loprocess.terminate(0)
       ENDIF
    ENDFOR
 ENDIF
 RETURN llisrunning
ENDFUNC
**
FUNCTION get_tip_plata_datecs
 LPARAMETERS tip_plata
 esql("select * from _tip_plata_datecs where tip_plata_wellness='"+tostr(tip_plata)+"' ", "cdatecsplata")
 IF RECCOUNT('cdatecsplata')>0
    RETURN cdatecsplata.valoare_casa
 ELSE
    RETURN 0
 ENDIF
ENDFUNC
**
FUNCTION get_tip_plata_from_grupa
 LPARAMETERS tagroup
 esql("SELECT * FROM fb_tagholder_access_group as a where a.tagrp_no='"+tostr(tagroup)+"' and pachet_in=1 ", "cget_tip_plata")
 BROWSE
 IF RECCOUNT('cget_tip_plata')>0
    RETURN cget_tip_plata.tip_plata
 ELSE
    RETURN 1
 ENDIF
ENDFUNC
**
FUNCTION check_lic
 LPARAMETERS app_id
 LOCAL lccomputername, lowmi, lowmiwin32objects, lowmiwin32object
 lccomputername = GETWORDNUM(SYS(0), 1)
 lowmi = GETOBJECT("WinMgmts://"+lccomputername)
 lowmiwin32objects = lowmi.instancesof("Win32_Processor")
 FOR EACH lowmiwin32object IN lowmiwin32objects
    WITH lowmiwin32object
       cpu_serial = TRANSFORM(.processorid)
    ENDWITH
 ENDFOR
 IF FILE('license.lic')
    lic_file = FOPEN('license.lic', 0)
    lic_str = FGETS(lic_file)
    FCLOSE(lic_file)
    lic_str_decoded = STRCONV(lic_str, 14)
    PUBLIC lic_denumire, lic_valabil, lic_serial, lic_app_id
    nrows = ALINES(lic_array, STRCONV(lic_str, 14), ",")
    lic_denumire = lic_array(1)
    lic_serial = lic_array(3)
    IF TYPE('_screen.myappid')='U'
    ELSE
       IF nrows<4
          MESSAGEBOX("Licenta Incorecta", 16, "STOP")
          RETURN -1
       ELSE
          IF app_id==ALLTRIM(lic_array(4))
             lic_app_id = lic_array(4)
          ELSE
             MESSAGEBOX("Licenta Incorecta sau Versiune aplicatie gresita", 16, "STOP")
             RETURN -1
          ENDIF
       ENDIF
    ENDIF
    FCLOSE(lic_file)
    IF cpu_serial==lic_array(3)
    ELSE
       MESSAGEBOX("Licenta Incorecta !!!", 16, "Stop")
       RETURN -1
    ENDIF
    IF LEN(ALLTRIM(lic_array(2)))<8
       lcserver = "supertrafic.ro"
       lcport = "3306"
       lcdatabase = "_licente"
       lcuser = "root"
       lcpassword = "polarx57"
       lcstringconn = "Driver={MySQL ODBC 3.51 Driver};Port="+lcport+";Server="+lcserver+";Database="+lcdatabase+";Uid="+lcuser+";Pwd="+lcpassword
       SQLSETPROP(0, "DispLogin", 3)
       TRY
          lnhandle = 'lic_con'
          &lnhandle=SQLSTRINGCONNECT(lcstringconn)
       CATCH TO xerr
       FINALLY
       ENDTRY
       IF &lnhandle=-1
          MESSAGEBOX("Nu s-a reusit verificarea licentei online, pentru varianta demo este necesara conexiunea la internet !!!", 16, "Stop")
          RETURN -1
       ELSE
          vsql = SQLEXEC(lic_con, "select * from produse where id="+tostr(lic_array(2))+" ", "cliconline")
          IF vsql=-1
             RETURN -1
          ELSE
             IF cliconline.valabil>0
                lic_valabil = cliconline.data_valabil
                _SCREEN.addproperty('lic_den', ALLTRIM(lic_array(1)))
                _SCREEN.addproperty('lic_val', (lic_valabil))
                _SCREEN.demo = 1
                RETURN 1
             ELSE
                MESSAGEBOX("Varianta demo a expirat !!! Daca v-a placut produsul va rugam achizitionati licenta. Va multumim !", 16, "Stop")
                RETURN -1
             ENDIF
          ENDIF
       ENDIF
    ELSE
       lic_valabil = DATE(VAL(SUBSTR(lic_array(2), 1, 4)), VAL(SUBSTR(lic_array(2), 5, 2)), VAL(SUBSTR(lic_array(2), 7, 2)))
       IF lic_valabil<DATE()
          MESSAGEBOX("Licenta Expirata !!!", 16, "Stop")
          RETURN -1
       ENDIF
    ENDIF
    _SCREEN.addproperty('lic_den', ALLTRIM(lic_array(1)))
    _SCREEN.addproperty('lic_val', (lic_valabil))
 ELSE
    IF FILE('key.txt')
       lic_file = FOPEN('key.txt', 12)
       FPUTS(lic_file, cpu_serial)
       FCLOSE(lic_file)
    ELSE
       STRTOFILE(cpu_serial, 'key.txt')
    ENDIF
    MESSAGEBOX("Licenta lipsa !!!"+CHR(13)+"Va rugam trimiteti fisierul key.txt pentru a primi licenta"+CHR(13)+"Va rugam sa specificati si aplicatia pentru care doriti licenta", 16, "Stop")
    RETURN -1
 ENDIF
 RETURN 1
ENDFUNC
**
