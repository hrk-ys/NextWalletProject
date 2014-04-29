//
//  NWPCardCreateBaseViewController.h
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/26.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NWPCardCreateBaseViewControllerDelegate;
@interface NWPCardCreateBaseViewController : UIViewController

@property (nonatomic) NWPCard* card;
@property (nonatomic) NSManagedObjectContext* context;

@property (nonatomic) id<NWPCardCreateBaseViewControllerDelegate> delegate;

- (void)setupNextViewController:(UIViewController*)vc;

@end


@protocol NWPCardCreateBaseViewControllerDelegate <NSObject>

- (void)cardCreateViewControllerSuccess:(NWPCardCreateBaseViewController*)vc;

@end