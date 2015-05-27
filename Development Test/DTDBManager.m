//
//  dbManager.m
//  dataBase
//
//  Created by cloudZon Infosoft on 03/06/14.
//  Copyright (c) 2014 cloudZon Infosoft. All rights reserved.
//

#import "DTDBManager.h"
#import "DTUser.h"

static NSString *colFirstName    = @"firstName";
static NSString *colLastName     = @"lastName";
static NSString *colEmail        = @"email";
static NSString *colBirthDate    = @"bDate";
static NSString *colGender       = @"gender";
static NSString *colImage        = @"image";
static NSString *colModifiedDate = @"modifiedDate";

static NSString *ID = @"1";

static NSString *tableName = @"userProfile";

@interface DTDBManager()

@end

@implementation DTDBManager

@synthesize dataBasePath,connectToDB;

const char *dbPath;

- (DTDBManager *)initDatabasewithName:(NSString *)name
{
    if (self == [super init])
    {
        [self createDB:name];
    }
    
    return self;
}

-(void)createDB:(NSString *)nameOfDB
{
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDir = dirPath[0];
    
    dataBasePath = [[NSString alloc]initWithString:[docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",nameOfDB]]];
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:dataBasePath] == NO)
    {
        dbPath = [dataBasePath UTF8String];
        
        if (sqlite3_open(dbPath, &connectToDB) == SQLITE_OK)
        {
            
            NSString *createDBSTring = [NSString stringWithFormat:@"create table if not exists %@(id text,%@ text,%@ text,%@ text,%@ text,%@ BLOB, %@ text, %@ text)",
                                        tableName,
                                        colFirstName,
                                        colLastName,
                                        colEmail,
                                        colBirthDate,
                                        colImage,
                                        colGender,
                                        colModifiedDate];
            
            const char *createDB = [createDBSTring UTF8String];
            
            char *errmsg;
            
            if (sqlite3_exec(connectToDB, createDB, NULL, NULL, &errmsg)!=SQLITE_OK)
            {
                NSLog(@"failed to cretae table");
            }
            else
            {
                NSLog(@"cretaed successfully");
            }
            
            sqlite3_close(connectToDB);
        }
        else
        {
            NSLog(@"failed to open database");
        }
    }
}

