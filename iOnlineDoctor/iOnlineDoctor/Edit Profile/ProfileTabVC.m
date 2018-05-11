//
//  ProfileTabVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/12/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ProfileTabVC.h"
#import "UIColor+HexString.h"

@interface ProfileTabVC ()

@end

@implementation ProfileTabVC

{
    UIView *vewSelect;
}
-(void)viewDidLayoutSubviews{
    self.tabBar.itemPositioning=UITabBarItemPositioningFill;
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    [super viewDidLoad];
    //    [[self.viewControllers objectAtIndex:0] setTitle: @"My Profile"];
    //    [[self.viewControllers objectAtIndex:1] setTitle: @"Add Member"];
    //    [[self.viewControllers objectAtIndex:2] setTitle: @"Payment Invoice"];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithHexString:@"82B8A1"], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Roboto-Black" size:15.0],
                                                       NSFontAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:@"Roboto-Black" size:15.5], NSFontAttributeName,
                                                       nil] forState:UIControlStateSelected];
    vewSelect=[UIView new];
    [vewSelect setFrame: CGRectMake(0, 0, self.tabBar.frame.size.width/[[self.tabBar items] count], 2)];
    vewSelect.backgroundColor=[UIColor colorWithHexString:@"67E19D"];
    [self.tabBar addSubview:vewSelect];
    
    self.selectedViewController=[self.viewControllers objectAtIndex:0];//or whichever index you want
    UITabBarItem *tabItem = [self.tabBar.items objectAtIndex:0];
    [self tabBar:self.tabBar didSelectItem:tabItem];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
