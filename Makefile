SCRIPT = shinclude
VERSION = 0.0.1

PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1
SHAREDIR = $(PREFIX)/share/$(SCRIPT)

RM = rm -rfv
CP = cp -rfva
MKDIR = mkdir -p
RONN = ronn

SCRIPT_SOURCES = \
				 src/shinclude.bash \
				 src/block-BANNER.bash \
				 src/block-EVAL.bash \
				 src/block-INCLUDE.bash \
				 src/block-MARKDOWN-TOC.bash \
				 src/block-RENDER.bash \
				 src/style.bash \
				 src/usage.bash \
				 src/main.bash
				
SCRIPT_INCLUDES = src/style.bash $(wildcard src/block-*.bash)

export SHLOG_TERM=info

.PHONY: test

#
# Dependencies
#

deps: deps/bin/shrender deps/bin/shlog deps/figlet-fonts

deps/bin/shrender:
	$(MKDIR) "$(dir $@)" && wget -O "$@" "https://rawgit.com/kba/shrender/master/shrender" && chmod a+x "$@"

deps/bin/shlog:
	$(MKDIR) "$(dir $@)" && wget -O "$@" "https://rawgit.com/kba/shlog/master/shlog" && chmod a+x "$@"

deps/figlet-fonts:
	git clone https://github.com/kba/figlet-fonts "$@"

#
# Development dependencies
#
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

dist: deps $(SCRIPT) $(SCRIPT).1 README.md

# Assemble the script
$(SCRIPT): $(SCRIPT_SOURCES)
	cat $(SCRIPT_SOURCES) > "$@"
	chmod a+x "$@"

# Build man page (shinclude -> ronn)
$(SCRIPT).1: $(SCRIPT) doc/$(SCRIPT).1.md
	./$(SCRIPT) -d doc/$(SCRIPT).1.md \
		| $(RONN) --roff --pipe --name="$(SCRIPT)" --date=`date +"%Y-%m-%d"` \
		> "$@"

# Build README.md
README.md: $(SCRIPT) doc/README.md
	./$(SCRIPT) -c xml doc/README.md > "$@"

#
# Clean
#

clean:
	rm -fr $(SCRIPT).1 $(SCRIPT)

realclean: clean
	rm -fr README.md deps

#
# Install
#

install: dist
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
uninstall:
	$(RM) $(BINDIR)/$(SCRIPT)
	$(RM) $(MANDIR)/$(SCRIPT).1
	$(RM) $(SHAREDIR)

#
# Test
#

test: test/tsht $(SCRIPT)
	./test/tsht
