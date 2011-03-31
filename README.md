A way to queue things up.  `IRAnimationQueue` is an experiment that works like this:

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

which calculates the delay automatically for the caller and uses GCD to dispatch blocks that run animations.  It does not rely on CAAnimation delegation, so probably is quite insensitive to proper timing — anyway, Core Animation runs its own thread, and you ought not do any important work when animating, and not animate when doing any important work…
