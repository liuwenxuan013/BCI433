000100190729       //**************************************************************************
000200190313       //* THIS PROGRAM USES A CURSOR TO LOAD A TEMPORARY RESULT TABLE THAT JOINS T
000300190313       //* ORDERLINE, CUSTOMER, PART AND SALESREP TABLES.  ORDER NUMBER IS USED AS
000400190313       //* FIELD WHERE CUSTOMER TOTALS ARE PRINTED ON NEW ORDER NUMBERS
000500190313       //*
000600190313       //**************************************************************************
000700190313           DCL-F PROVREPORT PRINTER OFLIND(*IN01) ;
000800190313           DCL-S ProvinceH    Char(10);
000900190313           DCL-S EndOfFile    IND;
001000190313           DCL-S TotalRecords PACKED(5:0) ;
001100190315             // LowLimit is passed to the program
001200190729               DCL-PI MAIN EXTPGM ('PROVSQLH');
001201190729                 LOWLIMIT ZONED(7:2);
001202190729               END-PI;
001300190315
001400190315
001401190315             // All Host Variables available under a single name
001500190729             DCL-DS CustomerRecord;
001501190729               CustId    Char(6);
001502190729               FullName  Char(31);
001503190729               City      Char(20);
001504190729               Purchase  Packed(7:2);
001505190729               PDate     Date;
001506190729               Province  Char(10);
001507190729             END-DS;
001508190729
001509190315
001510190315
001511190315
001512190315
001513190315
001514190315
002200190729
002300070123     C/EJECT
002400070123     C**************************************************************************
002500070123     C*                        ***   M A I N   R O U T I N E   ***
002600070123     C**************************************************************************
002700070118      /FREE
002800100309                EXSR PrepareFiles;
002900190313                Write Title;
003000190313                Write HEADINGS;
003100100309                EXSR GetRow;
003200190313                Write NewProv;
003300070209                ProvinceH = Province;
003400070202                DOW NOT EndOfFile;
003500190313                    IF *IN01 = *ON;
003600190313                        Write Title;
003700190313                        Write HEADINGS;
003800190313                       *IN01 = *OFF;
003900070209                    ENDIF;
003901190315                    // Province may change
003902190729                    IF provinceH = Province;
003903190729                      write Detail;
003905190729                    ELSE;
003906190729                      ProvinceH = Province;
003907190729                      write Totals;
003908190729                      TotalPurch = 0;
003909190729
003910190729                      Write NewProv;
003911190729                      Write Detail;
003912190729                    ENDIF;
003913190729
004000190315
004900190313                    TotalPurch     = TotalPurch     + Purchase;
005000070202                    TotalRecords= TotalRecords + 1;
005100100309                    EXSR GetRow;
005200070119                ENDDO;
005300190313                Write Totals;
005400070202                EXSR   WRAPUP;
005500190313                Write UnderLimit;
005600070119                *INLR = *ON;
005700070119                RETURN;
005800100309        //**********************************************************************
005900100309        // O P E N F I L E S   S U B R O U T I N E
006000100309        //**********************************************************************
006100100309         BEGSR  PrepareFiles;
006200190315        // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  STRUCTURE
006300190729         EXEC SQL
006301190729           DECLARE ALLPROVCURSOR CURSOR
006302190729             FOR SELECT CUSTID, TRIM(FNAME) || ' ' || LNAME,
006306190729                    CITY, PURCHASE, PDATE, 'Ontario' AS PROVINCE
006307190729             FROM BCI433LIB/ONTARIO
006308190729             WHERE PURCHASE > :LOWLIMIT
006309190729             UNION ALL
006310190729             SELECT CUSTID, TRIM(FNAME) || ' ' || LNAME,
006311190729                    CITY, PURCHASE, PDATE, 'Quebec' AS PROVINCE
006312190729             FROM BCI433LIB/QUEBEC
006313190729             WHERE PURCHASE > :LOWLIMIT
006314190729             UNION ALL
006315190729             SELECT CUSTID, TRIM(FNAME) || ' ' || LNAME,
006316190729                    CITY, PURCHASE, PDATE, 'Manitoba' AS PROVINCE
006317190729             FROM BCI433LIB/MANITOBA
006318190729             WHERE PURCHASE > :LOWLIMIT;
006319190729
006320190729
006338190315
008500100309        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D
009300190729         EXEC SQL
009301190729           OPEN ALLPROVCURSOR;
009302190729
009303190729         IF SQLCODE <> 0 OR SQLWN0 = 'W';
009304190729           ENDOFFILE = *ON;
009305190729         ENDIF;
009306190315
009307190315
009309190315
009310190315
009311190315
009400100309            ENDSR;
009500100309        //**********************************************************************
009600100309        //   G E T     R O W    S U B R O U T I N E
009700100309        //**********************************************************************
009800100309            BEGSR     GETROW;
010800190729               EXEC SQL
010801190729                 FETCH NEXT
010802190729                   FROM ALLPROVCURSOR
010803190729                   INTO :CustomerRecord;
010804190729
010805190729
010806190729
010807190729
010808190729
010809190729               IF SQLCODE <> 0 OR SQLWN0 = 'W';
010810190729                 ENDOFFILE = *ON;
010811190729               ENDIF;
010812190315
010813190315
010814190315
010815190315
010816190315
010900100309             ENDSR;
011000100309        //**********************************************************************
011100100309        // W R A P U P     S U B R O U T I N E
011200100309        //**********************************************************************
011300100309           BEGSR WRAPUP;
011301190729           EXEC SQL
011302190729             CLOSE ALLPROVCURSOR;
011303190729           IF SQLCODE <> 0 OR SQLWN0 = 'W';
011304190729             ENDOFFILE = *ON;
011305190729           ENDIF;
011306190729
011307190729           EXEC SQL
011308190729             SELECT COUNT(*) INTO :ONTTOTAL
011309190729               FROM BCI433LIB/ONTARIO
011310190729              WHERE PURCHASE <= :LOWLIMIT;
011311190729
011315190729
011316190729           EXEC SQL
011317190729             SELECT COUNT(*) INTO :QUETOTAL
011318190729               FROM BCI433LIB/QUEBEC
011319190729               WHERE PURCHASE <= :LOWLIMIT;
011320190729
011321190729           EXEC SQL
011322190729             SELECT COUNT(*) INTO :MANTOTAL
011323190729               FROM BCI433LIB/MANITOBA
011324190729             WHERE PURCHASE <= :LOWLIMIT;
011325190729
011330190729
014600100309          ENDSR;
014601190315
014602190315
014603190315
014604190315
014605190315
014606190315
014607190315
014608190315
014609190315
014610190315
014611190315
014612190315
014613190315
014614190315
014615190315
