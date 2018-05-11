//
//  labViewControllerDoc.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/24/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringPickerView.h"

@interface labViewControllerDoc : UIViewController<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *addReportBtn;
@property (weak, nonatomic) IBOutlet UITableView *tblLab;
@property (weak, nonatomic) IBOutlet UIView *viewReport;

@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txttest;
@property (weak, nonatomic) IBOutlet UITextField *txtDirection;
@property (weak, nonatomic) IBOutlet UITextView *txtvAdditionalNotes;
@property (weak, nonatomic) IBOutlet UIView *viewLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addButtonHeight;


@property (nonatomic, strong) StringPickerView *pickerView;
@property (nonatomic, strong) UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocGender;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctSpecialise;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserGender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAge;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;


@property (weak, nonatomic) IBOutlet UIButton *btnBadge;
@property (weak, nonatomic) IBOutlet UIView *labListView;


- (IBAction)addPrescribAction:(id)sender;
- (IBAction)btnSubmitAction:(id)sender;
- (IBAction)btnAdd:(id)sender;
- (IBAction)btnCancelPrescribe:(id)sender;
@end
