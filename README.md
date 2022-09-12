# 16-bit-Assembly

## Fill
changes the screen to black when a key is pressed ('b' key) and return to white when no key is pressed. For my implementation I started by calculating how many 16 bit iterations I will need to print to fill the screen. 
The hack computer this was written for has a screen size of 512 x 256, to calculate the iterations I will need to divide the width (256) by 16 (as our machine is 16 bit and will be changing 16 of those bits each iteration) and then multiply that value by our height. I have implemented this in my assembly code to avoid having to re calculate things if our screen size changes (I also added a rounding function at the end of the division function to avoid touching memory we shouldn’t be):
```nasm
@256    // Set height to 256
D=A
@height 
M=D   

@512   // Set width to 512
D=A
@width
M=D       
        // calculate end of screen
@i
M=0

(DIVIDE)
        @i      // Add 1 to division value
        M=M+1

        @16     // 16 bit system (width / 16 = iterations for each line) 
        D=A
        @width
        M=M-D

        D=M
        @DIVIDE
        D;JGT

        @WHOLE
        D;JEQ

        @i      // round value if non whole division
        M=M-1

(WHOLE) // Set width to divided value
        @i
        D=M
        M=0     // Reset i = 0 to re use
        @width
        M=D

(MULTIPLY)      // height * iterations for each line = end of screen
        @height
        D=M
        @i
        M=M+D

        @width
        M=M-1
        D=M

        @MULTIPLY
        D;JGT
```
From here my program basically holds a temp variable to store how far through the screen it has iterated, which gets reset when it reaches the end of the screen to start again at the top of the next frame. And a colour variable to store which colour should be printed to the screen at any given time. 
My infinite loop consists of storing the current colour value, going to the current address, storing colour value in address, incrementing the address, checking for the end of screen (if so re initialize temp variable for next frame), reading keyboard, if no key pressed store 0 as our next colour value, if 66 (the b key) then store -1 or (1111 1111 1111 1111) as our next colour value, and then jump back to our loop for the next iteration along the screen:
@colour // Initialize colour variable
M=0
```
(NEXTFRAME) 
        @i
        D=M
        @tmp
        M=D     // set temp variable for iterations

        @SCREEN
        D=A
        @addr
        M=D     // addr = 16384 (Screens base address)

        @keytemp

(FILL)  // fill with value until end of screen
        @colour // store colour value
        D=M
        @addr   
        A=M     // goto address
        M=D     // store colour value in address
        @addr   // address = address + 1
        M=M+1                

        @tmp    // check for end of screen
        M=M-1
        D=M
        @NEXTFRAME
        D;JEQ

        @KBD    // read keyboard
        D=M
        @keytemp
        M=D
        
        @colour // fill screen with white if no key pressed
        M=0
        @FILL
        D;JEQ

        @66     // check for b key
        D=A
        @keytemp
        M=M-D
        D=M
        
        @colour
        M=-1
        @FILL
        D;JEQ

        @FILL
        0;JMP     
```
Noting I have initialized the colour value to white as my first colour value to avoid unexpected values. Also note my code highlighting doesn’t look right, please disregard the highlighted parts within comments  as I haven’t found a visual studio code theme that supports our 16 bit assembly code yet. 
I have also chosen to continue to loop over the current screen before starting the next frame causing colour changes to happen in the middle of frames as that made the most sense to me, if I were to start from the top left of the screen every time the colour changed I may never write to the bottom right of the screen which may have left over artifacts and cause a variable refresh rate.
    
    
## Mult
Multiplication between two numbers is simply adding one number to itself the send numbers amount of times. For this implementation R[0] and R[1] hold the numbers to be multiplied. We need a third location to hold a ‘running sum’ to add the value in R[0] to itself R[1] amount of times (accounting for multiplications of 0 of course). 
The general idea behind my code is to create a SUM variable and initialise it to 0, then doing value checks on R[0] and R[1] to see if either is 0 then end the program there and output 0. If not then add R[0] to Sum and either increment or decrement R[1] depending on weather it is positive or negative (unnecessary but my fault for not reading the task sheet thorough enough) and then checking if R[1] is 0 to end the loop.
To put it in a higher level language context such as C++ it would look like this (still using R[0] and R[1] notation for our values)
```cpp
Int SUM = 0;
If (R[0] == 0 || R[1] == 0)
	Return SUM;
For (R[1] != 0)
{
	SUM = SUM + R[0]
	If (R[1] < 0)
		R[1]++;
	If (R[1] > 0)
		R[1]--;
}
Return SUM;
```

My assembly implementation looks like this:
```asm
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

And now knowing both numbers will not be negative I can shorten it down to this
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
M=M+1   // Increment R1 if not

@R0     // Sum = Sum + R0
D=M
@SUM    
M=M+D   

@LOOP   // Continue loop
0;JMP

(END)   // Store sum in R[2]
@SUM
D=M
@R2
M=D

(CONTROL)   // End of program control loop
@CONTROL
0;JMP
```
