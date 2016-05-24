//
//  Util.m
//  Interval Timer
//
//  Created by Ethan Neff on 9/4/14.
//  Copyright (c) 2014 ethanneff. All rights reserved.
//

#import "Util.h"

@implementation Util

- (id)init {
    if (self = [super init]) {
        self.colorCyan = [UIColor colorWithRed:0/255.0f green:120/255.0f blue:188/255.0f alpha:1.0f];
        self.colorRed = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
        self.colorYellow = [UIColor colorWithRed:241/255.0f green:196/255.0f blue:15/255.0f alpha:1.0f];
        self.colorGreen = [UIColor colorWithRed:46/255.0f green:204/255.0f blue:113/255.0f alpha:1.0f];
    }
    return self;
}

+ (NSString *)getTimeStr:(int)secondsElapsed {
    int seconds = secondsElapsed % 60;
    int minutes = secondsElapsed % 3600 / 60;
    int hours   = secondsElapsed / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

+ (NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random()%(max-min) + min;
}

+(void)showSimpleAlertWithMessage:(NSString *)message; {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

+(void)showSimpleAlertWithMessage:(NSString *)message andButton:(NSString *)button forSeconds:(float)seconds {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:button, nil];
    [alert show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:-1 animated:YES];
    });
}

@end
