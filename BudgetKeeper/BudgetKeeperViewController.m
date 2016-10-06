//
//  BudgetKeeperViewController.m
//  BudgetKeeper
//
//  Created by Chanel Chang on 9/12/15.
//  Copyright (c) 2015 Chanel Chang. All rights reserved.
//

#import "BudgetKeeperViewController.h"
#import "ExpenseItem.h"
#import "CustomView.h"
#import "KeyboardBar.h"
#import "FMDBDataAccess.h"

@interface BudgetKeeperViewController ()

@property NSDecimalNumber *originalBudget;
@property (strong, nonatomic) UILabel *remainingBudget;
@property (weak, nonatomic) IBOutlet UITableView *expenseTable;
@property NSMutableArray *expenseItems;
@property (strong, nonatomic) IBOutlet CustomView *customView;
@property (strong, nonatomic) KeyboardBar *keyboardBar;

@end

@implementation BudgetKeeperViewController

-(void) populateBudget
{
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    
    self.monthlyBudget = [db getCurrentBudget];
    self.originalBudget = [db getOriginalBudget];
    
    self.remainingBudget.text = [NSNumberFormatter localizedStringFromNumber:self.monthlyBudget numberStyle:NSNumberFormatterCurrencyStyle];
}

-(void) populateExpenses
{
    self.expenseItems = [[NSMutableArray alloc] init];
    
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    
    self.expenseItems = [db getExpenses];
}

-(void) saveExpense:(ExpenseItem *)expense {
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];

    [db insertExpense:expense];
}

-(void) editBudget:(NSDecimalNumber *)newBudget {
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];

    [db editBudget:newBudget];
    [db updateBudget:newBudget];
}

-(void) updateBudget:(NSDecimalNumber *)updatedBudget {
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];

    [db updateBudget:updatedBudget];
}

-(void) clearExpenseList
{
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];

    [db deleteExpenses];
}

// Dismiss the keyboard on view touches by making
// the view the first responder
- (void)didTouchView {
    [self.customView becomeFirstResponder];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
}

- (IBAction)onSave:(id)sender {
    [self addToExpenseList];

}

- (IBAction)onMenuClick:(id)sender {
    
    
    UIWindow* alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.rootViewController = [UIViewController new];
    alertWindow.windowLevel = 10000001;
    alertWindow.hidden = NO;
    alertWindow.tintColor = [[UIWindow valueForKey:@"keyWindow"] tintColor];

    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Menu"
                                 message:@"Select an option"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* editBudget = [UIAlertAction
                         actionWithTitle:@"Edit Budget"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             UIAlertController * alert=   [UIAlertController
                                                           alertControllerWithTitle:@"Set Budget"
                                                           message:@"Enter monthly budget."
                                                           preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 self.monthlyBudget = [NSDecimalNumber decimalNumberWithString:((UITextField *)[alert.textFields objectAtIndex:0]).text];
                                 self.originalBudget = self.monthlyBudget;
                                 self.remainingBudget.text = [NSNumberFormatter localizedStringFromNumber:self.monthlyBudget numberStyle:NSNumberFormatterCurrencyStyle];
                                 [self editBudget:self.monthlyBudget];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
                             
                             UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
                             
                             [alert addAction:ok];
                             [alert addAction:cancel];
                             [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                 textField.keyboardType = UIKeyboardTypeDecimalPad;
                                 textField.placeholder = @"";
                             }];
                             
                             [self presentViewController:alert animated:YES completion:nil];
                             
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    UIAlertAction* clearList = [UIAlertAction
                                 actionWithTitle:@"Clear List of Expenses"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     self.monthlyBudget = self.originalBudget;
                                     self.remainingBudget.text = [NSNumberFormatter localizedStringFromNumber:self.monthlyBudget numberStyle:NSNumberFormatterCurrencyStyle];
                                     self.keyboardBar.textField.text = @"";
                                     [self.expenseItems removeAllObjects];
                                     [self.expenseTable reloadData];
                                     [self clearExpenseList];
                                     [self updateBudget:self.originalBudget];
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    UIAlertController * editBudgetView =   [UIAlertController
                                            alertControllerWithTitle:@"Edit Budget"
                                            message:@"Enter monthly budget."
                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* onOk = [UIAlertAction
                           actionWithTitle:@"Ok"
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
                               [editBudgetView dismissViewControllerAnimated:YES completion:nil];
                               
                           }];
    [editBudgetView addAction:onOk];
    [view addChildViewController:editBudgetView];
    
    [view addAction:editBudget];
    [view addAction:clearList];
    [view addAction:cancel];
    
    [alertWindow.rootViewController presentViewController:view animated:YES completion:nil];

}


- (void)addToExpenseList {
    
    if (![self.keyboardBar.textField.text isEqualToString:@""])
    {
    ExpenseItem *item = [[ExpenseItem alloc] init];
    item.expensePrice = [NSDecimalNumber decimalNumberWithString:self.keyboardBar.textField.text];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    
    item.dateAdded = [dateFormatter stringFromDate:[NSDate date]];
    
    [self.expenseItems insertObject:item atIndex:0];
        
    self.monthlyBudget = [self.monthlyBudget decimalNumberBySubtracting:item.expensePrice];
    self.remainingBudget.text = [NSNumberFormatter localizedStringFromNumber:self.monthlyBudget numberStyle:NSNumberFormatterCurrencyStyle];
    [self.expenseTable reloadData];
        
    [self saveExpense:item];
    [self updateBudget:self.monthlyBudget];
    
    [self.keyboardBar.textField setText:@""];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.remainingBudget = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(screen), 100)];
    self.remainingBudget.numberOfLines = 1;
    self.remainingBudget.textAlignment = NSTextAlignmentCenter;
    self.remainingBudget.textColor = [UIColor redColor];
    self.remainingBudget.adjustsFontSizeToFitWidth = YES;
    self.remainingBudget.font = [UIFont systemFontOfSize:80];
    [self.view addSubview:self.remainingBudget];
    
    [self populateBudget];
    [self populateExpenses];
    
    self.keyboardBar = [[KeyboardBar alloc] init];
    [self.customView becomeFirstResponder];
    
     //Add a TapGestureRecognizer to dismiss the keyboard when the view is tapped
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTouchView)];
    [self.customView addGestureRecognizer:recognizer];
    [self.customView setInputAccessoryView:self.keyboardBar];
    [self.keyboardBar.menuButton addTarget:self action:@selector(onMenuClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.keyboardBar.saveButton addTarget:self action:@selector(onSave:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.expenseItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ListPrototypeCell"];
    }
    ExpenseItem *expenseItem = [self.expenseItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"$%.2lf", expenseItem.expensePrice.doubleValue];
    cell.detailTextLabel.text = expenseItem.dateAdded;
    
    return cell;
}

@end
