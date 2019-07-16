//
//  NetworkRechabilityMonitor.h
//  Montage
//
//  Created by MacBookPro on 1/25/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkRechabilityMonitor : NSObject

+(void)startNetworkReachabilityMonitoring;
+(BOOL)checkNetworkStatus;

@end
