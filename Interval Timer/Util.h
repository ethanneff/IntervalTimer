//
//  Util.h
//  Interval Timer
//
//  Created by Ethan Neff on 9/4/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

@property (nonatomic) UIColor *colorCyan;
@property (nonatomic) UIColor *colorRed;
@property (nonatomic) UIColor *colorYellow;
@property (nonatomic) UIColor *colorGreen;

// class methods (works on all classes, convenience construcutors) vs individual instance methods
+ (NSString *)getTimeStr:(int)secondsElapsed;
+ (NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;
+(void)showSimpleAlertWithMessage:(NSString *)message;
+(void)showSimpleAlertWithMessage:(NSString *)message andButton:(NSString *)button forSeconds:(float)seconds;

@end
