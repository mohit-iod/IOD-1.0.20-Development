//
//  Constants.h
//  PayeezyClientSample
//
//  Created by Deepak Patel on 8/25/17.
//  Copyright © 2017 First Data Corporation. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define IS_IPHONE_6PLUS (IS_IPHONE && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width


#define kBorderWidthTextInput 1
#define kBorderWidth 1 / [UIScreen mainScreen].scale;
#define kCornerRadiusSmall 0
#define kCornerRadiusAds 3
#define kCornerRadiusLarge 13

//User defaults manipulation
#define UDSet(k,o)     [[NSUserDefaults standardUserDefaults] setObject:o forKey:k]
#define UDGet(k)       [[NSUserDefaults standardUserDefaults] objectForKey:k]
#define UDSetBool(k,d) [[NSUserDefaults standardUserDefaults] setBool:d forKey:k]
#define UDGetBool(k)   [[NSUserDefaults standardUserDefaults] boolForKey:k]
#define UDSetInt(k,d)  [[NSUserDefaults standardUserDefaults] setInteger:d forKey:k]
#define UDGetInt(k)    [[NSUserDefaults standardUserDefaults] integerForKey:k]
#define UDSync()       [[NSUserDefaults standardUserDefaults] synchronize]


//Chat

#define messageWidth 260
#define ktextByme       @"textByme"
#define ktextbyother    @"textByOther"
#define kImageByme      @"ImageByme"
#define kImageByOther   @"ImageByOther"

#define kStatusSeding   @"Sending"
#define kStatusSent     @"Sent"
#define kStatusFailed   @"Failed"

//Version 1

// #define AuthKey @"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ0b2tlbiI6ImFUZmxCZGlURXJ0d3ZhVkRHR2ZIaU1tbzRDR3c4Ylo3IiwiYXBpX3ZlcnNpb24iOjF9.9Jw6WRIT8cW9zMnYfLZmQQ1xq9ACr1OgC-Z8Neen3T6f9P4ldC-Vm-ZGRiy22BIAp37yev70KGrH2g4L6DaAEA"

//Version 2
 #define AuthKey @"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJhdXRoX3Rva2VuIjoiQkVjNXRIOVlCUTVLMnBCaXNmZk81MTFMIiwidXNlciI6IiIsInRva2VuIjoiYkZUSEFTc2RzZHNyNTRydHJ5Z2hERkRGZGZ3aThiWjciLCJhcGlfdmVyc2lvbiI6Mn0.dvWxw2OA_vD6a36ds99fDtrbMoGJ8nYh2xBml-t9w3IzXsWoJFz1ChZAbmWHxTIkGfl0gYm6vBQUAWFy6VxV4g"

//
///* Payeezy*/
//
//#define kEnvironment @"CERT"
//#define KApiKey     @"SkzRNAnb1wslPwrGeycNjpA0JebBD7Xc"
//#define KApiSecret  @"03c343f729ff655802bb315ad343ecbaaeb617a24125a5bb1b3b746760696a0d"
//#define KToken      @"fdoa-541a6d7acb15a72a76023de33eb0689b541a6d7acb15a72a"
//#define KURL        @"https://api-cert.payeezy.com/v1/transactions/tokens"
//#define SURL        @"https://api-cert.payeezy.com/v1/securitytokens?"
//#define PURL        @"https://api-cert.payeezy.com/v1/transactions"
//#define merchantId   @"372275578881"



// Version 1
//#define AuthKey @"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJ0b2tlbiI6ImFUZmxCZGlURXJ0d3ZhVkRHR2ZIaU1tbzRDR3c4Ylo3IiwiYXBpX3ZlcnNpb24iOjF9.9Jw6WRIT8cW9zMnYfLZmQQ1xq9ACr1OgC-Z8Neen3T6f9P4ldC-Vm-ZGRiy22BIAp37yev70KGrH2g4L6DaAEA"

//Version 2
//#define AuthKey @"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJhdXRoX3Rva2VuIjoiQkVjNXRIOVlCUTVLMnBCaXNmZk81MTFMIiwidXNlciI6IiIsInRva2VuIjoiYkZUSEFTc2RzZHNyNTRydHJ5Z2hERkRGZGZ3aThiWjciLCJhcGlfdmVyc2lvbiI6Mn0.dvWxw2OA_vD6a36ds99fDtrbMoGJ8nYh2xBml-t9w3IzXsWoJFz1ChZAbmWHxTIkGfl0gYm6vBQUAWFy6VxV4g"


//LIVE
#define kEnvironment @"CERT"
#define KApiKey     @"TJGGjAK4btGCYzlyG69yuebYWWoA6k4d"
#define KApiSecret  @"67d7b0a649c6669462952d55dde54e5927b39d8b38e4bf2f0f618c73ae085496"
#define KURL        @"https://api.payeezy.com/v1/transactions/tokens"
#define SURL        @"https://api.payeezy.com/v1/securitytokens?"
#define PURL        @"https://api.payeezy.com/v1/transactions"
//#undef KToken


