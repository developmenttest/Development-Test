//
//  DTUser.m
//  dataBase
//
//  Created by Vivek on 25/05/15.
//  Copyright (c) 2015 cloudZon Infosoft. All rights reserved.
//

#import "DTUser.h"

NSString *const userFirstName   = @"firstName";
NSString *const userLastName    = @"lastName";
NSString *const userGender      = @"gender";
NSString *const userBirthDate   = @"birthDate";
NSString *const userImage       = @"image";

@implementation DTUser

@synthesize firstName,lastName,gender,image,birthDate;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo
{
    self = [super init];
    
    if(self)
    {
        firstName = userInfo[userFirstName];
        lastName  = userInfo[userLastName];
        birthDate = userInfo[userBirthDate];
        gender    = userInfo[userGender];
        image     = userInfo[userImage];
    
    }
    
    return self;
}

@end