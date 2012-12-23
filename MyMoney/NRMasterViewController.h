//
//  NRMasterViewController.h
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NRDetailViewController;
@class BirdSightDataController;

@interface NRMasterViewController : UITableViewController

@property (strong, nonatomic) NRDetailViewController *detailViewController;
@property (strong, nonatomic) BirdSightDataController *dataController;

@end
