//
//  VideoCallViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/5/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPulseView.h"
#import "STBubbleTableViewCell.h"

@interface PatientVideoCallViewController : UIViewController<STBubbleTableViewCellDataSource, STBubbleTableViewCellDelegate>
@property(nonatomic,weak) IBOutlet UIImageView *imguserImage,*imgLogo;
@property (nonatomic, weak) IBOutlet UILabel *lblDoctorname,*lblRing,*lblTimer,*lblWaitingDoctorname;
@property (nonatomic, weak) IBOutlet UITableView *tblChat;
@property (nonatomic, weak) IBOutlet UIButton *btnChat;
@property (nonatomic, weak) IBOutlet UIButton *btnAccept;
@property (nonatomic, weak) IBOutlet UIButton *btnReject;
@property (nonatomic, weak) IBOutlet UIView *ringingFooterView;

@property (weak, nonatomic) IBOutlet UIButton *cameraToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *audioPubUnpubButton;
@end
