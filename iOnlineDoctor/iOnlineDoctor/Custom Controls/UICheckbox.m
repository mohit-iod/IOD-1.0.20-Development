//
//  UICheckbox.m
//  iOnlineDoctor
//
//  Created by Purva Bhureja on 8/22/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "UICheckbox.h"

@interface UICheckbox (){
    BOOL loaded;
}

@property(nonatomic, strong)UILabel *textLabel;

@end



@implementation UICheckbox
@synthesize checked = _checked;
@synthesize disabled = _disabled;
@synthesize text = _text;
@synthesize textLabel = _textLabel;

-(void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
}

-(void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", (self.checked) ? @"Icn-Check.png" : @"Icn-uncheck.png"]];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    if(self.disabled) {
        self.userInteractionEnabled = FALSE;
        self.alpha = 0.7f;
    } else {
        self.userInteractionEnabled = TRUE;
        self.alpha = 1.0f;
    }
    if(self.text) {
        if(!loaded) {
            _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width + 5, 0, 1024, 30)];
            _textLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_textLabel];

            loaded = TRUE;
        }
        _textLabel.text = self.text;
    }
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self setChecked:!self.checked];
    return TRUE;
}

-(void)setChecked:(BOOL)boolValue {
    _checked = boolValue;
    [self setNeedsDisplay];
}

-(void)setDisabled:(BOOL)boolValue {
    _disabled = boolValue;
    [self setNeedsDisplay];
}

-(void)setText:(NSString *)stringValue {
    _text = stringValue;
    [self setNeedsDisplay];
}

@end
