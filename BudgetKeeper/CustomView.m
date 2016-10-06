//
//  CustomView.m
//  BudgetKeeper
//
//  Created by Chanel Chang on 7/16/16.
//  Copyright (c) 2016 Chanel Chang. All rights reserved.
//

#import "CustomView.h"
#import "KeyboardBar.h"

@interface CustomView()

@property (strong, nonatomic) UITextView *textView;

@end
@implementation CustomView

// Override canBecomeFirstResponder
// to allow this view to be a responder
- (bool) canBecomeFirstResponder {
    return true;
}

@end