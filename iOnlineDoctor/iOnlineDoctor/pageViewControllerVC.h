//
//  pageViewControllerVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pageViewControllerVC : UIViewController<UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *arrPageController;

-(void)selectPage:(NSInteger )page;

@end
