//
//  NSData+AES256.h
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/05/08.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
