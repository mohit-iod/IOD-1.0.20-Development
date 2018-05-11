//
//  NoInternetVC.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 5/1/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "NoInternetVC.h"
#import "UIImage+GIF.h"

@interface NoInternetVC ()

@end

@implementation NoInternetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - IBAction Methods

- (IBAction)tryAgainClicked:(id)sender {
    self.view.transform = CGAffineTransformMakeTranslation(20, 0);
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:nil];
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
