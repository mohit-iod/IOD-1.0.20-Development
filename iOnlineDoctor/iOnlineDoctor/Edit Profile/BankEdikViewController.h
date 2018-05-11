//
//  BankEdikViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 12/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringPickerView.h"


@interface BankEdikViewController : UIViewController
@property (nonatomic, strong) StringPickerView *pickerView;


@property (weak, nonatomic) IBOutlet UITextField *txtAcNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtAcType;

@property (weak, nonatomic) IBOutlet UITextField *txtAcName;
@property (weak, nonatomic) IBOutlet UITextField *txtAcHolderAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtAcCode;
@property (weak, nonatomic) IBOutlet UITextField *accountTypeCode;

@property (weak, nonatomic) IBOutlet UITextField *txtIban;
@property (weak, nonatomic) IBOutlet UITextField *txtBankName;
@property (weak, nonatomic) IBOutlet UITextField *txtBankAdress;
@property (weak, nonatomic) IBOutlet UITextField *txtBankAcNumber;

@property (weak, nonatomic) IBOutlet UITextField *txt15minsCharge;
@property (weak, nonatomic) IBOutlet UITextField *txt30minsCharge;

@property (weak, nonatomic) IBOutlet UIScrollView *scrlv;

@property (weak, nonatomic) IBOutlet UIImageView *imgPrice_lc;
@property (weak, nonatomic) IBOutlet UIImageView *imgPrice_bo;

@end
