//
//  HSKCMAnalyseMonthLineContextModel.h
//  CardManage
//
//  Created by Sam on 2018/5/11.
//  Copyright © 2018 Carl. All rights reserved.
//

#import <HSKBasic/HSKBasic.h>
#import "HSKCMAnalysePrintProtocol.h"
@interface HSKCMAnalyseLineContextModel : HSKBaseModel <HSKCMAnalyseCreateContextProtocol>
@property (nonatomic, assign) CGPoint fromPonit;
@property (nonatomic, assign) CGPoint toPoint;
@property (nonatomic, copy  ) NSString *color;
@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat   duration;
@property (nonatomic, copy  ) NSString *month;

@end




@interface HSKCMAnalyseGradientContextModel : HSKBaseModel <HSKCMAnalyseCreateContextProtocol>
@property (nonatomic, strong) NSArray *dotPoints;
@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, strong) NSArray *gradientColors;
@property (nonatomic, assign) CGFloat duration;
@end
