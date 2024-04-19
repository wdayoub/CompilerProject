* C-Minus Compilation to TM Code
* File: gcd_prototype.tm
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
* allocating global var: y
* <- vardecl
* processing function: gcd
* jump around function body here
 12:    ST 0,-1(5)	store return
* processing local var: u
* processing local var: v
* -> compound statement
* -> if
* -> op
* -> id
* looking up id: v
 13:    LD 0,-3(5)	load id value
* <- id
 14:    ST 0,-4(5)	op: push left
* -> constant
 15:   LDC 0,0(0)	load const
* <- constant
 16:    LD 1,-4(5)	op: load left
 17:   SUB 0, 1, 0	op ==
* <- op
 18:   JNE 0,2(7)	jump if not equal zero
* -> id
* looking up id: u
 19:    LD 0,-2(5)	load id value
* <- id
 20:    LD 7,-1(5)	return to caller
* -> call of function: gcd
* -> id
* looking up id: v
 21:    LD 0,-3(5)	load id value
* <- id
 22:    ST 0,-6(5)	store arg val
* -> op
* -> id
* looking up id: u
 23:    LD 0,-2(5)	load id value
* <- id
 24:    ST 0,-7(5)	op: push left
* -> op
* -> op
* -> id
* looking up id: u
 25:    LD 0,-2(5)	load id value
* <- id
 26:    ST 0,-8(5)	op: push left
* -> id
* looking up id: v
 27:    LD 0,-3(5)	load id value
* <- id
 28:    LD 1,-8(5)	op: load left
 29:   DIV 0, 1, 0	op /
* <- op
 30:    ST 0,-8(5)	op: push left
* -> id
* looking up id: v
 31:    LD 0,-3(5)	load id value
* <- id
 32:    LD 1,-8(5)	op: load left
 33:   MUL 0, 1, 0	op *
* <- op
 34:    LD 1,-7(5)	op: load left
 35:   SUB 0, 1, 0	op -
* <- op
 36:    ST 0,-7(5)	store arg val
 37:    ST 5,-4(5)	push ofp
 38:   LDA 5,-4(5)	push frame
 39:   LDA 0,1(7)	load ac with ret ptr
 40:   LDA 7,-29(7)	jump to func loc
 41:    LD 5,0(5)	pop frame
 42:    ST 0,-4(5)	save return value to caller's stack frame
* <- call
 43:    LD 7,-1(5)	return to caller
* <- if
* <- compound statement
 44:    LD 7,-1(5)	return to caller
 11:   LDA 7,33(7)	jump around fn body
* Leaving function gcd
* processing function: main
* jump around function body here
 46:    ST 0,-1(5)	store return
* -> compound statement
* processing local var: x
* -> op
* -> id
* looking up id: x
 47:   LDA 0,-2(5)	load id address
* <- id
 48:    ST 0,-3(5)	op: push left
* -> call of function: input
 49:    ST 5,-4(5)	push ofp
 50:   LDA 5,-4(5)	push frame
 51:   LDA 0,1(7)	load ac with ret ptr
 52:   LDA 7,-49(7)	jump to func loc
 53:    LD 5,0(5)	pop frame
* <- call
 54:    LD 1,-3(5)	op: load left
 55:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: y
 56:   LDA 0,0(6)	load id address
* <- id
 57:    ST 0,-3(5)	op: push left
* -> constant
 58:   LDC 0,10(0)	load const
* <- constant
 59:    LD 1,-3(5)	op: load left
 60:    ST 0,0(1)	assign: store value
* <- op
* -> call of function: output
* -> call of function: gcd
* -> id
* looking up id: x
 61:    LD 0,-2(5)	load id value
* <- id
 62:    ST 0,-7(5)	store arg val
* -> id
* looking up id: y
 63:    LD 0,0(6)	load id value
* <- id
 64:    ST 0,-8(5)	store arg val
 65:    ST 5,-5(5)	push ofp
 66:   LDA 5,-5(5)	push frame
 67:   LDA 0,1(7)	load ac with ret ptr
 68:   LDA 7,-57(7)	jump to func loc
 69:    LD 5,0(5)	pop frame
 70:    ST 0,-5(5)	save return value to caller's stack frame
* <- call
 71:    ST 0,-5(5)	store arg val
 72:    ST 5,-3(5)	push ofp
 73:   LDA 5,-3(5)	push frame
 74:   LDA 0,1(7)	load ac with ret ptr
 75:   LDA 7,-69(7)	jump to func loc
 76:    LD 5,0(5)	pop frame
* <- call
* <- compound statement
 77:    LD 7,-1(5)	return to caller
 45:   LDA 7,32(7)	jump around fn body
* Leaving function main
 78:    ST 5,-1(5)	push ofp
 79:   LDA 5,-1(5)	push frame
 80:   LDA 0,1(7)	load ac with ret addr
 81:   LDA 7,-36(7)	jump to main loc
 82:    LD 5,0(5)	pop frame
* End of execution
 83:  HALT 0, 0, 0	
