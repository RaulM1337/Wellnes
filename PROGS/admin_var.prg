 PUBLIC cn, co, cfb
 cn = SQLCONNECT('wellness')
 co = SQLCONNECT('wellness')
 cfb = SQLCONNECT('firebird_wellness')
 SET PROCEDURE TO functii ADDITIVE
 SET CLASSLIB TO 'module.vcx' ADDITIVE
 PUBLIC addr_in_process, addr_in_listen, usepasswordtodelete
 _SCREEN.addproperty('SYNC_ON_START', 0)
 _SCREEN.addproperty('SERVER', 0)
 _SCREEN.addproperty('ZONA_IN_OUT', 0)
 _SCREEN.addproperty('MESAJ_CIRCUITE_DESCHISE', 1)
 _SCREEN.addproperty('usePasswordToDelete', 0)
 addr_in_process = '00000000'
 addr_in_listen = '00000000'
 IF FILE('config.ini')
    config_file = FOPEN('config.ini')
    DO WHILE  .NOT. FEOF(config_file)
       conf_line = FGETS(config_file)
       conf_para = SUBSTR(conf_line, 1, AT('=', conf_line, 1)-1)
       conf_value = SUBSTR(conf_line, AT('=', conf_line, 1)+1)
       DO CASE
          CASE conf_para='ADDR_IN'
             addr_in_process = conf_value
          CASE conf_para='ADDR_LISTEN'
             addr_in_listen = "'"+STRTRAN(conf_value, ",", "','")+"'"
          CASE conf_para='SYNC_ON_START'
             _SCREEN.sync_on_start = VAL(conf_value)
          CASE conf_para='SERVER'
             _SCREEN.server = VAL(conf_value)
          CASE conf_para='ZONA_IN_OUT'
             _SCREEN.zona_in_out = VAL(conf_value)
          CASE conf_para='MESAJ_CIRCUITE_DESCHISE'
             _SCREEN.mesaj_circuite_deschise = VAL(conf_value)
          CASE conf_para='USE_PASSWORD_TO_DELETE'
             _SCREEN.usepasswordtodelete = VAL(conf_value)
          OTHERWISE
       ENDCASE
    ENDDO
    FCLOSE(config_file)
 ENDIF
 
**
