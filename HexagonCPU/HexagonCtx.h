//
//  HexagonCtx.h
//  HexagonCPU
//
//  Created by Tom Burmeister on 02.06.17.
//  Copyright © 2017 Tom Burmeister. All rights reserved.
//

#ifndef HexagonCtx_h
#define HexagonCtx_h


#endif /* HexagonCtx_h */

#import <Foundation/Foundation.h>
#import <Hopper/Hopper.h>

#define NO_OPCODE 0xffffffff
#define UNDEFINED (uint8_t)~0

#define PACKET_LEN 2
#define PACKET_OFF 14

#define DUPLEX_ICLASS_UPPER_LEN 3
#define DUPLEX_ICLASS_UPPER_OFF 29
#define DUPLEX_ICLASS_LOWER_LEN 1
#define DUPLEX_ICLASS_LOWER_OFF 13
#define DUPLEX_INST_LEN 13
#define DUPLEX_LOW_INST_OFF 0
#define DUPLEX_HIGH_INST_OFF 16

#define ICLASS_LEN 4
#define ICLASS_OFF 28

typedef NS_ENUM(NSUInteger, HexagonIClass) {
    HI_ConstantExtender,
    HI_Jump,
    HI_Jump_2,
    HI_LoadStore,
    HI_LoadStoreConditional,
    HI_Jump_3,
    HI_Control,
    HI_Alu32,
    HI_XType,
    HI_Load,
    HI_Store,
    HI_Alu32_2,
    HI_XType_2,
    HI_XType_3,
    HI_XType_4,
    HI_Alu32_3,
    HI_COUNT,
};

typedef NS_ENUM(uint8_t, HexagonDuplexIClass) {
    HID_L1,
    HID_L2,
    HID_A,
    HID_S1,
    HID_S2,
    HID_Reserved,
};

typedef NS_ENUM(uint8_t, HexagonRegisterSize) {
    HRS_32,
    HRS_64,
    HRS_16H,
    HRS_16L,
};

typedef NS_ENUM(uint8_t, HexagonOperandMod) {
    HOM_NONE,
    HOM_COMPLEMENT,
    HOM_NEW,
};


typedef NS_ENUM(uint8_t, HexagonInstructionPosition) {
    HIP_NONE,
    HIP_PKG_START,
    HIP_PKG_END,
    HIP_DUPLEX
};


/*
 *  Operand Type
 */

#define immediate 0
// immediate types
#define imm_u (1 << 1) | immediate
#define imm_s (2 << 1) | immediate
#define imm_m (3 << 1) | immediate
#define imm_r (4 << 1) | immediate

#define regi 1
//register types
#define r_to 1
#define r_tl 3
#define reg_r   (0b000 << r_to) | regi
#define reg_p   (0b001 << r_to) | regi
#define reg_n   (0b010 << r_to) | regi
#define reg_pc  (0b011 << r_to) | regi
#define reg_c   (0b100 << r_to) | regi
#define reg_gp  (0b101 << r_to) | regi
#define reg_m   (0b110 << r_to) | regi
#define reg_i   (0b111 << r_to) | regi
// r register info
#define r_io (r_to+r_tl)
#define r_il 3
#define reg_d (0 << r_io)
#define reg_s (1 << r_io)
#define reg_t (2 << r_io)
#define reg_x (3 << r_io)
#define reg_u (4 << r_io)
// p register info
#define reg_0 (0 << r_io)
#define reg_1 (1 << r_io)
#define reg_2 (2 << r_io)
#define reg_3 (3 << r_io)
// register size
#define r_so (r_io+r_il)
#define r_sl 2
#define reg_32 (0 << r_so)
#define reg_hi (1 << r_so)
#define reg_lo (2 << r_so)
#define reg_64 (3 << r_so)

/*
 *  Operand Modifier
 */
