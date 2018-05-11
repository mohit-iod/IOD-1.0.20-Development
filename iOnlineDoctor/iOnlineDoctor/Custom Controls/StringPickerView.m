//
//  StringPickerView.m
//  iOnlineDoctor
//
//  Created by Deepak Patel on 8/27/17.
//  Copyright © 2017 iOnlineDoctor. All rights reserved.
//

#import "StringPickerView.h"
#import "UIColor+HexString.h"
#import "Constants.h"

@interface StringPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, readwrite) NSString *value;
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation StringPickerView

- (void)setPreSelectedValue:(NSString *)preSelectedValue{
    _preSelectedValue = preSelectedValue;
    if( self.data && self.data.count > 0 ){
        [self selectPreSelectedValue];
    }
}

- (void)setData:(NSArray *)data{
    _data = data;
    if( self.data && self.data.count > 0 && self.preSelectedValue ){
        [self selectPreSelectedValue];
    }
}

- (void)setSelectedRow:(NSInteger)selectedRow{
    _selectedRow = selectedRow;
    if( self.data && self.data.count >  0){
        self.value = [self.data objectAtIndex:_selectedRow];
    }
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if( self ){
        self.selectedRow = 0;
        self.preSelectedValue = nil;
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    //    self.layer.borderColor = [UIColor colorWithHexString:@"CC003E"].CGColor;
    //    self.layer.borderWidth = 1.0;
    
    CGSize buttonSize = CGSizeMake(SCREEN_WIDTH/2, 44);
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton addTarget:self
                        action:@selector(onDoneButton:)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.doneButton.frame), 0, buttonSize.width, buttonSize.height);
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self
                          action:@selector(onCancelButton:)
                forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelButton.backgroundColor = self.doneButton.backgroundColor = [UIColor colorWithHexString:kDoneButton];
    self.doneButton.titleLabel.textColor = self.cancelButton.titleLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:self.doneButton];
    [self addSubview:self.cancelButton];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 42, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 40)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self addSubview:self.pickerView];
}

- (void)selectPreSelectedValue{
    for( NSString *str in self.data ){
        if ( [self.preSelectedValue isEqualToString:str] ){
            NSInteger index = [self.data indexOfObject:str];
            self.selectedRow = index;
            [self.pickerView selectRow:index inComponent:0 animated:false];
            return;
        }
    }
}

- (void)onDoneButton:(UIButton*)button{
    if( self.data && self.data.count >  0 ){
        self.value = [self.data objectAtIndex:self.selectedRow];
        _selectedId = (int) self.selectedRow ;
    }
    if( self.delegate && [self.delegate respondsToSelector:@selector(stringPickerViewDidSelectDone:)] ){
        [self.delegate stringPickerViewDidSelectDone:self];
    }
}

- (void)onCancelButton:(UIButton*)button{
    if( self.delegate && [self.delegate respondsToSelector:@selector(stringPickerViewDidSelectCancel:)] ){
        [self.delegate stringPickerViewDidSelectCancel:self];
    }
}

#pragma mark - UIPickerViewDelegate/UIPickerViewDataSource

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.data objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedRow = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.data.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

@end
