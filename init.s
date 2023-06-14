
format elfobj64

import "modules" modules
import "allocz" allocz
import "finalize" finalize

const good_return=0

#zero on success
functionx opy_initialize()
	importx "Py_Initialize" Py_Initialize
	call Py_Initialize()  #Ex(initsigs=0)? Signal handling depends on the notion of a 'main thread', a loop, that is required here

	sv m;setcall m modules()
	setcall m# allocz()
	return (good_return)
endfunction

functionx opy_finalize()
	call finalize()

	importx "Py_FinalizeEx" Py_FinalizeEx
	call Py_FinalizeEx()  #without Ex? void return on C, is call Ex for asm (tested)
endfunction

#PyObject
functionx opy_import(ss *name)
	return (good_return)
endfunction
