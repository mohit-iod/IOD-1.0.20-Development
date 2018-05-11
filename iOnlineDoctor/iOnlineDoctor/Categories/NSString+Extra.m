//
//  NSString+Extra.m
//  maxis

/*
 -----------------------------------------------------------------------------------------------------------------------------------------
 Copyright (c) 2015 Quix Creation Pte. Ltd. All Rights Reserved. This SOURCE CODE FILE, which has been provided by Quix as part of a
 Quix Creations product for use ONLY by licensed users of the product, includes CONFIDENTIAL and PROPRIETARY information of Quix Creations.
 
 USE OF THIS SOFTWARE IS GOVERNED BY THE TERMS AND CONDITIONS OF THE LICENSE STATEMENT AND LIMITED WARRANTY FURNISHED WITH THE PRODUCT.
 -----------------------------------------------------------------------------------------------------------------------------------------
 */

#import "NSString+Extra.h"

@implementation NSString (Extra)

- (BOOL)isVideo
{
    if ([self isEqualToString:@"mp4"] || [self isEqualToString:@"MP4"]  || [self isEqualToString:@"mov"] || [self isEqualToString:@"MOV"] )
        return YES;
    return NO;
}

- (BOOL)isPdf
{
    if ([self isEqualToString:@"pdf"] || [self isEqualToString:@"PDF"])
        return YES;
    return NO;
}


-(BOOL)isPpt{
    if ([self isEqualToString:@"ppt"]  || [self isEqualToString:@"PPT"] || [self isEqualToString:@"pptx"] || [self isEqualToString:@"PPTX"])
        return YES;
    return NO;
}

-(BOOL)isDoc{
    if ([self isEqualToString:@"doc"] || [self isEqualToString:@"DOC"] || [self isEqualToString:@"docx"] || [self isEqualToString:@"DOCX"])
        return YES;
    return NO;
}

-(BOOL)isXls{
    if ([self isEqualToString:@"xls"] || [self isEqualToString:@"XLS"] || [self isEqualToString:@"xlsx"] || [self isEqualToString:@"XLSX"])
        return YES;
    return NO;
}



- (BOOL)isImage
{
    if ([self isEqualToString:@"PNG"] ||[self isEqualToString:@"png"]  || [self isEqualToString:@"JPG"] ||  [self isEqualToString:@"jpg"]  || [self isEqualToString:@"gif"] || [self isEqualToString:@"GIF"] || [self isEqualToString:@"jpeg"] || [self isEqualToString:@"JPEG"] || [self isEqualToString:@"bmp"]  || [self isEqualToString:@"BMP"])
        return YES;
    return NO;
}

- (NSData *) decodeFromHexidecimal;
{
    return [[NSData alloc] initWithData:[self dataUsingEncoding:NSASCIIStringEncoding]];
}

- (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}


-(NSRange)rangeOfStringNoCase:(NSString*)s
{
    return  [self rangeOfString:s options:NSCaseInsensitiveSearch];
}
@end
