//
//  DoctorsMessage.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 4/12/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STBubbleTableViewCell.h"

@interface DoctorsMessage : UIViewController<UITableViewDelegate,UITableViewDataSource,STBubbleTableViewCellDelegate,STBubbleTableViewCellDataSource>
{
    NSMutableArray * docMsgData;
    NSMutableArray * dateArray;
}
@property (strong, nonatomic) IBOutlet UITextField *textMsg;

@property (strong, nonatomic) IBOutlet UIView *sendMsgView;
@property (nonatomic,strong) IBOutlet UIView * noMsgView;
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
