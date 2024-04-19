import java.util.ArrayList;

import absyn.*;

public class CodeGenerator implements AbsynVisitor {
    public int mainEntry; // absolute address for main function
    public int globalOffset; // next available location after global frame
    public int currentLevel = 0; // keeps track if we are in function or not and assigns to declaration's nestLevel
    public ArrayList<String> output = new ArrayList<String>();
    public int frameOffset = 0; // used in VarDecList for local frame
    public int callArgs = 0;
    public boolean paramAlloc = false;

    // macros for special registers
    public final static int ac   = 0;
    public final static int ac1   = 1;
    public final static int fp   = 5;
    public final static int gp   = 6;
    public final static int pc   = 7;
    public static int ofpFO = 0;
    public static int retFO = -1;
    public static int initFO = -2;
    // missing: opFO, retFO, initFO

    final static int SPACES = 4;

    // one of three sets of offsets
    public int emitLoc = 0;
    public int highEmitLoc = 0;


    // add constructor and all emitting routines
    public CodeGenerator(){
        this.mainEntry = -1;
        this.globalOffset = 0;
        this.frameOffset = 0;
        this.emitLoc = 0;
        this.highEmitLoc = 0;
        this.currentLevel = 0;
    }


    // emit Register Only Instructions
    // Opcode       Effect
    // HALT         stop execution
    // IN           reg[r] <- read an integer from input
    // OUT          reg[r] -> write to standard output
    // ADD          reg[r] = reg[s] + reg[t]
    // SUB          reg[r] = reg[s] - reg[t]
    // MUL          reg[r] = reg[s] * reg[t]
    // DIV          reg[r] = reg[s] / reg[t] (may generate ZERO_DIV)
    public void emitRO(String op, int r, int s, int t, String c){
        //System.out.printf("%3d: %5s %d %d, %d", emitLoc, op, r, s, t);
        //System.out.printf("\t%s\n", c);
        String insert = String.format("%3d: %5s %d, %d, %d\t%s\n", emitLoc, op, r, s, t, c);
       output.add(insert);

        emitLoc++;

        if (highEmitLoc < emitLoc){
            highEmitLoc = emitLoc;
        }
    }


    // emit Register Memory Instructions
    // Opcode       Effect
    // LD           reg[r] = dMem[a]
    // LDA          reg[r] = a
    // LDC          reg[r] = d
    // ST           dMem[a] = reg[r]
    // JLT          if( reg[r] < 0 ) reg[PC_REG] = a
    // JLE          if( reg[r] <= 0 ) reg[PC_REG] = a
    // JGT          if( reg[r] > 0 ) reg[PC_REG] = a
    // JGE          if( reg[r] >= 0 ) reg[PC_REG] = a
    // JEQ          if( reg[r] == 0 ) reg[PC_REG] = a
    // JNE          if( reg[r] != 0 ) reg[PC_REG] = a
    // r: source
    // d: destination
    // s: special register?
    // c: appended comment
    public void emitRM(String op, int r, int d, int s, String c){
        //System.out.printf("%3d: %5s %d,%d(%d)", emitLoc, op, r, d, s);
       // System.out.printf("\t%s\n", c );
        String insert = String.format("%3d: %5s %d,%d(%d)\t%s\n", emitLoc, op, r, d, s, c);
        output.add(insert);
        emitLoc++;
        if( highEmitLoc < emitLoc ){
            highEmitLoc = emitLoc;
        }
    }

    // create a string to replace an old emit
    public String emitRM_replacement(int location, String op, int r, int d, int s, String c){
        String insert = String.format("%3d: %5s %d,%d(%d)\t%s\n", location, op, r, d, s, c);
        return insert;
    }

    public String emitRM_Abs_replacement(int location, String op, int r, int a, String c){
        String insert = String.format("%3d: %5s %d,%d(%d)\t%s\n", location, op, r, a - (location + 1), pc, c);
        return insert;
    }

    // emit Register Memory Instructions but with Absolute Address(?)
    public void emitRM_Abs(String op, int r, int a, String c){
        //System.out.printf("%3d: %5s %d,%d(%d)", emitLoc, op, r, a - (emitLoc + 1), pc);
        //System.out.printf("\t%s\n", c );
        String insert = String.format("%3d: %5s %d,%d(%d)\t%s\n", emitLoc, op, r, a - (emitLoc + 1), pc, c);
        output.add(insert);

        emitLoc++;

        if (highEmitLoc < emitLoc){
            highEmitLoc = emitLoc;
        }

    }


