SOURCES=render.mli render.ml
PACKS=ANSITerminal core
THREADS=yes
RESULT=render
-include OCamlMakefile

install: bcl ncl nc
	ocamlfind install rendertable META render.cmi render.a render.cma render.cmx -optional render.cmxa render.cmxs

remove:
	ocamlfind remove rendertable
