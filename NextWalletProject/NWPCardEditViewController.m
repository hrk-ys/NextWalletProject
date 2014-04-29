//
//  NWPCardEditViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/03/10.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardEditViewController.h"

#import "NWPCardCaptureViewController.h"

@interface NWPCardEditViewController ()
<NWPCardCreateBaseViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *cardNameWrapView;
@property (weak, nonatomic) IBOutlet UITextField *cardNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *frontImageButton;
@property (weak, nonatomic) IBOutlet UIButton *backImageButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic) NWPCard* editCard;
@property (nonatomic) NSManagedObjectContext* context;
@end

@implementation NWPCardEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"カード編集";
    
    _context = [NSManagedObjectContext MR_context];
    _editCard = (NWPCard*)[_context objectWithID:self.card.objectID];

    [_cardNameWrapView setBorderColor:[UIColor lightGrayColor] borderWidth:1.0f cornerRadius:5.0f];
    
    [_deleteButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1.000 green:0.576 blue:0.144 alpha:1.000]] forState:UIControlStateNormal];
    [self.deleteButton setBorderColor:nil borderWidth:1.0f cornerRadius:5.0f];
    
    [self setupButton:self.frontImageButton withImage:self.card.frontImage];
    [self setupButton:self.backImageButton withImage:self.card.backImage];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tappedDoneButton:)];
}

- (void)setupButton:(UIButton*)button withImage:(UIImage*)image
{
    if (image) {
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
    }
    [button setBorderColor:[UIColor lightGrayColor] borderWidth:1.0f cornerRadius:5.0f];
}


- (IBAction)tappedTableView:(id)sender {
    [self.cardNameTextField resignFirstResponder];
}



- (void)cardCreateViewControllerSuccess:(NWPCardCreateBaseViewController *)vc
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [_frontImageButton setBackgroundImage:(_editCard.preFrontImage ?: _editCard.frontImage) forState:UIControlStateNormal];
    [_backImageButton  setBackgroundImage:(_editCard.preBackImage  ?: _editCard.backImage)  forState:UIControlStateNormal];
}

- (void)_pushCapureControllerIsBack:(BOOL)back
{
    NWPCardCaptureViewController* nextVc = [self.storyboard instantiateViewControllerWithIdentifier:@"cardCapture"];
    
    nextVc.card = _editCard;
    nextVc.delegate = self;
    nextVc.isBackImage = back;
    
    [self.navigationController pushViewController:nextVc animated:YES];
    
}
- (IBAction)tappedFrontImageButton:(id)sender {
    [self _pushCapureControllerIsBack:NO];
}

- (IBAction)tappedBaskImageButton:(id)sender {
    [self _pushCapureControllerIsBack:YES];
}



- (void)tappedDoneButton:(id)sender {
    _editCard.cardName = _cardNameTextField.text;
    if (_editCard.preFrontImage || _editCard.preBackImage) {
        [_editCard storePreImage];
    }
    [_context saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)tappedDeleteButton:(id)sender {
    
    NSManagedObjectContext* context = self.card.managedObjectContext;
    [self.card deleteEntity];
    [context saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

@end
