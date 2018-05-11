//
//  PatientEvisitDetailViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/3/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "PatientEvisitDetailViewController.h"
#import "TabbarCategoryViewController.h"

@interface PatientEvisitDetailViewController (){
    UITabBar *tabbarVC;
}
@end

@implementation PatientEvisitDetailViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    [super viewDidLoad];
    
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
