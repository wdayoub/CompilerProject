* C-Minus Compilation to TM Code
* File: mutual_prototype.tm
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
* allocating global var: x
* <- vardecl
* allocating global var: y
* <- vardecl
* allocating function prototype: g
* <- funcpro
* processing function: f
* jump around function body here
 12:    ST 0,-1(5)	store return
* processing local var: n
* -> compound statement
* -> call of function: g
* -> id
* looking up id: n
 13:    LD 0,-2(5)	load id value
* <- id
 14:    ST 0,-5(5)	store arg val
 15:    ST 5,-3(5)	push ofp
 16:   LDA 5,-3(5)	push frame
 17:   LDA 0,1(7)	load ac with ret ptr
 18:    LD 7,-2(6)	load function address
 19:    LD 5,0(5)	pop frame
* <- call
* -> op
* -> id
* looking up id: y
 20:   LDA 0,-1(6)	load id address
* <- id
 21:    ST 0,-3(5)	op: push left
* -> op
* -> id
* looking up id: y
 22:    LD 0,-1(6)	load id value
* <- id
 23:    ST 0,-4(5)	op: push left
* -> constant
 24:   LDC 0,1(0)	load const
* <- constant
 25:    LD 1,-4(5)	op: load left
 26:   SUB 0, 1, 0	op -
* <- op
 27:    LD 1,-3(5)	op: load left
 28:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
 29:    LD 7,-1(5)	return to caller
 11:   LDA 7,18(7)	jump around fn body
* Leaving function f
* processing function: g
* processing corresponding prototype
 31:   LDC 1,33(1)	load function address
 32:    ST 1,-2(6)	save function address in prototype
* jump around function body here
 33:    ST 0,-1(5)	store return
* processing local var: m
* -> compound statement
* -> op
* -> id
* looking up id: m
 34:   LDA 0,-2(5)	load id address
* <- id
 35:    ST 0,-3(5)	op: push left
* -> op
* -> id
* looking up id: m
 36:    LD 0,-2(5)	load id value
* <- id
 37:    ST 0,-4(5)	op: push left
* -> constant
 38:   LDC 0,1(0)	load const
* <- constant
 39:    LD 1,-4(5)	op: load left
 40:   SUB 0, 1, 0	op -
* <- op
 41:    LD 1,-3(5)	op: load left
 42:    ST 0,0(1)	assign: store value
* <- op
* -> if
* -> op
* -> id
* looking up id: m
 43:    LD 0,-2(5)	load id value
* <- id
 44:    ST 0,-3(5)	op: push left
* -> constant
 45:   LDC 0,0(0)	load const
* <- constant
 46:    LD 1,-3(5)	op: load left
 47:   SUB 0, 1, 0	op >
* <- op
 48:   JLE 0,23(7)	jump if less than or equal to zero
* -> compound statement
* -> call of function: f
* -> id
* looking up id: m
 49:    LD 0,-2(5)	load id value
* <- id
 50:    ST 0,-5(5)	store arg val
 51:    ST 5,-3(5)	push ofp
 52:   LDA 5,-3(5)	push frame
 53:   LDA 0,1(7)	load ac with ret ptr
 54:   LDA 7,-43(7)	jump to func loc
 55:    LD 5,0(5)	pop frame
* <- call
* -> op
* -> id
* looking up id: y
 56:   LDA 0,-1(6)	load id address
* <- id
 57:    ST 0,-3(5)	op: push left
* -> op
* -> id
* looking up id: y
 58:    LD 0,-1(6)	load id value
* <- id
 59:    ST 0,-4(5)	op: push left
* -> constant
 60:   LDC 0,1(0)	load const
* <- constant
 61:    LD 1,-4(5)	op: load left
 62:   SUB 0, 1, 0	op -
* <- op
 63:    LD 1,-3(5)	op: load left
 64:    ST 0,0(1)	assign: store value
* <- op
* -> call of function: g
* -> id
* looking up id: m
 65:    LD 0,-2(5)	load id value
* <- id
 66:    ST 0,-5(5)	store arg val
 67:    ST 5,-3(5)	push ofp
 68:   LDA 5,-3(5)	push frame
 69:   LDA 0,1(7)	load ac with ret ptr
 70:   LDA 7,-40(7)	jump to func loc
 71:    LD 5,0(5)	pop frame
* <- call
* <- compound statement
* <- if
* <- compound statement
 72:    LD 7,-1(5)	return to caller
 30:   LDA 7,42(7)	jump around fn body
* Leaving function g
* processing function: main
* jump around function body here
 74:    ST 0,-1(5)	store return
* -> compound statement
* -> op
* -> id
* looking up id: x
 75:   LDA 0,0(6)	load id address
* <- id
 76:    ST 0,-2(5)	op: push left
* -> call of function: input
 77:    ST 5,-3(5)	push ofp
 78:   LDA 5,-3(5)	push frame
 79:   LDA 0,1(7)	load ac with ret ptr
 80:   LDA 7,-77(7)	jump to func loc
 81:    LD 5,0(5)	pop frame
* <- call
 82:    LD 1,-2(5)	op: load left
 83:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: y
 84:   LDA 0,-1(6)	load id address
* <- id
 85:    ST 0,-2(5)	op: push left
* -> call of function: input
 86:    ST 5,-3(5)	push ofp
 87:   LDA 5,-3(5)	push frame
 88:   LDA 0,1(7)	load ac with ret ptr
 89:   LDA 7,-86(7)	jump to func loc
 90:    LD 5,0(5)	pop frame
* <- call
 91:    LD 1,-2(5)	op: load left
 92:    ST 0,0(1)	assign: store value
* <- op
* -> call of function: g
* -> id
* looking up id: x
 93:    LD 0,0(6)	load id value
* <- id
 94:    ST 0,-4(5)	store arg val
 95:    ST 5,-2(5)	push ofp
 96:   LDA 5,-2(5)	push frame
 97:   LDA 0,1(7)	load ac with ret ptr
 98:   LDA 7,-68(7)	jump to func loc
 99:    LD 5,0(5)	pop frame
* <- call
* -> call of function: output
* -> id
* looking up id: x
100:    LD 0,0(6)	load id value
* <- id
101:    ST 0,-4(5)	store arg val
102:    ST 5,-2(5)	push ofp
103:   LDA 5,-2(5)	push frame
104:   LDA 0,1(7)	load ac with ret ptr
105:   LDA 7,-99(7)	jump to func loc
106:    LD 5,0(5)	pop frame
* <- call
* -> call of function: output
* -> id
* looking up id: y
107:    LD 0,-1(6)	load id value
* <- id
108:    ST 0,-4(5)	store arg val
109:    ST 5,-2(5)	push ofp
110:   LDA 5,-2(5)	push frame
111:   LDA 0,1(7)	load ac with ret ptr
112:   LDA 7,-106(7)	jump to func loc
113:    LD 5,0(5)	pop frame
* <- call
* <- compound statement
114:    LD 7,-1(5)	return to caller
 73:   LDA 7,41(7)	jump around fn body
* Leaving function main
115:    ST 5,-3(5)	push ofp
116:   LDA 5,-3(5)	push frame
117:   LDA 0,1(7)	load ac with ret addr
118:   LDA 7,-45(7)	jump to main loc
119:    LD 5,0(5)	pop frame
* End of execution
120:  HALT 0, 0, 0	
