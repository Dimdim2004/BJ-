//
//  SubCommentsModel+DealWithComment.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/14.
//

#import "SubCommentsModel+DealWithComment.h"

@implementation BJSubCommentsModel (DealWithComment)
- (NSString *)dealWithTime {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    
    NSDate* date = [formatter dateFromString:self.timeString];
    NSDate* today = [[NSDate alloc] init];
    if ([self isSameYearBetweenDate1:date date2:today]) {
        [formatter setDateFormat:@"MM-dd"];
    } else if (![self isSameYearBetweenDate1:date date2:today]) {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    } else if ([self isOneDayBeforeDate1:today date2:date]) {
        [formatter setDateFormat:@"昨天"];
    } else {
        [formatter setDateFormat:@"MM-dd"];
    }
    NSString* string = [formatter stringFromDate:date];
    return string;
}
- (BOOL)isSameYearBetweenDate1:(NSDate *)date1 date2:(NSDate *)date2 {
    if (!date1 || !date2) return NO;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger year1 = [calendar component:NSCalendarUnitYear fromDate:date1];
    NSInteger year2 = [calendar component:NSCalendarUnitYear fromDate:date2];
    
    return year1 == year2;
}
- (BOOL)isOneDayBeforeDate1:(NSDate *)date1 date2:(NSDate *)date2 {
    if (!date1 || !date2) return NO;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger day1 = [calendar component:NSCalendarUnitDay fromDate:date1];
    NSInteger day2 = [calendar component:NSCalendarUnitDay fromDate:date2];
    
    NSInteger month1 = [calendar component:NSCalendarUnitMonth fromDate:date1];
    NSInteger month2 = [calendar component:NSCalendarUnitMonth fromDate:date2];
    
    return day1 - day2 == 1 && month1 == month2;
}
@end