//USerDefaults
#define kUserDefaultsUserActivated  @"kUserDefaultsUserActivate"
#define kUserDefaultsLoggedIn  @"kUserDefaultsUserActivate"
#define kUserDefaultsUserProfile @"kUserDefaultsUserProfile"
#define kreachability @"www.google.com"



//Webservices Endpoint
#define kLogin  @"/do-login"
#define kEditMember @"/patient-appoitment/edit-member-information"
#define kCurrentVersion @"/check-version"
#define kCountryList @"/get-country-list"
#define kStatesList @"/get-state-list"
#define kCityList @"/get-city-list"
#define kPatientRegistration @"/do-patient-register"
#define kDoctorRegistration @"/do-doctor-register"
#define kValidateEmail @"/check-email"
#define kSpecialization @"/get-specialization-list"
#define kdoctorAdditionalInfo @"/doctor/save-doctor-additional-info"
#define kdoctorBusinessHours @"/get-business-hours-details"
#define kdoctorSetBusinessHours @"/doctor/set-doctor-business-time"
#define kforgotPassword @"/forgot-password"
#define kgetPatientMemberListing @"/patient-appoitment/get-member-information"
#define kaddPatientMember @"/patient/save-member-information"
#define kgetProfile @"/user/get-user-data"
#define kgetBlogs @"user/get-blogs"
#define kValidateReferal @"/tier-code-validate"
#define kgetReferallDoctor @"/patient-appoitment/get-referal-doctor-list-medicalinfo"


#define keditProfile @"/patient/edit"
#define kgetAllDoctorCategoryList @"/patient-appoitment/get-specialization-list"
#define kgetAllReferralDoctor @"/patient-appoitment/get-referal-doctor-list"
#define kgetAllOnlineDoctor @"/patient-appoitment/get-doctor-list"
#define kPostPatientDetails @"/patient-appoitment/get-patient-token"
#define kPostFeedback @"/patient-appoitment/save-ratings"
#define klogout @"/logout"
#define kupdateToken @"/user/update-token"
#define kCouponcode @"/patient-appoitment/verify-coupan"
#define kGetCouponList @"/patient-appoitment/get-coupanlist-bypatient"
#define kGetMyEarning @"/doctor/doctor-my-earning"
#define kGetBAnkDetail @"/doctor/get-doctor-additional-Info"
#define kGetDoctorReviews @"/patient-appoitment/get-rating-data/"
#define ksendEmail @"/resend"
//Call
#define kgetQuestionAnswerDetails @"doctor/details"
#define kgetslots @"/doctor/get-slots"
#define kgetprescription @"doctor/details/"
#define kgetlab @"doctor/details"
#define kgetleave @"doctor/details/%@/leave"
#define kdoctorTimeSlots @"/doctor/get-time-slots"
#define kupdateStatus @"/patient-appoitment/update-doctor-status"


//Call
#define kgetdoc @"doctor/details"
#define kPostLeaveData @"doctor/save-leave-notes/"
#define kPostCallDetails @"doctor/save-call-deatils"
#define kPostPrescriptionDetails @"doctor/save-prescription-details"
#define kPostLabDetails @"doctor/save-lab-details"
#define kendCall @"/user/end-call"
#define kdoctorEventDates @"/patient-appoitment/get-doctor-events"
#define kDoctorCallToPatient @"/doctor/start-call/"
#define kPostPaymentInfo @"/patient-appoitment/save-payment-information"
#define kPostContactUs @"/user/contact-us"

//(Call status in every 30 seconds id call status is )
//My Patients
#define kgetAllPatientList @"/doctor/get-patient-list"
#define kgetAllPatientVisits @"/doctor/get-visit-list"
#define keditDoctorProfile @"/doctor/edit"
#define kpatientAppointmenttimeslot @"/patient-appoitment/get-time-slots"
#define kgetPatientDoc @"patient-appoitment/details"

#define kpatientBookAppointment @"patient-appoitment/get-patient-token"

//My Profile
#define kgetPatientPaymentInvoice @"/patient-appoitment/get-payment-invoice"
#define kGetPatientEarning @"/patient/get-my-earnings"

//E-Visit
#define kgetEvisit @"/patient-appoitment/get-visit-list"
#define kgetdownload @"user/download/"
#define kgetPatientViewDetail @"patient-appoitment/details"
#define kCancelAppointment @"patient-appoitment/cancel-call"
#define kPostCallsessionInformation @"patient-appoitment/get-call-session-information"
#define kPostInstructions @"/user/add-message"
#define kPostDocuments @"/patient-appoitment/add-documents"
#define kProfileUpdate @"/user/save-profile-pic"
#define kverifyChecksum @"/patient-appoitment/generate-checksum"

