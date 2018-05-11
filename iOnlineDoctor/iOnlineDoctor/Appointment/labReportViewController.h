//
//  labReportViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "labReportContainerVC.h"
@interface labReportViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *addReportBtn;
@property (weak, nonatomic) IBOutlet UITableView *tblReport;
@property (weak, nonatomic) IBOutlet UIView *viewReport;

@end
