000100190731         // DatFmt used to ensure that *USA is the default for all date fields                      
000101190731                                                                                                    
000102190731         Ctl-Opt DatFmt(*USA);                                                                      
000103190731                                                                                                    
000104190731         DCL-F WhatDayDsp Workstn;                                                                  
000105190731                                                                                                    
000106190805      /COPY lab10,DATEPROTOS                                                                        
000108190805             // Copying code from DATEPROTOS                                                        
000109190805                                                                                                    
000110190731         DCL-S WorkDay Zoned(1);                                                                    
000111190731         DCL-S WorkDate Date;                                                                       
000112190731                                                                                                    
000113190731           EXFMT Input;                                                                             
000114190731                                                                                                    
000115190731           DOW NOT *IN03;// CF03(03) First one is allowing to press F3 and second                   
000116190731                         // one is turing on Indicator                                              
000117190731                         // DOW *IN03 = *OFF;                                                       
000118190731                         // DOW *IN03 = 0;                                                          
000119190731                                                                                                    
000120190731              // DayOfWeek is Not an RPGLE function, it is a user defined function                  
000121190805              WorkDate = DateIn;                                                                    
000122190805              WorkDay = DayOfWeek(WorkDate);                                                        
000123190731                                                                                                    
000124190731               Result1 = 'The Day of Week is ' + %Char(WorkDay);//Converting into a character string
000125190805               Result2 = 'That is a ' + DayName(WorkDate); // Returns a 9 char word                 
000126190805               Result3 = DATEWORDS(WORKDATE); // have to fix                                        
000127190805                            //                                                                      
000128190805                                                                                                    
000129190731             //%DIFF(DATE1:DATE2: *D                                                                
000130190731             //                   *M                                                                
000131190731             //                   *Y                                                                
000132190731             //                                                                                     
000133190731             //REMAINDER =                                                                          
000134190731                                                                                                    
000135190805          *IN90 = *ON;  // Protects date field                                                      
000136190805             WRITE INPUT;                                                                           
000137190805             EXFMT OUTPUT;                                                                          
000138190805          *IN90 = *OFF;                                                                             
000139190731                                                                                                    
000140190805            IF NOT *IN03;                                                                           
000141190805              EXFMT INPUT;                                                                          
000142190731                                                                                                    
000143190805            ENDIF;                                                                                  
000144190731                                                                                                    
000145190805          ENDDO;                                                                                    
000146190805                                                                                                    
000147190805          *INLR = *ON;                                                                              
000148190805          Return;                                                                                   
000149190731              //  %DIFF(DATE1:DATED: *D OR *M OR *Y);                                               
000150190731                                                                                                    
