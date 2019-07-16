//
//  TestKit.h
//  VehicleIAPTest
//
//  Created by MacBookPro4 on 7/7/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TargetConditionals.h"

extern NSString *const kMKStoreKitProductsAvailableNotification;

extern NSString *const kMKStoreKitProductPurchasedNotification;

extern NSString *const kMKStoreKitProductPurchaseFailedNotification;

extern NSString *const kMKStoreKitProductPurchaseDeferredNotification NS_AVAILABLE(10_10, 8_0);

extern NSString *const kMKStoreKitRestoredPurchasesNotification;

extern NSString *const kMKStoreKitRestoringPurchasesFailedNotification;

extern NSString *const kMKStoreKitReceiptValidationFailedNotification;

extern NSString *const kMKStoreKitSubscriptionExpiredNotification;

extern NSString *const kMKStoreKitDownloadProgressNotification;

extern NSString *const kMKStoreKitDownloadCompletedNotification;


@interface TestKit : NSObject

@property NSArray *availableProducts;

+ (TestKit *)sharedKit;


//+ (NSString*)cFrom;

+ (void) setcFrom:(NSString*)value;



- (void)startProductRequest;

- (void)startProductRequestWithProductIdentifiers:(NSArray*) items;
- (void)restorePurchases;

- (void)refreshAppStoreReceipt;


- (void)initiatePaymentRequestForProductWithIdentifier:(NSString *)productId;

- (BOOL)purchasedAppBeforeVersion:(NSString *)requiredVersion;

- (BOOL)isProductPurchased:(NSString *)productId;

- (NSDate *)expiryDateForProduct:(NSString *)productId;

//- (NSNumber *)availableCreditsForConsumable:(NSString *)consumableID;
//
//- (NSNumber *)consumeCredits:(NSNumber *)creditCountToConsume identifiedByConsumableIdentifier:(NSString *)consumableId;
//
//- (void)setDefaultCredits:(NSNumber *)creditCount forConsumableIdentifier:(NSString *)consumableId;


@end
