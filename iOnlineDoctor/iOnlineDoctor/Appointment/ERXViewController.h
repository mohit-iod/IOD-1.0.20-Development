//
//  ERXViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERXContainerInfoVC.h"

@interface ERXViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,delegateP>
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *addPrescription;
@property (weak, nonatomic) IBOutlet UITableView *tblPrestcriptions;
@property (weak, nonatomic) IBOutlet UIView *viewAddPrescribtion;
- (IBAction)addPrescribAction:(id)sender;
- (IBAction)btnSubmitAction:(id)sender;

@end
