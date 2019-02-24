//
//  HSKCMAnalyseLineChartCell.m
//  CardManage
//
//  Created by Sam on 2018/5/2.
//  Copyright © 2018 Carl. All rights reserved.
//
#import "HSKCMAnalysePageModel.h"
#import "HSKCMAnalyseLineChartCell.h"
#import "KSKCMAnalyseMonthLineLayout.h"
#import "CALayer+HSKCMAnalysePrinter.h"
#import "HSKCMAnalysePrintModel.h"
@interface HSKCMAnalyseDotLabelView : UIView
@property (nonatomic, copy) void(^labelClick)(NSInteger index);
@property (nonatomic, assign) BOOL   selected;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) UIView  *dot;
@property (nonatomic, weak) UILabel *content;
- (instancetype)initWithContent:(NSString *)str atIndex:(NSInteger)index anchorPoint:(CGPoint)anchorPoint;
@end
@implementation HSKCMAnalyseDotLabelView
- (instancetype)initWithContent:(NSString *)str atIndex:(NSInteger)index anchorPoint:(CGPoint)anchorPoint
{
    if (self = [super initWithFrame:CGRectZero])
    {
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:10] boundSize:CGSizeMake(CGFLOAT_MAX, 11)];
        CGRect rect = CGRectMake(anchorPoint.x - size.width / 2, anchorPoint.y - 20, size.width, 20);
        self.frame  = rect;
        UILabel *l  = [UILabel new];
        l.font      = [UIFont systemFontOfSize:9];
        l.text      = str;
        l.textColor = UIColorFromRGB(0xf1bcbc); //[HSKUIManager colorFor:HSKColorPrimary];
        [self addSubview:l];
        self.content = l;
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(size.height);
        }];
        
        UIView *dot = [UIView new];
        dot.backgroundColor = [UIColor whiteColor];
        dot.cornerRadius = 3.5;
        dot.borderColor = UIColorFromRGB(0xF56B5C); //[HSKUIManager colorFor:HSKColorPrimary];
        dot.borderWidth = 1;
        [self addSubview:dot];
        self.dot = dot;
        [dot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(3.5);
            make.size.mas_equalTo(CGSizeMake(7, 7));
            make.centerX.equalTo(self.mas_centerX);
        }];
        self.index = index;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self);
        }];
        @weakify(self)
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if (self.labelClick) self.labelClick(index);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected
{
    if (selected)
    {
        self.content.textColor = UIColorFromRGB(0xF56B5C); //[HSKUIManager colorFor:HSKColorPrimary];
        self.dot.backgroundColor = UIColorFromRGB(0xF56B5C); // [HSKUIManager colorFor:HSKColorPrimary];
    }
    else
    {
        self.content.textColor = UIColorFromRGB(0x999999);
        self.dot.backgroundColor = [UIColor whiteColor];
    }
    _selected = selected;
}
@end


@interface HSKCMAnalyseLineChartCell()
@property (weak, nonatomic) IBOutlet UIScrollView *lineChartHolder;
@property (weak, nonatomic) IBOutlet UILabel *updateDesc;
@property (nonatomic, strong) KSKCMAnalyseMonthLineLayout *layout;
@property (nonatomic, strong) NSMutableArray <HSKCMAnalyseDotLabelView *> *dotLabels;
@end
@implementation HSKCMAnalyseLineChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dotLabels = @[].mutableCopy;
    self.lineChartHolder.showsHorizontalScrollIndicator = NO;
    self.lineChartHolder.showsVerticalScrollIndicator = NO;
}

- (void)updateCell:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) return;
    NSString *updateTime = [data safeObjectForKey:@"updateTime"];
    NSArray <HSKCMAnalyseDotModel *> *dots = [data safeObjectForKey:@"line"];
    self.updateDesc.text = updateTime;
    if (!self.layout)
    {
        CGPoint origin = CGPointMake(0, 200 - 30);
        self.layout = [[KSKCMAnalyseMonthLineLayout alloc] initWithOrigin:origin
                                                                   height:160
                                                       durationEveryMonth:0.15
                                                          brokenLineColor:@"#f56b5c"
                                                            baseLineColor:@"#f0f0f0"
                                                           gradientColors:@[@"#f1bcbc",@"#ffffff"]];
    }
    [self.lineChartHolder removeAllSubviews];
    [self.dotLabels removeAllObjects];
    self.lineChartHolder.contentOffset = CGPointMake(0, 0);
    NSArray *arr = [self.layout layoutMonthWithOriginalData:dots];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.layout.contentSize.width, 200)];
    v.backgroundColor = [UIColor colorWithHex:0xffffff];
    self.lineChartHolder.contentSize = CGSizeMake(self.layout.contentSize.width, 200);
    [self.lineChartHolder addSubview:v];
    
    NSMutableArray *_ = @[].mutableCopy;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_ addObjectsFromArray:obj];
    }];
    
    [v.layer print:_];
    CGPoint lastPoint = [self.layout.dots.lastObject  CGPointValue];
    [v.layer addSublayer:[self dashLineFrom:lastPoint endPoint:CGPointMake(self.layout.contentSize.width,lastPoint.y)]];
    
    @weakify(self)
    [self.layout.dots enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self)
        HSKCMAnalyseDotModel *m = [dots safeObjectAtIndex:idx];
        HSKCMAnalyseDotLabelView *lab = [[HSKCMAnalyseDotLabelView alloc] initWithContent:m.money?:@"0" atIndex:idx anchorPoint:[obj CGPointValue]];
        lab.selected = idx == self.layout.dots.count - 1;
        @weakify(self)
        [lab setLabelClick:^(NSInteger index) {
            @strongify(self)
            [self.dotLabels enumerateObjectsUsingBlock:^(HSKCMAnalyseDotLabelView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.selected = obj.index == index;
            }];
        }];
        
        lab.transform = CGAffineTransformScale(lab.transform, 0.1, 0.1);
        [self.dotLabels addObject:lab];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC * idx)), dispatch_get_main_queue(), ^{
            [self.lineChartHolder addSubview:lab];
            [UIView animateWithDuration:0.5 animations:^{
                lab.transform = CGAffineTransformScale(lab.transform, 10, 10);
            }];
        });
    }];
    
    [UIView animateWithDuration:self.layout.dots.count * 0.2 animations:^{
        self.lineChartHolder.contentOffset = CGPointMake(MAX(0,self.layout.contentSize.width - [UIScreen width]), 0);
    }];
}

- (CAShapeLayer *)dashLineFrom:(CGPoint)point endPoint:(CGPoint)endPoint
{
    CAShapeLayer *dash = [CAShapeLayer layer];
    dash.lineWidth = 1;
    dash.strokeColor = [UIColor colorWithString:@"#f0f0f0"].CGColor;
    UIBezierPath *b = [UIBezierPath bezierPath];
    [b moveToPoint:point];
    [b addLineToPoint:endPoint];
    dash.path = b.CGPath;
    dash.lineDashPattern = @[@3, @2];
    return dash;
}
@end
