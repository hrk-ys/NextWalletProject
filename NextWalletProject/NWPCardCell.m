//
//  NWPCardCell.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/26.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardCell.h"

@implementation NWPCardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    //    self.layer.cornerRadius = 2.f;
    //    self.clipsToBounds = YES;
    //    self.layer.borderWidth = 1.f;
    //    self.layer.borderColor = [UIColor colorWithWhite:0.782 alpha:1.000].CGColor;
    //    self.layer.shadowColor = [UIColor colorWithWhite:0.886 alpha:1.000].CGColor;
    
    self.cardImageView.layer.cornerRadius = 5.0f;
    self.cardImageView.clipsToBounds      = YES;
    
    self.nameLabel.layer.cornerRadius = 5.0f;
    self.nameLabel.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.nameLabel.layer.borderWidth  = 1.0f;
    self.nameLabel.clipsToBounds      = YES;
    self.nameLabel.font               = [UIFont systemFontOfSize:12.0f];
    self.nameLabel.backgroundColor    = [UIColor clearColor];

//    self.nameLabel.backgroundColor    = [UIColor colorWithRed:0.325 green:0.286 blue:0.226 alpha:1.000];
}

@end
