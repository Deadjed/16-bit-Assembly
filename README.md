# 16-bit-Assembly

## Fill
For this task I was required to write a program in assembly code to change the screen to black when a key is pressed and return to white when no key is pressed. For my implementation I started by calculating how many 16 bit iterations I will need to print to fill the screen. 
Our hack computer has a screen size of 512 x 256, to calculate the iterations I will need to divide the width (256) by 16 (as our machine is 16 bit and will be changing 16 of those bits each iteration) and then multiply that value by our height. I have implemented this in my assembly code to avoid having to re calculate things if our screen size changes (I also added a rounding function at the end of the division function to avoid touching memory we shouldn’t be):
```
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
