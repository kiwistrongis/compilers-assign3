// std lib imports
import java.io.*;

// antlr imports
import org.antlr.v4.runtime.*;

public class SimpleCompiler implements Runnable {
	// constants
	public static final boolean debug = false;

	// private members
	private ANTLRInputStream input = null;
	private SimpleLexer lexer = null;
	private CommonTokenStream tokens = null;
	private SimpleParser parser = null;
	private PrintStream output = null;

	// output vars
	private String classname = null;
	int stack_limit = 10;
	int locals_limit = 10;

	// entry-point method
	public static void main( String[] args){
		new SimpleCompiler( args).run();}

	// constructor
	public SimpleCompiler( String[] args){
		// select input
		this.classname = "TestClassPleaseIgnore";
		InputStream input = System.in;
		//  open file if arg given
		if( args.length > 0){
			try {
				input = new FileInputStream( args[0]);
				this.classname = basename( args[0]);}
			catch( FileNotFoundException exception){
				System.out.printf(
					"Error opening file {%s}: %s\n", args[0], exception);
				System.exit( 1);}}
		//  read input stream
		try{ this.input = new ANTLRInputStream( input);}
		catch( IOException exception){
				System.out.printf(
					"Error reading file {%s}: %s\n", args[0], exception);
				System.exit( 1);}

		// make parser
		this.lexer = new SimpleLexer( this.input);
		this.tokens = new CommonTokenStream( this.lexer);
		this.parser = new SimpleParser( this.tokens);

		// select output
		this.output = System.out;
		//  open file if arg given
		if( args.length > 1){
			try { this.output = new PrintStream( args[1]);}
			catch( FileNotFoundException exception){
				System.out.printf(
					"Error opening file {%s}: %s\n", args[1], exception);
				System.exit( 1);}}}

	// run compiler
	@Override
	public void run(){
		// parse input into jasmin assembly
		this.parser.start();
		// extract vars
		//this.stack_limit = this.parser.symbols.size();
		// print preamble
		if( ! debug) this.output.print( this.preamble());
		// print program assembly
		this.output.print( this.parser.result);
		// print postamble
		if( ! debug) this.output.print( this.postamble());}


	// preamble
	public String preamble(){
		StringBuilder result = new StringBuilder();
		result.append( String.format( ".class %s\n", this.classname));
		result.append( ".super java/lang/Object\n");
		result.append( ".method public <init>()V\n");
		result.append( "\taload_0\n");
		result.append( "\tinvokenonvirtual java/lang/Object/<init>()V\n");
		result.append( "\treturn\n");
		result.append( ".end method\n");
		result.append( ".method public static main([Ljava/lang/String;)V\n");
		result.append( String.format( ".limit stack %d\n", this.stack_limit));
		result.append( String.format( ".limit locals %d\n", this.locals_limit));
		result.append( "\n");
		return result.toString();}

	// postamble
	public String postamble(){
		StringBuilder result = new StringBuilder();
		result.append( "\n");
		result.append( "\treturn\n");
		result.append( ".end method\n");
		return result.toString();}

	// util
	public static String basename( String filename){
		String name = new File( filename).getName();
		return name.substring( 0, name.indexOf( '.'));}
}
