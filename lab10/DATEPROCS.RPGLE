000100190731         // DatFmt is used to ensure that *USA is the default for all date fields                   
000101190731                                                                                                    
000102190731         CTL-OPT NOMAIN DATFMT(*USA); // Control Option No Main and the date format                 
000103190805                                      // The program doesn't have a main exe function               
000104190805                                      // So cannot become an individual program                     
000105190805                                                                                                    
000106190805      /COPY LAB10,DATEPROTOS    // Copy the prototypes from the other file                          
000107190731                                // File name and member name                                        
000108190731                                                                                                    
000109190805        DCL-PROC DayOfWeek EXPORT; // Declaring a Procedure Statement                               
000110190805                                   // Returns the day number of the week                            
000111190805                                                                                                    
000112190805           DCL-PI *N ZONED(1); // DIDN'T BOTHER NAMING THE INTERFACE                                
000113190805                               // If we do not want to repeat the name of the procedure             
000114190731                WORKDATE DATE;                                                                      
000115190805                                                                                                    
000116190731           END-PI;                                                                                  
000117190731                                                                                                    
000118190731                                                                                                    
000119190731         // ANYSUNDAY CAN BE SET TO THE DATE OF ANY VALID SUNDAY                                    
000120190805         DCL-S ANYSUNDAY DATE INZ(D'04/02/1995'); // This is an actual Sunday date                  
000121190805                                                  // INZ is Initialize                              
000122190731         DCL-S WORKNUM PACKED(7); // Store diff between dates                                       
000123190731         DCL-S WORKDAY ZONED(1); // Gets the remainder                                              
000124190731                                                                                                    
000125190731         WORKNUM = %DIFF(WORKDATE : ANYSUNDAY: *D);                                                 
000126190731         WORKDAY = %REM( WORKNUM :7);  // = to remainder                                            
000127190805                                                                                                    
000128190805         IF WORKDAY < 1;   // Because Sundays are 0s;                                               
000129190731           WORKDAY = WORKDAY + 7;                                                                   
000130190805         ENDIF;                                                                                     
000131190805                                                                                                    
000132190731             RETURN WORKDAY;                                                                        
000133190731                                                                                                    
000134190731         END-PROC DayOfWeek;                                                                        
000135190805                                                                                                    
000136190731                                                                                                    
000137190805         DCL-PROC DAYNAME EXPORT; // Declaring a Procedure Statement                                
000138190805                                 // To be called by another module in the program                   
000139190805         DCL-Pi *n Char(9);                                                                         
000140190805           DateIn Date; // The Passed in value                                                      
000141190805         END-PI;                                                                                    
000142190731                                                                                                    
000143190805             DCL-DS DayData;                                                                        
000144190805               *n Char(9) Inz('Monday');                                                            
000145190805               *n Char(9) Inz('Tuesday');                                                           
000146190805               *n Char(9) Inz('Wednesday');                                                         
000147190805               *n Char(9) Inz('Thursday');                                                          
000148190805               *n Char(9) Inz('Friday');                                                            
000149190805               *n Char(9) Inz('Saturday');                                                          
000150190805               *n Char(9) Inz('Sunday');                                                            
000151190805                                                                                                    
000152190805               DayArray Char(9) Dim(7) Pos(1);                                                      
000153190805               // Pos - Starting position of the subfield in the data structure                     
000154190805               // Dim - Number of elements in the array                                             
000155190805                                                                                                    
000156190805             END-DS;                                                                                
000157190805                                                                                                    
000158190805             Return DayArray(DayOfWeek(DateIn));                                                    
000159190805                                                                                                    
000160190805         END-PROC DAYNAME;                                                                          
000161190805                                                                                                    
000162190805                                                                                                    
000163190805         DCL-PROC DateWords EXPORT; // Declaring a Procedure Statement                              
000166190805                                    // This is like the Function                                    
000167190805                                                                                                    
000168190805               DCL-Pi *n Char(28);  // This is like a parameter passed into the function            
000169190805                                   // Char is the return type of the function                       
000170190805                    WorkDate Date; // The Passed parameter name and type                            
000171190805               END-PI;                                                                              
000172190805                                                                                                    
000173190805             DCL-S DateC CHAR(30);                                                                  
000174190805                                                                                                    
000175190805                                                                                                    
000176190805             DCL-DS MonthData;                                                                      
000177190805                                                                                                    
000178190805               *n Char(9) Inz('January');                                                           
000179190805               *n Char(9) Inz('February');                                                          
000180190805               *n Char(9) Inz('March');                                                             
000181190805               *n Char(9) Inz('April');                                                             
000182190805               *n Char(9) Inz('May');                                                               
000183190805               *n Char(9) Inz('June');                                                              
000184190805               *n Char(9) Inz('July');                                                              
000185190805               *n Char(9) Inz('August');                                                            
000186190805               *n Char(9) Inz('September');                                                         
000187190805               *n Char(9) Inz('October');                                                           
000188190805               *n Char(9) Inz('November');                                                          
000189190805               *n Char(9) Inz('December');                                                          
000190190805                                                                                                    
000191190805               MonthArray Char(9) Dim(12) Pos(1);                                                   
000192190805               // Pos - Starting position of the subfield in the data structure                     
000193190805               // Dim - Number of elements in the array                                             
000194190805                                                                                                    
000195190805             END-DS;                                                                                
000196190805                                                                                                    
000200190805                                                                                                    
000203190805            DateC = %Char(WorkDate:*USA);                                                           
000204190805                                                                                                    
000205190805            Return %TRIMR(DayName(WorkDate)) + ' ' +                                                
000206190805            %TRIMR(MonthArray(%Dec(%Subst(DateC:1:2):2:0)) ) + ' '                                  
000207190805            // We grab the month and convert it into decimal with 0 dec places                      
000208190805            //                                                                                      
000209190805            + %Subst(DATEC:4:2) + ', ' + %Subst(DATEC :7:4);                                        
000210190805            // mm - dd - yyyy                                                                       
000211190805                                                                                                    
000212190805            End-Proc DateWords;                                                                     
000213190805                                                                                                    
000214190805                                                                                                    
000215190805                                                                                                    
000216190805                                                                                                    
000217190805                                                                                                    
000218190731                                                                                                    
