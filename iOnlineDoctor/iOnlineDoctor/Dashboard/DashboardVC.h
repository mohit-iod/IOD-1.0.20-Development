//
//  DashboardVC.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardXibCell.h"

@interface DashboardVC : UIViewController<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UIScrollViewDelegate>
{
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *wrapper;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDashbaord;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UIImageView *editProfileImg;
@property (strong, nonatomic) IBOutlet UILabel  *lblName;
@property (strong, nonatomic) IBOutlet UILabel  *lblAddress;

@property (strong, nonatomic) NSString *strProfileImg;
@property (strong, nonatomic) NSString  *strName;
@property (strong, nonatomic) NSString  *strAddress;
@property (strong, nonatomic) NSString  *strCouponCode;
@property (strong, nonatomic) NSString  *strPrice;
@property (strong, nonatomic) NSString  *strExpireDate;
@property (nonatomic,assign ) int isFirstLogin;

@end
