//
//  tabbarEdit.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/4/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "tabbarEdit.h"
#import "UIColor+HexString.h"
#import "PatientAppointService.h"
@interface tabbarEdit ()

@end

@implementation tabbarEdit
{
    UIView *vewSelect;
    PatientAppointService *patientService;
}

-(void)viewWillLayoutSubviews{
    self.tabBar.itemPositioning = UITabBarItemPositioningFill;
}

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    patientService = [PatientAppointService sharedManager];
    NSString *strSelectedTab = patientService.selectedTab;
    int tab = [strSelectedTab intValue];
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];
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
    
    
    //self.title=@"My Profile";
    vewSelect=[UIView new];
    [vewSelect setFrame: CGRectMake(0, 0, self.tabBar.frame.size.width/[[self.tabBar items] count], 2)];
    vewSelect.backgroundColor=[UIColor colorWithHexString:@"67E19D"];
    [self.tabBar addSubview:vewSelect];
    
    self.selectedViewController=[self.viewControllers objectAtIndex:tab];//or whichever index you want
    UITabBarItem *tabItem = [self.tabBar.items objectAtIndex:tab];
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
