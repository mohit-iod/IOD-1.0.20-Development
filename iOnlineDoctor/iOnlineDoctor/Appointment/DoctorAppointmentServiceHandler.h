//
//  DoctorAppointmentServiceHandler.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/23/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BaseServiceHandler.h"

@interface DoctorAppointmentServiceHandler : BaseServiceHandler

+ (id)sharedManager;

@property (nonatomic, retain) NSString  *appoitment_date;
@property (nonatomic,retain) NSString *call_duration;
@property (nonatomic,retain) NSString *from;
@property (nonatomic,retain) NSString *patient_address;
@property (nonatomic,assign) NSString *patient_dob;
@property (nonatomic,assign) NSString *dob;

@property (nonatomic,retain) NSString *patient_gender;
@property (nonatomic,retain) NSString *patient_id;
@property (nonatomic,retain) NSString *patient_name;
@property (nonatomic,retain) NSString *profile_pic;
@property (nonatomic,retain) NSString *session_token;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString *visit_id;
@property (nonatomic,retain) NSString *visit_type;
@property (nonatomic,retain) NSString *session_id;
@property (nonatomic,assign) int  isFromVideo;
@property (nonatomic, retain) NSString *isCallInterrupted;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *dateAppnt;
@property (nonatomic, retain) NSString *doctorName;
@property (nonatomic, retain) NSString *doctorSpecialization;
@property (nonatomic, retain) NSString *doctorGender;
@property (nonatomic, retain) NSString *doctorProfile;
@property (nonatomic, retain) NSString *callEnd;
@property (nonatomic, retain) NSString *isFilled;
@property (nonatomic, retain) NSString *diagnosis;
@property (nonatomic, retain) NSString *treatment;
@property (nonatomic, retain) NSString *selctedDoctorId;


@end
