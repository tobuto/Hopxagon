//
//  HexagonCPU.m
//  HexagonCPU
//
//  Created by Tom Burmeister on 19.05.17.
//  Copyright © 2017 Tom Burmeister. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexagonCPU.h"
#import "HexagonCtx.h"

#define REG_NAME_ID(N, MIN, MAX) (N >= MIN && N <= MAX ? N - MIN : -1)

@implementation HexagonCPU {
    NSObject<HPHopperServices> *_services;
}

/*
 * HopperPlugin.h
 */

- (instancetype)initWithHopperServices:(NSObject<HPHopperServices> *)services {
    if (self = [super init]) {
        _services = services;
    }
    return self;
}

- (NSObject<HPHopperServices> *)hopperServices {
    return _services;
}


- (HopperUUID *)pluginUUID {
    // TODO
    return [_services UUIDWithString:@"82196d67-df5e-441f-a7b9-7d2da5e101a4"];
}

- (HopperPluginType)pluginType {
    return Plugin_CPU;
}

- (NSString *)pluginName {
    return @"Hexagon";
}

- (NSString *)pluginDescription {
    return @"Hexagon v50 support";
}

- (NSString *)pluginAuthor {
    return @"Tom Burmeister";
}

- (NSString *)pluginCopyright {
    return @"©2017 - ";
}

- (NSString *)pluginVersion {
    return @"0.0.1";
}


/*
 * CPUDefinition.h
 */

- (Class)cpuContextClass {
    return [HexagonCtx class];
}

- (NSObject<CPUContext> *)buildCPUContextForFile:(NSObject<HPDisassembledFile> *)file {
    return [[HexagonCtx alloc] initWithCPU:self andFile:file];
}

- (NSArray *)cpuFamilies {
    return @[@"hexagon"];
}


- (NSArray *)cpuSubFamiliesForFamily:(NSString *)family {
    if ([family isEqualToString:@"hexagon"]) return @[@"v5"];
    return nil;
}

- (int)addressSpaceWidthInBitsForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
    if ([family isEqualToString:@"hexagon"] && [subFamily isEqualToString:@"v5"]) return 32;
    return 0;
}

- (CPUEndianess)endianess {
    return CPUEndianess_Little;
}

- (NSUInteger)cpuModeCount {
    return 1;
}

- (NSArray<NSString *> *)cpuModeNames {
    return @[@"generic"];
}

- (NSUInteger)syntaxVariantCount {
    return 1;
}

- (NSArray<NSString *> *)syntaxVariantNames {
    return @[@"v5"];
}

- (NSString *)framePointerRegisterNameForFile:(NSObject<HPDisassembledFile> *)file {
    return @"R30";
}

- (NSUInteger)registerClassCount {
    return RegClass_Hexagon_Cnt;
}

- (NSUInteger)registerCountForClass:(RegClass)reg_class {
    switch (reg_class) {
        case RegClass_CPUState: return 2;                       // PC, USR
        case RegClass_PseudoRegisterSTACK: return 3;            // SP, FP, LR
        case RegClass_GeneralPurposeRegister: return 29;        // R0 - R28
        case RegClass_LoopRegister: return 4;                   // LC0/1 SA0/1
        case RegClass_ModifierRegister: return 2;               // M0 - 1
        case RegClass_PredicateRegister: return 4;              // P3:0
        case RegClass_GPRegister: return 2;                     // UGP, GP
        case RegClass_CircularRegister: return 2;               // CS0, CS1
        default: break;                                         // ?? UPCYCLE=2 ??
    }
    return 0;
}

- (BOOL)registerIndexIsStackPointer:(NSUInteger)reg ofClass:(RegClass)reg_class {
    return reg_class == RegClass_PseudoRegisterSTACK && reg == 29;
}

- (BOOL)registerIndexIsFrameBasePointer:(NSUInteger)reg ofClass:(RegClass)reg_class {
    return reg_class == RegClass_PseudoRegisterSTACK && reg == 30;
}

