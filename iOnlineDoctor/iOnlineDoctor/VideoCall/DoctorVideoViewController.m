//
//  DoctorVideoViewController.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/6/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "DoctorVideoViewController.h"
#import <OpenTok/OpenTok.h>
#import "OTAudioDeviceRingtone.h"
#import "DoctorAppointmentServiceHandler.h"
#import "UIColor+HexString.h"
#import "UIImageView+WebCache.h"
#import "Message.h"
#import "STBubbleTableViewCell.h"
#import "IODUtils.h"
#import "CommonServiceHandler.h"
#import "CallInterruptionViewController.h"


// Replace with your OpenTok API key
static NSString* kApiKey = @"45960372";
// Replace with your generated session ID

@interface DoctorVideoViewController ()<OTSessionDelegate, OTPublisherDelegate,OTSubscriberDelegate,UITextFieldDelegate,STBubbleTableViewCellDataSource, STBubbleTableViewCellDelegate>
{
    MMPulseView *pulseView;
    DoctorAppointmentServiceHandler *doctorService;
    NSTimer *timerForWaiting;
    NSTimer *timerForDoctor;
    
    NSTimer *countdownTimer;
    int currMinute;
    int currSeconds;
    NSMutableArray *arrChat;
    
    OTAudioDeviceRingtone* _myAudioDevice;
    BOOL _reconnectPlease;
    NSMutableArray *backgroundConnectedStreams;
    NSString* startTime;
    NSString *endTime;
    NSString *UserId;
    BOOL isCallEnd;
    NSString *strStatus;
    NSString *strAppointmentStaus;
    
    
}


@property (nonatomic) OTSession *session;
@property (nonatomic) OTPublisher *publisher;
@property (nonatomic) OTSubscriber *subscriber;
@property (weak, nonatomic)  NSString *strToken;
@property (weak, nonatomic)  NSString *strSession;
@property (weak, nonatomic)  NSString *strDoctorName;
@property (weak, nonatomic)  NSString *strImageUrl;

- (void)batteryLevelChanged:(NSNotification *)notification;


@end

@implementation DoctorVideoViewController
-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)batteryLevelChanged:(NSNotification *)notification
{
    NSString *signalText = [NSString stringWithFormat:@"%f", [UIDevice currentDevice].batteryLevel];
    OTError *error;
        if (error) {
       // [IODUtils showMessage:@"" withTitle:[error localizedDescription]];
        
    }
}


- (void)viewDidLoad {
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryLevelChanged:)
                                                 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    doctorService = [DoctorAppointmentServiceHandler sharedManager];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
    self.navigationItem.backBarButtonItem = nil;
    UserId = UDGet(@"uid");
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    [_btnChat setBackgroundImage:[UIImage imageNamed:@"msg-icon.png"] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
    _myAudioDevice = [[OTAudioDeviceRingtone alloc] init];
    [OTAudioDeviceManager setAudioDevice:_myAudioDevice];
    _chatInputTextField.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated {

    if(![doctorService.isFromDocument isEqualToString:@"yes"]) {
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
        
        self.lblWaitingPatientName.text = doctorService.patient_name;
        self.lblRingingPatientName.text = doctorService.patient_name;
        arrChat = [[NSMutableArray alloc] init];
        
      //  [_imgPatientProfile sd_setImageWithURL:[NSURL URLWithString:doctorService.profile_pic] placeholderImage:[UIImage imageNamed:@"D-calling-icon.png"]];
        
        [_imgPatientProfile setImage:[UIImage imageNamed:@"D-calling-icon.png"]];
        [_imgPatientProfile.layer setCornerRadius:_imgPatientProfile.frame.size.height/2];
        _imgPatientProfile.clipsToBounds =YES;
        
        [ _tblChat setBackgroundColor:[UIColor colorWithHexString:@"f0f8d1"]];
        [self hideallViews];
        [self startAnimating];
        [_ringingView setHidden:NO];
        if([doctorService.isCallInterrupted isEqualToString: @"yes"]) {
            [_ringingFooterView setHidden:YES];
            [self interruptedCall];
        }
        else {
            strStatus = kCallDropped;
            strAppointmentStaus = kCallDropped;
            timerForWaiting = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(CallUnaccepted)userInfo:nil repeats:NO];
        }
        
    }
    else{
    if ([doctorService.currentView isEqualToString:@"ringing"]) {
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
            
            self.lblWaitingPatientName.text = doctorService.patient_name;
            [_imgPatientProfile sd_setImageWithURL:[NSURL URLWithString:doctorService.profile_pic] placeholderImage:[UIImage imageNamed:@"D-calling-icon.png"]];
            [_imgPatientProfile.layer setCornerRadius:_imgPatientProfile.frame.size.width/2];
            
            [_imgPatientProfile setClipsToBounds:YES];
            
            arrChat = [[NSMutableArray alloc] init];
            [ _tblChat setBackgroundColor:[UIColor colorWithHexString:@"f0f8d1"]];
            [self hideallViews];
            [_ringingView setHidden:NO];
            if([doctorService.isCallInterrupted isEqualToString: @"yes"]) {
                [_ringingFooterView setHidden:YES];
                [self interruptedCall];
            }
            else {
                [_ringingFooterView setHidden:NO];
                [self normalCall];
                doctorService.currentView = @"ringing";
            }
            
        } else {
           // NSLog(@"Else is called");
           // [self hideallViews];
           //[self publihStream];
            [_videoContainerView setHidden:NO];
             doctorService.isFromDocument = @"no";
            
        }
    }
}




