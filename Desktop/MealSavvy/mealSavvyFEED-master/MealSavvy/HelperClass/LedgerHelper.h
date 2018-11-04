//
//  LedgerHelper.h
//  TooLow
//
//  Created by Sang Nguyen on 1/17/17.
//  Copyright © 2017 TOOLOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"
//typedef enum {
//    USD = 0,
//    VND
//} CurrencyUnit;
@protocol LedgerHelperDelegate <NSObject>
-(CGFloat)getBalanceAmount;

@end
@interface LedgerHelper : NSObject<UIPickerViewDelegate,UIPickerViewDataSource>
@property (assign, nonatomic) BOOL isGettingBalance;
@property (assign, nonatomic) CGFloat availableAmount;
@property (assign, nonatomic) CGFloat totalAmount;
@property (assign, nonatomic) CGFloat minimumDepositAmount;
//@property (assign, nonatomic) CurrencyUnit currencyUnit;
@property (strong, nonatomic) Currency* currentCurrency;
@property (strong, nonatomic) NSMutableArray* currencies;
@property (strong, nonatomic) NSMutableArray* toolowCashOutMethods;
@property (weak,nonatomic) id<LedgerHelperDelegate>delegate;
+(LedgerHelper*)shared;
-(void)reset;
-(NSString*)getFormatedCurency:(NSString*) currencyCode;
-(NSString*)getFormatedCurency:(NSString*) currencyCode withRate:(CGFloat)rate;
-(NSString*)getCurencyUnit;
-(NSString*)getCountryFlag;
-(NSString*)getFormatedMoney:(CGFloat)money;
-(NSString*)formatMoney:(CGFloat)money currency:(Currency*)currency;
-(CGFloat)getAvailabelBalance;
-(NSString*)getStringAvailabelBalance;
-(CGFloat)convertToUSD:(CGFloat) value;

@end
