//
//  NWPCardTypeCell.h
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/28.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NWPCardTypeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelOffset;

@end
