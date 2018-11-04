//
//  DataHelper.m

//  TOOLOW
//
//  Created by Sang Nguyen on 2/20/16.
//  Copyright (c) 2016 TOOLOW. All rights reserved.
//

#import "DataHelper.h"
#import <sqlite3.h>
#import "json.h"
#define SET_VALUE(v,k)          [[NSUserDefaults standardUserDefaults] setObject:v forKey:[NSString stringWithFormat:@"%@%@", APP_NAME, k]]
#define DATABASE_NAME @"/toolow.db"
#define DATE_FORMAT_STRING @"yyyy-MM-dd"
#define USER_HID @"USER_HID"

#define DATABASE_VERSION_NAME @"databaseVersion"
@implementation DataHelper
static DataHelper * instant;
@synthesize dateFormater;

+(DataHelper*) shared
{
    if(!instant)
    {
       
        instant = [[DataHelper alloc]init];
        instant.dateFormater = [[NSDateFormatter alloc] init];
        [instant.dateFormater setDateFormat:DATE_FORMAT_STRING];
        instant.monthFormater = [[NSDateFormatter alloc] init];
        [instant.monthFormater setDateFormat:@"yyyy-MM"];
    }
    return instant;
}

-(NSString*) getHid{
    NSString * hid = @"test";
    if (!hid) {
        hid = [[NSUserDefaults standardUserDefaults]stringForKey:USER_HID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return hid;
}


-(NSString*) getKey:(NSString*)key{
    NSString* hid = [self getHid];
    if (hid) {
        return  [NSString stringWithFormat:@"%@%@",hid,key];
    }
    return key;
}


- (NSDictionary*)getDataByKey:(NSString*)key tableName:(NSString *)tableName
{
    sqlite3 *db;
    NSString *databasePath = [self databasePath];
    NSDictionary *dictionary = nil;
    
    /*Check Exist Record Employee*/
    if(sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat: @"SELECT value FROM %@ WHERE key=\"%@\"", tableName,  key];
        const char *selectSQL = [querySQL UTF8String];;
        
        sqlite3_stmt *stmt;
        if(sqlite3_prepare_v2(db, selectSQL, -1, &stmt, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(stmt) == SQLITE_ROW)
            {
                NSString* json_string = [self getString:stmt colum:0];
                dictionary = [json_string JSONValue];
            }
            sqlite3_finalize(stmt);
        }
    }
    sqlite3_close(db);
    return dictionary;
}

- (NSString*)getString:(sqlite3_stmt *)stmt colum:(int)colum{
    if (sqlite3_column_text(stmt, colum)==nil) {
        return @"";
    }else
        return [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, colum)];
}


- (NSString *)databasePath
{
    //[self handleIfLocalDatabaseIsNotExists];
    NSArray *paths  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory    = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingString:DATABASE_NAME];
}


@end
