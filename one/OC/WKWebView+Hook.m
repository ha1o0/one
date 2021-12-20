//
//  WKWebView+Hook.m
//  one
//
//  Created by sidney on 2021/12/20.
//

#import "WKWebView+Hook.h"
#import <objc/runtime.h>

@implementation WKWebView (Hook)

+ (void)load {
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        Method origin = class_getClassMethod(self, @selector(handlesURLScheme:));
        Method new = class_getClassMethod(self, @selector(_handlesURLScheme:));
        method_exchangeImplementations(origin, new);
    });
}

+ (BOOL)_handlesURLScheme:(NSString *) urlScheme {
    if ([urlScheme isEqualToString:@"http"] || [urlScheme isEqualToString:@"https"]) {
        return NO;
    }
    return [self _handlesURLScheme:urlScheme];
}

@end
