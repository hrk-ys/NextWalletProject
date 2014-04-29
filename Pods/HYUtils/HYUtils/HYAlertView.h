//
//  HYAlertView.h
//  Pods
//
//  Created by Hiroki Yoshifuji on 2014/04/26.
//
//


#import <UIKit/UIKit.h>
#include "HYBlock.h"

@interface HYAlertView : NSObject

@property (nonatomic, copy) HYBlock closedBlock;

@property (nonatomic) BOOL disableTapGesture; // default YES

- (id)initWithView:(UIView *)view;

- (void)showAlert;
- (void)close;


@end
