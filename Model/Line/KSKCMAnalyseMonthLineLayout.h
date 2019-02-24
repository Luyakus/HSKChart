//
//  KSKCMAnalyseMonthLineLayout.h
//  CardManage
//
//  Created by Sam on 2018/5/11.
//  Copyright © 2018 Carl. All rights reserved.
//

#import <HSKBasic/HSKBasic.h>
#import "HSKCMAnalysePageModel.h"
@interface KSKCMAnalyseMonthLineLayout : HSKBaseModel
- (instancetype)initWithOrigin:(CGPoint)origin
                        height:(CGFloat)height
            durationEveryMonth:(CGFloat)duration
               brokenLineColor:(NSString *)brokenLineColor
                 baseLineColor:(NSString *)baseLineColor
                gradientColors:(NSArray *)gradientColors;
- (NSArray *)layoutMonthWithOriginalData:(NSArray < HSKCMAnalyseDotModel *> *)data;

@property (nonatomic, readonly) NSArray *dots;

@property (nonatomic, readonly) CGSize  contentSize;
@end
