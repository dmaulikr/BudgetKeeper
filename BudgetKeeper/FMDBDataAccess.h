//
//  FMDBDataAccess.h
//  BudgetKeeper
//
//  Created by Chanel Chang on 7/30/16.
//  Copyright (c) 2016 Chanel Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ExpenseItem.h"

@interface FMDBDataAccess : NSObject
{
    
}

-(NSMutableArray *) getExpenses;
-(BOOL) insertExpense:(ExpenseItem *) expense;
-(BOOL) deleteExpenses;
-(NSDecimalNumber *) getOriginalBudget;
-(NSDecimalNumber *) getCurrentBudget;
-(BOOL) editBudget: (NSDecimalNumber *) newBudget;
-(BOOL) updateBudget:(NSDecimalNumber *) updatedBudget;

@end
