//
//  HexagonCtx.m
//  HexagonCPU
//
//  Created by Tom Burmeister on 02.06.17.
//  Copyright © 2017 Tom Burmeister. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexagonCtx.h"
#import "HexagonCPU.h"
#import <Hopper/CommonTypes.h>
#import <Hopper/CPUDefinition.h>
#import <Hopper/HPDisassembledFile.h>
#import <libkern/OSByteOrder.h>

#define BIT_0(A)  ((A) & 0x00000001)
#define BIT_1(A)  ((A) & 0x00000002)
#define BIT_2(A)  ((A) & 0x00000004)
#define BIT_3(A)  ((A) & 0x00000008)
#define BIT_4(A)  ((A) & 0x00000010)
#define BIT_5(A)  ((A) & 0x00000020)
#define BIT_6(A)  ((A) & 0x00000040)
#define BIT_7(A)  ((A) & 0x00000080)
#define BIT_8(A)  ((A) & 0x00000100)
#define BIT_9(A)  ((A) & 0x00000200)
#define BIT_A(A)  ((A) & 0x00000400)
#define BIT_B(A)  ((A) & 0x00000800)
#define BIT_C(A)  ((A) & 0x00001000)
#define BIT_D(A)  ((A) & 0x00002000)
#define BIT_E(A)  ((A) & 0x00004000)
#define BIT_F(A)  ((A) & 0x00008000)
#define BIT_10(A) ((A) & 0x00010000)
#define BIT_11(A) ((A) & 0x00020000)
#define BIT_12(A) ((A) & 0x00040000)
#define BIT_13(A) ((A) & 0x00080000)
#define BIT_14(A) ((A) & 0x00100000)
#define BIT_15(A) ((A) & 0x00200000)
#define BIT_16(A) ((A) & 0x00400000)
#define BIT_17(A) ((A) & 0x00800000)
#define BIT_18(A) ((A) & 0x01000000)
#define BIT_19(A) ((A) & 0x02000000)
#define BIT_1A(A) ((A) & 0x04000000)
#define BIT_1B(A) ((A) & 0x08000000)
#define BIT_1C(A) ((A) & 0x10000000)
#define BIT_1D(A) ((A) & 0x20000000)
#define BIT_1E(A) ((A) & 0x40000000)
#define BIT_1F(A) ((A) & 0x80000000)
#define EXTRACT(INS, COUNT, OFFSET) ((INS & ((uint)(__builtin_powi(2, COUNT)-1) << OFFSET)) >> OFFSET)
#define SETBITS(INS) (32 - __builtin_clz(INS))
#define MATCH(SRC, TRG) (!(SRC ^ TRG))
#define MATCHRT(SRC, TRG) (!((SRC&0b1110000) ^ TRG))
#define MATCHIT(SRC, TRG) (!((SRC&0b1111) ^ TRG))
#define MATCHRS(SRC, TRG) (!((SRC&0b110000) ^ TRG))



static uint8_t lowClass[] = {HID_L1, HID_L2, HID_L2, HID_A, HID_L1, HID_L2, HID_S1, HID_S2, HID_S1, HID_S1, HID_S1, HID_S2, HID_S2, HID_S2, HID_S2, HID_Reserved};
static uint8_t highClass[] = {HID_L1, HID_L1, HID_L2, HID_A, HID_A, HID_A, HID_A, HID_A, HID_L1, HID_L2, HID_S1, HID_S1, HID_L1, HID_L2, HID_S2, HID_Reserved};

@implementation HexagonCtx {
    HexagonCPU *_cpu;
    NSObject<HPDisassembledFile> *_file;
    BOOL duplex;
}

- (instancetype)initWithCPU:(HexagonCPU *)cpu andFile:(NSObject<HPDisassembledFile> *)file {
    if (self = [super init]) {
        _cpu = cpu;
        _file = file;
    }
    return self;
}

- (void)dealloc {}

- (NSObject<CPUDefinition> *)cpuDefinition {
    return _cpu;
}

- (void)initDisasmStructure:(DisasmStruct *)disasm withSyntaxIndex:(NSUInteger)syntaxIndex {
    bzero(disasm, sizeof(DisasmStruct));
}

// Analysis

- (Address)adjustCodeAddress:(Address)address {
    return address & ~3;
}

- (uint8_t)cpuModeFromAddress:(Address)address {
    return 0;
}

- (BOOL)addressForcesACPUMode:(Address)address {
    return NO;
}

- (Address)nextAddressToTryIfInstructionFailedToDecodeAt:(Address)address forCPUMode:(uint8_t)mode {
    return ((address & ~3) + 4);
}

- (int)isNopAt:(Address)address {
    uint32_t word = [_file readUInt32AtVirtualAddress:address];
    return (word == 0x00cc007f) ? 4 : 0;
}

- (BOOL)hasProcedurePrologAt:(Address)address {
    // procedures usually begins with allocframe
    uint32_t word = [_file readUInt32AtVirtualAddress:address];
    return (word & 0xffff3800) == 0xa09d0000;
}

- (NSUInteger)detectedPaddingLengthAt:(Address)address {
    NSUInteger len = 0;
    while ([_file readUInt32AtVirtualAddress:address] == 0) {
        address += 4;
        len += 4;
    }
    
    return len;
}

- (void)analysisBeginsAt:(Address)entryPoint {
    
}

- (void)analysisEnded {
    
}

- (void)procedureAnalysisBeginsForProcedure:(NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint {
    
}

- (void)procedureAnalysisOfPrologForProcedure:(NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint {
    
}

- (void)procedureAnalysisOfEpilogForProcedure:(NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint {
    
}

- (void)procedureAnalysisEndedForProcedure:(NSObject<HPProcedure> *)procedure atEntryPoint:(Address)entryPoint {
    
}

- (void)procedureAnalysisContinuesOnBasicBlock:(NSObject<HPBasicBlock> *)basicBlock {
    
}

- (Address)getThunkDestinationForInstructionAt:(Address)address {
    return BAD_ADDRESS;
}

- (void)resetDisassembler {
    
}

- (uint8_t)estimateCPUModeAtVirtualAddress:(Address)address {
    return 0;
}

uint32_t memory_read_callback(uint32_t address, void* private) {
    HexagonCtx *ctx = (__bridge HexagonCtx *)private;
    return [ctx readWordAt:address];
}

- (uint32_t)readWordAt:(uint32_t)address {
    return [_file readUInt32AtVirtualAddress:address];
}

- (bool)firstInPacket:(uint32_t)addr {
    uint8_t last = EXTRACT([self readWordAt: addr-4], 2, 14);
    return last == 0b00 || last == 0b11;
}

- (uint32) getImmFromExt:(uint32_t)code {
    return (EXTRACT(code, 14, 0) | (EXTRACT(code, 12, 16) << 14)) << 6;
}

- (void) decodeConstantExtender:(insn_t*) inst {
    strcpy(inst->parts[0].mnemonic, "immext");
    
    insp_t *p = &inst->parts[0];
    
    openc_t *op = &p->operands[0];
    p->opOrder = op_imm1;
    op->type = imm_u;
    op->val = [self getImmFromExt:inst->code];
}

- (void) decodeAlu32:(insn_t*) inst { // 0111
    uint32_t majOp = EXTRACT(inst->code, 3, 24);
    uint32_t minOp = EXTRACT(inst->code, 3, 21);
    uint32_t rsBit = EXTRACT(inst->code, 1, 27);
    uint8_t _minOp, _majOp;
    uint16_t dst = 0, src1 = 0, src2 = 0, src3 = 0;
    
    insp_t *p = &inst->parts[0];
    
    uint8_t opCount = 0;
    openc_t *op = &p->operands[opCount];
    
    if((rsBit && majOp == 0b110) || (!rsBit && majOp == 100) || (majOp == 0 && BIT_D(inst->code))) {
        p->opOrder |= op_psrc;
        p->type |= in_condition;
        op->type = reg_p;
        
        if(!majOp) {
            op->val = EXTRACT(inst->code, 2, 8);
            op->modifier |= BIT_B(inst->code) ? mod_negated : 0;
            op->modifier |= BIT_A(inst->code) ? mod_new : 0;
        } else {
            op->val = EXTRACT(inst->code, 2, 21);
            op->modifier |= BIT_2(minOp) ? mod_negated : 0;
            op->modifier |= BIT_D(inst->code) ? mod_new : 0;
        }
        
        p = &inst->parts[1];
        op = &p->operands[opCount];
    }
    
    switch(rsBit) {
        case 0b0:
            switch(majOp) {
                case 0b0:
                    dst = reg_r | reg_d | reg_32;
                    src1 = reg_r | reg_s | reg_32;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "aslh"); break;
                        case 0b1: strcpy(p->mnemonic, "asrh"); break;
                        case 0b100: strcpy(p->mnemonic, "zxtb"); break;
                        case 0b101: strcpy(p->mnemonic, "sxtb"); break;
                        case 0b110: strcpy(p->mnemonic, "zxth"); break;
                        case 0b111: strcpy(p->mnemonic, "sxth"); break;
                    }
                    break;
                case 0b001: p->type |= in_as_only; dst = reg_r | reg_x | reg_lo; src1 = imm_u; break; //Rx.L = #u16
                case 0b010: p->type |= in_as_only; dst = reg_r | reg_x | reg_hi; src1 = imm_u; break; //Rx.H = #u16
                case 0b11:
                    _minOp = !BIT_D(inst->code) ? (minOp & 0b100) + 0b1000 : minOp&0b011;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "combine"); dst = reg_r | reg_d | reg_64; src1 = reg_r | reg_s | reg_32; src2 = imm_s; break;
                        case 0b1: strcpy(p->mnemonic, "combine"); dst = reg_r | reg_d | reg_64; src1 = imm_s; src2 = reg_r | reg_s | reg_32; break;
                        case 0b10: strcpy(p->mnemonic, "cmp.eq"); dst = reg_r | reg_d | reg_32; src1 = reg_r | reg_s | reg_32; src2 = imm_s;break;
                        case 0b11: strcpy(p->mnemonic, "cmp.eq"); dst = reg_r | reg_d | reg_32; src1 = reg_r | reg_s | reg_32; src2 = imm_s; p->type |= in_negated; break;
                        case 0b1000: strcpy(p->mnemonic, "mux"); dst = reg_r | reg_d | reg_32; src1 = reg_p; src2 = reg_r | reg_s | reg_32; src3 = imm_s; break;
                        case 0b1100: strcpy(p->mnemonic, "mux"); dst = reg_r | reg_d | reg_32; src1 = reg_p; src2 = imm_s; src3 = reg_r | reg_s | reg_32; break;
                    }
                    break;
                case 0b100:
                    _minOp = minOp>>2;
                    dst = reg_r | reg_d | reg_32;
                    src1 = reg_r | reg_s | reg_32;
                    src2 = imm_s;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "add"); break;
                        case 0b1: strcpy(p->mnemonic, "add"); break;
                    }
                    break;
                case 0b101:
                    _minOp = minOp <0b100 ? minOp>>1 : minOp;
                    dst = reg_p;
                    src1 = reg_r | reg_s | reg_32;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "cmp.eq"); src2 = imm_s; p->type |= BIT_4(inst->code) ? in_negated : 0; break;
                        case 0b1: strcpy(p->mnemonic, "cmp.gt"); src2 = imm_s; p->type |= BIT_4(inst->code) ? in_negated : 0; break;
                        case 0b100: strcpy(p->mnemonic, "cmp.gtu"); src2 = imm_u; p->type |= BIT_4(inst->code) ? in_negated : 0; break;
                    }
                    break;
                case 0b110:
                    _minOp = minOp>>1;
                    dst = reg_r | reg_d | reg_32;
                    src1 = reg_r | reg_s | reg_32;
                    src2 = imm_s;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "and"); break;
                        case 0b10: strcpy(p->mnemonic, "or"); break;
                    }
                    break;
            }
            break;
        case 0b1:
            _majOp = (majOp&0b110) == 0b010 ? 0b1 : majOp;
            switch(_majOp) {
                case 0b000: p->type |= in_as_only; dst = reg_r | reg_d | reg_32; src1 = imm_s; break; //Rd=#s16
                case 0b1: strcpy(p->mnemonic, "mux"); dst = reg_r | reg_d | reg_32; src1 = reg_p; src2 = imm_s; src3 = imm_s; break;
                case 0b100:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "combine"); dst = reg_r | reg_d | reg_64; src1 = imm_s; src2 = imm_s; break;
                        case 0b1: strcpy(p->mnemonic, "combine"); dst = reg_r | reg_d | reg_64; src1 = imm_s; src2 = imm_u; break;
                    }
                    break;
                case 0b110: p->type |= in_as_only; dst = reg_r | reg_d | reg_32; src1 = imm_s; break; //Rd=#s12
                case 0b111: strcpy(p->mnemonic, "nop"); p->type |= in_nop; break;
            }
            break;
    }
    
    op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(dst, reg_d)? op_dst : MATCHRT(dst, reg_x)? op_xrc : op_pdst) << (op_size * opCount++);
    op->type = dst;
    op->val = EXTRACT(inst->code, (MATCHIT(dst, (reg_p)) ? 2 : 5), (MATCHRT(dst, reg_x) ? 5 : 0));

    op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(src1, reg_s)? op_src : MATCHIT(src1, reg_p )? op_psrc : op_imm1) << (op_size * opCount++);
    op->type = src1;
    op->val = MATCHRT(src1, reg_s) ? EXTRACT(inst->code, 5, 16) :
    MATCHIT(src1, (reg_p)) ? EXTRACT(inst->code, 2, (MATCHIT(src2, imm_s) && MATCHIT(src3, imm_s) ? 23 : 21)) :
    MATCHIT(src1, imm_u) ? EXTRACT(inst->code, 14, 0) | EXTRACT(inst->code, 2, 22) << 14 :
    majOp == 0 ? EXTRACT(inst->code, 9, 5) | EXTRACT(inst->code, 5, 16) << 9 | EXTRACT(inst->code, 2, 22) << 14 :
    EXTRACT(inst->code, 8, 5) | (majOp != 0b100 ? EXTRACT(inst->code, 4, 16) << 8 : 0);
    
    
    if(src2){
        op = &p->operands[opCount];
        p->opOrder |= (MATCHRT(src2, reg_s)? op_src : MATCH(src1&0b1, regi)? op_imm1 : op_imm2) << (op_size * opCount++);
        op->type = src2;
        op->val = MATCHRT(src2, reg_s)? EXTRACT(inst->code, 5, 16) :
        MATCHIT(dst, (reg_p))? EXTRACT(inst->code, 9, 5) | EXTRACT(inst->code, 1, 21) << 9: // #s10 / #u9
        MATCHRS(dst, reg_64)? EXTRACT(inst->code, 1, 13) | EXTRACT(inst->code, MATCHIT(src2, imm_u)? 5 : 7, 16) << 1 : //#S8, #U6
        EXTRACT(inst->code, 8, 5); //#s8
        
        if(src3) {
            op = &p->operands[opCount];
            p->opOrder |= (MATCHRT(src3, reg_s)? op_src : op_imm2) << (op_size * opCount++);
            op->type = src3;
            op->val = MATCHRT(src3, reg_s)? EXTRACT(inst->code, 5, 16) : // Rs
            MATCHRT(src2, reg_s)? EXTRACT(inst->code, 8, 5): // #s8
            EXTRACT(inst->code, 1, 13) | EXTRACT(inst->code, 7, 16) << 1; // #S8
        }
    }
    
}

- (void) decodeAlu32_2:(insn_t*) inst {
    insp_t *p = &inst->parts[0];
    strcpy(p->mnemonic, "add");
    
    uint8_t opCount = 0;
    
    openc_t *op = &p->operands[opCount];
    p->opOrder |= op_dst << (op_size * opCount++);
    op->type = reg_r | reg_d | reg_32;
    op->val = EXTRACT(inst->code, 5, 0);
    
    op = &p->operands[opCount];
    p->opOrder |= op_src << (op_size * opCount++);
    op->type = reg_r | reg_s | reg_32;
    op->val = EXTRACT(inst->code, 5, 16);
    
    op = &p->operands[opCount];
    p->opOrder |= op_imm1 << (op_size * opCount++);
    op->type = imm_s;
    op->val = EXTRACT(inst->code, 9, 5) | (EXTRACT(inst->code, 7, 21) << 9);
    
    p->opOrder |= op_stop << (op_size * opCount);
}

