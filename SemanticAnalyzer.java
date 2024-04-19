/* Checkpoint 2
  Student Names: Wisam Dayoub, Sam Engel, Affan Khan
  Course Name: CIS 4650
  Due Date: March 18th, 2023

  Based on starter code created by Fei Song
*/


import java.util.*;
import java.io.*;
import absyn.*;

// Symbol table structure: HashMap<String, ArrayList<NodeType>> table;
//  Initialized in the related constructor
//  Accessed by the utility methods for “insert”, ”lookup”, and “delete” operations

// “visit” methods that traverse the syntax trees in the post-order:
// - Display the entry and exit points for the scoping structures: global, function, and blocks
// - Add name-def pairs to ”table” for “Dec” nodes
// - Do type-checking for ”Exp” nodes

public class SemanticAnalyzer implements AbsynVisitor {

    final static int SPACES = 4;

    public static boolean valid = true;

    private HashMap<String, ArrayList<NodeType>> table = new HashMap<>();

    private NameTy currentFunctionReturnType = null;

    // put a declaration node into the hash table
    public void insert(String key, NodeType value) {

        // check if value's declaration is void and not a function
        if (value.def instanceof FunctionDec == false &&
                value.def instanceof FunctionPro == false) {

            if (value.def instanceof SimpleDec) {
                SimpleDec simple = (SimpleDec) value.def;
                if (simple.type.type == NameTy.VOID) {
                    System.out.println("Error: invalid type for " + value.name + " at line " + (simple.row + 1)
                            + " and column " + (simple.col + 1));
                    //System.exit(0);
                    valid = false;

                    // "For error recovery, we can change void to int for the related declarations"
                    simple.type.type = NameTy.INT;
                    value = new NodeType(value.name, simple, value.level);
                }
            } else {
                ArrayDec array = (ArrayDec) value.def;
                if (array.type.type == NameTy.VOID) {
                    System.out.println("Error: invalid type for " + value.name + " at line " + (array.row + 1) + " and column "
                            + (array.col + 1));
                    //System.exit(0);
                    valid = false;
                    
                    // "For error recovery, we can change void to int for the related declarations"
                    array.type.type = NameTy.INT;
                    value = new NodeType(value.name, array, value.level);
                }
            }
        }

        // if key place is occupied, append to start of existing arraylist
        if (table.containsKey(key)) {
            ArrayList<NodeType> match = table.get(key);
            match.add(0, value);
            table.replace(key, match);
        } else { // if key place is empty, make new arraylist
            ArrayList<NodeType> newList = new ArrayList<>();
            newList.add(value);
            table.put(key, newList);
        }
    }

    // deletes nodes matching a certain key at a certain level
    public void delete(String key, int level) {
        if (table.containsKey(key)) {
            ArrayList<NodeType> match = table.get(key);

            for (int i = 0; i < match.size(); i++) {
                if (match.get(i).level == level) {
                    match.remove(i);
                }

            }
        }
    }

    // define lookup method
    public boolean lookup(String name, int level) {
        // see if there's a node of the same name at the same level
        if (table.containsKey(name)) {
            ArrayList<NodeType> match = table.get(name);

            for (int i = 0; i < match.size(); i++) {
                if (name.equals(match.get(i).name) && match.get(i).level == level) {
                    return true;
                }
            }
        }
        return false;
    }

