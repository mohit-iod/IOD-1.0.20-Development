//
//  ContactUsViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController
@property(nonatomic, weak) IBOutlet  UITextView *message;
@property(nonatomic, weak) IBOutlet  UITextField *subject;
@property (nonatomic, weak) IBOutlet UITextField *txtName;
@property (nonatomic, weak) IBOutlet UITextField *txtEmail;

@property (nonatomic, retain) NSString *strFilePath;
@property (nonatomic, retain) NSString *strTitle;
@property BOOL *hideMenu;


@end
