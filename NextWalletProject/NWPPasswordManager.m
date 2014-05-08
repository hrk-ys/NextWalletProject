//
//  NWPPasswordManager.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/05/07.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPPasswordManager.h"

#import <THPinViewController.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NWPPasswordManager ()<THPinViewControllerDelegate>

@property (nonatomic) NSString* passcode;

@property (nonatomic) BOOL settingMode;
@property (nonatomic) BOOL isPassLocked;

@property (nonatomic) NSDate* lastFailedDate;
@property (nonatomic) int remainingPinEntries;


@property (nonatomic, copy) HYBlock successBlock;
@property (nonatomic, copy) HYBlock cancelBlock;

@end

@implementation NWPPasswordManager

+ (NWPPasswordManager*)sharedInstance
{
    static NWPPasswordManager* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [NWPPasswordManager new];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _passcode = [[NSUserDefaults standardUserDefaults] stringForKey:@"kPasscode"];
        _remainingPinEntries = 3;
        _isPassLocked = _passcode ? YES : NO;
    }
    return self;
}

+(NSString*) sha256ForStr:(NSString *)str {
    const char *c = [str UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(c, strlen(c), result);
    NSMutableString* strs = [NSMutableString string];
    for (int i=0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [strs appendFormat:@"%02x", result[i]];
    }
    return strs;
}

- (void)resetPassword
{
    _passcode = nil;
    _isPassLocked = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kPasscode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)hasPassword
{
    return _passcode ? YES : NO;
}

- (void)setPassword:(NSString*)password
{
    _passcode = [self.class sha256ForStr:password];
    [[NSUserDefaults standardUserDefaults] setObject:_passcode forKey:@"kPasscode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)validPassword:(NSString*)password
{
    NSString* passcode = [self.class sha256ForStr:password];
    return [passcode isEqualToString:_passcode];
}


- (BOOL)isPassLocked
{
    return _isPassLocked;
}

- (void)registPasswordFromViewController:(UIViewController*)vc
                                   title:(NSString*)title
                                animated:(BOOL)animated
                                 success:(HYBlock)success
                                  cancel:(HYBlock)cancel
{
    _settingMode = YES;
    [self presentViewController:vc
                          title:title
                       animated:animated
                        success:success
                         cancel:cancel];
}

- (void)validPasswordFromViewController:(UIViewController*)vc
                                  title:(NSString*)title
                               animated:(BOOL)animated
                                success:(HYBlock)success
                                 cancel:(HYBlock)cancel
{
    _settingMode = NO;
    [self presentViewController:vc
                          title:title
                       animated:animated
                        success:success
                         cancel:cancel];
}

- (void)presentViewController:(UIViewController*)vc
                        title:(NSString*)title
                     animated:(BOOL)animated
                      success:(HYBlock)success
                       cancel:(HYBlock)cancel
{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.backgroundColor = [UIColor lightGrayColor];
    pinViewController.promptTitle = title;
    pinViewController.promptColor = [UIColor whiteColor];
    pinViewController.view.tintColor = [UIColor whiteColor];
    pinViewController.hideLetters = YES;
    
    _successBlock = success;
    _cancelBlock  = cancel;
    
    [vc presentViewController:pinViewController animated:YES completion:nil];
}

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if (_settingMode) {
        [self setPassword:pin];
        return YES;
    }
    
    if ([self validPassword:pin]) {
        _isPassLocked = NO;
        return YES;
    } else {
        self.remainingPinEntries--;
        return NO;
    }
}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return (self.remainingPinEntries > 0);
}

- (void)pinViewControllerDidDismissAfterPinEntryWasSuccessful:(THPinViewController *)pinViewController
{
    _successBlock();
}

- (void)pinViewControllerDidDismissAfterPinEntryWasCancelled:(THPinViewController *)pinViewController
{
    _cancelBlock();
}

- (void)pinViewControllerDidDismissAfterPinEntryWasUnsuccessful:(THPinViewController *)pinViewController
{
    _cancelBlock();
}

@end
