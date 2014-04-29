//
//  NWPBarcodeImageView.m
//  NextWalletProject
//
//  Created by Hiroki Yoshifuji on 2014/04/26.
//  Copyright (c) 2014年 Hiroki Yoshifuji. All rights reserved.
//

#import "NWPBarcodeImageView.h"

@implementation NWPBarcodeImageView

- (void)setCard:(NWPCard *)card
{
    self.image = [card createBarcodeImage:self.size];
    
    if ([card isAceptFitImage]) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.layer.magnificationFilter = kCAFilterNearest;
    } else {
        self.contentMode = UIViewContentModeScaleToFill;
    }
}

@end