    /* Routines to maintain the code space */

    public int emitSkip(int distance){
        int i = emitLoc;
        emitLoc += distance;

        if (highEmitLoc < emitLoc){
            highEmitLoc = emitLoc;
        }

        return i;
    }


    /* Routine to generate one line of comment */
    public void emitComment(String c){
        //System.out.printf("* %s\n", c);
        String insert = String.format("* %s\n", c);
        output.add(insert);
    }

    public void emitBackup(int loc){
        if (loc > highEmitLoc){
            emitComment("BUG in emitBackup");
        }
        emitLoc = loc;
    }

    public void emitRestore(){
        emitLoc = highEmitLoc;
    }


    public void printOutput(){
        for (int i = 0; i < output.size(); i++){
            System.out.print(output.get(i));
        }
    }
    

    public void visit(Absyn trees){ // wrapper for post-order traversal
        // generate the prelude
        emitComment("C-Minus Compilation to TM Code");
        emitComment("File: " + CM.filename);
        emitComment("Standard prelude:");
        emitRM("LD", gp, 0, ac, "load gp with maxaddress");
        emitRM("LDA", fp, 0, gp, "copy gp to fp");
        emitRM("ST", ac, 0, ac, "clear value at location 0");
        
        emitSkip(1);
        // generate the i/o routines
        emitComment("Jump around i/o routines here");
        emitComment("Code for input routine");
        emitRM("ST", ac, retFO, fp, "store return");
        emitRO("IN",0, 0, 0, "input");
        emitRM("LD", pc, retFO, fp, "return to caller");

        emitComment("Code for output routine");
        emitRM("ST", ac, retFO, fp, "store return");
        emitRM("LD", ac, initFO, fp, "load output value");
        emitRO("OUT", 0, 0, 0, "output");
        emitRM("LD", pc, retFO, fp, "return to caller");
        
        emitBackup(3);
        emitRM("LDA", pc, pc, pc, "jump around i/o code");

        emitComment("End of standard prelude");
        emitRestore();
        // make a request to the visit method for DecList
        trees.accept(this, 0, false);
        
       
        emitRestore();
        // generate finale
        emitRM("ST", fp, globalOffset+ofpFO, fp, "push ofp");
        emitRM("LDA", fp, globalOffset, fp, "push frame");
        emitRM("LDA", ac, 1, pc, "load ac with ret addr");

        if (mainEntry == -1){
            System.err.println("Error: no main function found. Terminating compilation");
            System.exit(0);
        }

        emitRM_Abs("LDA", pc, mainEntry, "jump to main loc"); // Absolute addressing needed?
        emitRM("LD", fp, ofpFO, fp, "pop frame"); 
        emitComment("End of execution");
        emitRO("HALT", 0, 0, 0, "");
        
        printOutput();
    }



    // implement all visit methods in AbsynVistor
    // note: boolean isAddr is equivalent to boolean isAddress
    // note: int level is equivalent to int offset

    // - Note that  we need to handle the “visit” for
    // SimpleVar differently depending on whether we are computing the lefthand
    // side of AssignExp or not. This is distinguished by “isAddr”
    // parameter in the “visit(Absyn tree, int offset, boolean isAddr)”.
    
    // - The value for “isAddr” is false for most cases except when calling
    // “visit(tree.lhs, offset, true)” of AssignExp, since this is when we need to
    // compute and save the address of a variable into a memory location.
    
    // - For the case of IndexVar, we naturally compute the address of an
    // indexed variable, and that value can be saved directly into a memory
    // location when used in the left-hand side of AssignExp.
    
    // - As a general principle, we use the given location to save the result of an
    // OpExp, and the next two locations for its left and right children. In
    // addition, register “0” is used heavily for the result, which needs to be
    // saved to a memory location as soon as possible.

    // indent method to be used by the methods after
    private void indent( int offset ) {
        for( int i = 0; i < offset * SPACES; i++ ) System.out.print( " " );
    }


    @Override
    public void visit(NameTy type, int offset, boolean isAddr) {
        
        //System.out.print( "NameType: "); 
    }

