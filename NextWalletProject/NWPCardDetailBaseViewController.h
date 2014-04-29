//
//  NWPCardDetailBaseViewController.h
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/27.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWPCardDetailBaseViewController : UIViewController

@property (nonatomic) NWPCard* card;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;


@end
