//
//  TestOC.m
//  one
//
//  Created by sidney on 2021/12/2.
//

#import <Foundation/Foundation.h>
#import <os/lock.h>
#import "TestOC.h"

@implementation TestOC: NSObject

- (void)log {
    NSLog(@"%@", self.name);
}

- (void)testLock {
    
    // 互斥锁
    __block os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        os_unfair_lock_lock(&lock);
        NSLog(@"第一个线程同步操作开始");
        sleep(1);
        NSLog(@"第一个线程同步操作结束");
        os_unfair_lock_unlock(&lock);
    });
    NSLog(@"main");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        os_unfair_lock_lock(&lock);
        NSLog(@"第二个线程同步操作开始");
        sleep(1);
        NSLog(@"第二个线程同步操作结束");
        os_unfair_lock_unlock(&lock);
    });
    
    // 
}

@end
