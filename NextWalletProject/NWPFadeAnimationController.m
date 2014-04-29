//
//  NWPFadeAnimationController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/28.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPFadeAnimationController.h"

@implementation NWPFadeAnimationController

- (BOOL)fadeIn {
    return YES;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    

    if ([self fadeIn]) {
        [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
    } else {
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    }

    if ([self fadeIn]) {
        toVC.view.originX = fromVC.view.width;
    } else {
        toVC.view.originX = - toVC.view.width / 3.0f;
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         
                         if ([self fadeIn]) {
                             toVC.view.originX = fromVC.view.originX;
                             fromVC.view.originX = -fromVC.view.width / 3.0f;
                         } else {
                             toVC.view.originX = fromVC.view.originX;
                             fromVC.view.originX = fromVC.view.width;
                         }
                     }
                     completion:^(BOOL finished){
                         [transitionContext completeTransition:YES];
                     }];
}

@end

@implementation NWPFadeInAnimationController
@end

@implementation NWPFadeOutAnimationController
- (BOOL)fadeIn { return NO; }
@end