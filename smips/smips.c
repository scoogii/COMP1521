// "smips" - an emulator that translates and outputs hexadecimal MIPS instructions
// Prints out the program's instructions, output, and non-zero registers
// This program will execute the instructions declared in the given functions below
// If an invalid instruction is read, the program will terminate
// Christian Nguyen - z5310911
// 9 Aug 2020

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

#define MAX_INSTR_CODES 1000
#define NO_PC 0
#define VALID_INSTR 0
#define INVALID_INSTR 1
#define CHECK_INSTR 0
#define PRINT_INSTR 1
#define EXE_INSTR 2
#define STOP_EXEC -1
#define TERMINATE 1
#define NUM_REG 32
#define NO_DREG -1
#define REG_BITS 5
#define VZERO_INDEX 2
#define AZERO_INDEX 4
#define ADD_OPCODE 0x20
#define SUB_OPCODE 0x22
#define AND_OPCODE 0x24
#define OR_OPCODE 0x25
#define SLT_OPCODE 0x2A
#define MUL_OPCODE 0x1C
#define BEQ_OPCODE 0x4
#define BNE_OPCODE 0x5
#define ADDI_OPCODE 0x8
#define SLTI_OPCODE 0xA
#define ANDI_OPCODE 0xC
#define ORI_OPCODE 0xD
#define LUI_OPCODE 0xF
#define SYSCALL_OPCODE 0xC
#define GOOD_SYSCALL 0
#define BAD_SYSCALL -1
#define EXIT_SYSCALL 1

int decodeInstruction(int *PC, int identifier, uint32_t opCode, int registers[NUM_REG]);
void printRegisters(int registers[NUM_REG]);
void add(int registers[NUM_REG], int s, int t, int d);
void sub(int registers[NUM_REG], int s, int t, int d);
void and(int registers[NUM_REG], int s, int t, int d);
void or(int registers[NUM_REG], int s, int t, int d);
void slt(int registers[NUM_REG], int s, int t, int d);
void mul(int registers[NUM_REG], int s, int t, int d);
int beq(int registers[NUM_REG], int s, int t, int16_t imm, int *PC);
int bne(int registers[NUM_REG], int s, int t, int16_t imm, int *PC);
void addi(int registers[NUM_REG], int s, int t, int16_t imm);
void slti(int registers[NUM_REG], int s, int t, int16_t imm);
void andi(int registers[NUM_REG], int s, int t, int16_t imm);
void ori(int registers[NUM_REG], int s, int t, int16_t imm);
void lui(int registers[NUM_REG], int t, int16_t imm);
int syscall(int registers[NUM_REG]);


int main(int argc, char *argv[]) {
    // Open hex file and error handle
    FILE *hexFile = fopen(argv[1], "r");
    if (hexFile == NULL) {
        perror(argv[1]);
        exit(1);
    }
    // Error handling to ensure there's only one file
    if (argc != 2) {
        fprintf(stderr, "usage: %s <filename>\n", argv[0]);
        exit(1);
    }

    // Initialise arrays - 1. Instruction codes 2. Registers
    uint32_t opCodes[MAX_INSTR_CODES];
    int registers[NUM_REG] = {0};

    // Read in instructions from hex file and check they're valid
    int numInstr = 0;
    while ((numInstr < MAX_INSTR_CODES) && (fscanf(hexFile, "%x", &opCodes[numInstr]) == 1)) {
        int checkValid = decodeInstruction(NO_PC, CHECK_INSTR, opCodes[numInstr], registers);
        // If invalid instruction, terminate program and print to stderr
        if (checkValid == INVALID_INSTR) {
            fprintf(stderr, "%s:%d: invalid instruction code: %08x\n", argv[1], (numInstr + 1), opCodes[numInstr]);
            exit(1);
        }
        numInstr++;
    }
    // Check if more than 1000 instructions
    if (numInstr == MAX_INSTR_CODES) {
        fprintf(stderr, "File too long: '%s'\n", argv[1]);
    }

    // Loop through instructions and print them out
    printf("Program\n");
    for(int i = 0; i < numInstr; i++) {
        printf("%3d: ", i);
        decodeInstruction(NO_PC, PRINT_INSTR, opCodes[i], registers);
    }

    // Loop through instructions and execute them
    printf("Output\n");
    for (int PC = 0; PC < numInstr; PC++) {
        int checkExe = decodeInstruction(&PC, EXE_INSTR, opCodes[PC], registers);
        registers[0] = 0;
        // If function returns an indication to stop execution, break
        if (checkExe == STOP_EXEC) {
            break;
        }
    }

    // Print out non-zero registers after execution
    printRegisters(registers);

    fclose(hexFile);
    return 0;
}

////////////////////////////////////////////////////////////////////////////////////
//                        F   U   N   C   T   I   O   N   S                       //
////////////////////////////////////////////////////////////////////////////////////

