//
//  TestOC+Swizzling.m
//  one
//
//  Created by sidney on 12/20/21.
//

#import "TestOC+Swizzling.h"
#import <objc/runtime.h>

@implementation TestOC (Swizzling)

+ (void)swizzleInstanceMethod:(Class)target original:(SEL)originalSelector swizzled:(SEL)swizzledSelector {
    Method originMethod = class_getInstanceMethod(target, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(target, swizzledSelector);
    method_exchangeImplementations(originMethod, swizzledMethod);
}

+ (void)load {
    NSLog(@"TestOC swizzling load");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        SEL originalSelector = @selector(logOriginal);
        SEL swizzlingSelector = @selector(logSwizzling);
        [self swizzleInstanceMethod:aClass original:originalSelector swizzled:swizzlingSelector];
        NSLog(@"swizzling success");
    });
}


@end