#define mod_complement  (1 << 0)    // ~R0
#define mod_new         (1 << 1)    // Nt.new
#define mod_branch      (1 << 2)
#define mod_negated     (1 << 3)    // !R1
#define mod_col1        (1 << 4)    // #u6:1
#define mod_col2        (1 << 5)    // #u6:2
#define mod_col3        (1 << 6)    // #u6:3
#define mod_shiftByImm1 (1 << 7)    // R0<<#u6
#define mod_target      (1 << 8)
#define mod_source      mod_target
#define mod_addImm1     (1 << 9)    // R0+#u6
#define mod_asterisk    (1 << 10)   // Rt*
#define mod_circ        (1 << 11)   // Rt:circ(Mu)
#define mod_brev        (1 << 12)   // Mu:brev
#define mod_incrByNext  (1 << 13)   // Rx++#s4
#define mod_setNext     (1 << 14)   // Re=#u6
#define mod_shiftByImm2 (1 << 15)   // R0<<#U6

/*
 *  Operand Order
 */
#define op_size 5
#define op_mask (uint8_t)(__builtin_powi(2, op_size)-1)
#define order_size 32
#define op_stop     0b00000
#define op_dst      0b00001
#define op_src      0b00010
#define op_trc      0b00011
#define op_xrc      0b00100
#define op_psrc     0b00101
#define op_ptrc     0b00110
#define op_purc     0b00111
#define op_pdst     0b01000
#define op_imm1     0b01001
#define op_imm2     0b01010
#define op_comp     0b01011
#define op_csrc     0b01100
#define op_cdst     0b01101
#define op_urc      0b01110
#define op_gp       0b01111
#define op_mu       0b10000

/*
 * Instruction Type
 */
#define in_condition    (1 << 0)
#define in_branch       (1 << 1)
#define in_negated      (1 << 2)
#define in_sat          (1 << 3)
#define in_raw          (1 << 4)
#define in_rnd          (1 << 5)
#define in_as_sub       (1 << 6)
#define in_as_add       (1 << 7)
#define in_as_and       (1 << 8)
#define in_as_or        (1 << 9)
#define in_as_xor       (1 << 10)
#define in_chop         (1 << 11)
#define in_target       (1 << 12)
#define in_shiftRight1  (1 << 13)
#define in_carry        (1 << 14)
#define in_shiftBy16    (1 << 15)
#define in_deprecated   (1 << 16)
#define in_pos          (1 << 17)
#define in_neg          (1 << 18)
#define in_shiftBy1     (1 << 19)
#define in_shiftBy2     (1 << 20)
#define in_shiftBy3     (1 << 21)
#define in_shiftBy4     (1 << 22)
#define in_lo           (1 << 23)
#define in_hi           (1 << 24)
#define in_lib          (1 << 25)
#define in_minus        (1 << 26)
#define in_plus         (1 << 27)
#define in_as_only      (1 << 28)
#define in_scale        (1 << 29)
#define in_nop          (1 << 30)

/*
 *  Stuff
 */
#define OPU_SET 0
#define OPU_TYPE 1
#define OPU_MOD 2
#define OPU_PART 3
#define OPU_ID 4
#define OPU_EXT 5
#define OPU_SKIP 6

#define IUD_HIP 0
#define IUD_TYP1 1
#define IUD_TYP2 2
#define IUD_ORD1 3
#define IUD_ORD2 4
#define IUD_SKIP 5
#define IUD_SIZE IUD_SKIP+1

typedef struct OperandEncoding {
    uint16_t type;
    int32_t val;
    uint16_t modifier;
    bool composite;
} openc_t;

typedef struct InstructionPart {
    uint32_t type;
    char mnemonic[32];
    uint32_t opOrder;
    openc_t operands[6];
} insp_t;


typedef struct Instruction {
    uint32_t code;
    uint8_t iclass;
    uint8_t packet;
    HexagonInstructionPosition hip;
    insp_t parts[2];
    DisasmBranchType branch;
    DisasmCondition cond;
} insn_t;


@class HexagonCPU;

@interface HexagonCtx : NSObject<CPUContext>

- (instancetype)initWithCPU:(HexagonCPU *)cpu andFile:(NSObject<HPDisassembledFile> *)file;

@end
