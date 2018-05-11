//
//  ERXContainerInfoVC.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ERXContainerInfoVC.h"

@interface ERXContainerInfoVC ()

@end

@implementation ERXContainerInfoVC

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
    
    [self.delegateERX CancelSontainer];
}
- (IBAction)addClickAction:(id)sender {
    
    [self.delegateERX addPrecription:@{@"date":self.txtDat.text,@"medicine":self.txtMeds.text,@"strength":self.txtStength.text,@"quantity":self.txtQuantity.text ,@"direction":self.txtDIrection.text}];
}
@end
