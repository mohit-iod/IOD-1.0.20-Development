//
//  IODTextField.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "IODTextField.h"

@implementation IODTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)drawRect:(CGRect)rect
{

    //Get the current drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Set the line color and width
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 0.5f);
    //Start a new Path
    CGContextBeginPath(context);
    
    // offset lines up - we are adding offset to font.leading so that line is drawn right below the characters and still characters are visible.
    CGContextMoveToPoint(context, self.bounds.origin.x, self.font.leading + 20.0f);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.font.leading + 20.0f);
    
    //Close our Path and Stroke (draw) it
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    [self setIconImage];
    
}

-(void)setIconImage {
    UIImageView *imgforLeft=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)]; // Set frame as per space required around icon
    [imgforLeft setImage:[UIImage imageNamed:@"Forgot-pw.png"]];
    
    [imgforLeft setContentMode:UIViewContentModeCenter];// Set content mode centre or fit
    
    self.leftView=imgforLeft;
    self.leftViewMode=UITextFieldViewModeAlways;

}


@end
