//
//  DoctorCallAgainViewController.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/18/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import "DoctorCallAgainViewController.h"
#import <OpenTok/OpenTok.h>
#import "OTAudioDeviceRingtone.h"
#import "PatientAppointService.h"
#import "UIImageView+WebCache.h"
#import "PayeezySDK.h"
#import "IODUtils.h"
#import "Message.h"
#import "UIColor+HexString.h"
#import "rateUsVC.h"
#import "DoctorAppointmentServiceHandler.h"
#import "CommonServiceHandler.h"
#import "CallInterruptionViewController.h"
#import "MMPulseView.h"
#import "UIColor+HexString.h"
#import "STBubbleTableViewCell.h"


static NSString* kApiKey = @"45960372";

@interface DoctorCallAgainViewController ()<OTSessionDelegate, OTPublisherDelegate,OTSubscriberDelegate,UITextFieldDelegate,STBubbleTableViewCellDataSource, STBubbleTableViewCellDelegate> {
    MMPulseView *pulseView;
    PatientAppointService *patientService;
    DoctorAppointmentServiceHandler *doctorService;
    
    NSTimer *timerForWaiting;
    NSTimer *countdownTimer;
    int currMinute;
    int currSeconds;
    NSMutableArray *arrChat;
    OTAudioDeviceRingtone* _myAudioDevice;
    BOOL _reconnectPlease;
    NSMutableArray *backgroundConnectedStreams;
    BOOL isCallEnd;
    NSString* startTime;
    NSString *endTime;
    NSString *isPaymentDone;
    //DoctorAppointmentServiceHandler *doctorService;
    CallInterruptionViewController *interruptionVC;
     NSString *UserId;
    NSString *strStatus;
    NSString *strAppointmentStaus;
}
@property (nonatomic) OTSession *session;
@property (nonatomic) OTPublisher *publisher;
@property (nonatomic) OTSubscriber *subscriber;

@property (weak, nonatomic) IBOutlet UITextView *chatReceivedTextView;
@property (weak, nonatomic) IBOutlet UITextField *chatInputTextField;

@property (weak, nonatomic) IBOutlet UIView *callingView;
@property (weak, nonatomic) IBOutlet UIView *waitingView;
@property (weak, nonatomic) IBOutlet UIView *videoContainerView;
@property (weak, nonatomic) IBOutlet UIView *chatView;

@property (weak, nonatomic) IBOutlet UIView *subscriberView;
@property (weak, nonatomic) IBOutlet UIView *publisherView;
@property (weak, nonatomic) IBOutlet UIView *footerView;

@property (retain, nonatomic)  NSString *strToken;
@property (retain, nonatomic)  NSString *strSession;
@property (retain, nonatomic)  NSString *strDoctorName;
@property (retain, nonatomic)  NSString *strImageUrl;

@end

@implementation DoctorCallAgainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [_ringingFooterView setHidden:YES];
}


-(void) viewWillAppear:(BOOL)animated{
    doctorService = [DoctorAppointmentServiceHandler sharedManager];
    doctorService.currentView = @"ringing";
    self.appoitment_date = doctorService.appoitment_date;
    self.call_duration = doctorService.call_duration;
    self.from = doctorService.from;
    self.patient_address = doctorService.patient_address;
    //self.patient_dob = doctorService.patient_dob;
    self.patient_gender = doctorService.patient_gender ;
    self.patient_name = doctorService.patient_name;
    self.profile_pic = doctorService.profile_pic ;
    self.session_token = doctorService.session_token;
    self.type = doctorService.type;
    self.visit_id = doctorService.visit_id;
    self.visit_type = doctorService.visit_type;
    self.strSession = doctorService.session_id;
    arrChat = [[NSMutableArray alloc] init];
    [self hideallViews];
    [self startAnimating];
    [_btnChat setBackgroundImage:[UIImage imageNamed:@"msg-icon.png"] forState:UIControlStateNormal];
    _lblDoctorname.text =  self.patient_name;
    _lblWaitingDoctorname.text  = self.patient_name;
    UserId = UDGet(@"uid");
    [self connectToAnOpenTokSession ];
}