- (void) decodeAlu32_3:(insn_t*) inst {
    uint8_t predicated = EXTRACT(inst->code, 1, 27);
    uint8_t majOp = EXTRACT(inst->code, 3, 24);
    uint8_t minOp = EXTRACT(inst->code, 3, 21);
    uint8_t _minOp;
    
    uint16_t dst = reg_r | reg_d | reg_32;
    uint16_t src1 = reg_r, src2 = reg_r, src2mod = 0;

    insp_t *p = &inst->parts[0];
    
    uint8_t opCount = 0;
    openc_t *op = &p->operands[opCount];
    
    switch(predicated) {
        case 0b0:
            switch(majOp) {
                case 0b1:
                    src1 = reg_r | reg_32;
                    src2 = reg_r | reg_32;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "and"); src1 |= reg_s; src2 |= reg_t; break;
                        case 0b1: strcpy(p->mnemonic, "or"); src1 |= reg_s; src2 |= reg_t; break;
                        case 0b11: strcpy(p->mnemonic, "xor"); src1 |= reg_s; src2 |= reg_t; break;
                        case 0b100: strcpy(p->mnemonic, "and"); src1 |= reg_t; src2 |= reg_s; src2mod = mod_complement; break;
                        case 0b101: strcpy(p->mnemonic, "or"); src1 |= reg_t; src2 |= reg_s; src2mod = mod_complement; break;
                    }
                    break;
                case 0b10:
                    src1 = reg_r | reg_s | reg_32;
                    src2 = reg_r | reg_t | reg_32;
                    
                    if(minOp < 0b100) {
                        _minOp = EXTRACT(inst->code, 3, 2) | minOp;
                        dst = reg_p;
                    } else {
                        if(minOp>>1 == 0b10) {
                            strcpy(p->mnemonic, "combine");
                            dst = reg_r | reg_d | reg_64;
                        }
                        break;
                    }
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "cmp.eq"); break;
                        case 0b10: strcpy(p->mnemonic, "cmp.gt"); break;
                        case 0b11: strcpy(p->mnemonic, "cmp.gtu"); break;
                        case 0b100: strcpy(p->mnemonic, "cmp.eq"); p->type |= in_negated; break;
                        case 0b110: strcpy(p->mnemonic, "cmp.gt"); p->type |= in_negated; break;
                        case 0b111: strcpy(p->mnemonic, "cmp.gtu"); p->type |= in_negated; break;
                    }
                    break;
                case 0b11:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "add"); src1 |= reg_s | reg_32; src2 |= reg_t | reg_32; break;
                        case 0b1: strcpy(p->mnemonic, "sub"); src1 |= reg_t | reg_32; src2 |= reg_s | reg_32; break;
                        case 0b10: strcpy(p->mnemonic, "cmp.eq"); src1 |= reg_s | reg_32; src2 |= reg_t | reg_32; break;
                        case 0b11: strcpy(p->mnemonic, "cmp.eq"); p->type |= in_negated; src1 |= reg_s | reg_32; src2 |= reg_t | reg_32; break;
                        case 0b100: strcpy(p->mnemonic, "combine"); src1 |= reg_t | reg_hi; src2 |= reg_s | reg_hi; break;
                        case 0b101: strcpy(p->mnemonic, "combine"); src1 |= reg_t | reg_hi; src2 |= reg_s | reg_lo; break;
                        case 0b110: strcpy(p->mnemonic, "combine"); src1 |= reg_t | reg_lo; src2 |= reg_s | reg_hi; break;
                        case 0b111: strcpy(p->mnemonic, "combine"); src1 |= reg_t | reg_lo; src2 |= reg_s | reg_lo; break;
                    }
                    break;
                case 0b110:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vaddh"); src1 |= reg_s; src2 |= reg_t; break;
                        case 0b1: strcpy(p->mnemonic, "vaddh"); p->type |= in_sat; src1 |= reg_s; src2 |= reg_t; break;
                        case 0b10: strcpy(p->mnemonic, "add"); p->type |= in_sat; src1 |= reg_s; src2 |= reg_t; break;
                        case 0b11: strcpy(p->mnemonic, "vadduh"); p->type |= in_sat; src1 |= reg_s; src2 |= reg_t; break;
                        case 0b100: strcpy(p->mnemonic, "vsubh"); src1 |= reg_t; src2 |= reg_s; break;
                        case 0b101: strcpy(p->mnemonic, "vsubh"); p->type |= in_sat; src1 |= reg_t; src2 |= reg_s; break;
                        case 0b110: strcpy(p->mnemonic, "sub"); p->type |= in_sat; src1 |= reg_t; src2 |= reg_s; break;
                        case 0b111: strcpy(p->mnemonic, "vsubuh"); p->type |= in_sat; src1 |= reg_t; src2 |= reg_s; break;
                    }
                    break;
                case 0b111:
                    _minOp = minOp>>1;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "vavgh"); src1 |= reg_s; src2 |= reg_t; break;
                        case 0b1: strcpy(p->mnemonic, "vavgh"); p->type |= in_rnd; src1 |= reg_s; src2 |= reg_t; break;
                        case 0b11: strcpy(p->mnemonic, "vnavgh"); src1 |= reg_t; src2 |= reg_s; break;
                    }
                    break;
            }
            break;
        case 0b1:
            p->opOrder |= op_psrc;
            p->type |= in_condition;
            op->type = reg_p;
            op->val = 0;
            op->modifier |= BIT_7(inst->code) ? mod_negated : 0;
            op->modifier |= BIT_D(inst->code) ? mod_new : 0;
            
            p = &inst->parts[1];
            op = &p->operands[opCount];
            
            src1 = reg_r | reg_s | reg_32;
            src2 = reg_r | reg_t | reg_32;
            switch(majOp) {
                case 0b1:
                    _minOp = minOp & 0b011;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "and"); break;
                        case 0b1: strcpy(p->mnemonic, "or"); break;
                        case 0b11: strcpy(p->mnemonic, "xor"); break;
                    }
                    break;
                case 0b11:
                    _minOp = minOp & 0b001;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "add"); break;
                        case 0b1: strcpy(p->mnemonic, "sub"); break;
                    }
                    break;
                case 0b101: strcpy(p->mnemonic, "combine"); dst = reg_r | reg_d | reg_64; break;
            }
            break;
    }
    
    p->opOrder |= (reg_d & dst ? op_dst : op_pdst) << (op_size * opCount++);
    op->type = dst;
    op->val = EXTRACT(inst->code, reg_d & dst ? 5 : 2, 0);
    
    op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(src1, reg_s)? op_src : op_trc) << (op_size * opCount++);
    op->type = src1;
    op->val = EXTRACT(inst->code, 5, (MATCHRT(src1, reg_s)? 16: 8));
    
    op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(src2, reg_s)? op_src : op_trc) << (op_size * opCount++);
    op->type = src2;
    op->val = EXTRACT(inst->code, 5, (MATCHRT(src2, reg_s)? 16: 8));
    op->modifier = src2mod;
    
}

- (void) decodeControl:(insn_t*) inst { // 0110
    uint32_t mask1 = inst->code & 0x0fe02090;
    uint32_t mask2 = inst->code & 0x0f002000;
    uint32_t mask3 = inst->code & 0x0fff0000;
    uint32_t mask4 = inst->code & 0x0fc01000;
    uint32_t mask5 = inst->code & 0x0fe02000;
    
    insp_t *p = &inst->parts[0];
    
    if(MATCH(mask1, 0x0b002090)) {
        strcpy(p->mnemonic, "fastcorner9");
        p->type |= BIT_15(inst->code) ? in_negated : 0;
        uint8_t opCount = 0;
        
        openc_t *op = &p->operands[opCount];
        p->opOrder |= op_pdst << (op_size * opCount++);
        op->type = reg_p;
        op->val = EXTRACT(inst->code, 2, 0);
        
        op = &p->operands[opCount];
        p->opOrder |= op_psrc << (op_size * opCount++);
        op->type = reg_p;
        op->val = EXTRACT(inst->code, 2, 16);
        
        op = &p->operands[opCount];
        p->opOrder |= op_ptrc << (op_size * opCount++);
        op->type = reg_p;
        op->val = EXTRACT(inst->code, 2, 8);
        
        p->opOrder |= op_stop << (op_size * opCount);
        return;
    }
    
    if(MATCH(mask2, 0x0b000000)) {
        uint8_t type = 0;
        char mne[4];
        bool negate = false;
        
        switch EXTRACT(inst->code, 4, 21) {
        case 0x0: //Pd = and(Pt, Ps)
            strcpy(p->mnemonic, "and");
            break;
        case 0x1: //Pd = and(Ps, and(Pt, Pu))
            strcpy(p->mnemonic, "and"); type = 1; strcpy(mne, "and");
            break;
        case 0x2: //Pd = or(Pt, Ps)
            strcpy(p->mnemonic, "or");
            break;
        case 0x3: //Pd = and(Ps, or(Pt, Pu))
            strcpy(p->mnemonic, "and"); type = 1; strcpy(mne, "or");
            break;
        case 0x4: //Pd = xor(Pt, Ps)
            strcpy(p->mnemonic, "xor");
            break;
        case 0x5: //Pd = or(Ps, and(Pt, Pu))
            strcpy(p->mnemonic, "or"); type = 1; strcpy(mne, "and");
            break;
        case 0x6: //Pd = and(Pt, !Ps)
            strcpy(p->mnemonic, "and"); negate = true;
            break;
        case 0x7: //Pd = or(Ps, or(Pt, Pu))
            strcpy(p->mnemonic, "or"); type = 1; strcpy(mne, "or");
            break;
        case 0x8: //BIT_11 ? Pd = any8(Ps) : Pd = all8(Ps)
            strcpy(p->mnemonic, BIT_11(inst->code) ? "any8" : "all8"); type = 2;
            break;
        case 0x9: //Pd = and(Ps, and(Pt, !Pu))
            strcpy(p->mnemonic, "and"); type = 1; strcpy(mne, "and"); negate = true;
            break;
        case 0xb: //Pd = and(Ps, or(Pt, !Pu))
            strcpy(p->mnemonic, "and"); type = 1; strcpy(mne, "or"); negate = true;
            break;
        case 0xc: //Pd = not(Ps)
            strcpy(p->mnemonic, "not"); break;
        case 0xd: //Pd = or(Ps, and(Pt, !Pu))
            strcpy(p->mnemonic, "or"); type = 1; strcpy(mne, "and"); negate = true;
            break;
        case 0xe: //Pd = or(Pt, !Ps)
            strcpy(p->mnemonic, "or"); negate = true;
            break;
        case 0xf: //Pd = or(Ps, or(Pt, !Pu))
            strcpy(p->mnemonic, "or"); type = 1; strcpy(mne, "or"); negate = true;
            break;
        default: return;
        }
        
        uint8_t opCount = 0;
        openc_t *op = &p->operands[opCount];
        p->opOrder |= op_pdst << (op_size * opCount++);
        op->type = reg_p;
        op->val = EXTRACT(inst->code, 2, 0);
        
        switch(type) {
            case 0: // pd, ps, pt
                op = &p->operands[opCount];
                p->opOrder |= op_psrc << (op_size * opCount++);
                op->type = reg_p;
                op->val = EXTRACT(inst->code, 2, 16);
                
                op = &p->operands[opCount];
                p->opOrder |= op_ptrc << (op_size * opCount++);
                op->type = reg_p;
                op->val = EXTRACT(inst->code, 2, 8);
                op->modifier = negate ? mod_negated : 0;
                break;
            case 1: // pd, ps, composite(pt, pu)
                op = &p->operands[opCount];
                p->opOrder |= op_psrc << (op_size * opCount++);
                op->type = reg_p;
                op->val = EXTRACT(inst->code, 2, 16);
                
                op = &p->operands[opCount];
                p->opOrder |= op_comp << (op_size * opCount++);
                op->composite = true;
                
                p->opOrder |= op_stop << (op_size * opCount);
                
                p = &inst->parts[1];
                strcpy(p->mnemonic, mne);
                
                opCount = 0;
                
                op = &p->operands[opCount];
                p->opOrder |= op_ptrc << (op_size * opCount++);
                op->type = reg_p;
                op->val = EXTRACT(inst->code, 2, 8);
                
                op = &p->operands[opCount];
                p->opOrder |= op_purc << (op_size * opCount++);
                op->type = reg_p;
                op->val = EXTRACT(inst->code, 2, 6);
                op->modifier = negate ? mod_negated : 0;
                break;
            case 2: // pd, ps
                op = &p->operands[opCount];
                p->opOrder |= op_psrc << (op_size * opCount++);
                op->type = reg_p;
                op->val = EXTRACT(inst->code, 2, 16);
                break;
        }
        
        p->opOrder |= op_stop << (op_size * opCount);

        
        return;
    }
    
    if(MATCH(mask3, 0x0a490000)) {
        //Rd = add(pc, #u6)
        strcpy(p->mnemonic, "add");
        uint8_t opCount = 0;
        
        openc_t *op = &p->operands[opCount];
        p->opOrder |= op_dst << (op_size * opCount++);
        op->type = reg_r | reg_d | reg_32;
        op->val = EXTRACT(inst->code, 5, 0);
        
        op = &p->operands[opCount];
        p->opOrder |= op_src << (op_size * opCount++);
        op->type = reg_pc;
        
        op = &p->operands[opCount];
        p->opOrder |= op_imm1 << (op_size * opCount++);
        op->type = imm_u;
        op->val = EXTRACT(inst->code, 6, 7);
        
        p->opOrder |= op_stop << (op_size * opCount);
        return;
    }
    
    if(mask4 & 0x01000000) {
        //jump
        //BIT_10 ? t : nt
        p->type |= in_condition;
        p->opOrder |= op_src | (op_imm1 << op_size) | (op_stop << op_size*2);
        
        openc_t *op = &p->operands[0];
        op->type = reg_r | reg_s | reg_32;
        op->val = EXTRACT(inst->code, 5, 22);
    
        op = &p->operands[1];
        op->type = imm_u;
        op->val = 0;
        
        switch(EXTRACT(inst->code, 4, 21)){
            case 0x0:
                inst->branch = DISASM_BRANCH_JNE; break;
            case 0x4:
                inst->branch = DISASM_BRANCH_JGE; break;
            case 0x8:
                inst->branch = DISASM_BRANCH_JE; break;
            case 0xc:
                inst->branch = DISASM_BRANCH_JLE; break;
                break;
            default: return;
        }
    
        p = &inst->parts[1];
        strcpy(p->mnemonic, "jump");
        p->type |= in_branch;
        p->opOrder |= op_imm1 | (op_stop << op_size);
        
        op = &p->operands[0];
        op->type = imm_r;
        op->val = EXTRACT(inst->code, 11, 1) | (EXTRACT(inst->code, 1, 13) << 11) | (EXTRACT(inst->code, 1, 21) << 12);
        op->modifier = mod_col2;
        return;
    }
    
    uint8_t up = EXTRACT(mask5, 8, 21);
    uint8_t isImm = EXTRACT(up, 4, 4);
    
    uint8_t opCount = 0;
    openc_t *op = &p->operands[opCount];
    
    switch(up) {
        case 0x22:
            //Cd = Rs
            p->opOrder |= op_cdst << (op_size * opCount++);
            op->type = reg_c | reg_32;
            op->val = EXTRACT(inst->code, 5, 0);
            
            op = &p->operands[opCount];
            p->opOrder |= op_src << (op_size * opCount++);
            op->type = reg_r | reg_s | reg_32;
            op->val = EXTRACT(inst->code, 5, 16);
  
            p->opOrder |= op_stop << (op_size * opCount);
            break;
        case 0x32:
            //Cdd = Rss
            p->opOrder |= op_cdst << (op_size * opCount++);
            op->type = reg_c | reg_64;
            op->val = EXTRACT(inst->code, 5, 0);
            
            op = &p->operands[opCount];
            p->opOrder |= op_src << (op_size * opCount++);
            op->type = reg_r | reg_s | reg_64;
            op->val = EXTRACT(inst->code, 5, 16);
            
            p->opOrder |= op_stop << (op_size * opCount);
            break;
        case 0x80:
            //Rdd = Css
            p->opOrder |= op_dst << (op_size * opCount++);
            op->type = reg_r | reg_d | reg_64;
            op->val = EXTRACT(inst->code, 5, 0);
            
            op = &p->operands[opCount];
            p->opOrder |= op_csrc << (op_size * opCount++);
            op->type = reg_c | reg_64;
            op->val = EXTRACT(inst->code, 5, 16);
            
            p->opOrder |= op_stop << (op_size * opCount);
            break;
        case 0xa0:
            //Rd = Cs
            p->opOrder |= op_dst << (op_size * opCount++);
            op->type = reg_r | reg_d | reg_32;
            op->val = EXTRACT(inst->code, 5, 0);
            
            op = &p->operands[opCount];
            p->opOrder |= op_csrc << (op_size * opCount++);
            op->type = reg_c | reg_32;
            op->val = EXTRACT(inst->code, 5, 16);
            
            p->opOrder |= op_stop << (op_size * opCount);
            break;
        default:
            switch(EXTRACT(up, 4, 0)) {
                case 0x0:
                    //loop0|1(#r7:2, Rs|#U10)
                    strcpy(p->mnemonic, BIT_17(mask5) ? "loop1" : "loop0");
                    break;
                case 0xa:
                    //p3 = sp1loop0(#r7:2, Rs|#U10)
                    strcpy(p->mnemonic, "sp1loop0");
                    p->opOrder |= op_pdst << (op_size * opCount++);
                    op->type = reg_p | reg_3;
                case 0xc:
                    //p3 = sp2loop0(#r7:2, Rs|#U10)
                    strcpy(p->mnemonic, "sp2loop0");
                    p->opOrder |= op_pdst << (op_size * opCount++);
                    op->type = reg_p | reg_3;
                case 0xe:
                    //p3 = sp3loop0(#r7:2, Rs|#U10)
                    strcpy(p->mnemonic, "sp3loop0");
                    p->opOrder |= op_pdst << (op_size * opCount++);
                    op->type = reg_p | reg_3;
                    break;
            }
            
            op = &p->operands[opCount];
            p->opOrder |= op_imm1 << (op_size * opCount++);
            op->type = imm_r;
            op->val = EXTRACT(inst->code, 2, 3) | (EXTRACT(inst->code, 5, 8) << 2);
            op->modifier = mod_col2;
            
            if(!isImm) {
                op = &p->operands[opCount];
                p->opOrder |= op_src << (op_size * opCount++);
                op->type = reg_r | reg_s | reg_32;
                op->val = EXTRACT(inst->code, 5, 16);
            } else {
                op = &p->operands[opCount];
                p->opOrder |= op_imm2 << (op_size * opCount++);
                op->type = imm_u;
                op->val = EXTRACT(inst->code, 2, 0) | (EXTRACT(inst->code, 3, 5) << 2) | (EXTRACT(inst->code, 5, 16) << 5);
            }
            
            p->opOrder |= op_stop << (op_size * opCount);
            break;
    }
}

- (void) decodeJump:(insn_t*) inst {
    uint8_t majOp = EXTRACT(inst->code, 5, 22);
    uint8_t mne = EXTRACT(majOp, 2, 1);
    
    if(mne < 0b11) {
        insp_t *p = &inst->parts[0];
        p->type |= in_condition;
        
        switch(mne) {
            case 0b00:
                inst->cond = DISASM_INST_COND_EQ;
                strcpy(p->mnemonic, "cmp.eq"); break;
            case 0b01:
                inst->cond = DISASM_INST_COND_GE;
                strcpy(p->mnemonic, "cmp.gt"); break;
            case 0b10:
                inst->cond = DISASM_INST_COND_GT;
                strcpy(p->mnemonic, "cmp.gtu"); break;
        }
        
        uint8_t opCount = 0;
        openc_t *op = &p->operands[opCount];
        p->opOrder |= op_pdst << (op_size * opCount++);
        op->type = reg_p | (BIT_4(majOp) ? // if not immediate choose p register based on
                                BIT_C(inst->code) ? reg_1 : reg_0 : // bit 0 min op
                                BIT_3(majOp) ? reg_1 : reg_0); // else bit 3 maj op
        
        op = &p->operands[opCount];
        p->opOrder |= op_src << (op_size * opCount++);
        op->type = reg_r | reg_s | reg_32;
        op->val = EXTRACT(inst->code, 4, 16);
        
        op = &p->operands[opCount];
        if(BIT_4(majOp) == 0) { // if immediate
            p->opOrder |= op_imm1 << (op_size * opCount++);
            op->type = imm_u;
            op->val = EXTRACT(inst->code, 5, 8);
        } else { // else register
            p->opOrder |= op_trc << (op_size * opCount++);
            op->type = reg_r | reg_t | reg_32;
            op->val = EXTRACT(inst->code, 4, 8);
        }

        p->opOrder |= op_stop << (op_size * opCount);

        p = &inst->parts[1];
        inst->branch = BIT_0(majOp) ? DISASM_BRANCH_JNE : DISASM_BRANCH_JE;
        strcpy(p->mnemonic, "jump");
        p->type |= in_branch;

        opCount = 0;
        op = &p->operands[opCount];
        p->opOrder |= op_psrc << (op_size * opCount++);
        op->type = reg_p | (BIT_3(majOp) ? reg_1 : reg_0);
        op->modifier = BIT_0(majOp) ? mod_negated : 0;
        op->modifier |= mod_new;
        
        op = &p->operands[opCount];
        p->opOrder |= op_imm1 << (op_size * opCount++);
        op->type = imm_r;
        op->val = EXTRACT(inst->code, 7, 1) | (EXTRACT(inst->code, 2, 20) << 7);
        op->modifier = mod_col2;

        p->opOrder |= op_stop << (op_size * opCount);
        
    } else {
        uint32_t minOp = EXTRACT(inst->code, 2, 8);
        uint32_t destP = BIT_D(inst->code);
        
        insp_t *p = &inst->parts[0];
        p->type |= in_condition;
        
        switch(minOp) {
            case 0b00:
                inst->cond = DISASM_INST_COND_EQ;
                strcpy(p->mnemonic, "cmp.eq"); break;
            case 0b01:
                inst->cond = DISASM_INST_COND_GE;
                strcpy(p->mnemonic, "cmp.gt"); break;
            case 0b11:
                inst->cond = DISASM_INST_COND_GT;
                strcpy(p->mnemonic, "tstbit"); break;
        }
        
        uint8_t opCount = 0;
        
        openc_t *op = &p->operands[opCount];
        p->opOrder |= op_pdst << (op_size * opCount++);
        op->type = reg_p | (destP ? reg_1 : reg_0);
        
        op = &p->operands[opCount];
        p->opOrder |= op_src << (op_size * opCount++);
        op->type = reg_r | reg_s | reg_32;
        op->val = EXTRACT(inst->code, 4, 16);
        
        op = &p->operands[opCount];
        p->opOrder |= op_imm1 << (op_size * opCount++);
        op->type = imm_s;
        op->val = (minOp < 0b11 ? -1 : 0);
        
        p->opOrder |= op_stop << (op_size * opCount);
        
        p = &inst->parts[1];
        inst->branch = BIT_0(majOp) ? DISASM_BRANCH_JNE : DISASM_BRANCH_JE;
        strcpy(p->mnemonic, "jump");
        
        opCount = 0;
        
        op = &p->operands[opCount];
        p->opOrder |= op_pdst << (op_size * opCount++);
        op->type = reg_p | (destP ? reg_1 : reg_0);
        op->modifier = BIT_0(majOp) ? mod_negated : 0;
        
        op = &p->operands[opCount];
        p->opOrder |= op_imm1 << (op_size * opCount++);
        op->type = imm_r;
        op->val = EXTRACT(inst->code, 7, 1) | (EXTRACT(inst->code, 2, 20) << 7);
        op->modifier = mod_col2;

        
        p->opOrder |= op_stop << (op_size * opCount);
    }
}

