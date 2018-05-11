//
//  AboutdoctorViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/8/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface AboutdoctorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctorName;
@property (weak, nonatomic) IBOutlet UILabel *lblQualification;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecialization;
@property (weak, nonatomic) IBOutlet UILabel *lblLanguage;
@property (weak, nonatomic) IBOutlet UILabel *lblCharge;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblExperience;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalRating;
@property (weak, nonatomic) IBOutlet UILabel *lblPromoCode;

@property (weak, nonatomic) IBOutlet RateView *ratingview;
@property (weak, nonatomic) IBOutlet RateView *ratingviewReview;


@property (weak, nonatomic) IBOutlet UIView *callNowview;
@property (weak, nonatomic) IBOutlet UITextView *txtAboutMe;

@property (weak, nonatomic) IBOutlet UITableView *tblReview;
@property (strong, nonatomic) NSMutableDictionary *userProfile;
@property (weak, nonatomic) IBOutlet UIButton *callNow;

@end
