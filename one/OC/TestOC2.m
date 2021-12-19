//
//  TestOC2.m
//  one
//
//  Created by sidney on 2021/12/9.
//

#import <Foundation/Foundation.h>
#import "TestOC2.h"
#import "TestOC.h"

@implementation TestOC2: TestOC

+ (void)load {
    NSLog(@"TestOC2 load");
}

+ (void)initialize
{
    if (self == [TestOC2 class]) {
        NSLog(@"TestOC2 initialize");
    }
}

- (void)testObgMsg {
    NSLog(@"test2 testObjMsg");
}

@end