- (void) decodeJump2:(insn_t*) inst {
    uint8_t partCount = 0;
    insp_t *p = &inst->parts[partCount++];
    
    uint8_t opCount = 0;
    openc_t *op = NULL;
    
    uint8_t not = EXTRACT(inst->code, 1, 22);
    uint8_t imm = EXTRACT(inst->code, 1, 26);
    uint8_t opCode = EXTRACT(inst->code, 3, 23);
    uint8_t type = 0;
    
    p->type = in_condition;
    p->type |= not ? in_negated : 0;
    
    switch(opCode) {
        case 0b000: // cmp.eq n r|U
            strcpy(p->mnemonic, "cmp.eq"); type = imm; inst->branch = not ? DISASM_BRANCH_JNE : DISASM_BRANCH_JE; break;
        case 0b001: // cmp.gt n r|U
            strcpy(p->mnemonic, "cmp.gt"); type = imm; inst->branch = not ? DISASM_BRANCH_JNG : DISASM_BRANCH_JG; break;
        case 0b010: // cmp.gtu n r|U
            strcpy(p->mnemonic, "cmp.gtu"); type = imm; inst->branch = not ? DISASM_BRANCH_JNG : DISASM_BRANCH_JG; break;
        case 0b011: // cmp.gt r n | tstbit n 0
            strcpy(p->mnemonic, imm ? "tstbit" : "cmp.gt"); type = imm ? 3 : 2; inst->branch = imm ? DISASM_BRANCH_JE : DISASM_BRANCH_JG; inst->branch *= not ? -1 : 1; break;
        case 0b100: // cmp.gtu r n | cmp.eq n -1
            strcpy(p->mnemonic, imm ? "cmp.eq" : "cmp.gtu"); type = imm ? 4 : 2; inst->branch = imm ? DISASM_BRANCH_JE : DISASM_BRANCH_JG; inst->branch *= not ? -1 : 1; break;
        case 0b101: // - | cmp.gt n -1
            if (!imm) return; strcpy(p->mnemonic, "cmp.gt"); type = 4; inst->branch = DISASM_BRANCH_JG; break;
        default:
            return;
    }
    
    switch(type) {
        case 0: // n r
            op = &p->operands[opCount];
            p->opOrder |= op_src << (op_size * opCount++);
            op->type = reg_n;
            op->val = EXTRACT(inst->code, 3, 16);
            
            op = &p->operands[opCount];
            p->opOrder |= op_trc << (op_size * opCount++);
            op->type = reg_r | reg_t | reg_32;
            op->val = EXTRACT(inst->code, 5, 8);
            break;
        case 1: // n U
            op = &p->operands[opCount];
            p->opOrder |= op_src << (op_size * opCount++);
            op->type = reg_n;
            op->val = EXTRACT(inst->code, 3, 16);
            
            op = &p->operands[opCount];
            p->opOrder |= op_imm1 << (op_size * opCount++);
            op->type = imm_u;
            op->val = EXTRACT(inst->code, 5, 8);
            break;
        case 2: // r n
            op = &p->operands[opCount];
            p->opOrder |= op_trc << (op_size * opCount++);
            op->type = reg_r | reg_t | reg_32;
            op->val = EXTRACT(inst->code, 5, 8);
            
            op = &p->operands[opCount];
            p->opOrder |= op_src << (op_size * opCount++);
            op->type = reg_n;
            op->val = EXTRACT(inst->code, 3, 16);
            break;
        case 3: // n 0
            op = &p->operands[opCount];
            p->opOrder |= op_src << (op_size * opCount++);
            op->type = reg_n;
            op->val = EXTRACT(inst->code, 3, 16);
            
            op = &p->operands[opCount];
            p->opOrder |= op_imm1 << (op_size * opCount++);
            op->type = imm_s;
            op->val = 0;
            break;
        case 4: // n -1
            op = &p->operands[opCount];
            p->opOrder |= op_src << (op_size * opCount++);
            op->type = reg_n;
            op->val = EXTRACT(inst->code, 3, 16);
            
            op = &p->operands[opCount];
            p->opOrder |= op_imm1 << (op_size * opCount++);
            op->type = imm_s;
            op->val = -1;
        default:
            return;
    }
    
    if(not) {
        p->type |= in_negated;
    }
    
    p = &inst->parts[partCount];
    p->type = in_branch;
    strcpy(p->mnemonic, "jump");
    
    op = &p->operands[0];
    p->opOrder = op_imm1;
    op->type = imm_r;
    op->modifier = mod_col2;
    op->val = EXTRACT(inst->code, 7, 1) | (EXTRACT(inst->code, 2, 20) << 7);
}

- (void) decodeJump3:(insn_t*) inst { // 0101
    uint8_t partCount = 0;
    insp_t *p;
    
    uint32_t useImm = BIT_1B(inst->code);
    uint32_t smallImm = BIT_1A(inst->code);
    uint32_t type = BIT_19(inst->code);
    
    if(MATCH(useImm, smallImm) && BIT_18(inst->code)) { //condition
        p = &inst->parts[partCount++];
        p->type |= in_condition;
        p->opOrder |= op_psrc | (op_stop << op_size);
        openc_t *op = &p->operands[0];
        op->type = reg_p;
        op->val = EXTRACT(inst->code, 2, 8);
        op->modifier = BIT_15(inst->code) ? mod_negated : 0;
        if(!useImm) {
            op->modifier |= BIT_B(inst->code) ? mod_new : 0;
        }
    }

    p = &inst->parts[partCount];
    p->type |= in_branch;
    
    if(useImm) {
        inst->branch = DISASM_BRANCH_CALL;
        strcpy(p->mnemonic, "call");
    } else if (!type){
        inst->branch = DISASM_BRANCH_CALL;
        if(BIT_17(inst->code)) {
            strcpy(p->mnemonic, "callr");
        } else {
            strcpy(p->mnemonic, "call");
        }
    } else {
        if(BIT_17(inst->code) && BIT_15(inst->code)) {
            strcpy(p->mnemonic, "hintjr");
        } else {
            inst->branch = DISASM_BRANCH_JMP;
            strcpy(p->mnemonic, "jumpr");
        }
    }
    
    openc_t *op = &p->operands[0];
    if(useImm) {
        p->opOrder = op_imm1;
        op->modifier = mod_col2;
        op->type = imm_r;
        if(smallImm) {
            op->val = EXTRACT(inst->code, 7, 1) | (EXTRACT(inst->code, 1, 13) << 7) | (EXTRACT(inst->code, 5, 16) << 8) | (EXTRACT(inst->code, 2, 22) << 13);
        } else {
            op->val = EXTRACT(inst->code, 13, 1) | (EXTRACT(inst->code, 9, 16) << 13);
        }
    } else {
        p->opOrder = op_src;
        op->type = reg_r | reg_s | reg_32;
        op->val = EXTRACT(inst->code, 5, 16);
    }
    
    p->opOrder |= (op_stop << op_size);

}

- (void) decodeLoadStore:(insn_t*) inst {
    insp_t *p = &inst->parts[0];
    
    uint8_t opCount = 0;
    openc_t *op = &p->operands[opCount];
    
}


- (void) decodeLoadStoreConditional:(insn_t*) inst {
    uint32_t noCondition = BIT_1B(inst->code);
    uint32_t negateCond = BIT_1A(inst->code);
    uint32_t dotNew = BIT_19(inst->code);
    uint32_t load = BIT_18(inst->code);
    uint32_t opTyp = EXTRACT(inst->code, 3, 21);
    uint8_t size = 0;
    
    uint8_t opCount = 0;
    insp_t *p = &inst->parts[0];
    openc_t *op = &p->operands[opCount];
    
    if(!noCondition) {
        p->opOrder |= op_psrc;
        op->type = reg_p;
        op->val = EXTRACT(inst->code, 2, (load ? 11 : 0));
        op->modifier |= dotNew ? mod_new : 0;
        op->modifier |= negateCond ? mod_negated : 0;
        
        p->type = in_condition;
        
        p = &inst->parts[1];
        op = &p->operands[opCount];
    }
    
    switch(opTyp) {
        case 0b000: strcpy(p->mnemonic, "memb"); break;
        case 0b001: strcpy(p->mnemonic, "memub"); break;
        case 0b010: strcpy(p->mnemonic, "memh"); size = 1; break;
        case 0b011: strcpy(p->mnemonic, "memh"); size = 1; break;
        case 0b100: strcpy(p->mnemonic, "memw"); size = 2; break;
        case 0b101:
            switch(EXTRACT(inst->code, 2, 11)) {
                case 0b00: strcpy(p->mnemonic, "memb"); break;
                case 0b01: strcpy(p->mnemonic, "memh"); size = 1; break;
                case 0b10: strcpy(p->mnemonic, "memw"); size = 2; break;
            }
            break;
        case 0b110: strcpy(p->mnemonic, "memd"); size = 3; break;
        default: return;
    }
    
    if(load) {
        p->type |= in_target;

        p->opOrder |= op_dst << (op_size * opCount++);
        op->type = reg_r | reg_d | (size == 3 ? reg_64 : reg_32);
        op->val = EXTRACT(inst->code, 5, 0);
        
        op = &p->operands[opCount];
        p->opOrder |= op_src << (op_size * opCount++);
        op->type = reg_r | reg_s | reg_32;
        op->val = EXTRACT(inst->code, 5, 16);
        op->modifier = mod_addImm1;
        
        op = &p->operands[opCount];
        p->opOrder |= op_imm1 << (op_size * opCount++);
        op->type = imm_u;
        op->val = EXTRACT(inst->code, 6, 5);
        op->modifier |= size == 3 ? mod_col3 : size == 2 ? mod_col2 : size == 1 ? mod_col1 : 0;
    } else {
        op = &p->operands[opCount];
        p->opOrder |= (load ? op_src : op_gp) << (op_size * opCount++);
        op->type = load ? reg_r | reg_s | reg_32 : reg_gp;
        op->val = load ? EXTRACT(inst->code, 5, 16) : 0;
        op->modifier = mod_addImm1;
        
        op = &p->operands[opCount];
        p->opOrder |= op_imm1 << (op_size * opCount++);
        op->type = imm_u;
        op->val = load
                    ? EXTRACT(inst->code, 5,3) | (EXTRACT(inst->code, 1, 13) << 5)
                    : EXTRACT(inst->code, 8, 0) | (EXTRACT(inst->code, 1, 13) << 8) | (EXTRACT(inst->code, 5, 16) << 9) | (EXTRACT(inst->code, 2, 25) << 14);
        op->modifier |= size == 3 ? mod_col3 : size == 2 ? mod_col2 : size == 1 ? mod_col1 : 0;
        
        op = &p->operands[opCount];
        p->opOrder |= op_src << (op_size * opCount++);
        op->type = opTyp == 0b101 ? reg_n : reg_r | reg_t | (opTyp == 0b011 ? reg_hi : opTyp == 0b110 ? reg_64: reg_32);
        op->val = EXTRACT(inst->code, opTyp == 0b101 ? 3 : 5, 8);
        op->modifier = mod_target;
    }
}

- (void) decodeLoad:(insn_t*) inst {
    uint8_t amode = EXTRACT(inst->code, 3, 25);
    uint8_t type = EXTRACT(inst->code, 3, 22);
    uint8_t u = BIT_15(inst->code);
    uint8_t mod = EXTRACT(inst->code, 3, 11);
    uint16_t dst = 0, src1 = 0, src2 = 0, src3 = 0, src1mod = 0, src2mod = 0, col = 0;
    uint8_t _amode, _mod;

    insp_t *p = &inst->parts[0];
    
    uint8_t opCount = 0;
    openc_t *op = &p->operands[opCount];
    
    // todo: dcfetch & dealloc_return check
    
    if(amode > 0b100 && type >= 0b100 && BIT_2(mod)) {
        p->type = in_condition;
        
        p->opOrder = op_psrc;
        op->type = reg_p;
        op->val = EXTRACT(inst->code, 2, 9);
        op->modifier |= BIT_0(mod) ? mod_negated : 0;
        op->modifier |= BIT_1(mod) ? mod_new : 0;
        
        p = &inst->parts[1];
        op = &p->operands[opCount];
        
        mod = 0;
    } else if(amode == 0b100) {
        mod = EXTRACT(inst->code, 1, 9) << 1;
    }
    
    switch(type) {
        case 0b000:
            if(!u && amode == 0b001) {
                if(!(mod>>1)) {
                    strcpy(p->mnemonic, "memw_locked");
                    dst = reg_r | reg_d | reg_32;
                    src1 = reg_r | reg_s | reg_32;
                } else {
                    strcpy(p->mnemonic, "memd_locked");
                    dst = reg_r | reg_d | reg_64;
                    src1 = reg_r | reg_s | reg_32;
                }
            } else if(amode == 0b111) {
                strcpy(p->mnemonic, "membh");
                dst = reg_r | reg_d | reg_32;
                src1 = reg_r | reg_x | reg_32;  src1mod = mod_incrByNext;
                src2 = reg_m;                   src2mod = mod_brev;
            }
            break;
        case 0b001: strcpy(p->mnemonic, !u ? "memh_fifo" : "memubh"); col = mod_col1; break;
        case 0b010: strcpy(p->mnemonic, !u ? "memb_fifo" : "memubh"); break;
        case 0b011: strcpy(p->mnemonic, !u ? "" : "membh"); break;
        case 0b100: strcpy(p->mnemonic, !u ? "memb" : "memub"); break;
        case 0b101: strcpy(p->mnemonic, !u ? "memh" : "memuh"); col = mod_col1; break;
        case 0b110: strcpy(p->mnemonic, !u ? "memw" : ""); col = mod_col2; break;
        case 0b111: strcpy(p->mnemonic, !u ? "memd" : ""); col = mod_col3; break;
    }
    
    if(!dst) {
        _amode = amode < 0b100 ? 0 : amode;
        _mod = !BIT_1(mod);
        dst = !u ? reg_r | reg_x | reg_64 : reg_r | reg_d | reg_32;
        switch(amode) {
            case 0:
                dst = reg_r | reg_d | reg_32;
                src1 = reg_r | reg_x | reg_32;  src1mod = mod_addImm1;
                src2 = imm_s;                   src2mod = col;
                break;
            case 0b100:
                src1 = reg_r | reg_x | reg_32;      src1mod = mod_incrByNext;
                src2 = _mod ? imm_s : reg_i; src2mod = mod_circ;
                src3 = reg_m;
                break;
            case 0b101:
                src1 = reg_r | reg_x | reg_32;  src1mod = _mod ? mod_incrByNext : mod_setNext;
                src2 = _mod ? imm_s : imm_u;    src2mod = _mod ? col : 0;
                break;
            case 0b110:
                src1 = reg_r | (_mod ? reg_d : reg_x) | reg_32;  src1mod = mod_shiftByImm2 | mod_addImm1;
                src2 = imm_u;
                src3 = imm_u;
                break;
            case 0b111:
                if(!BIT_7(inst->code)) {
                    src1 = reg_r | reg_x | reg_32;  src1mod = mod_incrByNext;
                    src2 = reg_m;                   src2mod = mod_brev;
                } else {
                    src1 = imm_u;
                }
                break;
        }
    }
    
    p->type |= in_target;
    
    p->opOrder |= (MATCHRT(dst, reg_x)? op_xrc : op_dst) << (op_size * opCount++);
    op->type = dst;
    op->val = EXTRACT(inst->code, 5, 0);
    
    op = &p->operands[opCount];
    p->opOrder |= (MATCHIT(src1, imm_u)? op_imm1 :
                   MATCHRT(src1, reg_x)? op_xrc : op_src) << (op_size * opCount++);
    op->type = src1;
    op->val = EXTRACT(inst->code, 5, 16) | (MATCHIT(src1, imm_u)? EXTRACT(inst->code, 1, 8) << 5 : 0) ;
    op->modifier = src1mod;
    
    if(src2) {
        op = &p->operands[opCount];
        p->opOrder |= (MATCHIT(src2, imm_u) || MATCHIT(src2, imm_s)? op_imm1 :
                       MATCHRT(src2, reg_x)? op_xrc :
                       MATCHRT(src2, reg_m)? op_mu : op_trc) << (op_size * opCount++);
        op->type = src2;
        op->val = src1mod & mod_setNext ? EXTRACT(inst->code, 2,5) | (EXTRACT(inst->code, 4, 8) << 2) :
        MATCHIT(src2, imm_s)? EXTRACT(inst->code, 4, 5) :
        MATCHIT(src3, imm_u)? EXTRACT(inst->code, 1, 7) | (EXTRACT(inst->code, 1, 13) << 1) :
        MATCHIT(src2, imm_u)? EXTRACT(inst->code, 6, 5) :
        MATCHRT(src2, reg_m)? EXTRACT(inst->code, 1,13) : 0;
        op->modifier = src2mod;
        
        if(src3) {
            op = &p->operands[opCount];
            p->opOrder |= (MATCHIT(src3, imm_u)? op_imm2 : op_mu) << (op_size * opCount++);
            op->type = src3;
            op->val = MATCHIT(src3, imm_u)? EXTRACT(inst->code, 2,5) | (EXTRACT(inst->code, 4, 8) << 2) :
                                    EXTRACT(inst->code, 1, 13);
        }
    }
}

