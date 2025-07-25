/*
 *  common.h
 *  AvatarBuilder
 *
 *  Created by Jen Beaven on 12/21/10.
 *  Copyright 2010 . All rights reserved.
 *
 */

#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>


#import "UIColor-Expanded.h"
#import "UIColor-HSVAdditions.h"

#import <MobileCoreServices/MobileCoreServices.h>



#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / M_PI * 180.0)

//CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
//CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;};


#define XLog(format, ...) NSLog(@"%s:%@", __PRETTY_FUNCTION__,[NSString stringWithFormat:format, ## __VA_ARGS__]);

#define APP (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define isPad [APP iAm]

#define DEF [NSUserDefaults standardUserDefaults]
#define FM [NSFileManager defaultManager]

#define kPrefsSaturation    @"SatinSaturation"
#define kPrefsFXItem        @"SatinFXItem"
#define kPrefsFXValue       @"SatinFXValue"
#define kPrefsMoreFXItem    @"SatinMoreFXItem"
#define kSatIndex 2

#define kNotifyTakeImage    @"SatinNotifyTakeImage"
#define kNotifyUseImage     @"SatinNotifyUseImage"
#define kNotifyDoFx         @"SatinNotifyDoFx"
#define kNotifyCancel       @"SatinNotifyCancel"

//#define APP (printerAppDelegate *)[[UIApplication sharedApplication] delegate]

