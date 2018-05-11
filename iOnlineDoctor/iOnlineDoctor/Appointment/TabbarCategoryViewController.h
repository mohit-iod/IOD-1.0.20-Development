//
//  TabbarCategoryViewController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/18/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookSecondOpinionVC.h"

@interface TabbarCategoryViewController : UITabBarController<CustomDelegate>
- (void)settabbarIndex:(int) index;

@end

