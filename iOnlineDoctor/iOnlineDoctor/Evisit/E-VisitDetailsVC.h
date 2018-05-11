//
//  E-VisitDetailsVC.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/30/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface E_VisitDetailsVC : UIViewController <UITableViewDelegate,UITableViewDataSource>

{
    NSArray *arrayData;
    NSMutableDictionary *dictlistdata;
    NSArray *arrayImages;
    BOOL isReadDocument;
}

@property (nonatomic,retain) NSString *visitorId;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSDictionary *listOfdata;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocGender;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctSpecialise;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserGender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAge;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@end

