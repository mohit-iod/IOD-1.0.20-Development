//
//  RegisterPatientVCViewController.h
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
@interface RegisterPatientVCViewController : UIViewController<UIPageViewControllerDataSource,UITextFieldDelegate,StringPickerViewDelegate>
{
    UIDatePicker *datePicker;
}
@property (weak, nonatomic) IBOutlet UIButton *lblTermsAndCondition;
@property (weak, nonatomic) IBOutlet IODregisterView *state;

//Properties
@property (weak, nonatomic) IBOutlet UITextField *txtFullname;
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtPinCode;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (nonatomic, strong) StringPickerView *pickerView, *countryPicker;
@property (nonatomic, strong) UIView *datePickerView;
@property (nonatomic, strong) IBOutlet UICheckbox *checkbox;
@property (weak, nonatomic) IBOutlet UILabel *lblTerms;
@property (weak, nonatomic) IBOutlet UITextField *txtReferalCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;



//Actions
- (IBAction)btnActionSubmit:(id)sender;
- (IBAction)btnPrevious:(id)sender;
- (IBAction)btnNext:(id)sender;
@end
