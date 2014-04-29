//
//  NWPCardDetailDefaultViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/29.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardDetailDefaultViewController.h"

@interface NWPCardDetailDefaultViewController ()

@end

@implementation NWPCardDetailDefaultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupCardImage:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = 15.0f;
    imageView.clipsToBounds      = YES;
}

@end
