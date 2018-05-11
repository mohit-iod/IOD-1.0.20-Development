//
//  InternationalDoctorParentVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/18/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "InternationalDoctorParentVC.h"
#import "pageViewControllerVC.h"
#import "InternationalDoctorTypeVC.h"
@interface InternationalDoctorParentVC ()

@end

@implementation InternationalDoctorParentVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageViewControllerVC *pageVC=[self.storyboard instantiateViewControllerWithIdentifier:@"pageViewControllerVC"];
    pageVC.arrPageController=@[[self.storyboard instantiateViewControllerWithIdentifier:@"localDoctorTypeVC"],[self.storyboard instantiateViewControllerWithIdentifier:@"medicalInfoMainVC"],[self.storyboard instantiateViewControllerWithIdentifier:@"UploadDocumentsViewController"],[self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"],[self.storyboard instantiateViewControllerWithIdentifier:@"searchDoctorVC"]].mutableCopy;
    //pageVC.shouldScroll=YES;
    [self addChildViewController:pageVC];
    [[self view] addSubview:[pageVC view]];
    [pageVC didMoveToParentViewController:self];
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
