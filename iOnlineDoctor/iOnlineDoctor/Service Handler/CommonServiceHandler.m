//
//  CommonServiceHandler.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 9/3/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "CommonServiceHandler.h"
#import "AppSettings.h"
#import "AFDownloadRequestOperation.h"
@implementation CommonServiceHandler


#pragma mark GET REQUEST

//Check API version
- (void) getDataWith:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppSettings cmsUrl],kCurrentVersion];
    
    [self getDataWithUrl:url requestType:get requestParameters:parameter requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        if (response) {
            NSDictionary *data = [self handleResponseData:response];
             block(data,nil);
        }
        else {
        }
    } failure:^(NSError *error, BaseServiceHandler *context) {
        block(nil,error);
    }];
}

- (NSDictionary *)handleResponseData:(NSDictionary *)responseData
{
    return [responseData valueForKey:@"data"];
}


//Get all country List
- (void) getAllCountriesWithCompletion:(LoadCountryFinished)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kCountryList];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:@"json"
                 success:^(id response, BaseServiceHandler *context) {
                    
                    response =  [response valueForKey:@"data"];
                    response = [self storeResposneData:response WithFileName:@"countries.json"];
                     if (response)
                         completionBlock(response);
                     else
                         completionBlock (nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     NSArray *storeResponse = [self storeResposneData:nil WithFileName:@"countries.json"];
                     if (storeResponse)
                         completionBlock(storeResponse);
                     else
                         completionBlock(nil);
    }];
}

//get all state list based on country
- (void) getAllStatesgetDataWith:(NSDictionary *)parameter WithCompletionBlock:(LoadStatesFinished)completionBlock{
    NSString *stateid = [parameter valueForKey:@"country_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", [AppSettings cmsUrl],kStatesList,stateid];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:nil
                 success:^(id response, BaseServiceHandler *context) {
                     response =  [response valueForKey:@"data"];
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (nil,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                   
                         completionBlock(nil,error);
                 }];
}


//get all city list
- (void) getAllCityDataWith:(NSDictionary *)parameter WithCompletionBlock:(LoadStatesFinished)completionBlock{
    NSString *cityid = [parameter valueForKey:@"state_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", [AppSettings cmsUrl],kCityList,cityid];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:nil
                 success:^(id response, BaseServiceHandler *context) {
                     response =  [response valueForKey:@"data"];
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (nil,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     
                     completionBlock(nil,error);
    }];
}




//get specialization list
- (void) getSpecializationDataWith:(NSDictionary *)parameter WithCompletionBlock:(LoadSpecializationFinished)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kSpecialization];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:@"json"
                 success:^(id response, BaseServiceHandler *context) {
                     
                     response =  [response valueForKey:@"data"];
                     response = [self storeResposneData:response WithFileName:@"specialization.json"];
                     if (response)
                         completionBlock(response);
                     else
                         completionBlock (nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     NSArray *storeResponse = [self storeResposneData:nil WithFileName:@"specialization.json"];
                     if (storeResponse)
                         completionBlock(storeResponse);
                     else
                         completionBlock(nil);
                 }];
}

- (void)logoutWithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],klogout];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:nil
                 success:^(id response, BaseServiceHandler *context) {
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (nil,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     
                     completionBlock(nil,error);
                 }];
}

//Get business hours of doctor
- (void) getDoctorBusinessHoursWith:(NSDictionary *)parameter WithCompletionBlock:(LoadDataFinished)completionBlock{
    NSString *selecteddate = [parameter valueForKey:@"date"];
    NSString *url = [NSString stringWithFormat:@"%@%@?date=%@", [AppSettings cmsUrl],kdoctorTimeSlots,selecteddate];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:nil
                 success:^(id response, BaseServiceHandler *context) {
                     response =  [response valueForKey:@"data"];
                     response = [self storeResposneData:response WithFileName:@"businessHours.json"];
                     if (response)
                         completionBlock(response);
                     else
                         completionBlock (nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     NSArray *storeResponse = [self storeResposneData:nil WithFileName:@"businessHours.json"];
                     if (storeResponse)
                         completionBlock(storeResponse);
                     else
                         completionBlock(nil);
                 }];
}

//get all patient visit lists.
-(void)getAllPatienVisit: (NSDictionary *)parameter  WithCompletionBlock:(LoadListFinished)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kgetAllPatientList];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:parameter requestHeaders:nil withDataType:nil
                 success:^(id response, BaseServiceHandler *context) {
                     response =  [response valueForKey:@"data"];
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (response,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                         completionBlock(nil,error);
                 }];
}


