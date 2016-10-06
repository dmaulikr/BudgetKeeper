//
//  CustomView.h
//  BudgetKeeper
//
//  Created by Chanel Chang on 7/16/16.
//  Copyright (c) 2016 Chanel Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView

// Override inputAccessoryView to readWrite
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;

@end