-(void)setUI {
    [ _tblChat setBackgroundColor:[UIColor colorWithHexString:@"f0f8d1"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
}

- (void)hideallViews{
    [_callingView setHidden:YES];
    [_waitingView setHidden:YES];
    [_chatView setHidden:YES];
    [_videoContainerView setHidden:YES];
}

- (void)stopAnimating {
    [pulseView stopAnimation];
    [_myAudioDevice stopRingtone];
}

-(void)startAnimating {
    backgroundConnectedStreams = [[NSMutableArray alloc] init];
    [_callingView setHidden:NO];
    [_lblRing setHidden:NO];
    [_lblDoctorname setHidden:NO];
    _lblDoctorname.text = patientService.res_doctor_name;
    _lblWaitingDoctorname.text = patientService.res_doctor_name;
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"appleiphone"
                                                     ofType:@"mp3"];
    NSURL* url = [NSURL URLWithString:path];
    [_myAudioDevice playRingtoneFromURL:url];
    NSMutableArray *pulseArray = @[].mutableCopy;
    [pulseArray addObject:[MMPulseView new]];
    NSInteger index = 0;
    pulseView = pulseArray[index];
    pulseView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.x,self.view.frame.size.width,self.view.frame.size.height);
    pulseView.center = self.view.center;
    [_callingView addSubview:pulseView];
    UIImageView *userImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    [_callingView addSubview:userImageview];
    [userImageview sd_setImageWithURL:[NSURL URLWithString:patientService.res_profile_pic] placeholderImage:[UIImage imageNamed:@"P-calling-icon.png"]];
    [userImageview.layer setCornerRadius:45];
    userImageview.clipsToBounds =YES;
    userImageview.backgroundColor = [UIColor whiteColor];
    userImageview.layer.cornerRadius = 45.0;
    userImageview.center = self.view.center;
    [_callingView bringSubviewToFront:userImageview];
    [pulseView startAnimation];
    [_ringingFooterView setHidden:YES];
    
}

- (void)connectToAnOpenTokSession {
    //NSLog(@"session is %@",doctorService.session_id);
    _session = [[OTSession alloc] initWithApiKey:kApiKey sessionId:doctorService.session_id delegate:self];
    NSError *error;
    [_session connectWithToken:doctorService.session_token error:&error];
    if (error) {
       // NSLog(@"sessionerror");
    }
}

# pragma mark - OTPublisher delegate callbacks
- (void)publisher:(OTPublisherKit*)publisher
 didFailWithError:(OTError*) error
{
  //  NSLog(@"PUBLISHER FAILED: %@", error);
}

# pragma mark - OTSession delegate callbacks
- (void)sessionDidConnect:(OTSession*)session
{
    OTPublisherSettings *settings = [[OTPublisherSettings alloc] init];
    settings.cameraResolution = OTCameraCaptureResolutionLow;
    settings.cameraFrameRate = OTCameraCaptureFrameRate30FPS;
    settings.name = [UIDevice currentDevice].name;
    _publisher = [[OTPublisher alloc] initWithDelegate:self settings:settings];
    OTError *error = nil;
    [_session publish:_publisher error:&error];
    if (error)
    {
      //  NSLog(@"Unable to publish (%@)", error.localizedDescription);
        [IODUtils showMessage:error.localizedDescription withTitle:@"Error in Publish stream method"];
        
        return;
    }
    [_publisher.view setFrame:CGRectMake(0, 0, _publisherView.bounds.size.width,
                                         _publisherView.bounds.size.height)];
    [_publisherView addSubview:_publisher.view];
    [self hideallViews];
    
    {
        [self stopRingtone];
        [_ringingFooterView setHidden:YES];
        [_waitingView setHidden:NO];
        timerForWaiting = [NSTimer scheduledTimerWithTimeInterval:60
                                                           target:self
                                                         selector:@selector(CallUnaccepted)
                                                         userInfo:nil
                                                          repeats:NO];
        [self.view bringSubviewToFront:_waitingView];
    }
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    date = [IODUtils toLocalTime:date];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    startTime  = [NSString stringWithFormat:@"%@",date];
    
}