- (void) decodeStore:(insn_t*) inst {
    uint8_t amode = EXTRACT(inst->code, 3, 25);
    uint8_t type = EXTRACT(inst->code, 3, 22);
    uint8_t u = BIT_15(inst->code);
    uint8_t mod = EXTRACT(inst->code, 3, 11);
    uint16_t dst = 0, src1 = 0, src2 = 0, src3 = 0, src1mod = 0, src2mod = 0, col = 0;
    uint8_t _amode;
    bool cond = false;
    
    insp_t *p = &inst->parts[0];
    
    uint8_t opCount = 0;
    openc_t *op = &p->operands[opCount];
    
    if(MATCH(amode & 0b101, 0b101)) {
        p->type = in_condition;
        p->opOrder = op_psrc;
        op->type = reg_p;
        op->val = EXTRACT(inst->code, 2, 5);
        if(amode == 0b101) {
            op->modifier = !BIT_7(inst->code) ? 0 : mod_new;
            op->modifier = !BIT_2(inst->code) ? 0 : mod_negated;
        } else {
            op->modifier = !BIT_D(mod) ? 0 : mod_new;
            op->modifier = !BIT_2(inst->code) ? 0 : mod_negated;
        }
        cond = true;
        
        p = &inst->parts[1];
        op = &p->operands[opCount];
    }
    
    switch(type) {
            // todo: type < 0b100
        case 0b100: strcpy(p->mnemonic, "memb"); dst = reg_r | reg_t | reg_32; break;
        case 0b101: strcpy(p->mnemonic, "memh"); dst = reg_r | reg_t | (!u ? reg_32 : reg_hi); col = mod_col1; break;
        case 0b110:
            if(!u) {
                strcpy(p->mnemonic, ""); dst = reg_r | reg_t | reg_32;
            } else {
                switch(mod&0b11) {
                    case 0b00: strcpy(p->mnemonic, "memb"); break;
                    case 0b01: strcpy(p->mnemonic, "memh"); col = mod_col1; break;
                    case 0b10: strcpy(p->mnemonic, "memw"); col = mod_col2; break;
                }
                dst = reg_n;
            } break;
        case 0b111: strcpy(p->mnemonic, "memd"); dst = reg_r | reg_t | reg_64; col = mod_col3; break;
    }
    
//    if(!dst) {
        _amode = amode < 0b100 ? 0 : amode;
        switch(amode) {
            case 0:
                src1 = reg_r | reg_s | reg_32;  src1mod = mod_addImm1;
                src2 = imm_s;                   src2mod = col;
                break;
            case 0b100:
                src1 = reg_r | reg_x | reg_32;      src1mod = mod_incrByNext;
                uint8_t x = !BIT_1(inst->code);
                src2 = x ? imm_s : reg_i; src2mod = mod_circ | (x ? col : 0);
                src3 = reg_m;
                break;
            case 0b101:
                src1 = reg_r | reg_x | reg_32;
                x = !BIT_2(mod) ? !BIT_7(inst->code) : 1; src1mod = x ? mod_incrByNext : mod_setNext;
                src2 = x ? imm_s : imm_u;    src2mod = x ? col : 0;
                break;
            case 0b110:
                if(!BIT_7(inst->code)) {
                    src1 = reg_r | reg_u | reg_32; src1mod = mod_shiftByImm2 | mod_addImm1;
                    src2 = imm_u;
                    src3 = imm_u;
                } else {
                    src1 = reg_r | reg_x | reg_32;  src1mod = mod_incrByNext;
                    src2 = reg_m;
                }
                break;
            case 0b111:
                if(!BIT_7(inst->code)) {
                    src1 = reg_r | reg_x | reg_32;  src1mod = mod_incrByNext;
                    src2 = reg_m;                   src2mod = mod_brev;
                } else {
                    src1 = imm_u;
                }
                break;
        }
//    }
    
    p->opOrder |= (MATCHIT(src1, imm_u)? op_imm1 :
                   MATCHRT(src1, reg_x)? op_xrc : op_src) << (op_size * opCount++);
    op->type = src1;
    op->val = MATCHIT(src1, imm_u)? EXTRACT(inst->code, 4, 3) | EXTRACT(inst->code, 2, 16) << 4 : EXTRACT(inst->code, 5, 16);
    op->modifier = src1mod;
    
    if(src2) {
        op = &p->operands[opCount];
        p->opOrder |= (MATCHIT(src2, imm_u) || MATCHIT(src2, imm_s)? op_imm1 :
                       MATCHRT(src2, reg_x)? op_xrc :
                       MATCHRT(src2, reg_m)? op_mu : op_trc) << (op_size * opCount++);
        op->type = src2;
        op->val = src1mod & mod_setNext ? EXTRACT(inst->code, 6, 0) :
        MATCHIT(src2, imm_s)?  (!src3 ? EXTRACT(inst->code, 8, 0) | EXTRACT(inst->code, 1, 13) << 8 | EXTRACT(inst->code, 2, 25) << 9 :
                         EXTRACT(inst->code, 4, 3)) :
        MATCHIT(src3, imm_u)? EXTRACT(inst->code, 1, 6) | (EXTRACT(inst->code, 1, 13) << 1) :
        MATCHRT(src2, reg_m)? EXTRACT(inst->code, 1,13) : 0;
        op->modifier = src2mod;
        
        if(src3) {
            op = &p->operands[opCount];
            p->opOrder |= (MATCHIT(src3, imm_u)? op_imm2 : op_mu) << (op_size * opCount++);
            op->type = src3;
            op->val = MATCHIT(src3, imm_u)? EXTRACT(inst->code, 6, 0) :
            EXTRACT(inst->code, 1, 13);
    
        }
    }
    
    op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(dst, reg_t)? op_trc : op_src) << (op_size * opCount++);
    op->type = dst;
    op->val = MATCHRT(dst, reg_t)? EXTRACT(inst->code, 5, 8) : EXTRACT(inst->code, 3, (!cond ? 8 : 0));
    op->modifier = mod_target;
    
}


- (void) decodeXType:(insn_t*) inst {
    uint8_t regType = EXTRACT(inst->code, 4, 24);
    uint8_t majOp = EXTRACT(inst->code, 3, 21);
    uint8_t minOp = EXTRACT(inst->code, 3, 5);
    uint8_t _minOp, _majOp; // for alignment inside a regtype
    uint16_t dstType = 0, srcType = 0, imm1 = 0, imm2 = 0;
    bool smallImm = false;
    
    insp_t *p = &inst->parts[0];
   
    switch(regType) {
        case 0b0000:
            dstType = reg_r | reg_d | reg_64;
            srcType = reg_r | reg_s | reg_64;
            switch(majOp) {
                case 0b000:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "asr"); imm1 = imm_u; break;
                        case 0b001: strcpy(p->mnemonic, "lsr"); imm1 = imm_u; break;
                        case 0b010: strcpy(p->mnemonic, "asl"); imm1 = imm_u; break;
                        case 0b100: strcpy(p->mnemonic, "vsathub"); break;
                        case 0b101: strcpy(p->mnemonic, "vsatwuh"); break;
                        case 0b110: strcpy(p->mnemonic, "vsatwh"); break;
                        case 0b111: strcpy(p->mnemonic, "vsathb"); break;
                        default: break;
                    }
                    break;
                case 0b010:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "vasrw"); imm1 = imm_u; break;
                        case 0b001: strcpy(p->mnemonic, "vlsrw"); imm1 = imm_u; break;
                        case 0b100: strcpy(p->mnemonic, "vabsh"); imm1 = imm_u; break;
                        case 0b101: strcpy(p->mnemonic, "vabsh"); p->type |= in_sat; break;
                        case 0b110: strcpy(p->mnemonic, "vabsw"); break;
                        case 0b111: strcpy(p->mnemonic, "vabsw"); p->type |= in_sat; break;
                        default: break;
                    }
                    break;
                case 0b100:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "vasrh"); imm1 = imm_u; break;
                        case 0b001: strcpy(p->mnemonic, "vlsrh"); imm1 = imm_u; break;
                        case 0b010: strcpy(p->mnemonic, "vaslh"); imm1 = imm_u; break;
                        case 0b101: strcpy(p->mnemonic, "neg"); break;
                        default: break;
                    }
                    break;
                case 0b110:
                    switch(minOp) {
                        case 0b100: strcpy(p->mnemonic, "deinterleave"); break;
                        case 0b101: strcpy(p->mnemonic, "interleave"); break;
                        case 0b110: strcpy(p->mnemonic, "brev"); break;
                        case 0b111: strcpy(p->mnemonic, "asr"); p->type |= in_rnd; imm1 = imm_u; break;
                        default: break;
                    }
                    break;
                case 0b111:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "convert_df2d"); break;
                        case 0b001: strcpy(p->mnemonic, "convert_df2ud"); break;
                        case 0b010: strcpy(p->mnemonic, "convert_ud2df"); break;
                        case 0b011: strcpy(p->mnemonic, "convert_d2df"); break;
                        case 0b110: strcpy(p->mnemonic, "convert_df2d"); p->type |= in_chop;  break;
                        case 0b111: strcpy(p->mnemonic, "convert_df2ud"); p->type |= in_chop;  break;
                        default: break;
                    }
                    break;
            }
            break;
        case 0b0001:
            dstType = reg_r | reg_d | reg_64;
            srcType = reg_r | reg_s | reg_64;
            imm1 = imm_u;
            imm2 = imm_u;
            strcpy(p->mnemonic, "extractu"); break;
        case 0b0010:
            dstType = reg_r | reg_d | reg_64;
            srcType = reg_r | reg_s | reg_64;
            imm1 = imm_u;
            _majOp = majOp >> 1;
            _minOp = minOp & 0b011;
            
            switch(_majOp) {
                case 0b00:
                    if(minOp < 0b011) p->type |= in_as_sub;
                    else if(minOp > 0b011 && minOp < 0b111) p->type |= in_as_add;
                case 0b01:
                    if(minOp < 0b011) p->type |= in_as_and;
                    else if(minOp > 0b011 && minOp < 0b111) p->type |= in_as_or;
                case 0b10:
                    if(minOp > 0b000 && minOp < 0b011) p->type |= in_as_xor;
                    break;
                default: return;
            }
            
            switch(_minOp) {
                case 0b00: strcpy(p->mnemonic, "asr"); break;
                case 0b01: strcpy(p->mnemonic, "lsr"); break;
                case 0b10: strcpy(p->mnemonic, "asl"); break;
            }
            break;
        case 0b0011:
            dstType = reg_r | reg_d | reg_64;
            srcType = reg_r | reg_s | reg_64;
            imm1 = imm_u;
            imm2 = imm_u;
            strcpy(p->mnemonic, "insert"); break;
        case 0b0100:
            dstType = reg_r | reg_d | reg_64;
            srcType = reg_r | reg_s;
            _majOp = majOp>>2;
            
            switch(_majOp) {
                case 0:
                    srcType |= reg_32;
                    _minOp = minOp>>1;
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "vsxtbh"); break;
                        case 0b01: strcpy(p->mnemonic, "vzxtbh"); break;
                        case 0b10: strcpy(p->mnemonic, "vsxthw"); break;
                        case 0b11: strcpy(p->mnemonic, "vzxthw"); break;
                    }
                    break;
                case 1:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "convert_sf2df"); srcType |= reg_32; break;
                        case 0b001: strcpy(p->mnemonic, "convert_uw2df"); srcType |= reg_32; break;
                        case 0b010: strcpy(p->mnemonic, "convert_w2df"); srcType |= reg_32; break;
                        case 0b011: strcpy(p->mnemonic, "convert_sf2ud"); srcType |= reg_64; break;
                        case 0b100: strcpy(p->mnemonic, "convert_sf2d"); srcType |= reg_64; break;
                        case 0b101: strcpy(p->mnemonic, "convert_sf2ud"); p->type |= in_chop; srcType |= reg_64; break;
                        case 0b110: strcpy(p->mnemonic, "convert_sf2d"); p->type |= in_chop; srcType |= reg_64; break;
                    }
                    break;
            }
            break;
        case 0b0101:
            dstType = reg_p;
            srcType = reg_r | reg_s | reg_32;
            imm1 = imm_u;
            
            if(BIT_0(majOp)) p->type |= in_negated;
            _majOp = majOp>>1;
            switch(_majOp) {
                case 0b00: strcpy(p->mnemonic, "tstbit"); break;
                case 0b10: strcpy(p->mnemonic, "bitsclr"); break;
            }
            break;
        case 0b0111:
            dstType = reg_r | reg_x | reg_32;
            srcType = reg_r | reg_s | reg_32;
            imm1 = imm_u;
            imm2 = imm_s;
            
            p->type |= in_raw;
            _majOp = majOp >> 1;
            switch(_majOp) {
                case 0b00: strcpy(p->mnemonic, "tableidxb"); break;
                case 0b01: strcpy(p->mnemonic, "tableidxh"); break;
                case 0b10: strcpy(p->mnemonic, "tableidxw"); break;
                case 0b11: strcpy(p->mnemonic, "tableidxd"); break;
            }
            break;
        case 0b1000:
            dstType = reg_r | reg_d;
            srcType = reg_r | reg_s | reg_64;
            
            switch(majOp) {
                case 0b000:
                    dstType |= reg_32;
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "vsathub"); break;
                        case 0b001: strcpy(p->mnemonic, "convert_df2sf"); break;
                        case 0b011: strcpy(p->mnemonic, "vsatwh"); break;
                        case 0b100: strcpy(p->mnemonic, "vsatwuh"); break;
                        case 0b110: strcpy(p->mnemonic, "vsathb"); break;
                    }
                    break;
                case 0b001:
                    dstType |= reg_32;
                    switch(minOp) {
                        case 0b001: strcpy(p->mnemonic, "convert_ud2sf"); break;
                    }
                    break;
                case 0b010:
                    dstType |= reg_32;
                    switch(minOp) {
                        case 0b001: strcpy(p->mnemonic, "convert_d2sf"); break;
                    }
                    break;
                case 0b011:
                    dstType |= reg_32;
                    switch(minOp) {
                        case 0b001: strcpy(p->mnemonic, "convert_df2uw"); break;
                        case 0b100: strcpy(p->mnemonic, "vasrhub"); p->type |= in_raw; imm1 = imm_u; break;
                        case 0b101: strcpy(p->mnemonic, "vasrhub"); p->type |= in_sat; imm1 = imm_u; break;
                    }
                    break;
                case 0b100:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "vtrunohb"); dstType |= reg_32; break;
                        case 0b001: strcpy(p->mnemonic, "convert_df2w"); dstType |= reg_64; break;
                        case 0b010: strcpy(p->mnemonic, "vtrunehb"); dstType |= reg_32; break;
                        case 0b100: strcpy(p->mnemonic, "vrndwh"); dstType |= reg_32; break;
                        case 0b110: strcpy(p->mnemonic, "vrndwh"); p->type |= in_sat; dstType |= reg_32; break;
                    }
                    break;
                case 0b101:
                    switch(minOp) {
                        case 0b001: strcpy(p->mnemonic, "convert_df2uw"); p->type |= in_chop; dstType |= reg_64; break;
                    }
                    break;

                case 0b110:
                    dstType |= reg_32;
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "sat"); break;
                        case 0b001: strcpy(p->mnemonic, "round"); p->type |= in_sat; break;
                    }
                    break;
                case 0b111:
                    switch(minOp) {
                        case 0b001: strcpy(p->mnemonic, "convert_df2w"); p->type |= in_chop; dstType |= reg_64; break;
                    }
                    break;

            }
            break;
        case 0b1010:
            dstType = reg_r | reg_d | reg_64;
            srcType = reg_r | reg_s | reg_64;
            imm1 = imm_u;
            imm2 = imm_u;
            strcpy(p->mnemonic, "extract"); break;
        case 0b1011:
            dstType = reg_r | reg_d;
            srcType = reg_r | reg_s;
            switch(majOp) {
                case 0b001:
                    dstType |= reg_32;
                    srcType |= reg_32;
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "convert_uw2sf"); break;
                    }
                    break;
                case 0b010:
                    dstType |= reg_32;
                    srcType |= reg_32;
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "convert_w2sf"); break;
                    }
                    break;
                case 0b011:
                    dstType |= reg_64;
                    srcType |= reg_64;
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "convert_sf2uw"); break;
                        case 0b001: strcpy(p->mnemonic, "convert_sfu2w"); p->type |= in_chop; break;
                    }
                    break;
                case 0b100:
                    dstType |= reg_64;
                    srcType |= reg_64;
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "convert_sf2w"); break;
                        case 0b001: strcpy(p->mnemonic, "convert_sf2w"); p->type |= in_chop; break;
                    }
                    break;
            }
            break;
        case 0b1100:
            dstType = reg_r | reg_d | reg_32;
            srcType = reg_r | reg_s | reg_32;
            _majOp = majOp;
            _minOp = minOp;
            if(BIT_2(_majOp) & !BIT_1(_majOp)){
                _majOp = 0b100;
                _minOp = minOp>>1;
                
                if(minOp == 0b101 || minOp == 110) {
                    p->type |= in_sat;
                }
            }
            switch(_majOp) {
                case 0b000:
                    imm1 = imm_u;
                    switch(_minOp) {
                        case 0b000: strcpy(p->mnemonic, "asr"); break;
                        case 0b001: strcpy(p->mnemonic, "lsr"); break;
                        case 0b010: strcpy(p->mnemonic, "asl"); break;
                    }
                    break;
                case 0b010:
                    switch(_minOp) {
                        case 0b000: strcpy(p->mnemonic, "asr"); p->type |= in_rnd; imm1 = imm_u; break;
                        case 0b110: strcpy(p->mnemonic, "brev"); break;
                    }
                    break;
                case 0b100:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "vsathb"); break;
                        case 0b01: strcpy(p->mnemonic, "vsathub"); break;
                        case 0b10: strcpy(p->mnemonic, "abs"); break;
                        case 0b11: strcpy(p->mnemonic, "neg"); break;
                    }
                    break;
                case 0b110:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "setbit"); imm1 = imm_u; break;
                        case 0b001: strcpy(p->mnemonic, "clrbit"); imm1 = imm_u; break;
                        case 0b010: strcpy(p->mnemonic, "togglebit"); imm1 = imm_u; break;
                        case 0b100: strcpy(p->mnemonic, "sath"); break;
                        case 0b101: strcpy(p->mnemonic, "satuh"); break;
                        case 0b110: strcpy(p->mnemonic, "satub"); break;
                        case 0b111: strcpy(p->mnemonic, "satb"); break;
                        default: break;
                    }
                    break;
                case 0b111:
                    imm1 = imm_u;
                    _minOp = _minOp & 0b011;
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "cround"); break;
                        case 0b10: strcpy(p->mnemonic, "round"); break;
                        case 0b11: strcpy(p->mnemonic, "round"); p->type |= in_sat; break;
                    }
                    break;
            }
            break;
        case 0b1101:
            dstType = reg_r | reg_d | reg_32;
            srcType = reg_r | reg_s | reg_32;
            imm1 = imm_u;
            imm2 = imm_u;
            smallImm = true;
            _majOp = majOp>>2;
            switch(_majOp) {
                case 0b0: strcpy(p->mnemonic, "extractu"); break;
                case 0b1: strcpy(p->mnemonic, "extract"); break;
            }
            break;
        case 0b1110:
            dstType = reg_r | reg_x | reg_32;
            srcType = reg_r | reg_s | reg_32;
            imm1 = imm_u;
            _majOp = majOp >> 1;
            _minOp = minOp & 0b011;
            
            switch(_majOp) {
                case 0b00:
                    if(minOp < 0b011) p->type |= in_as_sub;
                    else if(minOp > 0b011 && minOp < 0b111) p->type |= in_as_add;
                case 0b01:
                    if(minOp < 0b011) p->type |= in_as_and;
                    else if(minOp > 0b011 && minOp < 0b111) p->type |= in_as_or;
                case 0b10:
                    if(minOp > 0b000 && minOp < 0b111) p->type |= in_as_xor;
                    break;
                default: return;
            }
            
            switch(_minOp) {
                case 0b00: strcpy(p->mnemonic, "asr"); break;
                case 0b01: strcpy(p->mnemonic, "lsr"); break;
                case 0b10: strcpy(p->mnemonic, "asl"); break;
            }
            break;
        case 0b1111:
            dstType = reg_r | reg_d | reg_32;
            srcType = reg_r | reg_s | reg_32;
            imm1 = imm_u;
            imm2 = imm_u;
            smallImm = true;
            strcpy(p->mnemonic, "insert"); break;
    }
    
    uint8_t opCount = 0;
    
    openc_t *op = &p->operands[opCount];
    p->opOrder |= (dstType & reg_r ? dstType & reg_x ? op_xrc : op_dst : op_pdst) << (op_size * opCount++);
    op->type = dstType;
    op->val = EXTRACT(inst->code, 5, 0);
    
    op = &p->operands[opCount];
    p->opOrder |= op_src << (op_size * opCount++);
    op->type = srcType;
    op->val = EXTRACT(inst->code, (dstType & reg_r ? 5 : 2), 16);
    
    if(imm1) {
        op = &p->operands[opCount];
        p->opOrder |= op_imm1 << (op_size * opCount++);
        op->type = imm1;
        op->val = EXTRACT(inst->code, 6, 8);
        
        if(imm2) {
            op = &p->operands[opCount];
            p->opOrder |= op_imm2 << (op_size * opCount++);
            op->type = imm2;
            op->val = minOp | ((smallImm ? majOp&0b11 : majOp) << 3);
        }
    }
    
}

