//
//  NWPCardTypeSelectViewController.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/03/10.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPCardTypeSelectViewController.h"
#import "NWPCard.h"
#import "NWPCardTypeCell.h"

#import "NWPCardBarcodeReaderViewController.h"
#import "NWPCardCaptureViewController.h"


@interface NWPCardTypeSelectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray* dataSource;

@property (nonatomic) BOOL isFirstView;

@end

@implementation NWPCardTypeSelectViewController

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
    
    self.title = @"カードタイプ選択";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close:)];

    self.view.backgroundColor = BG_COLOR;
    
    self.context = [NSManagedObjectContext context];
    self.card = [NWPCard createInContext:self.context];
    self.card.orderNum = @([[NWPCard MR_aggregateOperation:@"max:" onAttribute:@"orderNum" withPredicate:nil inContext:self.context] integerValue] + 1);
    
    NSMutableArray* array = @[].mutableCopy;
    for (NSNumber* n in [NWPCard cardTypes]) {
        [array addObject:@{
                          @"title": [NWPCard cardTypeTitle:n.integerValue],
                          @"type": n}];
    }
    _dataSource = [NSArray arrayWithArray:array];
    
    self.tableView.rowHeight = (self.view.height - 64) / _dataSource.count;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"card_create_type_select"];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    

}

- (void)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NWPCardTypeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.titleLabel.text = _dataSource[indexPath.row][@"title"];
//    cell.labelOffset.constant = 60.0f + indexPath.row * 20.0f;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
//                   dispatch_get_main_queue(), ^{
//                       [UIView animateKeyframesWithDuration:.3+0.08*indexPath.row
//                                                      delay:0.0f
//                                                    options:0
//                                                 animations:^{
//                                                     cell.titleLabel.originX = 20.0f;
//                                                 }
//                                                 completion:^(BOOL finished) {
//                                                 }];
//    });

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* cardType = _dataSource[indexPath.row];
    self.card.cardType = cardType[@"type"];
    
    [self.delegate cardCreateViewControllerSuccess:self];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
