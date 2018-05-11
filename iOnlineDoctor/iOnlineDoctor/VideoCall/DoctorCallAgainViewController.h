//
//  DoctorCallAgainViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/18/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorCallAgainViewController : UIViewController
@property(nonatomic,weak) IBOutlet UIImageView *imguserImage,*imgLogo;
@property (nonatomic, weak) IBOutlet UILabel *lblDoctorname,*lblRing,*lblTimer,*lblWaitingDoctorname;
@property (nonatomic, weak) IBOutlet UITableView *tblChat;
@property (nonatomic, weak) IBOutlet UIButton *btnChat;
@property (nonatomic, weak) IBOutlet UIButton *btnAccept;
@property (nonatomic, weak) IBOutlet UIButton *btnReject,*btnDocument;
@property (nonatomic, weak) IBOutlet UIView *ringingFooterView;
@property (nonatomic, retain) NSString  *appoitment_date;
@property (nonatomic,retain) NSString *call_duration;
@property (nonatomic,retain) NSString *from;
@property (nonatomic,retain) NSString *patient_address;
@property (nonatomic,assign) NSString *patient_dob;
@property (nonatomic,retain) NSString *patient_gender;
@property (nonatomic,retain) NSString *patient_name;
@property (nonatomic,retain) NSString *profile_pic;
@property (nonatomic,retain) NSString *session_token;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,assign) NSString *visit_id;
@property (nonatomic,retain) NSString *visit_type;
@property (weak, nonatomic) IBOutlet UIButton *cameraToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *audioPubUnpubButton;
@property (weak, nonatomic) IBOutlet UIView *documentView;



@end
