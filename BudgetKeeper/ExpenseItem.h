//
//  ExpenseItem.h
//  BudgetKeeper
//
//  Created by Chanel Chang on 9/19/15.
//  Copyright (c) 2015 Chanel Chang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseItem : NSObject

@property NSDecimalNumber *expensePrice;
@property NSString *expenseGroup;
@property NSString *dateAdded;

@end