- (void)publisher:(nonnull OTPublisherKit*)publisher
  streamDestroyed:(nonnull OTStream*)stream {
  //  NSLog(@"PUBLISHER STREAM DESTROYED");
}

-(void) timerOver {
}

-(void)CallUnaccepted {
    [self successfullCall];
}

#pragma mark - Utils
- (void)batteryLevelChanged:(NSNotification *)notification
{
    
}


-(void)stopRingtone {
    [_myAudioDevice stopRingtone];
}

- (void)sessionDidDisconnect:(OTSession*)session
{
 //   NSLog(@"SESSION DISCONNECT");
    // [IODUtils showMessage:@"The client disconnected from the OpenTok session." withTitle:@"Error"];
}

- (void) session:(OTSession*)session
didFailWithError:(OTError*)error
{
   // NSLog(@"SESSION FAIL WITH ERROR");
    if(error.code == 1022){
        [countdownTimer invalidate];
        doctorService.InterruptionTime = currMinute+1;
        doctorService.callInterruptionMessage = @"Call interrupted by patient but patient made it success";
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OTError* error = nil;
        [_session disconnect:&error];
        if (error) {
            //NSLog(@"disconnect failed with error: (%@)", error);
        }
        [countdownTimer invalidate];
        CallInterruptionViewController *interruptionVC =[sb instantiateViewControllerWithIdentifier:@"CallInterruptionPatient"];
        [self.navigationController pushViewController:interruptionVC animated:YES];
    }
}

- (void)session:(OTSession*)session
  streamCreated:(OTStream *)stream
{
    
    [self createSubscriber:stream];
}

- (void)createSubscriber:(OTStream *)stream
{
    //NSLog(@"CREATE SUBSCRIBER");
    
    if ([[UIApplication sharedApplication] applicationState] ==
        UIApplicationStateBackground ||
        [[UIApplication sharedApplication] applicationState] ==
        UIApplicationStateInactive)
    {
        [backgroundConnectedStreams addObject:stream];
    } else
    {
        // create subscriber
        _subscriber= [[OTSubscriber alloc]
                      initWithStream:stream delegate:self];
        
        // subscribe now
        OTError *error = nil;
        [_session subscribe:_subscriber error:&error];
        if (error)
        {
            //[IODUtils showMessage:[error localizedDescription] withTitle:@"Error"];
            
            [IODUtils showFCAlertMessage:[error localizedDescription] withTitle:@"" withViewController:self with:@"error"];
        }
    }
}

- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
}

- (void)subscriberDidDisconnectFromStream:(nonnull OTSubscriberKit*)subscriber{
}

# pragma mark - OTSubscriber delegate callbacks
- (void)subscriberDidConnectToStream:(OTSubscriberKit *)subscriber {
    
    [self stopRingtone];
    [timerForWaiting invalidate];
    [_subscriber.view setFrame:CGRectMake(0,0,_subscriberView.bounds.size.width,_subscriberView.bounds.size.height)];
    [_subscriberView addSubview:_subscriber.view];
    [_subscriberView bringSubviewToFront:_publisherView];
    [_publisherView.layer setBorderWidth:3.0];
    [_publisherView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_subscriberView bringSubviewToFront:_footerView];
    [self hideallViews];
    [_videoContainerView setHidden:NO];
    [_subscriberView bringSubviewToFront:_lblTimer];
    [_subscriberView bringSubviewToFront:_imgLogo];
    
    [_footerView setHidden:NO];
    [_subscriberView bringSubviewToFront:_footerView];
    [self startCoundownTimer];
    [self sendSignalforInterruptedminutes ];
}

- (void)subscriber:(OTSubscriberKit*)subscriber
  didFailWithError:(OTError*)error
{
    [_myAudioDevice stopRingtone];
}


- (void)enteringBackgroundMode:(NSNotification*)notification
{
}

