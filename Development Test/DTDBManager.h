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

- (void)saveUser:(DTUser *)user;

- (void)updateUser:(DTUser *)user;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) DTUser *fetchData;

@end