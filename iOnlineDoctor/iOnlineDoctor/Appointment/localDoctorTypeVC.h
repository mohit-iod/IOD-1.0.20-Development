//
//  localDoctorTypeVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface localDoctorTypeVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblDoctors;
@property (weak, nonatomic) IBOutlet UILabel *lblLaw;
- (IBAction)btnNext:(id)sender;

@end
