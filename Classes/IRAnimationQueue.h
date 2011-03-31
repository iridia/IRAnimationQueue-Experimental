//
//  IRAnimationQueue.h
//  GCD-Invoked-Animation
//
//  Created by Evadne Wu on 4/1/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>





#ifndef __IRAnimationInstruction__
#define __IRAnimationInstruction__

#define IRAnimationInstructionQueueableDelay MAXFLOAT

#endif

@interface IRAnimationInstruction : NSObject

+ (IRAnimationInstruction *) instructionWithAnimation:(CAAnimation *)animation delay:(NSTimeInterval)delay target:(CALayer *)target keyPath:(NSString *)keyPath;
+ (IRAnimationInstruction *) queueableInstructionWithAnimation:(CAAnimation *)animation target:(CALayer *)target keyPath:(NSString *)keyPath; // delay determined automatically by the animation queue

@end





@interface IRAnimationQueue : NSObject

+ (IRAnimationQueue *) queue; // reutrns an autoreleased new queue

- (void) runAnimationInstructions:(NSArray *)animationInstructions withCallback:(void(^)(BOOL didFinish))aBlockOrNil; // enqueues everything

- (void) enqueueAnimation:(CAAnimation *)animation withDelay:(NSTimeInterval)delay forTarget:(CALayer *)animatedTarget keyPath:(NSString *)animatedKeyPath;
- (void) dispatchAnimationsWithCallback:(void(^)(BOOL didFinish))aBlockOrNil;

@end
