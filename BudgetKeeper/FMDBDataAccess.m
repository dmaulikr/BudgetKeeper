//
//  FMDBDataAccess.m
//  BudgetKeeper
//
//  Created by Chanel Chang on 7/30/16.
//  Copyright (c) 2016 Chanel Chang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBDataAccess.h"
#import "AppDelegate.h"

@implementation FMDBDataAccess


-(NSMutableArray *) getExpenses
{
    NSMutableArray *expenses = [[NSMutableArray alloc] init];
    
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM expenses ORDER BY id DESC"];
    
    while([results next])
    {
        ExpenseItem *expense = [[ExpenseItem alloc] init];
        
        expense.expensePrice = [[NSDecimalNumber alloc] initWithDouble:([results intForColumn:@"expense"] / 100.0)];
        expense.dateAdded = [results stringForColumn:@"date"];
        
        [expenses addObject:expense];
        
    }
    
    [db close];
    
    return expenses;
    
}

// currently this saves the most recent entry at the end of the table
// which is the opposite of what i want
-(BOOL) insertExpense:(ExpenseItem *) expense
{
    // insert customer into database
        
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    
    NSInteger expenseAsInt = expense.expensePrice.floatValue * 100;

    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO expenses (expense,date) VALUES (?,?);", @(expenseAsInt),expense.dateAdded, nil];
        
    [db close];
        
    return success;
        
    
}

-(BOOL) deleteExpenses
{
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    
    [db open];
    
    BOOL success = [db executeUpdate:@"DELETE FROM expenses"];
    
    [db close];
    
    return success;
    
}

-(NSDecimalNumber *) getOriginalBudget
{
    int originalBudgetAsInt = 0;
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM originalbudget"];
    
    while([results next])
    {
        originalBudgetAsInt = [results intForColumn:@"originalbudget"];
    }
    
    [db close];
    
    NSDecimalNumber *originalBudget = [[NSDecimalNumber alloc] initWithFloat:(originalBudgetAsInt / 100.0)];

    return originalBudget;
}

-(NSDecimalNumber *) getCurrentBudget
{
    int currentBudgetAsInt = 0;
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM currentbudget"];
    
    while([results next])
    {
        currentBudgetAsInt = [results intForColumn:@"currentbudget"];
    }
    
    [db close];
    
    NSDecimalNumber *currentBudget = [[NSDecimalNumber alloc] initWithFloat:(currentBudgetAsInt / 100.0)];
    
    return currentBudget;
}

-(BOOL) editBudget:(NSDecimalNumber *)newBudget
{
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    
    NSInteger newBudgetAsInt = newBudget.floatValue * 100;
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE originalBudget SET originalbudget = '%@'",@(newBudgetAsInt)]];
    
    [db close];
    
    return success;
}

-(BOOL) updateBudget:(NSDecimalNumber *)updatedBudget
{
    NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
    
    NSInteger updatedBudgetAsInt = updatedBudget.floatValue * 100;
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE currentBudget SET currentbudget = '%@'",@(updatedBudgetAsInt)]];
    
    [db close];
    
    return success;
}

@end