- (void)decodeXType2:(insn_t*) inst {
    uint8_t regType = EXTRACT(inst->code, 4, 24);
    uint8_t majOp = EXTRACT(inst->code, 3, 21);
    uint8_t minOp = EXTRACT(inst->code, 3, 5);
    uint8_t _majOp, _minOp, x;
    uint16_t dst = 0, src = 0, trc = 0, px = 0, imm1 = 0;
    bool opAsterisk = false;
    
    insp_t *p = &inst->parts[0];
    
    switch(regType) {
        case 0b0001:
            dst = reg_r | reg_d | reg_64;
            src = reg_r | reg_s | reg_64;
            trc = reg_r | reg_t | reg_64;
            _majOp = majOp>>1;
            _minOp = minOp>>1;
            switch(_majOp){
                case 0b00:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "extractu"); break;
                        case 0b01: strcpy(p->mnemonic, "shuffeb"); break;
                        case 0b10: strcpy(p->mnemonic, "shuffob"); break;
                        case 0b11: strcpy(p->mnemonic, "shuffeh"); break;
                    }
                    break;
                case 0b01:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "vxaddsubw"); p->type |= in_sat; break;
                        case 0b010: strcpy(p->mnemonic, "vxsubaddw"); p->type |= in_sat; break;
                        case 0b100: strcpy(p->mnemonic, "vxaddsubh"); p->type |= in_sat; break;
                        case 0b110: strcpy(p->mnemonic, "vxsubaddh"); p->type |= in_sat; break;
                    }
                    break;
                case 0b10:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "shuffoh"); break;
                        case 0b01: strcpy(p->mnemonic, "vtrunewh"); break;
                        case 0b10: strcpy(p->mnemonic, "vtrunewh"); break;
                    }
                    break;
                case 0b11:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "vxaddsubh"); p->type |= in_sat | in_rnd | in_shiftRight1; break;
                        case 0b01: strcpy(p->mnemonic, "vxsubaddh"); p->type |= in_sat | in_rnd | in_shiftRight1; break;
                        case 0b10: strcpy(p->mnemonic, "extract"); break;
                    }
                    break;
            }
            break;
        case 0b0010:
            dst = reg_r | reg_d | reg_64;
            src = reg_r | reg_s | reg_64;
            trc = reg_r | reg_t | reg_64;
            px = reg_p;
            switch(majOp) {
                case 0b110: strcpy(p->mnemonic, "add"); p->type |= in_carry; break;
                case 0b111: strcpy(p->mnemonic, "sub"); p->type |= in_carry; break;
            }
            break;
        case 0b0011:
            dst = reg_r | reg_d | reg_64;
            src = reg_r | reg_s | reg_64;
            trc = reg_r | reg_t | reg_32;
            
            _majOp = majOp>>1;
            _minOp = minOp>>1;
            switch(_majOp){
                case 0b00:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "vasrw"); break;
                        case 0b01: strcpy(p->mnemonic, "vlsrw"); break;
                        case 0b10: strcpy(p->mnemonic, "vaslw"); break;
                        case 0b11: strcpy(p->mnemonic, "vlslw"); break;
                    }
                    break;
                case 0b01:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "vasrh"); break;
                        case 0b01: strcpy(p->mnemonic, "vlsrh"); break;
                        case 0b10: strcpy(p->mnemonic, "vaslh"); break;
                        case 0b11: strcpy(p->mnemonic, "vlslh"); break;
                    }
                    break;
                case 0b10:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "asr"); break;
                        case 0b01: strcpy(p->mnemonic, "lsr"); break;
                        case 0b10: strcpy(p->mnemonic, "asl"); break;
                        case 0b11: strcpy(p->mnemonic, "lsl"); break;
                    }
                    break;
            }
            break;
        case 0b0100:
            dst = reg_r | reg_d | reg_32;
            src = reg_r | reg_t | reg_32;
            trc = reg_r | reg_s | reg_32;
            imm1 = imm_u;
            switch(majOp) {
                case 0b000: strcpy(p->mnemonic, "addasl"); break;
            }
            break;
        case 0b0101:
            dst = reg_r | reg_d | reg_32;
            src = reg_r | reg_s | reg_64;
            trc = reg_r | reg_t | reg_32;
            switch(minOp) {
                case 0b100: strcpy(p->mnemonic, "cmpyiwh"); p->type |= in_sat | in_rnd | in_shiftRight1; break;
                case 0b101: strcpy(p->mnemonic, "cmpyiwh"); p->type |= in_sat | in_rnd | in_shiftRight1; opAsterisk = true; break;
                case 0b110: strcpy(p->mnemonic, "cmpyrwh"); p->type |= in_sat | in_rnd | in_shiftRight1; break;
                case 0b111: strcpy(p->mnemonic, "cmpyrwh"); p->type |= in_sat | in_rnd | in_shiftRight1; opAsterisk = true; break;
            }
            break;
        case 0b0110:
            dst = reg_r | reg_d | reg_32;
            src = reg_r | reg_s | reg_32;
            trc = reg_r | reg_t | reg_32;
            _majOp = majOp>>1;
            _minOp = minOp>>1;
            switch(_majOp){
                case 0b00:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "asr"); p->type |= in_sat; break;
                        case 0b10: strcpy(p->mnemonic, "asl"); p->type |= in_sat; break;
                    }
                    break;
                case 0b01:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "asr"); break;
                        case 0b01: strcpy(p->mnemonic, "lsr"); break;
                        case 0b10: strcpy(p->mnemonic, "asl"); break;
                        case 0b11: strcpy(p->mnemonic, "lsl"); break;
                    }
                    break;
                case 0b10:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "setbit"); break;
                        case 0b01: strcpy(p->mnemonic, "clrbit"); break;
                        case 0b10: strcpy(p->mnemonic, "togglebit"); break;
                    }
                    break;
                case 0b11:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "cround"); break;
                        case 0b10: strcpy(p->mnemonic, "round"); break;
                        case 0b11: strcpy(p->mnemonic, "round"); p->type |= in_sat; break;
                    }
                    break;
            }
            break;
        case 0b0111:
            dst = reg_p;
            src = reg_r | reg_s | reg_32;
            trc = reg_r | reg_t | reg_32;
            switch(majOp){
                case 0b000: strcpy(p->mnemonic, "tstbit"); break;
                case 0b010: strcpy(p->mnemonic, "bitsset"); break;
                case 0b100: strcpy(p->mnemonic, "bitsclr");break;
                case 0b110:
                    switch(minOp) {
                        case 0b010: strcpy(p->mnemonic, "cmpb.gt"); break;
                        case 0b011: strcpy(p->mnemonic, "cmph.eq"); break;
                        case 0b100: strcpy(p->mnemonic, "cmph.gt"); break;
                        case 0b101: strcpy(p->mnemonic, "cmph.gtu"); break;
                        case 0b110: strcpy(p->mnemonic, "cmpb.eq"); break;
                        case 0b111: strcpy(p->mnemonic, "cmpb.gtu"); break;
                    }
                    break;
                case 0b111:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "sfcmp.ge"); break;
                        case 0b001: strcpy(p->mnemonic, "sfcmp.uo"); break;
                        case 0b011: strcpy(p->mnemonic, "sfcmp.eq"); break;
                        case 0b100: strcpy(p->mnemonic, "sfcmp.gt"); break;
                    }
                    break;
            }
            break;
        case 0b1001:
            dst = reg_r | reg_d | reg_32;
            src = reg_r | reg_s | reg_32;
            trc = reg_r | reg_t | reg_64;
            _majOp = majOp>>1;
            _minOp = minOp>>1;
            switch(_majOp){
                case 0b00:
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "extractu"); break;
                        case 0b01: strcpy(p->mnemonic, "extract"); break;
                    }
            }
        case 0b1011:
            dst = reg_r | reg_x | reg_32;
            src = reg_r | reg_s | reg_64;
            trc = reg_r | reg_32;
            _minOp = minOp>>1;
            switch(majOp) {
                case 0b001:
                    x = BIT_D(inst->code);
                    trc |= reg_u;
                    switch(minOp) {
                        case 0b001: strcpy(p->mnemonic, x ? "vrmaxh" : "vrmaxuh"); break;
                        case 0b010: strcpy(p->mnemonic, x ? "vrmaxw" : "vrmaxuw"); break;
                        case 0b101: strcpy(p->mnemonic, x ? "vrminh" : "vrminuh"); break;
                        case 0b110: strcpy(p->mnemonic, x ? "vrminw" : "vrminuw"); break;
                    }
                    break;
                default:
                    trc |= reg_t;
                    switch(majOp) {
                        case 0b000: p->type |= in_as_or; break;
                        case 0b010: p->type |= in_as_and; break;
                        case 0b011: p->type |= in_as_xor; break;
                        case 0b100: p->type |= in_as_sub; break;
                        case 0b110: p->type |= in_as_add; break;
                        default: return;
                    }
                    
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "asr"); break;
                        case 0b01: strcpy(p->mnemonic, "lsr"); break;
                        case 0b10: strcpy(p->mnemonic, "asl"); break;
                        case 0b11: strcpy(p->mnemonic, "lsl"); break;
                    }
                    break;
            }
            break;
        case 0b1100:
            dst = reg_r | reg_x | reg_32;
            src = reg_r | reg_s | reg_32;
            trc = reg_r | reg_t | reg_32;
            _majOp = majOp>>1;
            _minOp = minOp>>1;
            
            switch(_majOp) {
                case 0b00: p->type |= in_as_or; break;
                case 0b01: p->type |= in_as_and; break;
                case 0b10: p->type |= in_as_sub; break;
                case 0b11: p->type |= in_as_add; break;
                default: return;
            }
            
            switch(_minOp) {
                case 0b00: strcpy(p->mnemonic, "asr"); break;
                case 0b01: strcpy(p->mnemonic, "lsr"); break;
                case 0b10: strcpy(p->mnemonic, "asl"); break;
                case 0b11: strcpy(p->mnemonic, "lsl"); break;
            }
            break;
    }
    
    uint8_t opCount = 0;

    openc_t *op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(dst, reg_d)? op_dst : MATCHRT(dst, reg_x)? op_xrc : op_pdst) << (op_size * opCount++);
    op->type = dst;
    op->val = EXTRACT(inst->code, (MATCHIT(dst, (reg_p))? 2 : 5), (MATCHRT(dst, reg_x)? 8 : 0));
    
    op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(src, reg_s) ? op_src : op_trc) << (op_size * opCount++);
    op->type = src;
    op->val = EXTRACT(inst->code, 5, (MATCHRT(src, reg_s) ? 16 : 8));
    
    op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(trc, reg_s) ? op_src : op_trc) << (op_size * opCount++);
    op->type = trc;
    op->val = EXTRACT(inst->code, 5, (MATCHRT(trc, reg_s) ? 16 : MATCHRT(trc, reg_t) ? 8 : 0));
    op->modifier = opAsterisk ? mod_asterisk : 0;
    
    if(imm1) {
        op = &p->operands[opCount];
        p->opOrder |= op_imm1 << (op_size * opCount++);
        op->type = imm1;
        op->val = minOp;
    }
    
    if(px) {
        op = &p->operands[opCount];
        p->opOrder |= op_psrc << (op_size * opCount++);
        op->type = px;
        op->val = EXTRACT(inst->code, 2, 5);
    }
}

