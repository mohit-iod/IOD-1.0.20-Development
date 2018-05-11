//
//  RegistrationService.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/31/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "RegistrationService.h"
#import "AppSettings.h"

@implementation RegistrationService


+ (id)sharedManager {
    static RegistrationService *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {

        self.strFullname=@"";
        self.strDOB=@"";
        self.strEmail=@"";
        self.strPassword=@"";
        self.strGender=@"";
        self.strViewAddress=@"";
        self.strCity=@"";
        self.strState=@"";
        self.strCountry=@"";
        self.strPinCode=@"";
        self.strMobile=@"";
        self.language=@"";
        self.additionalQualification=@"";
        self.RegistrationNumber=@"";
        self.dea=@"";
        self.highestQualification=@"";
        self.highestQualificationYear=@"";
        self.university=@"";
        self.deaNumber=@"";
        self.specialization=@"";
        self.experience=@"";
        self.licence=@"";
        self.imageData = [[NSMutableArray alloc] init];
        self.arrDocType = [[NSMutableArray alloc]init];
        self.nameArray = [[NSMutableArray alloc]init];
       
       //For doctor data
        self.strAcNumber = @"";
        self.strAcName = @"";
        self.strAcHolderNumber = @"";
        self.strIban = 0;
        self.strBankName = @"";
        self.strBankAdress= @"";
        self.strBankAcNumber= @"";
        self.arrSignature = [[NSArray alloc]init];
        
        self.token = @"";
        
    }
    return self;
}

- (void) CheckEmailid:(NSDictionary  *)parameter WithCompletionBlock:(CheckEmailidBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@", [AppSettings cmsUrl]];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:nil success:^(id response, BaseServiceHandler *context) {
    //code
    } failure:^(NSError *error, BaseServiceHandler *context) {
    //code
    }];
}

- (void) doRegistrationWithParameters:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kPatientRegistration];
    
    //NSLog(@"Parameters %@",parameters);
    [self  getDataWithUrl:url requestType:post requestParameters:parameters requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        block(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        block(nil,error);
        
    }];
}

-(void) validateEmail:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kValidateEmail];
    [self getDataWithUrl:url requestType:post requestParameters:parameters requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        block(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        block(nil,error);
    }];
}


-(void) validateReferalCode:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kValidateReferal];
    [self getDataWithUrl:url requestType:post requestParameters:parameters requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        block(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        block(nil,error);
    }];

}

- (void)AdditionalDoctorDetailWithParameters:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kdoctorAdditionalInfo];
    [self getDataWithUrl:url requestType:post requestParameters:parameters requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        block(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        block(nil,error);
    }];
}

- (void) doLoginWithParameters:(NSDictionary *)parameters withCompletionBlock:(userRegistrationBlock)block{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kLogin];
    //NSLog(@"Parameters %@",parameters);
    [self getDataWithUrl:url requestType:post requestParameters:parameters requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        block(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        block(nil,error);
    }];
}


//mit - New doc - change method name in .h .m
// Doctor Registration upload doc
- (void) doDoctorRegistrationWithParameters:(NSDictionary *)parameters andImageName:(NSArray *)image andArraray:(NSArray *)mageArray dataType:(NSMutableArray*)type withCompletionBlock:(userRegistrationBlock)block;
 {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kDoctorRegistration];
//    [self PostDataWithUrl:url requestType:post requestParameters:parameters andUploadData:mageArray requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
//        //NSLog(@"success");
//        block(response,nil);
//    } failure:^(NSError *error, BaseServiceHandler *context) {
//        //NSLog(@"Fail");
//        block(error,nil);
//        
//    }];
     
     [self PostDataWithImagePDF:url imageName:image requestType:post requestParameters:parameters   andUploadData:mageArray andDocType:type requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
         block(response,nil);
         
     } failure:^(NSError *error, BaseServiceHandler *context) {
         block(error, nil);
     }];
}

-(void)bankingDetails:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kdoctorAdditionalInfo];
    [self PostDataWithSingleImage:url imageName:image requestType:post requestParameters:parameter andUploadData:imageData requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


-(void)editBankingDetails:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData WithCompletionBlock:(callBackBlock)completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kdoctorAdditionalInfo];
    [self getDataWithUrl:url requestType:post requestParameters:parameter requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(nil,error);
    }];
}


//Post documents in second opinion

-(void)postSecondOpinionDocuments:(NSDictionary*)parameter andImageName:(NSArray *)image andImages:(NSArray *)imageData dataType:(NSMutableArray*)type WithCompletionBlock:(callBackBlock)completionBlock{
    
    NSLog(@"Type is:%@",type);
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppSettings cmsUrl],kPostDocuments];
    
    //mit - New doc
//    [self PostDataWithImagePDF:url requestType:post requestParameters:parameter andUploadData:image andDocType:type requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
//        //NSLog(@"success");
//        completionBlock(response,nil);
//    } failure:^(NSError *error, BaseServiceHandler *context) {
//        //NSLog(@"Fail");
//        completionBlock(nil,error);
//    }];
    
    [self PostDataWithImagePDF:url imageName:image requestType:post requestParameters:parameter andUploadData:imageData andDocType:type requestHeaders:nil withDataType:@"json" success:^(id response, BaseServiceHandler *context) {
        completionBlock(response,nil);
        
    } failure:^(NSError *error, BaseServiceHandler *context) {
        completionBlock(error, nil);
    }];
}





@end
