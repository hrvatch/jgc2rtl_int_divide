module integer_divide #(parameter WIDTH=16) ( // width of numbers in bits
  input wire logic clk,              // clock
  input wire logic rst_n,            // reset
  input wire logic start,            // start calculation
  output     logic busy,             // calculation in progress
  output     logic done,             // calculation is complete (high for one tick)
  output     logic valid,            // result is valid
  output     logic dbz,              // divide by zero
  input wire logic [WIDTH-1:0] a,    // dividend (numerator)
  input wire logic [WIDTH-1:0] b,    // divisor (denominator)
  output     logic [WIDTH-1:0] val,  // result value: quotient
  output     logic [WIDTH-1:0] rem   // result: remainder
);

  logic [WIDTH-1:0] b1;             // copy of divisor
  logic [WIDTH-1:0] quo, quo_next;  // intermediate quotient
  logic [WIDTH:0] acc, acc_next;    // accumulator (1 bit wider)
  logic [$clog2(WIDTH)-1:0] i;      // iteration counter

  // division algorithm iteration
  always_comb begin
    if (acc >= {1'b0, b1}) begin
      acc_next = acc - b1;
      {acc_next, quo_next} = {acc_next[WIDTH-1:0], quo, 1'b1};
    end else begin
      {acc_next, quo_next} = {acc, quo} << 1;
    end
  end

  // calculation control
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      busy  <= 1'b0;
      done  <= 1'b0;
      valid <= 1'b0;
      dbz   <= 1'b0;
      val   <= 1'b0;
      rem   <= 1'b0;
    end else begin
      done <= 1'b0;
      if (start) begin
        valid <= 1'b0;
        i <= 1'b0;
        if (b == 0) begin  // catch divide by zero
          busy <= 1'b0;
          done <= 1'b1;
          dbz  <= 1'b1;
        end else begin
          busy <= 1'b1;
          dbz  <= 1'b0;
          b1   <= b;
          {acc, quo} <= {{WIDTH{1'b0}}, a, 1'b0};  // initialize calculation
        end
      end else if (busy) begin
        if (i == WIDTH-1) begin  // we're done
          busy  <= 1'b0;
          done  <= 1'b1;
          valid <= 1'b1;
          val <= quo_next;
          rem <= acc_next[WIDTH:1];  // undo final shift
        end else begin  // next iteration
          i <= i + 1'b1;
          acc <= acc_next;
          quo <= quo_next;
        end
      end
    end
  end
endmodule : integer_divide
