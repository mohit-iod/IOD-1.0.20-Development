//
//  E-VisitDetailCell.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "E-VisitDetailCell.h"

@implementation E_VisitDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView.layer setBorderColor:[UIColor whiteColor].CGColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
