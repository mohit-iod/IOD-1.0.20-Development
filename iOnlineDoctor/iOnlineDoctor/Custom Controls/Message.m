//
//  Message.m
//  STBubbleTableViewCellDemo
//
//  Created by Cedric Vandendriessche on 24/08/13.
//  Copyright 2013 FreshCreations. All rights reserved.
//

#import "Message.h"

@implementation Message

+ (instancetype)messageWithString:(NSString *)message
{
	return [Message messageWithString:message image:nil];
}

+ (instancetype)messageWithString:(NSString *)message image:(UIImage *)image
{
	return [[Message alloc] initWithString:message image:image];
}

+ (instancetype)messageWithString:(NSString *)message usertype:(NSString *)userType
{
    return [[Message alloc] initWithString:message userType:userType];
}
- (instancetype)initWithString:(NSString *)message
{
	return [self initWithString:message image:nil];
}

- (instancetype)initWithString:(NSString *)message image:(UIImage *)image
{
	self = [super init];
	if(self)
	{
		_message = message;
		_avatar = image;
	}
	return self;
}

- (instancetype)initWithString:(NSString *)message userType:(NSString *)userType
{
    self = [super init];
    if(self)
    {
        _message = message;
        _userType = userType;
    }
    return self;
}

@end
