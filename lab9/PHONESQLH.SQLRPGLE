000100190313         // **************************************************************************
000200190313        //  CUSTOMER19 READ BY NATIVE LANGUAGE (ILE RPG)
000300190313        //  CONTACTW19 ROW RETRIEVED WITH EMBEDDED SQL
000400190313        //  DETAIL REPORT LINE INCLUDES INFORMATION FROM CUSTOMER19 AND CONTACTW19
000500190313        //  SUMMARRY REPORT INFORMATION RETRIEVED WITH EMBEDDED SQL STATEMENTS
000600190314
000700190313           DCL-F PHNREPORT PRINTER OFLIND(*IN01) ;
000800190313           DCL-F CUSTOMER19 DISK(*EXT) KEYED USAGE(*INPUT)
000900190314                 RENAME(CUSTOMER19:CUSTR);
001000190314                      // data structure for host variables from CONTACTW19
001100190722                       DCL-DS CONTACTW19 EXT END-DS;
001200190314                     // Standalone fields for indicator variables
001300190722                       DCL-S INDLASTCDATE BINDEC (4:0);
001301190722                       DCL-S INDNEXTCDATE BINDEC (4:0);
001400190314
001500190314
001600190314           DCL-S Dummy  Zoned(1);
001700190314
001800190314        //**************************************************************************
001900190314        //*                        ***   M A I N   R O U T I N E   ***
002000190314        //**************************************************************************
002100190314
002200070119                EXSR SummaryInfo;
002300190313                WRITE HEADINGS;
002400190313                READ CUSTOMER19;
002500070119                DOW NOT %EOF;
002600070119                    EXSR SQLSelect;
002700190313                    IF *IN01 = *ON;
002800190313                       Write HEADINGS;
002900190313                       *IN01 = *OFF;
003000070119                    ENDIF;
003100190313                    Write DETAIL;
003200190313                   READ CUSTOMER19;
003300070119                ENDDO;
003400190313                Write SUMMARY;
003500070119                *INLR = *ON;
003600070119                RETURN;
003700080923        //**********************************************************************
003800080923        //   S Q L S E L E C T   S U B R O U T I N E
003900080923   //   //********************************************************************
004000080923   //                  BEGSR    SQLSelect ;
004100080923   //    // A row from the contacts table that has the same customer number as t
004200190313   //    // read from the CUSTOMER19 file is retrieved to find out the last date
004300080923   //    // phone number, comments and the salesperson number.
004400080923   //
004500080923   //    //  The call back interval is added to the last date called to determin
004600080923   //    //  next date to call.  Since null values may be stored in the last dat
004700080923   //    // indicator variables are used.
004800190723              EXEC SQL
004801190723
004802190723             SELECT PHNLDC + PHNCIT DAYS, PHNLDC,
004803190723               CSTPHN, PHNCOM, CSTSLN
004804190723             INTO :NEXTCDATE :INDNEXTCDATE, :PHNLDC :INDLASTCDATE,
004805190723                  :CSTPHN, :PHNCOM, :CSTSLN
004806190723             FROM BCI433LIB/CONTACTW19
004807190723             WHERE CSTNUM = :CSTNUM;
004808190723
004809190723             SELECT;
004810190723               WHEN SQLSTATE = '00000';
004811190723                 DUMMY = 0;
004812190723               WHEN SQLSTATE = '02000';
004813190723                 CSTPHN = 'NOT FOUND';
004814190723                 NEXTCDATE = D'9999-09-09';
004815190723                 PHNLDC = D'9999-09-09';
004816190723                 PHNCOM = *ALL'*';
004817190723                 CSTSLN = *ALL'*';
004818190723             WHEN %SUBST(SQLSTATE :1 :2) = '01';
004819190723                 NEXTCDATE = D'9999-09-09';
004820190723                 PHNLDC = D'9999-09-09';
004821190723                 PHNCOM = *ALL'*';
004822190723                 CSTSLN = *ALL'*';
004823190723             OTHER;
004824190723                CSTPHN = *ALL'*';
004825190723                NEXTCDATE = D'9999-09-09';
004826190723                PHNLDC = D'9999-09-09';
004827190723                PHNCOM = *ALL'*';
004828190723                CSTSLN = *ALL'*';
004829190723             ENDSL;
004830190723
004831190723             IF INDLASTCDATE = -1;
004832190723               CSTPHN = 'UNKNOWN DATE';
004833190723               NEXTCDATE = D'9999-09-09';
004834190723               PHNLDC = D'9999-09-09';
004835190723
004836190723               ELSE;
004837190723                 IF INDLASTCDATE <> 0;
004838190723                   CSTPHN = 'DATE PROBLEM';
004839190723                   NEXTCDATE = D'9999-09-09';
004840190723                   PHNLDC = D'9999-09-09';
004841190723                 ENDIF;
004842190723
004843190723             ENDIF;
004844190723
005100190722
005200190314
005300190314
006600190314
006700190314
006800190314
006900080923                         ENDSR ;
007000080923        //**********************************************************************
007100080923        // S U M M A R Y I N F O   S U B R O U T I N E
007200080923        //**********************************************************************
007300080923                         BEGSR  SummaryInfo;
007400190313        //  D E T E R M I N E   T O T A L S   F O R   CONTACTW19 & CUSTOMER19
007500190723                       EXEC SQL
007501190723                         SELECT COUNT(*) INTO :CONTACTT
007502190723                           FROM BCI433LIB/CONTACTW19;
007503190723
007504190723                       IF (SQLCODE <> 0) OR (SQLWN0 ='W');
007505190723                            CONTACTT = -99999;
007506190723                       ENDIF;
007507190723
007508190723                       EXEC SQL
007509190723                         SELECT COUNT(*) INTO :CUSTOMERT
007510190723                           FROM BCI433LIB/CUSTOMER19;
007511190723
007512190723                       IF (SQLCODE <> 0) OR (SQLWN0 ='W');
007513190723                            CONTACTT = -99999;
007514190723                       ENDIF;
007515190723
007800190314
007900190314
008000190314
008100190314
008200190314
008300190314
008400190314
008500190314
008600190314
008700190314
008800190314
008900190314
009000190314        // D E T E R M I N E   N U M B E R   O F   U N K N O W N   LAST   DATE CALLED
009100190314
009200190723               EXEC SQL
009201190723                 SELECT COUNT(*)
009202190723                   INTO :UNKNOWNT
009203190723                   FROM BCI433LIB/CONTACTW19
009204190723                   WHERE CSTLASTCALLDATE IS NULL;
009205190723               IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
009206190723                    UNKNOWNT =-99999;
009207190723               ENDIF;
009208190723
009300190314
009400190314
009500190314
009600190314
009700190314
009800190314
009900190314
010000190314
010100080923        //  D E T E R M I N E   O L D E S T   &  M O S T   R E C E N T  L A S T
010200190723          EXEC SQL
010201190723                 SELECT MIN(PHNLDC)
010202190723                 INTO :OLDESTDATE
010203190723                 FROM BCI433LIB/CONTACTW19;
010204190723
010205190723               IF (SQLCODE <> 0) OR (SQLWN0 = 'W') AND (SQLWN2 <> 'W');
010206190723                  OLDESTDATE = D'9999-09-09';
010207190723               ENDIF;
010208190723
010209190723
010210190723             // MOST RECENT
010211190723               EXEC SQL
010212190723                 SELECT MAX(PHNLDC)
010213190723                 INTO :RECENTDATE
010214190723                 FROM BCI433LIB/CONTACTW19;
010215190723
010216190723               SELECT;
010217190723                 WHEN SQLWN2 = 'W';
010218190723                   WHEN NOT(SQLCODE = 0) OR (SQLWN0 = 'W');
010219190723                     RECENTDATE = D'9999-09-09';
010220190723               ENDSL;
010221190723
010300190314
010400190314
010500190314
010600190314
012000190314
012100080923       // D E T E R M I N E   T H E   U S E R   S E R V E R   &   T I M E S T A
012200080923
012300190723               EXEC SQL
012301190723                 SELECT USER, CURRENT TIMESTAMP, CURRENT SERVER
012302190723                   INTO :User, :TimeStamp, :Server
012303190723                   FROM SYSIBM/SYSDUMMY1;
012304190723
012500190314
012600190314
012700190314
012800080923                         ENDSR;
