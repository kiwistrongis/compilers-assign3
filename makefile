# globals
default: build
freshen: clean build
clean:
	rm -rf bin/* gen/* pkg/*
	rm -f $(antlr_gen_files)

# variables
antlr ?= antlr4
jasmin ?= jasmin

cp = src:bin:lib/*
dest = -d bin

package_file = pkg/assign3_kalev_100425828.tgz

options =
warnings =
#warnings = -Xlint:deprecation

# includes
include lists.mk
include deps.mk

# compilation definitions
$(antlr_class_files): $(antlr_java_files)
	javac -cp $(cp) $(dest) $(warnings) $(antlr_java_files)

$(other_class_files): bin/%.class : src/%.java
	javac -cp $(cp) $(dest) $(warnings) $<

$(test_class_files): bin/%.class : gen/%.j
	$(jasmin) $(dest) $<

$(test_j_files): gen/%.j : tests/%.txt
	java -cp $(cp) SimpleCompiler $< $@

$(antlr_gen_files) : src/Simple.g4
	$(antlr) $<

# commands
all: build built-tests
gen: $(antlr_gen_files)
build: $(class_files)
build-tests: $(test_class_files)

$(package_file): \
		$(class_files) \
		$(test_class_files) \
		legal/* lib/* \
		deps.mk lists.mk makefile readme.md
	tar -cf $(package_file) \
		bin gen legal lib pkg/.gitignore src tests \
		deps.mk lists.mk makefile readme.md
package: $(package_file)
package-test: package
	file-roller $(package_file) &

# test commands
test: build test-comp-asdf
test-all: build-tests \
	test-addition \
	test-asdf \
	test-declaration \
	test-division \
	test-expression \
	test-print_multi \
	test-print_one \
	test-product \
	test-repeat_multi \
	test-repeat_one \
	test-sample \
	test-subtraction \

test-comp-asdf: tests/asdf.txt
	java -cp $(cp) SimpleCompiler $<
test-comp-sample: tests/test.txt
	java -cp $(cp) SimpleCompiler $<

test-addition: bin/addition.class
	java -cp $(cp) addition
test-asdf: bin/asdf.class
	java -cp $(cp) asdf
test-declaration: bin/declaration.class
	java -cp $(cp) declaration
test-division: bin/division.class
	java -cp $(cp) division
test-expression: bin/expression.class
	java -cp $(cp) expression
test-print_multi: bin/print_multi.class
	java -cp $(cp) print_multi
test-print_one: bin/print_one.class
	java -cp $(cp) print_one
test-product: bin/product.class
	java -cp $(cp) product
test-repeat_multi: bin/repeat_multi.class
	java -cp $(cp) repeat_multi
test-repeat_one: bin/repeat_one.class
	java -cp $(cp) repeat_one
test-sample: bin/sample.class
	java -cp $(cp) sample
test-subtraction: bin/subtraction.class
	java -cp $(cp) subtraction
