//
//  HSKCMAnalyseAngleModel.h
//  CardManage
//
//  Created by Sam on 2018/5/2.
//  Copyright © 2018 Carl. All rights reserved.
//

#import <HSKBasic/HSKBasic.h>

@interface HSKCMAnalyseAngleModel : HSKBaseModel
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *typeDesc;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *type;
@end

@interface HSKCMAnalyseDotModel : HSKBaseModel
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *month;
@end

@interface HSKCMAnalysePageModel : HSKBaseModel
@property (nonatomic, strong) NSArray <HSKCMAnalyseAngleModel *> *sectorChart;
@property (nonatomic, strong) NSArray <HSKCMAnalyseDotModel   *> *lineChart;
@property (nonatomic, copy) NSString *unPay; // 未还账单
@property (nonatomic, copy) NSString *unCheck; // 未出账
@property (nonatomic, copy) NSString *allCost; // 总账单
@property (nonatomic, copy) NSString *consumeCost; // 消费花费
@property (nonatomic, copy) NSString *allLimit; // 总额度
@property (nonatomic, copy) NSString *leftLimit; // 剩余额度
@property (nonatomic, copy) NSString *cardCount; // 卡数量
@property (nonatomic, copy) NSString *highestLimit; // 最高额度
@property (nonatomic, copy) NSString *analyseDesc; // 饼状图分析标题
@property (nonatomic, copy) NSString *updateTime; // 更新时间
@property (nonatomic, copy) NSString *yearMonth;
@property (nonatomic, copy) NSString *bankIcon;
@property (nonatomic, copy) NSString *billDuration;
+ (NSArray *)randomSectors;
+ (NSArray *)randomDots;

@end
/*
 {
 code = 1;
 data =     {
 analyse =         (
 {
 color = "#F79954";
 consumeType = "\U5176\U4ed6\U652f\U51fa";
 consumeTypeId = 1;
 money = "432.00";
 }
 );
 bankIcon = "http://www.huishuaka.com/banklogo/bklogo_js.png";
 billCount = "432.00";
 consumeDesc = "2018\U5e7405\U6708\U6d88\U8d39\U63a5\U53e3\U5206\U6790";
 countCard = 1;
 lastUpdateTime = "\U6570\U636e\U66f4\U65b0\U4e8e2018.05.09";
 maxquota = 5000;
 monthConsumeCruve =         (
 {
 money = 561;
 yearMonth = 201805;
 },
 {
 money = "3979.31";
 yearMonth = 201804;
 },
 {
 money = "576.29";
 yearMonth = 201803;
 },
 {
 money = "793.82";
 yearMonth = 201802;
 },
 {
 money = "5860.43";
 yearMonth = 201801;
 },
 {
 money = "2411.26";
 yearMonth = 201712;
 },
 {
 money = "6288.85";
 yearMonth = 201711;
 },
 {
 money = "1651.51";
 yearMonth = 201710;
 },
 {
 money = "799.44";
 yearMonth = 201709;
 },
 {
 money = "2182.17";
 yearMonth = 201708;
 },
 {
 money = "1485.4";
 yearMonth = 201707;
 },
 {
 money = "952.7";
 yearMonth = 201706;
 }
 );
 noBillAmount = "432.00";
 shouldRepayment = "0.00";
 sumAvailablequota = 4568;
 sumQuota = 5000;
 yearMonth = 201805;
 };
 desc = success;
 }
*/
