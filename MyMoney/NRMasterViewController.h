//
//  NRMasterViewController.h
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NRDetailViewController;
@class ItemDataController;

@interface NRMasterViewController : UITableViewController

@property (strong, nonatomic) NRDetailViewController *detailViewController;
@property (strong, nonatomic) ItemDataController *dataController;

- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;

- (NSString*)deleteIgnoreKeyword: (NSString *) text;
- (BOOL)isCardKind: (NSString*) token;
- (BOOL)isUserName: (NSString*) token;
- (BOOL)isDate: (NSString*) token;
- (BOOL)isTime: (NSString*) token;
- (BOOL)getPriceFromToken: (NSDecimalNumber **)price token:(NSString*) token;

@end