- (void)enteringBackgroundMode:(NSNotification*)notification
{
    _publisher.publishVideo = NO;
    _subscriber.subscribeToVideo = NO;
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

-(void)interruptedCall {
     [self connectToAnOpenTokSession];
    strStatus = kCallSuccess;
    strAppointmentStaus = kCallSuccess;
    timerForWaiting = [NSTimer scheduledTimerWithTimeInterval:60
                                                       target:self
                                                     selector:@selector(CallUnaccepted)
                                                     userInfo:nil
                                                      repeats:NO];
    
}

-(void) normalCall {
    [self startAnimating];
    
    strStatus = kCallDropped;
    strAppointmentStaus = kCallDropped;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    if(![doctorService.isFromDocument isEqualToString:@"yes"]){
    timerForWaiting = [NSTimer scheduledTimerWithTimeInterval:60
                                                       target:self
                                                     selector:@selector(CallUnaccepted)
                                                     userInfo:nil
                                                      repeats:NO];
    }
    
}

//When the doctor doesnt acceps the call
-(void)CallUnaccepted {
    
    [timerForWaiting invalidate];
    [_myAudioDevice stopRingtone];
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    date = [IODUtils toLocalTime:date];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    endTime = [NSString stringWithFormat:@"%@", date];
    [self sendSignal];
    OTError* error = nil;
    [_session disconnect:&error];
    if (error) {
        ////NSLog(@"disconnect failed with error: (%@)", error);
    }
    NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
    [paramater setObject:self.visit_id forKey:@"patient_visit_id"];
    [paramater setObject:strStatus forKey:@"call_status"];
    [paramater setObject:strAppointmentStaus forKey:@"appointment_status_id"];
    [paramater setObject:UserId forKey:@"call_dropped_by"];
    [paramater setObject:@"YES" forKey:@"is_call_dropped"];
    [paramater setObject:@"Call disconnected due to not pickup" forKey:@"call_status_description"];
    [paramater setObject:doctorService.call_duration forKey:@"call_duration"];
    [paramater setObject:@"" forKey:@"start_time"];
    [paramater setObject:@"" forKey:@"end_time"];
    doctorService.isFromVideo = 0;
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service postEndCallData:paramater WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        //NSLog(@"End call done");
        doctorService.isFromVideo = 1;
        doctorService.status = @"callend";
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
        UIViewController *viewTab=[sb instantiateViewControllerWithIdentifier:@"TabVC"];
       // [self.navigationController pushViewController:viewTab animated:YES];
        //[viewTab.navigationController setNavigationBarHidden:TRUE animated:FALSE];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    
    //[[self.navigationController popToRootViewControllerAnimated:YES];

   
}

- (void)hideallViews{
    [_ringingView setHidden:YES];
    [_ringingDocumentView setHidden:YES];
    [_documentView setHidden:YES];
    [_chatView setHidden:YES];
    [_documentView setHidden:YES];
    [_videoContainerView setHidden:YES];
    [_waitingView setHidden:YES];
}
- (void)stopAnimating {
    [pulseView stopAnimation];
}
-(void)startAnimating {
    backgroundConnectedStreams = [[NSMutableArray alloc] init];
    [_ringingView setHidden:NO];
    [_lblRing setHidden:NO];
    [_lblPatientName setHidden:NO];
    _lblPatientName.text = doctorService.patient_name;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"appleiphone"
                                                     ofType:@"mp3"];
    NSURL* url = [NSURL URLWithString:path];
    [_myAudioDevice playRingtoneFromURL:url];
    NSMutableArray *pulseArray = @[].mutableCopy;
    [pulseArray addObject:[MMPulseView new]];
    NSInteger index = 0;
    pulseView = pulseArray[index];
    pulseView.frame = CGRectMake(self.view.frame.origin.x,30,self.view.frame.size.width,self.view.frame.size.height);
    [_ringingView addSubview:pulseView];
    UIImageView *userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [pulseView startAnimation];
    [_ringingView addSubview:userImage];
    [userImage sd_setImageWithURL:[NSURL URLWithString:doctorService.profile_pic] placeholderImage:[UIImage imageNamed:@"D-calling-icon.png.png"]];
    [userImage  setBackgroundColor:[UIColor redColor]];
    [userImage.layer setCornerRadius:userImage.frame.size.height/2];
    userImage.clipsToBounds =YES;
    userImage.backgroundColor = [UIColor whiteColor];
    userImage.center = pulseView.center;
    [_ringingView bringSubviewToFront:userImage];
    [_ringingView bringSubviewToFront:_ringingFooterView];
}

