//
//  SuccessfulPaymentViewController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"

@interface SuccessfulPaymentViewController : ViewController

@property (weak, nonatomic) IBOutlet UILabel *lblPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentWith;
@property (weak, nonatomic) IBOutlet UILabel *lblDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;

@property (weak, nonatomic) IBOutlet UIView *paymentFailed;
@property (weak, nonatomic) IBOutlet UIView *PaymentSucceww;
- (IBAction)GoHomePressed:(id)sender;

@end