-(void) getSlots:(NSDictionary *)parameter WithCompletionBlock:(LoadListFinished)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kgetslots];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:parameter requestHeaders:nil withDataType:nil
                 success:^(id response, BaseServiceHandler *context) {

                     response =  [response valueForKey:@"data"];
                     response = [self storeResposneData:response WithFileName:@"businessSlots.json"];
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (response,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     NSArray *storeResponse = [self storeResposneData:nil WithFileName:@"businessSlots.json"];
                     if (storeResponse)
                         completionBlock(storeResponse,nil);
                     else
                         completionBlock(nil,error);
                 }];
}

-(void) getAppointmentSlots:(NSDictionary *)parameter WithCompletionBlock:(LoadListFinished)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kpatientAppointmenttimeslot];
    [self getDataWithUrl:url
             requestType:post
       requestParameters:parameter requestHeaders:nil withDataType:@"json"
                 success:^(id response, BaseServiceHandler *context) {
                     response =  [response objectForKey:@"data"];
                     response = [self storeResposneData:response WithFileName:@"businessSlots.json"];
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (response,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     NSArray *storeResponse = [self storeResposneData:nil WithFileName:@"businessSlots.json"];
                     if (storeResponse)
                         completionBlock(storeResponse,nil);
                     else
                         completionBlock(nil,error);
                 }];
}


#pragma mark Store Respnse in Json file
- (NSMutableDictionary *)storeResposneData:(NSMutableArray*) responseData WithFileName:(NSString *)fileName
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savedModules = [docDir stringByAppendingPathComponent:fileName];
    
    if (responseData == nil) {
        // Off line mode. Use cache data
        if ([[NSFileManager defaultManager] fileExistsAtPath:savedModules] == true) {
            responseData = [[NSMutableArray alloc] initWithContentsOfFile:savedModules];
        }
    } else {
        NSMutableArray *modules = (NSMutableArray *)responseData;
        NSDictionary *dictData = [[NSDictionary alloc] initWithObjectsAndKeys:responseData,@"data", nil];
        // Cache this data.
      //  [dictData writeToFile:savedModules atomically:YES];
    
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictData options:0 error:nil];
        NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [myString writeToFile:savedModules atomically:YES];
    }
    return [responseData copy];
}

//set doctor business hours
-(void) setBusinessHoursWith:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock {
}


//Forgot Password : Parameter : email
-(void)forgotPassword:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kforgotPassword];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//GEt all members of patients
-(void)getAllMembersWithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppSettings cmsUrl],kgetPatientMemberListing];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:@"json"
                 success:^(id response, BaseServiceHandler *context) {
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (nil,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     
                     completionBlock(nil,error);
                 }];
}

-(void)getAllCouponWithCompletionBlock:(callBackBlock)completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppSettings cmsUrl],kGetCouponList];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:@"json"
                 success:^(id response, BaseServiceHandler *context) {
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (nil,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     
                     completionBlock(nil,error);
                 }];
}


-(void)getPatientEarningsWithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppSettings cmsUrl],kGetPatientEarning];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:@"json"
                 success:^(id response, BaseServiceHandler *context) {
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (nil,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     completionBlock(nil,error);
                 }];
}

-(void)getMyEarningsWithCompletionBlock:(callBackBlock)completionBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppSettings cmsUrl],kGetMyEarning];
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:@"json"
                 success:^(id response, BaseServiceHandler *context) {
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (nil,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     
                     completionBlock(nil,error);
                 }];
}


//get user profile
- (void)getUserProfile:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kgetProfile];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

- (void)getBAnkDetails:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kGetBAnkDetail];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//get all categories of spcialization.
-(void)getAllDoctorCategories:(NSDictionary *)parameter andVisitID:(NSString *)visitId WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *category = [parameter valueForKey:@"categoryId"];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", [AppSettings cmsUrl],kgetAllDoctorCategoryList,visitId];
   
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


