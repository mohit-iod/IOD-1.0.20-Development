//
//  addMemberRegisterVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringPickerView.h"

@interface addMemberRegisterVC : UIViewController
@property (nonatomic, strong) StringPickerView *pickerView;
@property (nonatomic, strong) UIView *datePickerView;
@property (nonatomic, strong) IBOutlet UITextField *txtDOB;
@property (nonatomic, strong) IBOutlet UITextField *txtfullName;
@property (nonatomic, strong) IBOutlet UITextField *txtGender;
@property (nonatomic, strong) IBOutlet UITextField *txtEmail;
@property (nonatomic, strong) IBOutlet UITextField *txtPhone;
@property (nonatomic, strong)  NSString *fullname;
@property (nonatomic, strong)  NSString *email;
@property (nonatomic, strong)  NSString *dob;
@property (nonatomic, strong)  NSString *gender;
@property (nonatomic, strong)  NSString *mobile;
@property (nonatomic, strong)  NSString *mid;
@property (nonatomic, strong)  NSString *isEdit;


@end
