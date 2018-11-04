//
//  DataHelper.h

//  TOOLOW
//
//  Created by Sang Nguyen on 2/20/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DataHelper : NSObject
{
  //  NSDateFormatter * dataFormater;
   // NSDateFormatter * monthFormater;
}

@property (strong, nonatomic) NSDateFormatter * dateFormater;
@property (strong, nonatomic) NSDateFormatter * monthFormater;
+(DataHelper*) shared;

- (NSDictionary*)getDataByKey:(NSString*)key tableName:(NSString *)tableName;
- (NSString*) getKey:(NSString*)key;

@end
