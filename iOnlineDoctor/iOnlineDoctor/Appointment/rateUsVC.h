//
//  rateUsVC.h
//  iOnlineDoctor
//
//  Created by Meghna Patel on 9/17/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepSlider.h"

@interface rateUsVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgSLmiley;
@property (weak, nonatomic) IBOutlet StepSlider *stepSLider;
@property (weak, nonatomic) IBOutlet UIPageControl *pagerRate;
@property (weak, nonatomic) IBOutlet UITextView *textViewRate;
- (IBAction)sliderValueChange:(id)sender;

@end
