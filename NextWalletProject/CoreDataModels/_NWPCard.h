// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NWPCard.h instead.

#import <CoreData/CoreData.h>


extern const struct NWPCardAttributes {
	__unsafe_unretained NSString *backImageFile;
	__unsafe_unretained NSString *barcodeType;
	__unsafe_unretained NSString *cardFormat;
	__unsafe_unretained NSString *cardName;
	__unsafe_unretained NSString *cardNo;
	__unsafe_unretained NSString *cardType;
	__unsafe_unretained NSString *frontImageFile;
	__unsafe_unretained NSString *orderNum;
} NWPCardAttributes;

extern const struct NWPCardRelationships {
} NWPCardRelationships;

extern const struct NWPCardFetchedProperties {
} NWPCardFetchedProperties;











@interface NWPCardID : NSManagedObjectID {}
@end

@interface _NWPCard : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (NWPCardID*)objectID;





@property (nonatomic, strong) NSString* backImageFile;



//- (BOOL)validateBackImageFile:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* barcodeType;



//- (BOOL)validateBarcodeType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* cardFormat;



@property int16_t cardFormatValue;
- (int16_t)cardFormatValue;
- (void)setCardFormatValue:(int16_t)value_;

//- (BOOL)validateCardFormat:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cardName;



//- (BOOL)validateCardName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* cardNo;



//- (BOOL)validateCardNo:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* cardType;



@property int16_t cardTypeValue;
- (int16_t)cardTypeValue;
- (void)setCardTypeValue:(int16_t)value_;

//- (BOOL)validateCardType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* frontImageFile;



//- (BOOL)validateFrontImageFile:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* orderNum;



@property int16_t orderNumValue;
- (int16_t)orderNumValue;
- (void)setOrderNumValue:(int16_t)value_;

//- (BOOL)validateOrderNum:(id*)value_ error:(NSError**)error_;






@end

@interface _NWPCard (CoreDataGeneratedAccessors)

@end

@interface _NWPCard (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBackImageFile;
- (void)setPrimitiveBackImageFile:(NSString*)value;




- (NSString*)primitiveBarcodeType;
- (void)setPrimitiveBarcodeType:(NSString*)value;




- (NSNumber*)primitiveCardFormat;
- (void)setPrimitiveCardFormat:(NSNumber*)value;

- (int16_t)primitiveCardFormatValue;
- (void)setPrimitiveCardFormatValue:(int16_t)value_;




- (NSString*)primitiveCardName;
- (void)setPrimitiveCardName:(NSString*)value;




- (NSString*)primitiveCardNo;
- (void)setPrimitiveCardNo:(NSString*)value;




- (NSNumber*)primitiveCardType;
- (void)setPrimitiveCardType:(NSNumber*)value;

- (int16_t)primitiveCardTypeValue;
- (void)setPrimitiveCardTypeValue:(int16_t)value_;




- (NSString*)primitiveFrontImageFile;
- (void)setPrimitiveFrontImageFile:(NSString*)value;




- (NSNumber*)primitiveOrderNum;
- (void)setPrimitiveOrderNum:(NSNumber*)value;

- (int16_t)primitiveOrderNumValue;
- (void)setPrimitiveOrderNumValue:(int16_t)value_;




@end
