
format elfobj64

functionx object()
	valuex *pointer#1
	#valuex childs#1
endfunction

import "modules" modules
import "finalize" finalize

include "com.h"
const good_return=0

functionx opy_finalize()
	call finalize()

	importx "Py_FinalizeEx" Py_FinalizeEx
	call Py_FinalizeEx()  #without Ex? void return on C, is call Ex for asm (tested)
endfunction

importx "Py_Initialize" Py_Initialize
importx "PyImport_ImportModule" PyImport_ImportModule

importaftercall ebool

import "alloc" alloc
import "ralloc" ralloc

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
	sv m;setcall m modules()
	call ralloc(m,(!!object))
	set m m#

	sd modul;setcall modul PyImport_ImportModule(name)
	if modul!=(NULL)
		sd sz=-:;add sz m#
		incst m;add m sz
		set m# modul
		return (good_return)
	endif
	sub m# :    #must decrement
	return (bad_return)
endfunction