- (void)leavingBackgroundMode:(NSNotification*)notification
{
    _publisher.publishVideo = YES;
    _subscriber.subscribeToVideo = YES;
    //now subscribe to any background connected streams
    for (OTStream *stream in backgroundConnectedStreams)
    {
        // create subscriber
        _subscriber = [[OTSubscriber alloc]
                       initWithStream:stream delegate:self];
        // subscribe now
        OTError *error = nil;
        [_session subscribe:_subscriber error:&error];
        if (error)
        {
            //            [self showAlert:[error localizedDescription]];
            [IODUtils showFCAlertMessage:[error localizedDescription] withTitle:@"" withViewController:self with:@"error"];
        }
    }
    [backgroundConnectedStreams removeAllObjects];
}

#pragma mark Click events


-(IBAction)openChatView:(id)sender {
    [_btnChat setBackgroundImage:[UIImage imageNamed:@"msg-icon.png"] forState:UIControlStateNormal];
    [UIView transitionWithView:self.view
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        if(_chatView.hidden){
                            [_chatView setHidden:NO];
                            [_subscriberView bringSubviewToFront:_chatView];
                            [_btnChat setBackgroundImage:[UIImage imageNamed:@"video-icon.png"] forState:UIControlStateNormal];
                        }
                        else {
                            [_chatView setHidden:YES];
                            [_videoContainerView bringSubviewToFront: _subscriberView];
                            [_btnChat setBackgroundImage:[UIImage imageNamed:@"msg-icon.png"] forState:UIControlStateNormal];
                        }
                    } completion:NULL];
}
- (IBAction)startCall:(UIButton *)sender{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"appleiphone"
                                                     ofType:@"mp3"];
    NSURL* url = [NSURL URLWithString:path];
    [_myAudioDevice playRingtoneFromURL:url];
    [self connectToAnOpenTokSession];
}

- (IBAction)recieveCall:(UIButton * )sender{
    [self connectToAnOpenTokSession];
}

- (IBAction)bounce:(UIButton *)yourButton {
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///use transform
    theAnimation.duration=0.4;
    theAnimation.repeatCount=5;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:-20];
    [yourButton.layer addAnimation:theAnimation forKey:@"animateTranslation"];//animationkey
    if(!_chatView.hidden)
    {
        [_btnChat setBackgroundImage:[UIImage imageNamed:@"chat-notification.png"] forState:UIControlStateNormal];
    }
    
    [_btnChat setBackgroundImage:[UIImage imageNamed:@"chat-notification.png"] forState:UIControlStateNormal];
}

-(IBAction)endCall:(UIButton *)sender{
    OTError* error = nil;
    [_session disconnect:&error];
    if (error) {
        //NSLog(@"disconnect failed with error: (%@)", error);
    }
}

- (IBAction)joinCall:(UIButton *)sender {
    [self connectToAnOpenTokSession];
}

#pragma mark - Chat messaging
- (IBAction)sendChatMessage:(id)sender
{
    OTError* error = nil;
    if(_chatInputTextField.text.length > 0) {
        [_session signalWithType:@"chat" string:_chatInputTextField.text connection:nil error:&error];
        if (error) {
           // NSLog(@"Signal error: %@", error);
        } else {
           // NSLog(@"Signal sent: %@", _chatInputTextField.text);
        }
        _chatInputTextField.text = @"";
    }
    [self.view endEditing:YES];
    [_chatView resignFirstResponder ];
    
    
}




-(void) sendSignalCallEnd {
    OTError* error = nil;
    [_session signalWithType:@"endCall" string:@"Call END" connection:nil error:&error];
    if (error) {
        
    } else {
    }
}

-(void) sendSignal {
    
   // NSLog(@"SEND SIGNAL");
    OTError* error = nil;
    [_session signalWithType:@"callComeFrom" string:@"iOS" connection:nil error:&error];
    if (error) {
        
    } else {
    }
}



- (IBAction)btnEndCallPressed:(id)sender {
    [timerForWaiting invalidate];
    [countdownTimer invalidate];
    doctorService.callEnd =@"yes";
    [self successfullCall];
    
}

