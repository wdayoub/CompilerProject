package absyn;

public class IndexVar extends Var {
    public int row, col;
    public String name;
    public Exp index;
    public ArrayDec dec;

    public IndexVar(int row, int col, String name, Exp index){
      this.row = row;
      this.col = col;
      this.name = name;
      this.index = index;
      this.dec = null;
    }


    public void accept( AbsynVisitor visitor, int level, boolean flag  ){
      visitor.visit( this, level, flag );
  }
    
}
