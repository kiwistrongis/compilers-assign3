# lists

antlr_class_files = \
	bin/SimpleBaseListener.class \
	bin/SimpleLexer.class \
	bin/SimpleListener.class \
	bin/SimpleParser.class \

antlr_java_files = \
	src/SimpleBaseListener.java \
	src/SimpleLexer.java \
	src/SimpleListener.java \
	src/SimpleParser.java \

antlr_gen_files = \
	src/Simple.tokens \
	src/SimpleBaseListener.java \
	src/SimpleLexer.java \
	src/SimpleLexer.tokens \
	src/SimpleListener.java \
	src/SimpleParser.java \

other_class_files = \
	bin/Code.class \
	bin/SimpleCompiler.class \
	bin/SymbolTable.class \

class_files = $(antlr_class_files) $(other_class_files)

test_class_files = \
	bin/addition.class \
	bin/asdf.class \
	bin/declaration.class \
	bin/division.class \
	bin/expression.class \
	bin/print_multi.class \
	bin/print_one.class \
	bin/product.class \
	bin/repeat_multi.class \
	bin/repeat_one.class \
	bin/sample.class \
	bin/subtraction.class \

test_j_files = \
	gen/addition.j \
	gen/asdf.j \
	gen/declaration.j \
	gen/division.j \
	gen/expression.j \
	gen/print_multi.j \
	gen/print_one.j \
	gen/product.j \
	gen/repeat_multi.j \
	gen/repeat_one.j \
	gen/sample.j \
	gen/subtraction.j \