//API PAAMETER CONSTANTS
#define kdoctor_id @"doctor_id"
#define kappointment_slot_id @"appointment_slot_id"
#define ktime_slot_id @"time_slot_id"

//Mohit
#define kBadgeCount @"/patient-appoitment/get-unread-count"
#define kDoctorMSG @"/patient-appoitment/details/"
#define kDoctorMSGRead @"/user/mark-message-read/"
#define kGetVideoLinks @"patient-appoitment/details"
#define kAddVideoLinks @"patient-appoitment/add-video-links"
 #define kGetDoctorSideVideoLinks @"/doctor/details/"

#define kvisit_type_id @"visit_type_id"
#define kdate  @"appointment_date"
#define kquestion_1 @"question_1"
#define kquestion_2 @"question_2"
#define kquestion_1_option_value @"question_1_option_value"
#define knew_member_name @"new_member_name"
#define knew_member_gender @"new_member_gender"
#define knew_member_dob @"new_member_dob"
#define kquestion_3 @"question_3"
#define kquestion_4 @"question_4"
#define kquestion_5 @"question_5"
#define kquestion_6 @"question_6"
#define kquestion_7 @"question_7"
#define kpayment_mode_id @"payment_mode_id"
#define kpayment_status @"payment_status"
#define kcorrelation_id @"correlation_id"
#define ktransaction_status @"transaction_status"
#define kvalidation_status @"validation_status"
#define ktransaction_type @"transaction_type"
#define ktransaction_id @"transaction_id"
#define ktransaction_tag @"transaction_tag"
#define kmethod @"method"
#define kamount @"amount"
#define kcurrency @"currency"
#define kbank_resp_code @"bank_resp_code"
#define kbank_message @"bank_message"
#define kgateway_resp_code @"gateway_resp_code"
#define kgateway_message @"gateway_message"


//Search Doctor Ket
#define kName  @"name"
#define kstate  @"state"
#define kcountry  @"country"
#define klanguages  @"languages"
#define kqualification  @"qualification"
#define kgender  @"gender"
#define kexperience @"experience"
#define krating  @"rating"
#define kaverageRating  @"rating_avg"
#define kCallNow @"CALL NOW"
#define kBookNow @"BOOK NOW"

#define  kCallDropped  @"2"
#define  kCallSuccess  @"5"
#define  kCallCancel  @"3"
#define  kCallInterupted  @"4"
#define  kversion @"Current Version 1.0.11"
#define  kNodata @"No data found"

#define MAX_BEFORE_DECIMAL_DIGITS  4
#define MAX_AFTER_DECIMAL_DIGITS  2

// PAYTM Parameter
#define kMID @"MID"
#define kORDERID @"ORDER_ID"
#define kCUST_ID @"CUST_ID"
#define kINDUSTRYTYPEID @"INDUSTRY_TYPE_ID"
#define kCHANNEL_ID @"CHANNEL_ID"
#define kTXN_AMOUNT @"TXN_AMOUNT"
#define kWEBSITE @"WEBSITE"
#define kCALLBACK_URL @"CALLBACK_URL"
#define kCHECKSUMHASH @"CHECKSUMHASH"


//Button Titles
#define kNext @"Next"
#define kSkip @"Skip"
#define kBookNow @"Book Now"


//Explore page links
#define kTermsLink  @"http://www.ionlinedoctor.com/termsandconditionsm"
#define kFaq @"https://www.ionlinedoctor.com/faqm"
#define kWhatWeTreat @"https://www.ionlinedoctor.com/servicesm"
#define kHowItWorks @"http://www.ionlinedoctor.com/howitworksm"


//Banking Parameter
#define kaccounttype @"account_type"
#define kaccountname @"account_name"
#define kaccountholderAddress @"account_holder_address"
#define kaccounttypeDetailid @"account_type_detail_id"
#define kaccounttypedetailvalue @"account_type_detail_value"
#define kbankname @"bank_name"
#define kbankaddress @"bank_address"
#define kbankaccountno @"bank_account_no"
#define klcprice @"lc_price"
#define ksoprice @"so_price"
#define ksignatureflag @"signature_flag"
#define kUnavailableTimeSlot @"This time slot is not available now"
#define kFileDownloaded @"File is successfully downloaded! Click view to view file"
#define kFileNotAvailable @"File is successfully downloaded! Click view to view file"
#define kSaveDocument @"Documents saved successfully"
#define kCouponValidatemessage @"Coupon Value is greater than Consultation Fees. This is a single use coupon.  Do you still wish to continue?"
#define kCouponSuccessful @"Coupon applied successfully"


// Placeholders

#define kLCPricePlaceholderDollar @"Price/Consult - Live Call In USD";
#define kSOPricePlaceholderDollar @"Price/Consult - 2nd Opinion In USD"

#define kLCPricePlaceholderInr @"Price/Consult - Live Call In INR";
#define kSOPricePlaceholderInr @"Price/Consult - 2nd Opinion In INR"

#endif /* Constants_h */
