/* Checkpoint 2
  Student Names: Wisam Dayoub, Sam Engel, Affan Khan
  Course Name: CIS 4650
  Due Date: March 18th, 2023

  Based on starter code created by Fei Song
  To Build: 
  After the Scanner.java, cspec.flex, and cspec.cup have been processed, do:
    javac CM.java
  
  To Run: 
    java -classpath /usr/share/java/cup.jar:. CM gcd.cm

  where gcd.cm is an test input file for the C Minus language.
*/
   
import java.io.*;

import javax.swing.text.StyleContext.SmallAttributeSet;

import absyn.*;
   
class CM {
  public final static boolean SHOW_TREE = true;
  public static String filename = "";

  static public void main(String argv[]) {

    if (argv.length >= 1){
      String fileParts[] = argv[0].split("\\.");
      filename = fileParts[0];
    }
    
    /* Start the parser */
    try {
      parser p = new parser(new Lexer(new FileReader(argv[0])));
      Absyn result = (Absyn)(p.parse().value); 
      if (argv.length > 1 && argv[1].equals("-s")){
        
        // if there are no syntatic errors, then do semantic analysis
        if (parser.valid){ 
          filename = filename + ".sym";
          AbsynVisitor visitor = new SemanticAnalyzer();

          // print output to console
          System.out.println("The symbol table is:");
          result.accept(visitor, 0, false); 

          //set output stream
          // Acknowledgement: https://stackoverflow.com/questions/14906458/output-console-into-text-file-java
          PrintStream ast = new PrintStream(new FileOutputStream(filename, false));
          System.setOut(ast);
          
          // print output again -- but to file this time
          System.out.println("The symbol table is:");
          result.accept(visitor, 0, false); 
        }


      } else if (argv.length > 1 && argv[1].equals("-a")){
        
        // if there are no syntatic errors, then save to file
        if (parser.valid){
          filename = filename + ".abs";
          AbsynVisitor visitor = new ShowTreeVisitor();

          // print output to console
          System.out.println("The abstract syntax tree is:");
          result.accept(visitor, 0, false);

          PrintStream ast = new PrintStream(new FileOutputStream(filename, false));
          System.setOut(ast);
        
          // print output again -- but to file this time
          System.out.println("The abstract syntax tree is:");
          result.accept(visitor, 0, false);
        }

      } else if (argv.length > 1 && argv[1].equals("-c")){
        filename = filename + ".tm";

        // Do semantic analysis before compilation
        AbsynVisitor visitor = new SemanticAnalyzer();

        
        if (parser.valid){
          System.out.println("The symbol table is:");
          result.accept(visitor, 0, false);
          System.out.println("");


          if (SemanticAnalyzer.valid){
            visitor = new CodeGenerator(); 
            visitor.visit(result);
  
            // print output to console
            PrintStream ast = new PrintStream(new FileOutputStream(filename, false));
            System.setOut(ast);
            
            visitor = new CodeGenerator(); 
            visitor.visit(result);
          }
        }
        
        
      
    } else if (SHOW_TREE && result != null) {
        // if there are errors found, only show the errors; don't show the tree
        if (parser.valid){
         System.out.println("The abstract syntax tree is:");
         AbsynVisitor visitor = new ShowTreeVisitor();
         result.accept(visitor, 0, false); 
        }
      }
    } catch (Exception e) {
      /* do cleanup here -- possibly rethrow e */
      System.setOut(System.out); // reset printstream
      e.printStackTrace();
    }
  }
}
