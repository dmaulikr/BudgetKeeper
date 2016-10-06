//
//  KeyboardBar.m
//  BudgetKeeper
//
//  Created by Chanel Chang on 7/16/16.
//  Copyright (c) 2016 Chanel Chang. All rights reserved.
//

#import "KeyboardBar.h"

@interface KeyboardBar()

@end

@implementation KeyboardBar

- (id)init {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(screen), 40);
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    
        CGRect textFieldRect = CGRectMake(CGRectGetWidth(frame)/6, 0, CGRectGetWidth(frame)*2/3, CGRectGetHeight(frame));
        CGRect menuBtnRect = CGRectMake(0, 0, CGRectGetWidth(frame)/6, CGRectGetHeight(frame));
        CGRect saveBtnRect = CGRectMake(CGRectGetWidth(frame)*5/6, 0, CGRectGetWidth(frame)/6, CGRectGetHeight(frame));
        self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.menuButton setFrame:CGRectInset(menuBtnRect, 8, 5)];
        [self.menuButton setTitle:@"Menu" forState:UIControlStateNormal];
        [self.menuButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:self.menuButton];
        
        self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.saveButton setFrame:CGRectInset(saveBtnRect, 8, 5)];
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.saveButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:self.saveButton];
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectInset(textFieldRect, 0, 5)];
        self.textField.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        [self.textField setPlaceholder:@"Enter amount"];
        [self.textField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.textField setKeyboardType:UIKeyboardTypeDecimalPad];
        [self addSubview:self.textField];
    }
    return self;
}

@end