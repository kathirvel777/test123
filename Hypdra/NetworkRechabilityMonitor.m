//
//  NetworkRechabilityMonitor.m
//  Montage
//
//  Created by MacBookPro on 1/25/18.
//  Copyright © 2018 sssn. All rights reserved.
//

#import "NetworkRechabilityMonitor.h"
#import "AFNetworking.h"

@implementation NetworkRechabilityMonitor

#pragma mark - Start Monitoring Network Manager
+(void)startNetworkReachabilityMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - Check Internet Network Status
+(BOOL)checkNetworkStatus
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end
