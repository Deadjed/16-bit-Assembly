
// 7.2D Jed Pauckner

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

@colour // Initialize colour variable
M=0

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