//
//  BudgetKeeperViewController.h
//  BudgetKeeper
//
//  Created by Chanel Chang on 9/12/15.
//  Copyright (c) 2015 Chanel Chang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BudgetKeeperViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
}

@property NSDecimalNumber *monthlyBudget;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
