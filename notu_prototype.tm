* C-Minus Compilation to TM Code
* File: notu_prototype.tm
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
* processing local var: a
* processing local var: b
* processing local var: what
* processing local var: lol
* -> op
* -> id
* looking up id: a
 13:   LDA 0,-2(5)	load id address
* <- id
 14:    ST 0,-6(5)	op: push left
* -> constant
 15:   LDC 0,4(0)	load const
* <- constant
 16:    LD 1,-6(5)	op: load left
 17:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: b
 18:   LDA 0,-3(5)	load id address
* <- id
 19:    ST 0,-6(5)	op: push left
* -> op
 20:    ST 0,-7(5)	op: push left
* -> constant
 21:   LDC 0,4(0)	load const
* <- constant
 22:    LD 1,-7(5)	op: load left
 23:   LDC 3,-1(0)	load -1
 24:   MUL 0, 0, 3	op *
* <- op
 25:    LD 1,-6(5)	op: load left
 26:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: what
 27:   LDA 0,-4(5)	load id address
* <- id
 28:    ST 0,-6(5)	op: push left
* -> boolean
 29:   LDC 0,1(0)	 
* <- boolean
 30:    LD 1,-6(5)	op: load left
 31:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: lol
 32:   LDA 0,-5(5)	load id address
* <- id
 33:    ST 0,-6(5)	op: push left
* -> id
* looking up id: what
 34:    LD 0,-4(5)	load id value
* <- id
 35:    LD 1,-6(5)	op: load left
 36:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
 37:    LD 7,-1(5)	return to caller
 11:   LDA 7,26(7)	jump around fn body
* Leaving function main
 38:    ST 5,0(5)	push ofp
 39:   LDA 5,0(5)	push frame
 40:   LDA 0,1(7)	load ac with ret addr
 41:   LDA 7,-30(7)	jump to main loc
 42:    LD 5,0(5)	pop frame
* End of execution
 43:  HALT 0, 0, 0	
