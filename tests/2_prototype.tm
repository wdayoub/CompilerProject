* C-Minus Compilation to TM Code
* File: tests/2_prototype.tm
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
* processing local var: yes
* processing local var: no
* -> op
* -> id
* looking up id: no
 13:   LDA 0,-3(5)	load id address
* <- id
 14:    ST 0,-4(5)	op: push left
* -> constant
 15:   LDC 0,2(0)	load const
* <- constant
 16:    LD 1,-4(5)	op: load left
 17:    ST 0,0(1)	assign: store value
* <- op
* -> while
* -> op
* -> id
* looking up id: yes
 18:    LD 0,-2(5)	load id value
* <- id
 19:    ST 0,-4(5)	op: push left
* -> constant
 20:   LDC 0,2(0)	load const
* <- constant
 21:    LD 1,-4(5)	op: load left
 22:   SUB 0, 1, 0	op >
* <- op
 23:   JLE 0,23(7)	jump if true
* -> compound statement
* -> op
* -> id
* looking up id: no
 24:   LDA 0,-3(5)	load id address
* <- id
 25:    ST 0,-4(5)	op: push left
* -> op
* -> op
* -> id
* looking up id: no
 26:    LD 0,-3(5)	load id value
* <- id
 27:    ST 0,-5(5)	op: push left
* -> id
* looking up id: yes
 28:    LD 0,-2(5)	load id value
* <- id
 29:    LD 1,-5(5)	op: load left
 30:   MUL 0, 1, 0	op *
* <- op
 31:    ST 0,-5(5)	op: push left
* -> constant
 32:   LDC 0,1(0)	load const
* <- constant
 33:    LD 1,-5(5)	op: load left
 34:   ADD 0, 1, 0	op +
* <- op
 35:    LD 1,-4(5)	op: load left
 36:    ST 0,0(1)	assign: store value
* <- op
* -> op
* -> id
* looking up id: yes
 37:   LDA 0,-2(5)	load id address
* <- id
 38:    ST 0,-4(5)	op: push left
* -> op
* -> id
* looking up id: yes
 39:    LD 0,-2(5)	load id value
* <- id
 40:    ST 0,-5(5)	op: push left
* -> constant
 41:   LDC 0,1(0)	load const
* <- constant
 42:    LD 1,-5(5)	op: load left
 43:   SUB 0, 1, 0	op -
* <- op
 44:    LD 1,-4(5)	op: load left
 45:    ST 0,0(1)	assign: store value
* <- op
* <- compound statement
 46:   LDA 7,-29(7)	absolute jump to test
* <- while
* <- compound statement
 47:    LD 7,-1(5)	return to caller
 11:   LDA 7,36(7)	jump around fn body
* Leaving function main
 48:    ST 5,0(5)	push ofp
 49:   LDA 5,0(5)	push frame
 50:   LDA 0,1(7)	load ac with ret addr
 51:   LDA 7,-40(7)	jump to main loc
 52:    LD 5,0(5)	pop frame
* End of execution
 53:  HALT 0, 0, 0	