#pragma mark Opentok Events

# pragma mark - OTPublisher delegate callbacks
- (void)publisher:(OTPublisherKit*)publisher
 didFailWithError:(OTError*) error
{
    //NSLog(@"The publisher failed: %@", error);
}


- (void)sessionDidBeginReconnecting:(OTSession *)session
{
   // [self showReconnectingAlert];
}

- (void)sessionDidReconnect:(OTSession *)session
{
   // [self dismissReconnectingAlert];
}

-(void)setUI {
    [ _tblChat setBackgroundColor:[UIColor colorWithHexString:@"f0f8d1"]];
}

# pragma mark - OTSession delegate callbacks
- (void)sessionDidConnect:(OTSession*)session
{
    doctorService.currentView = @"video";
    if([doctorService.isCallInterrupted isEqualToString:@"yes"]) {
        [self hideallViews];
        [self publihStream];
        
 
    }else {
        [self publihStream];
    }
}


#pragma mark Timer

- (void)publihStream {
    
    if (_session.capabilities.canPublish) {
      //  NSLog(@"can publish");
        // The client can publish.
    } else {
      //  NSLog(@"cannot publish");
        // The client cannot publish.
        // You may want to notify the user.
    }
    
    [_subscriberView bringSubviewToFront:_lblTimer];
    [_subscriberView bringSubviewToFront:_imgLogo];
    
    [timerForWaiting invalidate];
    timerForWaiting = nil;
    OTPublisherSettings *settings = [[OTPublisherSettings alloc] init];
    settings.cameraResolution = OTCameraCaptureResolutionLow;
    settings.cameraFrameRate = OTCameraCaptureFrameRate30FPS;
    settings.name = [UIDevice currentDevice].name;
    _publisher = [[OTPublisher alloc] initWithDelegate:self settings:settings];
    OTError *error = nil;
    [_session publish:_publisher error:&error];
    if (error)
    {
        // [self.navigationController popToRootViewControllerAnimated:YES];
      //  [IODUtils showMessage:error.description withTitle:@"Error in opentok publish streaam method"];
        
        [IODUtils showFCAlertMessage:[error localizedDescription] withTitle:@"" withViewController:self with:@"error"];

    }
    [_publisher.view setFrame:CGRectMake(0, 0, _publisherView.bounds.size.width,
                                         _publisherView.bounds.size.height)];
    [_publisherView addSubview:_publisher.view];
    
    [_publisherView bringSubviewToFront:_publisher.view];
    // [_videoContainerView setHidden:NO];
    [self.view bringSubviewToFront:_videoContainerView];
    [_subscriber.view setFrame:CGRectMake(0,0,_subscriberView.bounds.size.width,_subscriberView.bounds.size.height)];
    [_subscriberView addSubview:_subscriber.view];
    [_subscriberView bringSubviewToFront:_publisherView];
    [_publisherView.layer setBorderWidth:3.0];
    [_publisherView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_subscriberView bringSubviewToFront:_footerView];
    [_subscriberView bringSubviewToFront:_lblTimer];
    [_subscriberView bringSubviewToFront:_imgLogo];
    [_videoContainerView bringSubviewToFront:_subscriberView];
    
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    date = [IODUtils toLocalTime:date];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    startTime  = [NSString stringWithFormat:@"%@",date];
    [self hideallViews];
    [_videoContainerView setHidden:NO];
  //
    
    if([doctorService.isCallInterrupted isEqualToString:@"yes"]){
        [self sendSignalforInterruptedminutes ];
    }
    else{
       [self startCoundownTimer];
    }
}

