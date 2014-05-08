//
//  NWPPasswordManager.h
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/05/07.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NWPPasswordManager : NSObject

@property (nonatomic) BOOL recommendSetPass;

+ (NWPPasswordManager*)sharedInstance;

- (void)resetPassword;
- (BOOL)isPassLocked;
- (BOOL)hasPassword;
- (void)setPassword:(NSString*)password;
- (BOOL)validPassword:(NSString*)password;


- (void)registPasswordFromViewController:(UIViewController*)vc
                                   title:(NSString*)title
                                animated:(BOOL)animated
                                 success:(HYBlock)success
                                  cancel:(HYBlock)cancel;

- (void)validPasswordFromViewController:(UIViewController*)vc
                                  title:(NSString*)title
                               animated:(BOOL)animated
                                success:(HYBlock)success
                                 cancel:(HYBlock)cancel;

@end
