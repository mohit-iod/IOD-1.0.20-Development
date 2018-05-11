//
//  PatientVisitServiceHandler.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 10/2/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "BaseServiceHandler.h"

@interface PatientVisitServiceHandler : BaseServiceHandler


+ (id)sharedManager;

@property (nonatomic, retain) NSString  *patient_id;
@property (nonatomic, retain) NSString  *patient_name;
@property (nonatomic, retain) NSString  *member_id;

@property (nonatomic,retain) NSMutableArray *evisit;
@property (nonatomic,retain) NSMutableArray *secondOpinion;
@end
