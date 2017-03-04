program=bin/hexed
bindir=bin

default: $(program)

run: $(program)
	$(program)

release: src/hexed.cr src/**/*.cr $(bindir)
	crystal build --release -o $(program) $<

$(program): src/hexed.cr src/**/*.cr $(bindir)
	crystal build -o $(program) $<

$(bindir):
	mkdir -p $(bindir)
