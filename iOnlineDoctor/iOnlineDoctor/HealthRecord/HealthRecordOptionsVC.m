//
//  HealthRecordOptionsVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "HealthRecordOptionsVC.h"

@interface HealthRecordOptionsVC ()

@end

@implementation HealthRecordOptionsVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Health Record";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)secondOpinionButtonPressed:(id)sender {
}

- (IBAction)eVisitButtonPressed:(id)sender {
    UIViewController *viewTab=[self.storyboard instantiateViewControllerWithIdentifier:@"E_VisitPage"];
    [self.navigationController pushViewController:viewTab animated:YES];
}
@end