- (void)saveUser:(DTUser *)user
{
    const char *dbPath=[dataBasePath UTF8String];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbPath, &connectToDB)==SQLITE_OK)
    {
        NSString *insertString = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@) values (?,?,?,?,?,?,?,?)",
                                  tableName,
                                  @"id",
                                  colFirstName,
                                  colLastName,
                                  colEmail,
                                  colBirthDate,
                                  colImage,
                                  colGender,
                                  colModifiedDate];
        
        NSString *modifieddate = [DTGlobal stringForDate:[NSDate date]];
        
        const char *insertQuery = [insertString UTF8String];
        
        NSData *imageData = UIImagePNGRepresentation(user.image);
        
        int imageLength = (int)[imageData length];
        
        sqlite3_prepare_v2(connectToDB, insertQuery, -1, &statement, NULL);
        
        sqlite3_bind_text(statement, 1, [ID UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [user.firstName UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [user.lastName UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 4, [user.email UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 5, [user.birthDate UTF8String], -1, NULL);
        sqlite3_bind_blob(statement, 6, [imageData bytes], imageLength, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [user.gender UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 8, [modifieddate UTF8String], -1, NULL);
        
        if (sqlite3_step(statement)==SQLITE_DONE)
        {
            NSLog(@"inserted successfully");
        }
        else
        {
            NSLog(@"error");
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(connectToDB);
    }
}

- (void)updateUser:(DTUser *)user
{
    BOOL success = false;
    
    sqlite3_stmt *statement;
    
    const char *dbpath = [dataBasePath UTF8String];
    
    if (sqlite3_open(dbpath, &connectToDB) == SQLITE_OK)
    {
        NSLog(@"Exitsing data, Update Please");
        
        NSString *updateSQL = [NSString stringWithFormat:@"update %@ set %@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ?,%@ = ? where id = ?",
                               tableName,
                               colFirstName,
                               colLastName,
                               colEmail,
                               colBirthDate,
                               colImage,
                               colGender,
                               colModifiedDate];
        
        NSString *modifieddate = [DTGlobal stringForDate:[NSDate date]];
        
        NSData *imgData = UIImagePNGRepresentation(user.image);
        
        int imgLength = (int)[imgData length];
        
        const char *update_stmt = [updateSQL UTF8String];
        
        sqlite3_prepare_v2(connectToDB, update_stmt, -1, &statement, NULL );

        sqlite3_bind_text(statement, 1, [user.firstName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [user.lastName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [user.email UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [user.birthDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_blob(statement, 5, [imgData bytes], imgLength, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [user.gender UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [modifieddate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 8, [ID UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
            
            sqlite3_finalize(statement);
            sqlite3_close(connectToDB);
        }
        else if (sqlite3_step(statement) == SQLITE_BUSY)
        {
            NSLog(@"BUSY");
        }
    }
}

- (DTUser *)fetchData
{
    NSDictionary *dic;
    
    const char *dbPath = [dataBasePath UTF8String];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbPath, &connectToDB) == SQLITE_OK)
    {
        NSString *string=[NSString stringWithFormat:@"select * from %@",tableName];
        
        const char *select=[string UTF8String];
        
        if (sqlite3_prepare_v2(connectToDB, select, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *firstName;
                
                const char* firstColumn = (const char*)sqlite3_column_text(statement, 1);
                
                if (firstColumn == NULL)
                {
                    firstName = @"";
                }
                else
                {
                    firstName = @(firstColumn);
                }
                
                NSString *lastName;
                
                const char *secondColumn = (const char*)sqlite3_column_text(statement, 2);
                
                if (secondColumn == NULL)
                {
                    lastName = @"";
                }
                else
                {
                    lastName = @((const char *) secondColumn);
                }
                
                NSString *emailAddress;
                const char* thirdColumn = (const char*)sqlite3_column_text(statement, 3);
                
                if (thirdColumn == NULL)
                {
                    emailAddress = @"";
                }
                else
                {
                    emailAddress = @((const char *) thirdColumn);
                }
                
                NSString *bDate;
                
                const char* fourthColumn = (const char*)sqlite3_column_text(statement, 4);
                
                if (fourthColumn == NULL)
                {
                    bDate = @"";
                }
                else
                {
                    bDate = @((const char *) fourthColumn);
                }
                
                int length = sqlite3_column_bytes(statement, 5);
                
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(statement, 5) length:length];
                
                NSString *gender;
                
                const char* sixthColumn = (const char*)sqlite3_column_text(statement, 6);
                
                if (sixthColumn == NULL)
                {
                    gender = @"";
                }
                else
                {
                    gender = @((const char *) sixthColumn);
                }
                
                NSString *modifiedDate;
                
                const char* seventhCoulmn = (const char*)sqlite3_column_text(statement, 7);
                
                if (seventhCoulmn == NULL)
                {
                    modifiedDate = [DTGlobal stringForDate:[NSDate dateWithTimeIntervalSince1970:0]];
                }
                else
                {
                    modifiedDate = @((const char *) seventhCoulmn);
                }
                
                dic = @{userFirstName   : firstName,
                        userLastName    : lastName,
                        userEmail       : emailAddress,
                        userBirthDate   : bDate,
                        userImage       : imageData,
                        userGender      : gender,
                        userModifiedDate: modifiedDate};
                
                DTUser *user = [[DTUser alloc] initWithDictionary:dic];
                
                sqlite3_finalize(statement);
                sqlite3_close(connectToDB);
                
                return user;
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(connectToDB);
    }
    
    return nil;
}

@end