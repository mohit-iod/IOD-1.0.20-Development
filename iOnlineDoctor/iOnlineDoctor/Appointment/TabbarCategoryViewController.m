//
//  TabbarCategoryViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/18/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "TabbarCategoryViewController.h"
#import "UIColor+HexString.h"

@interface TabbarCategoryViewController ()

@end

@implementation TabbarCategoryViewController
{
    UIView *vewSelect;
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.title=@"Select Specialization";
    BookSecondOpinionVC *bookVC = [[BookSecondOpinionVC alloc] init];
    bookVC.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveSelectedTabNotification:)
                                                 name:@"SelectedTabNotification"
                                               object:nil];
    
  //  self.title = @"Categories";
     [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithHexString:@"82B8A1"], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Roboto-Black" size:13.0],
                                                       NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
        
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Roboto-Black" size:13.5], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
    vewSelect=[UIView new];
    [vewSelect setFrame: CGRectMake(0, 0, self.tabBar.frame.size.width/[[self.tabBar items] count], 2)];
    vewSelect.backgroundColor=[UIColor colorWithHexString:@"67E19D"];
    [self.tabBar addSubview:vewSelect];
}
-(void)viewWillLayoutSubviews{
    self.tabBar.itemPositioning = UITabBarItemPositioningFill;
}

- (void) receiveSelectedTabNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"SelectedTabNotification"]){
        //NSLog (@"Successfully received the notification!");
        NSDictionary *userInfo = notification.userInfo;
        NSInteger index = [[userInfo valueForKey:@"selectedTab"] integerValue];
        UITabBarItem *tabItem = [self.tabBar.items objectAtIndex:index];
        [self tabBar:self.tabBar didSelectItem:tabItem];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger widthItem=self.tabBar.frame.size.width/[[tabBar items] count];
    [UIView transitionWithView:vewSelect
                      duration:0.1
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [vewSelect setFrame: CGRectMake(widthItem*[[tabBar items]indexOfObject:item], 0, widthItem, 3)];
                    }
                    completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewWillLayoutSubviews{
//    self.tabBar.itemPositioning = UITabBarItemPositioningFill;
//}

- (void)settabbarIndex:(int) index {
   // [self.tabBar setSelectedItem: [self.tabBar.items objectAtIndex:1]];

    [(UITabBarController*)self.navigationController.topViewController setSelectedIndex:1];

}

-(void)setSelectedTabIndex:(int)index{
  
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
