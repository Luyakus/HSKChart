//
//  HSKCMAnalyseMonthLineContextModel.m
//  CardManage
//
//  Created by Sam on 2018/5/11.
//  Copyright © 2018 Carl. All rights reserved.
//

#import "HSKCMAnalyseMonthLineContextModel.h"
#import "HSKCMAnalysePrintModel.h"
@implementation HSKCMAnalyseLineContextModel
- (NSArray<id<HSKCMAnalyseContextProtocol>> *)perpareContext
{
    HSKCMAnalysePrintModel *lineContext = [HSKCMAnalysePrintModel new];
    CAShapeLayer *line = [CAShapeLayer layer];
    line.lineJoin = kCALineJoinRound;
    line.strokeColor = [UIColor colorWithString:self.color].CGColor;
    line.lineWidth = 1;
    line.lineCap = kCALineCapButt;
    UIBezierPath *b = [UIBezierPath bezierPath];
    [b moveToPoint:self.fromPonit];
    [b addLineToPoint:self.toPoint];
    line.path = b.CGPath;
    lineContext.layer = line;
    if ([self.type isEqualToString:@"baseLine"])
    {
        lineContext.layerPriority = 1000;
        lineContext.afterHigherPriority = 0;
        
        if (self.fromPonit.y != self.toPoint.y)
        {
            HSKCMAnalysePrintModel *monthContext = [HSKCMAnalysePrintModel new];
            CATextLayer *month    = [CATextLayer layer];
            month.foregroundColor = UIColorFromRGB(0x868E9E).CGColor;
            month.string          = [NSString stringWithFormat:@"%@月",self.month];
            month.contentsScale   = [UIScreen mainScreen].scale;
            month.wrapped  = NO;
            month.font     =(__bridge CGFontRef)[UIFont systemFontOfSize:9];
            month.fontSize = 9;
            month.alignmentMode = @"center";
            month.frame    = CGRectMake(self.fromPonit.x - 20, self.fromPonit.y + 9, 40, 40);
            monthContext.layer         = month;
            CABasicAnimation *monthAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
            monthAni.fromValue         = @0;
            monthAni.toValue           = @1;
            monthAni.duration          = self.duration;
            monthContext.layerPriority = 750 - self.index;
            monthContext.afterHigherPriority = self.duration + 0.05;
            
            monthContext.animation = monthAni;
            return @[lineContext, monthContext];
        }
       
        return @[lineContext];
    }
    lineContext.layerPriority = 750 - self.index;
    lineContext.afterHigherPriority = self.duration + 0.05;
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ani.fromValue         = @0;
    ani.toValue           = @1;
    ani.duration          = self.duration;
    lineContext.animation = ani;
    return @[lineContext];
}
@end

@implementation HSKCMAnalyseGradientContextModel
- (NSArray<id<HSKCMAnalyseContextProtocol>> *)perpareContext
{
    HSKCMAnalysePrintModel *gradientContext = [HSKCMAnalysePrintModel new];
    
    CAGradientLayer *g = [CAGradientLayer layer];
    CAShapeLayer *mask = [CAShapeLayer layer];
    CGPoint fisrtDot = [self.dotPoints.firstObject CGPointValue];
    CGPoint lastDot = [self.dotPoints.lastObject CGPointValue];
    __block CGFloat highest = 0;
    [self.dotPoints enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint p = [obj CGPointValue];
        if (self.originPoint.y - p.y > highest) highest = self.originPoint.y - p.y;
    }];
    g.frame = CGRectMake(fisrtDot.x,
                         self.originPoint.y - highest,
                         lastDot.x,
                         highest);
    
    
    CGPoint reallyOrigin = g.frame.origin;
    UIBezierPath *b = [UIBezierPath bezierPath];
    [b moveToPoint:CGPointMake(fisrtDot.x - reallyOrigin.x, self.originPoint.y - reallyOrigin.y)];
    [self.dotPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint p = [obj CGPointValue];
        [b addLineToPoint:CGPointMake(p.x - reallyOrigin.x, p.y - reallyOrigin.y)];
    }];
    [b addLineToPoint:CGPointMake(lastDot.x - reallyOrigin.x, self.originPoint.y - reallyOrigin.y)];
    [b closePath];
    mask.path = b.CGPath;
    mask.fillColor = [UIColor cyanColor].CGColor;
    
    g.mask = mask;

    g.mask = mask;
    g.startPoint = CGPointMake(0.5, 0);
    g.endPoint   = CGPointMake(0.5, 1);
    g.locations  = @[@0,@1];
    g.opacity    = 0.5;
    g.colors     = @[(__bridge id)[UIColor colorWithString:self.gradientColors.firstObject].CGColor,(__bridge id)[UIColor colorWithString:self.gradientColors.lastObject].CGColor];
    gradientContext.layer = g;
    gradientContext.layerPriority = 500;
    gradientContext.afterHigherPriority =  0.1;
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"opacity"];
    ani.fromValue         = @0;
    ani.toValue           = @0.5;
    ani.duration          = 0.7;
    gradientContext.animation = ani;
    
    return @[gradientContext];
}

@end