// Extracts bits of hex to determine which opcode it is
// Depending on the value of identifier -> checks all instr valid, prints instr, exe instr
int decodeInstruction(int *PC, int identifier, uint32_t opCode, int registers[NUM_REG]) {
    // Extract all registers and the immediate beforehand
    int sReg = (opCode << 6) >> 27;
    int tReg = (opCode << 11) >> 27;
    int dReg = (opCode << 16) >> 27;
    int16_t imm = (opCode << 16) >> 16;

    // Check first 6 bits:
    uint8_t first6 = (opCode >> 26);

    // First 6 bits 0
    if (first6 == 0) {
        // Check 6 possible cases, looking at last 6 bits
        uint8_t last6 = (opCode << 26) >> 26;
        // 'add'
        if (last6 == ADD_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("add  $%d, $%d, $%d\n", dReg, sReg, tReg);
            } else if (identifier == EXE_INSTR) {
                add(registers, sReg, tReg, dReg);
            }
            return VALID_INSTR;
        }
        // 'sub'
        if (last6 == SUB_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("sub  $%d, $%d, $%d\n", dReg, sReg, tReg);
            } else if (identifier == EXE_INSTR) {
                sub(registers, sReg, tReg, dReg);
            }
            return VALID_INSTR;
        }
        // 'and'
        if (last6 == AND_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("and  $%d, $%d, $%d\n", dReg, sReg, tReg);
            } else if (identifier == EXE_INSTR) {
                and(registers, sReg, tReg, dReg);
            }
            return VALID_INSTR;
        }
        // 'or'
        if (last6 == OR_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("or   $%d, $%d, $%d\n", dReg, sReg, tReg);
            } else if (identifier == EXE_INSTR) {
                or(registers, sReg, tReg, dReg);
            }
            return VALID_INSTR;
        }
        // 'slt'
        if (last6 == SLT_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("slt  $%d, $%d, $%d\n", dReg, sReg, tReg);
            } else if (identifier == EXE_INSTR) {
                slt(registers, sReg, tReg, dReg);
            }
            return VALID_INSTR;
        }
        // 'syscall'
        if (last6 == SYSCALL_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("syscall\n");
            } else if (identifier == EXE_INSTR) {
                int sysRetVal = syscall(registers);
                // Bad/exit syscall -> stop execution
                if (sysRetVal == BAD_SYSCALL || sysRetVal == EXIT_SYSCALL) {
                    return STOP_EXEC;
                }
            }
            return VALID_INSTR;
        }
        // If reaches here, invalid instruction
        return INVALID_INSTR;
    }

    // First 6 bits NOT 0
    else if (first6 != 0) {
        // Chec 8 pokssible cases - looking at the first 6 bits
        // 'mul'
        if (first6 == MUL_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("mul  $%d, $%d, $%d\n", dReg, sReg, tReg);
            } else if (identifier == EXE_INSTR) {
                mul(registers, sReg, tReg, dReg);
            }
            return VALID_INSTR;
        }
        // 'beq'
        if (first6 == BEQ_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("beq  $%d, $%d, %d\n", sReg, tReg, imm);
            } else if (identifier == EXE_INSTR) {
                int checkTerm = beq(registers, sReg, tReg, imm, PC);
                if (checkTerm == TERMINATE) {
                    return STOP_EXEC;
                }
            }
            return VALID_INSTR;
        }
        // 'bne'
        if (first6 == BNE_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("bne  $%d, $%d, %d\n", sReg, tReg, imm);
            } else if (identifier == EXE_INSTR) {
                int checkTerm = bne(registers, sReg, tReg, imm, PC);
                if (checkTerm == TERMINATE) {
                    return STOP_EXEC;
                }
            }
            return VALID_INSTR;
        }
        // 'addi'
        if (first6 == ADDI_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("addi $%d, $%d, %d\n", tReg, sReg, imm);
            } else if (identifier == EXE_INSTR) {
                addi(registers, sReg, tReg, imm);
            }
            return VALID_INSTR;
        }
        // 'slti'
        if (first6 == SLTI_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("slti $%d, $%d, %d\n", tReg, sReg, imm);
            } else if (identifier == EXE_INSTR) {
                slti(registers, sReg, tReg, imm);
            }
            return VALID_INSTR;
        }
        // 'andi'
        if (first6 == ANDI_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("andi $%d, $%d, %d\n", tReg, sReg, imm);
            } else if (identifier == EXE_INSTR) {
                andi(registers, sReg, tReg, imm);
            }
            return VALID_INSTR;
        }
        // 'ori'
        if (first6 == ORI_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("ori  $%d, $%d, %d\n", tReg, sReg, imm);
            } else if (identifier == EXE_INSTR) {
                ori(registers, sReg, tReg, imm);
            }
            return VALID_INSTR;
        }
        // 'lui'
        if (first6 == LUI_OPCODE) {
            if (identifier == PRINT_INSTR) {
                printf("lui  $%d, %d\n", tReg, imm);
            } else if (identifier == EXE_INSTR) {
                lui(registers, tReg, imm);
            }
            return VALID_INSTR;
        }
        // If reaches here, invalid instruction
        return INVALID_INSTR;
    }

    // Otherwise, invalid instruction code
    return INVALID_INSTR;
}

