//
//  NRBirdSight.m
//  MyMoney
//
//  Created by saekil on 12. 12. 23..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import "NRBirdSight.h"

/*
SMS Text Sample
씨티카드(2*7*)         cardKind    : 씨티카드*, 하나SK*, 삼성카드*, 롯데
강귀남님               //userName    : *님
12/23                buyDate: 99/99
17:56                buyTime: 99:99
일시불                 <ignore_keyword>
50,150원              price: *원
누계                  <ignore_keyword>
2,633,051원           //totalPrice: *원  -> price와 어떻게 구분할 것인가? ... 저장하지 않고, 작은 값만 유효하게...
미스터피자상갈보라점       productName: 유일한 ELSE
*/

@implementation NRBirdSight

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
@end