    // print all keys and their types at a certain level
    public void showContents(int level) {
        for (String i : table.keySet()) {
            String name = "";
            String type = "";
            ArrayList<NodeType> current = table.get(i);

            // find corresponding nodetype
            for (int j = 0; j < current.size(); j++) {
                // if the key has a node at the level, print it
                if (current.get(j).level == level) {
                    name = current.get(j).name;

                    // note, for the type retrieval below:
                    // tried to put a NameTy type attribute for the Dec superclass (and assigning
                    // result to type for functions) so this process would be streamlined
                    // as in, to get the type it would simply be a matter of
                    // current.get(j).type.type to get access to the int type value instead of
                    // needing to cast it first
                    // but that only resulted in a NullPointerException, so here we are:

                    // check if def is SimpleDec
                    if (current.get(j).def instanceof SimpleDec) {
                        SimpleDec dec = (SimpleDec) current.get(j).def; // cast from Dec to SimpleDec to get access to
                                                                        // type attribute
                        type = getTypeString(dec.type);
                    }

                    // check if def is ArrayDec
                    if (current.get(j).def instanceof ArrayDec) {
                        ArrayDec dec = (ArrayDec) current.get(j).def; // cast from Dec to ArrayDec to get access to type
                                                                      // attribute
                        type = getTypeString(dec.type);
                        type = type + "[]";
                    }

                    // if the declaration is a function
                    if (current.get(j).def instanceof FunctionDec) {
                        FunctionDec dec = (FunctionDec) current.get(j).def; // cast from Dec to FunctionDec to get
                                                                            // access to result attribute
                        type = getTypeString(dec.result);
                        type = type + " function";
                    }

                    // if the declaration is a function prototype
                    if (current.get(j).def instanceof FunctionPro) {
                        FunctionPro dec = (FunctionPro) current.get(j).def; // cast from Dec to FunctionPro to get
                                                                            // access to result attribute
                        type = getTypeString(dec.result);
                        type = type + " function";
                    }

                    indent(level);
                    System.out.println(name + ": " + type);
                }
            }
        }
    }

    public String getTypeString(NameTy type) {
        String typeString = "";

        if (type.type == NameTy.BOOL) {
            typeString = "bool";
        }

        if (type.type == NameTy.INT) {
            typeString = "int";
        }

        if (type.type == NameTy.VOID) {
            typeString = "void";
        }

        return typeString;

    }

    // remove all nodes at a certain level
    public void removeContents(int level) {
        for (String i : table.keySet()) {
            delete(i, level);
        }
    }

    // indent method to be used by the methods after
    private void indent(int level) {
        for (int i = 0; i < level * SPACES; i++)
            System.out.print(" ");
    }

    // returns the SimpleDec from a variable name in a scope
    private SimpleDec getSimpleDecType(String variable) {
        ArrayList<NodeType> entries = table.get(variable);
        if (entries == null) {
            return null;
        }

        for (NodeType entry : entries) {
            if (variable.equals(entry.name) && (entry.def instanceof SimpleDec)) {
                SimpleDec dec = (SimpleDec) entry.def;
                return dec;
            }
        }

        return null;
    }

    // returns the SimpleDec from a variable name in a scope
    private ArrayDec getArrayDecType(String variable) {
            ArrayList<NodeType> entries = table.get(variable);
            if (entries == null) {
                return null;
            }
    
            for (NodeType entry : entries) {
                if (variable.equals(entry.name) && (entry.def instanceof ArrayDec)) {
                    ArrayDec dec = (ArrayDec) entry.def;
                    return dec;
                }
            }
    
            return null;
    }


    // helper function to link callExp with function its calling
    private FunctionDec getFunctionDec(String function){
        ArrayList<NodeType> entries = table.get(function);
        if (entries == null) {
            return null;
        }

        for (NodeType entry : entries) {
            if (function.equals(entry.name) && (entry.def instanceof FunctionDec)) {
                FunctionDec dec = (FunctionDec) entry.def;
                return dec;
            }
        }

        return null;

    }

    private int countFunctionParams(Dec dec) {
        int count = 0;
        if (dec instanceof FunctionDec) {
            VarDecList params = ((FunctionDec) dec).params;
            while (params != null) {
                count++;
                params = params.tail;
            }
        } else if (dec instanceof FunctionPro) {
            VarDecList params = ((FunctionPro) dec).params;
            while (params != null) {
                count++;
                params = params.tail;
            }
        }
        return count;
    }

    // helper function to get the length of ExpList arguments
    private int length(ExpList list) {
        int length = 0;
        while (list != null) {
            length++;
            list = list.tail;
        }
        return length;
    }

    // helper function to link callExp with function its calling
    private FunctionPro getFunctionPro(String function){
        ArrayList<NodeType> entries = table.get(function);
        if (entries == null) {
            return null;
        }

        for (NodeType entry : entries) {
            if (function.equals(entry.name) && (entry.def instanceof FunctionPro)) {
                FunctionPro dec = (FunctionPro) entry.def;
                return dec;
            }
        }

        return null;

    }

