//
//  NSData+Extention.m
//  Pods
//
//  Created by Hiroki Yoshifuji on 2014/07/20.
//
//

#import "NSData+Extention.h"

@implementation NSData (Extention)

- (NSString *)stringHexEncoding
{
    NSUInteger      length  = [self length];
    unsigned char  *bytes   = (unsigned char *) [self bytes];
    NSMutableArray *builder = [NSMutableArray array];
    for (int i = 0; i < length; i++) {
        [builder addObject:[NSString stringWithFormat:@"%02x", bytes[i]]];
    }
    
    return [builder componentsJoinedByString:@""];
}

@end
