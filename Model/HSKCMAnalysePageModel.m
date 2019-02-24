//
//  HSKCMAnalyseAngleModel.m
//  CardManage
//
//  Created by Sam on 2018/5/2.
//  Copyright © 2018 Carl. All rights reserved.
//

#import "HSKCMAnalysePageModel.h"

@implementation HSKCMAnalyseAngleModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{
             @"typeDesc":@"consumeType",
             @"type":@"consumeTypeId"
             };
}
@end


@implementation HSKCMAnalyseDotModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{
             @"month":@"yearMonth"
             };
}

- (void)setMonth:(NSString *)month
{   if (month.length < 6){ _month = month; return;}
    _month = @([month substringWithRange:NSMakeRange(4, 2)].integerValue).stringValue;
}
@end

@implementation HSKCMAnalysePageModel : HSKBaseModel

+ (NSArray *)randomSectors
{
    NSArray *colors = @[@"#123456", @"#fe2353", @"#789654",@"#a123fe",@"#feb65c",@"#237264"];
    NSArray *moneys = @[@"9000000000", @"3000",@"10",@"8000", @"10000",@"4444"];
    NSArray *descs = @[@"日常消费", @"餐饮零食", @"其他支出", @"网上消费", @"打车" ,@"买买买"];
    NSMutableArray *arr = @[].mutableCopy;
    NSInteger  num = 5;
    for (int i = 0; i < num; i ++)
    {
        HSKCMAnalyseAngleModel *m = [HSKCMAnalyseAngleModel new];
        NSInteger j = arc4random() % colors.count;
        m.money = moneys[j];
        m.color = colors[j];
        m.typeDesc = descs[j];
        [arr addObject:m];
    }
    return arr;
}
+ (NSArray *)randomDots
{
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 5; i > 0; i --) {
        HSKCMAnalyseDotModel *m = [HSKCMAnalyseDotModel new];
        m.money = @(arc4random()%9000).stringValue;
        m.month = @(i).stringValue;
        [arr addObject:m];
    }
    return arr;
}
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{
             @"unPay":@"shouldRepayment",
             @"unCheck":@"noBillAmount",
             @"allCost":@"billCount",
             @"consumeCost":@"sumConsumeMoney",
             @"allLimit":@"sumQuota",
             @"leftLimit":@"sumAvailablequota",
             @"cardCount":@"countCard",
             @"highestLimit":@"maxquota",
             @"sectorChart":@"analyse",
             @"lineChart":@"monthConsumeCruve",
             @"analyseDesc":@"consumeDesc",
             @"updateTime":@"lastUpdateTime",
             @"billDuration":@"firstLastMonthDay"
             };
}
- (void)setBillDuration:(NSString *)billDuration
{
    if (billDuration.length == 0) return;
    NSArray *months = [billDuration componentsSeparatedByString:@"-"];
    NSString *from  = months.firstObject;
    
    NSArray  *fromMonthDay = [from componentsSeparatedByString:@"."];
    NSString *fromMonth    = fromMonthDay.firstObject;
    NSString *fromDay      = fromMonthDay.lastObject;
    from = [NSString stringWithFormat:@"%d.%d",(int)fromMonth.integerValue, (int)fromDay.integerValue];
    
    NSString *to    = months.lastObject;
    NSArray *toMonthDay = [to componentsSeparatedByString:@"."];
    NSString *toMonth = toMonthDay.firstObject;
    NSString *toDay = toMonthDay.lastObject;
    to = [NSString stringWithFormat:@"%d.%d",(int)toMonth.integerValue, (int)toDay.integerValue];
    
    billDuration = [NSString stringWithFormat:@"%@-%@",from,to];
    _billDuration = billDuration;
}
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{
             @"sectorChart":[HSKCMAnalyseAngleModel class],
             @"lineChart":[HSKCMAnalyseDotModel class]
             };
}
@end
