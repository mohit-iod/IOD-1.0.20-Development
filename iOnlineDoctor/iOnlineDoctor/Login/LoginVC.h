//
//  LoginVC.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/25/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//


#import "ViewController.h"
#import "UICheckbox.h"

@class UICheckbox;

@interface LoginVC : UIViewController <UITextFieldDelegate>
/**
 * The object that acts as the ate of the calendardeleg.
 */

/*! @brief This property is. */
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property(nonatomic, weak)IBOutlet UICheckbox *checkbox;

@property (weak, nonatomic) IBOutlet UIButton *lblTerms;

@property (nonatomic, strong) NSString *country_id;


- (IBAction)btnForgotPassword:(id)sender;
- (IBAction)btnGetStarted:(id)sender;
- (IBAction)registerPressed:(UIButton *)sender;
- (IBAction)testCheckbox:(id)sender;
- (IBAction)testChecking;
- (IBAction)testDisabling;


@end
