//
//  labReportViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERXContainerInfoVC.h"
#import "StringPickerView.h"


@interface ERCViewController : UIViewController<delegateP,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consHeightSubmit;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *addReportBtn;
@property (weak, nonatomic) IBOutlet UITableView *tblReport;
@property (weak, nonatomic) IBOutlet UIView *viewReport;
- (IBAction)addPrescribAction:(id)sender;
- (IBAction)btnSubmitAction:(id)sender;
- (IBAction)btnAdd:(id)sender;
- (IBAction)btnCancelPrescribe:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtMeds;
@property (weak, nonatomic) IBOutlet UITextField *txtStength;
@property (weak, nonatomic) IBOutlet UITextField *txtUsage;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UITextField *txtRefill;
@property (weak, nonatomic) IBOutlet UITextField *txtDosage;
@property (weak, nonatomic) IBOutlet UITextField *txtDirection;
@property (weak, nonatomic) IBOutlet UITextField *txtAdditionalNotes;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UIView *viewLab;
@property (nonatomic, strong) StringPickerView *pickerView;
@property (nonatomic, strong) UIView *datePickerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewheight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonHeight;



@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocGender;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctSpecialise;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserGender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAge;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;

@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *dateAppnt;
@property (nonatomic, retain) NSString *doctorName;
@property (nonatomic, retain) NSString *doctorSpecialization;
@property (nonatomic, retain) NSString *doctorGender;
@property (nonatomic, retain) NSString *doctorProfile;


@property (weak, nonatomic) IBOutlet UIButton *btnBadge;
@property (weak, nonatomic) IBOutlet UIView *prescriptionListView;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end
