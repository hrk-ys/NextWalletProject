//
//  NWPCardBarcodeReaderViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/03/10.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardBarcodeReaderViewController.h"

#import "NWPBarcodeImageView.h"

//#import "ZBarSDK.h"
#import <ZBarSDK.h>



@interface NWPCardBarcodeReaderViewController () <ZBarReaderViewDelegate>


@property (weak, nonatomic) IBOutlet ZBarReaderView *readerView;
@property (nonatomic, retain) ZBarCameraSimulator   *cameraSim;


@property (nonatomic) HYAlertView                       *alertView;
@property (weak, nonatomic) IBOutlet UIView             *previewView;
@property (weak, nonatomic) IBOutlet NWPBarcodeImageView *barcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel            *barcodeLabel;


@property (weak, nonatomic) IBOutlet UIButton *previewOkButton;
@property (weak, nonatomic) IBOutlet UIButton *previewCancelButton;


@end

@implementation NWPCardBarcodeReaderViewController

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
    
    self.view.backgroundColor = BG_COLOR;
    
    self.title                         = @"バーコード読み込み";
    self.previewView.layer.borderWidth = 1.0f;
    self.previewView.layer.borderColor = [UIColor grayColor].CGColor;

    [self.previewCancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    
    // the delegate receives decode results
    self.readerView.readerDelegate = self;
    
    // Enable UPC-A
    [self.readerView.scanner setSymbology:ZBAR_UPCA
                                   config:ZBAR_CFG_ENABLE
                                       to:1];
    
    // you can use this to support the simulator
    if (TARGET_IPHONE_SIMULATOR) {
        self.cameraSim = [[ZBarCameraSimulator alloc]
                          initWithViewController:self];
        self.cameraSim.readerView = self.readerView;
    }
    

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.readerView start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [UIView animateWithDuration:0.3f animations:^{ self.view.alpha = 0; }];
    [self.readerView stop];
}


#pragma mark - ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)view
    didReadSymbols:(ZBarSymbolSet *)syms
         fromImage:(UIImage *)img
{
    self.card.barcodeType = nil;
    
    LOG(@"symbol count %d", syms.count);
    for (ZBarSymbol *sym in syms) {
        LOG(@"%@ %@", sym.typeName, sym.data);
        if ([NWPCard enableBarcodeType:sym.typeName]) {
            self.card.barcodeType = sym.typeName;
            self.card.cardNo      = sym.data;
            break;
        }
    }
    if (self.card.barcodeType) {
        [self.barcodeImageView setCard:self.card];
        
        [self.readerView stop];
        self.barcodeLabel.text = self.card.displayBarcode;
        
        self.alertView = [[HYAlertView alloc] initWithView:self.previewView];
        __weak NWPCardBarcodeReaderViewController *weakSelf = self;
        self.alertView.closedBlock = ^{
            [weakSelf.readerView start];
        };
        [self.alertView showAlert];
    }
}

#pragma mark - action

- (IBAction)tappedCancel:(id)sender
{
    self.card.cardNo = nil;
    self.card.barcodeType = nil;
    [self.alertView close];
}

- (IBAction)tappedOkButton:(id)sender
{
    self.alertView.closedBlock  = nil;
    [self.alertView close];
    
    [self.delegate cardCreateViewControllerSuccess:self];
}


@end
