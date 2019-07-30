## Microprocessors

There are 3 different versions of CPUs in this repository which are ascending from the most primitive to the most advanced.

# CPU/FROG
- This CPU can only carry out LDI and ALU operations.
- There is no load/store operation.
- 2-bit OPCODE available.

# CPU/BIRD
- This CPU can carry out LDI, ALU, LOAD, STORE and STACK operations.
- However, there is no interrupt logic. Instead, there is a pooling mechanisim to get input from user.
- 4-bit OPCODE available.

# CPU/MAMMAL
- This is the most advanced CPU design.
- It can do all type of operations. In addition to that, it has a interrupt design within it.
- CPU clock that works by interrupt signals is available.
- 4-bit OPCODE available.
