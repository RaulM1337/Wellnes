 LPARAMETERS ccurs, bon_path, tip_platax
 bon_path = "C:\ASID"
 SELECT AVG(pret_unit) AS pret_unit,SUM(buc) AS buc,denumire,dep_tva FROM &ccurs GROUP BY denumire,dep_tva INTO CURSOR print_bon_datecs
 IF RECCOUNT('print_bon_datecs')=0
    MESSAGEBOX("Bon gol !!!", 16, "Atentie")
    RETURN
 ENDIF
 den_bon = ALLTRIM(DTOS(DATE()))+ALLTRIM(STRTRAN(TIME(), ':', ''))+"_"+SUBSTR(STR(SECONDS()*1000), LEN(STR(SECONDS()*1000))-3)+".txt"
 varza = FCREATE(den_bon)
 SELECT print_bon_datecs
 GOTO TOP
 vtotal_bon = 0
 DO WHILE  .NOT. EOF('print_bon_datecs')
    vtpu = PADL(ALLTRIM(STR(print_bon_datecs.pret_unit*100, 8)), 8, '0')
    vtcant = PADL(ALLTRIM(STR(print_bon_datecs.buc, 8, 3)), 8, '0')
    vtden = PADR(ALLTRIM(LEFT(ALLTRIM(print_bon_datecs.denumire), 20)), 20, ' ')
    vdeptva = PADL(ALLTRIM(STR(print_bon_datecs.dep_tva, 1, 0)), 2, '0')
    vtext = ''+vtden+','+vtcant+','+vtpu+','+vdeptva
    = FPUTS(varza, vtext)
    vtotal_bon = vtotal_bon+print_bon_datecs.pret_unit
    SKIP 1 IN 'print_bon_datecs'
 ENDDO
 vtotal_bon = ALLTRIM(STR(vtotal_bon, 8, 2))
 IF tip_platax=1
    vtext = '<'
 ELSE
    vtext = '@'
 ENDIF
 = FPUTS(varza, vtext)
 = FCLOSE(varza)
 den_bon_dst = main_form.fiscal_path+'\'+den_bon
 COPY FILE &den_bon TO &den_bon_dst
 IF FILE(den_bon_dst)
    ERASE (SYS(2003)+"\"+den_bon)
 ELSE
    MESSAGEBOX("Nu se poate copia fisierul bon in folderul "+main_form.fiscal_path+" ", 16, "Atentie !!!")
 ENDIF
 
**
