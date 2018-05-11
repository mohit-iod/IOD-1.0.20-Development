//
//  PatientVisitServiceHandler.m
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/2/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "PatientVisitServiceHandler.h"

@implementation PatientVisitServiceHandler

+ (id)sharedManager {
    static PatientVisitServiceHandler *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
        self.patient_id = @"";
        self.patient_name = @"";
        self.evisit = [[NSMutableArray alloc]init];
        self.secondOpinion = [[NSMutableArray alloc] init];
    }
    return self;
}


@end
