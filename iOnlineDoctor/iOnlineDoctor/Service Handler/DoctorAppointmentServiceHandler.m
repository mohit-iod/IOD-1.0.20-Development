//
//  DoctorAppointmentServiceHandler.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/23/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "DoctorAppointmentServiceHandler.h"

@implementation DoctorAppointmentServiceHandler

+ (id)sharedManager {
    static DoctorAppointmentServiceHandler *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    
    if (self = [super init]) {
        self.appoitment_date = @"";
        self.call_duration = @"";
        self.from = @"" ;
        self.patient_address = @"" ;
        self.patient_dob = @"";
        self.patient_gender = @"";
        self.patient_name = @"";
        self.profile_pic= @"";
        self.session_token= @"";
        self.type= @"";
        self.visit_id= @"";
        self.visit_type= @"";
        self.session_id = @"";
        self.isFromVideo = 0;
        self.isCallInterrupted = @"";
        self.status = @"";
        self.dateAppnt = @"";
        self.doctorName = @"";
        self.doctorGender = @"";
        self.doctorSpecialization = @"";
        self.doctorProfile = @"";
        self.callInterruptionMessage = @"";
        self.callEnd = @"";
        self.doctorSpecialization = @"";
        self.dob = @"";
        self.diagnosis = @"";
        self.isFilled = @"";
        self.InterruptionTime = 0;
        self.treatment = @"";
        self.isEVisit = @"";
        self.selctedDoctorId = @"";
        self.isAlreadyOnCall = 0;
        //xcc
  }
    return self;
}

@end
