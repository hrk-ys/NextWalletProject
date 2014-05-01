//
//  NWPCardCreateViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/03/10.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardCreateViewController.h"


#import "NWPCardCreateBaseViewController.h"
#import "NWPCardCaptureViewController.h"

@interface NWPCardCreateViewController ()

@end

@implementation NWPCardCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    LOG(@"card create");
    [self.viewControllers[0] setDelegate:self];
}

- (void)_pushCaptureView:(NWPCardCreateBaseViewController*)vc
{
    NWPCardCaptureViewController* nextVc = [self.storyboard instantiateViewControllerWithIdentifier:@"cardCapture"];
    [vc setupNextViewController:nextVc];
    nextVc.isBackImage = vc.card.preFrontImage ? YES : NO;
    
    [vc.navigationController pushViewController:nextVc animated:YES];
}

- (void)cardCreateViewControllerSuccess:(NWPCardCreateBaseViewController*)vc
{

    if (self.viewControllers.count == 1) {
        if ([vc.card.cardType integerValue] == NWPCardTypeBarcode) {
            [vc performSegueWithIdentifier:@"barcode" sender:nil];
        } else {
            [vc performSegueWithIdentifier:@"capture" sender:nil];
        }
    } else if (self.viewControllers.count == 2) {
        if (vc.card.cardType.integerValue == NWPCardTypeBarcode) {
            [vc performSegueWithIdentifier:@"next" sender:nil];
        } else {
            [self _pushCaptureView:vc];            
        }
    } else if (self.viewControllers.count == 3) {
        if (vc.card.cardType.integerValue == NWPCardTypeBarcode) {
            [self _pushCaptureView:vc];
        } else {
            [self cardRegist:vc];
        }
    } else {
        [self cardRegist:vc];
    }
}


- (void)cardRegist:(NWPCardCreateBaseViewController*)vc {
    [vc.card storePreImage];
    [vc.context saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        [vc.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"card_create" properties:@{ @"card_": vc.card.cardType}];
}


- (void)close:(id)sender
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
