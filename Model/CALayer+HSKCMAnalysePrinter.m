//
//  CALayer+HSKCMAnalyseSectorPrinter.m
//  CardManage
//
//  Created by Sam on 2018/5/10.
//  Copyright © 2018 Carl. All rights reserved.
//

#import "CALayer+HSKCMAnalysePrinter.h"
static NSInteger timeBuff  = 0;
@implementation CALayer (HSKCMAnalysePrinter)

- (void)print:(NSArray <id<HSKCMAnalyseCreateContextProtocol>>*)subLayerContextModels;
{
    __block NSInteger priority = 1000;
    __block CGFloat after = 0;
    NSMutableArray *buff = @[].mutableCopy;
    [subLayerContextModels enumerateObjectsUsingBlock:^(id<HSKCMAnalyseCreateContextProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <id <HSKCMAnalyseContextProtocol>>* contexts = [obj perpareContext];
        [buff addObjectsFromArray:contexts];
    }];
    buff =
    [buff sortedArrayUsingComparator:^NSComparisonResult(id <HSKCMAnalyseContextProtocol> obj1, id <HSKCMAnalyseContextProtocol> obj2) {
        return obj2.layerPriority - obj1.layerPriority;
    }].mutableCopy;
    [buff enumerateObjectsUsingBlock:^(id<HSKCMAnalyseContextProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.layerPriority < priority)
        {
            priority = obj.layerPriority;
            after   += obj.afterHigherPriority;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addSublayer:obj.layer];
            if (obj.animation)  [obj.layer addAnimation:obj.animation forKey:[NSString stringWithFormat:@"%p",obj]];
        });
    }];
    timeBuff = after;
}


@end
