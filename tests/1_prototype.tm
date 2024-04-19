* C-Minus Compilation to TM Code
* File: tests/1_prototype.tm
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
* processing local var: c
* -> op
* -> id
* looking up id: b
 13:   LDA 0,-3(5)	load id address
* <- id
 14:    ST 0,-5(5)	op: push left
* -> constant
 15:   LDC 0,5(0)	load const
* <- constant
 16:    LD 1,-5(5)	op: load left
 17:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: a
 18:   LDA 0,-2(5)	load id address
* <- id
 19:    ST 0,-5(5)	op: push left
* -> constant
 20:   LDC 0,6(0)	load const
* <- constant
 21:    LD 1,-5(5)	op: load left
 22:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: c
 23:   LDA 0,-4(5)	load id address
* <- id
 24:    ST 0,-5(5)	op: push left
* -> op
* -> op
* -> op
* -> id
* looking up id: a
 25:    LD 0,-2(5)	load id value
* <- id
 26:    ST 0,-6(5)	op: push left
* -> id
* looking up id: b
 27:    LD 0,-3(5)	load id value
* <- id
 28:    LD 1,-6(5)	op: load left
 29:   MUL 0, 1, 0	op *
* <- op
 30:    ST 0,-6(5)	op: push left
* -> constant
 31:   LDC 0,20(0)	load const
* <- constant
 32:    LD 1,-6(5)	op: load left
 33:   ADD 0, 1, 0	op +
* <- op
 34:    ST 0,-6(5)	op: push left
* -> constant
 35:   LDC 0,2(0)	load const
* <- constant
 36:    LD 1,-6(5)	op: load left
 37:   DIV 0, 1, 0	op /
* <- op
 38:    LD 1,-5(5)	op: load left
 39:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
 40:    LD 7,-1(5)	return to caller
 11:   LDA 7,29(7)	jump around fn body
* Leaving function main
 41:    ST 5,0(5)	push ofp
 42:   LDA 5,0(5)	push frame
 43:   LDA 0,1(7)	load ac with ret addr
 44:   LDA 7,-33(7)	jump to main loc
 45:    LD 5,0(5)	pop frame
* End of execution
 46:  HALT 0, 0, 0	
