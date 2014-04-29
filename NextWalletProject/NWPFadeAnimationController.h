//
//  NWPFadeAnimationController.h
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/28.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWPFadeAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@end


@interface NWPFadeInAnimationController : NWPFadeAnimationController

@end

@interface NWPFadeOutAnimationController : NWPFadeAnimationController

@end
