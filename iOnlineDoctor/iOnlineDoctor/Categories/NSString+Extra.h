//
//  NSString+Extra.h
//  maxis

/*
 -----------------------------------------------------------------------------------------------------------------------------------------
 Copyright (c) 2015 Quix Creation Pte. Ltd. All Rights Reserved. This SOURCE CODE FILE, which has been provided by Quix as part of a
 Quix Creations product for use ONLY by licensed users of the product, includes CONFIDENTIAL and PROPRIETARY information of Quix Creations.
 
 USE OF THIS SOFTWARE IS GOVERNED BY THE TERMS AND CONDITIONS OF THE LICENSE STATEMENT AND LIMITED WARRANTY FURNISHED WITH THE PRODUCT.
 -----------------------------------------------------------------------------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>

@interface NSString (Extra)
- (BOOL)isVideo;
- (BOOL)isImage;
- (BOOL)isPdf;
-(BOOL)isPpt;
-(BOOL)isDoc;
-(BOOL)isXls;
- (NSData *) decodeFromHexidecimal;
- (NSString *)randomAlphanumericStringWithLength:(NSInteger)length;
- (NSRange)rangeOfStringNoCase:(NSString*)s;
@end
