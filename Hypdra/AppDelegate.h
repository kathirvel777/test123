//
//  AppDelegate.h
//  Montage
//
//  Created by MacBookPro on 3/20/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import <Foundation/Foundation.h>
#import <Google/SignIn.h>
@import InMobiSDK;


@interface AppDelegate : UIResponder <UIApplicationDelegate , DBSessionDelegate, DBNetworkRequestDelegate>
{
    NSString *relinkUserId;
}

@property (strong, nonatomic) UIWindow *window;


@end

