
format elfobj64

import "modules" modules
import "finalize" finalize

include "com.h"

functionx opy_finalize()
	call finalize()

	importx "Py_FinalizeEx" Py_FinalizeEx
	call Py_FinalizeEx()  #without Ex? void return on C, is call Ex for asm (tested)
endfunction

import "bralloc" bralloc

importx "free" free
importx "Py_Initialize" Py_Initialize
importx "PyImport_ImportModule" PyImport_ImportModule

importaftercall ebool

import "alloc" alloc

#zero on success
functionx opy_initialize()
	call Py_Initialize()  #Ex(initsigs=0)? Signal handling depends on the notion of a 'main thread', a loop, that is required here

	sv m;setcall m modules()
	call alloc(m,:)

	set m m#
	set m# 0

	return (good_return)
endfunction

#PyObject
functionx opy_import(ss name)
	sv temp;call alloc(#temp,:)

	sv m;setcall m modules()
	sd b;setcall b bralloc(m,(!!object))
	if b==(good_return)
		set m m#
		sd modul;setcall modul PyImport_ImportModule(name)
		if modul!=(NULL)
			sd sz=-!!object;add sz m#
			incst m;add m sz
			set m#:object.pointer modul
			set m#:object.childs temp
			return (good_return)
		endif
		sub m# (!!object)    #must decrement
	endif
	call free(temp)
	return (bad_return)
endfunction
