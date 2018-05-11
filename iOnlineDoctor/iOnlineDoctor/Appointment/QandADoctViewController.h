//
//  QandADoctViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/16/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol tabbarDelegate <NSObject>
- (void)setSelectedTabIndex:(int)index;
@end

@interface QandADoctViewController : UIViewController<UITextViewDelegate>
@property (strong, nonatomic) id <tabbarDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *txtViewQue1;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UITextView *ttDiagnose;
@property (weak, nonatomic) IBOutlet UITextView *txtTreatment;
@property (weak, nonatomic) IBOutlet UIStackView *stckView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDiagnose;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTreatment;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocGender;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctSpecialise;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserGender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAge;
@property(nonatomic, weak) IBOutlet UICollectionView *collv;
@property (weak, nonatomic) IBOutlet UILabel *lblCounter;


@end
