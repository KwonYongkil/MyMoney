//
//  NRDetailViewController.h
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NRBirdSight;
@interface NRDetailViewController : UITableViewController

//@property (strong, nonatomic) id detailItem;
//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property(strong, nonatomic) NRBirdSight *sight;
@property(weak, nonatomic) IBOutlet UILabel *birdNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *locationLabel;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
