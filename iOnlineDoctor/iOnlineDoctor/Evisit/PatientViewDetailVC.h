//
//  PatientViewDetailVC.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/6/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PatientViewDetailVC : UIViewController

@property (nonatomic,retain) NSString *visitorId;
@property (nonatomic,retain) NSDictionary *listOfdata;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocGender;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctSpecialise;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserGender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAge;
@property (weak, nonatomic) IBOutlet UIView *viewDocument;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (nonatomic,retain) NSString *date;
@property (weak, nonatomic) IBOutlet UIStackView *stckView;
@property (weak, nonatomic) IBOutlet UITextView *ttDiagnose;
@property (weak, nonatomic) IBOutlet UITextView *txtTreatment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDiagnose;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTreatment;
@property(nonatomic, weak) IBOutlet UICollectionView *collv;
@property (weak, nonatomic) IBOutlet UILabel *lblCounter;


@end
