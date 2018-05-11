//
//  UIColor+HexString.m
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/22/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//
#import "UIColor+HexString.h"

@implementation UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)hexStr
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:1.0];
    
    return color;
}

+ (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}

+ (UIColor *)colorWithHexRGB:(NSString *)string
{
    unsigned int rgbValue;
    NSScanner *scanner = [NSScanner scannerWithString:[string stringByReplacingOccurrencesOfString:@"#" withString:@"0x"]];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:(((rgbValue & 0xFF0000) >> 16))/255.0
                           green:(((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((rgbValue & 0xFF))/255.0
                           alpha:1.0];
}


@end
