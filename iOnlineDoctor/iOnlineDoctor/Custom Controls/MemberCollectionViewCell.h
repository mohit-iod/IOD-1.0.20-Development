//
//  MemberCollectionViewCell.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/6/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imgCell;
@property (nonatomic, weak) IBOutlet UIImageView *img;

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

@end
