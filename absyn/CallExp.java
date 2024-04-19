package absyn;

public class CallExp extends Exp {
  public String func;
  public ExpList args;
  public FunctionDec dec; // link to declaration
  public FunctionPro pro; // link to prototype

  public CallExp( int row, int col, String func, ExpList args ) {
    this.row = row;
    this.col = col;
    this.func = func;
    this.args = args;
    this.dec = null;
  }

  public void accept( AbsynVisitor visitor, int level, boolean flag  ) {
    visitor.visit( this, level, flag );
  }
}