- (void)decodeXType3:(insn_t*) inst {
    uint8_t regType = EXTRACT(inst->code, 4, 24);
    uint8_t majOp = EXTRACT(inst->code, 3, 21);
    uint8_t minOp = EXTRACT(inst->code, 3, 5);
    uint8_t _majOp, _minOp;
    uint16_t dst = 0, src1 = 0, src2 = 0, src3 = 0, src2mod = 0;
    bool composite = false;
    
    insp_t *p = &inst->parts[0];
    
    switch(regType) {
        case 0b0000:
            dst = reg_r | reg_d | reg_32;
            src1 = reg_r | reg_s | reg_64;
            src2 = reg_r | reg_t | reg_64;
            strcpy(p->mnemonic, "parity");
            break;
        case 0b0010:
            dst = reg_p;
            src1 = reg_r | reg_s | reg_64;
            src2 = reg_r | reg_t | reg_64;
            _majOp = majOp < 0b100 ? 0 : majOp;
            switch(_majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "vcmpw.eq"); break;
                        case 0b001: strcpy(p->mnemonic, "vcmpw.gt"); break;
                        case 0b010: strcpy(p->mnemonic, "vcmpw.gtu"); break;
                        case 0b011: strcpy(p->mnemonic, "vcmph.eq"); break;
                        case 0b100: strcpy(p->mnemonic, "vcmph.gt"); break;
                        case 0b101: strcpy(p->mnemonic, "vcmph.gtu"); break;
                        case 0b110: strcpy(p->mnemonic, "vcmpb.eq"); break;
                        case 0b111: strcpy(p->mnemonic, "vcmpb.gtu"); break;
                    }
                    break;
                case 0b100:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "cmp.eq"); break;
                        case 0b010: strcpy(p->mnemonic, "cmp.gt"); break;
                        case 0b100: strcpy(p->mnemonic, "cmp.gtu"); break;
                    }
                    break;
                case 0b111:
                    switch(minOp) {
                        case 0b000: strcpy(p->mnemonic, "dfcmp.eq"); break;
                        case 0b001: strcpy(p->mnemonic, "dfcmp.gt"); break;
                        case 0b010: strcpy(p->mnemonic, "dfcmp.ge"); break;
                        case 0b011: strcpy(p->mnemonic, "dfcmp.uo"); break;
                    }
                    break;
            }
            break;
        case 0b0011:
            dst = reg_r | reg_d | reg_32;
            src1 = reg_r | reg_64;
            src2 = reg_r | reg_64;
            switch(majOp) {
                case 0b000:
                    src1 |= reg_s;
                    src2 |= reg_t;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vaddub"); break;
                        case 0b1: strcpy(p->mnemonic, "vaddub"); break;
                        case 0b10: strcpy(p->mnemonic, "vaddh"); break;
                        case 0b11: strcpy(p->mnemonic, "vaddh"); break;
                        case 0b100: strcpy(p->mnemonic, "vadduh"); break;
                        case 0b101: strcpy(p->mnemonic, "vaddw"); break;
                        case 0b110: strcpy(p->mnemonic, "vaddw"); break;
                        case 0b111: strcpy(p->mnemonic, "add"); break;
                    }
                    break;
                case 0b001:
                    src1 |= reg_t;
                    src2 |= reg_s;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vsubub"); break;
                        case 0b1: strcpy(p->mnemonic, "vsubub"); break;
                        case 0b10: strcpy(p->mnemonic, "vsubh"); break;
                        case 0b11: strcpy(p->mnemonic, "vsubh"); break;
                        case 0b100: strcpy(p->mnemonic, "vsubuh"); break;
                        case 0b101: strcpy(p->mnemonic, "vsubw"); break;
                        case 0b110: strcpy(p->mnemonic, "vsubw"); break;
                        case 0b111: strcpy(p->mnemonic, "sub"); break;
                    }
                    break;
                case 0b010:
                    src1 |= reg_s;
                    src2 |= reg_t;
                    _minOp = minOp >= 0b110 ? 0b11 : minOp;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "vavgub"); break;
                        case 0b1: strcpy(p->mnemonic, "vavgub"); break;
                        case 0b10: strcpy(p->mnemonic, "vavgh"); break;
                        case 0b11: strcpy(p->mnemonic, "vavguh"); break;
                        case 0b100: strcpy(p->mnemonic, "vavgh"); break;
                        case 0b101: strcpy(p->mnemonic, "vavguh"); break;
                    }
                    break;
                case 0b011:
                    src1 |= reg_s;
                    src2 |= reg_t;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vavgw"); break;
                        case 0b1: strcpy(p->mnemonic, "vavgw"); break;
                        case 0b10: strcpy(p->mnemonic, "vavgw"); break;
                        case 0b11: strcpy(p->mnemonic, "vavguw"); break;
                        case 0b100: strcpy(p->mnemonic, "vavguw"); break;
                        case 0b101: strcpy(p->mnemonic, "add"); break;
                        case 0b110: strcpy(p->mnemonic, "add"); break;
                        case 0b111: strcpy(p->mnemonic, "add"); break;
                    }
                    break;
                case 0b100:
                    src1 |= reg_t;
                    src2 |= reg_s;
                    _minOp = minOp >= 0b100 ? minOp & 0b110 : minOp;
                    switch(_minOp) {
                        case 0b000: strcpy(p->mnemonic, "vnavgh"); break;
                        case 0b001: strcpy(p->mnemonic, "vnavgh"); break;
                        case 0b010: strcpy(p->mnemonic, "vnavgh"); break;
                        case 0b011: strcpy(p->mnemonic, "vnavgw"); break;
                        case 0b100: strcpy(p->mnemonic, "vnavgw"); break;
                        case 0b110: strcpy(p->mnemonic, "vnavgw"); break;
                    }
                    break;
                case 0b101:
                    src1 |= reg_t;
                    src2 |= reg_s;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vminub"); break;
                        case 0b1: strcpy(p->mnemonic, "vminh"); break;
                        case 0b10: strcpy(p->mnemonic, "vminuh"); break;
                        case 0b11: strcpy(p->mnemonic, "vminw"); break;
                        case 0b100: strcpy(p->mnemonic, "vminuw"); break;
                        case 0b101: strcpy(p->mnemonic, "vmaxuw"); break;
                        case 0b110: strcpy(p->mnemonic, "min"); break;
                        case 0b111: strcpy(p->mnemonic, "minu"); break;
                    }
                    break;
                case 0b110:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vmaxub"); src1 |= reg_t; src2 |= reg_s; break;
                        case 0b1: strcpy(p->mnemonic, "vmaxh"); src1 |= reg_t; src2 |= reg_s; break;
                        case 0b10: strcpy(p->mnemonic, "vmaxuh"); src1 |= reg_t; src2 |= reg_s; break;
                        case 0b11: strcpy(p->mnemonic, "vmaxw"); src1 |= reg_t; src2 |= reg_s; break;
                        case 0b100: strcpy(p->mnemonic, "max"); src1 |= reg_s; src2 |= reg_t; break;
                        case 0b101: strcpy(p->mnemonic, "maxu"); src1 |= reg_s; src2 |= reg_t; break;
                        case 0b110: strcpy(p->mnemonic, "vmaxb"); src1 |= reg_t; src2 |= reg_s; break;
                        case 0b111: strcpy(p->mnemonic, "vminb"); src1 |= reg_t; src2 |= reg_s; break;
                    }
                    break;
                case 0b111:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "and"); src1 |= reg_s; src2 |= reg_t; break;
                        case 0b1: strcpy(p->mnemonic, "and"); src1 |= reg_t; src2 |= reg_s; src2mod = mod_complement; break;
                        case 0b10: strcpy(p->mnemonic, "or"); src1 |= reg_s; src2 |= reg_t; break;
                        case 0b11: strcpy(p->mnemonic, "or"); src1 |= reg_t; src2 |= reg_s; src2mod = mod_complement; break;
                        case 0b100: strcpy(p->mnemonic, "xor"); src1 |= reg_s; src2 |= reg_t; break;
                    }
                    break;
            }
            break;
        case 0b0101:
            dst = reg_r | reg_r | reg_32;
            src1 = reg_r;
            src2 = reg_r;
            _minOp = majOp >= 0b100 ? minOp>>2 : minOp;
            switch(majOp) {
                case 0b0:
                    src1 |= reg_t | reg_lo;
                    src2 |= reg_s;
                    _minOp = minOp >> 1;
                    switch(_minOp) {
                        case 0b00: strcpy(p->mnemonic, "add"); src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "add"); src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "add"); p->type |= in_sat; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "add"); p->type |= in_sat; src2 |= reg_hi; break;
                    }
                    break;
                case 0b1:
                    src1 |= reg_t | reg_lo;
                    src2 |= reg_s;
                    _minOp = minOp >> 1;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "sub"); src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "sub"); src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "sub"); p->type |= in_sat; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "sub"); p->type |= in_sat; src2 |= reg_hi; break;
                    }
                    break;
                case 0b10:
                    src1 |= reg_t;
                    src2 |= reg_s;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "add"); p->type |= in_shiftBy16; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "add"); p->type |= in_shiftBy16; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "add"); p->type |= in_shiftBy16; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "add"); p->type |= in_shiftBy16; src1 |= reg_hi; src2 |= reg_hi; break;
                        case 0b100: strcpy(p->mnemonic, "add"); p->type |= in_sat | in_shiftBy16; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b101: strcpy(p->mnemonic, "add"); p->type |= in_sat | in_shiftBy16; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b110: strcpy(p->mnemonic, "add"); p->type |= in_sat | in_shiftBy16; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b111: strcpy(p->mnemonic, "add"); p->type |= in_sat | in_shiftBy16; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b11:
                    src1 |= reg_t;
                    src2 |= reg_s;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "sub"); p->type |= in_shiftBy16; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "sub"); p->type |= in_shiftBy16; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "sub"); p->type |= in_shiftBy16; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "sub"); p->type |= in_shiftBy16; src1 |= reg_hi; src2 |= reg_hi; break;
                        case 0b100: strcpy(p->mnemonic, "sub"); p->type |= in_sat | in_shiftBy16; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b101: strcpy(p->mnemonic, "sub"); p->type |= in_sat | in_shiftBy16; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b110: strcpy(p->mnemonic, "sub"); p->type |= in_sat | in_shiftBy16; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b111: strcpy(p->mnemonic, "sub"); p->type |= in_sat | in_shiftBy16; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b100:
                    src1 |= reg_32;
                    src2 |= reg_32;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "add"); p->type |= in_sat | in_deprecated; src1 |= reg_s; src2 |= reg_t; break;
                        case 0b1: strcpy(p->mnemonic, "sub"); p->type |= in_sat | in_deprecated; src1 |= reg_t; src2 |= reg_s; break;
                    }
                    break;
                case 0b101:
                    src1 |= reg_t | reg_32;
                    src2 |= reg_s | reg_32;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "min"); break;
                        case 0b1: strcpy(p->mnemonic, "minu"); break;
                    }
                    break;
                case 0b110:
                    src1 |= reg_s | reg_32;
                    src2 |= reg_t | reg_32;
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "max"); break;
                        case 0b1: strcpy(p->mnemonic, "maxu"); break;
                    }
                    break;
                case 0b111:
                    src1 |= reg_s | reg_32;
                    src2 |= reg_t | reg_32;
                    strcpy(p->mnemonic, "parity"); break;
            }
            break;
        case 0b0110:
            dst = reg_r | reg_d | reg_32;
            src1 = imm_u;
            _majOp = majOp >> 1;
            switch(_majOp) {
                case 0b00: strcpy(p->mnemonic, "sfmake"); p->type |= in_pos; break;
                case 0b01: strcpy(p->mnemonic, "sfmale"); p->type |= in_neg; break;
            }
            break;
        case 0b0111:
            if(BIT_2(majOp)) return;
            dst = reg_r | reg_d | reg_32;
            src1 = imm_u;
            strcpy(p->mnemonic, "add");
            composite = true;
            src2 = reg_r | reg_s | reg_32;
            src3 = reg_r | reg_t | reg_32;
            strcpy(inst->parts[2].mnemonic, "mpyi");
            break;
        case 0b1000:
            dst = reg_r | reg_d | reg_32;
            src1 = imm_u;
            strcpy(p->mnemonic, "add");
            composite = true;
            src2 = reg_r | reg_s | reg_32;
            src3 = imm_u;
            strcpy(inst->parts[2].mnemonic, "mpyi");
            break;
        case 0b1001:
            dst = reg_r | reg_d | reg_64;
            src1 = imm_u;
            _majOp = majOp >> 1;
            switch(_majOp) {
                case 0b0: strcpy(p->mnemonic, "dfmake"); p->type |= in_pos; break;
                case 0b1: strcpy(p->mnemonic, "dfmake"); p->type |= in_neg; break;
            }
            break;
        case 0b1011:
            _majOp = majOp >> 2;
            switch(_majOp) {
                case 0b0:
                    dst = reg_r | reg_d | reg_32;
                    src1 = imm_u;
                    strcpy(p->mnemonic, "add");
                    composite = true;
                    src2 = reg_r | reg_u | reg_32;
                    src3 = imm_s;
                    strcpy(inst->parts[2].mnemonic, "add");
                    break;
                case 0b1:
                    dst = reg_r | reg_d | reg_32;
                    src1 = imm_u;
                    strcpy(p->mnemonic, "add");
                    composite = true;
                    src2 = reg_r | reg_u | reg_32;
                    src3 = imm_s;
                    strcpy(inst->parts[2].mnemonic, "sub");
                    break;
            }
            break;
        case 0b1100:
            dst = reg_p;
            src1 = reg_r | reg_s | reg_64;
            _minOp = minOp & 0b011;
            switch(majOp) {
                case 0b0:
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "vcmpb.eq"); src3 = imm_u; break;
                        case 0b1: strcpy(p->mnemonic, "vcmph.eq"); src3 = imm_s; break;
                        case 0b10: strcpy(p->mnemonic, "vcmpw.eq"); src3 = imm_s; break;
                    }
                    break;
                case 0b1:
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "vcmpb.gt"); src3 = imm_s; break;
                        case 0b1: strcpy(p->mnemonic, "vcmph.gt"); src3 = imm_s; break;
                        case 0b10: strcpy(p->mnemonic, "vcmpw.gt"); src3 = imm_s; break;
                    }
                    break;
                case 0b10:
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "vcmpb.gtu"); src3 = imm_u; break;
                        case 0b1: strcpy(p->mnemonic, "vcmph.gtu"); src3 = imm_u; break;
                        case 0b10: strcpy(p->mnemonic, "vcmpw.gtu"); src3 = imm_u; break;
                    }
                    break;
            }
            break;
        case 0b1101:
            dst = reg_p;
            src1 = reg_r | reg_s | reg_32;
            _majOp = majOp & 0b011;
            _minOp = minOp & 0b011;
            switch(_majOp) {
                case 0b0:
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "cmpb.eq"); src3 = imm_u; break;
                        case 0b1: strcpy(p->mnemonic, "cmph.eq"); src3 = imm_s; break;
                    }
                    break;
                case 0b1:
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "cmpb.gt"); src3 = imm_s; break;
                        case 0b1: strcpy(p->mnemonic, "cmph.gt"); src3 = imm_s; break;
                    }
                    break;
                case 0b10:
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "cmpb.gtu"); src3 = imm_u; break;
                        case 0b1: strcpy(p->mnemonic, "cmph.gtu"); src3 = imm_u; break;
                    }
                    break;
            }
            break;
        case 0b1110:
            _majOp = EXTRACT(inst->code, 2, 1) | (EXTRACT(inst->code, 1, 4) << 2);
            dst = reg_r | reg_x | reg_32;
            src1 = imm_u;
            composite = true;
            src2 = reg_r | reg_x | reg_32;
            src3 = imm_u;
            switch(_majOp) {
                case 0b000: strcpy(p->mnemonic, "and"); strcpy(inst->parts[2].mnemonic, "asl"); break;
                case 0b001: strcpy(p->mnemonic, "or"); strcpy(inst->parts[2].mnemonic, "asl"); break;
                case 0b100: strcpy(p->mnemonic, "and"); strcpy(inst->parts[2].mnemonic, "lsr"); break;
                case 0b101: strcpy(p->mnemonic, "or"); strcpy(inst->parts[2].mnemonic, "lsr"); break;
            }
        case 0b1111:
            _majOp = majOp >> 2;
            switch(_majOp) {
                case 0b0:
                    dst = reg_r | reg_d | reg_32;
                    src1 = reg_r | reg_u | reg_32;
                    strcpy(p->mnemonic, "add");
                    composite = true;
                    src2 = imm_u; src2mod = mod_col2;
                    src3 = reg_r | reg_s | reg_32;
                    strcpy(inst->parts[2].mnemonic, "mpyi");
                    break;
                case 0b1:
                    dst = reg_r | reg_d | reg_32;
                    src1 = reg_r | reg_u | reg_32;
                    strcpy(p->mnemonic, "add");
                    composite = true;
                    src2 = reg_r | reg_s | reg_32;
                    src3 = imm_u;
                    strcpy(inst->parts[2].mnemonic, "mpyi");
                    break;
            }
            break;
    }
    
    uint8_t opCount = 0;
    
    openc_t *op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(dst, reg_d)? op_dst : MATCHRT(dst, reg_x)? op_xrc : op_pdst) << (op_size * opCount++);
    op->type = dst;
    op->val = MATCHRT(dst, reg_d)? EXTRACT(inst->code, 5, (MATCHRT(src1, reg_u)? 8 : 0)) :
    MATCHRT(dst, reg_x)? EXTRACT(inst->code, 5, (MATCHRT(src1, reg_u)? 8 : 16)) :
    EXTRACT(inst->code, 2, 0);
    
    op = &p->operands[opCount];
    p->opOrder |= op_src << (op_size * opCount++); // todo
    op->type = src1;
    op->val = MATCHRT(src1, reg_s)? EXTRACT(inst->code, 5, 16) :
    MATCHRT(src1, reg_t)? EXTRACT(inst->code, 5, 8) :
    MATCHRT(src1, reg_u)? EXTRACT(inst->code, 5, 0) :
    MATCHIT(src1, imm_u)? :
    (MATCHRT(src2, reg_s)? EXTRACT(inst->code, 3, 5) | EXTRACT(inst->code, 1, 13) << 3 | EXTRACT(inst->code, 2, 21) <<4 :
     src2 ? EXTRACT(inst->code, 1, 3) | EXTRACT(inst->code, 3, 5) << 1 | EXTRACT(inst->code, 1, 13) << 4 | EXTRACT(inst->code, 3, 21) <<5 :
     EXTRACT(inst->code, 9, 5) | EXTRACT(inst->code, 1, 21) << 9);
    
    if(composite) {
        opCount = 0;
        p = &inst->parts[1];
        
        op = &p->operands[opCount];
        p->opOrder |= (MATCHRT(src2, reg_x)? op_xrc : op_src) << (op_size * opCount++);
        op->type = src2;
        op->val = MATCHRT(src2, reg_s)? EXTRACT(inst->code, 5, 16):
        MATCHRT(src2, (reg_u|reg_x))? EXTRACT(inst->code, 5, 0) :
        EXTRACT(inst->code, 0, 0);
    
        op = &p->operands[opCount];
        p->opOrder |= (MATCHRT(src3, reg_x)? op_xrc : op_src) << (op_size * opCount++);
        op->type = src3;
        op->val = MATCHRT(src3, reg_s)? EXTRACT(inst->code, 5, 16):
        MATCHRT(src3, reg_t)? EXTRACT(inst->code, 5, 8) :
        MATCHRT(src2, reg_x)? EXTRACT(inst->code, 5, 8) :
        EXTRACT(inst->code, 3, 5) | EXTRACT(inst->code, 1, 13) << 3 | EXTRACT(inst->code, 2, 21) <<4;
        
    } else if(src2) {
        op = &p->operands[opCount];
        p->opOrder |= (MATCHRT(src2, reg_s)? op_src : MATCHRT(src2, reg_t)? op_trc : op_imm1) << (op_size * opCount++);
        op->type = src2;
        op->val = MATCHRT(src2, reg_s)? EXTRACT(inst->code, 5, 16) :
        MATCHRT(src2, reg_t)? EXTRACT(inst->code, 5, 8):
        EXTRACT(inst->code, 8, 5);
    }

}

