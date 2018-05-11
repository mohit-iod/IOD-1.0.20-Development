//
//  ShareVideoLink.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 4/16/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareVideoLink : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * dataArray;
    NSMutableArray * tempLinkArray;
}

@property (nonatomic,strong)IBOutlet UITextField * linkText;

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
