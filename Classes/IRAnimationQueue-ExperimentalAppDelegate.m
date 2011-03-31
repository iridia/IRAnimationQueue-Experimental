//
//  GCD_Invoked_AnimationAppDelegate.m
//  GCD-Invoked-Animation
//
//  Created by Evadne Wu on 3/31/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRAnimationQueue-ExperimentalAppDelegate.h"

@implementation GCD_Invoked_AnimationAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    [self.window makeKeyAndVisible];
		
		dispatch_async(dispatch_get_main_queue(), ^ {
		
			UIView *animatedView = [[[UIView alloc] initWithFrame:(CGRect){ 0, 0, 128, 128 }] autorelease];
			animatedView.center = self.window.center;
			animatedView.backgroundColor = [UIColor redColor];
			
			[self.window addSubview:animatedView];
			
			[[IRAnimationQueue queue] runAnimationInstructions:[NSArray arrayWithObjects:
			
				[IRAnimationInstruction queueableInstructionWithAnimation:(( ^ {
				
					CABasicAnimation *animation = [CABasicAnimation animation];
					animation.toValue = (id)[UIColor greenColor].CGColor;
					animation.duration = 2.5f;
					animation.fillMode = kCAFillModeForwards;
					return animation;
				
				})()) target:animatedView.layer keyPath:@"backgroundColor"],
				
				[IRAnimationInstruction queueableInstructionWithAnimation:(( ^ {
			
					CABasicAnimation *animation = [CABasicAnimation animation];
					animation.toValue = (id)[UIColor blueColor].CGColor;
					animation.duration = 2.5f;
					animation.fillMode = kCAFillModeForwards;
					return animation;
			
				})()) target:animatedView.layer keyPath:@"backgroundColor"],
			
			nil] withCallback:nil];
			
		});
    
    return YES;
		
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
