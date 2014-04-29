//
//  NWPSuccessButton.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/26.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPSuccessButton.h"

@implementation NWPSuccessButton

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
    self.layer.borderColor = [UIColor colorWithRed:0.933 green:0.556 blue:0.085 alpha:1.000].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 3.0f;
    
    [self setTitleColor:[UIColor colorWithRed:0.933 green:0.556 blue:0.085 alpha:1.000] forState:UIControlStateNormal];
    self.clipsToBounds = YES;
}

@end
