//
//  NRBirdSight.h
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NRBirdSight : NSObject

@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSDecimalNumber* price;
@property (nonatomic, strong) NSDate *date;

-(id)initWithName: (NSString*)productName price:(NSDecimalNumber*) price date:(NSDate*) date;
@end