    @Override
    public void visit(SimpleVar var, int offset, boolean isAddr) {
//       For a VarDec (either SimpleDec or ArrayDec), we need to add “int
//      nestLevel” and “int offset”. The former is either 0 for “global” scope or “1”
//      for “local” scope, and the latter is the offset within the related stackframe
//      for memory access.
//        If “nestLevel = 0” and “offset = -3”, we will go the global frame
//      pointed by ”gp” and its 4th location to read/write data. If “nestLevel = 1”
//      and “offset=-2”, we will go the current stackframe pointed by “fp” and
//      access its third location (right after “ofp”and “return addr”).
        emitComment("looking up id: " + var.name);
        
        int currentFrame = 0;
        
        if (var.dec != null){
            if (var.dec.nestLevel == 0){
                currentFrame = gp;
            } else {
                currentFrame = fp;
            }


            if (isAddr){
                emitRM("LDA", 0, var.dec.offset, currentFrame, "load id address"); // todo: change -2 to actual declaration offset in fp
                //emitRM("ST", 0, offset, currentFrame, "save id address");
            } else {
                emitRM("LD", 0, var.dec.offset, currentFrame, "load id value"); // todo: change -2 to actual declaration offset in fp
                //emitRM("ST", 0, offset, currentFrame, "save id value");
            }
        } else if (var.array != null){
            if (var.array.nestLevel == 0){
                currentFrame = gp;
            } else {
                currentFrame = fp;
            }
            
            if (var.array.isParam == false){
                // emitRM("LDA", 0, var.array.offset + var.array.size - 1, currentFrame, "load id address");
                emitRM("LDA", 0, var.array.offset, currentFrame, "load id address");
            } else {
                emitRM("LD", 0, var.array.offset, currentFrame, "load id value");
            }
            // if (isAddr){
            //     emitRM("LDA", 0, var.array.offset, currentFrame, "load id base address"); // todo: change -2 to actual declaration offset in fp
            //     //emitRM("ST", 0, offset, currentFrame, "save id address");
            // } else {
            //     emitRM("LD", 0, var.array.offset, currentFrame, "load id value"); // todo: change -2 to actual declaration offset in fp
            //     //emitRM("ST", 0, offset, currentFrame, "save id value");
            // }
        }
        
        //System.out.println( "SimpleVar: " + var.name);
    }

    @Override
    public void visit(IndexVar var, int offset, boolean isAddr) {
        
        //System.out.println( "IndexVar: " + var.name); 
        emitComment("* -> subs");
        
        int currentFrame = 0;
        //System.out.println(var.dec);
        
        if (var.dec.nestLevel == 0){
            currentFrame = gp;
        } else {
            currentFrame = fp;
        }
    

        if (isAddr && var.dec.isParam == false){
           // emitRM("LDA", ac, var.dec.offset + var.dec.size - 1, currentFrame, "load id address"); // todo: change -2 to actual declaration offset in fp
           emitRM("LDA", ac, var.dec.offset , currentFrame, "load id address");
            emitRM("ST", 0, offset, fp, "store array address");
        } else if (var.dec.isParam == true) {
            emitRM("LD", ac, var.dec.offset, currentFrame, "load id value");
            emitRM("ST", 0, offset, fp, "store array address");
        } else if (callArgs > 0){
            // emitRM("LDA", ac, var.dec.offset + var.dec.size - 1, currentFrame, "load id address"); // todo: change -2 to actual declaration offset in fp
            emitRM("LDA", ac, var.dec.offset, currentFrame, "load id address");
            emitRM("ST", 0, offset, fp, "store array address");
        } else {
            emitRM("LD", ac, var.dec.offset, currentFrame, "load id value"); // todo: change -2 to actual declaration offset in fp
            emitRM("ST", 0, offset, fp, "store array value");
        }

        if (var.index != null){
          var.index.accept( this, offset, false);
        }

         // var.index.accept will result in a value load in ac
        //emitRM("LDC", ac, var.dec.offset, currentFrame, "load array base offset");
       // emitRM("LDC", ac, 7, ac, "load 7 into ac");
        //  emitRM("LDC", ac1, var.dec.offset, ac1, "load base offset into ac1");
        //  emitRO("SUB", ac, ac1, ac, "move by loaded index value");

        emitRM("JLT", ac, 1, pc, "halt if subscript < 0");
        emitRM("LDA", pc, 1, pc, "absolute jump if not");
        emitRO("HALT", 0, 0, 0, "halt if subscript < 0");
        
        if (var.dec.isParam == false){
            emitRM("LD", ac1, var.dec.offset-1, currentFrame, "load array size");
            emitRO("SUB", ac1, ac1, ac, "compare subscript with size");
            emitRM("JLE", ac1, 1, pc, "halt if subscript equal or greater than size");
            emitRM("LDA", pc, ac1, pc, "absolute jump if not");
            emitRO("HALT", 0, 0, 0, "halt if subscript equal or greater than size");
        } else {
           emitRM("LD", ac1, offset, currentFrame, "load array size");
           emitRM("LDC", 3, 1, 0, "load array size");
           emitRO("SUB", ac1, ac1, 3, "get array size location");
           emitRM("LD", ac1, 0, ac1, "load array size");
           emitRO("SUB", ac1, ac1, ac, "compare subscript with size");
           emitRM("JLE", ac1, 1, pc, "halt if subscript equal or greater than size");
           emitRM("LDA", pc, ac1, pc, "absolute jump if not");
           emitRO("HALT", 0, 0, 0, "halt if subscript equal or greater than size");
        }

        emitRM("LD", ac1, offset, fp, "load array base address");
       // emitRO("SUB", ac, ac1, ac, "base is at the bottom of array");
        emitRO("ADD", ac, ac, ac1, "base is at the bottom of array");
        if (isAddr == false){
            emitRM("LD", ac, ac, ac, "load value at array index");
        }
       
        // if (isAddr){
        //     emitRM("LDA", ac, ac, currentFrame, "load id address"); // todo: change -2 to actual declaration offset in fp
        //     //emitRM("ST", 0, offset, currentFrame, "save id address");
        // } else {
        //     emitRM("LD", ac, ac, currentFrame, "load id value"); // todo: change -2 to actual declaration offset in fp
        //     //emitRM("ST", 0, offset, currentFrame, "save id value");
        // }

        emitComment("*<- subs");
    }

