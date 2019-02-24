//
//  HSKCMAnalyseContextModel.m
//  CardManage
//
//  Created by Sam on 2018/5/10.
//  Copyright © 2018 Carl. All rights reserved.
//

#import "HSKCMAnalyseSectorContextModel.h"
#import "HSKCMAnalysePrintModel.h"
@interface HSKCMAnalyseAnagleContextModel()

@end
@implementation HSKCMAnalyseAnagleContextModel

- (NSArray< HSKCMAnalysePrintModel *> *)perpareContext
{
    CAShapeLayer *l = [CAShapeLayer layer];
    l.allowsEdgeAntialiasing = YES;
    l.fillColor     = [UIColor clearColor].CGColor;
    l.lineWidth     = self.lineWidth;
    l.strokeColor   = /*[UIColor clearColor].CGColor;*/ [UIColor colorWithString:self.color].CGColor;
    UIBezierPath *b = [UIBezierPath bezierPathWithArcCenter:self.center
                                                     radius:self.radius
                                                 startAngle:self.startAngle
                                                   endAngle:self.startAngle + self.printAngle
                                                  clockwise:self.clockwise];
    l.lineCap       = kCALineCapButt;
    l.path          = b.CGPath;
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ani.fromValue         = @0;
    ani.toValue           = @1;
    ani.duration          = 1;
    
    
    HSKCMAnalysePrintModel *context = [HSKCMAnalysePrintModel new];
    context.layerPriority   = 1000;
    context.afterHigherPriority = 0;
    context.layer           = l;
    context.animation       = ani;
    return @[context];
}
@end

@implementation HSKCMAnalyseDescContextModel
- (NSArray< HSKCMAnalysePrintModel *> *)perpareContext
{
    
    // 折线
    HSKCMAnalysePrintModel *lineContext = [HSKCMAnalysePrintModel new];
    CAShapeLayer *line = [CAShapeLayer layer];
    line.lineWidth = 1;
    line.fillColor = [UIColor clearColor].CGColor;
    line.strokeColor = [UIColor colorWithString:self.color].CGColor;
    UIBezierPath *b = [UIBezierPath bezierPath];
    [b moveToPoint:self.startPoint];
    [b addLineToPoint:self.inflectionPoint];
    [b addLineToPoint:self.endPoint];
    line.path = b.CGPath;
    
    CABasicAnimation *lineAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    lineAni.fromValue         = @0;
    lineAni.toValue           = @1;
    lineAni.duration          = 0.7;
    lineContext.layer = line;
    lineContext.layerPriority = 750;
    lineContext.afterHigherPriority = 1;
    lineContext.animation = lineAni;
    
    // 点
    HSKCMAnalysePrintModel *dotContext = [HSKCMAnalysePrintModel new];

    CALayer *dot = [CALayer layer];
    NSInteger dotRadiurs = 2;
    if (self.startPoint.x > self.endPoint.x)
    {
        dot.frame = CGRectMake(self.endPoint.x - 2 * dotRadiurs, self.endPoint.y - dotRadiurs, 2 * dotRadiurs, 2 * dotRadiurs);

    }
    else
    {
        dot.frame = CGRectMake(self.endPoint.x , self.endPoint.y - dotRadiurs, 2 * dotRadiurs, 2 * dotRadiurs);
    }
    dot.cornerRadius = dotRadiurs;
    dot.backgroundColor = [UIColor colorWithString:self.color].CGColor;
    dotContext.layerPriority = 500;
    dotContext.afterHigherPriority = 0.7;
    
    dotContext.layer = dot;
    // 钱
    HSKCMAnalysePrintModel *moneyContext = [HSKCMAnalysePrintModel new];
    NSString *str = [NSString stringWithFormat:@"%.2f",self.originalValue];
    CATextLayer *money = [self textLayerForString:str];
    if (self.startPoint.x > self.endPoint.x)
    {
        CGFloat x = self.endPoint.x;
        money.frame = CGRectMake(x + 5, self.endPoint.y - 13,
                                self.desc.length * 11, 10);
        money.alignmentMode = @"left";
    }
    else
    {
        money.frame = CGRectMake(self.endPoint.x - 7 - self.desc.length * 10 ,
                                self.endPoint.y - 13,
                                self.desc.length * 11, 10);
        money.alignmentMode = @"right";
    }
    CABasicAnimation *moneyAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    moneyAni.fromValue = @0;
    moneyAni.toValue = @1;
    moneyAni.duration = 0.7;
    moneyContext.layer = money;
    moneyContext.animation = moneyAni;
    moneyContext.layerPriority = 500;
    moneyContext.afterHigherPriority = 0.7;
    
    
    // 类型描述
    HSKCMAnalysePrintModel *descContext = [HSKCMAnalysePrintModel new];
    CATextLayer *desc = [self textLayerForString:self.desc];

    if (self.startPoint.x > self.endPoint.x)
    {
        CGFloat x = self.endPoint.x;
        CGRect frame = CGRectMake(x + 5, self.endPoint.y + 2,
                                  str.length * 11, 10);
        desc.frame = frame;
        desc.alignmentMode = @"left";
    }
    else
    {
        
        desc.frame = CGRectMake(self.endPoint.x - 5 - str.length * 10 + 2,
                                 self.endPoint.y + 2,
                                 str.length * 10, 10);
        desc.alignmentMode = @"right";
    }
    CABasicAnimation *descAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    descAni.fromValue = @0;
    descAni.toValue = @1;
    descAni.duration = 0.7;
    descContext.layer = desc;
    descContext.animation = descAni;
    descContext.layerPriority = 500;
    descContext.afterHigherPriority = 0.7;
    
    return @[lineContext, dotContext, descContext, moneyContext];
}

