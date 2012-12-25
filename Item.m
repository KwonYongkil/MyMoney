//
//  Item.m
//  MyMoney
//
//  Created by saekil on 12. 12. 25..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import "Item.h"


@implementation Item

-(id)initWithName:(NSString *)productName price:(NSDecimalNumber*) price date:(NSDate *)date
{
    self = [super init];
    if (self){
        _productName = productName;
        _price = price;
        _date = date;
        return self;
    }
    return nil;
}

-(id)initWithName:(NSString *)productName price:(NSDecimalNumber*) price dateStr:(NSString *)dateStr timeStr:(NSString *)timeStr
{
    self = [super init];
    if (self){
        _productName = productName;
        _price = price;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd HH:mm"];
        _date = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",dateStr, timeStr]];
        return self;
    }
    return nil;
}

-(id)initWithName:
(NSString *)cardKind
         userName: (NSString *)userName
      productName: (NSString *)productName
            price:(NSDecimalNumber*) price
       sumOfPrice:(NSDecimalNumber*) sumOfPrice
          dateStr:(NSString *)dateStr
          timeStr:(NSString *)timeStr
{
    self = [super init];
    if (self){
        _cardKind = cardKind;
        _userName = userName;
        _productName = productName;
        _price = price;
        _sumOfPrice = sumOfPrice;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *yearStr = [formatter stringFromDate:[NSDate date]];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        _date = [formatter dateFromString:[NSString stringWithFormat:@"%@/%@ %@",yearStr, dateStr, timeStr]];
        NSLog(@"item.date = %@", _date);
        return self;
    }
    return nil;
    
}

@end
