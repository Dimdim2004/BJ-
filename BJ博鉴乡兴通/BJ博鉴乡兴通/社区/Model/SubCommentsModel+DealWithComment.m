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
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    NSDate* date = [formatter dateFromString:self.timeString];
    if (!date) return @""; // 处理解析失败
    NSDate* today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    if ([calendar isDateInYesterday:date]) {
        return @"昨天";
    } else if ([self isSameYearBetweenDate1:date date2:today]) {
        [formatter setDateFormat:@"MM-dd"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [formatter stringFromDate:date];
}

// 优化后的年份判断
- (BOOL)isSameYearBetweenDate1:(NSDate *)date1 date2:(NSDate *)date2 {
    if (!date1 || !date2) return NO;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar component:NSCalendarUnitYear fromDate:date1] == [calendar component:NSCalendarUnitYear fromDate:date2];
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
