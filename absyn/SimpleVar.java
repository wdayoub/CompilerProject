package absyn;

public class SimpleVar extends Var {
    public int row, col;
    public String name;
    public SimpleDec dec; // link
    public ArrayDec array; // link;

    public SimpleVar(int row, int col, String name){
      this.row = row;
      this.col = col;
      this.name = name;
      this.dec = null;
    }

    public void accept( AbsynVisitor visitor, int level, boolean flag  ){
        visitor.visit( this, level, flag );
    }
    
}
