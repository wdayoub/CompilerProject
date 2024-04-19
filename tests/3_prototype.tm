* C-Minus Compilation to TM Code
* File: tests/3_prototype.tm
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
* processing function: soh
* jump around function body here
 12:    ST 0,-1(5)	store return
* -> compound statement
* processing local var: x
* -> op
* -> id
* looking up id: x
 13:   LDA 0,-2(5)	load id address
* <- id
 14:    ST 0,-3(5)	op: push left
* -> constant
 15:   LDC 0,2(0)	load const
* <- constant
 16:    LD 1,-3(5)	op: load left
 17:    ST 0,0(1)	assign: store value
* <- op
* -> id
* looking up id: x
 18:    LD 0,-2(5)	load id value
* <- id
 19:    LD 7,-1(5)	return to caller
* <- compound statement
 20:    LD 7,-1(5)	return to caller
 11:   LDA 7,9(7)	jump around fn body
* Leaving function soh
* processing function: main
* jump around function body here
 22:    ST 0,-1(5)	store return
* -> compound statement
* processing local var: y
* processing local var: foo
* -> op
* -> id
* looking up id: foo
 23:   LDA 0,-3(5)	load id address
* <- id
 24:    ST 0,-4(5)	op: push left
* -> call of function: soh
 25:    ST 5,-5(5)	push ofp
 26:   LDA 5,-5(5)	push frame
 27:   LDA 0,1(7)	load ac with ret ptr
 28:   LDA 7,-17(7)	jump to func loc
 29:    LD 5,0(5)	pop frame
 30:    ST 0,-5(5)	save return value to caller's stack frame
* <- call
 31:    LD 1,-4(5)	op: load left
 32:    ST 0,0(1)	assign: store value
* <- op
* -> while
* -> op
* -> id
* looking up id: y
 33:    LD 0,-2(5)	load id value
* <- id
 34:    ST 0,-4(5)	op: push left
* -> constant
 35:   LDC 0,1(0)	load const
* <- constant
 36:    LD 1,-4(5)	op: load left
 37:   SUB 0, 1, 0	op >
* <- op
 38:   JLE 0,23(7)	jump if true
* -> compound statement
* -> op
* -> id
* looking up id: foo
 39:   LDA 0,-3(5)	load id address
* <- id
 40:    ST 0,-4(5)	op: push left
* -> op
* -> op
* -> id
* looking up id: foo
 41:    LD 0,-3(5)	load id value
* <- id
 42:    ST 0,-5(5)	op: push left
* -> id
* looking up id: y
 43:    LD 0,-2(5)	load id value
* <- id
 44:    LD 1,-5(5)	op: load left
 45:   MUL 0, 1, 0	op *
* <- op
 46:    ST 0,-5(5)	op: push left
* -> constant
 47:   LDC 0,1(0)	load const
* <- constant
 48:    LD 1,-5(5)	op: load left
 49:   ADD 0, 1, 0	op +
* <- op
 50:    LD 1,-4(5)	op: load left
 51:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: y
 52:   LDA 0,-2(5)	load id address
* <- id
 53:    ST 0,-4(5)	op: push left
* -> op
* -> id
* looking up id: y
 54:    LD 0,-2(5)	load id value
* <- id
 55:    ST 0,-5(5)	op: push left
* -> constant
 56:   LDC 0,1(0)	load const
* <- constant
 57:    LD 1,-5(5)	op: load left
 58:   SUB 0, 1, 0	op -
* <- op
 59:    LD 1,-4(5)	op: load left
 60:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
 61:   LDA 7,-29(7)	absolute jump to test
* <- while
* <- compound statement
 62:    LD 7,-1(5)	return to caller
 21:   LDA 7,41(7)	jump around fn body
* Leaving function main
 63:    ST 5,0(5)	push ofp
 64:   LDA 5,0(5)	push frame
 65:   LDA 0,1(7)	load ac with ret addr
 66:   LDA 7,-45(7)	jump to main loc
 67:    LD 5,0(5)	pop frame
* End of execution
 68:  HALT 0, 0, 0	
