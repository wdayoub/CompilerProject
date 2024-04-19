* C-Minus Compilation to TM Code
* File: booltest_prototype.tm
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
* processing local var: x
* processing local var: fac
* processing local var: test
* -> op
* -> id
* looking up id: x
 13:   LDA 0,-2(5)	load id address
* <- id
 14:    ST 0,-5(5)	op: push left
* -> call of function: input
 15:    ST 5,-6(5)	push ofp
 16:   LDA 5,-6(5)	push frame
 17:   LDA 0,1(7)	load ac with ret ptr
 18:   LDA 7,-15(7)	jump to func loc
 19:    LD 5,0(5)	pop frame
* <- call
 20:    LD 1,-5(5)	op: load left
 21:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: fac
 22:   LDA 0,-3(5)	load id address
* <- id
 23:    ST 0,-5(5)	op: push left
* -> constant
 24:   LDC 0,1(0)	load const
* <- constant
 25:    LD 1,-5(5)	op: load left
 26:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: test
 27:   LDA 0,-4(5)	load id address
* <- id
 28:    ST 0,-5(5)	op: push left
* -> op
* -> id
* looking up id: x
 29:    LD 0,-2(5)	load id value
* <- id
 30:    ST 0,-6(5)	op: push left
* -> constant
 31:   LDC 0,1(0)	load const
* <- constant
 32:    LD 1,-6(5)	op: load left
 33:   SUB 0, 1, 0	op >
* <- op
 34:   JGT 0,1(7)	if true, boolean is equal to 1
 35:   LDC 0,0(0)	load 0
 36:   LDA 7,1(7)	if load 0, jump over load 1 command
 37:   LDC 0,1(0)	load 1
 38:    LD 1,-5(5)	op: load left
 39:    ST 0,0(1)	assign: store value
* <- op
* -> while
* -> id
* looking up id: test
 40:    LD 0,-4(5)	load id value
* <- id
 41:   JEQ 0,32(7)	jump if true
* -> compound statement
* -> op
* -> id
* looking up id: fac
 42:   LDA 0,-3(5)	load id address
* <- id
 43:    ST 0,-5(5)	op: push left
* -> op
* -> id
* looking up id: fac
 44:    LD 0,-3(5)	load id value
* <- id
 45:    ST 0,-6(5)	op: push left
* -> id
* looking up id: x
 46:    LD 0,-2(5)	load id value
* <- id
 47:    LD 1,-6(5)	op: load left
 48:   MUL 0, 1, 0	op *
* <- op
 49:    LD 1,-5(5)	op: load left
 50:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: x
 51:   LDA 0,-2(5)	load id address
* <- id
 52:    ST 0,-5(5)	op: push left
* -> op
* -> id
* looking up id: x
 53:    LD 0,-2(5)	load id value
* <- id
 54:    ST 0,-6(5)	op: push left
* -> constant
 55:   LDC 0,1(0)	load const
* <- constant
 56:    LD 1,-6(5)	op: load left
 57:   SUB 0, 1, 0	op -
* <- op
 58:    LD 1,-5(5)	op: load left
 59:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: test
 60:   LDA 0,-4(5)	load id address
* <- id
 61:    ST 0,-5(5)	op: push left
* -> op
* -> id
* looking up id: x
 62:    LD 0,-2(5)	load id value
* <- id
 63:    ST 0,-6(5)	op: push left
* -> constant
 64:   LDC 0,1(0)	load const
* <- constant
 65:    LD 1,-6(5)	op: load left
 66:   SUB 0, 1, 0	op >
* <- op
 67:   JGT 0,1(7)	if true, boolean is equal to 1
 68:   LDC 0,0(0)	load 0
 69:   LDA 7,1(7)	if load 0, jump over load 1 command
 70:   LDC 0,1(0)	load 1
 71:    LD 1,-5(5)	op: load left
 72:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
 73:   LDA 7,-34(7)	absolute jump to test
* <- while
* -> call of function: output
* -> id
* looking up id: fac
 74:    LD 0,-3(5)	load id value
* <- id
 75:    ST 0,-7(5)	store arg val
 76:    ST 5,-5(5)	push ofp
 77:   LDA 5,-5(5)	push frame
 78:   LDA 0,1(7)	load ac with ret ptr
 79:   LDA 7,-73(7)	jump to func loc
 80:    LD 5,0(5)	pop frame
* <- call
* <- compound statement
 81:    LD 7,-1(5)	return to caller
 11:   LDA 7,70(7)	jump around fn body
* Leaving function main
 82:    ST 5,0(5)	push ofp
 83:   LDA 5,0(5)	push frame
 84:   LDA 0,1(7)	load ac with ret addr
 85:   LDA 7,-74(7)	jump to main loc
 86:    LD 5,0(5)	pop frame
* End of execution
 87:  HALT 0, 0, 0	
