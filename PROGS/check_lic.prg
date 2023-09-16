 LOCAL lccomputername, lowmi, lowmiwin32objects, lowmiwin32object
 lccomputername = GETWORDNUM(SYS(0), 1)
 lowmi = GETOBJECT("WinMgmts://"+lccomputername)
 lowmiwin32objects = lowmi.instancesof("Win32_Processor")
 FOR EACH lowmiwin32object IN lowmiwin32objects
    WITH lowmiwin32object
       hdd_serial = TRANSFORM(.processorid)
    ENDWITH
 ENDFOR
 IF FILE('license.lic')
    lic_file = FOPEN('license.lic', 0)
    lic_str = FGETS(lic_file)
    lic_str_decoded = STRCONV(lic_str, 14)
    PUBLIC lic_denumire, lic_valabil
    lic_denumire = SUBSTR(lic_str_decoded, 1, AT(',', lic_str_decoded, 1)-1)
    lic_valabil = SUBSTR(lic_str_decoded, AT(',', lic_str_decoded, 1)+1, 8)
    lic_serial = SUBSTR(lic_str_decoded, AT(',', lic_str_decoded, 2)+1)
    FCLOSE(lic_file)
    IF hdd_serial<>lic_serial
       MESSAGEBOX("Licenta Incorecta !!!", 16, "Stop")
       QUIT
    ENDIF
    lic_valabil = DATE(VAL(SUBSTR(lic_valabil, 1, 4)), VAL(SUBSTR(lic_valabil, 5, 2)), VAL(SUBSTR(lic_valabil, 7, 2)))
    IF lic_valabil<DATE()
       MESSAGEBOX("Licenta Expirata !!!", 16, "Stop")
       QUIT
    ENDIF
 ELSE
    MESSAGEBOX("Licenta lipsa !!!", 16, "Stop")
    QUIT
 ENDIF
 
**
