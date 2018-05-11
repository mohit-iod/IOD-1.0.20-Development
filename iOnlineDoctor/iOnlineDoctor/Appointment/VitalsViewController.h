//
//  VitalsViewController.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 3/3/18.
//  Copyright © 2018 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VitalsViewController : UIViewController

/*! @discussion This property is used to enter body temperature.!*/
@property (weak, nonatomic) IBOutlet UITextField *txtbodyTemparature;

/*! @discussion This property is used to enter blood pressure.!*/
@property (weak, nonatomic) IBOutlet UITextField *txtBloodPressure;

/*! @discussion This property is used to enter blood pressure.!*/
@property (weak, nonatomic) IBOutlet UITextField *txtBloodPressure2;

/*! @discussion This property is used to enter pulse rate.!*/
@property (weak, nonatomic) IBOutlet UITextField *txtPulseRate;

/*! @discussion This property is used to enter respiratory rate.!*/
@property (weak, nonatomic) IBOutlet UITextField *txtRespiratoryRate;

/*! @discussion This property is used to enter blodd pressure.!*/
@property (weak, nonatomic) IBOutlet UITextField *txtBloodGlucose;

/*! @discussion This property is used to enter vitals.!*/
@property (weak, nonatomic) IBOutlet UIView *vitalsView;


@end
