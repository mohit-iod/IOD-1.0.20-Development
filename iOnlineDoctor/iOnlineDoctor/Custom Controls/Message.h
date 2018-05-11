//
//  Message.h
//  STBubbleTableViewCellDemo
//
//  Created by Cedric Vandendriessche on 24/08/13.
//  Copyright 2013 FreshCreations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

+ (instancetype)messageWithString:(NSString *)message;
+ (instancetype)messageWithString:(NSString *)message image:(UIImage *)image;
+ (instancetype)messageWithString:(NSString *)message usertype:(NSString *)userType;

- (instancetype)initWithString:(NSString *)message;
- (instancetype)initWithString:(NSString *)message image:(UIImage *)image;
- (instancetype)initWithString:(NSString *)message userType:(NSString *)userType;


@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *userType;

@property (nonatomic, strong) UIImage *avatar;

@end