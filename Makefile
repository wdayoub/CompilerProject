JAVA=java
JAVAC=javac
JFLEX=jflex
CLASSPATH=-cp /usr/share/java/cup.jar:.
CUP=cup
#JFLEX=~/Projects/jflex/bin/jflex
#CLASSPATH=-cp ~/Projects/java-cup-11b.jar:.
#CUP=$(JAVA) $(CLASSPATH) java_cup.Main

all: CM.class

CM.class: absyn/*.java parser.java sym.java Lexer.java ShowTreeVisitor.java SemanticAnalyzer.java CodeGenerator.java Scanner.java CM.java

%.class: %.java
	$(JAVAC) $(CLASSPATH) $^

Lexer.java: cspec.flex
	$(JFLEX) cspec.flex

parser.java: cspec.cup
	#$(CUP) -dump -expect 3 cspec.cup
	$(CUP) -expect 3 cspec.cup

clean:
	rm -f parser.java Lexer.java sym.java *.class absyn/*.class *~
