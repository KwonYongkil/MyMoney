//
//  Item.h
//  MyMoney
//
//  Created by saekil on 12. 12. 25..
//  Copyright (c) 2012년 R&D Center. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface Item : NSObject
@property (nonatomic, copy) NSString *cardKind;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSDecimalNumber* price;
@property (nonatomic, copy) NSDecimalNumber* sumOfPrice;
@property (nonatomic, strong) NSDate *date;
@property NSInteger sectionNumber;

-(id)initWithName: (NSString*)productName price:(NSDecimalNumber*) price date:(NSDate*) date;
-(id)initWithName:(NSString *)productName price:(NSDecimalNumber*) price dateStr:(NSString *)dateStr timeStr:(NSString *)timeStr;

-(id)initWithName:
            (NSString *)cardKind
            userName: (NSString *)userName
            productName: (NSString *)productName
            price:(NSDecimalNumber*) price
            sumOfPrice:(NSDecimalNumber*) sumOfPrice
            dateStr:(NSString *)dateStr
            timeStr:(NSString *)timeStr;

@end
