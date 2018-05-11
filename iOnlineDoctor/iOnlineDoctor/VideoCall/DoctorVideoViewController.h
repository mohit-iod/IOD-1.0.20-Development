//
//  DoctorVideoViewController.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/6/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"
#import "MMPulseView.h"

@interface DoctorVideoViewController : ViewController{
}
@property (nonatomic, weak) IBOutlet UILabel *lblPatientName,*lblRing,*lblTimer;
@property (nonatomic, weak) IBOutlet UIButton *btnAccept,*btnReject,*btnDocument;
@property (nonatomic, weak) IBOutlet UIView *PatientContainer;

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


@property (nonatomic, weak) IBOutlet UITableView *tblChat;
@property (weak, nonatomic) IBOutlet UITextView *chatReceivedTextView;
@property (weak, nonatomic) IBOutlet UITextField *chatInputTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImageview;
@property (nonatomic, weak) IBOutlet UIImageView *imgLogo;


@property (weak, nonatomic) IBOutlet UIView *ringingView;
@property (weak, nonatomic) IBOutlet UIView *documentView;
@property (weak, nonatomic) IBOutlet UIView *ringingDocumentView;
@property (weak, nonatomic) IBOutlet UIView *waitingView;
@property (weak, nonatomic) IBOutlet UIView *videoContainerView;
@property (weak, nonatomic) IBOutlet UIView *chatView;

@property (nonatomic, weak) IBOutlet UILabel  *lblWaitingPatientName;
@property (nonatomic, weak) IBOutlet UILabel  *lblRingingPatientName;

@property (nonatomic, weak) IBOutlet UIImageView *imgPatientProfile;


@property (weak, nonatomic) IBOutlet UIView *subscriberView;
@property (weak, nonatomic) IBOutlet UIView *publisherView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *ringingFooterView;

@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIButton *btnDoc;
@property (weak, nonatomic) IBOutlet UIButton *btnEndcall;

//Ringing view buttons
@property (weak, nonatomic) IBOutlet UIButton *btnRingingChat;
@property (weak, nonatomic) IBOutlet UIButton *btnRingingDoc;
@property (weak, nonatomic) IBOutlet UIButton *btnRingingEndcall;


@property (weak, nonatomic) IBOutlet UIButton *cameraToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *audioPubUnpubButton;
@end
