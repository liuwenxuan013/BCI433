000100190805       DCL-F ALLSHIFT   USAGE(*INPUT) KEYED;                                                        
000101190805       DCL-F SHIFTRATES DISK USAGE(*INPUT);                                                         
000102190709       DCL-F CONFIRMPY2 WORKSTN;                                                                    
000103190709       DCL-F PAYRPT2     PRINTER OFLIND(*IN01);                                                     
000104190709       DCL-S HOURSOVER PACKED(3);                                                                   
000105190709                                                                                                    
000106190709       DCL-PI  Main  ExtPgm('PAYROLLPG3');                                                          
000107190709       SHIFTTYPE  char(30);                                                                         
000108190709       End-PI;                                                                                      
000109190709                                                                                                    
000110190709                                                                                                    
000111190805       READ  SHIFTRATES;                                                                            
000112190709       WRITE TITLE;                                                                                 
000113190709       WRITE COLHDG;                                                                                
000114190709       READ ALLSHIFT;                                                                               
000115190709       DOW NOT %EOF;                                                                                
000116190709         EXSR PAYSR;                                                                                
000117190709         IF *IN01;                                                                                  
000118190709           WRITE TITLE;                                                                             
000119190709           WRITE COLHDG;                                                                            
000120190709           *IN01 = *OFF;                                                                            
000121190709         ENDIF;                                                                                     
000122190709         WRITE EMPDETAIL;                                                                           
000123190709         READ ALLSHIFT;                                                                             
000124190709       ENDDO;                                                                                       
000125190709       TOTEMPPAY = TOTREGPAY + TOTOVTPAY;                                                           
000126190709       WRITE TOTALS;                                                                                
000127190709       EXFMT RECORD1;                                                                               
000128190709       *INLR = *ON;                                                                                 
000129190709       RETURN;                                                                                      
000130190709                                                                                                    
000131190709       BEGSR PAYSR;                                                                                 
000132190709         SELECT;                                                                                    
000133190709           WHEN WORKSHIFT = 'D';                                                                    
000134190709             HOURLYRATE = DAYRATE;                                                                  
000135190709           WHEN WORKSHIFT = 'N';                                                                    
000136190709             HOURLYRATE = NIGHTRATE;                                                                
000137190709           WHEN WORKSHIFT = 'A';                                                                    
000138190709             HOURLYRATE = AFTNRATE;                                                                 
000139190709         ENDSL;                                                                                     
000140190709                                                                                                    
000141190709         SELECT;                                                                                    
000142190709           WHEN PAYGRADE = '1';                                                                     
000143190709             EVAL(H) HOURLYRATE *= 1.072;                                                           
000144190709           WHEN PAYGRADE = '2';                                                                     
000145190709             EVAL(H) HOURLYRATE *= 1.056;                                                           
000146190709           WHEN PAYGRADE = '3';                                                                     
000147190709             EVAL(H) HOURLYRATE *= 0.966;                                                           
000148190709         ENDSL;                                                                                     
000149190709                                                                                                    
000150190709         HOURSOVER = HRSWORKED - 40;                                                                
000151190709         SELECT;                                                                                    
000152190709           WHEN (HOURSOVER > 0);                                                                    
000153190709             REGULARPAY = 40 * HOURLYRATE;                                                          
000154190709             EVAL(H) OVERPAY = HOURSOVER * HOURLYRATE * 1.5;                                        
000155190709             TOTREGPAY += REGULARPAY;                                                               
000156190709             TOTOVTPAY += OVERPAY;                                                                  
000157190709           OTHER;                                                                                   
000158190709             REGULARPAY = HRSWORKED * HOURLYRATE;                                                   
000159190709             OVERPAY = 0;                                                                           
000160190709             TOTREGPAY += REGULARPAY;                                                               
000161190709         ENDSL;                                                                                     
000162190709         TOTALPAY = REGULARPAY + OVERPAY;                                                           
000163190709       ENDSR;                                                                                       
000164190709                                                                                                    
