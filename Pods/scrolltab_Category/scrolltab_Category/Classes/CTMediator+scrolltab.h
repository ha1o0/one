//
//  CTMediator+scrolltab.h
//  CTMediator
//
//  Created by sidney on 2022/1/12.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>

@interface CTMediator (scrolltab)

- (UIViewController *)get_scrolltabViewController;
- (UIViewController *)scrolltab_Category_Swift_ViewControllerWithCallback:(void(^)(NSString *result))callback;
- (UIViewController *)scrolltab_Category_Objc_ViewControllerWithCallback:(void(^)(NSString *result))callback;

@end
