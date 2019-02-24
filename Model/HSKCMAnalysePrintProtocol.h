//
//  HSKCMAnalysePrintProtocol.h
//  Modules
//
//  Created by Sam on 2018/5/10.
//  Copyright © 2018 Carl. All rights reserved.
//

#ifndef HSKCMAnalysePrintProtocol_h
#define HSKCMAnalysePrintProtocol_h
@protocol HSKCMAnalyseContextProtocol <NSObject>
@required

@property (nonatomic, assign) NSInteger    layerPriority;
@property (nonatomic, strong) CALayer     *layer;
@property (nonatomic, strong) CAAnimation *animation;
@property (nonatomic, assign) CGFloat      afterHigherPriority;

@end


@protocol HSKCMAnalyseCreateContextProtocol <NSObject>
@required
- (NSArray<id<HSKCMAnalyseContextProtocol>> *)perpareContext;
@end



#endif /* HSKCMAnalysePrintProtocol_h */
