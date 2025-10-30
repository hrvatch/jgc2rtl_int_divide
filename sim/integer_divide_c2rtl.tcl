clear -all

# Compile C model
check_c2rtl -compile -spec ../c_refmodel/integer_divide_refmodel.c

# Compile RTL block
check_c2rtl -analyze -imp -sv ../rtl/integer_divide.sv
check_c2rtl -elaborate -imp -top integer_divide

# Create verification setup
check_c2rtl -setup -no_auto_mapping

# Define clocks and resets
clock integer_divide_imp.clk
reset !integer_divide_imp.rst_n

# Assume RM and RTL inputs to be the same
assume { a == integer_divide_imp.a }
assume { b == integer_divide_imp.b }

# Check outputs to be the same with appropriate pipeline delays and exceptions (div by zero) ignored
assert -name check_result { integer_divide_imp.done && integer_divide_imp.valid |-> (integer_divide_imp.val == $past(val, 17)) }
assert -name check_remainder { integer_divide_imp.done && integer_divide_imp.valid |-> (integer_divide_imp.rem == $past(rem, 17)) }

# Prove
prove -property check_result -engine_mode { Hp }
prove -property check_remainder -with_proven -engine_mode { Hp }
prove -all -bg
