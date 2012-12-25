//
//  ItemDataController.h
//  MyMoney
//
//  Created by saekil on 12. 12. 25..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;

@interface ItemDataController : NSObject {
    NSMutableArray *items;
	//NSMutableArray *sectionsArray;
	//UILocalizedIndexedCollation *collation;
}
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, retain) UILocalizedIndexedCollation *theCollation;

//- (NSUInteger) countOfSection;
//- (NSUInteger) countOfItemsInSection:(NSUInteger)section;
- (NSUInteger) countOfList;
- (Item*) itemInListAtIndex: (NSUInteger)theIndex;
- (void) addItemWithItem: (Item*) item;
- (void) removeObjectFromListAtIndex: (NSUInteger)theIndex;

@end
