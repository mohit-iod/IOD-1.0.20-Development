//
//  BookAppointmentVC.h
//  iOnlineDoctor
//
//  Created by Deepak Patel on 10/4/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"
#import "BookSecondOpinionVC.h"
@interface BookAppointmentVC : ViewController<CustomDelegate>
@property(nonatomic, weak) IBOutlet UIView *calendarContainer;
@property(nonatomic, weak) IBOutlet UICollectionView *businessHourSlots;
@property (nonatomic, strong) NSString* fdTokenValue;
@end
