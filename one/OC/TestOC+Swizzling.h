//
//  TestOC+Swizzling.h
//  one
//
//  Created by sidney on 12/20/21.
//

#import "TestOC.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestOC (Swizzling)

+ (void)swizzleInstanceMethod:(Class)target original:(SEL)originalSelector swizzled:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
