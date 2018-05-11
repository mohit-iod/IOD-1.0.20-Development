//
//  PatientDocVC.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/4/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientDocVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblDoc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (nonatomic,retain) NSString *visitorId;
@property (nonatomic,retain) NSString *date;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocGender;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctSpecialise;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserGender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAge;
@property (nonatomic,retain) NSDictionary *listOfdata;
@property (weak, nonatomic) IBOutlet UIView *viewDocument;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIView *documentContainerView;
@property (weak, nonatomic) IBOutlet UITextView *txtInstructions;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;


@end