- (BOOL)registerIndexIsProgramCounter:(NSUInteger)reg {
    return reg == 31+9;
}

- (NSString *)lowercaseStringForRegister:(NSUInteger)reg ofClass:(RegClass)reg_class withSize:(NSUInteger)size{
    switch(reg_class) {
        case RegClass_CPUState:
            if (reg < 2){
                static NSString *names[] = {@"pc", @"usr"};
                return names[reg];
            }
            return [NSString stringWithFormat:@"UNKNOWN_CPUSTATE_REG<%lld>", (long long) reg];
        case RegClass_PseudoRegisterSTACK:
            if (reg < 3) {
                static NSString *names[] = {@"sp", @"fp", @"lr"};
                return names[reg];
            }
            return [NSString stringWithFormat:@"UNKNOWN_PSEUDO_STACK_REG<%lld>", (long long) reg];
        case RegClass_GeneralPurposeRegister: if(size == 64) {
            return [NSString stringWithFormat:@"r%d:%d", (int) reg+1, (int) reg];
        } else {
            return [NSString stringWithFormat:@"r%d", (int) reg];
        }
        case RegClass_LoopRegister:
            if (reg < 4) {
                static NSString *names[] = {@"lc0", @"sa0", @"lc1", @"sa1"};
                return names[reg];
            }
            return [NSString stringWithFormat:@"UNKNOWN_LOOP_REG<%lld>", (long long) reg];
        case RegClass_ModifierRegister:
            if (reg < 4){
                return [NSString stringWithFormat:@"m%d", (int) reg];
            }
            return [NSString stringWithFormat:@"UNKNOWN_MODIFIER_REG<%lld>", (long long) reg];
        case RegClass_PredicateRegister:
            if (reg < 4) {
                return [NSString stringWithFormat:@"p%d", (int) reg];
            }
            return [NSString stringWithFormat:@"UNKNOWN_PREDICATE_REG<%lld>", (long long) reg];
        case RegClass_GPRegister:
            if (reg < 2) {
                static NSString *names[] = {@"ugp", @"gp"};
                return names[reg];
            }
            return [NSString stringWithFormat:@"UNKNOWN_GP_REG<%lld>", (long long) reg];
        case RegClass_CircularRegister:
            if (reg < 4) {
                return [NSString stringWithFormat:@"cs%d", (int) reg];
            }
            return [NSString stringWithFormat:@"UNKNOWN_CIRCULAR_REG<%lld>", (long long) reg];
        default: break;
    }
    return nil;
}

- (NSString *)registerIndexToString:(NSUInteger)reg ofClass:(RegClass)reg_class withBitSize:(NSUInteger)size position:(DisasmPosition)position andSyntaxIndex:(NSUInteger)syntaxIndex {
    NSString *regName = [self lowercaseStringForRegister:reg ofClass:reg_class withSize:size];
    return regName;
}

- (NSString *)cpuRegisterStateMaskToString:(uint32_t)cpuState {
    // TODO
    return @"";
}

- (BOOL)registerHasSideEffectForIndex:(NSUInteger)reg andClass:(RegClass)reg_class {
    return NO;
}

- (NSData *)nopWithSize:(NSUInteger)size andMode:(NSUInteger)cpuMode forFile:(NSObject<HPDisassembledFile> *)file {
    // Instruction size is always a multiple of 2
    if (size % 4) return nil;
    NSMutableData *nopArray = [[NSMutableData alloc] initWithCapacity:size];
    [nopArray setLength:size];
    uint16_t *ptr = (uint16_t *)[nopArray mutableBytes];
    for (NSUInteger i=0; i<size; i+=4) {
        OSWriteBigInt32(ptr, i, 0x00cc007f);
    }
    return [NSData dataWithData:nopArray];
}

- (BOOL)canAssembleInstructionsForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
    // KeyStone?
    return NO;
}

- (BOOL)canDecompileProceduresForCPUFamily:(NSString *)family andSubFamily:(NSString *)subFamily {
    return NO;
}

@end
