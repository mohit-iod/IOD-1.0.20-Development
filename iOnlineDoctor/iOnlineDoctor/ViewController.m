//
//  ViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/25/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"
#import "NSUserDefaults+AppDefaults.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Controller Methods

- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Termporary setting the user defaults login to 1
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setLoggedIn:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end
