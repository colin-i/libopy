
format elfobj64

include "com.h"

function modules()
	value mods=NULL
	return #mods
endfunction

function finalize()
	sv m;setcall m modules()
	if m#!=(NULL)
		sv n;set n m#
		sd end;set end n#
		incst n
		add end n
		while n<^end
			importx "Py_DECREF" Py_DECREF   #this is also a macro
			call Py_DECREF(n#)
			incst n
		endwhile
		call null(m)  #why null? let a potential error print at py side (example calling Py_Fin.. without init)
	endif
endfunction

function null(sv a)
	importx "free" free
	call free(a#)
	set a# (NULL)
endfunction

importx "malloc" malloc
importx "realloc" realloc
importx "printf" printf

aftercall ebool

function alloc(sv pmem,sd sz)
	sd a;setcall a malloc(sz)
	if a!=(NULL)
		set pmem# a
		ret
	endif
	call printf("malloc error")
	aftercallactivate
	return (bad_return)
endfunction

function ralloc(sv pmem,sd sz)
	sv mem;set mem pmem#
	sd allsize;set allsize mem#
	add allsize sz
	setcall mem realloc(mem,allsize)
	if mem!=(NULL)
		set pmem# mem
		add mem# sz
		ret
	endif
	call printf("realloc error")
	aftercallactivate
	return (bad_return)
endfunction
