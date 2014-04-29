// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to NWPCard.m instead.

#import "_NWPCard.h"

const struct NWPCardAttributes NWPCardAttributes = {
	.backImageFile = @"backImageFile",
	.barcodeType = @"barcodeType",
	.cardFormat = @"cardFormat",
	.cardName = @"cardName",
	.cardNo = @"cardNo",
	.cardType = @"cardType",
	.frontImageFile = @"frontImageFile",
	.orderNum = @"orderNum",
};

const struct NWPCardRelationships NWPCardRelationships = {
};

const struct NWPCardFetchedProperties NWPCardFetchedProperties = {
};

@implementation NWPCardID
@end

@implementation _NWPCard

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Card" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Card";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Card" inManagedObjectContext:moc_];
}

- (NWPCardID*)objectID {
	return (NWPCardID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"cardFormatValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"cardFormat"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"cardTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"cardType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"orderNumValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"orderNum"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic backImageFile;






@dynamic barcodeType;






@dynamic cardFormat;



- (int16_t)cardFormatValue {
	NSNumber *result = [self cardFormat];
	return [result shortValue];
}

- (void)setCardFormatValue:(int16_t)value_ {
	[self setCardFormat:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCardFormatValue {
	NSNumber *result = [self primitiveCardFormat];
	return [result shortValue];
}

- (void)setPrimitiveCardFormatValue:(int16_t)value_ {
	[self setPrimitiveCardFormat:[NSNumber numberWithShort:value_]];
}





@dynamic cardName;






@dynamic cardNo;






@dynamic cardType;



- (int16_t)cardTypeValue {
	NSNumber *result = [self cardType];
	return [result shortValue];
}

- (void)setCardTypeValue:(int16_t)value_ {
	[self setCardType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCardTypeValue {
	NSNumber *result = [self primitiveCardType];
	return [result shortValue];
}

- (void)setPrimitiveCardTypeValue:(int16_t)value_ {
	[self setPrimitiveCardType:[NSNumber numberWithShort:value_]];
}





@dynamic frontImageFile;






@dynamic orderNum;



- (int16_t)orderNumValue {
	NSNumber *result = [self orderNum];
	return [result shortValue];
}

- (void)setOrderNumValue:(int16_t)value_ {
	[self setOrderNum:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveOrderNumValue {
	NSNumber *result = [self primitiveOrderNum];
	return [result shortValue];
}

- (void)setPrimitiveOrderNumValue:(int16_t)value_ {
	[self setPrimitiveOrderNum:[NSNumber numberWithShort:value_]];
}










@end
