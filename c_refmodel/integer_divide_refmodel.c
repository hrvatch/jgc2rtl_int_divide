#include <stdint.h>
#include "jasperc.h"

int main() {
  int32_t a;
  int32_t b;
  int32_t val;
  int32_t rem;
  
  JASPER_INPUT(a);
  JASPER_INPUT(b);
  if (b == 0) { // divide by zero
    val = 0;
    rem = 0;
  } else {
    val = a / b;
    rem = a - (b * val);
  }

  JASPER_OUTPUT(val);
  JASPER_OUTPUT(rem);
}
