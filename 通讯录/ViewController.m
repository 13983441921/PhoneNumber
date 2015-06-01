//
//  ViewController.m
//  通讯录
//
//  Created by 叶星龙 on 15/4/13.
//  Copyright (c) 2015年 一修科技. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import "YXLPhoneNumber.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[YXLPhoneNumber shareAddressBookDB]getLatestUserAddressBookSuccessWithBlock:^(NSArray *phoneArray) {
        for(int i=0;i < [phoneArray count];i++)
        {
            
            NSLog(@"%@:%@\n",phoneArray[i][@"name"],phoneArray[i][@"phone"]);
//            continue;
        }
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
