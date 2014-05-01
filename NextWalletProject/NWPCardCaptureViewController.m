//
//  NWPCardCaptureViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/03/10.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardCaptureViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface NWPCardCaptureViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, retain) AVCaptureSession          *session;
@property (nonatomic, retain) AVCaptureStillImageOutput *imageOutput;

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *cardShadowView;

@property (weak, nonatomic) IBOutlet UIButton *captureButton;

@property (weak, nonatomic) IBOutlet UIView      *captureView;
@property (weak, nonatomic) IBOutlet UIImageView *captureImageView;

@property (weak, nonatomic) IBOutlet UIButton *previewOkButton;
@property (weak, nonatomic) IBOutlet UIButton *previewCancelButton;

@property (nonatomic, retain) HYAlertView* alertView;

@property (nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation NWPCardCaptureViewController

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
    
    if (!self.isBackImage) {
        
        self.title = @"カード表 撮影";

    } else {
        self.title = @"カード裏 撮影";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tappedDoneButton:)];
    }
    
    self.previewView.backgroundColor = [UIColor clearColor];
    
    self.cardShadowView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.cardShadowView.layer.borderWidth = 1.0f;
    self.cardShadowView.layer.cornerRadius = 5.0f;
    
    [self.previewCancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

    
    self.session = [[AVCaptureSession alloc] init];
    [self.session beginConfiguration];
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    
    NSArray                *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice        *device  = nil;
    AVCaptureDevicePosition camera  = AVCaptureDevicePositionBack; // Back or Front
    for (AVCaptureDevice *d in devices) {
        device = d;
        if (d.position == camera) {
            break;
        }
    }
    
    NSError              *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (input) {
        [self.session addInput:input];
    }
    
    self.imageOutput = [AVCaptureStillImageOutput new];
    [self.session addOutput:self.imageOutput];
    [self.session commitConfiguration];
    
    
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.frame        = self.previewView.bounds;
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.previewView.layer addSublayer:preview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.card.isInserted) {
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:self.isBackImage ? @"card_create_capture_back" : @"card_create_capture_front"];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.session stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (IBAction)tappedCaptureButton:(id)sender
{
    AVCaptureConnection *connection = [[self.session.outputs.lastObject connections] lastObject];
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection
                                                  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                      NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                      
                                                      UIImage* image = [UIImage imageWithData:data];
                                                      float diff =  self.cardShadowView.width / self.view.width;
                                                      float width = image.size.width * diff;
                                                      float height = width * (self.cardShadowView.height / self.cardShadowView.width);
                                                      
                                                      UIGraphicsBeginImageContext(image.size);
                                                      [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
                                                      image = UIGraphicsGetImageFromCurrentImageContext();
                                                      UIGraphicsEndImageContext();
                                                      
                                                      CGRect rect = CGRectMake(
                                                                               (image.size.width - width) / 2.0f,
                                                                               (image.size.height - height) / 2.0f,
                                                                               width,
                                                                               height
                                                                               );
                                                      CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
                                                      
                                                      
                                                      UIImage* rectImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:UIImageOrientationUp];
                                                      CGImageRelease(imageRef);
                                                      
                                                      self.captureImageView.image = rectImage;
                                                      
                                                      self.alertView = [[HYAlertView alloc] initWithView:self.captureView];
                                                      
                                                      [self.alertView showAlert];
                                                  }];
}


- (IBAction)tappedCancelButton:(id)sender
{
    [self.alertView close];
}

- (IBAction)tappedOkButton:(id)sender
{
    [self.alertView close];
    
    if (!self.isBackImage) {
        self.card.preFrontImage = self.captureImageView.image;
    } else {
        self.card.preBackImage = self.captureImageView.image;
    }
    
    [self.delegate cardCreateViewControllerSuccess:self];
}

- (void)tappedDoneButton:(id)sender
{
    [self.delegate cardCreateViewControllerSuccess:self];
}

- (IBAction)tappedLibraryButton:(id)sender {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}




- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.captureImageView.image = image;
    
    self.alertView = [[HYAlertView alloc] initWithView:self.captureView];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.alertView showAlert];
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end