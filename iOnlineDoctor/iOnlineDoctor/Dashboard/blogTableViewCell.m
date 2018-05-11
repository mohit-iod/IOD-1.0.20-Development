//
//  blogTableViewCell.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 1/18/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "blogTableViewCell.h"

@implementation blogTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_contv.layer setCornerRadius:6.0];
    [_contv.layer setBorderWidth:1.0];
    [_contv.layer setBorderColor:[UIColor lightGrayColor].CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
