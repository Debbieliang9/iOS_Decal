//
//  EncryptionHelper.m
//  TOOLOW
//
//  Created by Sang Nguyen on 2/20/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

#import "EncryptionHelper.h"
#include <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "MealSavvy-Swift.h"

@implementation EncryptionHelper

+(NSString*) encrypt:(NSString*) string {
    NSString * password = [RSAUtils getRSAPassword];
    NSString * salt = [RSAUtils getRSASalt];
    NSString * IV = [RSAUtils getRSAIv];
    return [self encrypt:string password:password salt:salt iv64:IV];
}


+(NSString*) encrypt:(NSString*) string password:(NSString*) password salt:(NSString*)salt iv64:(NSString*)iv64{

    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    NSMutableData* key = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(salt.UTF8String, (CC_LONG)strlen(salt.UTF8String), hash.mutableBytes);
    CCKeyDerivationPBKDF(kCCPBKDF2, password.UTF8String, strlen(password.UTF8String), hash.bytes, hash.length, kCCPRFHmacAlgSHA1, 1000, key.mutableBytes, key.length);
    NSLog(@"Hash : %@",[hash base64EncodedStringWithOptions:0]);
    NSLog(@"Key : %@",[key base64EncodedStringWithOptions:0]);
    
    // Generate a random IV (or use the base64 version from node.js)
    NSData* iv = [[NSData alloc] initWithBase64EncodedString:iv64 options:0];
    NSLog(@"IV : %@",[iv base64EncodedStringWithOptions:0]);

    
    // Encrypt message into base64
    NSData* message = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* encrypted = [NSMutableData dataWithLength:message.length + kCCBlockSizeAES128];
    size_t bytesEncrypted = 0;
    CCCrypt(kCCEncrypt,
            kCCAlgorithmAES128,
            kCCOptionPKCS7Padding,
            key.bytes,
            key.length,
            iv.bytes,
            message.bytes, message.length,
            encrypted.mutableBytes, encrypted.length, &bytesEncrypted);
    NSString* encrypted64 = [[NSMutableData dataWithBytes:encrypted.mutableBytes length:bytesEncrypted] base64EncodedStringWithOptions:0];
    return encrypted64;
}

@end
