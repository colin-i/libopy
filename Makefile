
ifndef OCOMP
OCOMP=o
endif

ifndef OLINK
OLINK=ounused
endif

ifndef linkerflags
linkerflags=-s -O3
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
$(foreach var,$(items),$(eval logs += ${var}.oc.log))
$(foreach var,$(aritems),$(eval aobs += ${var}.o))
$(foreach var,$(aritems),$(eval alogs += ${var}.oc.log))

${name}: ${exte} ${obs}
	${OLINK} ${alogs} ${logs}
	@echo
	$(CC) ${linkerflags} ${obs} -shared -o ${name} -lpython3.12 -L. -l:${exte} -Wl,--exclude-libs ${exte}

${exte}: ${aobs}
	$(AR) cr ${exte} ${aobs}

%.o: %.oc
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

.PHONY: all install clean clean-compile clean-link distclean uninstall test
