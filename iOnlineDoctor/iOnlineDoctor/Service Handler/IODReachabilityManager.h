//
//  IODReachabilityManager.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/28/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IODReachabilityManager : NSObject

/*
 * Initiate monitoring.
 */
+(void) initialize;
/*
 * Gets a value indicating whether or not the service is reachable.
 */
+(bool) imoReachable;



@end