-(void)getMedicalInforREferalDoctor: (NSDictionary *)parameter ithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kgetReferallDoctor];
    
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//get list of referal doctor
-(void)getAllReferralDoctor: (NSDictionary *)parameter PostParameter:(NSDictionary *)postParameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *categorytype = [parameter valueForKey:@"categoryname"];
    NSString *category = [parameter valueForKey:@"categoryId"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@", [AppSettings cmsUrl],kgetAllReferralDoctor,category,categorytype];
    [self getDataWithUrl:url requestType:post requestParameters:postParameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

-(void)getAllReviews:(NSDictionary *)parameter  WithCompletionBlock:(callBackBlock)completionBlock
{
    NSString *doctorId = [parameter valueForKey:@"doctorid"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",[AppSettings cmsUrl],kGetDoctorReviews,doctorId];
    
    [self getDataWithUrl:url
             requestType:get
       requestParameters:nil requestHeaders:nil withDataType:@"json"
                 success:^(id response, BaseServiceHandler *context) {
                     if (response)
                         completionBlock(response,nil);
                     else
                         completionBlock (nil,nil);
                 } failure:^(NSError *error, BaseServiceHandler *context) {
                     
                     completionBlock(nil,error);
                 }];
}

-(void)getAllReferralDoctor2: (NSDictionary *)parameter PostParameter:(NSDictionary *)postParameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *categorytype = [parameter valueForKey:@"categoryname"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kgetAllReferralDoctor];
    
    [self getDataWithUrl:url requestType:post requestParameters:postParameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


-(void)getAllRefer: (NSDictionary *)parameter PostParameter:(NSDictionary *)postParameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *categorytype = [parameter valueForKey:@"categoryname"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kgetAllReferralDoctor];
    
    [self getDataWithUrl:url requestType:post requestParameters:postParameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//get list of all online doctors
-(void)getAllOnlineDoctors:(NSDictionary *)parameter PostParameter:(NSDictionary *)postParameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *category = [parameter valueForKey:@"categoryId"];
      NSString *categorytype = [parameter valueForKey:@"categoryname"];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/%@", [AppSettings cmsUrl],kgetAllOnlineDoctor,category,categorytype];
    
    [self getDataWithUrl:url requestType:post requestParameters:postParameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//get all question/answer details
-(void)getQuestionAnswerDetails:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/question-ans", [AppSettings cmsUrl],kgetQuestionAnswerDetails,visitId];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

// get list of documents on doctor's end for visit
-(void)getDocuments:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/documents", [AppSettings cmsUrl],kgetdoc,visitId];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

// get list of documents on patients end for visit
-(void)getDocumentsPatients:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/documents", [AppSettings cmsUrl],kgetPatientDoc,visitId];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//Get patient view details
-(void)getPatientsViewDetails:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/question-ans", [AppSettings cmsUrl],kgetPatientViewDetail,visitId];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];

}

//Cancel appointment
-(void)getCancelAppointment:(NSDictionary *)parameter  andReason:(NSDictionary *)reason WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", [AppSettings cmsUrl],kCancelAppointment,visitId];
    
    [self getDataWithUrl:url requestType:post requestParameters:reason requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
    
}

//Get call session information
-(void)getCallSessionInformation:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"patient_visit_id"];
    NSString *url = [NSString stringWithFormat:@"%@/%@", [AppSettings cmsUrl],kPostCallsessionInformation];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];

}

//Get prescription of specific visit on doctor's end.
-(void)getPrescription:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@%@/prescription", [AppSettings cmsUrl],kgetprescription,visitId];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//Get Lab of specific visit on doctor's end.
-(void)getLab:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/lab", [AppSettings cmsUrl],kgetlab,visitId];    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//Get Leave of specific visit on doctor's end.
-(void)getLeave:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@153/question-ans", [AppSettings cmsUrl],kgetQuestionAnswerDetails];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//Get business slots list.


#pragma mark POST REQUEST

-(void) postLeave:(NSDictionary *)parameter WithVisitId:(NSString *) visitId WithCompletionBlock:(callBackBlock)completionBlock{
    //kPostLeaveData
    NSString *url = [NSString stringWithFormat:@"%@/%@%@", [AppSettings cmsUrl],kPostLeaveData,visitId];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//Post call details from doctor's end
-(void) postCallDetails:(NSDictionary *)parameter WithVisitId:(NSString *) visitId WithCompletionBlock:(callBackBlock)completionBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", [AppSettings cmsUrl],kPostCallDetails];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//post prescription data
-(void) postPrescription:(NSDictionary *)parameter WithVisitId:(NSString *) visitId WithCompletionBlock:(callBackBlock)completionBlock {
NSString *url = [NSString stringWithFormat:@"%@/%@/%@", [AppSettings cmsUrl],kPostPrescriptionDetails,visitId];
[self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
    completionBlock(response,nil);
} failure:^(NSError *error, BaseServiceHandler *context) {
    completionBlock(nil,error);
}];
}


//post lab report data
-(void) postLabDetails:(NSDictionary *)parameter WithVisitId:(NSString *) visitId WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@", [AppSettings cmsUrl],kPostLabDetails,visitId];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


-(void)postEndCallData:(NSDictionary *)parameter  WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kendCall];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//Add new member (Patient)
-(void)postPatientNewMember:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kaddPatientMember];
    //NSLog(@"Parameters %@",parameter);
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