- (void)successfullCall{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    date = [IODUtils toLocalTime:date];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    endTime  = [formatter stringFromDate:date];
    [self sendSignalCallEnd];
    NSString *start_time = startTime;
    NSString *end_time = endTime;
    doctorService.strStartTime = startTime;
    doctorService.endTime = endTime;
    doctorService.isFromVideo = 0;
    
    NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
    [paramater setObject:self.visit_id forKey:@"patient_visit_id"];
    [paramater setObject:kCallSuccess forKey:@"call_status"];
    [paramater setObject:kCallSuccess forKey:@"appointment_status_id"];
    [paramater setObject:UserId forKey:@"call_dropped_by"];
    [paramater setObject:@"NO" forKey:@"is_call_dropped"];
    [paramater setObject:@"Call end" forKey:@"call_status_description"];
    [paramater setObject:doctorService.call_duration forKey:@"call_duration"];
    [paramater setObject:start_time forKey:@"start_time"];
    [paramater setObject:end_time forKey:@"end_time"];
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service postEndCallData:paramater WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //NSLog(@"End call done");
        doctorService.status = @"callend";
        doctorService.isFromVideo = 0;
        
        if([[responseCode objectForKey:@"status"]isEqualToString:@"success"]) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
            UIViewController *viewTab=[sb instantiateViewControllerWithIdentifier:@"TabVC"];
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController:viewTab animated:YES];
        }
        else {
            
            [IODUtils showFCAlertMessage:@"Something went wrong" withTitle:@"" withViewController:self with:@"error"];
        }
        
    }];
}


- (void)session:(OTSession*)session receivedSignalType:(NSString*)type fromConnection:(OTConnection*)connection withString:(NSString*)string {
  //  NSLog(@"Received signal %@", string);
    if([ string caseInsensitiveCompare:@"Call END"]== NSOrderedSame ){
        isCallEnd = YES;
        [countdownTimer invalidate];
        OTError* error = nil;
        [_session disconnect:&error];
      
    }
    else if ([type caseInsensitiveCompare:@"remaining_time"]== NSOrderedSame){
        
       /// NSLog(@"%d",[string  intValue]);
        //currMinute = [string intValue];
        //[self startCoundownTimer];
    }
    //"callComeFrom" string:@"iOS" c
    else if([type caseInsensitiveCompare:@"callComeFrom"]==NSOrderedSame){
    }
    
    else{
        Boolean fromSelf = NO;
        if ([connection.connectionId isEqualToString:session.connection.connectionId]) {
            fromSelf = YES;
        }
        [self logSignalString:string fromSelf:fromSelf];
    }
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrChat count];
}




# pragma mark - UITextFieldDelegate callbacks
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _chatInputTextField.text = @"";
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //    [self sendChatMessage];
    [self.view endEditing:YES];
    return YES;
}

#pragma mark Timer
-(void)startCoundownTimer {
    
    currMinute = doctorService.InterruptionTime;
     currSeconds=00;
    countdownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
   /*
 if([patientService.visit_type_id isEqualToString:@"3"]){
        [_lblTimer setText:@"30:00"];
        currMinute=30;
        currSeconds=00;
        countdownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
    }
    else {
        [_lblTimer setText:@"15:00"];
        currMinute=15;
        currSeconds=00;
        countdownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
    }*/
}

-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [_lblTimer setText:[NSString stringWithFormat:@"%@%d%@%02d",@"",currMinute,@":",currSeconds]];
        if((currMinute <=1) && (currMinute > -1)){
            _lblTimer.alpha = 1;
            [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
                _lblTimer.alpha = 0;
            } completion:nil];
        }
    }
    else
    {
        [countdownTimer invalidate];
        OTError* error = nil;
        [_session disconnect:&error];
        if (error) {
            //NSLog(@"disconnect failed with error: (%@)", error);
        }
        UIViewController *rateUs=[self.storyboard instantiateViewControllerWithIdentifier:@"rateUsVC"];
        [self.navigationController pushViewController:rateUs animated:YES];
    }
}

