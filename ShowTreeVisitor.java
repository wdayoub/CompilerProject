import absyn.*;

/* Checkpoint 1
  Student Names: Wisam Dayoub, Sam Engel, Affan Khan
  Course Name: CIS 4650
  Due Date: March 4th, 2023

  Based on starter code created by Fei Song
*/


// This class is full of visit implementations for each class in the absyn package
// You can find the declarations for these methods in AbsynVistor.java


// the absyn class the visit method is for will be the first argument
// for example: public void visit(NameTy type, int level) is for the absyn class NameTy

// a visit function for a class seems to follow this format:
// indent(level);
// System.out.println("classname" + value/variable/func)
// 
// and if an arguments for the class is another absyn class, then:
// level++
// classArgName.absynClassVariable.accept(this, level)    | do this for each absyn argument


// The image file Class-Based AST for C can serve as a rough cheat sheet for what arguments 
// are used for each absyn class though occasionally the argument names may not be the exact same
// for instance: for IfExp, the 'Exp else' argument is actually called 'elsepart' since
// Java reserves the word 'else', so it couldn't be used as a variable/argument name


public class ShowTreeVisitor implements AbsynVisitor {

  final static int SPACES = 4;

  // indent method to be used by the methods after
  private void indent( int level ) {
    for( int i = 0; i < level * SPACES; i++ ) System.out.print( " " );
  }


  // NameTy
  @Override
  public void visit(NameTy type, int level, boolean flag ) {
    indent( level );
    System.out.print( "NameType: "); 

    switch(type.type) {
      case NameTy.BOOL:
        System.out.print( "boolean\n" );
        break;
      case NameTy.INT:
        System.out.print( "int\n" );
        break;
      case NameTy.VOID:
        System.out.print( "void\n" );
        break;
      default:
        System.out.println( "Unrecognized type at line " + type.row + " and column " + type.col);
    }
  }


  // Var subclasses
  // SIimpleVar
  @Override
  public void visit(SimpleVar var, int level, boolean flag ) {
    indent( level );
    System.out.println( "SimpleVar: " + var.name); 
  }


  // IndexExp
  @Override
  public void visit(IndexVar var, int level, boolean flag ) {
    indent( level );
    System.out.println( "IndexVar: " + var.name); 

    level++;
    if (var.index != null){
      var.index.accept( this, level, flag);
    }
  }



  // Exp subclasses
  // NilExp
  @Override
  public void visit(NilExp exp, int level, boolean flag ) {
    indent( level );
    System.out.println( "NilExp"); 
  }


  // IntExp
  public void visit( IntExp exp, int level, boolean flag  ) {
    indent( level );
    System.out.println( "IntExp: " + exp.value ); 
  }

  // BoolExp
  @Override
  public void visit(BoolExp exp, int level, boolean flag ) {
    indent( level );
    System.out.println( "BoolExp: " + exp.value ); 
  }


  // VarExp
  public void visit( VarExp exp, int level, boolean flag  ) {
    indent( level );
    System.out.println( "VarExp: ");

    level++;
    exp.variable.accept(this,level, flag);
  }


  // CallExp
  @Override
  public void visit(CallExp exp, int level, boolean flag ) {
    indent( level );
    System.out.println( "CallExp: " + exp.func);
    
    // Iterate through args (which is an expList)
    level++;
    if (exp.args != null){
       exp.args.accept( this, level, flag );
    }

  }


  // OpExp
  public void visit( OpExp exp, int level, boolean flag  ) {
    indent( level );
    System.out.print( "OpExp:" ); 
    switch( exp.op ) {
      case OpExp.PLUS:
        System.out.println( " + " );
        break;
      case OpExp.MINUS:
        System.out.println( " - " );
        break;
      case OpExp.TIMES:
        System.out.println( " * " );
        break;
      case OpExp.DIV:
        System.out.println( " / " );
        break;
      case OpExp.EQ:
        System.out.println( " == " );
        break;
      case OpExp.NE:
        System.out.println( " != " );
        break;
      case OpExp.LT:
        System.out.println( " < " );
        break;
      case OpExp.LTE:
        System.out.println( " <= " );
        break;
      case OpExp.GT:
        System.out.println( " > " );
        break;
      case OpExp.GTE:
        System.out.println( " >= " );
        break;
      case OpExp.NOT:
        System.out.println( " != " );
        break;
      case OpExp.AND:
        System.out.println( " && " );
        break;
      case OpExp.OR:
        System.out.println( " || " );
        break;
      case OpExp.UMINUS:
        System.out.println( " - " );
        break;
      default:
        System.out.println( "Unrecognized operator at line " + exp.row + " and column " + exp.col);
    }
    level++;
    if (exp.left != null) 
       exp.left.accept( this, level, flag );
    if (exp.right != null)
       exp.right.accept( this, level, flag );
  }


