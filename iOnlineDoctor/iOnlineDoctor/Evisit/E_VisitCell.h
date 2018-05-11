//
//  E_VisitCell.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface E_VisitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctorName;
@property (weak, nonatomic) IBOutlet UILabel *lblAptTime;
@property (weak, nonatomic) IBOutlet UIButton *btncall;
@property (weak, nonatomic) IBOutlet UIButton *btnBadge;
@property (weak, nonatomic) IBOutlet UILabel *lblAppointmentType;



@property (weak, nonatomic) IBOutlet UIButton *btnStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end
