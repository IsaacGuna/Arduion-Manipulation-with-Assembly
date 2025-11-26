;Creating labels for each special registers
.equ SREG, 0x3F 
.equ PORTB, 0x05
.equ PORTD, 0x0B
.equ DDRB, 0x04
.equ DDRD, 0x0A

.org 0 
main: ldi r16, 0 
      out SREG, r16 ;Set status register to 0
      ldi r16, 0x0f ;Setting the data direction registers
      ldi r17, 0xf0
      
      out DDRB, r16
      out DDRD, r17

;Task 1 - Display your K-Number, write r22 as each of Knumber - K25009653
;Output each digit onto LEDs using write subroutine

      ldi r22, 2        ;Writing into r22, 2 
      call outputdelay1s  ;this outputs the value in r22 onto LEDs, then delays for 1 second
      ldi r22,5   
      call outputdelay1s
      ldi r22, 0   
      call outputdelay1s
      ldi r22, 0   
      call outputdelay1s
      ldi r22, 9   
      call outputdelay1s
      ldi r22, 6   
      call outputdelay1s
      ldi r22, 5   
      call outputdelay1s
      ldi r22, 3   
      call outputdelay1s

;Task 2 - Display your initials - I.G
      
      ldi r22, 9           ;Writing into r22, 9 which represents "i"
      call outputdelay2s     ;this outputs the value in r22 onto LEDs, then delays for 1 second
      ldi r22, 27          ;Writing into r22, 27 which represents "."
      call outputdelay2s   
      ldi r22, 7           ;Writing into r22, 9 which represents "g"
      call outputdelay2s

;Task 3 - Display Morse Code - Blinking "ISA" as morse code into the LEDs 

      ldi r23, 50 ;r23 in this instance will be the maximum limit for the loop
      ldi r24, 0  ; r24 is the counter
      ldi r25, 2  ;2 to check modulo2
      ldi r26, 5  ;5 to check modulo5
      
divloop: 

      inc r24
modulo2:
      mov r27, r24
      sub r27, r25
      cpi r27, 0
      breq even
      brpl modulo2
      
      call displayISA
oddmodulo5: 
      mov r27, r24
      sub r27, r26
      cpi r27, 0
      breq multiple5
      brpl oddmodulo5

even: call displayASI
evenmodulo5: 
      mov r27, r24
      sub r27, r26
      cpi r27, 0
      breq multiple5
      brpl evenmodulo5
    
      
multiple5:
      call turnoff200ms
      call display5
      call interwordspace
      
     cpi r24, r23 ; compare counter with max limit - 50 to see if it has reached the limit
     brne divloop
      

;Task 4 - Ping-pong 
      
      ldi r22, 0x80; initialise the first LED to be on
      ldi r23, 0x80; limits to keep doing right shift
      ldi r24, 0x01; limits to keep doing left shift
leftshift:
      lsl r22
      call outputdelay1s
      cpi r22, r24
      brne leftshift
rightshift: 
      lsr r22
      call outputdelay1s
      cpi r22, r23
      brne rightshift
      rjmp leftshift
      





;Small subroutine to improve readability for outputting value in r22 and delaying for 1 second
outputdelay1s: 
       call write
       ldi r18, 100
       call delay
       ret

;Small subroutine to improve readability for outputting value in r22 and delaying for 2 second
outputdelay2s: 
       call write
       ldi r18, 200
       call delay
       ret




;Subroutine to turn all LEDs on for 600ms
turnon200ms:  
       ldi r22, 0xff ;Initialise r22 to be fully on
       call write
       ldi r18, 20
       call delay
       ret

;Subroutine to turn all LEDs off for 600ms
turnoff200ms: 
       ldi r22, 0x00 ;Initialise r22, 0 for LEDs to be off
       call write
       ldi r18, 20
       call delay
       ret

;Subroutine to turn all LEDs on for 600ms
turnon600ms:  
       ldi r22, 0xff ;Initialise r22 to be fully on
       call write
       ldi r18, 60
       call delay
       ret

;Subroutine to turn all LEDs off for 600ms
turnoff600ms: 
       ldi r22, 0x00 ;Initialise r22, 0 for LEDs to be off
       call write
       ldi r18, 60
       call delay
       ret



displayISA:
      call displayI
      call turnoff600ms ;Inter-letter space, turn off for 600ms
      call displayS
      call turnoff600ms ;Inter-letter space, turn off for 600ms
      call displayA
      ret


displayASI: 
      call displayA
      call turnoff600ms ;Inter-letter space, turn off for 600ms
      call displayS
      call turnoff600ms ;Inter-letter space, turn off for 600ms
      call displayI
      ret



;Subroutine to display "I" in morse code, to improve readability and style
displayI: 
       
      ;Output letter "I" in morse code
      call turnon200ms  
      call turnoff200ms ;Inter-part spacing turn off LED for 200ms  
      call turnon200ms
      ret

;Subroutine to display "S" in morse code, to improve readability and style      
displayS: 
      
      ;Output letter "S" in morse code
      call turnon200ms
      call turnoff200ms ;Inter-part spacing turn off LED for 200ms
      call turnon200ms
      call turnoff200ms ;Inter-part spacing turn off LED for 200ms
      call turnon200ms
      ret

;Subroutine to display "A" in morse code, to improve readability and style
displayA: 
      
      ;Output letter "A" in morse 
      call turnon200ms
      call turnoff200ms ;Inter-part spacing turn off LED for 200ms
      call turnon600ms  ;First dash of letter A
      ret

;Subroutine to display "A" in morse code, to improve readability and style     
display5: 
      
      ;Output letter "5" in morse code
      call turnon200ms
      call turnoff200ms ;Inter-part spacing turn off LED for 200ms
      call turnon200ms
      call turnoff200ms ;Inter-part spacing turn off LED for 200ms
      call turnon200ms
      call turnoff200ms ;Inter-part spacing turn off LED for 200ms
      call turnon200ms
      call turnoff200ms ;Inter-part spacing turn off LED for 200ms
      call turnon200ms
      ret

;Subroutine to show the interword space in morse code, to improve readability and style      
interwordspace: 

;Turn off LED for 1400ms for the inter-word space      
      ldi r22, 0x00 ;Initialise r22, 0 for LEDs to be off
      call write
      ldi r18, 140 ;Delay for 1400ms
      call delay
      ret

;writes whatevers in r22 onto the 8 LEDs  
write: out PORTB, r22
       out PORTD, r22
       ret

delay: 
       dec r18        ;r18 is the register parameter for how many 10ms delay
       ldi r21, 5     ; initialise as 5 to 2 x 10 = 20ms 
nest2: 
       dec r21       
       ldi r20, 128   ;Clock frequency of Arduino = 16MHz
nest1:                ;r20 * (r19 * 2) + 3 = 33152
       dec r20        ;Time delayed = clock cycles/frequency 
       ldi r19, 128   ;33152/16,000,000 = 2.072 * 10^-3 = 2ms  
nest0:                ;inner most loop does 256 cycles
       dec r19
	   cpi r19, 0
	   brne loop
	   cpi r20, 0
	   brne nest1
       cpi r21, 0
       brne nest2
       cpi r18, 0
       brne delay    ;decides how many 2ms delays to do
	   ret


mainloop: rjmp mainloop

