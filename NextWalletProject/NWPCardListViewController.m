//
//  NWPCardListViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/03/09.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardListViewController.h"

#import "NWPFadeAnimationController.h"

#import "NWPCardDetailViewController.h"
#import "NWPCardCell.h"

@interface NWPCardListViewController ()
<UICollectionViewDataSource, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic) NSArray* dataSource;

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
    
    self.collectionView.backgroundColor = BG_COLOR;
    
    
    self.dataSource = [NWPCard findAllSortedBy:@"orderNum" ascending:YES];
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


@end
