#import "NWPCard.h"

#import "NKDBarcodeFramework.h"
#import <ZXingObjC.h>




@interface NWPCard ()
{
    UIImage *_frontImage;
    UIImage *_backImage;
    
    UIImage *_preFrontImage;
    UIImage *_preBackImage;
}
// Private interface goes here.

@end


@implementation NWPCard

- (void)didTurnIntoFault
{
    _frontImage = nil;
    _backImage  = nil;
}

// Custom logic goes here.
@synthesize preFrontImage = _preFrontImage;
@synthesize preBackImage  = _preBackImage;


#pragma mark - card type

+ (NSArray*)cardTypes {
    return @[ @(NWPCardTypeLicense), @(NWPCardTypeCredit), @(NWPCardTypeBarcode), @(NWPCardTypeOther) ];
}
+ (NSString*)cardTypeTitle:(NWPCardType)cardType {
    switch (cardType) {
        case NWPCardTypeLicense:
            return @"免許、保険証、各種証明書";
        case NWPCardTypeCredit:
            return @"キャッシュカード、クレジットカード";
        case NWPCardTypeBarcode:
            return @"バーコード式カード";
        case NWPCardTypeOther:
            return @"その他のカード";
        default:
            break;
    }
    return @"";
}

#pragma mark - file management

+ (NSString *)storePath
{
    static dispatch_once_t onceToken;
    static NSString       *directory;
    dispatch_once(&onceToken, ^{
        directory = [NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES)
                     objectAtIndex:0];
        
        directory = [directory stringByAppendingPathComponent:@"images"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) { DDLogCError(@"Error:%@", error); }
        }
    });
    
    return directory;
}

+ (void)writeImage:(UIImage *)image toImagePath:(NSString *)imagePath
{
    NSData   *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.8)];
    NSString *filePath  = [[self.class storePath] stringByAppendingPathComponent:imagePath];
    [imageData writeToFile:filePath atomically:YES];
}

+ (void)removeImagePath:(NSString *)imagePath
{
    NSString      *path  = [[self storePath] stringByAppendingPathComponent:imagePath];
    NSFileManager *fm    = [NSFileManager defaultManager];
    NSError       *error = nil;
    [fm removeItemAtPath:path error:&error];
    if (error) { DDLogCError(@"Error:%@", error); }
}

#pragma mark - image management

- (void)storePreImage
{
    if (self.preFrontImage) {
        if (self.frontImageFile) {
            [self.class removeImagePath:self.frontImageFile];
        }
        
        self.frontImageFile = S(@"front-%@.jpg", [[NSUUID UUID] UUIDString]);
        
        [self.class writeImage:self.preFrontImage toImagePath:self.frontImageFile];
        
        _frontImage = self.preFrontImage;
    }
    
    if (self.preBackImage) {
        if (self.backImageFile) {
            [self.class removeImagePath:self.backImageFile];
        }
        
        self.backImageFile = S(@"back-%@.jpg", [[NSUUID UUID] UUIDString]);
        
        [self.class writeImage:self.preBackImage toImagePath:self.backImageFile];
        
        _backImage = self.preBackImage;
    }
}

- (UIImage *)frontImage
{
    if  (self.frontImageFile && !_frontImage) {
        NSString *filePath = [self frontImagePath];
        _frontImage = [[UIImage alloc] initWithContentsOfFile:filePath];
    }
    
    return _frontImage;
}

- (NSString *)frontImagePath
{
    return [[self.class storePath] stringByAppendingPathComponent:self.frontImageFile];
}

- (NSURL *)frontImageURL
{
    return [NSURL fileURLWithPath:self.frontImagePath];
}

- (UIImage *)backImage
{
    if  (self.backImageFile && !_backImage) {
        NSString *filePath = [self backImagePath];
        _backImage = [[UIImage alloc] initWithContentsOfFile:filePath];
    }
    
    return _backImage;
}

- (NSString *)backImagePath
{
    return [[self.class storePath] stringByAppendingPathComponent:self.backImageFile];
}

- (NSURL *)backImageURL
{
    return [NSURL fileURLWithPath:self.backImagePath];
}


