//
//  PatientAppointService.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/19/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "PatientAppointService.h"
#import "AppSettings.h"
@implementation PatientAppointService

+ (id)sharedManager {
    static PatientAppointService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.doctor_id = @"";
        self.visit_type_id = @"";
        self.date = @"" ;
        self.question_1 = @"" ;
        self.q_2 = @"";
        self.question_2 = @"";
        self.question_3 = @"";
        self.question_4 = @"";
        self.question_5= @"";
        self.question_6= @"";
        self.question_7= @"";
        self.payment_mode_id= 0;
        self.payment_status= @"";
        self.member_name= @"";
        self.member_dob= @"";
        self.member_gender= 0;
        self.question_1_option_value= @"";
        self.correlation_id= @"";
        self.transaction_status= @"";
        self.transaction_type= @"";
        self.transaction_id= @"";
        self.transaction_tag= @"";
        self.validation_status = @"";
        self.amount= @"";
        self.currency= @"";
        self.bank_resp_code= @"";
        self.bank_message= @"";
        self.gateway_resp_code= @"";
        self.gateway_message= @"";
        self.method = @"";
        self. arrDocumentData =[[NSMutableArray alloc] init];
        self.documentName=[[NSMutableArray alloc] init];
        self.arrDocType = [[NSMutableArray alloc]init];
        self.selectedCategory = @"";
        self.doctor_id = @"";
        self.couponCode = @"";
        self.slot_id = @"";
        self.selectedTab = @"";
        self.strCurrency = @"";
        self.question_8_id = @"";
        self.question_8_code = @"";
        
        //Response
        self.res_call_duration = @"";
        self.res_doctor_address = @"";
        self.res_doctor_id = @"";
        self.res_doctor_name = @"";
        self.res_profile_pic= @"";
        self.res_session_id = @"";
        self.res_session_token =@"";
        self.res_visit_id = @"";
        
        self.isFromliveCall = @"";
        self.res_order_no = @"";
        self.res_date = @"";
        self.res_startTime = @"";
        self.fromDashboard = 0;
        self.doctorPracticeCount = -1;
        
        self.paymentToken  = @"";
        self.merchantId  = @"";
        self.Currencyid = @"";
        
        self.couponMessage = @"";
        self.couponPrice = @"";
        self.remainingPrice = @"";
        self.price = @"";
        self.doctorPrice =  @"";
        self.isFrom = @"";
        self.isFromLiveVideoCall = @"";
        self.selectedDoctorCountry = @"";
        self.usdPrice = @"";
        self.ReferalDoc = [[NSMutableArray alloc] init];
    }
    return self;
}

// Post Appontment data
-(void)postAppointmentDetail:(NSDictionary*)parameter andImageName:(NSMutableArray *)image andImages:(NSMutableArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock {
    
//    NSLog(@"iamge is:%@",image);
//    NSLog(@"image data is:%@",imageData);
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kPostPatientDetails];
    [self PostDataWithSingleImage:url imageName:image requestType:post requestParameters:parameter andUploadData:imageData  requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
         completionBlock(response,nil);

    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(error, nil);
    }];
}

//mit - Document Picker (change method name)

-(void)bookAppointment:(NSDictionary*)parameter andImageName:(NSMutableArray *)image andImages:(NSMutableArray *)imageData dataType:(NSMutableArray*)type WithCompletionBlock:(callBackBlock)completionBlock
{
//    NSLog(@"iamge is:%@",image);
//    NSLog(@"image data is:%@",imageData);
    NSLog(@"Type is:%@",type);
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kPostPatientDetails];
    [self PostDataWithImagePDF:url imageName:image requestType:post requestParameters:parameter andUploadData:imageData andDocType:type requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
        
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(error, nil);
    }];
    
}

@end
