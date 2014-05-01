//
//  NWPCardDetailBarcodeViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/26.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardDetailBarcodeViewController.h"

#import "NWPBarcodeImageView.h"

#import <Social/Social.h>


@interface NWPCardDetailBarcodeViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView  *scrollView;
@property (weak, nonatomic) IBOutlet UIView *barcodeWrapView;
@property (weak, nonatomic) IBOutlet NWPBarcodeImageView *barcodeView;
@property (weak, nonatomic) IBOutlet UILabel *barcodeNoLabel;

@property (nonatomic) float brightness;

@end

@implementation NWPCardDetailBarcodeViewController

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
    
    [_barcodeWrapView setBorderColor:nil borderWidth:0 cornerRadius:5.0f];
    [_barcodeView setCard:self.card];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.barcodeNoLabel.text = self.card.cardNo;
    
    
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    UIApplication *application = [UIApplication sharedApplication];
    application.idleTimerDisabled = YES;
    
    if (self.card.cardNo) {
        self.brightness  = [UIScreen mainScreen].brightness;
        [UIScreen mainScreen].brightness = 1.0f;
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //    self.scrollView.clipsToBounds = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    self.scrollView.clipsToBounds = YES;
    
    UIApplication *application = [UIApplication sharedApplication];
    application.idleTimerDisabled = NO;
    
    if (self.card.cardNo) {
        [UIScreen mainScreen].brightness = self.brightness;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

- (IBAction)tappedReportButton:(id)sender {
    
    NSString* barcodeType = self.card.barcodeType;
    [self showTwitterPost:S(@".@NextWalletProject %@ [お問い合わせ内容を入してください]", barcodeType)];
}


- (void)showTwitterPost:(NSString*)message
{
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [controller setInitialText:message];
    [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
        } else if (result == SLComposeViewControllerResultCancelled) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [self presentViewController:controller animated:YES completion:nil];
}


@end
