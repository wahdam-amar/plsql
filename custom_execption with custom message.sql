DECLARE
  my_exception EXCEPTION;
  message VARCHAR2(100) := 'Custom error message';
BEGIN
  RAISE my_exception;
EXCEPTION
  WHEN my_exception THEN
    RAISE_APPLICATION_ERROR(-20001, message);
END;