- (CATextLayer *)textLayerForString:(NSString *)text
{
    CATextLayer *l = [CATextLayer layer];
    l.foregroundColor = UIColorFromRGB(0x868E9E).CGColor;
    l.string = text;
    l.contentsScale = [UIScreen mainScreen].scale;
    l.wrapped = NO;
    l.font =(__bridge CGFontRef)[UIFont systemFontOfSize:9];
    l.fontSize = 9;
    return l;
}
@end
@implementation HSKCMAnalyseSumContextModel
- (NSArray< HSKCMAnalysePrintModel *> *)perpareContext
{
    HSKCMAnalysePrintModel *sumContext = [HSKCMAnalysePrintModel new];
    CALayer *l = [CALayer layer];
    l.backgroundColor = [UIColor clearColor].CGColor;
    l.position = self.center;
    l.bounds = CGRectMake(0, 0, 100, 100);
    l.cornerRadius = 50;
    l.masksToBounds = YES;
    CATextLayer *monthLayer = [self textLayerForString:[NSString stringWithFormat:@"%@月累计消费", self.month] fontSize:9 textColor:@"#999999"];
    monthLayer.frame = CGRectMake(0, 30, 100, 14);
    [l addSublayer:monthLayer];
    
    CATextLayer *moneyLayer = [self textLayerForString:self.sumMoney fontSize:15 textColor:@"#333333"];
    for (int i = 0; i < 501; i ++)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1.7 / 500.0) * i * NSEC_PER_SEC) + 0.1), dispatch_get_main_queue(), ^{
            moneyLayer.string = [NSString stringWithFormat:@"%.2f", (self.sumMoney.doubleValue * i / 500)];
        });
    }
    moneyLayer.frame = CGRectMake(0, 45, 100, 50);
    [l addSublayer:moneyLayer];
    sumContext.layer = l;
    sumContext.layerPriority = 1000;
    sumContext.afterHigherPriority = 0.7;
    return @[sumContext];
}

- (CATextLayer *)textLayerForString:(NSString *)text fontSize:(NSInteger)size textColor:(NSString *)textColor
{
    CATextLayer *l = [CATextLayer layer];
    l.foregroundColor =  [UIColor colorWithString:textColor].CGColor;
    l.string = text;
    l.contentsScale = [UIScreen mainScreen].scale;
    l.wrapped = YES;
    l.alignmentMode = @"center";
    l.font =(__bridge CGFontRef)[UIFont systemFontOfSize:9];
    l.fontSize = size;
    return l;
}
@end

