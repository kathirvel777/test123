//
//  singletons.h
//  Montage
//
//  Created by Mac on 2/27/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface singletons : NSObject

+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
@end

