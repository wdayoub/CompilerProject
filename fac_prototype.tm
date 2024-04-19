* C-Minus Compilation to TM Code
* File: fac_prototype.tm
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
* -> op
* -> id
* looking up id: x
 13:   LDA 0,-2(5)	load id address
* <- id
 14:    ST 0,-4(5)	op: push left
* -> call of function: input
 15:    ST 5,-5(5)	push ofp
 16:   LDA 5,-5(5)	push frame
 17:   LDA 0,1(7)	load ac with ret ptr
 18:   LDA 7,-15(7)	jump to func loc
 19:    LD 5,0(5)	pop frame
* <- call
 20:    LD 1,-4(5)	op: load left
 21:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: fac
 22:   LDA 0,-3(5)	load id address
* <- id
 23:    ST 0,-4(5)	op: push left
* -> constant
 24:   LDC 0,1(0)	load const
* <- constant
 25:    LD 1,-4(5)	op: load left
 26:    ST 0,0(1)	assign: store value
* <- op
* -> while
* -> op
* -> id
* looking up id: x
 27:    LD 0,-2(5)	load id value
* <- id
 28:    ST 0,-4(5)	op: push left
* -> constant
 29:   LDC 0,1(0)	load const
* <- constant
 30:    LD 1,-4(5)	op: load left
 31:   SUB 0, 1, 0	op >
* <- op
 32:   JLE 0,19(7)	jump if true
* -> compound statement
* -> op
* -> id
* looking up id: fac
 33:   LDA 0,-3(5)	load id address
* <- id
 34:    ST 0,-4(5)	op: push left
* -> op
* -> id
* looking up id: fac
 35:    LD 0,-3(5)	load id value
* <- id
 36:    ST 0,-5(5)	op: push left
* -> id
* looking up id: x
 37:    LD 0,-2(5)	load id value
* <- id
 38:    LD 1,-5(5)	op: load left
 39:   MUL 0, 1, 0	op *
* <- op
 40:    LD 1,-4(5)	op: load left
 41:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: x
 42:   LDA 0,-2(5)	load id address
* <- id
 43:    ST 0,-4(5)	op: push left
* -> op
* -> id
* looking up id: x
 44:    LD 0,-2(5)	load id value
* <- id
 45:    ST 0,-5(5)	op: push left
* -> constant
 46:   LDC 0,1(0)	load const
* <- constant
 47:    LD 1,-5(5)	op: load left
 48:   SUB 0, 1, 0	op -
* <- op
 49:    LD 1,-4(5)	op: load left
 50:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
 51:   LDA 7,-25(7)	absolute jump to test
* <- while
* -> call of function: output
* -> id
* looking up id: fac
 52:    LD 0,-3(5)	load id value
* <- id
 53:    ST 0,-6(5)	store arg val
 54:    ST 5,-4(5)	push ofp
 55:   LDA 5,-4(5)	push frame
 56:   LDA 0,1(7)	load ac with ret ptr
 57:   LDA 7,-51(7)	jump to func loc
 58:    LD 5,0(5)	pop frame
* <- call
* <- compound statement
 59:    LD 7,-1(5)	return to caller
 11:   LDA 7,48(7)	jump around fn body
* Leaving function main
 60:    ST 5,0(5)	push ofp
 61:   LDA 5,0(5)	push frame
 62:   LDA 0,1(7)	load ac with ret addr
 63:   LDA 7,-52(7)	jump to main loc
 64:    LD 5,0(5)	pop frame
* End of execution
 65:  HALT 0, 0, 0	
