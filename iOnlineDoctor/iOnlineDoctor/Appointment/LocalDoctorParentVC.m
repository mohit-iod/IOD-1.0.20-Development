//
//  LocalDoctorParentVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "LocalDoctorParentVC.h"
#import "pageViewControllerVC.h"


@interface LocalDoctorParentVC ()

@end

@implementation LocalDoctorParentVC
- (void)viewDidAppear:(BOOL)animated
{
   
}
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    UIStoryboard *medicalInfoStoryBoard = [UIStoryboard storyboardWithName:@"MedicalInfo" bundle:nil];
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    pageViewControllerVC *pageVC=[self.storyboard instantiateViewControllerWithIdentifier:@"pageViewControllerVC"];
    pageVC.arrPageController=@[[mainSB instantiateViewControllerWithIdentifier:@"localDoctorTypeVC"],[medicalInfoStoryBoard instantiateViewControllerWithIdentifier:@"SelectPatientViewController"],[mainSB instantiateViewControllerWithIdentifier:@"UploadDocumentsViewController"],[mainSB instantiateViewControllerWithIdentifier:@"paymentViewController"],[mainSB instantiateViewControllerWithIdentifier:@"searchDoctorVC"]].mutableCopy;

    //pageVC.shouldScroll=YES;searchDoctorVC
    [self addChildViewController:pageVC];
    [[self view] addSubview:[pageVC view]];
    [pageVC didMoveToParentViewController:self];

    // [self.navigationController pushViewController:pageVC animated:YES];
    // Do any additional setup after loading the view.
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
