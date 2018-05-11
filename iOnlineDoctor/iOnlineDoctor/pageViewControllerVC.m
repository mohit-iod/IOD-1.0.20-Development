//
//  pageViewControllerVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "pageViewControllerVC.h"
#import "RegisterPageDoctorController.h"

@interface pageViewControllerVC () <UIPageViewControllerDelegate>

@end

@implementation pageViewControllerVC
{
    NSMutableArray *pageViewControllers;
    //NSInteger index;
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    pageViewControllers=[NSMutableArray new];
     self.navigationItem.leftBarButtonItem=nil;
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPage:) name:@"ForceUpdateLocation" object:nil];
  [[self navigationController] setNavigationBarHidden:NO animated:NO];
    for (int i=0; i<self.arrPageController.count; i++) {
  
        [pageViewControllers addObject:@{@"Page":(UIViewController *)[self.arrPageController objectAtIndex:i],@"PageNumber":[NSString stringWithFormat:@"%d",i]}];
    }
    //pageViewControllers=[NSMutableArray arrayWithObjects:doctPage1,doctPage2,doctPage3, nil];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterPageController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate=self;
    RegisterPageDoctorController *startingViewController = [[pageViewControllers objectAtIndex:0] objectForKey:@"Page"];
    NSArray *viewControllers = @[startingViewController];
       self.title=startingViewController.title;
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    self.pageViewController.dataSource=nil;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews{
    RegisterPageDoctorController *startingViewController = [[pageViewControllers objectAtIndex:0] objectForKey:@"Page"];
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}
- (UIViewController *)viewControllerAtIndex:(NSUInteger)indexpage
{
    if (([pageViewControllers count] == 0) || (indexpage >= [pageViewControllers count])) {
        return nil;
    }
  self.title=[[[pageViewControllers objectAtIndex:indexpage] objectForKey:@"Page"]title];
    return [[pageViewControllers objectAtIndex:indexpage] objectForKey:@"Page"];
}

- (void)setPage:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    RegisterPageDoctorController *startingViewController = [[pageViewControllers objectAtIndex:[[dict valueForKey:@"pnumb"]integerValue] ] objectForKey:@"Page"];
    self.title=startingViewController.title;
    
    if ([[dict valueForKey:@"direction"] isEqualToString:kNext]) {
        [self.pageViewController setViewControllers:@[startingViewController ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    else{
        [self.pageViewController setViewControllers:@[startingViewController ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
      self.title=startingViewController.title;
}

-(void)selectPage:(NSInteger )page;
{

    [self.pageViewController setViewControllers:@[[pageViewControllers objectAtIndex:page]  ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    //   NSInteger index = [pageViewControllers indexOfObject:viewController];
  // NSUInteger index = ((RegisterPageDoctorController *) viewController).pageIndex;
    NSUInteger index=0;
    for (NSDictionary *dict in pageViewControllers) {
        if ([dict objectForKey:@"Page"]==viewController) {
            index=[[dict objectForKey:@"PageNumber"] integerValue];
        }
    }
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
   // NSInteger index = [pageViewControllers indexOfObject:viewController];
     NSUInteger index=0;
    //   NSUInteger index = ((RegisterPageDoctorController *) viewController).pageIndex;
    for (NSDictionary *dict in pageViewControllers) {
        if ([dict objectForKey:@"Page"]==viewController) {
            index=[[dict objectForKey:@"PageNumber"] integerValue];
        }
    }
    if (index == [pageViewControllers count]-1) {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index];
}
@end