-(void)timesUp {
    [timerForDoctor invalidate];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)startCoundownTimer {
  
    if([doctorService.isCallInterrupted isEqualToString:@"yes"]){
        currMinute = doctorService.InterruptionTime;
        currSeconds=00;
       // [_lblTimer setText:[NSString stringWithFormat:@"%d:%d",currMinute,currSeconds]];

        _lblTimer.text =[NSString stringWithFormat:@"%d:%d",currMinute,currSeconds];
        
    }
    else if([doctorService.visit_type isEqualToString:@"second-opinion"]){
        [_lblTimer setText:@"30:00"];
        currMinute=30;
        currSeconds=00;
    }
    else {
        [_lblTimer setText:@"15:00"];
        currMinute=15;
        currSeconds=00;
    }
    countdownTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:countdownTimer forMode:NSRunLoopCommonModes];
    
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
            [UIView animateWithDuration:1 delay:1.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
                _lblTimer.alpha = 0;
            } completion:nil];
        }
    }
    else
    {
        [self sendSignal];
        [self successfullCall];
        [countdownTimer invalidate];
        OTError* error = nil;
        [_session disconnect:&error];
        if (error) {
            ////NSLog(@"disconnect failed with error: (%@)", error);
        }
        doctorService.isFromVideo = 0;
        doctorService.callEnd =@"yes";
        doctorService.status = @"callend";
        
        //    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
        //    UIViewController *viewTab=[sb instantiateViewControllerWithIdentifier:@"TabVC"];
        //    [self.navigationController pushViewController:viewTab animated:YES];
        //     [viewTab.navigationController setNavigationBarHidden:TRUE animated:FALSE];
    }
}


- (void)publisher:(nonnull OTPublisherKit*)publisher
  streamDestroyed:(nonnull OTStream*)stream {
  //  NSLog(@"Publisher diasconnecdted");
}

- (void)sessionDidDisconnect:(OTSession*)session
{
   // NSLog(@"The client disconnected from the OpenTok session.");
}

- (void) session:(OTSession*)session
didFailWithError:(OTError*)error
{
   // NSLog(@"session didFailWithError %@",error.description);
    if(error.code == 1022){
        OTError* error = nil;
        [_session disconnect:&error];
        if (error) {
            //NSLog(@"disconnect failed with error: (%@)", error);
        }
        [countdownTimer invalidate];
        
        doctorService.InterruptionTime = currMinute;
        CallInterruptionViewController *interruptionVC =[self.storyboard instantiateViewControllerWithIdentifier:@"CallInterruptionViewController"];
        [self.navigationController pushViewController:interruptionVC animated:NO];
    }
}
- (void)session:(OTSession*)session
  streamCreated:(OTStream *)stream
{
    
   // NSLog(@"Create stream");
    [self createSubscriber:stream];
}

- (void)createSubscriber:(OTStream *)stream
{
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
           // [IODUtils showMessage:[error localizedDescription] withTitle:@"Error"];
            
              [IODUtils showFCAlertMessage:[error localizedDescription] withTitle:@"" withViewController:self with:@"error"];
        }
    }
}

- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
    //NSLog(@"A stream was destroyed in the session.");
    OTError* error = nil;
    [_session disconnect:&error];
    if (error) {
        //NSLog(@"disconnect failed with error: (%@)", error);
    }
     [countdownTimer invalidate];
    doctorService.InterruptionTime = currMinute;
    CallInterruptionViewController *interruptionVC =[self.storyboard instantiateViewControllerWithIdentifier:@"CallInterruptionViewController"];
    [self.navigationController pushViewController:interruptionVC animated:NO];
    
}
- (void)subscriberDidDisconnectFromStream:(nonnull OTSubscriberKit*)subscriber{
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    date = [IODUtils toLocalTime:date];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    endTime  = [NSString stringWithFormat:@"%@",date];
    
    OTError* error = nil;
}

