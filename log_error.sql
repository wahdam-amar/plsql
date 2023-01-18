DROP TABLE ERROR_LOG CASCADE CONSTRAINTS;

CREATE TABLE ERROR_LOG
(
    TITLE             VARCHAR2 (200 BYTE),
    INFO              CLOB,
    CREATED_BY        VARCHAR2 (100 BYTE),
    CALLSTACK         CLOB,
    ERRORSTACK        CLOB,
    ERRORBACKTRACE    CLOB,
    CREATED_ON        DATE DEFAULT SYSDATE
)
LOB (CALLSTACK) STORE AS BASICFILE
    (TABLESPACE TDJCFINDATA
     ENABLE STORAGE IN ROW
     CHUNK 8192
     RETENTION
     NOCACHE LOGGING
     STORAGE (INITIAL 64 K
              NEXT 1 M
              MINEXTENTS 1
              MAXEXTENTS UNLIMITED
              PCTINCREASE 0
              BUFFER_POOL DEFAULT))
LOB (ERRORBACKTRACE) STORE AS BASICFILE
    (TABLESPACE TDJCFINDATA
     ENABLE STORAGE IN ROW
     CHUNK 8192
     RETENTION
     NOCACHE LOGGING
     STORAGE (INITIAL 64 K
              NEXT 1 M
              MINEXTENTS 1
              MAXEXTENTS UNLIMITED
              PCTINCREASE 0
              BUFFER_POOL DEFAULT))
LOB (ERRORSTACK) STORE AS BASICFILE
    (TABLESPACE TDJCFINDATA
     ENABLE STORAGE IN ROW
     CHUNK 8192
     RETENTION
     NOCACHE LOGGING
     STORAGE (INITIAL 64 K
              NEXT 1 M
              MINEXTENTS 1
              MAXEXTENTS UNLIMITED
              PCTINCREASE 0
              BUFFER_POOL DEFAULT))
LOB (INFO) STORE AS BASICFILE
    (TABLESPACE TDJCFINDATA
     ENABLE STORAGE IN ROW
     CHUNK 8192
     RETENTION
     NOCACHE LOGGING
     STORAGE (INITIAL 64 K
              NEXT 1 M
              MINEXTENTS 1
              MAXEXTENTS UNLIMITED
              PCTINCREASE 0
              BUFFER_POOL DEFAULT))
TABLESPACE TDJCFINDATA
PCTUSED 0
PCTFREE 10
INITRANS 1
MAXTRANS 255
STORAGE (INITIAL 64 K
         NEXT 1 M
         MINEXTENTS 1
         MAXEXTENTS UNLIMITED
         PCTINCREASE 0
         BUFFER_POOL DEFAULT)
LOGGING
NOCOMPRESS
NOCACHE
MONITORING;


CREATE OR REPLACE PROCEDURE log_error (
    title_in   IN error_log.title%TYPE,
    info_in    IN error_log.info%TYPE,
    user_in    IN VARCHAR2 DEFAULT 'ADMIN')
    AUTHID DEFINER
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO error_log (title,
                           info,
                           created_by,
                           callstack,
                           errorstack,
                           errorbacktrace)
         VALUES (title_in,
                 info_in,
                 user_in,
                 DBMS_UTILITY.format_call_stack,
                 DBMS_UTILITY.format_error_stack,
                 DBMS_UTILITY.format_error_backtrace);

    COMMIT;
END;
/