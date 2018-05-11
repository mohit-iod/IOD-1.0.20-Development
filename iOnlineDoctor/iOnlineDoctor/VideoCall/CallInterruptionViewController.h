//
//  CallInterruptionViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"

@interface CallInterruptionViewController : ViewController
@property (nonatomic,retain) NSString *strRemainingTime;
@property (nonatomic,retain) IBOutlet UILabel *lblRemainingTime;
@property (nonatomic,retain) IBOutlet UIButton *btnCancelPressed;
@property (nonatomic,retain) IBOutlet UIButton *btnCallAgainPressed;
@property (nonatomic,retain) IBOutlet UIButton *btnDonePressed;
@property (nonatomic,retain) IBOutlet UIButton *btnCancelbyPatientPressed;

@property (nonatomic,retain) IBOutlet UIButton *btnCallInterruption;
@property (nonatomic,retain) IBOutlet UIButton *btnCancel;
@property (nonatomic,retain) IBOutlet UIButton *btnPatientDone;
@property (nonatomic,retain) IBOutlet UIButton *btnPatientCancel;

@end

