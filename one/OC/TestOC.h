//
//  TestOC.h
//  one
//
//  Created by sidney on 2021/12/2.
//

#import <Foundation/Foundation.h>

#ifndef Test_h
#define Test_h

@interface TestOC : NSObject

@property(nonatomic, strong) NSString *name;

- (void)testlog;

- (void)log;

- (void)logOriginal;

- (void)logSwizzling;

- (void)log2:(NSString *)param;

- (void)testLock;

- (void)testObgMsg;

@end


#endif /* Test_h */
