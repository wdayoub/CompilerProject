* C-Minus Compilation to TM Code
* File: array_prototype.tm
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
* processing global var: lol
 11:   LDC 1,10(1)	load array size
 12:    ST 1,-10(6)	store array size
* processing function: what
* jump around function body here
 14:    ST 0,-1(5)	store return
* -> compound statement
* -> op
* -> id
* * -> subs
 15:    LD 0,-2(5)	load id value
 16:    ST 0,-3(5)	store array address
* -> constant
 17:   LDC 0,3(0)	load const
* <- constant
 18:   JLT 0,1(7)	halt if subscript < 0
 19:   LDA 7,1(7)	absolute jump if not
 20:  HALT 0, 0, 0	halt if subscript < 0
 21:    LD 1,-3(5)	load array size
 22:   LDC 3,1(0)	load array size
 23:   SUB 1, 1, 3	get array size location
 24:    LD 1,0(1)	load array size
 25:   SUB 1, 1, 0	compare subscript with size
 26:   JLE 1,1(7)	halt if subscript equal or greater than size
 27:   LDA 7,1(7)	absolute jump if not
 28:  HALT 0, 0, 0	halt if subscript equal or greater than size
 29:    LD 1,-3(5)	load array base address
 30:   ADD 0, 0, 1	base is at the bottom of array
* *<- subs
* <- id
 31:    ST 0,-3(5)	op: push left
* -> constant
 32:   LDC 0,3(0)	load const
* <- constant
 33:    LD 1,-3(5)	op: load left
 34:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* * -> subs
 35:    LD 0,-2(5)	load id value
 36:    ST 0,-3(5)	store array address
* -> constant
 37:   LDC 0,10(0)	load const
* <- constant
 38:   JLT 0,1(7)	halt if subscript < 0
 39:   LDA 7,1(7)	absolute jump if not
 40:  HALT 0, 0, 0	halt if subscript < 0
 41:    LD 1,-3(5)	load array size
 42:   LDC 3,1(0)	load array size
 43:   SUB 1, 1, 3	get array size location
 44:    LD 1,0(1)	load array size
 45:   SUB 1, 1, 0	compare subscript with size
 46:   JLE 1,1(7)	halt if subscript equal or greater than size
 47:   LDA 7,1(7)	absolute jump if not
 48:  HALT 0, 0, 0	halt if subscript equal or greater than size
 49:    LD 1,-3(5)	load array base address
 50:   ADD 0, 0, 1	base is at the bottom of array
* *<- subs
* <- id
 51:    ST 0,-3(5)	op: push left
* -> constant
 52:   LDC 0,17(0)	load const
* <- constant
 53:    LD 1,-3(5)	op: load left
 54:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
 55:    LD 7,-1(5)	return to caller
 13:   LDA 7,42(7)	jump around fn body
* Leaving function what
* processing function: main
* jump around function body here
 57:    ST 0,-1(5)	store return
* -> compound statement
* -> op
* -> id
* * -> subs
 58:   LDA 0,-9(6)	load id address
 59:    ST 0,-2(5)	store array address
* -> constant
 60:   LDC 0,1(0)	load const
* <- constant
 61:   JLT 0,1(7)	halt if subscript < 0
 62:   LDA 7,1(7)	absolute jump if not
 63:  HALT 0, 0, 0	halt if subscript < 0
 64:    LD 1,-10(6)	load array size
 65:   SUB 1, 1, 0	compare subscript with size
 66:   JLE 1,1(7)	halt if subscript equal or greater than size
 67:   LDA 7,1(7)	absolute jump if not
 68:  HALT 0, 0, 0	halt if subscript equal or greater than size
 69:    LD 1,-2(5)	load array base address
 70:   ADD 0, 0, 1	base is at the bottom of array
* *<- subs
* <- id
 71:    ST 0,-2(5)	op: push left
* -> constant
 72:   LDC 0,7(0)	load const
* <- constant
 73:    LD 1,-2(5)	op: load left
 74:    ST 0,0(1)	assign: store value
* <- op
* -> call of function: what
* -> id
* looking up id: lol
 75:   LDA 0,-9(6)	load id address
* <- id
 76:    ST 0,-4(5)	store arg val
 77:    ST 5,-2(5)	push ofp
 78:   LDA 5,-2(5)	push frame
 79:   LDA 0,1(7)	load ac with ret ptr
 80:   LDA 7,-67(7)	jump to func loc
 81:    LD 5,0(5)	pop frame
* <- call
* <- compound statement
 82:    LD 7,-1(5)	return to caller
 56:   LDA 7,26(7)	jump around fn body
* Leaving function main
 83:    ST 5,-11(5)	push ofp
 84:   LDA 5,-11(5)	push frame
 85:   LDA 0,1(7)	load ac with ret addr
 86:   LDA 7,-30(7)	jump to main loc
 87:    LD 5,0(5)	pop frame
* End of execution
 88:  HALT 0, 0, 0	
