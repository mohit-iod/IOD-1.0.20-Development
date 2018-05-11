//
//  DashboardDoctor.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 8/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardXibCell.h"

@interface DashboardDoctor : UIViewController<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewDashbaord;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName,*lblAddress;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *wrapper;

- (IBAction)editButton:(id)sender;

@end
