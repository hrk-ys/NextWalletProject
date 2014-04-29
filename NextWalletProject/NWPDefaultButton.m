//
//  NWPDefaultButton.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/26.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPDefaultButton.h"

@implementation NWPDefaultButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 3.0f;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.clipsToBounds = YES;
}

@end
