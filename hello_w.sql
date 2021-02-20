CREATE OR REPLACE TYPE hello_there --ACCESSIBLE BY (FUNCTION hello_there) 
IS OBJECT
( who VARCHAR2(20)
 , CONSTRUCTOR FUNCTION hello_there 
    RETURN SELF AS RESULT
 , CONSTRUCTOR FUNCTION hello_there 
    (who VARCHAR2) RETURN SELF AS RESULT
 , MEMBER FUNCTION get_who RETURN VARCHAR2
 , MEMBER PROCEDURE set_who (pv_who VARCHAR2)
 , MEMBER PROCEDURE to_string
 ) INSTANTIABLE NOT FINAL; 
/

CREATE OR REPLACE TYPE BODY hello_there IS
    CONSTRUCTOR FUNCTION hello_there RETURN SELF AS RESULT IS
        hello HELLO_THERE := hello_there('Object ogulny.');
    BEGIN
        /*tworzenie exemplarza typu objectowego*/
        SELF := hello;
        dbms_output.put_line('obj was init');
        RETURN;
    END hello_there;
    
    CONSTRUCTOR FUNCTION hello_there
    (who VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        /*tworzenie exemplarza typu objectowego*/
        SELF.who := who;
        RETURN;
    END hello_there;
    
    MEMBER FUNCTION get_who RETURN VARCHAR2 IS
    BEGIN
        RETURN SELF.who;
    END get_who;
    
    MEMBER PROCEDURE set_who (pv_who VARCHAR2) IS
    BEGIN
        SELF.who := pv_who;
    END set_who;
    
    MEMBER PROCEDURE to_string IS
    BEGIN
        /* zwracanie wartosci atrybutu*/
        dbms_output.put_line('hello '||SELF.who);
    END to_string;
END;
/

DECLARE 
    hello HELLO_THERE := hello_there('object przeciazony');
BEGIN
    hello.set_who('new object');
    dbms_output.put_line(hello.get_who);
    hello.to_string();
END;
/
