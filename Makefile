PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1

SCRIPT = shinclude

SCRIPT_SOURCE = src/shinclude.bash
SCRIPT_INCLUDES = \
				  src/logging.bash \
				  src/style.bash \
				  $(wildcard src/block-*.bash)

RONN = $(RONN)

.PHONY: \
	all \
	README.md \
	$(SCRIPT).bootstrap

all: $(SCRIPT) $(SCRIPT).1 README.md

# shinclude.bootstrap: lazily cat included files
$(SCRIPT).bootstrap:
	cat $(SCRIPT_INCLUDES) $(SCRIPT_SOURCE) > $@

# Run shinclude.bootstrap on src/shinclude.bash
$(SCRIPT): $(SCRIPT).bootstrap
	bash ./$(SCRIPT).bootstrap $(SCRIPT_SOURCE) > $@
	chmod a+x $@

# Build man page (Markdown)
$(SCRIPT).1.md: $(SCRIPT)
	./$(SCRIPT) doc/$(SCRIPT).1.md > "$@"

# Build man page (roff)
$(SCRIPT).1: $(SCRIPT).1.md
	ronn --roff --date=`date +"%Y-%m-%d"` "$<"

# Build README.md
README.md: $(SCRIPT)
	./$(SCRIPT) -d -c xml doc/README.md > "$@"

install: $(SCRIPT) $(SCRIPT).1
	cp $(SCRIPT) $(BINDIR)/$(SCRIPT)
	chmod a+x $(BINDIR)/$(SCRIPT)
	cp $(SCRIPT).1 $(MANDIR)

uninstall:
	rm -rf $(BINDIR)/$(SCRIPT)
	rm -rf $(MANDIR)/$(SCRIPT).1

dev-deps:
	which ronn || gem install --user-install ronn

clean:
	rm -f \
		$(SCRIPT).1 \
		$(SCRIPT).bootstrap \
		$(SCRIPT) 

test: $(SCRIPT)
	./test/tsht