    // method to get the return type of a function by its name
    private NameTy getFunctionReturnType(String functionName) {
        ArrayList<NodeType> entries = table.get(functionName);
        if (functionName.equals("input")){
            NameTy ret = new NameTy(0, 0, NameTy.INT);
            return ret;
        }


        if (entries != null) {
            for (NodeType entry : entries) {
                if (entry.def instanceof FunctionDec) {
                    FunctionDec dec = (FunctionDec) entry.def;
                    return dec.result;
                }
            }
        }
        return null;
    }

    
    private boolean isIndexExpressionInteger(Exp exp) {
        if (exp instanceof IntExp) {
            return true;
        } else if (exp instanceof VarExp) {
            VarExp varExp = (VarExp) exp;

            if (varExp.variable instanceof SimpleVar) {
                SimpleVar simpleVar = (SimpleVar) varExp.variable;
                SimpleDec dec = getSimpleDecType(simpleVar.name);
                return dec != null && dec.type.type == NameTy.INT;
            }
        } else if (exp instanceof CallExp) {
            CallExp callExp = (CallExp) exp;
            NameTy returnType = getFunctionReturnType(callExp.func);
            return returnType != null && returnType.type == NameTy.INT;
        }

        return false;
    }

    private NameTy getTypeOfExpression(Exp exp) {
        if (exp instanceof VarExp) {
            VarExp varExp = (VarExp) exp;
            if (varExp.variable instanceof SimpleVar) {
                SimpleVar simpleVar = (SimpleVar) varExp.variable;
                SimpleDec dec = getSimpleDecType(simpleVar.name);
                //System.out.println(dec.type.type);
                if (dec != null) {
                    return dec.type;
                }
            } else if (varExp.variable instanceof IndexVar){
                IndexVar indexVar = (IndexVar) varExp.variable;
                ArrayDec dec = getArrayDecType(indexVar.name);
                if (dec != null) {
                    return dec.type;
                }
            }
        } else if (exp instanceof CallExp) {
            CallExp callExp = (CallExp) exp;
            return getFunctionReturnType(callExp.func);
        } else if (exp instanceof IntExp){
            NameTy type = new NameTy(exp.row, exp.col, NameTy.INT);
            return type;
        } else if (exp instanceof BoolExp){
            NameTy type = new NameTy(exp.row, exp.col, NameTy.BOOL);
            return type;
        } else if (exp instanceof OpExp){ 
            OpExp op = (OpExp) exp;
            // for signed factors and OpExp assignments in general
            if (((op.left instanceof NilExp) || (op.left instanceof IntExp)) && (op.right instanceof IntExp)){
                NameTy type = new NameTy(exp.row, exp.col, NameTy.INT);
                return type;
            }

            NameTy leftType = getTypeOfExpression(op.left);
            NameTy rightType = getTypeOfExpression(op.right);

            if ((leftType != null) && (rightType != null) && (leftType.type == rightType.type) && leftType.type == NameTy.INT){
                NameTy type = new NameTy(exp.row, exp.col, NameTy.INT);
                return type;
            }


        } 

        return null;
    }

    private boolean isTypeCompatible(NameTy lhs, NameTy rhs) {
        if (lhs.type == rhs.type) {
            return true;
        }

        if (lhs.type == NameTy.INT && rhs.type == NameTy.INT) {
            return true;
        }

        // Return false if none of the compatibility rules match
        return false;
    }

    @Override
    public void visit(NameTy type, int level, boolean flag ) {
        // indent( level );
        // System.out.print( "NameType: ");
    }

    @Override
    public void visit(SimpleVar var, int level, boolean flag ) {
        // System.out.println( "SimpleVar: " + var.name);
        
        // link dec with var for CodeGenerator
        if (var.dec == null){
            var.dec = getSimpleDecType(var.name);
        }

        // if no dec is found, find an array declaration
        if (var.dec == null){
            var.array = getArrayDecType(var.name);
        }
    }