# pragma mark - OTSubscriber delegate callbacks
- (void)subscriberDidConnectToStream:(OTSubscriberKit *)subscriber {
    
       if([doctorService.isCallInterrupted isEqualToString:@"yes"]){
           [timerForDoctor invalidate];
           [timerForWaiting invalidate];
           [countdownTimer invalidate];
           //[self publihStream];
    }
    else {
        [timerForDoctor invalidate];
        [_waitingView setHidden:YES];
        [_subscriber.view setFrame:CGRectMake(0,0,_subscriberView.bounds.size.width,_subscriberView.bounds.size.height)];
        [_subscriberView addSubview:_subscriber.view];
        [_subscriberView bringSubviewToFront:_publisherView];
        [_publisherView.layer setBorderWidth:3.0];
        [_publisherView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_subscriberView bringSubviewToFront:_footerView];
        [self hideallViews];
        [_videoContainerView setHidden:NO];
        [_videoContainerView bringSubviewToFront:_subscriberView];
        [_subscriberView bringSubviewToFront:_lblTimer];
        [_subscriberView bringSubviewToFront:_imgLogo];

      }
}


- (void)subscriber:(OTSubscriberKit*)subscriber
  didFailWithError:(OTError*)error
{
    // Stop ringtone from playing, as the subscriber will connect shortly
    [_myAudioDevice stopRingtone];
    //NSLog(@"subscriber %@ didFailWithError %@",
    //  subscriber.stream.streamId,
    // error);
}

#pragma mark Ringing Events

-(IBAction)RingingAccept:(id)sender {
    _lblRing.text = @"Connecting...";
    [_myAudioDevice stopRingtone];
    [self stopAnimating];
   // [self hideallViews];
    [self.waitingView setHidden:NO];
    [_ringingView setHidden:YES];
    [self.view bringSubviewToFront:self.waitingView];
    [timerForWaiting invalidate];

    [self connectToAnOpenTokSession];
}

- (void)connectToAnOpenTokSession {
    
   // NSLog(@"session is %@",self.strSession);
    
    _session = [[OTSession alloc] initWithApiKey:kApiKey sessionId:self.strSession delegate:self];
    NSError *error;
    [_session connectWithToken:self.session_token error:&error];
    if (error) {
     //   NSLog(@"sessionerror");
    
    }
}
-(IBAction)RingingDocument:(id)sender {
    
    if(_ringingDocumentView.hidden){
        [_ringingView bringSubviewToFront:_ringingDocumentView];
        [_ringingDocumentView setHidden:NO];
        [_btnDocument setBackgroundImage:[UIImage imageNamed:@"video-icon.png"] forState:UIControlStateNormal];
    }
    else {
        [_ringingDocumentView setHidden:YES];
        [_videoContainerView bringSubviewToFront: _ringingDocumentView];
        [_btnDocument setBackgroundImage:[UIImage imageNamed:@"view-document-2.png"] forState:UIControlStateNormal];
    }
}


-(IBAction)RingingRejectCall:(id)sender{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [timerForWaiting invalidate];
    [_myAudioDevice stopRingtone];
    
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    date = [IODUtils toLocalTime:date];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    endTime  = [NSString stringWithFormat:@"%@",date];
    [self sendSignal];
    OTError* error = nil;
    [_session disconnect:&error];
    if (error) {
    }
    NSString *start_time = startTime;
    NSString *end_time = endTime;
    
    NSMutableDictionary *paramater = [[NSMutableDictionary alloc] init];
    [paramater setObject:self.visit_id forKey:@"patient_visit_id"];
    [paramater setObject:kCallDropped forKey:@"call_status"];
    [paramater setObject:kCallDropped forKey:@"appointment_status_id"];
    [paramater setObject:UserId forKey:@"call_dropped_by"];
    [paramater setObject:@"YES" forKey:@"is_call_dropped"];
    [paramater setObject:@"Call disconnected due to call not pickup by Doctor" forKey:@"call_status_description"];
    [paramater setObject:doctorService.call_duration forKey:@"call_duration"];
    [paramater setObject:@"" forKey:@"start_time"];
    [paramater setObject:@"" forKey:@"end_time"];
    
    CommonServiceHandler *service = [[CommonServiceHandler alloc] init];
    [service postEndCallData:paramater WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        //NSLog(@"End call done");
        doctorService.isFromVideo = 1;
        doctorService.status = @"callend";
        [self stopAnimating];
        [self.navigationController popViewControllerAnimated:YES];
    }];
 
}

