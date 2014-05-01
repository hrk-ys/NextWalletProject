//
//  NWPCardDetailViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/03/10.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardDetailViewController.h"

#import "NWPCardDetailBaseViewController.h"
#import "NWPCardEditViewController.h"

@interface NWPCardDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *defaultCardView;
@property (weak, nonatomic) IBOutlet UIView *barcodeCardView;

@end

@implementation NWPCardDetailViewController

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
        self.screenName  = @"CardDetailView";
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"card_detail_view" properties:@{ @"card_type": self.card.cardType }];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = _card.cardName;
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"barcode"]) {
        if (self.card.cardTypeValue == NWPCardTypeBarcode) {
            self.barcodeCardView.hidden = NO;
            return YES;
        }
        return NO;
    }
    if ([identifier isEqualToString:@"default"]) {
        if (self.card.cardTypeValue != NWPCardTypeBarcode) {
            self.defaultCardView.hidden = NO;
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[NWPCardDetailBaseViewController class]]) {
        
        NWPCardDetailBaseViewController* vc = segue.destinationViewController;
        vc.card = self.card;

    } else if ([segue.destinationViewController isKindOfClass:[NWPCardEditViewController class]]){

        NWPCardEditViewController* vc = segue.destinationViewController;
        vc.card = self.card;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    self.scrollView.clipsToBounds = NO;
}



- (void)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
