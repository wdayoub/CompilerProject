package absyn;

public class VarExp extends Exp {
  public Var variable;

  public VarExp( int row, int col, Var variable ) {
    this.row = row;
    this.col = col;
    this.variable = variable;
  }

  public void accept( AbsynVisitor visitor, int level, boolean flag  ) {
    visitor.visit( this, level, flag );
  }
}
