//
//  searchDoctorCell.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/4/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "searchDoctorTableCell.h"
#import "UIColor+HexString.h"
@implementation searchDoctorTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_btnCall.layer setBorderWidth:1.0];
    [_btnCall.layer setBorderColor:[UIColor colorWithHexRGB:kNavigatinBarColor].CGColor];
    // Initialization code
    [_btnProfilePic.layer setCornerRadius:_btnProfilePic.frame.size.width/2];
    [_imgBackground.layer setCornerRadius:12.0];
    [_imgBackground.layer setBorderWidth:1.0];
   [_imgBackground.layer setBorderColor:[UIColor colorWithHexRGB:@"#dedede"].CGColor];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
