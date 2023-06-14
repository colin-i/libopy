
format elfobj64

const NULL=0

const bad_return=-1

function modules()
	value alloc=NULL
	return #alloc
endfunction

function finalize()
	sd m;setcall m modules()
	if m#!=(NULL)
		call null(m)  #why null? let a potential error print at py side (example calling Py_Fin.. without init)
	endif
endfunction

function null(sv a)
	importx "free" free
	call free(a#)
	set a# (NULL)
endfunction

#aftercall ebool

function allocz()
	importx "malloc" malloc
	sd a;setcall a malloc(0)
	if a!=(NULL)
		return a
	endif
	#call errexit()
	importx "printf" printf
	call printf("malloc error")
	#call finalize()
	#errset
	return (bad_return)
endfunction
