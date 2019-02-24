//
//  KSKCMAnalyseMonthLineLayout.m
//  CardManage
//
//  Created by Sam on 2018/5/11.
//  Copyright © 2018 Carl. All rights reserved.
//
#import "HSKCMAnalyseMonthLineContextModel.h"
#import "KSKCMAnalyseMonthLineLayout.h"
@interface KSKCMAnalyseMonthLineLayout()
@property (nonatomic, strong) NSMutableArray *brokenDots;
@property (nonatomic, strong) NSArray        *month;
@property (nonatomic, copy  ) NSString       *brokenLineColor;
@property (nonatomic, copy  ) NSString       *baseLineColor;
@property (nonatomic, strong) NSArray        *gradientColors;
@property (nonatomic, assign) CGPoint         origin;
@property (nonatomic, assign) CGFloat         height;
@property (nonatomic, assign) CGFloat         durationEveryMonth;
@end

@implementation KSKCMAnalyseMonthLineLayout
- (instancetype)initWithOrigin:(CGPoint)origin
                        height:(CGFloat)height
            durationEveryMonth:(CGFloat)duration
               brokenLineColor:(NSString *)brokenLineColor
                 baseLineColor:(NSString *)baseLineColor
                gradientColors:(NSArray *)gradientColors
{
    if (self = [super init]) {
        self.origin          = origin;
        self.baseLineColor   = baseLineColor;
        self.brokenLineColor = brokenLineColor;
        self.gradientColors  = gradientColors;
        self.height          = height;
        self.durationEveryMonth =  duration;
        self.brokenDots = @[].mutableCopy;
    }
    return self;
}
- (NSArray *)layoutMonthWithOriginalData:(NSArray <HSKCMAnalyseDotModel *> *)data
{
    [self caculateDots:data];
    NSArray *baseLines   = [self createBaseLineContexts];
    NSArray *brokenLines = [self createBrokenLineContexs];
    NSArray *gradient    = [self createGradient];
    return @[baseLines, brokenLines, gradient];
}

- (void)caculateDots:(NSArray <HSKCMAnalyseDotModel *> *)data
{
    [self.brokenDots removeAllObjects];
    self.month = [data valueForKeyPath:@"month"];
    NSArray  <HSKCMAnalyseDotModel *>*values =
    [data sortedArrayUsingComparator:^NSComparisonResult(HSKCMAnalyseDotModel *obj1, HSKCMAnalyseDotModel *obj2) {
        return obj1.money.doubleValue - obj2.money.doubleValue;
    }];
    
    CGFloat minumValue = values.firstObject.money.doubleValue;
    CGFloat maxValue   = values.lastObject.money.doubleValue;
    CGFloat minumRatio = 0.05;
    CGFloat width      = [UIScreen width] / 5;
    
    __block CGFloat lastPointX = width / 2 + self.origin.x;
    [data enumerateObjectsUsingBlock:^(HSKCMAnalyseDotModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat ratio = (obj.money.doubleValue - minumValue) / (maxValue - minumValue);
        ratio         = MAX(minumRatio, ratio > 0.7 ? (0.7 + (ratio - 0.7) / 3.5) : ratio);
        CGFloat y     = self.origin.y - ratio * self.height;
        CGPoint p     =  CGPointMake(lastPointX, y);
        lastPointX    = p.x + width;
        [self.brokenDots addObject:[NSValue valueWithCGPoint:p]];
    }];
}
- (NSArray *)createBaseLineContexts
{
    CGFloat width = [UIScreen width] / 5;
    NSMutableArray *arr = @[].mutableCopy;
    HSKCMAnalyseLineContextModel *bottom = [HSKCMAnalyseLineContextModel new];
    bottom.fromPonit  = CGPointMake(0, self.origin.y);
    CGPoint lastPoint = [self.brokenDots.lastObject CGPointValue];
    bottom.toPoint    = CGPointMake(lastPoint.x + width/2, self.origin.y);
    [arr addObject:bottom];
    
    [self.brokenDots enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint p = [obj CGPointValue];
        HSKCMAnalyseLineContextModel *v = [HSKCMAnalyseLineContextModel new];
        v.month     = [self.month safeObjectAtIndex:idx];
        v.fromPonit = CGPointMake(p.x, self.origin.y);
        v.toPoint   = CGPointMake(p.x, self.origin.y - self.height);
        v.index     = idx;
        v.duration = self.durationEveryMonth;
        [arr addObject:v];
    }];
    
    HSKCMAnalyseLineContextModel *top = [HSKCMAnalyseLineContextModel new];
    top.fromPonit = CGPointMake(self.origin.x, self.origin.y - self.height);
    top.toPoint   = CGPointMake(self.origin.x + lastPoint.x + width/2, self.origin.y - self.height);
    [arr addObject:top];
    [arr setValue:@"baseLine" forKeyPath:@"type"];
    [arr setValue:self.baseLineColor forKey:@"color"];
    return arr;
}
- (NSArray *)createBrokenLineContexs
{
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < self.brokenDots.count - 1; i ++)
    {
        HSKCMAnalyseLineContextModel *m = [HSKCMAnalyseLineContextModel new];
        CGPoint fromPoint = [self.brokenDots[i] CGPointValue];
        CGPoint toPoint   = [self.brokenDots[i + 1] CGPointValue];
        m.fromPonit       = fromPoint;
        m.toPoint         = toPoint;
        m.color           = self.brokenLineColor;
        m.index           = i;
        m.duration        = self.durationEveryMonth;
        m.type            = @"brokenLine";
        [arr addObject:m];
    }
    return arr;
}
- (NSArray *)createGradient
{
    HSKCMAnalyseGradientContextModel *g = [HSKCMAnalyseGradientContextModel new];
    g.gradientColors = self.gradientColors;
    g.originPoint = self.origin;
    g.dotPoints = self.brokenDots.copy;
    g.duration = self.durationEveryMonth;
    return @[g];
}
- (CGSize)contentSize
{
    CGPoint p = [self.brokenDots.lastObject CGPointValue];
    CGFloat width = p.x + [UIScreen width] / 10;
    CGSize size = CGSizeMake(width, self.height);
    return size;
}
- (NSArray *)dots
{
    return self.brokenDots.copy;
}
@end
