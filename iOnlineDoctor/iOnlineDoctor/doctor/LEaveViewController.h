//
//  LEaveViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/25/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEaveViewController : UIViewController


@property(nonatomic, weak) IBOutlet UITextField *txtReason1Date;
@property(nonatomic, weak) IBOutlet UITextField *txtReason2Date;
@property(nonatomic, weak) IBOutlet UITextField *txtReason3Date;
@property(nonatomic, weak) IBOutlet UITextView *txtvDiagnosis;
@property(nonatomic, weak) IBOutlet UITextField *lblDate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet UIView *topBar;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocGender;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctSpecialise;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserGender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAge;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;
@end

