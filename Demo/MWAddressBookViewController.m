//
//  MWAddressBookViewController.m
//  Demo
//
//  Created by caifeng on 16/9/5.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWAddressBookViewController.h"

#import <AddressBookUI/AddressBookUI.h>


@interface MWAddressBookViewController ()<ABPeoplePickerNavigationControllerDelegate>


@end

@implementation MWAddressBookViewController

- (void)viewDidLoad {

    [super viewDidLoad];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    
    peoplePicker.peoplePickerDelegate = self;
    
    [self presentViewController:peoplePicker animated:YES completion:nil];
    
    
}




- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    // 获取联系人名称
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *first = CFBridgingRelease(firstName);
    NSString *last = CFBridgingRelease(lastName);
    NSLog(@"%@---%@", first, last);
    
    
    // 获取联系人电话
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phones);
    for (CFIndex i = 0; i < phoneCount; i++) {
        
        NSString *label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, i));
        NSString *value = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, i));
        NSLog(@"%@-%@", label, value);
    }
    
    CFRelease(phones);

}


- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {

}

@end




