
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

ifndef prefix
prefix=/usr
endif

name=libopython.so
outname=/lib/${name}
exte=libexte.a

all: ${name}

items = init
aritems = alloc

$(foreach var,$(items),$(eval obs += ${var}.o))
$(foreach var,$(items),$(eval logs += ${var}.s.log))
$(foreach var,$(aritems),$(eval aobs += ${var}.o))
$(foreach var,$(aritems),$(eval alogs += ${var}.s.log))

${name}: ${exte} ${obs}
	${OLINK} ${alogs} ${logs}
	@echo
	$(CC) ${linkerflags} ${obs} -shared -o ${name} -lpython3.11 -L. -l:${exte} -Wl,--exclude-libs ${exte}

${exte}: ${aobs}
	$(AR) cr ${exte} ${aobs}

%.o: %.s
	${OCOMP} $< ${OFLAGS}

install: all
	install -D ${name} \
		$(DESTDIR)$(prefix)${outname}

clean-compile:
	-rm -f ${aobs}
	-rm -f ${alogs}
	-rm -f ${obs}
	-rm -f ${logs}

clean-link:
	-rm -f ${exte}
	-rm -f ${name}

clean: clean-compile clean-link
distclean: clean

uninstall:
	-rm -f $(DESTDIR)$(prefix)${outname}

test:
	echo "Nothing"

.PHONY: all install clean distclean uninstall test
