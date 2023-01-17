CREATE OR REPLACE PROCEDURE TDJSYS.log_error (title_in   IN error_log.title%TYPE,
                                       info_in    IN error_log.info%TYPE,
                                       user_in in varchar2 default 'ADMIN')
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
