grammar Simple;
// i so simple :)
// kalev kalda sikes
// 100425828

// preamble
@header {
	import java.util.Vector;
}

@members {
	public SymbolTable symbols = new SymbolTable();
	public StringBuilder result = new StringBuilder();
}

// main constructs
start : program;
program
	locals[ Code code = new Code() ]
	@after {
		result.append( $code.toString());}
	: block { $code.extend( $block.code);};

block returns [ Code code = new Code() ]
	: ( stmt { $code.extend( $stmt.code);})+;

stmt returns [ Code code = new Code() ]
	: stmt_assign { $code.extend( $stmt_assign.code);}
	| stmt_print { $code.extend( $stmt_print.code);}
	| stmt_repeat { $code.extend( $stmt_repeat.code);}
	;


// expressions
expr_list returns [ Vector<Code> codes = new Vector<Code>() ]
	// push each code frag
	: ( expr { $codes.add( $expr.code);} ',')*
		expr { $codes.add( $expr.code);}
	;

expr returns [ Code code = new Code() ]
	// term
	: term {
		$code.extend( $term.code);}
	// add
	| t1=term '+' e2=expr {
		$code.extend( $t1.code);
		$code.extend( $e2.code);
		$code.add();}
	// sub
	| t1=term '-' e2=expr {
		$code.extend( $t1.code);
		$code.extend( $e2.code);
		$code.sub();}
	;

term returns [ Code code = new Code() ]
	// factor
	: factor {
		$code.extend( $factor.code);}
	// mult
	| f1=factor '*' f2=factor {
		$code.extend( $f1.code);
		$code.extend( $f2.code);
		$code.mul();}
	// div
	| f1=factor '/' f2=factor {
		$code.extend( $f1.code);
		$code.extend( $f2.code);
		$code.div();}
	;

factor returns [ Code code = new Code() ]
	: ID { $code.load( symbols, $ID.text);}
	| literal { $code.push( $literal.value);}
	| '(' expr ')' { $code.extend( $expr.code);}
	;

literal returns [ int value ]
	: CONST {
		$value = Integer.parseInt( $CONST.text);}
	;

// statements
stmt_assign returns [ Code code = new Code() ]
	: 'let' ID '=' expr {
		// get new id
		symbols.set( $ID.text);
		// execute code
		$code.extend( $expr.code);
		// save to reg
		$code.save( symbols, $ID.text);}
	;

stmt_print returns [ Code code = new Code() ]
	: 'print' '(' expr_list ')' {
		// for each expr's code
		//  execute the code and print the result
		for( Code expr_code : $expr_list.codes){
			$code.print( expr_code);}
		// and print a newline
		$code.println();}
	;

stmt_repeat returns [ Code code = new Code() ]
	locals [ String loop_id ]
	@init {
		// get unique id
		$loop_id = symbols.uniq_id();}
	: 'repeat' expr '{' block '}' {
		// save loop counter
		$code.extend( $expr.code);
		$code.save( symbols, $loop_id);
		// set loop label
		$code.label( $loop_id);
		// extend by block
		$code.extend( $block.code);
		// decrement counter
		$code.load( symbols, $loop_id);
		$code.push( 1);
		$code.sub();
		$code.dup();
		$code.save( symbols, $loop_id);
		// continue loop?
		$code.gt( $loop_id);}
	;

// terminal tokens
//  no capitals for ids cause it makes
//  generating unique loop ids easier :D
ID : ('a'..'z') (('a'..'z')|('0'..'9'))* ;
CONST : ('0'..'9')+;
WS : [ \t\r\n]+ -> skip;
