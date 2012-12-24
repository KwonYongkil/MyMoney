//
//  NRBirdSight.m
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import "NRBirdSight.h"

@implementation NRBirdSight
-(id)initWithName:(NSString *)name location:(NSString *)location date:(NSDate *)date
{
    self = [super init];
    if (self){
        _name = name;
        _location = location;
        _date = date;
        return self;
    }
    return nil;
}
@end