    @Override
    public void visit(NilExp exp, int offset, boolean isAddr) {
        
        //System.out.println( "NilExp"); 
    }

    @Override
    public void visit(IntExp exp, int offset, boolean isAddr) {
        emitComment("-> constant");
       // emitRM("LDC", ac, exp.value, ac, "load const");
        //emitRM("ST", ac, offset, fp, "save value to location " + offset);
        emitRM("LDC", ac, exp.value, ac, "load const");
        emitComment("<- constant");
        //System.out.println( "IntExp: " + exp.value ); 
    }

    @Override
    public void visit(BoolExp exp, int offset, boolean isAddr) {
        
        int value = 0;
        emitComment("-> boolean");
        if (exp.value == true){
            value = 1;
        } else {
            value = 0;
        }


        emitRM("LDC", ac, value, ac, " ");
        //emitRM("ST", ac, offset, fp, "save value to location " + offset);

        emitComment("<- boolean");
        
        //System.out.println( "BoolExp: " + exp.value ); 
    }

    @Override
    public void visit(VarExp exp, int offset, boolean isAddr) {
        emitComment("-> id");
        
        //System.out.println( "VarExp: ");
        
        exp.variable.accept(this,offset, isAddr);

        emitComment("<- id");
    }

    @Override
    public void visit(CallExp exp, int offset, boolean isAddr) {
        emitComment("-> call of function: " + exp.func);
        
        // Iterate through args (which is an expList)
        // <code to compute first arg>
        //emitRM("ST", ac, offset+initFO, fp, "");
        // <code to compute second arg>
       // emitRM("ST", ac, offset+initFO-1, fp, "");
        int address = 0;

        if (exp.func.equals("input")){
            address = 4;
        } else if (exp.func.equals("output")){
            address = 7;
        } else {
            if (exp.dec != null){
                address = exp.dec.funaddr;
            }
        }
       

        callArgs++;
        if (exp.args != null){
           exp.args.accept( this, offset + initFO, isAddr );
        }
        callArgs--;
        
        emitRM("ST", fp, offset+ofpFO, fp, "push ofp");
        emitRM("LDA", fp, offset, fp, "push frame");
        emitRM("LDA", ac, 1, pc, "load ac with ret ptr");

        if (exp.dec != null || exp.func.equals("input") || exp.func.equals("output")){
            emitRM_Abs("LDA", pc, address, "jump to func loc");
        } else if (exp.pro != null){
            emitRM("LD", pc, exp.pro.offset, gp, "load function address");
        }
        
        emitRM("LD", fp, ofpFO, fp, "pop frame");

        if (exp.dec instanceof FunctionDec && exp.dec.result.type != NameTy.VOID){
            emitRM("ST", ac, offset, fp, "save return value to caller's stack frame");
        }

        emitComment("<- call");
    }

