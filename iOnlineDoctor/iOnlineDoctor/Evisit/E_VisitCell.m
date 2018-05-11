//
//  E_VisitCell.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "E_VisitCell.h"

@implementation E_VisitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.btnBadge setHidden:YES];
    [self.btncall.layer setCornerRadius:16.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