-(void)editPatientNewMember:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kEditMember];
    //NSLog(@"Parameters %@",parameter);
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

// Edit BAnk Details
-(void)editBAnkDetails:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kdoctorAdditionalInfo];
    //NSLog(@"Parameters %@",parameter);
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}
//EditUserProfile
-(void)editProfile:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],keditProfile];
    [self PostDataWithSingleImage:url imageName:image requestType:post requestParameters:parameter andUploadData:imageData requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

-(void)editProfilePicture:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kProfileUpdate];
    [self PostDataWithSingleImage:url imageName:image requestType:post requestParameters:nil andUploadData:imageData requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


// Post feed back for rate us page.
-(void)PostFeedack:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kPostFeedback];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//to set business hours by doctor
-(void)postDoctorBusinessHours:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppSettings cmsUrl],kdoctorSetBusinessHours];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//Patient visit list
-(void)getAllPatienVisitData: (NSDictionary *)parameter  WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kgetAllPatientVisits];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//Update device token  (used this because token is not available at login time always)
-(void)updateToken:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kupdateToken];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

-(void)postResendEmail: (NSDictionary *)parameter withCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],ksendEmail];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//Edit doctor Profile
-(void)editDoctorProfile:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],keditDoctorProfile];
    [self PostDataWithSingleImage:url imageName:image requestType:post requestParameters:parameter andUploadData:imageData requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


// get Paymemnt invoice list
-(void)getPatienPaymentInvoice: (NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kgetPatientPaymentInvoice];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//ist for e visit
-(void)getEvisitlist:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitType= [parameter valueForKey:@"visitType"];
    if([visitType isEqualToString:@"none"]){
        visitType = @"";
    }
    NSString *url = [NSString stringWithFormat:@"%@%@%@", [AppSettings cmsUrl],kgetEvisit,visitType];

    //  NSLog(@"URL %@", url);
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//Download Documents.
-(void)GetDownloadDocuments:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock
{
    NSString *visitId = [parameter valueForKey:@"patient_visit_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@%@", [AppSettings cmsUrl],kgetdownload,visitId];
    
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//Book appointmemt
-(void)bookAppointment:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kpatientBookAppointment];
    //NSLog(@"Parameters %@",parameter);
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];

}

//Verify coupon code
-(void)verifyCouponcode: (NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kCouponcode];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//Getting all doctor dates to know doctor shleduled slots.
-(void)getAllDoctorEventDates:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kdoctorEventDates];
    //NSLog(@"Parameters %@",parameter);
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//Doctor calls to patient (getting all session details).
-(void)callToPatientByDoctor:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visit_id"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", [AppSettings cmsUrl],kDoctorCallToPatient,visitId];
    //NSLog(@"Parameters %@",parameter);
    [self getDataWithUrl:url requestType:get requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//Dowload file code
- (void)downloadFilePath:(NSString *) filePath imagePath:(NSString *)imagePath finished:(FileDownloadFinished)completionBlock
{

    NSString *urlString = [NSString stringWithFormat:@"%@",filePath];
    NSString *encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:encodedUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:imagePath shouldResume:YES];
    [operation.securityPolicy setAllowInvalidCertificates:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      //  NSLog(@"Successfully downloaded file to %@", imagePath);
      //  NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        completionBlock(imagePath, nil);
    } failure:^(AFHTTPRequestOperation* operation, NSError *error) {
       // NSLog(@"Error: %@", error);
        //NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        if ([[NSFileManager defaultManager] isDeletableFileAtPath:imagePath]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&error];
            if (!success) {
               // NSLog(@"Error removing file at path: %@", error.localizedDescription);
            }
        }
        completionBlock(imagePath, error);
    }];
    
    [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
    }];
    [operation start];
}


//Post instruction for second opinion by doctor
-(void)postInstructionForSecondOpinion:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kPostInstructions];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

-(void)postPaymentInfo:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kPostPaymentInfo];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


-(void)postFeedBackinContactUs:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kPostContactUs];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}
//Get prescription of specific visit on doctor's end.
-(void)getAllPrescription:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@%@", [AppSettings cmsUrl],visitId,kgetprescription];
    
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//Get Lab of specific visit on doctor's end.
-(void)getAllLab:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *visitId = [parameter valueForKey:@"visitId"];
    NSString *url = [NSString stringWithFormat:@"%@/%@%@", [AppSettings cmsUrl],kgetQuestionAnswerDetails,visitId];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//Get Blogs.
