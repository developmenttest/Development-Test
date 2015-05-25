//
//  dbManager.h
//  dataBase
//
//  Created by cloudZon Infosoft on 03/06/14.
//  Copyright (c) 2014 cloudZon Infosoft. All rights reserved.
//

#import <sqlite3.h>

@interface DTDBManager : NSObject

@property(nonatomic) sqlite3 *connectToDB;

@property(strong,nonatomic) NSString *dataBasePath;

- (DTDBManager *)initDatabasewithName:(NSString *)name NS_DESIGNATED_INITIALIZER;

- (void)createDB:(NSString *)nameOfDB;

- (void)saveProfile:(NSString *)firstNames lastName:(NSString *)lastNames date:(NSString *)date data:(NSData *)imageData gender:(NSString *)genders;

- (void)updateDataForfirstName:(NSString *)firstName lastName:(NSString *)lastName dateOfBirth:(NSString *)bDate gender:(NSString *)gendr image:(NSData *)imgData;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *fetchData;

@end