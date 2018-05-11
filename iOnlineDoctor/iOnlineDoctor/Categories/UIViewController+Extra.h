//
//  UIViewController+Extra.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 5/3/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCAlertView.h"
@interface UIViewController (Extra) <FCAlertViewDelegate>
-(void)showAlertWithoutButton;

@end
