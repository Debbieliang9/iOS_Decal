//
//  EncryptionHelper.h
//  TOOLOW
//
//  Created by Sang Nguyen on 2/20/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionHelper : NSObject

+(NSString*) encrypt:(NSString*) string password:(NSString*) password salt:(NSString*)salt iv64:(NSString*)iv64;
+(NSString*) encrypt:(NSString*) string;

@end