    @Override
    public void visit(IndexVar var, int level, boolean flag ) {
        //System.out.println( "IndexVar: " + var.name);

        if (var.dec == null){
           // System.out.println(var.name);
            var.dec = getArrayDecType(var.name);
        }

        // level++;
        if (var.index != null) {
            var.index.accept(this, level, flag);
        }
        // TODO
        if (!isIndexExpressionInteger(var.index)) {
            int errorLine = var.row + 1;
            System.out.println("Error: Array index must be of type int at line " + errorLine + "and column " + (var.col + 1));
            valid = false;
            //System.exit(0);

        }
    }

    // Do Type-Checking for Exp Nodes
    // Type Checking: use type information to ensure that all constructs are valid
    // under the type rules
    // For example: boolean variables can't be added and integer variables can be
    // or'ed
    // Add boolean methods such as “isInteger(Dec dectype)” in SemanticAnalyzer.java
    // to simplify the code for type checking

    @Override
    public void visit(NilExp exp, int level, boolean flag ) {
    }

    @Override
    public void visit(IntExp exp, int level, boolean flag ) {
        // indent( level );
        // System.out.println( "IntExp: " + exp.value );
    }

    @Override
    public void visit(BoolExp exp, int level, boolean flag ) {
        // indent( level );
        // System.out.println( "BoolExp: " + exp.value );
    }

    @Override
    public void visit(VarExp exp, int level, boolean flag ) {
        if(exp.variable instanceof SimpleVar){
            SimpleVar simpleVar = (SimpleVar) exp.variable;
            int tempLevel = level;

            //checks if the variable exists in all levels of the scopes before accepting
            while(tempLevel >= 0){
                if(lookup(simpleVar.name, tempLevel)){
                    exp.variable.accept(this,level, flag);
                    return;   
                }
                tempLevel--;
            }

            //if not found defined in scope and previous scopes display error
            System.out.println("Error: Undefined variable '" + simpleVar.name + "' detected at line " + (simpleVar.row + 1) + " and column " + (simpleVar.col + 1) +".");
            //System.exit(0);
        } else if (exp.variable instanceof IndexVar){
            IndexVar indexVar = (IndexVar) exp.variable;
            int tempLevel = level;

            //checks if the variable exists in all levels of the scopes before accepting
            while(tempLevel >= 0){
                if(lookup(indexVar.name, tempLevel)){
                    exp.variable.accept(this,level, flag);
                    return;   
                }
                tempLevel--;
            }

            //if not found defined in scope and previous scopes display error
            System.out.println("Error: Undefined variable '" + indexVar.name + "' detected at line " + (indexVar.row + 1) + " and column " + (indexVar.col + 1) +".");
            //System.exit(0);

        }



    }

    @Override
    public void visit(CallExp exp, int level, boolean flag ) {
        // link CallExp to function for CodeGenerator
        if (exp.dec == null){
            exp.dec = getFunctionDec(exp.func);
        }

        if (exp.pro == null){
            exp.pro = getFunctionPro(exp.func);
        }

        int argsLength = length(exp.args);
        // Special handling for the output() function
        if ("output".equals(exp.func)) {
            if (argsLength != 1) {
                System.out.println("Error: Mismatch in the number of arguments for function call '" + exp.func
                    + "'. Expected 1, got " + argsLength + " at line " + (exp.row + 1) + " and column " + (exp.col + 1) + ".");
                valid = false;
            }
        } else {
            Dec functionDec = exp.dec != null ? exp.dec : exp.pro; // Use the function declaration or prototype
            int paramsCount = countFunctionParams(functionDec);
            if (argsLength != paramsCount) {
                System.out.println("Error: Mismatch in the number of arguments for function call '" + exp.func
                    + "'. Expected " + paramsCount + ", got " + argsLength + " at line " + (exp.row + 1) + " and column " + (exp.col + 1) + ".");
                valid = false;
            }
        }


        if (exp.args != null) {
            exp.args.accept(this, level, flag);
        }
    }

