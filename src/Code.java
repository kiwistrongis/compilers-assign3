// std lib imports
import java.util.Vector;

public class Code {
	// members
	public Vector<String> lines;

	// constructor
	public Code(){
		this.lines = new Vector<String>();}

	// functions
	public void extend( Code code){
		this.lines.addAll( code.lines);}

	@Override
	public String toString(){
		StringBuilder result = new StringBuilder();
		for( String line : this.lines){
			result.append( line);
			result.append( '\n');}
		return result.toString();}

	// vars
	public void save( SymbolTable symbols, String id){
		this.addf( "istore %d", symbols.get( id));}
	public void load( SymbolTable symbols, String id){
		this.addf( "iload %d", symbols.get( id));}

	// labels
	public void label( String label){
		this.addf( "%s:", label);}
	public void gt( String label){
		this.addf( "ifgt %s", label);}

	// logic
	public void push( int value){
		this.addf( "ldc %d", value);}
	public void dup(){
		this.addf( "dup");}

	public void add(){
		this.addf( "iadd");}
	public void sub(){
		this.addf( "isub");}
	public void mul(){
		this.addf( "imul");}
	public void div(){
		this.addf( "idiv");}

	// special
	public void print( Code code){
		// print expression
		this.addf(
			"getstatic java/lang/System/out Ljava/io/PrintStream;");
		this.dup();
		this.extend( code);
		this.addf(
			"invokevirtual java/io/PrintStream/print(I)V");
		// print space
		this.addf( "ldc \" \"");
		this.addf(
			"invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V");}

	public void println(){
		// print newline
		this.addf(
			"getstatic java/lang/System/out Ljava/io/PrintStream;");
		this.addf( "ldc \"\\n\"");
		this.addf(
			"invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V");}

	// util
	private void addf( String format, Object... args){
		this.lines.add(
			String.format( format, args));}
}