//
//  Currency.h
//  TooLow
//
//  Created by Sang Nguyen on 1/21/17.
//  Copyright © 2017 TOOLOW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Currency : NSObject
@property (nonatomic,strong) NSString* code;
@property (nonatomic,assign) CGFloat rate;
@property (nonatomic,strong) NSString* flagImageName;
@end
