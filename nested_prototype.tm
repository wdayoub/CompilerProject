* C-Minus Compilation to TM Code
* File: nested_prototype.tm
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
* processing local var: y
* processing local var: what
* -> op
* -> id
* looking up id: what
 13:   LDA 0,-4(5)	load id address
* <- id
 14:    ST 0,-5(5)	op: push left
* -> boolean
 15:   LDC 0,1(0)	 
* <- boolean
 16:    LD 1,-5(5)	op: load left
 17:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: x
 18:   LDA 0,-2(5)	load id address
* <- id
 19:    ST 0,-5(5)	op: push left
* -> constant
 20:   LDC 0,1(0)	load const
* <- constant
 21:    LD 1,-5(5)	op: load left
 22:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: y
 23:   LDA 0,-3(5)	load id address
* <- id
 24:    ST 0,-5(5)	op: push left
* -> constant
 25:   LDC 0,2(0)	load const
* <- constant
 26:    LD 1,-5(5)	op: load left
 27:    ST 0,0(1)	assign: store value
* <- op
* -> if
* -> id
* looking up id: what
 28:    LD 0,-4(5)	load id value
* <- id
 29:   JEQ 0,36(7)	jump if true
* -> compound statement
* processing local var: x
 30:   LDC 1,10(1)	load array size
 31:    ST 1,-15(5)	store array size
* -> op
* -> id
* * -> subs
 32:   LDA 0,-14(5)	load id address
 33:    ST 0,-16(5)	store array address
* -> constant
 34:   LDC 0,0(0)	load const
* <- constant
 35:   JLT 0,1(7)	halt if subscript < 0
 36:   LDA 7,1(7)	absolute jump if not
 37:  HALT 0, 0, 0	halt if subscript < 0
 38:    LD 1,-15(5)	load array size
 39:   SUB 1, 1, 0	compare subscript with size
 40:   JLE 1,1(7)	halt if subscript equal or greater than size
 41:   LDA 7,1(7)	absolute jump if not
 42:  HALT 0, 0, 0	halt if subscript equal or greater than size
 43:    LD 1,-16(5)	load array base address
 44:   ADD 0, 0, 1	base is at the bottom of array
* *<- subs
* <- id
 45:    ST 0,-16(5)	op: push left
* -> constant
 46:   LDC 0,9(0)	load const
* <- constant
 47:    LD 1,-16(5)	op: load left
 48:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* * -> subs
 49:   LDA 0,-14(5)	load id address
 50:    ST 0,-16(5)	store array address
* -> constant
 51:   LDC 0,9(0)	load const
* <- constant
 52:   JLT 0,1(7)	halt if subscript < 0
 53:   LDA 7,1(7)	absolute jump if not
 54:  HALT 0, 0, 0	halt if subscript < 0
 55:    LD 1,-15(5)	load array size
 56:   SUB 1, 1, 0	compare subscript with size
 57:   JLE 1,1(7)	halt if subscript equal or greater than size
 58:   LDA 7,1(7)	absolute jump if not
 59:  HALT 0, 0, 0	halt if subscript equal or greater than size
 60:    LD 1,-16(5)	load array base address
 61:   ADD 0, 0, 1	base is at the bottom of array
* *<- subs
* <- id
 62:    ST 0,-16(5)	op: push left
* -> constant
 63:   LDC 0,6(0)	load const
* <- constant
 64:    LD 1,-16(5)	op: load left
 65:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
* <- if
* -> op
* -> id
* looking up id: x
 66:   LDA 0,-2(5)	load id address
* <- id
 67:    ST 0,-5(5)	op: push left
* -> constant
 68:   LDC 0,3(0)	load const
* <- constant
 69:    LD 1,-5(5)	op: load left
 70:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: y
 71:   LDA 0,-3(5)	load id address
* <- id
 72:    ST 0,-5(5)	op: push left
* -> constant
 73:   LDC 0,3(0)	load const
* <- constant
 74:    LD 1,-5(5)	op: load left
 75:    ST 0,0(1)	assign: store value
* <- op
* -> if
* -> id
* looking up id: what
 76:    LD 0,-4(5)	load id value
* <- id
 77:   JEQ 0,10(7)	jump if true
* -> compound statement
* processing local var: x
* processing local var: y
* -> op
* -> id
* looking up id: x
 78:   LDA 0,-5(5)	load id address
* <- id
 79:    ST 0,-18(5)	op: push left
* -> constant
 80:   LDC 0,4(0)	load const
* <- constant
 81:    LD 1,-18(5)	op: load left
 82:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: y
 83:   LDA 0,-6(5)	load id address
* <- id
 84:    ST 0,-18(5)	op: push left
* -> constant
 85:   LDC 0,4(0)	load const
* <- constant
 86:    LD 1,-18(5)	op: load left
 87:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
* <- if
* <- compound statement
 88:    LD 7,-1(5)	return to caller
 11:   LDA 7,77(7)	jump around fn body
* Leaving function main
 89:    ST 5,0(5)	push ofp
 90:   LDA 5,0(5)	push frame
 91:   LDA 0,1(7)	load ac with ret addr
 92:   LDA 7,-81(7)	jump to main loc
 93:    LD 5,0(5)	pop frame
* End of execution
 94:  HALT 0, 0, 0	
