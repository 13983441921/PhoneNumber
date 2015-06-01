//
//  YXLPhoneNumber.h
//  通讯录
//
//  Created by 叶星龙 on 15/6/1.
//  Copyright (c) 2015年 一修科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLPhoneNumber : NSObject
+ (YXLPhoneNumber *)shareAddressBookDB;

///得到当前用户数据
- (void)getLatestUserAddressBookSuccessWithBlock:(void(^)(NSArray *phoneArray))success;

@end
