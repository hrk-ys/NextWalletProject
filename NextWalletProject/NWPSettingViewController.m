//
//  NWPSettingViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/03/10.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPSettingViewController.h"

#import "NWPPasswordManager.h"

#import <BlocksKit+UIKit.h>
#import <Social/Social.h>

typedef NS_ENUM(NSUInteger, NWPSettingRowIndex) {
    NWPSettingRowIndexInquiry = 0,
    NWPSettingRowIndexPassSetting = 1,
    NWPSettingRowIndexPassReset = 2,
};
@interface NWPSettingViewController ()

@end

@implementation NWPSettingViewController

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == NWPSettingRowIndexInquiry) {
        [self showTwitterPost:S(@".%@ [お問い合わせ内容を入してください]", TWITTER_ACCOUNT)];
    }
    if (indexPath.row == NWPSettingRowIndexPassSetting) {
        [self passwordSetting];
    }
    if (indexPath.row == NWPSettingRowIndexPassReset) {
        [self passwordReset];
    }
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

- (void)passwordRegist {
    
    NWPPasswordManager* passwordMgr = [NWPPasswordManager sharedInstance];
    [passwordMgr registPasswordFromViewController:self
                                            title:@"新しいパスワード"
                                         animated:YES
                                          success:^{
                                              [JDStatusBarNotification showWithStatus:@"登録しました" dismissAfter:3.f];
                                          }
                                           cancel:^{}];
}

- (void)passwordSetting {

    NWPPasswordManager* passwordMgr = [NWPPasswordManager sharedInstance];
    
    if ([passwordMgr hasPassword]) {
        
        [passwordMgr validPasswordFromViewController:self
                                               title:@"古いパスワード"
                                            animated:YES
                                             success:^{
                                                 [self passwordRegist];
                                             }
                                              cancel:^{}];
    } else {
        [self passwordRegist];
    }
}

- (void)passwordReset {
    
    if ([UIDevice iOSVersion] < 8.0f) {

        UIAlertView* av = [[UIAlertView alloc] bk_initWithTitle:@"パスワードリセット" message:@"パスワードをリセットすると、保護されているカードはすべて削除されます"];
        [av bk_setCancelButtonWithTitle:@"キャンセル" handler:^{}];
        
        [av bk_addButtonWithTitle:@"リセット" handler:^{
            
            NSMutableArray* cards = @[].mutableCopy;
            [cards addObjectsFromArray:[NWPCard findByAttribute:@"cardType" withValue:@(NWPCardTypeCredit)]];
            [cards addObjectsFromArray:[NWPCard findByAttribute:@"cardType" withValue:@(NWPCardTypeLicense)]];
            
            NSManagedObjectContext* context = [NSManagedObjectContext defaultContext];
            for (NWPCard* card in cards) {
                [context deleteObject:card];
            }
            [context saveToPersistentStoreAndWait];
            
            [[NWPPasswordManager sharedInstance] resetPassword];
            
            [JDStatusBarNotification showWithStatus:@"パスワードをリセットしました" dismissAfter:3.f];
        }];
        [av show];
    } else {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"パスワードリセット" message:@"パスワードをリセットすると、保護されているカードはすべて削除されます" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        
        [ac addAction:[UIAlertAction actionWithTitle:@"リセット" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSMutableArray* cards = @[].mutableCopy;
            [cards addObjectsFromArray:[NWPCard findByAttribute:@"cardType" withValue:@(NWPCardTypeCredit)]];
            [cards addObjectsFromArray:[NWPCard findByAttribute:@"cardType" withValue:@(NWPCardTypeLicense)]];
            
            NSManagedObjectContext* context = [NSManagedObjectContext defaultContext];
            for (NWPCard* card in cards) {
                [context deleteObject:card];
            }
            [context saveToPersistentStoreAndWait];
            
            [[NWPPasswordManager sharedInstance] resetPassword];
            
            [JDStatusBarNotification showWithStatus:@"パスワードをリセットしました" dismissAfter:3.f];
        }]];
        
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (void)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