-(void)creditCardPayment{
    // Test credit card info
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSDictionary* credit_card = [[NSUserDefaults standardUserDefaults]objectForKey:@"ccdetails"] ;
        
        NSString *strtoken = [[NSUserDefaults standardUserDefaults]valueForKey:@"fdtoken"];
        PayeezySDK* myClient = [[PayeezySDK alloc]initWithApiKey:KApiKey apiSecret:KApiSecret merchantToken:patientService.paymentToken  url:PURL];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:2];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        
        NSString *numberString = [NSString stringWithFormat:@"%@", patientService.amount];
        //NSLog(@"Result...%@",numberString);//Result 22.37
        float amt = [numberString floatValue];
        int   amount = amt * 100;
        NSString *stramt = [NSString stringWithFormat:@"%d",amount];
        
        //patientService.amount
        [myClient submitAuthorizePurchaseTransactionWithCreditCardDetails:credit_card[@"cvv"] cardExpMMYY:credit_card[@"exp_date"] cardNumber:strtoken cardHolderName:credit_card[@"cardholder_name"]  cardType:credit_card[@"type"] currencyCode:patientService.Currencyid totalAmount:stramt merchantRef:patientService.merchantId   transactionType:@"purchase" token_type:@"FDToken" method:@"token" completion:^(NSDictionary *dict, NSError *error)
         {
             NSString *authStatusMessage = nil;
             if (error == nil)
             {
                 if ([[dict objectForKey:@"transaction_status"] isEqualToString:@"approved"]){
                     patientService.payment_status=@"Authorize";
                     patientService.correlation_id = @"";
                     patientService.transaction_status = [dict objectForKey:@"transaction_status"];
                     patientService.transaction_type =[dict objectForKey:@"transaction_type"];
                     patientService.correlation_id  = [dict objectForKey:@"correlation_id"];
                     patientService.transaction_id = [dict objectForKey:@"transaction_id"];
                     patientService.validation_status = [dict objectForKey:@"validation_status"];
                     patientService.transaction_tag = [dict objectForKey:@"transaction_tag"];
                     patientService.method = [dict objectForKey:@"method"];
                     patientService.amount = patientService.amount;
                     patientService.currency = [dict objectForKey:@"currency"];
                     patientService.bank_resp_code = [dict objectForKey:@"bank_resp_code"];
                     patientService.bank_message = [dict objectForKey:@"bank_message"];
                     patientService.gateway_resp_code = [dict objectForKey:@"gateway_resp_code"];
                     patientService.gateway_message = [dict objectForKey:@"gateway_message"];
                     
                     isPaymentDone = @"yes";
                     [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"ccdetails"];
                     [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"fdtoken"];
                     [self postPaymentInfo];
                 }
             }
             else
             {
                 authStatusMessage = [NSString stringWithFormat:@"Error was encountered processing transaction: %@", error.debugDescription];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"First Data Payment Authorization"
                                                                 message:authStatusMessage delegate:self
                                                       cancelButtonTitle:@"Dismiss"
                                                       otherButtonTitles:nil];
                 [alert show];
                 [countdownTimer invalidate];
                 OTError* error = nil;
                 [_session disconnect:&error];
                 if (error) {
                     //NSLog(@"disconnect failed with error: (%@)", error);
                 }
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ForceUpdateLocation" object:self userInfo:[NSDictionary dictionaryWithObject:@"2" forKey:@"pnumb"]];
             }
         }];
    }
    else{
        //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
    }
}



//Doctor to patient Call Events.

- (IBAction)patientAcceptedCall:(id)sender {
    OTError* error = nil;
    [_session disconnect:&error];
    if (error) {
        //NSLog(@"disconnect failed with error: (%@)", error);
    }
    doctorService.isAlreadyOnCall = 1;
    [_ringingFooterView setHidden:YES];
    [self connectToAnOpenTokSession];
}

