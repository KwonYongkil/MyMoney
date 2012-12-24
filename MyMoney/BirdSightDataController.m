//
//  BirdSightDataController.m
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import "BirdSightDataController.h"
#import "NRBirdSight.h"

@interface BirdSightDataController ()
- (void)initializeDefaultDataList;
@end

@implementation BirdSightDataController

- (void)initializeDefaultDataList {
    NSMutableArray* sightList = [[NSMutableArray alloc] init];
    self.masterBirdSightList = sightList;
    NRBirdSight* birdSight;
    NSDate* today = [NSDate date];
    birdSight = [[NRBirdSight alloc] initWithName:@"Pegion" location:@"Seoul" date:today];
    
    [self addBirdSightWithBirdSight: birdSight];
}

- (void)setMasterBirdSightingList:(NSMutableArray *)newList {
    if (_masterBirdSightList != newList) {
        _masterBirdSightList = [newList mutableCopy];
    }
}
    - (id)init{
        if (self = [super init]){
            [self initializeDefaultDataList];
            return self;
        }
        return nil;
    }
- (NSUInteger) countOfList {
    return [self.masterBirdSightList count];
}

- (NRBirdSight*) itemInListAtIndex:(NSUInteger)theIndex{
    return [self.masterBirdSightList objectAtIndex:theIndex];
}

- (void) addBirdSightWithBirdSight:(NRBirdSight *)birdSight{
    [self.masterBirdSightList addObject:birdSight];
}
@end
