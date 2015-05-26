//
//  DTUser.m
//  dataBase
//
//  Created by Vivek on 25/05/15.
//  Copyright (c) 2015 cloudZon Infosoft. All rights reserved.
//

#import "DTUser.h"

NSString *const userFirstName    = @"firstName";
NSString *const userLastName     = @"lastName";
NSString *const userGender       = @"gender";
NSString *const userBirthDate    = @"birthDate";
NSString *const userImage        = @"image";
NSString *const userModifiedDate = @"modifiedDate";

@implementation DTUser

@synthesize firstName,lastName,gender,image,birthDate, modifiedDate;

- (instancetype)initWithDictionary:(NSDictionary *)userInfo
{
    self = [super init];
    
    if(self)
    {
        firstName = userInfo[userFirstName];
        lastName  = userInfo[userLastName];
        birthDate = userInfo[userBirthDate];
        gender    = userInfo[userGender];
        
        if([userInfo[userImage] isKindOfClass:[UIImage class]])
        {
            image = userInfo[userImage];
        }
        else if ([userInfo[userImage] isKindOfClass:[NSData class]])
        {
            image = [UIImage imageWithData:userInfo[userImage]];
        }

        if([userInfo[userModifiedDate] isKindOfClass:[NSDate class]])
        {
            modifiedDate = userInfo[userModifiedDate];
        }
        else if ([userInfo[userModifiedDate] isKindOfClass:[NSString class]])
        {
            modifiedDate = [DTGlobal dateForString:userInfo[userModifiedDate]];
        }
    }
    
    return self;
}

+ (void)saveUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isAnyUserLogin
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end