    @Override
    public void visit(OpExp exp, int offset, boolean isAddr) {
        emitComment("-> op");
 
        if (exp.left != null){
            exp.left.accept( this, offset, isAddr );
        } 
        emitRM("ST", 0, offset, fp, "op: push left");
        
        if (exp.right != null){
           exp.right.accept( this, offset-1, isAddr );
        }

        //System.out.println(exp.left + " " + exp.right);
        
        emitRM("LD", ac1, offset, fp, "op: load left");

        //emitRM("LD", ac1, offset-1, fp, "load value of right operand");

        if (exp.op == OpExp.PLUS){
            emitRO("ADD", ac, ac1, ac, "op +");
        } else if (exp.op == OpExp.MINUS){
            emitRO("SUB", ac, ac1, ac, "op -");
        } else if (exp.op == OpExp.TIMES){
            emitRO("MUL", ac, ac1, ac, "op *");
        } else if (exp.op == OpExp.DIV){
            emitRO("DIV", ac, ac1, ac, "op /");
        } else if (exp.op == OpExp.EQ){
            emitRO("SUB", ac, ac1, ac, "op ==");
        } else if (exp.op == OpExp.NE){
            emitRO("SUB", ac, ac1, ac, "op !=");
        } else if (exp.op == OpExp.LT){
            emitRO("SUB", ac, ac1, ac, "op <");
        } else if (exp.op == OpExp.LTE){
            emitRO("SUB", ac, ac1, ac, "op <=");
        } else if (exp.op == OpExp.GT){
            emitRO("SUB", ac, ac1, ac, "op >");
        } else if (exp.op == OpExp.GTE){
            emitRO("SUB", ac, ac1, ac, "op >=");
        } else if (exp.op == OpExp.OR){
            emitRO("ADD", ac, ac1, ac, "op ||");
        } else if (exp.op == OpExp.AND){
            emitRO("SUB", ac, ac1, ac, "op &&");
        } else if (exp.op == OpExp.NOT){
            emitRO("SUB", ac, ac1, ac, "op ~");
        } else if (exp.op == OpExp.UMINUS){
            emitRM("LDC", 3, -1, 0, "load -1");
            emitRO("MUL", ac, ac, 3, "op *");
        }
        
        // don't save result if the operation is comparative?
        // if (exp.op < OpExp.EQ || exp.op > OpExp.GTE){
        //     emitRM("ST", ac, offset, fp, "save result in location " + offset);
        // }

        emitComment("<- op");

    }

    @Override
    public void visit(AssignExp exp, int offset, boolean isAddr) {
        //System.out.println("offset: " + offset);
        emitComment("-> op");
        exp.lhs.accept( this, offset, true ); // The value for isAddr is false for most cases except when calling visit(tree.lhs, offset, true) of AssignExp
        emitRM("ST", 0, offset, fp, "op: push left");
        
        exp.rhs.accept( this, offset-1, isAddr );

      //  emitRM("LD", ac, offset-1, fp, "op: load left"); // TODO: fix offset value for left-hand side
       // emitRM("LD", ac1, offset-2, fp, "op: load right");
       
       
       if (exp.lhs.variable instanceof SimpleVar){
        SimpleVar boolVar = (SimpleVar) exp.lhs.variable;
        if (boolVar.dec.type.type == NameTy.BOOL){
            //System.out.println("yes");
            if (exp.rhs instanceof OpExp){
                emitRM_Abs("JGT", ac, emitLoc + 2, "if true, boolean is equal to 1");
                emitRM("LDC", ac, 0, ac, "load 0");
                emitRM_Abs("LDA", pc, emitLoc + 2, "if load 0, jump over load 1 command");
                emitRM("LDC", ac, 1, ac, "load 1");
            }
        }
       }


       emitRM("LD", ac1, offset, fp, "op: load left");
       emitRM("ST", ac, ac, ac1, "assign: store value");
       // emitRM("ST", ac, ac, ac1, "assign: store value");
      //  emitRM("ST", ac1, ac, ac, "save result to register 0");
      //  emitRM("ST", ac1, offset, fp, "save result to location " + offset);
        
        emitComment("<- op");
    }