-(void)getAllBlogs:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@/%@", [AppSettings cmsUrl],kgetBlogs];
    [self getDataWithUrl:url requestType:get requestParameters:nil requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

/*
 [self getDataWithUrl:url
 requestType:get
 requestParameters:nil requestHeaders:nil withDataType:nil
 success:^(id response, BaseServiceHandler *context) {
 //  response =  [response valueForKey:@"data"];
 if (response)
 completionBlock(response,nil);
 else
 completionBlock (response,nil);
 } failure:^(NSError *error, BaseServiceHandler *context) {
 completionBlock(nil,error);
 }];
 
 */

-(void)verifyChecksum:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kverifyChecksum];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

-(void)updateStatus:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)completionBlock{

    NSString *url = [NSString stringWithFormat:@"%@%@",[AppSettings cmsUrl],kupdateStatus];
  //  NSLog(@"URL is:-%@",url);
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}

//Mohit

- (void) getBadgeCounts:(NSDictionary *)parameter WithCompletionBlock:(callBackBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppSettings cmsUrl],kBadgeCount];
  //  NSLog(@"URL is:-%@",url);
    [self getDataWithUrl:url requestType:get requestParameters:parameter requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
        if (response) {
            NSDictionary *data = [self handleResponseData:response];
            block(response,nil);
        }
        else {
        }
    } failure:^(NSError *error, BaseServiceHandler *context) {
        block(nil,error);
    }];
}


-(void) getDoctorsMessage:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block
{
    NSString * visitorID = [parameter objectForKey:@"visitId"];
    NSString * backURL = [NSString stringWithFormat:@"%@/%@",visitorID,@"messages"];
    NSString * url = [NSString stringWithFormat:@"%@%@%@",[AppSettings cmsUrl],kDoctorMSG,backURL];
    //NSLog(@"URL is:-%@",url);
    [self getDataWithUrl:url requestType:get requestParameters:parameter requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler * context){
        if(response){
            NSDictionary * data = [self handleResponseData:response];
            block(response,nil);
        }
    }failure:^(NSError  *error, BaseServiceHandler  *context){
        block(nil,error);
    }];
}

-(void) doctorMessageRead:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block
{
    NSString * visitorID = [parameter objectForKey:@"visitId"];
    NSString * url = [NSString stringWithFormat:@"%@%@%@",[AppSettings cmsUrl],kDoctorMSGRead,visitorID];
    //NSLog(@"URL is:-%@",url);
    [self getDataWithUrl:url requestType:get requestParameters:parameter requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler * context){
        if(response){
            NSDictionary * data = [self handleResponseData:response];
            block(data,nil);
        }
    }failure:^(NSError  *error, BaseServiceHandler  *context){
        block(nil,error);
    }];
}


-(void) getVideoLinkList:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block
{
    NSString * visitorID = [parameter objectForKey:@"visitId"];
    NSString * backURL = [NSString stringWithFormat:@"/%@/%@",visitorID,@"links"];
    NSString * url = [NSString stringWithFormat:@"%@/%@%@",[AppSettings cmsUrl],kGetVideoLinks,backURL];
    //NSLog(@"URL is:-%@",url);
    [self getDataWithUrl:url requestType:get requestParameters:parameter requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler * context){
        if(response){
           // NSDictionary * data = [self handleResponseData:response];
            block(response,nil);
        }
    }failure:^(NSError  *error, BaseServiceHandler  *context){
        block(nil,error);
    }];
}

-(void) addVideoLink:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block
{
    // NSString * visitorID = [parameter objectForKey:@"visitId"];
    NSString * url = [NSString stringWithFormat:@"%@/%@",[AppSettings cmsUrl],kAddVideoLinks];
    //NSLog(@"URL is:-%@",url);
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler * context){
        if(response){
            NSDictionary * data = [self handleResponseData:response];
            block(data,nil);
        }
    }failure:^(NSError  *error, BaseServiceHandler  *context){
        block(nil,error);
    }];
}


-(void) getVideoLinkListDRSide:(NSDictionary*)parameter WithCompletionBlock:(callBackBlock)block
{
    NSString * visitorID = [parameter objectForKey:@"visitId"];
    NSString * backURL = [NSString stringWithFormat:@"%@/%@",visitorID,@"links"];
    NSString * url = [NSString stringWithFormat:@"%@%@%@",[AppSettings cmsUrl],kGetDoctorSideVideoLinks,backURL];
    //NSLog(@"url is:%@",url);
    [self getDataWithUrl:url requestType:get requestParameters:parameter requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler * context){
        if(response){
            //            NSDictionary * data = [self handleResponseData:response];
            //            block(data,nil);
            block(response,nil);
        }
    }failure:^(NSError  *error, BaseServiceHandler  *context){
        block(nil,error);
    }];
}
@end
