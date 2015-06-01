//
//  YXLPhoneNumber.m
//  通讯录
//
//  Created by 叶星龙 on 15/6/1.
//  Copyright (c) 2015年 一修科技. All rights reserved.
//

#import "YXLPhoneNumber.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>



@interface YXLPhoneNumber ()

@property (nonatomic, copy) void(^successBlock)(void);
@property (nonatomic, copy) void(^failureBlock)(void);

@end

@implementation YXLPhoneNumber

+ (YXLPhoneNumber *)shareAddressBookDB{
    static YXLPhoneNumber *_addressBookDB;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_addressBookDB == nil) {
            _addressBookDB = [[YXLPhoneNumber alloc]init];
        }
        
        
    });
    return _addressBookDB;
}

#pragma mark - LatestUserAddressBook,LastUserAddressBook

///得到当前用户数据
- (void)getLatestUserAddressBookSuccessWithBlock:(void(^)(NSArray *phoneArray))success{
    //获取通讯录权限
    ABAddressBookRef addressBook = NULL;
    //ABAddressBookCreateWithOptions is iOS 6 and up.
    if (&ABAddressBookCreateWithOptions) {
        CFErrorRef error = nil;
        addressBook = ABAddressBookCreateWithOptions(NULL, &error);
        if (error) {
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"获取失败或未授权%li",[(__bridge NSError *)error code]);
            });
            return;
        }
    }
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted == YES) {
            ///当前所有对象
            NSMutableArray* latestArray = [[NSMutableArray alloc]init];
            @autoreleasepool {
                ///得到权限
                CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
                ///所有用户名
                NSMutableArray *allName = [[NSMutableArray alloc]init];
                NSMutableDictionary *phoneDic = [[NSMutableDictionary alloc]init];
                for(int i = 0; i < CFArrayGetCount(results); i++)
                {
                    ABRecordRef person = CFArrayGetValueAtIndex(results, i);
                    NSMutableString *name = [[NSMutableString alloc]init];
                    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                    NSString *middleName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
                    NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
                    NSString *prefix = CFBridgingRelease(ABRecordCopyValue(person, kABPersonPrefixProperty));
                    NSString *suffix = CFBridgingRelease(ABRecordCopyValue(person, kABPersonSuffixProperty));
                    NSString *nickName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty));
                    [name appendFormat:@"%@%@%@%@%@%@",prefix==nil?@"":prefix,lastName==nil?@"":lastName,middleName==nil?@"":middleName,firstName==nil?@"":firstName,suffix==nil?@"":suffix,nickName==nil?@"":nickName];
                    [allName addObject:name];
                }
                
                for(int i = 0; i < CFArrayGetCount(results); i++)
                {
                    ABRecordRef person = CFArrayGetValueAtIndex(results, i);
                    
                    ///当前用户名
                    NSMutableString *name = [[NSMutableString alloc]init];
                    NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                    NSString *middleName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonMiddleNameProperty));
                    NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
                    NSString *prefix = CFBridgingRelease(ABRecordCopyValue(person, kABPersonPrefixProperty));
                    NSString *suffix = CFBridgingRelease(ABRecordCopyValue(person, kABPersonSuffixProperty));
                    NSString *nickName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonNicknameProperty));
                    [name appendFormat:@"%@%@%@%@%@%@",prefix==nil?@"":prefix,lastName==nil?@"":lastName,middleName==nil?@"":middleName,firstName==nil?@"":firstName,suffix==nil?@"":suffix,nickName==nil?@"":nickName];
                    
                    
                    ///查看当前用户下的电话号码
                    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    for (int j = 0; j<ABMultiValueGetCount(phone); j++)
                    {
                        ///正则判断是否满足手机号码格式
                        NSString * personMobile = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phone, j));
                        NSString *regex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
                        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                        NSString *mobile = [personMobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        BOOL isMatch = [pred evaluateWithObject:mobile];
                        
                        
                        if (isMatch) {
                            if (phoneDic[mobile]) {
                                continue ;
                            }
                            [phoneDic setObject:@"123" forKey:mobile];
                            NSDictionary *dic =[[NSDictionary alloc]init];
                            dic =@{
                                   @"name":name,
                                   @"phone":mobile
                                   };
                            
                            [latestArray addObject:dic];
                            
                        }
                        
                    }
                    CFRelease(phone);
                }
                CFRelease(results);
                CFRelease(addressBook);
            }
            
            success(latestArray);
            
        }else {
            /// ----- 未能获得通讯录
            NSLog(@"未能获得通讯录");
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            return;
        }
    });
}
@end
