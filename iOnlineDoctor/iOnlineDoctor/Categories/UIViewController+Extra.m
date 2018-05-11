//
//  UIViewController+Extra.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 5/3/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "UIViewController+Extra.h"
#import "FCAlertView.h"

@implementation UIViewController (Extra) 


-(void)showAlertWithoutButton{
    FCAlertView *alert = [[FCAlertView alloc] init]; // 2) Add This Where you Want to Create an FCAlertView
    
    alert.delegate = self; // 5) Add This is You Would like to Use Buttons without Action Blocks
    UIImage *alertImage = [UIImage imageNamed:@"LC.png"];
    NSMutableArray *arrayOfButtonTitles = @[@"First"];
    alert.avoidCustomImageTint = 1;
    alert.blurBackground = 1;
    alert.bounceAnimations = 1;
    alert.colorScheme = [self checkFlatColors:@"Green"];
    alert.subTitleColor = [self checkFlatColors:@"Green"];
    alert.titleColor = [self checkFlatColors:@"Green"];
    [alert showAlertInView:self
                 withTitle:@"test"
              withSubtitle:@"This is my alert's subtitle. Keep it short and concise."
           withCustomImage:alertImage
       withDoneButtonTitle:@"df"
                andButtons:nil];
}


- (UIColor *) checkFlatColors:(NSString *)selectedColor {
    
    FCAlertView *alert = [[FCAlertView alloc] init]; // Ignore This FCAlertView, simply initalized for colors here
    
    UIColor *color;
    
    if ([selectedColor isEqual:@"Turquoise"])
        color = alert.flatTurquoise;
    if ([selectedColor isEqual:@"Green"])
        color = alert.flatGreen;
    return color;
    
}

@end
