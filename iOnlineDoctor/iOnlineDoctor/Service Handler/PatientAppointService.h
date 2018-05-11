//
//  PatientAppointService.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/19/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BaseServiceHandler.h"
typedef void (^callBackBlock)(NSDictionary *responseCode, NSError *error);

@interface PatientAppointService : BaseServiceHandler
+ (id)sharedManager;

@property (nonatomic, retain) NSString  *doctor_id;
@property (nonatomic,retain) NSString *visit_type_id;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *question_1;
@property (nonatomic,assign) NSString *question_2;
@property (nonatomic,assign) NSString *q_2;

@property (nonatomic,retain) NSString *question_3;
@property (nonatomic,retain) NSString *question_4;
@property (nonatomic,retain) NSString *question_5;
@property (nonatomic,retain) NSString *question_6;
@property (nonatomic,retain) NSString *question_7;
@property (nonatomic,assign) int payment_mode_id;
@property (nonatomic,retain) NSString *payment_status;
@property (nonatomic,retain) NSString *member_name;
@property (nonatomic,retain) NSString *member_dob;
@property (nonatomic,assign) int member_gender;
@property (nonatomic,retain) NSString *question_1_option_value;
@property (nonatomic,retain) NSString *correlation_id;
@property (nonatomic,retain) NSString *transaction_status;
@property (nonatomic,retain) NSString *transaction_type;
@property (nonatomic,retain) NSString *transaction_id;
@property (nonatomic,retain) NSString *transaction_tag;
@property (nonatomic,retain) NSString *amount;
@property (nonatomic,retain) NSString *currency;
@property (nonatomic,retain) NSString *bank_resp_code;
@property (nonatomic,retain) NSString *bank_message;
@property (nonatomic,retain) NSString *gateway_resp_code;
@property (nonatomic,retain) NSString *gateway_message;
@property (nonatomic,retain) NSString *validation_status;
@property (nonatomic,retain) NSString *method;
@property (nonnull,retain)   NSString *selectedCategory;
@property (nonnull,retain)   NSString *couponCode;
@property (nonatomic, retain) NSString *remainingTime;
@property (nonatomic, retain) NSString *strCurrency;
@property (nonatomic,retain)  NSString *question_8_code;
@property (nonatomic,retain)  NSString *question_8_id;

@property (nonatomic,retain) NSString *selectedDoctorCountry;
@property (nonatomic,assign) int isPracticeCallDone;
@property (nonatomic,assign) int doctorPracticeCount;


//mit - NEW

@property (nonatomic,retain) NSMutableArray * arrDocType;

@property (nonatomic,retain) NSMutableArray * arrDocumentData;
@property (nonatomic, retain) NSMutableArray * documentName;
@property (nonatomic, retain) NSString *selectedCategoryName;
@property (nonatomic, retain) NSString *isFromliveCall;
@property (nonatomic, retain) NSString *slot_id;
@property (nonatomic, retain) NSMutableArray *ReferalDoc;
@property (nonatomic, retain) NSString *selectedTab;
@property (nonatomic, retain) NSString *isFrom;

@property (nonatomic, retain) NSString *isFromLiveVideoCall;


@property (nonatomic,assign) int fromDashboard;

// Session Respionse data
@property (nonatomic,retain) NSString *res_call_duration;
@property (nonatomic,retain) NSString *res_doctor_address;
@property (nonatomic,retain) NSString *res_doctor_id;
@property (nonatomic,retain) NSString *res_doctor_name;
@property (nonatomic,retain) NSString *res_profile_pic;
@property (nonatomic,retain) NSString *res_session_id;
@property (nonatomic,retain) NSString *res_session_token;
@property (nonatomic,retain) NSString *res_visit_id;

@property (nonatomic,retain) NSString * res_order_no;
@property (nonatomic,retain) NSString * res_date;
@property (nonatomic,retain) NSString * res_startTime;


//Payment options
@property (nonatomic,retain) NSString * paymentToken;
@property (nonatomic,retain) NSString * merchantId;
@property (nonatomic,retain) NSString * Currencyid;

// payment
@property (nonatomic, retain) NSString *couponMessage;
@property (nonatomic, retain) NSString *couponPrice;
@property (nonatomic, retain) NSString *remainingPrice;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *doctorPrice;
@property (nonatomic, retain) NSString *usdPrice;



-(void)postAppointmentDetail:(NSDictionary*)parameter andImageName:(NSMutableArray *)image andImages:(NSMutableArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock;

//mit - NEW
-(void)bookAppointment:(NSDictionary*)parameter andImageName:(NSMutableArray *)image andImages:(NSMutableArray *)imageData dataType:(NSMutableArray*)type WithCompletionBlock:(callBackBlock)completionBlock;

@end
