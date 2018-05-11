//
//  RegisterPageDoctorController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterPageController.h"
#import "StringPickerView.h"
#import "UICheckbox.h"
#import "IODregisterView.h"
#import "MultiSelectTableView.h"

@interface RegisterPageDoctorController : UIViewController<UIPageViewControllerDataSource,UITextFieldDelegate>
@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIButton *lblConditions;


@property (weak, nonatomic) IBOutlet IODregisterView *licenseState;
@property (weak, nonatomic) IBOutlet IODregisterView *dea;


@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;
@property (weak, nonatomic) IBOutlet UITextField *txtregistration;
@property (weak, nonatomic) IBOutlet UITextField *txtHighestQualificaion;
@property (weak, nonatomic) IBOutlet UITextField *txtQualificationyear;
@property (weak, nonatomic) IBOutlet UITextField *txtUnitversity;
@property (weak, nonatomic) IBOutlet UITextField *txtAdditionalQualification;
@property (weak, nonatomic) IBOutlet UITextField *txtSpecialization;
@property (weak, nonatomic) IBOutlet UITextField *txtLanguageKnown;
@property (weak, nonatomic) IBOutlet UITextField *txtgender;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAdress;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtPinCode;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;

@property (weak, nonatomic) IBOutlet UITextField *txtExperince;
@property (weak, nonatomic) IBOutlet UITextField *txtLicence;
@property (weak, nonatomic) IBOutlet UITextField *txtDocs;
@property (weak, nonatomic) IBOutlet UITextField *txtDea;
@property (weak, nonatomic) IBOutlet UILabel *lblTerms;
@property (weak, nonatomic) IBOutlet UITextField *txtspecial;
@property (weak, nonatomic) IBOutlet UITextField *txtLicenseStates;
@property (weak, nonatomic) IBOutlet UITextField *txtReferalCode;

@property (weak, nonatomic) IBOutlet UIButton *lblTermsAndCondition;

@property (nonatomic, strong) StringPickerView *pickerView, *countryPicker;
@property (nonatomic, strong) MultiSelectTableView * multiSelect;
@property (nonatomic, strong) UIView *datePickerView, *yearPickerView;
@property (nonatomic, strong) IBOutlet UICheckbox *checkbox;
@property (nonatomic, weak) IBOutlet UIView *documentView;

- (IBAction)nextPage1:(id)sender;
- (IBAction)btnNextPage2:(id)sender;
- (IBAction)btnBackPage2:(id)sender;
- (IBAction)btnSubmit:(id)sender;
- (IBAction)btnBackPage3:(id)sender;

@end
