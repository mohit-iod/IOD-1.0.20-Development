//
//  UploadDocumentsViewController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/21/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"


@interface UploadDocumentsViewController : ViewController <UITableViewDataSource,UITabBarDelegate>

/*! @discussion This property is used to enter Doctor's referral code.!*/
@property (nonatomic, weak) IBOutlet UITextField *txtReferalCode;

/*! @discussion This property is used to select Referral Doctor name from list.!*/
@property (nonatomic, weak) IBOutlet UITextField *txtReferalDoctor;

/*! @discussion This property is for Referral Doctor table!*/
@property (nonatomic, strong) IBOutlet UITableView *tblReferalDoc;

@property (nonatomic, weak) IBOutlet UIButton *btnOr;

@property (nonatomic, weak) IBOutlet UIView *referalView;

/*! search bar to search the doctor from list */
@property(nonatomic,strong) IBOutlet UISearchBar *search;

@end
