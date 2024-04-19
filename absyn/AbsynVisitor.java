package absyn;

public interface AbsynVisitor {

  public void visit(Absyn trees);

  public void visit( NameTy type, int level, boolean flag );


  // Var subclasses
  public void visit( SimpleVar var, int level, boolean flag );

  public void visit( IndexVar var, int level, boolean flag );


  // Exp subclasses
  public void visit( NilExp exp, int level, boolean flag );

  public void visit( IntExp exp, int level, boolean flag );

  public void visit( BoolExp exp, int level, boolean flag );

  public void visit( VarExp exp, int level, boolean flag );

  public void visit( CallExp exp, int level, boolean flag );

  public void visit( OpExp exp, int level, boolean flag );

  public void visit( AssignExp exp, int level, boolean flag );

  public void visit( IfExp exp, int level, boolean flag );

  public void visit( WhileExp exp, int level, boolean flag );

  public void visit( ReturnExp exp, int level, boolean flag );

  public void visit( CompoundExp exp, int level, boolean flag );


  // Dec subclass
  public void visit( FunctionDec dec, int level, boolean flag );

  public void visit( FunctionPro dec, int level, boolean flag );


  // VarDec subclasses
  public void visit( SimpleDec dec, int level, boolean flag );
    
  public void visit( ArrayDec dec, int level, boolean flag );


  // miscellaneous classes
  public void visit( DecList exp, int level, boolean flag );
    
  public void visit( VarDecList exp, int level, boolean flag );
    
  public void visit( ExpList exp, int level, boolean flag );

  

}
