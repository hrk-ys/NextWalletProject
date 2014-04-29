//
//  NWPCardCreateBaseViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/26.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardCreateBaseViewController.h"

@interface NWPCardCreateBaseViewController ()

@end

@implementation NWPCardCreateBaseViewController

- (void)setupNextViewController:(UIViewController*)vc
{
    if ([vc isKindOfClass:[NWPCardCreateBaseViewController class]]) {
        
        NWPCardCreateBaseViewController* cbvc = (NWPCardCreateBaseViewController*)vc;

        cbvc.card     = _card;
        cbvc.context  = _context;
        cbvc.delegate = _delegate;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self setupNextViewController:segue.destinationViewController];
}

@end
