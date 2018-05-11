//
//  UIView+viewUtils.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/3/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "UIView+viewUtils.h"

@implementation UIView (viewUtils)
- (NSMutableArray*)allSubViews
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    [arr addObject:self];
    for (UIView *subview in self.subviews)
    {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    return arr;
}
@end
