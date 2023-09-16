 LPARAMETERS ccurs, bon_path, tip_platax
 bon_path = "C:\CaSyst"
 SELECT AVG(pret_unit) AS pret_unit,SUM(buc) AS buc,denumire,dep_tva FROM &ccurs GROUP BY denumire,dep_tva INTO CURSOR print_bon_datecs
 IF RECCOUNT('print_bon_datecs')=0
    MESSAGEBOX("Bon gol !!!", 16, "Atentie")
    RETURN
 ENDIF
 den_bon = ALLTRIM(DTOS(DATE()))+ALLTRIM(STRTRAN(TIME(), ':', ''))+"_"+SUBSTR(STR(SECONDS()*1000), LEN(STR(SECONDS()*1000))-3)+".inp"
 varza = FCREATE(den_bon)
 SELECT print_bon_datecs
 GOTO TOP
 vtotal_bon = 0
 DO WHILE  .NOT. EOF('print_bon_datecs')
    vtpu = ALLTRIM(STR(print_bon_datecs.pret_unit, 8, 2))
    vtcant = ALLTRIM(STR(print_bon_datecs.buc, 8, 3))
    vtden = ALLTRIM(LEFT(ALLTRIM(print_bon_datecs.denumire), 22))
    vdeptva = ALLTRIM(STR(print_bon_datecs.dep_tva, 1, 0))
    vtext = 'S,1,______,_,__;'+vtden+';'+vtpu+';'+vtcant+';'+vdeptva+';1;'+vdeptva+';0;0;'
    = FPUTS(varza, vtext)
    vtotal_bon = vtotal_bon+(print_bon_datecs.pret_unit*print_bon_datecs.buc)
    SKIP 1 IN 'print_bon_datecs'
 ENDDO
 SELECT print_bon_datecs
 GOTO TOP
 SUM print_bon_datecs.pret_unit*print_bon_datecs.buc TO vtotal_bon 
 vtotal_bon = ALLTRIM(STR(vtotal_bon, 8, 2))
 IF tip_platax=1
    vtext = 'T,1,______,_,__;'
 ELSE
    tip_plata_datecs = ALLTRIM(STR(get_tip_plata_datecs(tip_platax)))
    vtext = 'T,1,______,_,__;'+tip_plata_datecs+';'+vtotal_bon+';;;;'
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
