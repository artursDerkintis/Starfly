//
//  ew.h
//  StarflyV2
//
//  Created by Neal Caffrey on 4/9/15.
//  Copyright (c) 2015 Neal Caffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ew : NSObject
+(ew*)getEw;
-(NSMutableArray*)mainColoursInImage:(UIImage *)image detail:(int)detail;
@end
@interface KGNoise : NSObject

+ (void)drawNoiseWithOpacity:(CGFloat)opacity;
+ (void)drawNoiseWithOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode;

@end
@interface UIImage(KGNoise)
- (UIImage *)imageWithNoiseOpacity:(CGFloat)opacity;
- (UIImage *)imageWithNoiseOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode;
@end