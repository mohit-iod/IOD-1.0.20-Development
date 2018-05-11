//
//  EditDoctorViewController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/3/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"
#import "StringPickerView.h"
#import "IODregisterView.h"
#import "MultiSelectTableView.h"

@interface EditDoctorViewController : ViewController


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
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtPinCode;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtExperince;
@property (weak, nonatomic) IBOutlet UITextField *txtLicence;
@property (weak, nonatomic) IBOutlet UITextField *txtDocs;
@property (weak, nonatomic) IBOutlet UITextField *txtDea;
@property (weak, nonatomic) IBOutlet UITextField *txtspecial;
@property (weak, nonatomic) IBOutlet UITextField *txtLicenseStates;

@property (weak, nonatomic) IBOutlet UITextView *txtViewAboutMe;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAdress;


@property (weak, nonatomic) IBOutlet IODregisterView *dea;
@property (weak, nonatomic) IBOutlet IODregisterView *state;


@property (nonatomic, weak) IBOutlet UIImageView *imgProfile;
@property (nonatomic, strong) StringPickerView *pickerView;
@property (nonatomic, strong) MultiSelectTableView *multiSelect;
@property (nonatomic, strong) UIView *datePickerView;
@end
