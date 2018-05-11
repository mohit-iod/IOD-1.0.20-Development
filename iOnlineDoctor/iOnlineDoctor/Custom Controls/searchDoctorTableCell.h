//
//  searchDoctorCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/4/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"


@interface searchDoctorTableCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *lblName;
@property(nonatomic, weak) IBOutlet UILabel *lblQualification;
@property(nonatomic, weak) IBOutlet UILabel *lblLanguage;
@property(nonatomic, weak) IBOutlet UILabel *lblAddress;
@property(nonatomic, weak) IBOutlet UILabel *lblRating;
@property(nonatomic, weak) IBOutlet UILabel *lblGender;
@property(nonatomic, weak) IBOutlet UILabel *lblExperience;
@property(nonatomic, weak) IBOutlet UIImageView *btnProfilePic;
@property(nonatomic, weak) IBOutlet UIImageView *imgBackground;
@property(nonatomic, weak) IBOutlet RateView *ratingView;


@property(nonatomic, weak) IBOutlet UILabel *btnCall;
@property(nonatomic, weak) IBOutlet UILabel *lblPromoCall;
@property(nonatomic, weak) IBOutlet UIButton *btnProfile;


@end
