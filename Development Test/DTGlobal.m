//
//  DTGlobal.m
//  Development Test
//
//  Created by Development Test on 25/05/15.
//  Copyright (c) 2015 Development. All rights reserved.
//

#import "DTGlobal.h"
#import <Reachability/Reachability.h>

NSString *Appname = @"Development Test";

@implementation DTGlobal

@synthesize screenSizeType;

+ (DTGlobal *)global
{
    static DTGlobal *object = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        object = [[self alloc] init];
    });
    
    return object;
}

- (instancetype) init
{
    self = [super init];
    
    if(self)
    {
        
    }
    
    return self;
}

- (DTScreenSizeType)screenSizeType
{
    if(screenSizeType == DTScreenSizeTypeUnknown)
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        if(screenSize.height == 480)
        {
            return DTScreenSizeTypeIPhone4;
        }
        else if(screenSize.height == 568)
        {
            return DTScreenSizeTypeIPhone5;
        }
        else if (screenSize.height == 667)
        {
            return DTScreenSizeTypeIPhone6;
        }
        else if (screenSize.height == 736)
        {
            return DTScreenSizeTypeIPhone6p;
        }
        else
        {
            return DTScreenSizeTypeUnknown;
        }
    }
    
    return screenSizeType;
}

+ (BOOL)reachable
{
    Reachability *reachability   = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable)
    {
        return NO;
    }
    
    return YES;
}

+ (NSString *)stringForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (NSDate *)dateForString:(NSString *)stringDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:stringDate];
    
    return date;
}

@end