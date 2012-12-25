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

@synthesize	items, sectionsArray, theCollation, sectionNames, sectionSums;


- (void)initializeDefaultDataList
{
    self.items = [[NSMutableArray alloc] init];
    self.sectionNames  = [[NSMutableArray alloc] init];
    self.sectionSums = [[NSMutableArray alloc] init];

    // Sample
    Item* item;
    NSDate* today = [NSDate date];
    NSDecimalNumber* price = [NSDecimalNumber one];
    item = [[Item alloc] initWithName:@"Pegion" price:price date:today];
    
    [self addItemWithItem: item];
}

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

- (Item*) itemInListAtIndex:(NSIndexPath *)theIndexPath{
    NSLog(@"selected section = %d, row = %d", theIndexPath.section, theIndexPath.row);
    NSMutableArray *sectionItems = [sectionsArray objectAtIndex:theIndexPath.section];
    
    return [sectionItems objectAtIndex:theIndexPath.row];
}

- (void) addItemWithItem:(Item *)item{
    [self.items addObject:item];
    [self configureSections];
 }

- (void) removeObjectFromListAtIndex: (NSUInteger)theIndex
{
    [self.items removeObjectAtIndex:theIndex];
}

- (void)setItems:(NSMutableArray *)newDataArray {
	if (newDataArray != items) {
		items = [newDataArray mutableCopy];
	}
	if (items == nil) {
		self.sectionsArray = nil;
	}
}


- (void)configureSections {
	static NSDateFormatter *formatter;
    if (formatter == nil)
        formatter = [[NSDateFormatter alloc] init];
    
	// Get the current collation and keep a reference to it.
	self.theCollation = [UILocalizedIndexedCollation currentCollation];
	
	NSInteger index;
    [formatter setDateFormat:@"yyyy.MM"];
    
    [sectionNames removeAllObjects];
	// Segregate the time zones into the appropriate arrays.
	for (Item *item in items) {
		
		// Ask the collation which section number the time zone belongs in, based on its locale name.
		//NSInteger sectionNumber = [theCollation sectionForObject:item collationStringSelector:@selector(productName)];
        NSString *dateStr = [formatter stringFromDate:item.date];
    
        if (FALSE == [sectionNames containsObject:dateStr]){
            [sectionNames addObject:dateStr];
        }
	}
    
    NSArray *newSectionNames = [sectionNames sortedArrayUsingSelector:@selector(compare:)];
    sectionNames = [newSectionNames mutableCopy];
    //for (NSInteger i = 0; i < [newSectionNames count]; i++)
      //  NSLog(@"sectionNames[%d]=%@", i,[newSectionNames objectAtIndex:i] );

    NSInteger sectionTitlesCount = sectionNames.count;
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    [sectionSums removeAllObjects];
    // Set up the sections array: elements are mutable arrays that will contain the time zones for that section.
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
        NSDecimalNumber *sum = [NSDecimalNumber zero];
        
        [sectionSums addObject:sum];
		[newSectionsArray addObject:array];
	}
    
    NSDecimalNumber *sum = [NSDecimalNumber zero];
    
    for (Item *item in items) {
        NSString *dateStr = [formatter stringFromDate:item.date];
        NSInteger sectionNumber = [sectionNames indexOfObject:dateStr];
        NSLog(@"item %@ %@ %d", item.productName, dateStr, sectionNumber);
        
        // Get the array for the section.
		NSMutableArray *sectionItems = [newSectionsArray objectAtIndex:sectionNumber];
        
        sum = sectionSums[sectionNumber];
        sum = [sum decimalNumberByAdding:item.price];
        sectionSums[sectionNumber] = sum;
        NSLog(@"sectionSums[%d] = %d", sectionNumber, [sum integerValue]);
        
		//  Add the time zone to the section.
		[sectionItems addObject:item];
    }
    
    

	// Now that all the data's in place, each section array needs to be sorted.
	/*for (index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *itemsInSection = [newSectionsArray objectAtIndex:index];
		
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedTimeZonesArrayForSection = [theCollation sortedArrayFromArray:itemsInSection collationStringSelector:@selector(date)];
		
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedTimeZonesArrayForSection];
	}*/
	
	self.sectionsArray = newSectionsArray;
}


@end
