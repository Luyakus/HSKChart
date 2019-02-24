//
//  CALayer+HSKCMAnalyseSectorPrinter.h
//  CardManage
//
//  Created by Sam on 2018/5/10.
//  Copyright © 2018 Carl. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HSKCMAnalysePrintProtocol.h"
@interface CALayer (HSKCMAnalysePrinter)
- (void)print:(NSArray <id<HSKCMAnalyseCreateContextProtocol>>*)subLayerContextModels;
@end
