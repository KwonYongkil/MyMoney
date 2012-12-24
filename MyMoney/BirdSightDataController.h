//
//  BirdSightDataController.h
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NRBirdSight;

@interface BirdSightDataController : NSObject
@property(nonatomic, retain) NSMutableArray* masterBirdSightList;

- (NSUInteger) countOfList;
- (NRBirdSight*) itemInListAtIndex: (NSUInteger)theIndex;
- (void) addBirdSightWithBirdSight: (NRBirdSight*) birdSight;

@end
