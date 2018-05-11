//
//  doctorDocVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STBubbleTableViewCell.h"

@interface doctorDocVC : UIViewController<UITableViewDelegate,UITableViewDataSource,STBubbleTableViewCellDataSource,STBubbleTableViewCellDelegate>{
    NSMutableArray * dateArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tblDoc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tablevHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *txtvInstructionsHeight;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblDocName;
@property (weak, nonatomic) IBOutlet UILabel *lblDocGender;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctSpecialise;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserGender;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAge;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UITextView *txtvInstructions;
@property (weak, nonatomic) IBOutlet UITextView *txtvaddInstruction;
@property (weak, nonatomic) IBOutlet UIButton *btnStatus;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollv;

//mohit
@property(nonatomic,strong) IBOutlet UIView *sendMsgView;
@property(nonatomic,strong) IBOutlet UIView * docView, * msgView, *videoLinkView;
@property(nonatomic,strong) IBOutlet UITableView * msgTable;
@property (strong, nonatomic) IBOutlet UISegmentedControl * segmentedControl;
@property(nonatomic,strong) IBOutlet UITextField * msgText;


@property(nonatomic, strong)IBOutlet UITableView * linkTable;
@property (strong, nonatomic) IBOutlet UIView *linkView;
@end