    @Override
    public void visit(IfExp exp, int offset, boolean isAddr) {
        emitComment("-> if");
        int jump = emitLoc;

        // process condition
        exp.test.accept( this, offset, isAddr );
        emitRM("JNE", ac, jump, pc, "dummy placeholder");
        int conditionLoc = output.size() - 1;
        int oldLoc = emitLoc - 1; // location in emits

        // process code block
        exp.then.accept( this, offset, isAddr );

        jump = emitLoc;
        if (exp.elsepart != null ){
            exp.elsepart.accept( this, offset, isAddr );
         }

        // replace dummy comment with jump command
        if (exp.test instanceof OpExp){
            OpExp test = (OpExp) exp.test;
            // if a given condition, jump upon the opposite condition
            if (test.op == OpExp.EQ){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JNE", ac, jump,  "jump if not equal zero"));
            } else if (test.op == OpExp.NE){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JEQ", ac, jump, "jump if equal zero"));
            } else if (test.op == OpExp.LT){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JGE", ac, jump, "jump if greater than or equal to zero"));
            } else if (test.op == OpExp.LTE){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JGT", ac, jump, "jump if greater than zero"));
            } else if (test.op == OpExp.GT){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JLE", ac, jump,  "jump if less than or equal to zero"));
            } else if (test.op == OpExp.GTE){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JLT", ac, jump,  "jump if less than zero"));
            }
        }  else { // if bool
            output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JEQ", ac, jump, "jump if true"));
        }


        emitComment("<- if");

        


    }

    @Override
    public void visit(WhileExp exp, int offset, boolean isAddr) {
        emitComment("-> while");
        int jump = emitLoc;
        int beginning = emitLoc; // before test
        int oldOffset = offset;
    
        exp.test.accept( this, offset, isAddr );


        emitRM("JNE", ac, jump, pc, "dummy placeholder");
        int conditionLoc = output.size() - 1; // location in arraylist
        int oldLoc = emitLoc - 1; // location in emits
        
        // process code block
        exp.body.accept( this, offset, isAddr );
        //offset = oldOffset;

        // unconditional jump for loop (retest the condition)
        emitRM_Abs("LDA", pc, beginning, "absolute jump to test");
        jump = emitLoc; // end of block
        //System.out.println(jump);

        // replace dummy comment with jump command
        if (exp.test instanceof OpExp){
            //System.out.println("hey");
            OpExp test = (OpExp) exp.test;
            // break if true
            if (test.op == OpExp.EQ){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JNE", ac, jump, "jump if true"));
            } else if (test.op == OpExp.NE){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JEQ", ac, jump,  "jump if true"));
            } else if (test.op == OpExp.LT){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JGE", ac, jump, "jump if true"));
            } else if (test.op == OpExp.LTE){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JGT", ac, jump, "jump if true"));
            } else if (test.op == OpExp.GT){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JLE", ac, jump,  "jump if true"));
            } else if (test.op == OpExp.GTE){
                output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JLT", ac, jump, "jump if true"));
            }
        }  else { // if bool
            output.set(conditionLoc, emitRM_Abs_replacement(oldLoc, "JEQ", ac, jump, "jump if true"));
        }

       

        emitComment("<- while");
    }

    @Override
    public void visit(ReturnExp exp, int offset, boolean isAddr) {
        
        exp.exp.accept( this, offset, isAddr );

        //emitRM("ST", ac, retFO, fp, "store return address");
        emitRM("LD", pc, retFO, fp, "return to caller");

    }

    @Override
    public void visit(CompoundExp exp, int offset, boolean isAddr) {
        emitComment("-> compound statement");
        exp.decs.accept( this, offset, isAddr );

        offset = frameOffset;
        //System.out.println("CompoundExp offset: " + offset);
        exp.exps.accept( this, offset, isAddr );

        emitComment("<- compound statement");
    }