#pragma mark Call Events

#pragma mark - Chat messaging
-(IBAction)openChatView:(id)sender {
    //    [UIView transitionWithView:self.view
    //                      duration:0.3f
    //                       options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionCurveEaseInOut
    //                    animations:^{
    [_btnChat setBackgroundImage:[UIImage imageNamed:@"msg-icon.png"] forState:UIControlStateNormal];

    if(_chatView.hidden){
        [_chatView setHidden:NO];
        [_documentView setHidden:YES];
        [_subscriberView bringSubviewToFront:_chatView];
        [_btnChat setBackgroundImage:[UIImage imageNamed:@"video-icon.png"] forState:UIControlStateNormal];
    }
    else {
        [_chatView setHidden:YES];
        [_documentView setHidden:YES];
        [_videoContainerView setHidden:NO];
        [_videoContainerView bringSubviewToFront: _subscriberView];
        
        [_btnChat setBackgroundImage:[UIImage imageNamed:@"msg-icon.png"] forState:UIControlStateNormal];
    }
    // } completion:NULL];
}

- (IBAction)sendChatMessage:(id)sender
{
    OTError* error = nil;
    if(_chatInputTextField.text.length > 0) {
        [_session signalWithType:@"chat" string:_chatInputTextField.text connection:nil error:&error];
        if (error) {
            //NSLog(@"Signal error: %@", error);
        } else {
            //NSLog(@"Signal sent: %@", _chatInputTextField.text);
        }
        _chatInputTextField.text = @"";
        [_chatInputTextField resignFirstResponder];
      //  [_tblChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:arrChat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void) sendSignal {
    OTError* error = nil;
    [_session signalWithType:@"endCall" string:@"Call END" connection:nil error:&error];
    if (error) {
        
    } else {
    }
}

-(void)sendSignalforInterruptedminutes{
    OTError* error = nil;
    NSString *remainingtime = [NSString stringWithFormat:@"%d",currMinute];
    [_session signalWithType:@"remaining_time" string:remainingtime connection:nil error:&error];
    if (error) {
        NSLog(@"error %@", error);
    } else {
    }
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

- (void)session:(OTSession*)session receivedSignalType:(NSString*)type fromConnection:(OTConnection*)connection withString:(NSString*)string {
    if([type isEqualToString:@"endCall"]) {
        OTError* error = nil;
        [_session disconnect:&error];
        if (error) {
         //   NSLog(@"disconnect failed with error: (%@)", error);
        }
    }
    else if([type caseInsensitiveCompare:@"callComeFrom"]==NSOrderedSame){
    }
    
    else if([type isEqualToString:@"remaining_time"]) {
        OTError* error = nil;
        [_session disconnect:&error];
        if (error) {
          //  NSLog(@"disconnect failed with error: (%@)", error);
        }
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

# pragma mark - UITextFieldDelegate callbacks
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _chatInputTextField.text = @"";
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //  [self sendChatMessage];
    [self.view endEditing:YES];
    return YES;
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

- (IBAction)btnEndCallPressed:(id)sender {
    [timerForWaiting invalidate];
    [countdownTimer invalidate];
    doctorService.callEnd =@"yes";
    [self successfullCall];
}

- (void)successfullCall{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // NSDate  *date = [NSDate date];
  //  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  //  date = [IODUtils toLocalTime:date];
  //  [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
 //   endTime  = [formatter stringFromDate:date];
    
    NSDate  *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    date = [IODUtils toLocalTime:date];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    endTime  = [NSString stringWithFormat:@"%@",date];
    
    [self sendSignal];
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
        
        if(!error) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
            UIViewController *viewTab=[sb instantiateViewControllerWithIdentifier:@"TabVC"];
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController:viewTab animated:YES];
        }
        else {
           // [IODUtils showMessage:@"Something went wrong" withTitle:@"Error"];
              [IODUtils showFCAlertMessage:[error localizedDescription] withTitle:@"" withViewController:self with:@"error"];
        }
  
    }];
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
    [_btnChat setBackgroundImage:[UIImage imageNamed:@"chat-notification.png"] forState:UIControlStateNormal];
    
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


@end