- (UIImage *)createBarcodeImage:(CGSize)size
{
    if (self.barcodeType) {
        NSDictionary *cardTypeMaster = [[self.class barcodeTypes] objectForKey:self.barcodeType];
        
        if ([cardTypeMaster enableValue:@"format"]) {
            ZXBarcodeFormat format = [cardTypeMaster[@"format"] integerValue];
            
            NSString *barcode = self.cardNo;
            if (format == kBarcodeFormatCodabar) {
                barcode = self.cardNo;
                if ([barcode hasSuffix:@"A"]) { barcode = S(@"%@T", [barcode substringToIndex:barcode.length - 1]); }
                if ([barcode hasSuffix:@"B"]) { barcode = S(@"%@N", [barcode substringToIndex:barcode.length - 1]); }
                if ([barcode hasSuffix:@"C"]) { barcode = S(@"%@*", [barcode substringToIndex:barcode.length - 1]); }
                if ([barcode hasSuffix:@"D"]) { barcode = S(@"%@E", [barcode substringToIndex:barcode.length - 1]); }
            }
            
            if (format == kBarcodeFormatQRCode) {
                size.width  = 500;
                size.height = 500;
            }
            
            NSError             *error  = nil;
            ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
            ZXBitMatrix         *result = [writer encode:barcode
                                                  format:format
                                                   width:size.width / 2
                                                  height:size.height / 2
                                                   error:&error];
            if (result) {
                CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
                
                return [UIImage imageWithCGImage:image];
            }
        }
        
        if ([self.barcodeType isEqualToString:@"QR-Code"]) {
            // QRコード作成用のフィルターを作成・パラメータの初期化
            CIFilter *ciFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            [ciFilter setDefaults];
            
            // 格納する文字列をNSData形式（UTF-8でエンコード）で用意して設定
            NSString *qrString = self.cardNo;
            NSData   *data     = [qrString dataUsingEncoding:NSUTF8StringEncoding];
            [ciFilter setValue:data forKey:@"inputMessage"];
            
            // 誤り訂正レベルを「L（低い）」に設定
            [ciFilter setValue:@"L" forKey:@"inputCorrectionLevel"];
            
            // Core Imageコンテキストを取得したらCGImage→UIImageと変換して描画
            CIContext *ciContext = [CIContext contextWithOptions:nil];
            CGImageRef cgimg     =
            [ciContext createCGImage:[ciFilter outputImage]
                            fromRect:[[ciFilter outputImage] extent]];
            UIImage *image = [UIImage imageWithCGImage:cgimg scale:1.0f
                                           orientation:UIImageOrientationUp];
            CGImageRelease(cgimg);
            
            return image;
        } else {
            NKDBarcode *code = nil;
            
            Class nkdBarcode = cardTypeMaster[@"generator"];
            
            code = [[nkdBarcode alloc] initWithContent:self.cardNo
                                         printsCaption:NO
                                           andBarWidth:4                                                                                             // .013 * kScreenResolution
                                             andHeight:size.height                                                                                                    // 5 * kScreenResolution
                                           andFontSize:4
                                         andCheckDigit:(char) -1];
            
            UIImage *generatedImage = [UIImage imageFromBarcode:code];     // ..or as a less accurate UIImage
            return generatedImage;
        }
//    } else {
//        // ZXing専用
//        NSError             *error  = nil;
//        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
//        ZXBitMatrix         *result = [writer encode:self.barcode
//                                              format:self.barcodeFormatValue
//                                               width:500
//                                              height:500
//                                               error:&error];
//        if (result) {
//            CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
//            
//            return [UIImage imageWithCGImage:image];
//        }
    }
    
    return nil;
}


#pragma mark - propaty

+ (BOOL)enableBarcodeType:(NSString *)cardType
{
    if ([[self barcodeTypes] objectForKey:cardType]) {
        return YES;
    }
    
    return NO;
}


+ (NSDictionary*)barcodeTypes {
    static dispatch_once_t onceToken;
    static NSDictionary   *cardTypes;
    dispatch_once(&onceToken, ^{
        cardTypes = @{
                      @"EAN-8":   @{
                              @"generator": [NKDEAN8Barcode    class]
                              /*, @"format": @(kBarcodeFormatEan8)*/ },
                      @"EAN-13":  @{
                              @"generator": [NKDEAN13Barcode   class],
                              @"format": @(kBarcodeFormatEan13)
                              },
                      @"CODE-128": @{
                              @"generator": [NKDCode128Barcode class],
                              @"format": @(kBarcodeFormatCode128) },
                      @"Codabar": @{
                              @"generator": [NKDCodabarBarcode class],
                              @"format": @(kBarcodeFormatCodabar)
                              },
                      @"CODE-39": @{
                              @"generator": [NKDCode39Barcode  class]
                              /*, @"format": @(kBarcodeFormatCode39)*/ },
                      @"I2/5":    @{
                              @"generator": [NKDIndustrialTwoOfFiveBarcode class],
                              },
                      @"UPC-A":   @{
                              @"generator": [NKDUPCABarcode class],
                              @"format": @(kBarcodeFormatUPCA)
                              },
                      @"QR-Code": @{
                              @"format": @(kBarcodeFormatQRCode)
                              },
                      @"UPC-E":   @{
                              @"generator": [NKDUPCEBarcode class],
                              },
                      };
    });
    
    return cardTypes;
}

- (NSInteger)barcodeFormatValue {
    return 0;
}

- (BOOL)isAceptFitImage
{
    if (self.cardFormatValue == kBarcodeFormatQRCode) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)arrayContains:(char *)array length:(unsigned int)length key:(unichar)key
{
    if (array != nil) {
        for (int i = 0; i < length; i++) {
            if (array[i] == key) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSString *)displayBarcode
{
    if (self.cardFormatValue == kBarcodeFormatCodabar) {
        NSMutableString *str = [NSMutableString stringWithString:self.cardNo];
        
        if ([self.class arrayContains:(char *) "ABCD" length:4 key:[[str uppercaseString] characterAtIndex:0]]) {
            [str deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        
        if ([self.class arrayContains:(char *) "ABCD" length:4 key:[[str uppercaseString] characterAtIndex:str.length - 1]]) {
            [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
        }
        
        return str;
    }
    
    return self.cardNo;
}



@end
