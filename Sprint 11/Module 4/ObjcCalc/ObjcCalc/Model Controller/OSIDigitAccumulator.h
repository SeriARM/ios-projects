//
//  OSIDigitAccumulator.h
//  ObjcCalc
//
//  Created by Sergey Osipyan on 2/28/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSIDigitAccumulator : NSObject

@property (readonly) double value;

- (void)addDigitWithNumericValue:(NSInteger)number;
- (void)addDecimalPoint;
- (void)clear;

@end

NS_ASSUME_NONNULL_END