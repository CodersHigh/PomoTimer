//
//  LSPomoFunction.m
//  PomoTimer
//
//  Created by Lingostar on 13. 1. 9..
//  Copyright (c) 2013년 Lingostar. All rights reserved.
//

#import "LSPomoFunction.h"

NSString *documentDirectory()
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [documentPaths lastObject];
}


int yearOfDate(NSDate *date)
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    return comps.year;
}

int monthOfDate(NSDate *date)
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    return comps.month;
}

int dayOfDate(NSDate *date)
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
    return comps.day;
}

BOOL isSameDay(NSDate *oneDate, NSDate *anotherDate)
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSMonthCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:oneDate  toDate:anotherDate  options:0];
    int years = [comps year];
    int months = [comps month];
    int days = [comps day];
    
    
    /*
     int years = [self yearOfDate:lastPomoDate] - [self yearOfDate:[NSDate date]];
     int months = [self monthOfDate:lastPomoDate] - [self monthOfDate:[NSDate date]];
     int days = [self dayOfDate:lastPomoDate] - [self dayOfDate:[NSDate date]];
     */
    if (years + months + days == 0){
        return YES;
    }
    return NO;
}