  // AssignExp
  public void visit( AssignExp exp, int level, boolean flag ) {
    indent( level );
    System.out.println( "AssignExp:" );
    level++;
    exp.lhs.accept( this, level, flag );
    exp.rhs.accept( this, level, flag );
  }


  // IfExp
  public void visit( IfExp exp, int level, boolean flag) {
    indent( level );
    System.out.println( "IfExp:" );
    level++;
    exp.test.accept( this, level, flag );
    exp.then.accept( this, level, flag );
    if (exp.elsepart != null )
       exp.elsepart.accept( this, level, flag );
  }

  // WhileExp
  @Override
  public void visit(WhileExp exp, int level, boolean flag ) {
    indent( level );
    System.out.println( "WhileExp:" );

    level++;
    exp.test.accept( this, level, flag );
    exp.body.accept( this, level, flag );
  }

  // ReturnExp
  @Override
  public void visit(ReturnExp exp, int level, boolean flag ) {
    indent( level );
    System.out.println( "ReturnExp" );
    level++;
    exp.exp.accept( this, level, flag );
  }

  // CompoundExp
  @Override
  public void visit(CompoundExp exp, int level, boolean flag ) {
    indent( level );
    System.out.println( "CompoundExp:");
    level++;
    
    exp.decs.accept( this, level, flag );
    exp.exps.accept( this, level, flag );
  }


  // Dec subclass
  // FunctionDec
  @Override
  public void visit(FunctionDec dec, int level, boolean flag ) {
    indent( level );
    System.out.println( "FunctionDec: " + dec.func);

    level++;
    if (dec.result != null){
      dec.result.accept( this, level, flag );
    }
    
    if (dec.params != null){
      dec.params.accept( this, level, flag );
    }

    if (dec.body != null){
      dec.body.accept( this, level, flag );
    }
  }

  // Dec subclass
  // FunctionPro
  @Override
  public void visit(FunctionPro pro, int level, boolean flag ) {
    indent( level );
    System.out.println( "FunctionPro: " + pro.func);

    level++;
    if (pro.result != null){
      pro.result.accept( this, level, flag );
    }
    
    if (pro.params != null){
      pro.params.accept( this, level, flag );
    }

  }


  // VarDec subclasses
  // SimpleDec
  @Override
  public void visit(SimpleDec dec, int level, boolean flag ) {
    indent( level );
    System.out.println( "SimpleDec: " + dec.name);
    
    level++;
    dec.type.accept( this, level, flag );
  }

  // ArrayDec
  @Override
  public void visit(ArrayDec dec, int level, boolean flag ) {
    indent( level );
    System.out.println( "ArrayDec: " + dec.name);

    level++;
    dec.type.accept( this, level, flag );
  }


  // miscellaneous classes
  // DecList
  @Override
  public void visit(DecList exp, int level, boolean flag ) {
    //System.out.println("DecList");
    while (exp != null){ 
      exp.head.accept( this, level, flag );
      exp = exp.tail;
    }
  }

  @Override
  // VarDecList
  public void visit(VarDecList exp, int level, boolean flag ) {
    //System.out.println("VarDecList " + exp.head + " " + exp.tail);
    while (exp != null){

      if (exp.head != null){ // a hacky method to account for empty strings
        exp.head.accept( this, level, flag );
      }

      exp = exp.tail;
    }
  }


  // ExpList
  public void visit( ExpList expList, int level, boolean flag  ) {
    //System.out.println("ExpList");
    while(expList != null) {

      if (expList.head != null){ // a hacky method to account for empty strings
        expList.head.accept( this, level, flag );
      }

      expList = expList.tail;
    } 
  }


  @Override
  public void visit(Absyn trees) {
    // TODO Auto-generated method stub
    throw new UnsupportedOperationException("Unimplemented method 'visit'");
  }



  // tiny legacy methods (for reference purposes)
  // public void visit( ReadExp exp, int level ) {
  //   indent( level );
  //   System.out.println( "ReadExp:" );
  //   exp.input.accept( this, ++level );
  // }

  // public void visit( RepeatExp exp, int level ) {
  //   indent( level );
  //   System.out.println( "RepeatExp:" );
  //   level++;
  //   exp.exps.accept( this, level );
  //   exp.test.accept( this, level ); 
  // }



  // public void visit( WriteExp exp, int level ) {
  //   indent( level );
  //   System.out.println( "WriteExp:" );
  //   if (exp.output != null)
  //      exp.output.accept( this, ++level );
  // }

}
