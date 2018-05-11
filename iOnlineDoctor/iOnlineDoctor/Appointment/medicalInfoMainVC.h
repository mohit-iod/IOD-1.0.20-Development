//
//  medicalInfoMainVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/8/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "medicalnfoCell.h"
#import "StringPickerView.h"


#import "MedicalInfoDropDownVIews.h"

@interface medicalInfoMainVC : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,delegateMedXib>
@property (weak, nonatomic) IBOutlet UITextView *txtViewCHange;
@property (weak, nonatomic) IBOutlet UITableView *tblReferalDoc;
@property (weak, nonatomic) IBOutlet UITableView *tblExistingMember;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UITextView *txtCurrentMeds;
@property (weak, nonatomic) IBOutlet UITextView *txtAllergies;
@property (weak, nonatomic) IBOutlet UITextView *txtDiagnose;
@property (weak, nonatomic) IBOutlet UITextField *txtReferralDoctor;

@property (weak, nonatomic) IBOutlet UITextField *txtbodyTemparature;
@property (weak, nonatomic) IBOutlet UITextField *txtBloodPressure;
@property (weak, nonatomic) IBOutlet UITextField *txtBloodPressure2;

@property (weak, nonatomic) IBOutlet UITextField *txtPulseRate;
@property (weak, nonatomic) IBOutlet UITextField *txtRespiratoryRate;
@property (weak, nonatomic) IBOutlet UITextField *txtBloodGlucose;
@property (weak, nonatomic) IBOutlet UITextField *txtExistingMember;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtDOB;
@property (weak, nonatomic) IBOutlet UITextField *txtGender;

@property (weak, nonatomic) IBOutlet UICollectionView *membersCollectionView;


@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *ButtonArray;

@property (nonatomic, strong) StringPickerView *pickerView;
@property (nonatomic, strong) UIView *datePickerView;
@end
