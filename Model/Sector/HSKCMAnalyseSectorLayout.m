//
//  HSKCMAnalyseSectorLayout.m
//  CardManage
//
//  Created by Sam on 2018/5/10.
//  Copyright © 2018 Carl. All rights reserved.
//

#import "HSKCMAnalyseSectorLayout.h"
#import "HSKCMAnalyseSectorContextModel.h"
typedef NSArray <HSKCMAnalyseAnagleContextModel *>*  HSKCMPAS;
typedef NSArray <HSKCMAnalyseDescContextModel *> *   HSKCMPDS;
@interface HSKCMAnalyseSectorLayout()
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) BOOL    clockwise;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGRect  printRect;
@end
@implementation HSKCMAnalyseSectorLayout

- (instancetype)initWithStartAngle:(CGFloat)startAngle
                       centerPoint:(CGPoint)center
                            radius:(CGFloat)radius
                         clockwise:(BOOL)clockwise
                         lineWidth:(CGFloat)width
                         printRect:(CGRect)rect
{
    if (self = [super init])
    {
        self.startAngle = startAngle;
        self.center     = center;
        self.radius     = radius;
        self.clockwise  = clockwise;
        self.lineWidth  = width;
        self.printRect  = rect;
    }
    return self;
}
- (NSArray *)layoutSectorWithOriginalData:(NSArray <HSKCMAnalyseAngleModel *> *)data;
{
    NSAssert([data isKindOfClass:[NSArray class]], @"data must be array");
    NSArray <HSKCMAnalyseAnagleContextModel *> * as =
    [[data.rac_sequence map:^id(HSKCMAnalyseAngleModel *value) {
        HSKCMAnalyseAnagleContextModel *m = [HSKCMAnalyseAnagleContextModel new];
        m.color         = value.color;
        m.originalValue = value.money.doubleValue;
        m.desc          = value.typeDesc;

        m.clockwise     = self.clockwise;
        m.lineWidth     = self.lineWidth;
        m.center        = self.center;
        m.startAngle    = self.startAngle;
        m.radius        = self.radius;
        return m;
    }] array];
    
    
    as =
    [as sortedArrayUsingComparator:^NSComparisonResult(HSKCMAnalyseAnagleContextModel *obj1, HSKCMAnalyseAnagleContextModel *obj2) {
        return obj1.originalValue - obj2.originalValue;
    }];
    
    as = [self analyseProportion:as];
    HSKCMPDS ls = [self caculateLine:as];
    
    return @[as, ls];
}





- (HSKCMPAS)analyseProportion:(HSKCMPAS)data
{
    __block CGFloat sum = 0;
    [data enumerateObjectsUsingBlock:^(HSKCMAnalyseAnagleContextModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        sum += obj.originalValue;
    }];
    
    __block CGFloat ProportionBuff = 0;
    __block NSInteger endProportionindex = 0;
    CGFloat minimumProportion = 1/12.0;
    
    [data enumerateObjectsUsingBlock:^(HSKCMAnalyseAnagleContextModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat proportion = obj.originalValue / sum;
        if (proportion  < minimumProportion)
        {
            ProportionBuff += proportion - minimumProportion;
            proportion = minimumProportion;
        }
        else
        {
            if(endProportionindex == 0) endProportionindex = idx;
        }
        if (endProportionindex == 0)
        {
            obj.reallyAngle = self.mutipi(proportion);
        }
        else
        {
            CGFloat result =  proportion + (ProportionBuff/(data.count - endProportionindex));
            if (result  > minimumProportion)
            {
                proportion = result;
            }
            else
            {
                endProportionindex += 1;
            }
            obj.reallyAngle = self.mutipi(proportion);
        }
    }];
    NSMutableArray *arr = data.mutableCopy;
    if (data.count == 5) // 12345
    {
        // 14325
        [arr exchangeObjectAtIndex:1 withObjectAtIndex:3];
        // 14235
        [arr exchangeObjectAtIndex:2 withObjectAtIndex:3];
        // 14253
        [arr exchangeObjectAtIndex:3 withObjectAtIndex:4];
    }
    else if (data.count == 4) // 1234
    {
        [arr exchangeObjectAtIndex:1 withObjectAtIndex:2];
    }
    
    __block CGFloat sumReallyAngle = 0;
    [arr enumerateObjectsUsingBlock:^(HSKCMAnalyseAnagleContextModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.printAngle = obj.reallyAngle + sumReallyAngle;
        sumReallyAngle += obj.reallyAngle;
    }];
    
    NSMutableArray *_ = @[].mutableCopy;
    [arr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_ addObject:obj];
    }];
    return _.copy;
}


- (HSKCMPDS)caculateLine:(HSKCMPAS)data
{
    __block HSKCMAnalyseAnagleContextModel *lastAngle = nil;
    __block HSKCMAnalyseDescContextModel   *lastDesc  = nil;
    CGSize safeSize = CGSizeMake(self.printRect.size.width - 40,
                                self.printRect.size.height - 20);
    
    NSInteger radius = self.radius + self.lineWidth / 2 + 0;
    NSMutableArray *arr = @[].mutableCopy;
    
    [data enumerateObjectsWithOptions:NSEnumerationReverse  usingBlock:^(HSKCMAnalyseAnagleContextModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HSKCMAnalyseDescContextModel *desc = [[HSKCMAnalyseDescContextModel alloc] init];
        desc.color = obj.color;
        desc.desc  = obj.desc;
        desc.originalValue = obj.originalValue;
        CGFloat centerAngle = self.startAngle + lastAngle.printAngle + (obj.printAngle - lastAngle.printAngle) / 2;
        CGPoint startPoint = CGPointMake(radius * cos(centerAngle), radius * sin(centerAngle + M_PI));
        CGPoint inflectionPoint;
        NSInteger turnRight = cos(centerAngle) > 0 ? 1 : -1;
        NSInteger turnUp = sin(centerAngle) > 0 ? -1 : 1;
        if (ABS(sin(centerAngle)) > sin(70) && sin(centerAngle) != 1) // 画折线
        {
            inflectionPoint = CGPointMake(startPoint.x + 15 * turnRight, startPoint.y + 15 * turnUp);
        }
        else // 画直线
        {
            inflectionPoint = CGPointMake(startPoint.x + 30 * turnRight, startPoint.y);
        }
        
        CGPoint endPoint = CGPointMake(turnRight * safeSize.width/2 - turnRight * 5, inflectionPoint.y);
        desc.startPoint = startPoint;
        desc.inflectionPoint = inflectionPoint;
        desc.endPoint = endPoint;
        [arr addObject:desc];
        lastDesc = desc;
        lastAngle = obj;
    }];
    // 转换坐标
    [arr enumerateObjectsUsingBlock:^(HSKCMAnalyseDescContextModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.startPoint = CGPointMake(obj.startPoint.x + self.center.x,  self.center.y - obj.startPoint.y);
        obj.inflectionPoint = CGPointMake(obj.inflectionPoint.x + self.center.x, self.center.y - obj.inflectionPoint.y);
        obj.endPoint = CGPointMake(obj.endPoint.x + self.center.x, self.center.y - obj.endPoint.y);
    }];
    return arr;
}




- (CGFloat(^)(CGFloat))mutipi
{
    return ^CGFloat (CGFloat value) {
        return 2 * M_PI *value;
    };
}



@end
