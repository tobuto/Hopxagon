//
//  HexagonCPU.h
//  HexagonCPU
//
//  Created by Tom Burmeister on 19.05.17.
//  Copyright © 2017 Tom Burmeister. All rights reserved.
//

#ifndef HexagonCPU_h
#define HexagonCPU_h
#endif /* HexagonCPU_h */

#import <Foundation/Foundation.h>
#import <Hopper/Hopper.h>

typedef NS_ENUM(NSUInteger, HexagonRegClass) {
    RegClass_LoopRegister = RegClass_FirstUserClass,
    RegClass_ModifierRegister,
    RegClass_PredicateRegister,
    RegClass_GPRegister,
    RegClass_CircularRegister,
    RegClass_Hexagon_Cnt
};

@interface HexagonCPU : NSObject<CPUDefinition>

- (NSObject<HPHopperServices> *)hopperServices;

@end