// Prints out all registers that are non-zero after execution
void printRegisters(int registers[NUM_REG]) {
    printf("Registers After Execution\n");
    for (int j = 1; j < NUM_REG; j++) {
        if (registers[j] != 0) {
            printf("$%-3d= %d\n", j, registers[j]);
        }
    }
}

// 'add' instruction - Adds 2 reg's, result in dest reg
void add(int registers[NUM_REG], int s, int t, int d) {
    registers[d] = registers[s] + registers[t];
}

// 'sub' instruction - Subtracts 2 source reg's, result in dest reg
void sub(int registers[NUM_REG], int s, int t, int d) {
    registers[d] = registers[s] - registers[t];
}

// 'and' instruction - bitwise op. '&' with two reg's, result in dest reg
void and(int registers[NUM_REG], int s, int t, int d) {
    registers[d] = registers[s] & registers[t];
}

// 'or' instruction - bitwise op. '|' with two reg's, result in dest reg
void or(int registers[NUM_REG], int s, int t, int d) {
    registers[d] = registers[s] | registers[t];
}

// 'slt' instruction - if sReg < tReg, dest reg = 1, otherwise = 0
void slt(int registers[NUM_REG], int s, int t, int d) {
    if (registers[s] < registers[t]) {
        registers[d] = 1;
    } else {
        registers[d] = 0;
    }
}

// 'mul' instruction - multiply two reg's, result in dest reg
void mul(int registers[NUM_REG], int s, int t, int d) {
    registers[d] = registers[s] * registers[t];
}

// 'beq' instruction - if sReg == tReg, change program counter accordingly
int beq(int registers[NUM_REG], int s, int t, int16_t imm, int *PC) {
    if (registers[s] == registers[t]) {
        *PC += (imm - 1);
        // If PC out of bounds, stop execution
        if (*PC < 0 || *PC > MAX_INSTR_CODES) {
            return TERMINATE;
        }
    }
    return 0;
}

// 'bne' instruction - if sReg !=tReg, change program counter accordingly
int bne(int registers[NUM_REG], int s, int t, int16_t imm, int *PC) {
    if (registers[s] != registers[t]) {
        *PC += (imm - 1);
        // If PC out of bounds, stop execution
        if (*PC < 0 || *PC > MAX_INSTR_CODES) {
            return TERMINATE;
        }
    }
    return 0;
}

// 'addi' instruction - add sReg w/ imm, result in tReg
void addi(int registers[NUM_REG], int s, int t, int16_t imm) {
    registers[t] = registers[s] + imm;
}

// 'slti' instruction - if sReg < imm, tReg set to 1, otherwise set to 0
void slti(int registers[NUM_REG], int s, int t, int16_t imm) {
    if (registers[s] < imm) {
        registers[t] = 1;
    } else {
        registers[t] = 0;
    }
}

// 'andi' instruction - bitwise op. '&' w/ sReg and imm, result in tReg
void andi(int registers[NUM_REG], int s, int t, int16_t imm) {
    registers[t] = registers[s] & imm;
}

// 'ori' instruction - bitwise op. '|' w/ sReg and imm, result in tReg
void ori(int registers[NUM_REG], int s, int t, int16_t imm) {
    registers[t] = registers[s] | imm;
}

// 'lui' instruction - bit shift immediate 16 left, result in tReg
void lui(int registers[NUM_REG], int t, int16_t imm) {
    registers[t] = imm << 16;
}

// 'syscall' instruction - execute a function with a specified parameter $v0
// Function will return appropriate return value after being called
int syscall(int registers[NUM_REG]) {
    // $v0/$2 = 10 -> exit
    if (registers[VZERO_INDEX] == 10) {
        return EXIT_SYSCALL;
    }
    // $v0 or $2 = 1 -> print integer
    else if (registers[VZERO_INDEX] == 1) {
        printf("%d", registers[AZERO_INDEX]);
    }
    // $v0 or $2 = 11 -> print character (LOWEST 8 BITS)
    else if (registers[VZERO_INDEX] == 11) {
        printf("%c", (uint8_t)registers[AZERO_INDEX]);
    }
    // Otherwise unknown syscall
    else {
        printf("Unknown system call: %d\n", registers[VZERO_INDEX]);
        return BAD_SYSCALL;
    }
    return GOOD_SYSCALL;
}