    @Override
    public void visit(FunctionDec dec, int offset, boolean isAddr) {
        emitRestore();
        int savedLoc = emitSkip(1);
        
        //System.out.println( "FunctionDec: " + dec.func);
        offset = initFO; // when entering function the offset is initalized to -2
                        // since 0 and -1 are occupied by ofp and ret-addr 
        frameOffset = initFO;
        currentLevel = 1;
        dec.funaddr = emitLoc;

    
        
        if (dec.func.equals("main")){
            mainEntry = emitLoc;
        }

        emitComment("processing function: " + dec.func);
        if (dec.pro != null){
            emitComment("processing corresponding prototype");
            emitRM("LDC", ac1, emitLoc + 2, ac1, "load function address");
            emitRM("ST", ac1, dec.pro.offset, gp, "save function address in prototype");
        }

        emitComment("jump around function body here");
        emitRM("ST", ac, retFO, fp, "store return");

        if (dec.result != null){
        dec.result.accept( this, offset, isAddr );
        }
        
       
        paramAlloc = true;
        if (dec.params != null){
            dec.params.accept( this, offset, isAddr );
        }
        paramAlloc = false;
        
        //System.out.println(dec.func + " offset :" + offset);
        offset = frameOffset;
        //System.out.println(dec.func + " offset :" + offset);
        if (dec.body != null){
        dec.body.accept( this, offset, isAddr );
        }

        
        emitRM("LD", pc, retFO, fp, "return to caller");
        int end = emitLoc;
        emitBackup(savedLoc);
        emitRM_Abs("LDA", pc, end, "jump around fn body");
        emitComment("Leaving function " + dec.func);
        currentLevel = 0;
    }

    @Override
    public void visit(FunctionPro pro, int offset, boolean isAddr) {
        emitComment("allocating function prototype: " +  pro.func);
        pro.offset = globalOffset;
        globalOffset = globalOffset - 1;
    
        if (pro.result != null){
         // pro.result.accept( this, offset, isAddr );
        }
        
        if (pro.params != null){
         // pro.params.accept( this, offset, isAddr );
        }
        emitComment("<- funcpro");
    }

    @Override
    public void visit(SimpleDec dec, int offset, boolean isAddr) {
        dec.offset = offset;
        dec.nestLevel = currentLevel;

        if (currentLevel == 0){
            dec.offset = globalOffset;
            globalOffset = globalOffset - 1;
        }

        if(currentLevel == 0){
            emitComment("allocating global var: " + dec.name);
            emitComment("<- vardecl");
        }
        else{
            emitComment("processing local var: " + dec.name);
        }
        
        dec.type.accept( this, offset, isAddr );
    }

    @Override
    public void visit(ArrayDec dec, int offset, boolean isAddr) {
        
        if (paramAlloc == false){
            dec.offset = offset - dec.size + 1;
            dec.nestLevel = currentLevel;
            dec.isParam = false;

            int currentFrame = 0;
            
            if (dec.nestLevel == 0){
                emitComment("processing global var: " + dec.name);
                currentFrame = gp;
            } else {
                emitComment("processing local var: " + dec.name);
                currentFrame = fp;
            }

            // add the size of array plus 1 more for the array size
            if (currentLevel == 0){
                dec.offset = globalOffset - dec.size + 1;
                globalOffset = globalOffset - dec.size - 1;
            } else {
                frameOffset = offset - dec.size; // don't include size since there's another counter that accounts for that
            }


            emitRM("LDC", ac1, dec.size, ac1, "load array size");
            if (dec.nestLevel == 0){
                emitRM("ST", ac1, globalOffset+1, currentFrame, "store array size");
            } else {
                emitRM("ST", ac1, frameOffset, currentFrame, "store array size");
            }
        } else {
            dec.offset = offset;
            dec.nestLevel = currentLevel;
            dec.isParam = true;
        }

        dec.type.accept( this, offset, isAddr );
    }

    @Override
    public void visit(DecList exp, int offset, boolean isAddr) {
        while (exp != null){ 
            exp.head.accept( this, offset, isAddr );
            exp = exp.tail;
        }
    }

    @Override
    public void visit(VarDecList exp, int offset, boolean isAddr) {
        while (exp != null){
            if (exp.head != null){ // a hacky method to account for empty strings
              exp.head.accept( this, offset, isAddr );
              offset--;


                if (currentLevel == 1){
                    //System.out.println("offset :" + offset);
                    frameOffset--;
                }
            }
            exp = exp.tail;

       
          }

          
          
    }


    @Override
    public void visit(ExpList expList, int offset, boolean isAddr) {
        while(expList != null) {

            if (expList.head != null){ // a hacky method to account for empty strings
              expList.head.accept( this, offset, isAddr );
              
              if (callArgs > 0){
                emitRM("ST", 0, offset, fp, "store arg val");
                offset--;
              }

            }
      
            expList = expList.tail;
          } 
    }
    
}
