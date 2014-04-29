//
//  NWPCardDetailBaseViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/27.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardDetailBaseViewController.h"

@interface NWPCardDetailBaseViewController ()

@end

@implementation NWPCardDetailBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCardImage:_frontImageView];
    [self setupCardImage:_backImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = self.card.cardName;
    self.frontImageView.image = self.card.frontImage;
    self.backImageView.image = self.card.backImage;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.scrollView.contentOffset = CGPointMake(0, -64);
}



- (void)setupCardImage:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = 15.0f;
    imageView.clipsToBounds      = YES;
}

@end
