//
//  BJMyPageDraftModel.h
//  BJ博鉴乡兴通
//
//  Created by nanxun on 2025/4/3.
//

#import <Foundation/Foundation.h>
#import "DatabaseProtocol.h"
@interface BJMyPageDraftModel : NSObject <DatabaseProtocol>
@property (nonatomic, copy) NSString* titleString;
@property (nonatomic, copy) NSString* contentString;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, assign) NSInteger noteId;
@property (nonatomic, copy) NSArray* images;
/*
 // An ORM type can be any C types or any ObjC classes which conforms to NSCoding or WCTColumnCoding protocol.
 // An ORM property must contains a setter which can be private
@property (nonatomic, retain) NSString *<#property1#>;
@property (nonatomic, assign) NSInteger <#property2#>;
@property (nonatomic, assign) float <#property3#>;
@property (nonatomic, strong) NSArray *<#property4#>;
@property (nonatomic, readonly) NSDate *<#..........#>;
 */

@end
