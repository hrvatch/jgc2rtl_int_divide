Contains: 
- 16-bit non-restoring divide implementation.
- C-based reference model.

## To run:

```
cd sim
jg -c2rtl integer_divide_c2rtl.tcl
```

Note: The design itself is not really optimal for formal verification because of the large diameter (N+1, where N is the divider bit-width). It takes roughly:
- 9 minutes to prove all properties using Hp engine
- Roughly 3 minutes if check_result property is used as a helper for check_remainder property
