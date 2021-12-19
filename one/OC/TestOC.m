//
//  TestOC.m
//  one
//
//  Created by sidney on 2021/12/2.
//

#import <Foundation/Foundation.h>
#import <os/lock.h>
#import <objc/runtime.h>
#import "TestOC.h"
#import "TestOC2.h"

@implementation TestOC: NSObject

+ (void)load {
    NSLog(@"TestOC load");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        SEL originalSelector = @selector(logOriginal);
        SEL swizzlingSelector = @selector(logSwizzling);
        Method originalMethod = class_getClassMethod(aClass, originalSelector);
        Method swizzlingMethod = class_getClassMethod(aClass, swizzlingSelector);
        method_exchangeImplementations(originalMethod, swizzlingMethod);
        NSLog(@"swizzling success");
    });
}

+ (void)initialize
{
    if (self == [TestOC class]) {
        NSLog(@"TestOC initialize");
    }
}

- (void)testlog {
    [self logOriginal];
}

- (void)logOriginal {
    NSLog(@"log original: %@", self.name);
}

- (void)logSwizzling {
    NSLog(@"log swizzling: %@", self.name);
//    [self logSwizzling];
}

- (void)log {
    NSLog(@"log: %@", self.name);
}

- (void)log2:(NSString *)param {
    NSLog(@"log2: %@", param);
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
}

// 1. 动态解析消息, NSLog只会打印一次，绑定好method后就不再进入此方法，直接调用method。
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    NSLog(@"1. %@", selectorString);
    Method method = class_getInstanceMethod(self, @selector(log));
    class_addMethod(self, sel, method_getImplementation(method), "");
    // 由于上面设置了方法，即使返回NO, 且无论selector是否能被执行，都不会进行消息转发。
    // 只不过如果@selector设置的方法不存在，它会不断重复进入此方法，此时NSLog会不断执行，直至崩溃。
    return YES;
}

// 2. 将消息转发给指定的对象去处理, NSLog每次都会调用
- (id)forwardingTargetForSelector:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    NSLog(@"2. %@", selectorString);
    return [TestOC2 new];
}


// 3. 最后一道防线，为方法生成签名并将消息交由其他对象处理, NSLog每次都会调用
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = [anInvocation selector];
    NSString *selectorString = NSStringFromSelector(sel);
    NSLog(@"3. %@", selectorString);
    TestOC2 *testOC2 = [TestOC2 new];
    if ([testOC2 respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:testOC2];
    }
}


@end
