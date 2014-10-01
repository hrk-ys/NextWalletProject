//
//  HYAlertView.m
//  Pods
//
//  Created by Hiroki Yoshifuji on 2014/04/26.
//
//

#import "HYAlertView.h"

@interface HYAlertView() <UIGestureRecognizerDelegate>

@property (nonatomic) UIWindow *currentWindow;
@property (nonatomic) UIWindow *selfWindow;

@property (nonatomic) UIView *parentView;
@property (nonatomic) UIView *view;
@property (nonatomic) CGRect  viewFrame;

@property (nonatomic) UITapGestureRecognizer *gesture;
@end

@implementation HYAlertView

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.currentWindow = [[[UIApplication sharedApplication] delegate] window];
        self.selfWindow    = [[UIWindow alloc] initWithFrame:self.currentWindow.bounds];
        
        view.layer.cornerRadius = 10.0f;
        view.clipsToBounds      = YES;
        
        self.view       = view;
        self.viewFrame  = view.frame;
        self.parentView = view.superview;
        [view removeFromSuperview];
        
        UIView *tapView = [[UIView alloc] initWithFrame:self.selfWindow.bounds];
        tapView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.5];
        tapView.userInteractionEnabled = YES;
        self.gesture            = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        self.gesture.delegate   = self;
        self.gesture.enabled    = YES;
        [tapView addGestureRecognizer:self.gesture];
        [self.selfWindow addSubview:tapView];
        
        view.center = self.selfWindow.center;
        [self.selfWindow addSubview:view];

        [self.selfWindow addConstraint:[NSLayoutConstraint constraintWithItem:self.selfWindow
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];

        [self.selfWindow addConstraint:[NSLayoutConstraint constraintWithItem:self.selfWindow
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:view
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0.0]];

        self.disableTapGesture = YES;
    }
    
    return self;
}

- (void)setDisableTapGesture:(BOOL)disableTapGesture
{
    _disableTapGesture   = disableTapGesture;
    self.gesture.enabled = !disableTapGesture;
}

- (void)showAlert
{
    self.view.hidden = NO;
    [self.selfWindow makeKeyAndVisible];
}

- (void)close
{
    if (self.parentView) {
        self.view.hidden = YES;
        [self.view removeFromSuperview];
        self.view.frame = self.viewFrame;
        [self.parentView addSubview:self.view];
    }
    
    [self.currentWindow makeKeyAndVisible];
    
    if (self.closedBlock) { self.closedBlock(); }
}

- (void)tap:(id)sender
{
    [self close];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != gestureRecognizer.view)
    {
        return NO;
    }
    
    return YES;
}

@end
