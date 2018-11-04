//
//  NSData_SHA1.h
//  TOOLOW
//
//  Created by Sang Nguyen on 2/20/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NSData_SwiftyRSASHA)

- (nonnull NSData*) SwiftyRSASHA1;
- (nonnull NSData*) SwiftyRSASHA224;
- (nonnull NSData*) SwiftyRSASHA256;
- (nonnull NSData*) SwiftyRSASHA384;
- (nonnull NSData*) SwiftyRSASHA512;

@end
