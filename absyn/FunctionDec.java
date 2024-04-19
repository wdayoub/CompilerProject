package absyn;

public class FunctionDec extends Dec {
  public NameTy result;
  public String func;
  public VarDecList params;
  public Exp body;
  public int funaddr;
  public FunctionPro pro; //link to FunctionPro

  public FunctionDec( int row, int col, NameTy result, String func, VarDecList params, Exp body ) {
    this.row = row;
    this.col = col;
    this.result = result;
    this.func = func;
    this.params = params;
    this.body = body;
  }

  public void accept( AbsynVisitor visitor, int level, boolean flag  ) {
    visitor.visit( this, level, flag );
  }
}

