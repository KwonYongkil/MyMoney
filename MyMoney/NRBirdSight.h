//
//  NRBirdSight.h
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRBirdSight : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) NSDate *date;

-(id)initWithName: (NSString*)name location:(NSString*) location date:(NSDate*) date;
@end
