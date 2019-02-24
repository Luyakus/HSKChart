//
//  HSKCMAnalyseContextModel.h
//  CardManage
//
//  Created by Sam on 2018/5/10.
//  Copyright © 2018 Carl. All rights reserved.
//

#import <HSKBasic/HSKBasic.h>

#import "HSKCMAnalysePrintProtocol.h"


@interface HSKCMAnalyseAnagleContextModel : HSKBaseModel <HSKCMAnalyseCreateContextProtocol>
@property (nonatomic, copy  ) NSString *color;
@property (nonatomic, copy  ) NSString *desc;
@property (nonatomic, assign) CGFloat originalValue;
@property (nonatomic, assign) CGFloat reallyAngle;
@property (nonatomic, assign) CGFloat printAngle;
@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) BOOL    clockwise; 
@end

@interface HSKCMAnalyseDescContextModel : HSKBaseModel <HSKCMAnalyseCreateContextProtocol>
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint inflectionPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, copy  ) NSString *desc;
@property (nonatomic, assign) CGFloat   originalValue;
@property (nonatomic, copy  ) NSString *color;
@end

@interface HSKCMAnalyseSumContextModel : HSKBaseModel <HSKCMAnalyseCreateContextProtocol>
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *sumMoney;
@property (nonatomic, assign) CGPoint center;
@end


