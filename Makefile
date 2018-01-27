# Script name. Default: 'shinclude'
SCRIPT = shinclude

VERSION = 0.0.2

# Install prefix. Default: '/usr/local'
PREFIX = /usr/local

BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1
SHAREDIR = $(PREFIX)/share/$(SCRIPT)

RM = rm -rfv
CP = cp -rfa
MKDIR = mkdir -p
RONN = ronn

SCRIPT_SOURCES = \
				 src/header.bash \
				 src/block-BANNER.bash \
				 src/block-EVAL.bash \
				 src/block-INCLUDE.bash \
				 src/block-MARKDOWN-TOC.bash \
				 src/block-RENDER.bash \
				 src/style.bash \
				 src/read-lines.bash \
				 src/usage.bash \
				 src/cli.bash

SCRIPT_INCLUDES = src/style.bash $(wildcard src/block-*.bash)

export SHLOG_TERM=info

# BEGIN-RENDER Makefile

help:
	@echo ""
	@echo "  Targets"
	@echo ""
	@echo "    all          Build deps, shinclude the manpage and the README.md"
	@echo "    deps         Setup dependencies"
	@echo "    build-deps   Check Development dependencies"
	@echo "    $(SCRIPT)    Assemble the script"
	@echo "    $(SCRIPT).1  Build man page (shinclude -> ronn)"
	@echo "    README.md    Run shinclude on README.md"
	@echo "    Makefile     Run shinclude on Makefile"
	@echo "    clean        Remove built manpage and script"
	@echo "    realclean    Remove built manpage, script, README.md and deps"
	@echo "    install      Install to $(PREFIX)"
	@echo "    uninstall    Uninstall from $(PREFIX)"
	@echo "    test         Run tests"
	@echo ""
	@echo "  Variables"
	@echo ""
	@echo "    SCRIPT  Script name. Default: 'shinclude'"
	@echo "    PREFIX  Install prefix. Default: '/usr/local'"

# END-RENDER

.PHONY: test all

# Build deps, shinclude the manpage and the README.md
all: deps $(SCRIPT) $(SCRIPT).1 README.md Makefile

#
# Dependencies
#

# Setup dependencies
deps: deps/bin/shrender deps/bin/shlog deps/figlet-fonts

deps/bin/shrender:
	$(MKDIR) "$(dir $@)" && wget -O "$@" "https://rawgit.com/kba/shrender/master/shrender" && chmod a+x "$@"

deps/bin/shlog:
	$(MKDIR) "$(dir $@)" && wget -O "$@" "https://rawgit.com/kba/shlog/master/shlog" && chmod a+x "$@"

deps/figlet-fonts:
	git clone https://github.com/kba/figlet-fonts "$@"

# Check Development dependencies
build-deps: test/tsht
	@which ronn >/dev/null || { \
		which gem >/dev/null  || { \
			echo "Ruby is required for ronn."; exit 1; }; \
		gem install --user-install ronn; }

test/tsht:
	wget -O "$@" "https://rawgit.com/kba/tsht/master/tsht" && chmod a+x "$@"

#
# Build
#

# Assemble the script
$(SCRIPT): $(SCRIPT_SOURCES)
	cat $(SCRIPT_SOURCES) > "$@"
	chmod a+x "$@"

# Build man page (shinclude -> ronn)
$(SCRIPT).1: $(SCRIPT) doc/$(SCRIPT).1.md
	./$(SCRIPT) -d doc/$(SCRIPT).1.md \
		| $(RONN) --roff --pipe --name="$(SCRIPT)" --date=`date +"%Y-%m-%d"` \
		> "$@"

# Run shinclude on README.md
README.md: $(SCRIPT) doc/README.md
	./$(SCRIPT) -c xml doc/README.md > "$@"

# Run shinclude on Makefile
.PHONY: Makefile
Makefile: $(SCRIPT)
	./$(SCRIPT) -c pound -i Makefile

#
# Clean
#

# Remove built manpage and script
clean:
	rm -fr $(SCRIPT).1 $(SCRIPT)

# Remove built manpage, script, README.md and deps
realclean: clean
	rm -fr README.md deps

#
# Install
#

# Install to $(PREFIX)
install: all
	$(MKDIR) $(BINDIR)
	sed 's,^SHINCLUDESHARE=.*,SHINCLUDESHARE="$(SHAREDIR)",' $(SCRIPT) > "$(BINDIR)/$(SCRIPT)"
	chmod a+x $(BINDIR)/$(SCRIPT)
	$(MKDIR) $(MANDIR)
	$(CP) $(SCRIPT).1 $(MANDIR)/$(SCRIPT).1
	$(MKDIR) $(SHAREDIR)
	$(CP) -t $(SHAREDIR) README.md LICENSE deps

#
# Uninstall
#

# Uninstall from $(PREFIX)
uninstall:
	$(RM) $(BINDIR)/$(SCRIPT)
	$(RM) $(MANDIR)/$(SCRIPT).1
	$(RM) $(SHAREDIR)

#
# Test
#

# Run tests
test: test/tsht $(SCRIPT)
	./test/tsht
