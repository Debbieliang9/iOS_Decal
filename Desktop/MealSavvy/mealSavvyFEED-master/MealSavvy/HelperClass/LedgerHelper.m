//
//  LedgerHelper.m
//  TooLow
//
//  Created by Sang Nguyen on 1/17/17.
//  Copyright © 2017 TOOLOW. All rights reserved.
//

#import "LedgerHelper.h"
#import "JSON.h"
#import "DataHelper.h"

#define ROW_HEIGHT 40
#define LABEL_UNIT_WIDTH 40
#define IMAGE_FLAG_WIDTH 34
#define IMAGE_FLAG_HEIGHT 18
#define KEY_BALANCE @"balance"
#define TABLE_COMMON @"CommonTable"
#define TOOLOW_GREEN [UIColor colorWithRed: 0.0/255.0f green:166.0/255.0f blue:82.0/255.0f alpha:1.0]
#define NOTIFICATION_UPDATE_BALANCE @"NOTIFICATION_UPDATE_BALANCE"

static LedgerHelper* instant;
@implementation LedgerHelper
+(LedgerHelper*)shared{
    if (!instant) {
        instant = [[LedgerHelper alloc] init];
        [instant reset];
        NSDictionary* dictData = [[DataHelper shared] getDataByKey:[[DataHelper shared] getKey: KEY_BALANCE] tableName:TABLE_COMMON];
        if (dictData) {
            [instant parseBalance:dictData];
        }
    }
    return instant;
}
-(void)reset{
    self.totalAmount = 0;
    self.availableAmount = 0;
    self.currentCurrency = [[Currency alloc] init];
    self.currentCurrency.code = @"USD";
    self.currentCurrency.rate = 1.0f;
    self.currentCurrency.flagImageName = @"USD-flag";

}

-(NSString*)getFormatedCurency:(NSString*) currencyCode withRate:(CGFloat)rate {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    numberFormatter.currencyCode = currencyCode;
    numberFormatter.generatesDecimalNumbers = false;
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:self.availableAmount * rate]];
    return numberAsString;
}
-(NSString*)getFormatedCurency:(NSString*) currencyCode{

    return  [self getFormatedCurency:currencyCode withRate:self.currentCurrency.rate];
}
-(NSString*)getFormatedMoney:(CGFloat)money{
    return [self formatMoney:money currency:self.currentCurrency];
}
-(NSString*)formatMoney:(CGFloat)money currency:(Currency*)currency{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    numberFormatter.currencyCode = currency.code;
    numberFormatter.generatesDecimalNumbers = false;
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:money * currency.rate]];
    return numberAsString;
}

-(NSString*)getCurencyUnit{
    return self.currentCurrency.code;
}
-(NSString*)getCountryFlag{
    return self.currentCurrency.flagImageName;
}

-(NSString*)getStringAvailabelBalance{
    return [self formatMoney:self.availableAmount currency:self.currentCurrency];
}

-(CGFloat)convertToUSD:(CGFloat) value{
    if ([self.currentCurrency.code isEqualToString:@"USD"]) {
        return value;
    } else {
        return value / self.currentCurrency.rate;
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    if([hexString length] > 0)
    {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        [scanner setScanLocation:1];
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
    }
    else
    {
        return [UIColor whiteColor];
    }
}

-(CGFloat)getAvailabelBalance{
    return self.availableAmount * self.currentCurrency.rate;
}

-(void)parseBalance:(NSDictionary*)dictData{
    self.totalAmount = [[dictData objectForKey:@"total_amount"] doubleValue];
    self.availableAmount = [[dictData objectForKey:@"available_amount"] doubleValue];
}


#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel* labelBalance;
    UILabel* labelUnit;
    UIImageView * imageFlag;
    if (view == nil) {
        view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        labelBalance = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - (LABEL_UNIT_WIDTH +IMAGE_FLAG_WIDTH + 30) , ROW_HEIGHT)];
        labelBalance.font = [UIFont fontWithName:@"SF UI Display" size:15.0];
        labelBalance.textColor = TOOLOW_GREEN;
        labelBalance.tag = 0;
        [view addSubview:labelBalance];
        
        labelUnit = [[UILabel alloc] initWithFrame:CGRectMake(labelBalance.frame.origin.x + labelBalance.frame.size.width, 0, LABEL_UNIT_WIDTH , ROW_HEIGHT)];
        labelUnit.font = [UIFont fontWithName:@"SF UI Display" size:16.0];
        labelUnit.textColor = [self colorFromHexString:@"#444444"];
        labelUnit.tag = 0;
        [view addSubview:labelUnit];
        
        imageFlag = [[UIImageView alloc] initWithFrame: CGRectMake(labelUnit.frame.origin.x + labelUnit.frame.size.width + 10, (ROW_HEIGHT - IMAGE_FLAG_HEIGHT) / 2, IMAGE_FLAG_WIDTH , IMAGE_FLAG_HEIGHT)];
        [view addSubview:imageFlag];
        
    } else {
        for (UIView * subView in view.subviews){
            if (subView.tag == 0) {
                labelBalance = (UILabel*) (subView);
            } else if(subView.tag == 1) {
                labelUnit = (UILabel*)(subView);
            } else if(subView.tag == 2){
                imageFlag = (UIImageView*)(subView);
            }
        }
    }
    
    CGFloat amount = 0;
    if ([self.delegate respondsToSelector:@selector(getBalanceAmount)]) {
        amount = [self.delegate getBalanceAmount];
    } else {
        amount = [LedgerHelper shared].availableAmount;
    }
    Currency* currency = [[LedgerHelper shared].currencies objectAtIndex:row];
    labelBalance.text = [[LedgerHelper shared] formatMoney:amount currency:currency];
    imageFlag.image = [UIImage imageNamed:currency.flagImageName];
    return view;
}
- (NSInteger)selectedRowInComponent:(NSInteger)component{
    NSInteger index = 0;
    for (Currency * currency in [LedgerHelper shared].currencies) {
        if ([currency.code isEqualToString: [LedgerHelper shared].currentCurrency.code]) {
            break;
        }
        index +=1;
    }
    return index;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [LedgerHelper shared].currentCurrency = [[LedgerHelper shared].currencies objectAtIndex:row];
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_BALANCE object:nil];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [LedgerHelper shared].currencies.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

@end
