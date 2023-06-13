
ifndef OCOMP
OCOMP=o
endif

ifndef OLINK
OLINK=ounused
endif

ifndef linkerflags
linkerflags=-s
#-O (same as actionswf)
endif

name=libopython.so
outname=/lib/${name}

all: ${name}

items = init

$(foreach var,$(items),$(eval obs += ${var}.o))
$(foreach var,$(items),$(eval logs += ${var}.s.log))

${name}: ${obs}
	${OLINK} ${logs}
	@echo
	$(CC) ${linkerflags} ${obs} -shared -o ${name}

%.o: %.s
	${OCOMP} $< ${OFLAGS}

install: all
	install -D ${name} \
		$(DESTDIR)$(prefix)${outname}

clean-compile:
	-rm -f ${obs}
	-rm -f ${logs}

clean-link:
	-rm -f ${name}

clean: clean-compile clean-link
distclean: clean

uninstall:
	-rm -f $(DESTDIR)$(prefix)${outname}

test:
	echo "Nothing"

.PHONY: all install clean distclean uninstall test
