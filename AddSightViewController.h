//
//  AddSightViewController.h
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Item;

@interface AddSightViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *NameInput;
@property (weak, nonatomic) IBOutlet UITextField *LocationInput;

@property (strong, nonatomic) Item *item;
@end
