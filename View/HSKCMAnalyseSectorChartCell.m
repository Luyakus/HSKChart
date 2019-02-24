//
//  HSKCMAnalyseSectorChartCell.m
//  CardManage
//
//  Created by Sam on 2018/5/2.
//  Copyright © 2018 Carl. All rights reserved.
//

#import "HSKCMAnalyseSectorChartCell.h"
#import "HSKCMAnalyseSectorLayout.h"
#import "CALayer+HSKCMAnalysePrinter.h"
#import "HSKCMAnalyseSectorContextModel.h"
@interface HSKCMAnalyseSectorChartCell()
@property (weak, nonatomic) IBOutlet UIView *sectorHolder;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *billDuration;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleHeight;
@property (nonatomic, weak) IBOutlet UIView *titleView;
@property (nonatomic, strong) HSKCMAnalyseSectorLayout *layout;

@property (nonatomic, weak) CALayer *printLayer;
@end
@implementation HSKCMAnalyseSectorChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCell:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) return;
    NSString *analyseDesc = [data safeObjectForKey:@"analyseDesc"];
    NSString *sumMoney    = [data safeObjectForKey:@"consumeCost"];
    NSString *yearMonth   = [data safeObjectForKey:@"date"];
    NSString *billDuration  = [data safeObjectForKey:@"billDuration"];
    self.title.text        = analyseDesc;
    self.billDuration.text = billDuration;
    
    NSString *month = @"0";
    if (yearMonth.length >= 6)
    {
        month = @([yearMonth substringWithRange:NSMakeRange(4, 2)].integerValue).stringValue;
    }
    NSArray *sectors      = [data safeObjectForKey:@"sector"];
    CGRect printRect = CGRectMake(0, 0, [UIScreen width], 260);
    CGPoint center = CGPointMake([UIScreen width] / 2, 130);
    CALayer *l = nil;
    if (sectors.count > 0)
    {
        l = [CALayer layer];
        l.backgroundColor = [UIColor whiteColor].CGColor;
        l.frame = printRect;
    }
    else if (sectors.count == 0 && analyseDesc.length > 0)
    {
        l = [self errorLayerAt:center month:month];
    }
    else  if (sectors.count == 0 && analyseDesc.length == 0) // 空视图
    {
        l = [self emptyLayerat:center];
    }
    
    self.titleView.alpha = self.titleHeight.constant = analyseDesc.length == 0 ? 0 : 45;
    [self.sectorHolder.layer addSublayer:l];
    self.printLayer = l;
    if (!self.layout)
    {
        self.layout = [[HSKCMAnalyseSectorLayout alloc] initWithStartAngle:M_PI / 2 * 3
                                                               centerPoint:center
                                                                    radius:67
                                                                 clockwise:YES
                                                                 lineWidth:30
                                                                 printRect:printRect];
    }
    if (sectors.count > 0)
    {
        NSArray *arr = [self.layout layoutSectorWithOriginalData:sectors];
        NSMutableArray *_ = @[].mutableCopy;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_ addObjectsFromArray:obj];
        }];
        HSKCMAnalyseSumContextModel *sumContext = [HSKCMAnalyseSumContextModel  new];
        sumContext.center = center;
        sumContext.month = month;
        sumContext.sumMoney = sumMoney;
        [_ addObject:sumContext];
        [RACScheduler mainThreadScheduler];
        [self.printLayer print:_];
    }
}

- (IBAction)btnClick:(UIButton *)sender
{
    [self.cellItemClickSignal sendNext:@1];
}

- (CALayer *) emptyLayerat:(CGPoint)center
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, [UIScreen width], 260);
    CAShapeLayer *l = [CAShapeLayer layer];
    l.lineCap = kCALineCapButt;
    l.strokeColor = UIColorFromRGB(0xedeff8).CGColor;
    l.fillColor = nil;
    l.lineWidth = 30;
    UIBezierPath *b = [UIBezierPath bezierPath];
    [b addArcWithCenter:center radius:67 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    l.path = b.CGPath;
    
    CATextLayer *text = [CATextLayer layer];
    text.foregroundColor = UIColorFromRGB(0x999999).CGColor;
    text.string = @"暂无数据";
    text.contentsScale = [UIScreen mainScreen].scale;
    text.wrapped = NO;
    text.alignmentMode = @"center";
    text.font =(__bridge CGFontRef)[UIFont systemFontOfSize:14];
    text.fontSize = 14;
    text.position = CGPointMake(center.x, center.y + 18);
    text.bounds = CGRectMake(0, 0, 100, 50);
    [layer addSublayer:text];
    [layer addSublayer:l];
    return layer;}


- (CALayer *)errorLayerAt:(CGPoint)center month:(NSString *)month
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, [UIScreen width], 260);
    CAShapeLayer *l = [CAShapeLayer layer];
    l.lineCap = kCALineCapButt;
    l.strokeColor = UIColorFromRGB(0xedeff8).CGColor;
    l.fillColor = nil;
    l.lineWidth = 30;
    UIBezierPath *b = [UIBezierPath bezierPath];
    [b addArcWithCenter:center radius:67 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    l.path = b.CGPath;
    CATextLayer *monthLayer = [CATextLayer layer];
    monthLayer.foregroundColor = UIColorFromRGB(0x999999).CGColor;
    monthLayer.string = [NSString stringWithFormat:@"%@月份消费",month];
    monthLayer.contentsScale = [UIScreen mainScreen].scale;
    monthLayer.wrapped = NO;
    monthLayer.alignmentMode = @"center";
    monthLayer.font =(__bridge CGFontRef)[UIFont systemFontOfSize:9];
    monthLayer.fontSize = 9;
    monthLayer.position = CGPointMake(center.x, center.y - 10);
    monthLayer.bounds = CGRectMake(0, 0, 100, 14);

    CATextLayer *moneyLayer = [CATextLayer layer];
    moneyLayer.foregroundColor = UIColorFromRGB(0x333333).CGColor;
    moneyLayer.string = @"0.00";
    moneyLayer.contentsScale = [UIScreen mainScreen].scale;
    moneyLayer.wrapped = NO;
    moneyLayer.alignmentMode = @"center";
    moneyLayer.font =(__bridge CGFontRef)[UIFont systemFontOfSize:15];
    moneyLayer.fontSize = 15;
    moneyLayer.position = CGPointMake(center.x, center.y + 20);
    moneyLayer.bounds = CGRectMake(0, 0, 100, 50);
    [layer addSublayer:monthLayer];
    [layer addSublayer:moneyLayer];
    [layer addSublayer:l];
    return layer;
}
@end
