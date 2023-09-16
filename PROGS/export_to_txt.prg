 LPARAMETERS date_export, tip
 DO CASE
    CASE tip=1
       tip_export = 'bar'
    CASE tip=2
       tip_export = 'restaurant'
    OTHERWISE
       tip_export = 'altele'
 ENDCASE
 path_export = 'export_date\'+DTOS(DATE())
 IF  .NOT. DIRECTORY(path_export)
    MD (path_export)
 ENDIF
 folder_name = path_export
 txtfile = ''
 SELECT * FROM &date_export INTO CURSOR export_cursor
 DO WHILE  .NOT. EOF('export_cursor')
    luna = PADL(ALLTRIM(STR(MONTH(export_cursor.tr_date_time), 2, 0)), 2, '0')
    ziua = PADL(ALLTRIM(STR(DAY(export_cursor.tr_date_time), 2, 0)), 2, '0')
    anul = PADL(ALLTRIM(STR(YEAR(export_cursor.tr_date_time), 4, 0)), 4, '0')
    dataf = ziua+'/'+luna+'/'+anul
    cota_tva = ALLTRIM(SUBSTR(export_cursor.tva, 1, 2))
    buc = VAL(export_cursor.bucati)
    valoare = export_cursor.prod_pret*buc
    den_gest = ALLTRIM(export_cursor.denumire_gestiune)
    txtfile = txtfile+luna+ziua+';'+dataf+';'+tostr(export_cursor.prod_name)+';'+tostr(export_cursor.cod_produs_gestiune)+';'+tostr(buc)+';'
    txtfile = txtfile+tostr(valoare)+';'+tostr(export_cursor.cod_gestiune)+';'+tostr(den_gest)+';'+cota_tva+CHR(10)+CHR(13)+CHR(10)
    SKIP 1 IN 'export_cursor'
 ENDDO
 IF USED('export_cursor')
    inchide('export_cursor')
 ENDIF
 file_name = folder_name+'\'+ziua+luna+anul+'_export_'+tip_export+'.txt'
 SET SAFETY OFF
 STRTOFILE(txtfile, file_name, 0)
 SET SAFETY ON
 
**
