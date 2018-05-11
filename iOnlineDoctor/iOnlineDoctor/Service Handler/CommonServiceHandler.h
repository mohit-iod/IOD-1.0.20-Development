//
//  CommonServiceHandler.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/3/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BaseServiceHandler.h"

typedef void (^callBackBlock)(NSDictionary *responseCode, NSError *error);

typedef void (^callBlock)(id *responseCode, NSError *error);

typedef void (^LoadCountryFinished)(NSArray *array);

typedef void (^LoadSpecializationFinished)(NSArray *array);

typedef void (^LoadDataFinished)(NSArray *array);

typedef void (^LoadListFinished)(NSArray *array, NSError *error);

typedef void (^userRegistrationBlock)(id response, NSError *error);

typedef void (^LoadStatesFinished)(NSArray *state,NSError *error);

typedef void (^FileDownloadFinished)(NSString *filePath,NSError *errro);

@interface CommonServiceHandler : BaseServiceHandler

- (void) getDataWith:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)block;

- (void) getAllCountriesWithCompletion:(LoadCountryFinished)completionBlock;

- (void) getAllStatesgetDataWith:(NSDictionary *)parameter WithCompletionBlock:(LoadStatesFinished)completionBlock;

- (void) getAllCityDataWith:(NSDictionary *)parameter WithCompletionBlock:(LoadStatesFinished)completionBlock;

- (void) getSpecializationDataWith:(NSDictionary *)parameter WithCompletionBlock:(LoadSpecializationFinished)completionBlock;

-(void) getDoctorBusinessHoursWith:(NSDictionary *)parameter WithCompletionBlock:(LoadDataFinished)completionBlock;

-(void) getBusinessSlotsWith:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;


-(void) setBusinessHoursWith:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;


-(void) getSlots:(NSDictionary *)parameter WithCompletionBlock:(LoadListFinished)completionBlock;


-(void)forgotPassword:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getAllMembersWithCompletionBlock:(callBackBlock)completionBlock;

-(void)getPatientEarningsWithCompletionBlock:(callBackBlock)completionBlock;

-(void)postPatientNewMember:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)editPatientNewMember:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)completionBlock;

- (void)getUserProfile:(callBackBlock)completionBlock;

- (void)getBAnkDetails:(callBackBlock)completionBlock;

-(void)editBAnkDetails:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)editProfile:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock;

-(void)editDoctorProfile:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock;

- (void)logoutWithCompletionBlock:(callBackBlock)completionBlock;

-(void)getAllDoctorCategories:(NSDictionary *)parameter andVisitID:(NSString *)visitId WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getAllReferralDoctor: (NSDictionary *)parameter PostParameter:(NSDictionary *)postParameter WithCompletionBlock:(callBackBlock)completionBlock;


-(void)getAllRefer: (NSDictionary *)parameter PostParameter:(NSDictionary *)postParameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getAllReferralDoctor2: (NSDictionary *)parameter PostParameter:(NSDictionary *)postParameter WithCompletionBlock:(callBackBlock)completionBlock;


-(void)getMedicalInforREferalDoctor: (NSDictionary *)parameter ithCompletionBlock:(callBackBlock)completionBlock;

-(void)getCancelAppointment:(NSDictionary *)parameter  andReason:(NSDictionary *)reason WithCompletionBlock:(callBackBlock)completionBlock;


-(void)getAllOnlineDoctors:(NSDictionary *)parameter PostParameter:(NSDictionary *)postParameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getAllReviews:(NSDictionary *)parameter  WithCompletionBlock:(callBackBlock)completionBlock;


-(void)getAllBlogs:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;


-(void)getAllCouponWithCompletionBlock:(callBackBlock)completionBlock;


-(void)getMyEarningsWithCompletionBlock:(callBackBlock)completionBlock;


-(void)getAllPatienVisit: (NSDictionary *)parameter  WithCompletionBlock:(LoadListFinished)completionBlock;

-(void)PostFeedack:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getQuestionAnswerDetails:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getDocuments:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getPrescription:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getLab:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getLeave:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void) postLeave:(NSDictionary *)parameter WithVisitId:(NSString *) visitId WithCompletionBlock:(callBackBlock)completionBlock;

-(void) postCallDetails:(NSDictionary *)parameter WithVisitId:(NSString *) visitId WithCompletionBlock:(callBackBlock)completionBlock;

-(void) postPrescription:(NSDictionary *)parameter WithVisitId:(NSString *) visitId WithCompletionBlock:(callBackBlock)completionBlock;

-(void) postLabDetails:(NSDictionary *)parameter WithVisitId:(NSString *) visitId WithCompletionBlock:(callBackBlock)completionBlock ;

-(void)postEndCallData:(NSDictionary *)parameter  WithCompletionBlock:(callBackBlock)completionBlock;

-(void)postDoctorBusinessHours:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)postResendEmail: (NSDictionary *)parameter withCompletionBlock:(callBackBlock)completionBlock;

-(void)getAllPatienVisitData: (NSDictionary *)parameter  WithCompletionBlock:(callBackBlock)completionBlock;

-(void)updateToken:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getPatienPaymentInvoice: (NSDictionary *)parameter  WithCompletionBlock:(callBackBlock)completionBlock;

-(void) getAppointmentSlots:(NSDictionary *)parameter WithCompletionBlock:(LoadListFinished)completionBlock;

-(void)getEvisitlist:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)GetDownloadDocuments:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;


-(void)getProfileOfDoctor:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getPrescription:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getDocumentsPatients:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getPatientsViewDetails:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getCancelAppointment:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getCallSessionInformation:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;


-(void)verifyCouponcode: (NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)getAllDoctorEventDates:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;


-(void)callToPatientByDoctor:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

- (void)downloadFilePath:(NSString *) filePath imagePath:(NSString *)imagePath finished:(FileDownloadFinished)completionBlock;

-(void)postInstructionForSecondOpinion:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)postPaymentInfo:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;


-(void)postFeedBackinContactUs:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)verifyChecksum:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;

-(void)editProfilePicture:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock;


-(void)updateStatus:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock;


//Mohit

- (void) getBadgeCounts:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)block;

-(void) getDoctorsMessage:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block;

-(void) doctorMessageRead:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block;

-(void) getVideoLinkList:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block;

-(void) addVideoLink:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block;

-(void) getVideoLinkListDRSide:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block;


@end
