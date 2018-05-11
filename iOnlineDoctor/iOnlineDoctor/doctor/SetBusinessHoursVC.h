//
//  SetBusinessHoursVC.h
//  iOnlineDoctor
//  Created by Deepak Patel on 9/9/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "ViewController.h"
#import "StringPickerView.h"
#import "UICheckbox.h"

@interface SetBusinessHoursVC : ViewController
@property(nonatomic, weak) IBOutlet UICollectionView *businessHoursCollectionView;
@property(nonatomic, weak) IBOutlet UITextField *txtSelection;
@property(nonatomic, weak) IBOutlet UICheckbox *checkBox;
@property (nonatomic, strong) StringPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIView *calendarContainer;
@property (nonatomic, weak) IBOutlet UIView *scheduleContainer;


@end
