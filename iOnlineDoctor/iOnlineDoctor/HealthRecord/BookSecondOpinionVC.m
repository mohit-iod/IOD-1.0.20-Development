//
//  BookSecondOpinionVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BookSecondOpinionVC.h"
#import "TabbarCategoryViewController.h"
#import "InternationalDoctorTypeVC.h"
#import "localDoctorTypeVC.h"
#import "CommonServiceHandler.h"

@interface BookSecondOpinionVC ()<UITabBarControllerDelegate>
{
    UITabBar *tabbarVC;
    UITabBarController *tabbarController;
    localDoctorTypeVC * viewcontrollerLocal;
    InternationalDoctorTypeVC *viewcontrollerInternational;
}
@end

@implementation BookSecondOpinionVC
{
    UIColor *selectedColor;
}
@synthesize delegate;

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    [super viewDidLoad];
    [_segmentControl addTarget:self
                        action:@selector(segmentSwitch:)
              forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"ROBOTO" size:13], UITextAttributeFont,
                                [UIColor grayColor], NSForegroundColorAttributeName, nil];
    
    [_segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
     _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl setTintColor:[UIColor grayColor]];
    selectedColor = [UIColor lightGrayColor];
    _tblEVisit.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //NSLog(@"Tabbar items");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl sendActionsForControlEvents:UIControlEventValueChanged];
}



- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    if (selectedSegment == 0) {
        [viewcontrollerInternational willMoveToParentViewController:nil];  // 1
        [viewcontrollerInternational.view removeFromSuperview];
        [viewcontrollerInternational removeFromParentViewController];//this line is updated as view is removed from parent view cotnroller istead of its viewcontroller is removed from parentViewController
        viewcontrollerInternational = nil;
        
        viewcontrollerLocal = [self.storyboard instantiateViewControllerWithIdentifier:@"localDoctorTypeVC"];
        [viewcontrollerLocal willMoveToParentViewController:self];
        [self.containerView addSubview:viewcontrollerLocal.view];
        [self addChildViewController:viewcontrollerLocal];
        [viewcontrollerLocal didMoveToParentViewController:self];
    }
    else{
        [viewcontrollerLocal willMoveToParentViewController:nil];  // 1
        [viewcontrollerLocal.view removeFromSuperview];
        [viewcontrollerLocal removeFromParentViewController];//this line is updated as view is removed from parent view cotnroller istead of its viewcontroller is removed from parentViewController
        viewcontrollerLocal = nil;
        viewcontrollerInternational = [self.storyboard instantiateViewControllerWithIdentifier:@"InternationalDoctorTypeVC"];
        [viewcontrollerInternational willMoveToParentViewController:self];
        [self.containerView addSubview:viewcontrollerInternational.view];
        [self addChildViewController:viewcontrollerInternational];
        [viewcontrollerInternational didMoveToParentViewController:self];
    }
}

- (IBAction)localPressed:(id)sender {
}
@end

