//
//  InternationalDoctorTypeVCViewController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/18/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternationalDoctorTypeVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tblDoctors;
@property (weak, nonatomic) IBOutlet UILabel *lblLaw;
- (IBAction)btnNext:(id)sender;
@end
