//
//  IRAnimationQueue.m
//  GCD-Invoked-Animation
//
//  Created by Evadne Wu on 4/1/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRAnimationQueue.h"





@interface IRAnimationInstruction ()

@property (nonatomic, readwrite, retain) CAAnimation *animation;
@property (nonatomic, readwrite, assign) CFTimeInterval delay;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite, retain) NSString *keyPath;

@end

@implementation IRAnimationInstruction

@synthesize animation, delay, target, keyPath;

+ (IRAnimationInstruction *) instructionWithAnimation:(CAAnimation *)animation delay:(NSTimeInterval)delay target:(CALayer *)target keyPath:(NSString *)keyPath {

	IRAnimationInstruction *returnedInstruction = [[[self alloc] init] autorelease];
	returnedInstruction.animation = animation;
	returnedInstruction.delay = delay;
	returnedInstruction.target = target;
	returnedInstruction.keyPath = keyPath;
	
	return returnedInstruction;
	
}

+ (IRAnimationInstruction *) queueableInstructionWithAnimation:(CAAnimation *)animation target:(CALayer *)target keyPath:(NSString *)keyPath {

	return [self instructionWithAnimation:animation delay:IRAnimationInstructionQueueableDelay target:target keyPath:keyPath];

}

- (void) dealloc {

	[animation release];
	[keyPath release];
	
	[super dealloc];

}

@end










@interface IRAnimationQueue ()

@property (nonatomic, readwrite, retain) NSMutableArray *animations;

@end

@implementation IRAnimationQueue
@synthesize animations;

+ (IRAnimationQueue *) queue {

	return [[[self alloc] init] autorelease];

}

- (id) init {

	self = [super init];
	if (!self) return nil;
	
	animations = [[NSMutableArray array] retain];
	
	return self;

}

- (void) dealloc {

	[animations release];
	
	[super dealloc];

}

- (void) enqueueAnimation:(CAAnimation *)animation withDelay:(NSTimeInterval)delay forTarget:(CALayer *)animatedTarget keyPath:(NSString *)animatedKeyPath {

	CAAnimation *enqueuedAnimation = [[animation copy] autorelease];
	enqueuedAnimation.delegate = self;

	objc_setAssociatedObject(enqueuedAnimation, @"IRAnimationQueueContext", [NSDictionary dictionaryWithObjectsAndKeys:
	
		[NSNumber numberWithDouble:delay], @"delay",
		animatedTarget, @"animatedTarget",
		animatedKeyPath, @"animatedKeyPath",
	
	nil], OBJC_ASSOCIATION_RETAIN);

	[animations addObject:enqueuedAnimation];

}

- (void) dispatchAnimationsWithCallback:(void(^)(BOOL didFinish))aBlockOrNil {

	dispatch_queue_t dispatchedQueue = dispatch_get_main_queue();
	__block CFTimeInterval sumDuration = 0;
	
	for (CAAnimation *animation in self.animations) {
	
		NSDictionary *userInfo = (NSDictionary *)objc_getAssociatedObject(animation, @"IRAnimationQueueContext");
	
		NSTimeInterval delay = [[userInfo objectForKey:@"delay"] doubleValue];
		CALayer *animatedTarget = [userInfo objectForKey:@"animatedTarget"];
		NSString *animatedKeyPath = [userInfo objectForKey:@"animatedKeyPath"];
		
		dispatch_time_t dispatchDelay = delay * NSEC_PER_SEC;
	
		dispatch_retain(dispatchedQueue);
		dispatch_after(dispatchDelay, dispatchedQueue, ^ {

			[animatedTarget addAnimation:animation forKey:animatedKeyPath];
		
		});
		
		sumDuration = MAX(sumDuration, (delay + animation.duration));
		
	}
	
	
	dispatch_after(sumDuration, dispatchedQueue, ^ {

		if (aBlockOrNil)
		aBlockOrNil(YES);
	
	});

}





- (void) runAnimationInstructions:(NSArray *)animationInstructions withCallback:(void(^)(BOOL didFinish))aBlockOrNil {

	__block CFTimeInterval exhaustedDuration = 0.0;

	for (IRAnimationInstruction *instruction in animationInstructions) {
	
		exhaustedDuration += instruction.animation.duration;
		
		CFTimeInterval actualDelay = instruction.delay;
		if (actualDelay == IRAnimationInstructionQueueableDelay)
		actualDelay = exhaustedDuration;
	
		[self enqueueAnimation:instruction.animation withDelay:actualDelay forTarget:instruction.target keyPath:instruction.keyPath];

	
	}
	
	[self dispatchAnimationsWithCallback:aBlockOrNil];

}

@end
