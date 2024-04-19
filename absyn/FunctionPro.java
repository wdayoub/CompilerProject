package absyn;

public class FunctionPro extends Dec {
  public NameTy result;
  public String func;
  public VarDecList params;
  public int offset;

  public FunctionPro( int row, int col, NameTy result, String func, VarDecList params ) {
    this.row = row;
    this.col = col;
    this.result = result;
    this.func = func;
    this.params = params;
  }

  public void accept( AbsynVisitor visitor, int level, boolean flag  ) {
    visitor.visit( this, level, flag );
  }
}

