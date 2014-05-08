#import "_NWPCard.h"



typedef NS_ENUM(NSInteger, NWPCardType) {
    NWPCardTypeLicense = 1,
    NWPCardTypeCredit  = 2,
    NWPCardTypeBarcode = 3,
    NWPCardTypeOther   = 0,
};




@interface NWPCard : _NWPCard {}
// Custom logic goes here.

+ (NSArray*)cardTypes;
+ (NSString*)cardTypeTitle:(NWPCardType)cardType;


@property (nonatomic, retain) UIImage *preFrontImage;
@property (nonatomic, retain) UIImage *preBackImage;


- (BOOL)isSecretCardType;

//------------------------------------------------------------------------------

- (void)storePreImage;
+ (NSString*)storePath;

- (UIImage *)frontImage;
- (NSString*)frontImagePath;
- (NSURL*)frontImageURL;

- (UIImage *)backImage;
- (NSString*)backImagePath;
- (NSURL*)backImageURL;

//------------------------------------------------------------------------------

+ (BOOL)enableBarcodeType:(NSString *)barcodeType;

- (UIImage *)createBarcodeImage:(CGSize)size;
- (BOOL)isAceptFitImage;

- (NSString*)displayBarcode;


@end
