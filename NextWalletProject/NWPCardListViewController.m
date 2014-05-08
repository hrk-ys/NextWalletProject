//
//  NWPCardListViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/03/09.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardListViewController.h"


#import <GADBannerView.h>
#import <GADRequest.h>
#import <LXReorderableCollectionViewFlowLayout.h>
#import <BlocksKit+UIKit.h>

#import "NWPFadeAnimationController.h"

#import "NWPCardDetailViewController.h"
#import "NWPCardCell.h"
#import "NWPPasswordManager.h"

@interface NWPCardListViewController ()
<UICollectionViewDataSource, UIViewControllerTransitioningDelegate, GADBannerViewDelegate,
LXReorderableCollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) GADBannerView *adMobView;
@property (nonatomic) BOOL           adMobIsVisible;

@property (nonatomic) NSArray* dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingButtonBottomLayout;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@end

@implementation NWPCardListViewController

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
    self.screenName  = @"CardListView";
    
    self.collectionView.backgroundColor = BG_COLOR;
    
    
    self.dataSource = [NWPCard findAllSortedBy:@"orderNum" ascending:YES];
    
    [self.settingButton setTintColor:[UIColor grayColor]];
    
    self.adMobView                    = [[GADBannerView alloc] init];
    self.adMobView.height             = 0;
    self.adMobView.delegate           = self;
    self.adMobView.adUnitID           = @"ca-app-pub-1525765559709019/9130686947";
    self.adMobView.rootViewController = self;
    self.adMobView.adSize             = kGADAdSizeSmartBannerPortrait;
    GADRequest *request = [GADRequest request];
#ifdef DEBUG
    request.testDevices = [NSArray arrayWithObjects:
                           GAD_SIMULATOR_ID,
                           nil];
#endif
    [self.adMobView loadRequest:request];
    self.adMobView.hidden = YES;
    [self.view addSubview:self.adMobView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUInteger itemCount = self.dataSource.count;
    self.dataSource = [NWPCard findAllSortedBy:@"orderNum" ascending:YES];
    if (self.dataSource.count != itemCount) {
        [self.collectionView reloadData];
    } else {
        for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
            [self configureCell:cell];
        }
    }
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];    
    [mixpanel track:@"card_list_view" properties:@{ @"card_num": @(self.dataSource.count) }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count + 1;
}

- (void)configureCell:(UICollectionViewCell*)cell cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.dataSource.count) return;
    
    NWPCard* card = self.dataSource[indexPath.item];
    
    NWPCardCell* _cell = (NWPCardCell*)cell;

    _cell.cardImageView.image = card.frontImage;
    
    [cell setNeedsDisplay];
}

- (void)configureCell:(UICollectionViewCell*)cell
{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    [self configureCell:cell cellForItemAtIndexPath:indexPath];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell;
    if (self.dataSource.count == indexPath.item) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        [self configureCell:cell cellForItemAtIndexPath:indexPath];
    }
    
    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (! [identifier isEqualToString:@"detail"]) {
        return YES;
    }
    
    UICollectionViewCell* cell = sender;
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    NWPCard* card = self.dataSource[indexPath.item];
    if (![card isSecretCardType]) {
        return YES;
    }
    
    NWPPasswordManager* passMgr = [NWPPasswordManager sharedInstance];
    
    
    if ([passMgr hasPassword]) {
        
        if (![passMgr isPassLocked]) {
            return YES;
        }

        [passMgr validPasswordFromViewController:self
                                           title:@"パスワード"
                                        animated:YES
                                         success:^{
                                             [self performSegueWithIdentifier:@"detail" sender:cell];
                                         }
                                          cancel:^{}];
    } else if (![passMgr recommendSetPass]) {

        passMgr.recommendSetPass = YES;
        
        UIAlertView* av = [[UIAlertView alloc] bk_initWithTitle:@"パスワード設定" message:@"免許、保険証、各種証明書、キャッシュカード、クレジットカード等はパスワードで保護することができます。パスワードを設定しますか？"];
        [av bk_setCancelButtonWithTitle:@"キャンセル" handler:^{
            [self performSegueWithIdentifier:@"detail" sender:cell];
        }];
        [av bk_addButtonWithTitle:@"登録する" handler:^{
            [passMgr registPasswordFromViewController:self
                                                title:@"パスワード登録"
                                             animated:YES
                                              success:^{
                                                  [self performSegueWithIdentifier:@"detail" sender:cell];
                                              }
                                               cancel:^{}];
        }];
        
        [av show];
    } else {
        [self performSegueWithIdentifier:@"detail" sender:cell];        
    }
    
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detail"]) {
        UICollectionViewCell* cell = sender;
        NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
        NWPCard* card = self.dataSource[indexPath.item];
        
        NWPCardDetailViewController* vc = [segue.destinationViewController viewControllers][0];
        vc.card = card;
    } else if ([segue.identifier isEqualToString:@"create"]) {
        [segue.destinationViewController setDelegate:self];
        [segue.destinationViewController setTransitioningDelegate:self];
    }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
{
    return [[NWPFadeInAnimationController alloc] init];
}
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[NWPFadeOutAnimationController alloc] init];
}


- (IBAction)tappedSettingButton:(id)sender {
}


#pragma mark - LXReorderableCollectionViewDelegateFlowLayout

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource.count == indexPath.item ? NO : YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    return self.dataSource.count == toIndexPath.item ? NO : YES;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NWPCard *card = [self.dataSource objectAtIndex:fromIndexPath.item];
    
    NSUInteger minIndex = MIN(fromIndexPath.item, toIndexPath.item);
    NSUInteger maxIndex = MAX(fromIndexPath.item, toIndexPath.item);
    
    NSUInteger orderNo = [[(NWPCard *) self.dataSource[ minIndex ] orderNum] integerValue];
    
    
    NSMutableArray *array = self.dataSource.mutableCopy;
    
    [array removeObjectAtIndex:fromIndexPath.item];
    [array insertObject:card atIndex:toIndexPath.item];
    
    self.dataSource = [NSArray arrayWithArray:array];
    
    for (int i = minIndex; i <= maxIndex; i++) {
        NWPCard *c = self.dataSource[ i ];
        c.orderNum = @(orderNo);
        orderNo++;
    }
    
    [[NSManagedObjectContext MR_defaultContext] saveToPersistentStoreAndWait];
}




#pragma mark -
#pragma mark admod

- (void)adViewDidReceiveAd:(GADBannerView *)banner
{
    LOGTrace;
    if (self.adMobIsVisible) { return; }
    
    self.adMobIsVisible = YES;
    
    self.adMobView.originY = self.view.height;
    self.adMobView.hidden  = NO;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.adMobView.originY -= self.adMobView.height;
                         self.settingButton.originY -= self.adMobView.height;
                     } completion:^(BOOL finished) {
                         UIEdgeInsets insets = self.collectionView.contentInset;
                         insets.bottom = +self.adMobView.height;
                         self.collectionView.contentInset = insets;
                         self.settingButtonBottomLayout.constant = self.adMobView.height;
                     }];
}

- (void)adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error
{
    LOGTrace;
    if (!self.adMobIsVisible) { return; }
    self.adMobIsVisible = NO;
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.adMobView.originY = self.view.height;
                         self.settingButton.originY += self.adMobView.height;
                     } completion:^(BOOL finished) {
                         self.adMobView.hidden = YES;
                         UIEdgeInsets insets = self.collectionView.contentInset;
                         insets.bottom = 0;
                         self.collectionView.contentInset = insets;
                         self.settingButtonBottomLayout.constant = 0;
                     }];
}


@end
