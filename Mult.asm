@SUM    // Initialize sum variable to 0
M=0

@R0     // End program if R0 == 0
D=M
@END
D;JEQ   

(LOOP)  // for (R1 != 0)
@R1     // End program if R1 == 0
D=M
@END    
D;JEQ

@R0     // Sum = Sum + R0
D=M
@SUM    
M=M+D   

@R1      
D=M
@ADD        // if (R1 < 0) R1++;
D;JLT
@SUBTRACT   // if (R1 > 0) R1--;
D;JGT

@LOOP   // Continue loop otherwise
0;JMP

(ADD)       // Function to increment value
@R1
M=M+1
@LOOP
0;JMP

(SUBTRACT)  // Function to decrement value
@R1
M=M-1
@LOOP
0;JMP

(END)   // Store sum in R[2]
@SUM
D=M
@R2
M=D

(CONTROL)   // End of program control loop
@CONTROL
0;JMP