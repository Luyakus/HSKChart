//
//  HSKCMAnalyseSectorLayout.h
//  CardManage
//
//  Created by Sam on 2018/5/10.
//  Copyright © 2018 Carl. All rights reserved.
//

#import <HSKBasic/HSKBasic.h>
#import "HSKCMAnalysePageModel.h"
@interface HSKCMAnalyseSectorLayout : HSKBaseModel
/*
 * 返回Arrary first NSArray <HSKCMAnalyseAnagleContextModel *>*
 *           second NSArray <HSKCMAnalyseDescContextModel *>*
 */
- (instancetype)initWithStartAngle:(CGFloat)starAngle
                       centerPoint:(CGPoint)center
                            radius:(CGFloat)radius
                         clockwise:(BOOL)clockwise
                         lineWidth:(CGFloat)width
                         printRect:(CGRect)rect;
- (NSArray *)layoutSectorWithOriginalData:(NSArray <HSKCMAnalyseAngleModel *> *)data;
@end
