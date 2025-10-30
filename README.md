Contains: 
- 16-bit non-restoring divide implementation.
- C-based reference model.

To run:
$ cd sim
$ jg -c2rtl integer_divide_c2rtl.tcl

Inside JasperGold type:
$ prove -orchestration on -all

Note: It takes roughly 12 minutes to prove equivalence between the C-based reference model and the design. The design itself is not really optimal for formal verification because of the large diameter (N+1, where N is the divider bit-width).
