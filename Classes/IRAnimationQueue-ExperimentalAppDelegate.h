//
//  GCD_Invoked_AnimationAppDelegate.h
//  GCD-Invoked-Animation
//
//  Created by Evadne Wu on 3/31/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "IRAnimationQueue.h"

@interface GCD_Invoked_AnimationAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