-(IBAction)patientRejectedCall :(id)sender {
    
   // NSLog(@"PATIENT REJECT CALL");
    doctorService.isAlreadyOnCall  = 0;
    [_ringingFooterView setHidden:YES];
    [_myAudioDevice stopRingtone];
    
    Reachability* reach = [Reachability reachabilityWithHostname:kreachability];
    BOOL reachable = reach. isReachable;
    if (reachable) {
        NSString *start_time = doctorService.strStartTime;
        NSString *end_time = doctorService.endTime;
        NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
        [paramater setObject:doctorService.visit_id forKey:@"patient_visit_id"];
        [paramater setObject:kCallInterupted forKey:@"call_status"];
        [paramater setObject:kCallInterupted forKey:@"appointment_status_id"];
        [paramater setObject:UDGet(@"uid") forKey:@"call_dropped_by"];
        [paramater setObject:@"NO" forKey:@"is_call_dropped"];
        [paramater setObject:@"Call interrupted by patient" forKey:@"call_status_description"];
        [paramater setObject:doctorService.call_duration forKey:@"call_duration"];
        [paramater setObject:@"" forKey:@"start_time"];
        [paramater setObject:@"" forKey:@"end_time"];
        CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
        [service postEndCallData:paramater WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    else {
        // //[IODUtils showMessage:INTERNET_ERROR withTitle:@"Error"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) postPaymentInfo {
    CommonServiceHandler *service =[[CommonServiceHandler alloc] init];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:patientService.res_visit_id forKey:@"patient_visit_id"];
    [parameter setObject:patientService.correlation_id forKey:kcorrelation_id];
    [parameter setObject:patientService.transaction_status forKey:ktransaction_status];
    [parameter setObject:patientService.validation_status forKey:kvalidation_status];
    [parameter setObject:patientService.transaction_type forKey:ktransaction_type];
    [parameter setObject:patientService.transaction_id forKey:ktransaction_id];
    [parameter setObject:patientService.transaction_tag forKey:ktransaction_tag];
    [parameter setObject:patientService.method forKey:kmethod];
    [parameter setObject:[NSString stringWithFormat:@"%@$",patientService.amount] forKey:kamount];
    [parameter setObject:patientService.couponCode forKey:@"coupan"];
    
    [parameter setObject:patientService.currency forKey:kcurrency];
    [parameter setObject:patientService.bank_resp_code forKey:kbank_resp_code];
    [parameter setObject:patientService.bank_message forKey:kbank_message];
    [parameter setObject:patientService.gateway_resp_code forKey:kgateway_resp_code];
    [parameter setObject:patientService.gateway_message forKey:kgateway_message];
    [parameter setObject:patientService.amount forKey:@"price"];
    [parameter setObject:patientService.couponPrice forKey:@"coupon_price"];
    [parameter setObject:patientService.doctorPrice forKey:@"doctor_price"];
    
   // NSLog(@"Parametr %@",parameter);
    
    [service postPaymentInfo:parameter WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]) {
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)toggleCameraPosition:(id)sender
{
    if (_publisher.cameraPosition == AVCaptureDevicePositionBack) {
        _publisher.cameraPosition = AVCaptureDevicePositionFront;
        self.cameraToggleButton.selected = NO;
        self.cameraToggleButton.highlighted = NO;
    } else if (_publisher.cameraPosition == AVCaptureDevicePositionFront) {
        _publisher.cameraPosition = AVCaptureDevicePositionBack;
        self.cameraToggleButton.selected = YES;
        self.cameraToggleButton.highlighted = YES;
    }
}

- (IBAction)toggleAudioPublish:(id)sender
{
    if (_publisher.publishAudio == YES) {
        _publisher.publishAudio = NO;
        self.audioPubUnpubButton.selected = YES;
        [self.audioPubUnpubButton setBackgroundImage:[UIImage imageNamed:@"mute-off.png"] forState:UIControlStateNormal];
    } else {
        _publisher.publishAudio = YES;
        self.audioPubUnpubButton.selected = NO;
        [self.audioPubUnpubButton setBackgroundImage:[UIImage imageNamed:@"mute.png"] forState:UIControlStateNormal];
    }
}

-(void)sendSignalforInterruptedminutes{
    OTError* error = nil;
    
    currMinute =  doctorService.InterruptionTime;
    
    NSString *remainingtime = [NSString stringWithFormat:@"%d",currMinute];
    [_session signalWithType:@"remaining_time" string:remainingtime connection:nil error:&error];
    if (error) {
       // NSLog(@"error %@", error);
    } else {
    }
}

#pragma Document Events
-(IBAction)openDocumentView:(id)sender {
    //    [UIView transitionWithView:self.view
    //                      duration:0.3f
    //                       options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionCurveEaseInOut
    //                    animations:^{
    if(_documentView.hidden){
        [_documentView setHidden:NO];
        [_subscriberView bringSubviewToFront:_documentView];
        [_chatView setHidden:YES];
        [_btnDocument setBackgroundImage:[UIImage imageNamed:@"video-icon.png"] forState:UIControlStateNormal];
    }
    else {
        [_documentView setHidden:YES];
        [_chatView setHidden:YES];
        [_btnDocument setBackgroundImage:[UIImage imageNamed:@"view-document-2.png"] forState:UIControlStateNormal];
        [_videoContainerView setHidden:NO];
        [_videoContainerView bringSubviewToFront: _subscriberView];
    }
    // } completion:NULL];
}






- (void)logSignalString:(NSString*)string fromSelf:(Boolean)fromSelf {
    
    int prevLength = _chatReceivedTextView.text.length - 1;
    [_chatReceivedTextView insertText:string];
    [_chatReceivedTextView insertText:@"\n"];
    
    if (fromSelf) {
        NSDictionary* formatDict = @{NSForegroundColorAttributeName: [UIColor blueColor]};
        NSRange textRange = NSMakeRange(prevLength + 1, string.length);
        [_chatReceivedTextView.textStorage setAttributes:formatDict range:textRange];
        // [arrChat addObject:string];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //        [dict setObject:@"me" forKey:@"sendby"];
        //        [dict setObject:string forKey:@"message"];
        //[Message messageWithString:@"How is that bubble component of yours coming along?" image:[UIImage imageNamed:@"jonnotie.png"]]
        [Message messageWithString:string usertype:@"me"];
        [arrChat addObject:[Message messageWithString:string usertype:@"me"]];
    }
    else {
        [self bounce:_btnChat];
        NSDictionary* formatDict = @{NSForegroundColorAttributeName: [UIColor redColor]};
        NSRange textRange = NSMakeRange(prevLength + 1, string.length);
        [_chatReceivedTextView.textStorage setAttributes:formatDict range:textRange];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        [arrChat addObject:[Message messageWithString:string usertype:@"other"]];
    }
    [_chatReceivedTextView setContentOffset:_chatReceivedTextView.contentOffset animated:NO];
    [_chatReceivedTextView scrollRangeToVisible:NSMakeRange([_chatReceivedTextView.text length], 0)];
    
    [_tblChat reloadData];
    //NSLog(@"Chat is %@", arrChat);
}


#pragma mark - UITableViewDatasource methods



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Bubble Cell";
    
    STBubbleTableViewCell *cell = (STBubbleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[STBubbleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = self.tblChat.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataSource = self;
        cell.delegate = self;
    }
    
    Message *message = [arrChat objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = message.message;
    
    if([message.userType isEqualToString:@"me"]) {
        cell.authorType = STBubbleTableViewCellAuthorTypeSelf;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.bubbleColor = STBubbleTableViewCellBubbleColorGreen;
        
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.authorType = STBubbleTableViewCellAuthorTypeOther;
        cell.bubbleColor = STBubbleTableViewCellBubbleColorGray;
    }
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [arrChat objectAtIndex:indexPath.row];
    
    CGSize size;
    
    if(message.avatar)
    {
        size = [message.message boundingRectWithSize:CGSizeMake(self.tblChat.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - STBubbleImageSize - 8.0f - STBubbleWidthOffset, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                             context:nil].size;
    }
    else
    {
        size = [message.message boundingRectWithSize:CGSizeMake(self.tblChat.frame.size.width - [self minInsetForCell:nil atIndexPath:indexPath] - STBubbleWidthOffset, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]}
                                             context:nil].size;
    }
    
    // This makes sure the cell is big enough to hold the avatar
    if(size.height + 25.0f < STBubbleImageSize + 4.0f && message.avatar)
    {
        return STBubbleImageSize + 4.0f;
    }
    return size.height + 25.0f;
}

#pragma mark - STBubbleTableViewCellDataSource methods

- (CGFloat)minInsetForCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        return 100.0f;
    }
    return 50.0f;
}

#pragma mark - STBubbleTableViewCellDelegate methods

- (void)tappedImageOfCell:(STBubbleTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Message *message = [arrChat objectAtIndex:indexPath.row];
    //NSLog(@"%@", message.message);
}





@end