- (void)decodeXType4:(insn_t*)inst {
    uint8_t regType = EXTRACT(inst->code, 4, 24);
    uint8_t majOp = EXTRACT(inst->code, 3, 21);
    uint8_t minOp = EXTRACT(inst->code, 3, 5);
    uint8_t _majOp, _minOp;
    uint16_t dst = 0, src1 = 0, src2 = 0, src3 = 0, src2mod = 0;
    bool composite = false;
    
    insp_t *p = &inst->parts[0];
    
    uint32_t shift = 0;
    
    switch(regType) {
        case 0b0000:
            dst = reg_r | reg_d | reg_32;
            src1 = reg_r | reg_s | reg_32;
            src2 = imm_u;
            _majOp = majOp >> 2;
            switch(_majOp) {
                case 0b0: strcpy(p->mnemonic, "mpyi"); p->type |= in_plus; break;
                case 0b1: strcpy(p->mnemonic, "mpyi"); p->type |= in_minus; break;
            }
            break;
        case 0b0001:
            dst = reg_r | reg_x | reg_32;
            src1 = reg_r | reg_s | reg_32;
            src2 = imm_u;
            _majOp = majOp >> 2;
            switch(_majOp) {
                case 0b0: strcpy(p->mnemonic, "mpyi"); p->type |= in_as_add; break;
                case 0b1: strcpy(p->mnemonic, "mpyi"); p->type |= in_as_sub; break;
            }
            break;
        case 0b0010:
            dst = reg_r | reg_d | reg_32;
            src1 = reg_r | reg_s | reg_32;
            src2 = imm_s;
            _majOp = majOp >> 2;
            switch(_majOp) {
                case 0b0: strcpy(p->mnemonic, "add"); p->type |= in_as_add; break;
                case 0b1: strcpy(p->mnemonic, "add"); p->type |= in_as_sub; break;
            }
            break;
        case 0b0011:
            dst = reg_r | reg_x | reg_32;
            src1 = reg_r | reg_u | reg_32;
            src2 = reg_r | reg_x | reg_32;
            src3 = reg_r | reg_s | reg_32;
            switch(majOp) {
                case 0b0: strcpy(p->mnemonic, "add"); composite = true; strcpy(inst->parts[1].mnemonic, "mpyi"); break;
            }
            break;
        case 0b100:
            shift = EXTRACT(majOp, 1, 2) == 1 ? in_shiftBy1 : 0;
            dst = reg_r | reg_d | reg_64;
            src1 = reg_r | reg_s;
            src2 = reg_r | reg_t;
            _majOp = majOp & 0b011;
            _minOp = minOp & 0b011;
            switch(_majOp) {
                case 0b0:
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= shift; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= shift; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpy"); p->type |= shift; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpy"); p->type |= shift; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b1:
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b10:
                    switch(_minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyu"); p->type |= shift; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpyu"); p->type |= shift; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpyu"); p->type |= shift; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpyu"); p->type |= shift; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
            }
            break;
        case 0b0101:
            dst = reg_r | reg_d | reg_64;
            src1 = reg_r | reg_s | reg_32;
            src2 = reg_r | reg_t | reg_32;
            shift = EXTRACT(majOp, 1, 2) == 1 ? in_shiftBy1 : 0;
            _majOp = minOp > 0b100 ? majOp&0b011 : majOp;
            switch(_majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); break;
                        case 0b1: strcpy(p->mnemonic, "cmpyi"); break;
                        case 0b10: strcpy(p->mnemonic, "cmpyr"); break;
                        case 0b101: strcpy(p->mnemonic, "vmpyh"); p->type |= shift | in_sat; break;
                        case 0b110: strcpy(p->mnemonic, "cmpy"); p->type |= shift | in_sat; break;
                    }
                    break;
                case 0b10:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyu"); break;
                        case 0b1: strcpy(p->mnemonic, "vmpybsu"); break;
                        case 0b110: strcpy(p->mnemonic, "cmpy"); p->type |= shift | in_sat; src2mod = mod_asterisk; break;
                    }
                    break;
                case 0b100:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "vmpybu"); break;
                    }
                    break;
            }
            break;
        case 0b110:
            shift = EXTRACT(majOp, 1, 2) == 1 ? in_shiftBy1 : 0;
            dst = reg_r | reg_x | reg_64;
            src1 = reg_r | reg_s;
            src2 = reg_r | reg_t;
            _majOp = majOp & 0b011;
            switch(_majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_add; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_add; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_add; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_add; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b1:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_sub; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_sub; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_sub; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_sub; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b10:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_add; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_add; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_add; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_add; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b11:
                    switch(minOp) {
                        case 0b100: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_sub; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b101: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_sub; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b110: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_sub; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b111: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_sub; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
            }
            break;
        case 0b111:
            shift = EXTRACT(majOp, 1, 2) == 1 ? in_shiftBy1 : 0;
            dst = reg_r | reg_x | reg_64;
            src1 = reg_r | reg_s | reg_32;
            src2 = reg_r | reg_t | reg_32;
            _majOp = minOp > 0b100 ? majOp&0b011 : majOp;
            switch(_majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= in_as_add; break;
                        case 0b1: strcpy(p->mnemonic, "cmpyi"); p->type |= in_as_add; break;
                        case 0b10: strcpy(p->mnemonic, "cmpyr"); p->type |= in_as_add; break;
                        case 0b101: strcpy(p->mnemonic, "vmpyh"); p->type |= shift | in_sat | in_as_add; break;
                        case 0b110: strcpy(p->mnemonic, "cmpy"); p->type |= shift | in_sat | in_as_add; break;
                        case 0b111: strcpy(p->mnemonic, "cmpy"); p->type |= shift | in_sat | in_as_sub; break;
                    }
                    break;
                case 0b1:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= in_as_sub; break;
                        case 0b1: strcpy(p->mnemonic, "vmpyh"); p->type |= in_as_add; break;
                    }
                    break;
                case 0b10:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyu"); p->type |= in_as_add; break;
                        case 0b110: strcpy(p->mnemonic, "cmpy"); p->type |= shift | in_sat | in_as_add; src2mod = mod_asterisk; break;
                        case 0b111: strcpy(p->mnemonic, "cmpy"); p->type |= shift | in_sat | in_as_sub; src2mod = mod_asterisk; break;
                    }
                    break;
                case 0b11:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyu"); p->type |= in_as_sub; break;
                    }
                    break;
                case 0b100:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "vmpybu"); p->type |= in_as_add; break;
                    }
                    break;
                case 0b110:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "vmpybsu"); p->type |= in_as_add; break;
                    }
                    break;
            }
            break;
        case 0b1000:
            shift = EXTRACT(majOp, 1, 2) == 1 ? in_shiftBy1 : 0;
            dst = reg_r | reg_d | reg_64;
            src1 = reg_r | reg_s | reg_64;
            src2 = reg_r | reg_t | reg_64;
            _majOp = minOp > 0b100 || minOp == 0b010 ? majOp&0b011 : majOp;
            switch(_majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vrcmpyi"); break;
                        case 0b1: strcpy(p->mnemonic, "vrcmpyr"); break;
                        case 0b101: strcpy(p->mnemonic, "vmpyweh"); p->type |= shift | in_sat; break;
                        case 0b110: strcpy(p->mnemonic, "vmpyeh"); p->type |= shift | in_sat; break;
                        case 0b111: strcpy(p->mnemonic, "vmpywoh"); p->type |= shift | in_sat; break;
                    }
                    break;
                case 0b1:
                    switch(minOp) {
                        case 0b10: strcpy(p->mnemonic, "vrmpywoh"); p->type |= shift; break;
                        case 0b101: strcpy(p->mnemonic, "vmpyweh"); p->type |= shift | in_rnd | in_sat; break;
                        case 0b110: strcpy(p->mnemonic, "vcmpyr"); p->type |= shift | in_sat; break;
                        case 0b111: strcpy(p->mnemonic, "vmpywoh"); p->type |= shift | in_rnd | in_sat; break;
                    }
                    break;
                case 0b10:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vrcmpyi"); src2mod = mod_asterisk; break;
                        case 0b100: strcpy(p->mnemonic, "vrmpyweh"); p->type |= shift; break;
                        case 0b101: strcpy(p->mnemonic, "vmpyweuh"); p->type |= shift | in_sat; break;
                        case 0b110: strcpy(p->mnemonic, "vcmpyi"); p->type |= shift | in_sat; break;
                        case 0b111: strcpy(p->mnemonic, "vmpywouh"); p->type |= shift | in_sat; break;
                    }
                    break;
                case 0b11:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "vrcmpyr"); src2mod = mod_asterisk; break;
                        case 0b101: strcpy(p->mnemonic, "vmpyweuh"); p->type |= shift | in_rnd | in_sat; break;
                        case 0b111: strcpy(p->mnemonic, "vmpywouh"); p->type |= shift | in_rnd | in_sat; break;
                    }
                    break;
                case 0b100:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "vrmpybu"); break;
                    }
                    break;
                case 0b101:
                    switch(minOp) {
                        case 0b100: strcpy(p->mnemonic, "vrcmpys"); p->type |= in_shiftBy1 | in_sat | in_raw | in_hi; break;
                    }
                    break;
                case 0b110:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "vrmpybsu"); break;
                    }
                    break;
                case 0b111:
                    switch(minOp) {
                        case 0b100: strcpy(p->mnemonic, "vrcmpys"); p->type |= in_shiftBy1 | in_sat | in_raw | in_lo; break;
                    }
                    break;
            }
            break;
        case 0b1001:
            dst = reg_r | reg_d | reg_32;
            src1 = reg_r | reg_s | reg_64;
            src2 = reg_r | reg_t | reg_64;
            _majOp = minOp & 0b111 ? BIT_0(majOp) | ((majOp&0b100)>>1) : majOp>>2;
            _minOp = minOp & 0b011;
            switch(_majOp) {
                case 0b0:
                    switch(_minOp) {
                        case 0b1: strcpy(p->mnemonic, "vradduh"); break;
                    }
                    break;
                case 0b1:
                    switch(minOp) {
                        case 0b111: strcpy(p->mnemonic, "vraddh"); break;
                    }
                    break;
                case 0b11:
                    switch(minOp) {
                        case 0b111: strcpy(p->mnemonic, "vrcmpys"); p->type |= in_shiftBy1 | in_rnd | in_sat | in_raw | in_lo; break;
                    }
                    break;
            }
            break;
        case 0b1010:
            shift = EXTRACT(majOp, 1, 2) == 1 ? in_shiftBy1 : 0;
            dst = reg_r | reg_x | reg_64;
            src1 = reg_r | reg_s | reg_64;
            src2 = reg_r | reg_t | reg_64;
            _majOp = minOp > 0b100 ? majOp&0b011 : majOp;
            switch(_majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vrcmpyi"); p->type |= in_as_add; break;
                        case 0b1: strcpy(p->mnemonic, "vrcmpyr"); p->type |= in_as_add; break;
                        case 0b101: strcpy(p->mnemonic, "vmpyweh"); p->type |= shift | in_sat | in_as_add; break;
                        case 0b110: strcpy(p->mnemonic, "vmpyeh"); p->type |= shift | in_sat | in_as_add; break;
                        case 0b111: strcpy(p->mnemonic, "vmpywoh"); p->type |= shift | in_sat | in_as_add; break;
                    }
                    break;
                case 0b1:
                    switch(minOp) {
                        case 0b10: strcpy(p->mnemonic, "vmpyeh"); p->type |= in_as_add; break;
                        case 0b100: strcpy(p->mnemonic, "vcmpyr"); p->type |= in_sat | in_as_add; break;
                        case 0b101: strcpy(p->mnemonic, "vmpyweh"); p->type |= shift | in_rnd | in_sat | in_as_add; break;
                        case 0b110: strcpy(p->mnemonic, "vrmpyweh"); p->type |= shift | in_as_add; break;
                        case 0b111: strcpy(p->mnemonic, "vmpywoh"); p->type |= shift | in_rnd | in_sat | in_as_add; break;
                    }
                    break;
                case 0b10:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "vrcmpyi"); p->type |= in_as_add; src2mod = mod_asterisk; break;
                        case 0b100: strcpy(p->mnemonic, "vcmpyi"); p->type |= in_sat | in_as_add; break;
                        case 0b101: strcpy(p->mnemonic, "vmpyweuh"); p->type |= shift | in_sat | in_as_add; break;
                        case 0b111: strcpy(p->mnemonic, "vmpywouh"); p->type |= shift | in_sat | in_as_add; break;
                    }
                    break;
                case 0b11:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "vrcmpyr"); p->type |= in_as_add; src2mod = mod_asterisk; break;
                        case 0b101: strcpy(p->mnemonic, "vmpyweuh"); p->type |= shift | in_rnd | in_sat | in_as_add; break;
                        case 0b110: strcpy(p->mnemonic, "vrmpywoh"); p->type |= shift | in_as_add; break;
                        case 0b111: strcpy(p->mnemonic, "vmpywouh"); p->type |= shift | in_rnd | in_sat | in_as_add; break;
                    }
                    break;
                case 0b100:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "vrmpybu"); p->type |= in_as_add; break;
                    }
                    break;
                case 0b101:
                    switch(minOp) {
                        case 0b100: strcpy(p->mnemonic, "vrcmpys"); p->type |= in_shiftBy1 | in_sat | in_raw | in_hi | in_as_add; break;
                    }
                    break;
                case 0b110:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "vrmpybsu"); p->type |= in_as_add; break;
                    }
                    break;
                case 0b111:
                    switch(minOp) {
                        case 0b100: strcpy(p->mnemonic, "vrcmpys"); p->type |= in_shiftBy1 | in_sat | in_raw | in_lo | in_as_add; break;
                    }
                    break;
            }
            break;
        case 0b1011:
            dst = reg_r | reg_d | reg_32;
            src1 = reg_r | reg_s | reg_32;
            src2 = reg_r | reg_t | reg_32;
            switch(majOp) {
                case 0b110:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "sffixupn"); break;
                        case 0b1: strcpy(p->mnemonic, "sffixupd"); break;
                    }
                    break;
            }
            break;
        case 0b1100:
            shift = EXTRACT(majOp, 1, 2) == 1 ? in_shiftBy1 : 0;
            dst = reg_r | reg_d | reg_32;
            src1 = reg_r | reg_s;
            src2 = reg_r | reg_t;
            _majOp = majOp&0b011;
            switch(majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= shift; src1 |= reg_lo; src2 = reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= shift; src1 |= reg_lo; src2 = reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpy"); p->type |= shift; src1 |= reg_hi; src2 = reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpy"); p->type |= shift; src1 |= reg_hi; src2 = reg_hi; break;
                        case 0b100: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat; src1 |= reg_lo; src2 = reg_lo; break;
                        case 0b101: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat; src1 |= reg_lo; src2 = reg_hi; break;
                        case 0b110: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat; src1 |= reg_lo; src2 = reg_hi; break;
                        case 0b111: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat; src1 |= reg_hi; src2 = reg_hi; break;
                    }
                    break;
                case 0b1:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd; src1 |= reg_lo; src2 = reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd; src1 |= reg_lo; src2 = reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd; src1 |= reg_hi; src2 = reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd; src1 |= reg_hi; src2 = reg_hi; break;
                        case 0b100: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd | in_sat; src1 |= reg_lo; src2 = reg_lo; break;
                        case 0b101: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd | in_sat; src1 |= reg_lo; src2 = reg_hi; break;
                        case 0b110: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd | in_sat; src1 |= reg_hi; src2 = reg_lo; break;
                        case 0b111: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_rnd | in_sat; src1 |= reg_hi; src2 = reg_hi; break;
                    }
                    break;
                case 0b10:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyu"); p->type |= shift; src1 |= reg_lo; src2 = reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpyu"); p->type |= shift; src1 |= reg_lo; src2 = reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpyu"); p->type |= shift; src1 |= reg_hi; src2 = reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpyu"); p->type |= shift; src1 |= reg_hi; src2 = reg_hi; break;
                    }
                    break;
            }
            break;
        case 0b1101:
            dst = reg_r | reg_d | reg_32;
            src1 = reg_r | reg_s | reg_32;
            src2 = reg_r | reg_t;
            shift = EXTRACT(majOp, 1, 2) == 1 ? in_shiftBy1 : 0;
            _majOp = minOp > 0b100 ? majOp&0b011 : majOp;
            switch(_majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyi"); src2 |= reg_32; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= in_rnd; src2 |= reg_32; break;
                    }
                    break;
                case 0b1:
                    switch(minOp) {
                        case 0b110: strcpy(p->mnemonic, "cmpy"); p->type |= shift | in_rnd | in_sat; src2 |= reg_32; break;
                    }
                    break;
                case 0b10:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "mpyu"); src2 |= reg_32; break;
                    }
                    break;
                case 0b11:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "mpysu"); src2 |= reg_32; break;
                        case 0b110: strcpy(p->mnemonic, "cmpy"); p->type |= shift | in_rnd | in_sat; src2 |= reg_32; src2mod = mod_asterisk; break;
                    }
                    break;
                case 0b101:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= in_shiftBy1 | in_sat; src2 |= reg_hi; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= in_shiftBy1 | in_sat; src2 |= reg_lo; break;
                        case 0b100: strcpy(p->mnemonic, "mpy"); p->type |= in_shiftBy1 | in_rnd | in_sat; src2 |= reg_hi; break;
                    }
                    break;
                case 0b111:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= in_shiftBy1 | in_sat; src2 |= reg_32; break;
                        case 0b100: strcpy(p->mnemonic, "mpy"); p->type |= in_shiftBy1 | in_rnd | in_sat; src2 |= reg_lo; break;
                    }
                    break;
            }
            
            if(strcmp(p->mnemonic, "") < 0 && BIT_1(majOp) == 0 && BIT_2(minOp) == 0) {
                uint8_t n = minOp | (0b1&majOp)<<2 | (majOp>>2)<<3;
                shift = n ? in_shiftBy1 : n == 2 ? in_shiftBy2 : n == 3 ? in_shiftBy3: n == 4 ? in_shiftBy4 : 0;
                strcpy(p->mnemonic, "mpy"); p->type |= shift; src2 |= reg_32;
            }
            
            break;
        case 0b1110:
            shift = EXTRACT(majOp, 1, 2) == 1 ? in_shiftBy1 : 0;
            dst = reg_r | reg_x | reg_32;
            src1 = reg_r | reg_s;
            src2 = reg_r | reg_t;
            _majOp = majOp&0b011;
            switch(_majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_add; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_add; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_add; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_add; src1 |= reg_hi; src2 |= reg_hi; break;
                        case 0b100: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat | in_as_add; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b101: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat | in_as_add; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b110: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat | in_as_add; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b111: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat | in_as_add; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b1:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_sub; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_sub; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_sub; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_as_sub; src1 |= reg_hi; src2 |= reg_hi; break;
                        case 0b100: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat | in_as_sub; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b101: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat | in_as_sub; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b110: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat | in_as_sub; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b111: strcpy(p->mnemonic, "mpy"); p->type |= shift | in_sat | in_as_sub; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b10:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_add; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_add; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_add; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_add; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
                case 0b11:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_sub; src1 |= reg_lo; src2 |= reg_lo; break;
                        case 0b1: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_sub; src1 |= reg_lo; src2 |= reg_hi; break;
                        case 0b10: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_sub; src1 |= reg_hi; src2 |= reg_lo; break;
                        case 0b11: strcpy(p->mnemonic, "mpyu"); p->type |= shift | in_as_sub; src1 |= reg_hi; src2 |= reg_hi; break;
                    }
                    break;
            }
            break;
        case 0b1111:
            dst = reg_r | reg_x | reg_32;
            src1 = reg_r | reg_s | reg_32;
            src2 = reg_r | reg_t | reg_32;
            switch(majOp) {
                case 0b0:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpyi"); p->type |= in_as_add; break;
                        case 0b1: strcpy(p->mnemonic, "add"); p->type |= in_as_add; break;
                        case 0b100: strcpy(p->mnemonic, "sfmpy"); p->type |= in_as_add; break;
                        case 0b101: strcpy(p->mnemonic, "sfmpy"); p->type |= in_as_sub; break;
                        case 0b110: strcpy(p->mnemonic, "sfmpy"); p->type |= in_lib | in_as_add; break;
                        case 0b111: strcpy(p->mnemonic, "sfmpy"); p->type |= in_lib | in_as_sub; break;
                    }
                    break;
                case 0b1:
                    src2mod = mod_complement;
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "and"); p->type |= in_as_or; break;
                        case 0b1: strcpy(p->mnemonic, "and"); p->type |= in_as_and; break;
                        case 0b10: strcpy(p->mnemonic, "and"); p->type |= in_as_xor; break;
                    }
                    break;
                case 0b10:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "and"); p->type |= in_as_and; break;
                        case 0b1: strcpy(p->mnemonic, "or"); p->type |= in_as_and; break;
                        case 0b10: strcpy(p->mnemonic, "xor"); p->type |= in_as_and; break;
                        case 0b11: strcpy(p->mnemonic, "and"); p->type |= in_as_or; break;
                    }
                    break;
                case 0b11:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "mpy"); p->type |= in_shiftBy1 | in_sat | in_as_add; break;
                        case 0b1: strcpy(p->mnemonic, "mpy"); p->type |= in_shiftBy1 | in_sat | in_as_sub; break;
                    }
                    break;
                case 0b100:
                    switch(minOp) {
                        case 0b1: strcpy(p->mnemonic, "add"); p->type |= in_as_sub; break;
                        case 0b11: strcpy(p->mnemonic, "xor"); p->type |= in_as_xor; break;
                    }
                    break;
                case 0b110:
                    switch(minOp) {
                        case 0b0: strcpy(p->mnemonic, "or"); p->type |= in_as_or; break;
                        case 0b1: strcpy(p->mnemonic, "xor"); p->type |= in_as_or; break;
                        case 0b10: strcpy(p->mnemonic, "and"); p->type |= in_as_xor; break;
                        case 0b11: strcpy(p->mnemonic, "or"); p->type |= in_as_xor; break;
                    }
                    break;
            }
            break;
    }
    
    uint8_t opCount = 0;
    
    openc_t *op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(dst, reg_d)? op_dst : op_xrc) << (op_size * opCount++);
    op->type = dst;
    op->val = EXTRACT(inst->code, 5, (composite ? 8 : 0));
    
    op = &p->operands[opCount];
    p->opOrder |= (MATCHRT(src1, reg_s)? op_src : op_urc) << (op_size * opCount++);
    op->type = src1;
    op->val = MATCHRT(src1, reg_s)? EXTRACT(inst->code, 5, 16) : EXTRACT(inst->code, 5, 0);
    
    if(!composite) {
        op = &p->operands[opCount];
        p->opOrder |= (MATCHRT(src2, reg_t)? op_trc : op_imm1) << (op_size * opCount++);
        op->type = src2;
        op->val = MATCHRT(src2, reg_t)? EXTRACT(inst->code, 5, 8) : EXTRACT(inst->code, 8, 5);
    } else {
        p = &inst->parts[1];
        opCount = 0;
        
        op = &p->operands[opCount];
        p->opOrder |= op_xrc << (op_size * opCount++);
        op->type = src2;
        op->val = EXTRACT(inst->code, 5, 8);
        
        op = &p->operands[opCount];
        p->opOrder |= op_src << (op_size * opCount++);
        op->type = src3;
        op->val = EXTRACT(inst->code, 5, 16);
    }

}



- (void)decodeInstruction:(insn_t*) inst {
    if(inst->packet == 0b00) {
        strcpy(inst->parts[0].mnemonic, "duplex");
        HexagonDuplexIClass iclass;
        if(duplex) {
            iclass = lowClass[inst->iclass];
        } else {
            iclass = highClass[inst->iclass];
        }
        
        switch (iclass) {
            case HID_L1:
                break;
            case HID_L2:
                break;
            case HID_A:
                break;
            case HID_S1:
                break;
            case HID_S2:
                break;
            default:
                return;
        }
    } else {
        switch(inst->iclass) {
            case HI_ConstantExtender:       // 0000
                [self decodeConstantExtender:inst]; break;
            case HI_Alu32:                  // 0111
                [self decodeAlu32:inst]; break;
            case HI_Alu32_2:                // 1011
                [self decodeAlu32_2:inst]; break;
            case HI_Alu32_3:                // 1111
                [self decodeAlu32_3:inst]; break;
            case HI_Control:                // 0110
                [self decodeControl:inst]; break;
            case HI_Jump:                   // 0001
                [self decodeJump:inst]; break;
            case HI_Jump_2:                 // 0010
                [self decodeJump2:inst]; break;
            case HI_Jump_3:                 // 0101
                [self decodeJump3:inst]; break;
            case HI_LoadStore:              // 0011
                [self decodeLoadStore:inst]; break;
            case HI_LoadStoreConditional:   // 0100
                [self decodeLoadStoreConditional:inst]; break;
            case HI_Load:                   // 1001
                [self decodeLoad:inst]; break;
            case HI_Store:                  // 1010
                [self decodeStore:inst]; break;
            case HI_XType:                  // 1000
                [self decodeXType:inst]; break;
            case HI_XType_2:                // 1100
                [self decodeXType2:inst]; break;
            case HI_XType_3:                // 1101
                [self decodeXType3:inst]; break;
            case HI_XType_4:                // 1110
                [self decodeXType4:inst]; break;
        }
    }
}

