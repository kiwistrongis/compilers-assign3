# dependencies

# antlr classes
$(antlr_class_files): \
	bin/Code.class \
	bin/SymbolTable.class \

# jasmin files
$(test_j_files): \
	$(class_files)

# compiler
bin/SimpleCompiler.class: \
	$(antlr_class_files)
