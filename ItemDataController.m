//
//  ItemDataController.m
//  MyMoney
//
//  Created by saekil on 12. 12. 25..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import "ItemDataController.h"
#import "Item.h"

@interface ItemDataController ()

- (void)configureSections;
- (void)initializeDefaultDataList;
@end

@implementation ItemDataController

@synthesize	items, sectionsArray, theCollation;

/*
 - (NSUInteger) countOfSection
 {
 return [[self.theCollation sectionTitles] count];
 }
- (void)initializeDefaultDataList {
    NSMutableArray* sightList = [[NSMutableArray alloc] init];
    self.masterItemList = sightList;
    Item* item;
    NSDate* today = [NSDate date];
    NSDecimalNumber* price = [NSDecimalNumber one];
    item = [[Item alloc] initWithName:@"Pegion" price:price date:today];
    
    [self addItemWithItem: item];
}*/

- (void)initializeDefaultDataList
{
    self.items = [[NSMutableArray alloc] init];
    self.theCollation = [UILocalizedIndexedCollation currentCollation];
    
    self.items = [NSMutableArray arrayWithCapacity:1];
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"Items" ofType:@"plist"];
    NSArray *tempArray;
    NSMutableArray *statesTemp;
    
    if (thePath && (tempArray = [NSArray arrayWithContentsOfFile:thePath]) ) {
        statesTemp = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *stateDict in tempArray) {
            Item *aState = [[Item alloc] init];
            aState.productName = [stateDict objectForKey:@"ProductName"];
            aState.price = [stateDict objectForKey:@"Price"];
            aState.date = [stateDict objectForKey:@"Date"];
            [statesTemp addObject:aState];
        }
    } else  {
        return;
    }
    
    // after
    // (1)
    for (Item *theState in statesTemp) {
        NSInteger sect = [self.theCollation sectionForObject:theState collationStringSelector:@selector(productName)];
        theState.sectionNumber = sect;
    }
    // (2) The data source source then creates a (temporary) outer mutable array and mutable arrays for each section; it adds each created section array to the outer array.
    NSInteger highSection = [[self.theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    // (3)t then enumerates the array of model objects and adds each object to its assigned section array.
    for (Item *theState in statesTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:theState.sectionNumber] addObject:theState];
    }
    // (4)
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [self.theCollation sortedArrayFromArray:sectionArray
                                            collationStringSelector:@selector(producName)];
        [self.items addObject:sortedSection];
    }

}
/*- (void)setMasterItemList:(NSMutableArray *)newList {
    if (_items != newList) {
        _items = [newList mutableCopy];
    }
}*/

- (id)init{
    if (self = [super init]){
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}
- (NSUInteger) countOfList {
    return [self.items count];
}

- (Item*) itemInListAtIndex:(NSUInteger)theIndex{
    return [self.items objectAtIndex:theIndex];
}

- (void) addItemWithItem:(Item *)item{
    [self.items addObject:item];
    [self configureSections];
    /*NSInteger sect = [self.theCollation sectionForObject:birdSight collationStringSelector:@selector(productName)];

    NSMutableArray *sectionArray = [self.items objectAtIndex:sect];
    
    [self.items ob
    if (sectionArray == nil){
        sectionArray = [NSMutableArray arrayWithCapacity:1];
    }
    [sectionArray addObject:birdSight];
    [self.items addObject:sectionArray];*/

     
     //NSArray *sortedSection = [self.theCollation sortedArrayFromArray:sectionArray
     //                                         collationStringSelector:@selector(producName)];
     //[self.items addObject:sortedSection];

}

- (void) removeObjectFromListAtIndex: (NSUInteger)theIndex
{
    [self.items removeObjectAtIndex:theIndex];
}

- (void)setItems:(NSMutableArray *)newDataArray {
	if (newDataArray != items) {
		items = newDataArray;
	}
	if (items == nil) {
		self.sectionsArray = nil;
	}
	else {
        Item* item;
        NSDate* today = [NSDate date];
        NSDecimalNumber* price = [NSDecimalNumber one];
        item = [[Item alloc] initWithName:@"Pegion" price:price date:today];
        
        [self addItemWithItem: item];

		//[self configureSections];
	}
}


- (void)configureSections {
	
	// Get the current collation and keep a reference to it.
	self.theCollation = [UILocalizedIndexedCollation currentCollation];
	
	NSInteger index, sectionTitlesCount = [[theCollation sectionTitles] count];
	
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
	
	// Set up the sections array: elements are mutable arrays that will contain the time zones for that section.
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
	}
	
	// Segregate the time zones into the appropriate arrays.
	for (Item *item in items) {
		
		// Ask the collation which section number the time zone belongs in, based on its locale name.
		NSInteger sectionNumber = [theCollation sectionForObject:item collationStringSelector:@selector(productName)];
		
		// Get the array for the section.
		NSMutableArray *sectionItems = [newSectionsArray objectAtIndex:sectionNumber];
		
		//  Add the time zone to the section.
		[sectionItems addObject:item];
	}
	
	// Now that all the data's in place, each section array needs to be sorted.
	for (index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *itemsInSection = [newSectionsArray objectAtIndex:index];
		
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedTimeZonesArrayForSection = [theCollation sortedArrayFromArray:itemsInSection collationStringSelector:@selector(productName)];
		
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedTimeZonesArrayForSection];
	}
	
	self.sectionsArray = newSectionsArray;
}


@end