- (int)disassembleSingleInstruction:(DisasmStruct *)disasm usingProcessorMode:(NSUInteger)mode {
    if (disasm->bytes == NULL) return DISASM_UNKNOWN_OPCODE;
    insn_t inst = {.code =  [self readWordAt:(uint32_t)disasm->virtualAddr]};
    
    disasm->instruction.length = 4;
    
    // packet, iclass extraction
    inst.packet = EXTRACT(inst.code, PACKET_LEN, PACKET_OFF);
    
    if(inst.packet == 0x00) {
        inst.iclass = EXTRACT(inst.code, DUPLEX_ICLASS_LOWER_LEN, DUPLEX_ICLASS_LOWER_OFF) |
        (EXTRACT(inst.code, DUPLEX_ICLASS_UPPER_LEN, DUPLEX_ICLASS_UPPER_OFF) << 1);
        inst.hip = HIP_DUPLEX;
    } else {
        inst.iclass = EXTRACT(inst.code, ICLASS_LEN, ICLASS_OFF);
        
        inst.hip = [self firstInPacket:(uint32_t)disasm->virtualAddr] ? HIP_PKG_START : inst.packet == 0b11 ? HIP_PKG_END : HIP_NONE;
    }
    
    [self decodeInstruction:&inst];
    
    disasm->instruction.pcRegisterValue = disasm->virtualAddr+4;
    while(![self firstInPacket:(uint32_t)disasm->instruction.pcRegisterValue]) {
        disasm->instruction.pcRegisterValue += 4;
    }

   
    if(!MATCH(inst.parts[0].type,in_as_only)) {
        if(inst.parts[0].type & in_condition) {
            strcpy(disasm->instruction.mnemonic, inst.parts[0].mnemonic);
            strcpy(disasm->instruction.unconditionalMnemonic, inst.parts[1].mnemonic);
        } else if(strcmp("", inst.parts[1].mnemonic)) {
            strcpy(disasm->instruction.mnemonic, inst.parts[0].mnemonic);
            strcpy(disasm->instruction.unconditionalMnemonic, inst.parts[1].mnemonic);
        } else {
            strcpy(disasm->instruction.unconditionalMnemonic, inst.parts[0].mnemonic);
        }
    }
    
    disasm->instruction.condition = inst.cond;
    disasm->instruction.branchType = inst.branch;
    
    disasm->instruction.userData = (uintptr_t)malloc(sizeof(uint32_t)*IUD_SIZE);
    memset((void *)disasm->instruction.userData, 0, sizeof(uint32_t)*IUD_SIZE);
    uint32_t (*userData)[] = (uint32_t (*)[])disasm->instruction.userData;
    
    (*userData)[IUD_HIP] = inst.hip;

    uint8_t opIndex = 0;

    for(int i = 0; i < 2; i++) {
        insp_t p = inst.parts[i];
        
        (*userData)[i+IUD_TYP1] = p.type;
        (*userData)[i+IUD_ORD1] = p.opOrder;
        
        if(p.type & in_nop) {
            break;
        }

        
        for(int j = 0; j < (int)(order_size/op_size) && j < DISASM_MAX_OPERANDS; j++){
            uint8_t op = (p.opOrder >> j*op_size) & op_mask;
            if(op == op_stop) {
                break;
            }
            
            openc_t insOp = p.operands[j];
            DisasmOperand *disOp = &disasm->operand[opIndex++];
            
            disOp->userData[OPU_TYPE] = insOp.type;
            disOp->userData[OPU_MOD] = insOp.modifier;
            disOp->userData[OPU_SET] = 1;
            disOp->userData[OPU_PART] = i;
            disOp->userData[OPU_ID] = j;

            if(insOp.composite) { // composite
                continue;
            }
            
            disOp->size = 32;
            
            if(BIT_0(insOp.type)) { // Register
                disOp->type = DISASM_OPERAND_REGISTER_TYPE;
                NSUInteger cls = 0;
                
                uint16_t insType = insOp.type;
                uint16_t regType = (insType & 0b1111);
                
                if(regType == (reg_r) || regType == (reg_u)) {
                    cls = RegClass_GeneralPurposeRegister;
                    // differentiate
                    
                    disOp->size = insType & reg_64 ? 64 : insType & reg_hi ? 16 : insType & reg_lo ? 16 : 32;
                    
                    if(insType & reg_hi) {
                        disOp->position = DISASM_HIGHPOSITION;
                    }
                } else if(regType == (reg_n)) {
                    cls = RegClass_GeneralPurposeRegister;
                    
                    insn_t _inst = {.code =  [self readWordAt:(uint32_t)disasm->virtualAddr-(4 * (insOp.val >> 1))]};
                    _inst.packet = EXTRACT(_inst.code, PACKET_LEN, PACKET_OFF);
                    _inst.iclass = EXTRACT(_inst.code, ICLASS_LEN, ICLASS_OFF);
                    [self decodeInstruction:&_inst];
                    
                    for(int k = 0; k<2; k++) {
                        insp_t _p = _inst.parts[k];
                        for(int l = 0; l < (int)(order_size/op_size) && l < DISASM_MAX_OPERANDS; l++){
                            uint8_t op = (_p.opOrder >> l*op_size) & op_mask;
                            if(op == op_stop) {
                                break;
                            }
                            
                            if(op == op_dst || op == op_xrc) {
                                insOp.val = _p.operands[l].val;
                                break;
                            }
                        }
                    }

                    disOp->userData[OPU_MOD] |= mod_new;
                } else if(regType == (reg_p)) {
                    cls = RegClass_PredicateRegister;
                    // adjust val if reg is preset
                    
                    disOp->size = 8;
                } else if(regType == (reg_m) || regType == (reg_i)) {
                    cls = RegClass_ModifierRegister;
                } else if(regType == (reg_gp)) {
                    cls = RegClass_GPRegister;
                } else if(regType == (reg_c)) {
                    cls = RegClass_CircularRegister;
                    //differentiate
                } else if(regType == (reg_pc)) {
                    cls = RegClass_CPUState;
                }
                
                disOp->type |= DISASM_BUILD_REGISTER_MASK(cls, insOp.val);
                
                if(op == op_dst || op == op_pdst || op == op_xrc) {
                    disOp->accessMode = DISASM_ACCESS_WRITE;
                } else {
                    disOp->accessMode = DISASM_ACCESS_READ;
                }
                
                // TODO: evaluate shifting

            } else { // Immediate
                disOp->type = DISASM_OPERAND_CONSTANT_TYPE;
                uint32_t opMod = insOp.modifier;
                
                bool extend = true;
                for(int k = i; k<2; k++) { // Improvement?
                    insp_t _p = inst.parts[k];
                    for(int l = k == i ? j+1 : 0; l < (int)(order_size/op_size) && l < DISASM_MAX_OPERANDS; l++){
                        uint8_t op = (_p.opOrder >> l*op_size) & op_mask;
                        if(op == op_stop) {
                            break;
                        }
                        
                        if(op == op_imm1 || op == op_imm2) {
                            extend = false;
                            break;
                        }
                    }
                }
                
                if(extend) {
                    uint32_t lastWord = [self readWordAt:(uint32_t)disasm->virtualAddr-4];
                    if(EXTRACT(lastWord, PACKET_LEN, PACKET_OFF) != 0 && EXTRACT(lastWord, ICLASS_LEN, ICLASS_OFF) == 0) {
                        insOp.val = [self getImmFromExt:lastWord] | (0b111111 & insOp.val);
                        disOp->userData[OPU_EXT] = 1;
                    }
                }
                
                disOp->immediateValue = insOp.val << (opMod&mod_col1 ? 1 : opMod&mod_col2 ? 2 : opMod&mod_col3 ? 3 : 0);
                disOp->accessMode = DISASM_ACCESS_NONE;
                
                if(insOp.modifier & mod_branch || p.type & in_branch) {
                    disOp->isBranchDestination = true;
                    disOp->immediateValue &= ~0x3;
                    
                    uint32_t curPc = (uint32_t)disasm->virtualAddr;
                    
                    while(![self firstInPacket:curPc]) {
                        curPc -= 4;
                    }
                    
                    disasm->instruction.addressValue = curPc + disOp->immediateValue;
                    
                    while(![self firstInPacket:(uint32_t)disasm->instruction.addressValue]){
                        disasm->instruction.addressValue -= 4;
                    }
                }
            }
        }
    }
    
    return disasm->instruction.length;
}

- (BOOL)instructionHaltsExecutionFlow:(DisasmStruct *)disasm {
    return NO;
}

- (void)performBranchesAnalysis:(DisasmStruct *)disasm computingNextAddress:(Address *)next andBranches:(NSMutableArray *)branches forProcedure:(NSObject<HPProcedure> *)procedure basicBlock:(NSObject<HPBasicBlock> *)basicBlock ofSegment:(NSObject<HPSegment> *)segment calledAddresses:(NSMutableArray *)calledAddresses callsites:(NSMutableArray *)callSitesAddresses {

}

- (void)performInstructionSpecificAnalysis:(DisasmStruct *)disasm forProcedure:(NSObject<HPProcedure> *)procedure inSegment:(NSObject<HPSegment> *)segment {
}

- (void)performProcedureAnalysis:(NSObject<HPProcedure> *)procedure basicBlock:(NSObject<HPBasicBlock> *)basicBlock disasm:(DisasmStruct *)disasm {
}

- (void)updateProcedureAnalysis:(DisasmStruct *)disasm {
}

// Printing

- (NSObject<HPASMLine> *)buildMnemonicString:(DisasmStruct *)disasm inFile:(NSObject<HPDisassembledFile> *)file {
    NSObject<HPHopperServices> *services = _cpu.hopperServices;
    NSObject<HPASMLine> *line = [services blankASMLine];
    
    return line;
}

- (NSObject<HPASMLine> *)buildOperandString:(DisasmStruct *)disasm forOperandIndex:(NSUInteger)operandIndex inFile:(NSObject<HPDisassembledFile> *)file raw:(BOOL)raw {
    DisasmOperand op = disasm->operand[operandIndex];
    
    // NSLog(@"%lld, T:%lld", disasm->virtualAddr, op.type);
    
    if(op.userData[OPU_SET] == 0) {
        return nil;
    }

    NSObject<HPHopperServices> *services = _cpu.hopperServices;
    NSObject<HPASMLine> *line = [services blankASMLine];
    
    uint64_t mod = op.userData[OPU_MOD];

    if(mod&mod_negated) {
        [line appendCFString:@"!"];
    }
    
    if((op.type & DISASM_OPERAND_TYPE_MASK) == DISASM_OPERAND_CONSTANT_TYPE) {
        if(!(mod&mod_branch)) {
            [line appendCFString:@"#"];
            if(op.userData[OPU_EXT]) {
                [line appendCFString:@"#"];
            }
        }
        
        if(op.isBranchDestination) {
            [line appendHexadecimalNumber:disasm->instruction.addressValue];
        } else {
            [line appendDecimalNumber:op.immediateValue];
        }
    } else {
        uint64_t class = __builtin_ctzll(DISASM_GET_REGISTER_CLS_MASK(op.type));
        uint64_t index = __builtin_ctzll(DISASM_GET_REGISTER_INDEX_MASK(op.type));
        [line appendRegister:[_cpu registerIndexToString:index ofClass:class withBitSize:op.size position:0 andSyntaxIndex:disasm->syntaxIndex] ofClass:class andIndex:index];
    }
    
    if(mod&mod_new) {
        [line appendCFString:@".new"];
    }
    
    if(mod&mod_incrByNext) {
        [line appendCFString:@"++"];
        [line append:[self buildOperandString:disasm forOperandIndex:operandIndex+1 inFile:file raw:raw]];
        disasm->operand[operandIndex].userData[OPU_SKIP]++;
    }
    
    if(mod&mod_addImm1) {
        uint32_t (*userData)[] = (uint32_t (*)[])disasm->instruction.userData;
        uint32_t curOpOrder = (*userData)[IUD_ORD1+op.userData[OPU_PART]];
        
        for(int i = (int)op.userData[OPU_ID]; i < (int)(order_size/op_size) && i < DISASM_MAX_OPERANDS; i++){
            uint8_t opTyp = (curOpOrder >> i*op_size) & op_mask;
            if(opTyp == op_stop) {
                break;
            }
            
            if(opTyp == op_imm1) {
                [line appendCFString:@"+"];
                uint64_t imm1Index = (i-op.userData[OPU_ID])+operandIndex;
                [line append:[self buildOperandString:disasm forOperandIndex:imm1Index inFile:file raw:raw]];
                disasm->operand[imm1Index].userData[OPU_SKIP]++;
                break;
            }
        }
    }
    
    
    return line;
}

- (NSObject<HPASMLine> *)buildCompleteOperandString:(DisasmStruct *)disasm inFile:(NSObject<HPDisassembledFile> *)file raw:(BOOL)raw {
    NSObject<HPHopperServices> *services = _cpu.hopperServices;
    NSObject<HPASMLine> *line = [services blankASMLine];
    
    NSString *mnemonic = @(disasm->instruction.mnemonic);
    NSString *uncondMne = @(disasm->instruction.unconditionalMnemonic);
    bool mneEmpty = [mnemonic isEqualToString:@""];
    bool umneEmpty = [uncondMne isEqualToString:@""];
    
    uint32_t (*userData)[] = (uint32_t (*)[])disasm->instruction.userData;
    if((*userData)[IUD_HIP] == HIP_PKG_START) {
        [line appendMnemonic:@"{"];
    }
    [line appendSpacesUntil:4];
    
    uint32_t partID = 0;
    uint8_t opIndex = 0;
    
    if((*userData)[IUD_TYP1] & in_condition) {
        bool comp = ((*userData)[IUD_ORD1+partID] & op_mask) == op_pdst;
        if(comp) {
            [line append:[self buildOperandString:disasm forOperandIndex:opIndex++ inFile:file raw:false]];
            [line appendCFString:@" = "];
        } else {
            [line appendCFString:@"if("];
        }
        
        if(!mneEmpty) {
            if((*userData)[IUD_TYP1] & in_negated) [line appendCFString:@"!"];
            
            [line appendMnemonic:mnemonic];
            [line appendCFString:@"("];
            [line append:[self buildOperandString:disasm forOperandIndex:opIndex++ inFile:file raw:false]];
            [line appendCFString:@","];
            [line append:[self buildOperandString:disasm forOperandIndex:opIndex++ inFile:file raw:false]];
            [line appendCFString:@")"];
        } else {
            [line append:[self buildOperandString:disasm forOperandIndex:opIndex++ inFile:file raw:false]];
            
            if((*userData)[IUD_ORD1+partID] > op_mask) {
                if(disasm->instruction.condition) {
                    switch(disasm->instruction.condition) {
                        case DISASM_INST_COND_GT: [line appendCFString:@">"]; break;
                        case DISASM_INST_COND_GE: [line appendCFString:@">="]; break;
                        case DISASM_INST_COND_LT: [line appendCFString:@"<"]; break;
                        case DISASM_INST_COND_LE: [line appendCFString:@"<="]; break;
                        case DISASM_INST_COND_EQ: [line appendCFString:@"=="]; break;
                        case DISASM_INST_COND_NE: [line appendCFString:@"!="]; break;
                        default: break;
                    }
                } else if (disasm->instruction.branchType){
                    switch(disasm->instruction.branchType) {
                        case DISASM_BRANCH_JG: [line appendCFString:@">"]; break;
                        case DISASM_BRANCH_JGE: [line appendCFString:@">="]; break;
                        case DISASM_BRANCH_JL: [line appendCFString:@"<"]; break;
                        case DISASM_BRANCH_JLE: [line appendCFString:@"<="]; break;
                        case DISASM_BRANCH_JE: [line appendCFString:@"=="]; break;
                        case DISASM_BRANCH_JNE: [line appendCFString:@"!="]; break;
                        default: break;
                    }
                }
                
                [line append:[self buildOperandString:disasm forOperandIndex:opIndex++ inFile:file raw:false]];
            }
        }
        
        if(comp) {
            [line appendCFString:@"; if("];
            [line append:[self buildOperandString:disasm forOperandIndex:opIndex++ inFile:file raw:false]];
        }
        
        [line appendCFString:@") "];
        partID = 1;
    }
    
    uint32_t curOpOrder = (*userData)[IUD_ORD1+partID];
    uint32_t curTyp = (*userData)[IUD_TYP1+partID];
    uint32_t firstOp = curOpOrder & op_mask;

    if(firstOp == op_dst || firstOp == op_pdst || firstOp == op_cdst || firstOp == op_xrc) {
        NSObject<HPASMLine> *part = [self buildOperandString:disasm forOperandIndex:opIndex++ inFile:file raw:false];
        if(part != NULL) {
            [line append:part];
            [line appendCFString:@" "];
            
            if(curTyp & in_as_sub) [line appendCFString:@"-"];
            else if(curTyp & in_as_add) [line appendCFString:@"+"];
            else if(curTyp & in_as_and) [line appendCFString:@"&"];
            else if(curTyp & in_as_or) [line appendCFString:@"|"];
            else if(curTyp & in_as_xor) [line appendCFString:@"^"];
            
            [line appendCFString:@"= "];
        }
    }
    
    if(!umneEmpty) {
        [line appendMnemonic:uncondMne];
        if(!((*userData)[IUD_TYP1+partID] & (in_branch|in_nop))) [line appendCFString:@"("];
        else if(!((*userData)[IUD_TYP1+partID] & in_nop)) [line appendCFString:@" "];
    }
    
    int source = -1;
    
    // NSLog(@"%lld, O:%d", disasm->virtualAddr, curOpOrder);
    for (int i=opIndex; i<=DISASM_MAX_OPERANDS; i++) {
        DisasmOperand disOp = disasm->operand[i];
        if(disOp.userData[OPU_SKIP]) continue;
        
        if(disOp.userData[OPU_MOD]&mod_source) {
            source = i;
            break;
        }
        
        NSObject<HPASMLine> *part = [self buildOperandString:disasm forOperandIndex:i inFile:file raw:raw];
        if (part == nil) break;
        
        if (i>opIndex) [line appendRawString:@", "];
        
        [line append:part];
        
        i += disasm->operand[i].userData[OPU_SKIP];
    }
    
    if(!((*userData)[IUD_TYP1+partID] & (in_branch|in_as_only|in_nop))) [line appendCFString:@")"];

    
    if(source != -1) {
        [line appendCFString:@" = "];
        [line append:[self buildOperandString:disasm forOperandIndex:source inFile:file raw:raw]];

    }
    
    if((*userData)[IUD_HIP] == HIP_PKG_END || (*userData)[IUD_HIP] == HIP_DUPLEX) {
        [line appendSpaces:3];
        [line appendCFString:@"}"];
    }
    
    return line;
}

// Decompiler

- (BOOL)canDecompileProcedure:(NSObject<HPProcedure> *)procedure {
    return NO;
}

- (Address)skipHeader:(NSObject<HPBasicBlock> *)basicBlock ofProcedure:(NSObject<HPProcedure> *)procedure {
    return basicBlock.from;
}

- (Address)skipFooter:(NSObject<HPBasicBlock> *)basicBlock ofProcedure:(NSObject<HPProcedure> *)procedure {
    return basicBlock.to;
}

- (ASTNode *)rawDecodeArgumentIndex:(int)argIndex
                           ofDisasm:(DisasmStruct *)disasm
                  ignoringWriteMode:(BOOL)ignoreWrite
                    usingDecompiler:(Decompiler *)decompiler {
    return nil;
}

- (ASTNode *)decompileInstructionAtAddress:(Address)a
                                    disasm:(DisasmStruct *)d
                                 addNode_p:(BOOL *)addNode_p
                           usingDecompiler:(Decompiler *)decompiler {
    return nil;
}

// Assembler

- (NSData *)assembleRawInstruction:(NSString *)instr atAddress:(Address)addr forFile:(NSObject<HPDisassembledFile> *)file withCPUMode:(uint8_t)cpuMode usingSyntaxVariant:(NSUInteger)syntax error:(NSError **)error {
    return nil;
}

- (BOOL)instructionCanBeUsedToExtractDirectMemoryReferences:(DisasmStruct *)disasmStruct {
    return YES;
}

- (BOOL)instructionOnlyLoadsAddress:(DisasmStruct *)disasmStruct {
    return strcmp(disasmStruct->instruction.mnemonic, "lea") == 0;
}

- (BOOL)instructionMayBeASwitchStatement:(DisasmStruct *)disasmStruct {
    return NO;
}

@end
