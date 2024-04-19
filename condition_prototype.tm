* C-Minus Compilation to TM Code
* File: condition_prototype.tm
* Standard prelude:
  0:    LD 6,0(0)	load gp with maxaddress
  1:   LDA 5,0(6)	copy gp to fp
  2:    ST 0,0(0)	clear value at location 0
* Jump around i/o routines here
* Code for input routine
  4:    ST 0,-1(5)	store return
  5:    IN 0, 0, 0	input
  6:    LD 7,-1(5)	return to caller
* Code for output routine
  7:    ST 0,-1(5)	store return
  8:    LD 0,-2(5)	load output value
  9:   OUT 0, 0, 0	output
 10:    LD 7,-1(5)	return to caller
  3:   LDA 7,7(7)	jump around i/o code
* End of standard prelude
* processing function: main
* jump around function body here
 12:    ST 0,-1(5)	store return
* -> compound statement
* processing local var: what
* -> op
* -> id
* looking up id: what
 13:   LDA 0,-2(5)	load id address
* <- id
 14:    ST 0,-3(5)	op: push left
* -> boolean
 15:   LDC 0,0(0)	 
* <- boolean
 16:    LD 1,-3(5)	op: load left
 17:    ST 0,0(1)	assign: store value
* <- op
* -> if
* -> op
* -> id
* looking up id: what
 18:    LD 0,-2(5)	load id value
* <- id
 19:    ST 0,-3(5)	op: push left
* -> boolean
 20:   LDC 0,0(0)	 
* <- boolean
 21:    LD 1,-3(5)	op: load left
 22:   SUB 0, 1, 0	op ==
* <- op
 23:   JNE 0,5(7)	jump if not equal zero
* -> compound statement
* processing local var: x
* -> op
* -> id
* looking up id: x
 24:   LDA 0,-3(5)	load id address
* <- id
 25:    ST 0,-4(5)	op: push left
* -> constant
 26:   LDC 0,2(0)	load const
* <- constant
 27:    LD 1,-4(5)	op: load left
 28:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
* <- if
* <- compound statement
 29:    LD 7,-1(5)	return to caller
 11:   LDA 7,18(7)	jump around fn body
* Leaving function main
 30:    ST 5,0(5)	push ofp
 31:   LDA 5,0(5)	push frame
 32:   LDA 0,1(7)	load ac with ret addr
 33:   LDA 7,-22(7)	jump to main loc
 34:    LD 5,0(5)	pop frame
* End of execution
 35:  HALT 0, 0, 0	