    @Override
    public void visit(OpExp exp, int level, boolean flag ) {
        if (exp.left != null) {
            exp.left.accept(this, level, flag);
        }

        if (exp.right != null) {
            exp.right.accept(this, level, flag);
        }
        // Perform type checking for the operands
        NameTy leftType = getTypeOfExpression(exp.left);
        NameTy rightType = getTypeOfExpression(exp.right);

        //System.out.println(leftType.type + " " + rightType.type);

        boolean isValidOperation = false;

        // for signed factors
        if ((exp.left instanceof NilExp) && (exp.right instanceof IntExp) && (exp.op == OpExp.UMINUS)){
            isValidOperation = true;
        }

        // everything else
        if (leftType != null && rightType != null && leftType.type == rightType.type) {
            //System.out.println("here");
            if (exp.op >= OpExp.PLUS && exp.op <= OpExp.DIV) {
                isValidOperation = leftType.type == NameTy.INT;
            } else if (exp.op >= OpExp.EQ && exp.op < OpExp.UMINUS) {
                isValidOperation = true;
            } 

        }

        if (!isValidOperation) {
            System.out.println("Type Error: Incompatible types for operation at line " + (exp.row + 1) + " and column " + (exp.col + 1));
            valid = false;
            //System.exit(0);
        }

    }

    @Override
    public void visit(AssignExp exp, int level, boolean flag ) {
        exp.lhs.accept(this, level, flag);
        exp.rhs.accept(this, level, flag);
        // Determine the types of LHS and RHS of the assignment
        NameTy lhsType = getTypeOfExpression(exp.lhs);
        NameTy rhsType = getTypeOfExpression(exp.rhs);


        if (lhsType == null || rhsType == null) {
            System.out.println(
                    "Type Error: One of the types in the assignment at line " + (exp.row + 1) + " and column " + (exp.col + 1) + " is unknown.");
            valid = false;
            //System.exit(0);
        } else if (lhsType.type == NameTy.BOOL && exp.rhs instanceof OpExp){ // accept int operation with a comparative operator
            OpExp op = (OpExp) exp.rhs;
            if (op.op >= OpExp.EQ && op.op < OpExp.UMINUS){
                valid = true;
            }
        } else if (!isTypeCompatible(lhsType, rhsType)) {
            System.out.println("Type Error: Assignment type mismatch at line " + (exp.row + 1) + " and column " + (exp.col + 1));
            valid = false;
            //System.exit(0);
        }
    }

    @Override
    public void visit(IfExp exp, int level, boolean flag ) {
        indent(level);
        System.out.println("Entering a new block:");

        //checks to see if the test expression is a Callexp, makes sure only ints and bools are inside test expression
        if(exp.test instanceof CallExp){
            CallExp temp = (CallExp) exp.test;
            NameTy retType = getTypeOfExpression(exp.test);
            
            if (retType == null || retType.type != NameTy.BOOL && retType.type != NameTy.INT){
                System.out.println("Type Error: Test condition on line " + (temp.row + 1) + " and column " + (temp.col + 1) + " must be of type int or bool.");
                valid = false;
                //System.exit(0);
            }
        }

        exp.test.accept(this, level + 1, flag);
        exp.then.accept(this, level + 1, flag);
        if (exp.elsepart != null) {
            exp.elsepart.accept(this, level, flag);
        }

        showContents(level + 1);
        removeContents(level + 1);

        indent(level);
        System.out.println("Leaving the block");
    }

    @Override
    public void visit(WhileExp exp, int level, boolean flag ) {
        indent(level);
        System.out.println("Entering a new block:");

        //checks to see if the test expression is a Callexp, makes sure only ints and bools are inside test expression
        if(exp.test instanceof CallExp){
            CallExp temp = (CallExp) exp.test;
            NameTy retType = getTypeOfExpression(exp.test);
            
            if (retType == null || retType.type != NameTy.BOOL && retType.type != NameTy.INT){
                System.out.println("Type Error: Test condition on line " + (temp.row + 1)  + " and column " + (temp.col + 1) + " must be of type int or bool.");
                valid = false;
                //System.exit(0);
            }
            
        }

        exp.test.accept(this, level + 1, flag);
        exp.body.accept(this, level + 1, flag);

        showContents(level + 1);
        removeContents(level + 1);

        indent(level);
        System.out.println("Leaving the block");
    }

