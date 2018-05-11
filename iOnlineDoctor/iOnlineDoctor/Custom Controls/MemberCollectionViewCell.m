//
//  MemberCollectionViewCell.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/6/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "MemberCollectionViewCell.h"

@implementation MemberCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_imgCell.layer setCornerRadius:_imgCell.frame.size.height/2];
    _imgCell.clipsToBounds = YES;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    // here we clear the previously set data
    self.imgCell.image = nil; // this will clear the previously set imageView is a property of UIImageView used to display a image data
}


@end
