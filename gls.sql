CREATE TEMP TABLE TEST_TABLE (ID int, AREA float, ROOMS float, ODD float, PRICE float);
    INSERT INTO TEST_TABLE SELECT 1, 2202, 3, 1, 400;
    INSERT INTO TEST_TABLE SELECT 2, 1600, 3, 0, 330;
    INSERT INTO TEST_TABLE SELECT 3, 2400, 3, 1, 369;
    INSERT INTO TEST_TABLE SELECT 4, 1416, 2, 1, 232;
    INSERT INTO TEST_TABLE SELECT 5, 3000, 4, 0, 540;

--INDEPENDENT VARIABLE VECTOR--
CREATE TEMP TABLE X_VAR AS
  SELECT ID xid, 0 xn, 1 xv FROM TEST_TABLE
    UNION ALL
    SELECT ID, 1, ROOMS FROM TEST_TABLE
    UNION ALL
    SELECT ID, 2, AREA FROM TEST_TABLE
    UNION ALL
    SELECT ID, 3, ODD FROM TEST_TABLE;

--DEPENDANT VARIABLE VECTOR--
CREATE TEMP TABLE Y_VAR AS
  SELECT ID yid, 0 yn, PRICE yv FROM TEST_TABLE;

--ORTHOGONAL PROCESSED VALUES--
CREATE TEMP TABLE Z_VAR (zid int, zn int, zv float);
    INSERT INTO Z_VAR SELECT ID, 0 zn, 1 zv FROM TEST_TABLE;

--ORTHOGONALIZATION COEFFICIENTS--
CREATE TEMP TABLE C_VAR (cxn int, czn int, cv float);
    INSERT INTO C_VAR SELECT ID, 0 zn, 1 zv from TEST_TABLE;

--REGRESSION COEFFICIENTS--
CREATE TEMP TABLE B_VAR (bn int, bv float);

--FIRST LOOP: ORTHOGONALIZATION COEFFICIENT CALC--
CREATE OR REPLACE PROCEDURE ORTH()
    RETURNS FLOAT NOT NULL
    LANGUAGE JAVASCRIPT
    AS
  $$
        var sql_counter =
            `SELECT MAX(XN) as C FROM X_VAR`;
        var sql_bulk =
            `INSERT INTO C_VAR
                    SELECT XN CXN, ZN CZN, SUM(XV*ZV)/SUM(ZV*ZV) CV
                        FROM X_VAR
                    JOIN Z_VAR ON XID = ZID
                        WHERE ZN = p-1
                        AND XN > ZN
                        GROUP BY XN, ZN
                    INSERT INTO Z_VAR
                    SELECT ZID, XN, XV-SUM(CV*ZV)
                        FROM X_VAR
                    JOIN Z_VAR ON XID = ZID
                    JOIN C_VAR ON CZN = ZN AND CXN = XN
                        WHERE
                        1=1
                        AND XN = P
                        AND ZN < XN
                    GROUP BY ZID, XN, XV`;
        var p = 1;
        while (p <= ExecuteSingleValueQuery('C', sql_counter)) {
            snowflake.execute ({sqlText: sql_bulk})
            p = p + 1
            }

// Added a helper function

function ExecuteSingleValueQuery(columnName, queryString) {
    var out;
    cmd1 = {sqlText: queryString};
    stmt = snowflake.createStatement(cmd1);
    var rs;

    rs = stmt.execute();
    rs.next();
    return rs.getColumnValue(columnName);
$$
;

CALL ORTH();
SELECT * FROM C_VAR;

SELECT MAX(XN) FROM X_VAR