    @Override
    public void visit(ReturnExp exp, int level, boolean flag ) {
        exp.exp.accept(this, level, flag);

        if (exp.exp instanceof VarExp) {
            VarExp varExp = (VarExp) exp.exp;
            if (varExp.variable instanceof SimpleVar) {
                SimpleVar simpleVar = (SimpleVar) varExp.variable;
                SimpleDec dec = getSimpleDecType(simpleVar.name);

                NameTy varType = dec.type;
                if (varType.type != currentFunctionReturnType.type) {
                    indent(level);
                    System.out.println("Type Error: Return type mismatch, return type of '" + simpleVar.name
                            + "' does not match the function's return type.");
                    valid = false;
                    //System.exit(0);
                }
            }
        }
    }

    @Override
    public void visit(CompoundExp exp, int level, boolean flag ) {
        exp.decs.accept(this, level, flag);
        exp.exps.accept(this, level, flag);
    }

    // // Add name-def pairs to table for Dec nodes
    @Override
    public void visit(FunctionDec dec, int level, boolean flag ) {
        if (dec.pro == null){ // link to function prototype
            dec.pro = getFunctionPro(dec.func);
        }

        // Add name-def pair to table for Dec nodes
        insert(dec.func, new NodeType(dec.func, dec, level));

        currentFunctionReturnType = dec.result;

        indent(level);
        System.out.println("Entering the scope for function " + dec.func + ":");

        if (dec.result != null) {
            dec.result.accept(this, level + 1, flag);
        }

        if (dec.params != null) {
            dec.params.accept(this, level + 1, flag);
        }

        if (dec.body != null) {
            dec.body.accept(this, level + 1, flag);
        }

        showContents(level + 1);
        removeContents(level + 1);

        indent(level);
        System.out.println("Leaving the function scope");

        currentFunctionReturnType = null;
    }

    @Override
    public void visit(FunctionPro pro, int level, boolean flag ) {

        // Add name-def pair to table for Dec nodes
        insert(pro.func, new NodeType(pro.func, pro, level));

        if (pro.result != null) {
            pro.result.accept(this, level + 1, flag);
        }

        if (pro.params != null) {
            //pro.params.accept(this, level + 1);
        }
    }

    @Override
    public void visit(SimpleDec dec, int level, boolean flag ) {
        // indent( level );
        // System.out.println( "SimpleDec: " + dec.name);

        // check if name-def of variable already exists inside scope
        if (!lookup(dec.name, level)) {
            // Add name-def pair to table for Dec nodes
            insert(dec.name, new NodeType(dec.name, dec, level));
        } else {
            System.out.println("Error: Duplicate variable name '" + dec.name + "' detected.");
            valid = false;
            //System.exit(0);
        }

        // level++;
        dec.type.accept(this, level, flag);
    }

    @Override
    public void visit(ArrayDec dec, int level, boolean flag ) {
        indent(level);
        // System.out.println( "ArrayDec: " + dec.name);

        // Add name-def pair to table for Dec nodes
        insert(dec.name, new NodeType(dec.name, dec, level));

        // level++;
        dec.type.accept(this, level, flag);
    }

    // miscellaneous classes
    @Override
    public void visit(DecList exp, int level, boolean flag ) {
        System.out.println("Entering the global scope:");

        level++;
        while (exp != null) {
            exp.head.accept(this, level, flag);
            exp = exp.tail;
        }

        showContents(level);
        removeContents(level);
        System.out.println("Leaving the global scope");
    }

    @Override
    public void visit(VarDecList exp, int level, boolean flag ) {
        while (exp != null) {

            if (exp.head != null) { // a hacky method to account for empty strings
                exp.head.accept(this, level, flag);
            }

            exp = exp.tail;
        }

    }

    @Override
    public void visit(ExpList expList, int level, boolean flag ) {
        while (expList != null) {

            if (expList.head != null) { // a hacky method to account for empty strings
                expList.head.accept(this, level, flag);
            }

            expList = expList.tail;
        }
    }

    @Override
    public void visit(Absyn trees) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'visit'");
    }

}
