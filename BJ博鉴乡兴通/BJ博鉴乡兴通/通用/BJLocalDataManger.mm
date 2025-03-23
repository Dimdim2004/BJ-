//
//  BJLocalDataManger.m
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/3/20.
//

#import "BJLocalDataManger.h"
static id localSharedManger = nil;
#import "BJMyDraftModel.h"
#import "WCDB/WCDBObjc.h"
#import "BJUserModel.h"
@interface BJLocalDataManger()<WCTTableCoding>
@property (nonatomic, strong) WCTDatabase* dataBase;
@end
@implementation BJLocalDataManger
+(instancetype) sharedManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localSharedManger = [[super allocWithZone:NULL] init];
    });
    return localSharedManger;
}


@end
