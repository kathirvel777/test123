//
//  TestKit.m
//  VehicleIAPTest
//
//  Created by MacBookPro4 on 7/7/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import "TestKit.h"
#import "AFNetworking.h"
#import "MyPlayerViewController.h"

@import StoreKit;

NSString *const kMKStoreKitProductsAvailableNotification = @"com.test.teststorekit.productsavailable";
NSString *const kMKStoreKitProductPurchasedNotification = @"com.test.teststorekit.productspurchased";
NSString *const kMKStoreKitProductPurchaseFailedNotification = @"com.test.teststorekit.productspurchasefailed";
NSString *const kMKStoreKitProductPurchaseDeferredNotification = @"com.test.teststorekit.productspurchasedeferred";
NSString *const kMKStoreKitRestoredPurchasesNotification = @"com.test.teststorekit.restoredpurchases";
NSString *const kMKStoreKitRestoringPurchasesFailedNotification = @"com.test.teststorekit.failedrestoringpurchases";
NSString *const kMKStoreKitReceiptValidationFailedNotification = @"com.test.teststorekit.failedvalidatingreceipts";
NSString *const kMKStoreKitSubscriptionExpiredNotification = @"com.test.teststorekit.subscriptionexpired";
NSString *const kMKStoreKitDownloadProgressNotification = @"com.test.teststorekit.downloadprogress";
NSString *const kMKStoreKitDownloadCompletedNotification = @"com.test.teststorekit.downloadcompleted";


NSString *const kSandboxServer = @"https://sandbox.itunes.apple.com/verifyReceipt";
NSString *const kLiveServer = @"https://buy.itunes.apple.com/verifyReceipt";

NSString *const kOriginalAppVersionKey = @"SKOrigBundleRef"; // Obfuscating record key name
static NSDictionary *errorDictionary;

@interface TestKit (/*Private Methods*/) <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSMutableArray *inAppReceipts;
    NSMutableArray *receipts123;
    NSString *transactionVal;
}
@property NSMutableDictionary *purchaseRecord;
@end


static NSString *cFrom;

@implementation TestKit

+ (void) setcFrom:(NSString*)value
{
    cFrom = value;
}


+ (TestKit *)sharedKit {
    
    NSLog(@"sharekit called");
    static TestKit *_sharedKit;
    
    if (!_sharedKit) {
        NSLog(@"!_Sharedkit called");
        
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate,
                      ^{
                          NSLog(@"sharekit dispatch called");
                          _sharedKit = [[super allocWithZone:nil] init];
                          [[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedKit];
                          [_sharedKit restorePurchaseRecord];
                          
#if TARGET_OS_IPHONE
                          
                          [[NSNotificationCenter defaultCenter] addObserver:_sharedKit selector:@selector(savePurchaseRecord)
                                                                       name:UIApplicationDidEnterBackgroundNotification object:nil];
#endif
                          // [_sharedKit startValidatingReceiptsAndUpdateLocalStore];
                      });
    }
    
    return _sharedKit;
}

+ (id)allocWithZone:(NSZone *)zone
{
    NSLog(@"allocWithZone Called");
    return [self sharedKit];
}

- (id)copyWithZone:(NSZone *)zone
{
    NSLog(@"copyWithZone Called");
    
    return self;
}

+ (void)initialize
{
    NSLog(@"initialize called");
    errorDictionary = @{@(21000) : @"The App Store could not read the JSON object you provided.",
                        @(21002) : @"The data in the receipt-data property was malformed or missing.",
                        @(21003) : @"The receipt could not be authenticated.",
                        @(21004) : @"The shared secret you provided does not match the shared secret on file for your accunt.",
                        @(21005) : @"The receipt server is not currently available.",
                        @(21006) : @"This receipt is valid but the subscription has expired.",
                        @(21007) : @"This receipt is from the test environment.",
                        @(21008) : @"This receipt is from the production environment."};
}

#pragma mark -
#pragma mark Helpers

+ (NSDictionary *)configs
{
    NSLog(@"configs");
    NSLog(@"MKStoreKitConfigs:%@",[NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TestProductsList.plist"]]);
    
    return [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TestProductsList.plist"]];
}

#pragma mark -
#pragma mark Store File Management

- (NSString *)purchaseRecordFilePath
{
    NSLog(@"purchaseRecodeFilePath");
    
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"PurchaseRecordPlist:%@",[documentDirectory stringByAppendingPathComponent:@"purchaserecord.plist"]);
    return [documentDirectory stringByAppendingPathComponent:@"purchaserecord.plist"];
}

- (void)restorePurchaseRecord {

    NSLog(@"restorePurchaseRecord");
    self.purchaseRecord = (NSMutableDictionary *)[[NSKeyedUnarchiver unarchiveObjectWithFile:[self purchaseRecordFilePath]] mutableCopy];
    if (self.purchaseRecord == nil) {
        self.purchaseRecord = [NSMutableDictionary dictionary];
    }
    NSLog(@"PurchaseRecord:%@", self.purchaseRecord);
}

- (void)savePurchaseRecord {
    NSLog(@"savePurchaseRecord:%@",self.purchaseRecord);
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.purchaseRecord];
#if TARGET_OS_IPHONE
    BOOL success = [data writeToFile:[self purchaseRecordFilePath] options:NSDataWritingAtomic | NSDataWritingFileProtectionComplete error:&error];
#elif TARGET_OS_MAC
    BOOL success = [data writeToFile:[self purchaseRecordFilePath] options:NSDataWritingAtomic error:&error];
#endif
    
    if (!success) {
        
        NSLog(@"Failed to remember data record");
    }
    
    NSLog(@"%@", self.purchaseRecord);
}

#pragma mark -
#pragma mark Feature Management

- (BOOL)isProductPurchased:(NSString *)productId {
    NSLog(@"isProductPurchased:%hhd",
          [self.purchaseRecord.allKeys containsObject:productId]);
    NSLog(@"allkeys:%@",self.purchaseRecord.allKeys);
    return [self.purchaseRecord.allKeys containsObject:productId];
}

-(NSDate*) expiryDateForProduct:(NSString*) productId {
    NSLog(@"expiryDateforProdut:%@",productId);
    
    NSNumber *expiresDateMs = self.purchaseRecord[productId];
    if ([expiresDateMs isKindOfClass:NSNull.class]) {
        return NSDate.date;
    } else {
        NSLog(@"ExpireDate of double:%@",[NSDate dateWithTimeIntervalSince1970:[expiresDateMs doubleValue] / 1000.0f]);
        return [NSDate dateWithTimeIntervalSince1970:[expiresDateMs doubleValue] / 1000.0f];
    }
}

- (NSNumber *)availableCreditsForConsumable:(NSString *)consumableId {
    
    NSLog(@"availableCreditsForConsumable");
    return self.purchaseRecord[consumableId];
}

#pragma mark -
#pragma mark Start requesting for available in app purchases

- (void)startProductRequestWithProductIdentifiers:(NSArray*) items
{
    NSLog(@"startProductRequestwithProductIdentifiers");
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:items]];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)startProductRequest
{
    NSLog(@"startProductRequest");
    NSMutableArray *productsArray = [NSMutableArray array];
    NSArray *ai = [TestKit configs][@"AI"];
    NSArray *uploads = [TestKit configs][@"Uploads"];
    NSArray *others = [TestKit configs][@"MemberShip"];
    NSArray *watMrk = [TestKit configs][@"WaterMark"];
    NSArray *min = [TestKit configs][@"Minutes"];
    NSArray *spc = [TestKit configs][@"Space"];
    NSArray *effects=[TestKit configs][@"Effects"];
    NSArray *tens = [TestKit configs][@"Tens"];

    [productsArray addObjectsFromArray:watMrk];
    [productsArray addObjectsFromArray:others];
    [productsArray addObjectsFromArray:min];
    [productsArray addObjectsFromArray:spc];
    [productsArray addObjectsFromArray:effects];
    [productsArray addObjectsFromArray:tens];
    [productsArray addObjectsFromArray:uploads];
    [productsArray addObjectsFromArray:ai];
    
    
    [self startProductRequestWithProductIdentifiers:productsArray];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    if (response.invalidProductIdentifiers.count > 0) {
        NSLog(@"Invalid Product IDs: %@", response.invalidProductIdentifiers);
    }
    
    self.availableProducts = response.products;
    NSLog(@"availableProducts:%@",self.availableProducts);
    [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitProductsAvailableNotification
                                                        object:self.availableProducts];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Product request failed with error: %@", error);
}

#pragma mark -
#pragma mark Restore Purchases

- (void)restorePurchases {
    NSLog(@"restorePurchases");
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"restorefailed");
    [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitRestoringPurchasesFailedNotification object:error];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"restoreCompleted");
    [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitRestoredPurchasesNotification object:nil];
}

#pragma mark -
#pragma mark Initiate a Purchase

- (void)initiatePaymentRequestForProductWithIdentifier:(NSString *)productId
{
    NSLog(@"initiate Payment Request");
    if (!self.availableProducts) {

        // Initializer might be running or internet might not be available
        NSLog(@"No products are available. Did you initialize MKStoreKit by calling [[MKStoreKit sharedKit] startProductRequest]?");
    }
    
    if (![SKPaymentQueue canMakePayments]) {
        
#if TARGET_OS_IPHONE
#elif TARGET_OS_MAC
        
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = NSLocalizedString(@"In App Purchasing Disabled", @"");
        alert.informativeText = NSLocalizedString(@"Check your parental control settings and try again later", @"");
        [alert runModal];
#endif
        return;
    }
    
    [self.availableProducts enumerateObjectsUsingBlock:^(SKProduct *thisProduct, NSUInteger idx, BOOL *stop) {
        NSLog(@"thisProduct:%@",thisProduct.productIdentifier);
        if ([thisProduct.productIdentifier isEqualToString:productId]) {
            *stop = YES;
            SKPayment *payment = [SKPayment paymentWithProduct:thisProduct];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }];
}

#pragma mark -
#pragma mark Receipt validation

- (void)refreshAppStoreReceipt {
    
    NSLog(@"refreshAllStoreReceipt");
    SKReceiptRefreshRequest *refreshReceiptRequest = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
    refreshReceiptRequest.delegate = self;
    [refreshReceiptRequest start];
    
}

- (void)requestDidFinish:(SKRequest *)request {
    // SKReceiptRefreshRequest
    NSLog(@"requestDidFinish:%@",request);
    if([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[receiptUrl path]]) {
            NSLog(@"App receipt exists. Preparing to validate and update local stores.");
            //[self startValidatingReceiptsAndUpdateLocalStore];
        } else {
            NSLog(@"Receipt request completed but there is no receipt. The user may have refused to login, or the reciept is missing.");
            // Disable features of your app, but do not terminate the app
        }
    }
}

- (void)startValidatingAppStoreReceiptWithCompletionHandler:(void (^)(NSArray *receipts, NSError *error)) completionHandler {
    
    NSLog(@"startValidatingAppStoreReceipt completionhandler");

    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSError *receiptError;
    BOOL isPresent = [receiptURL checkResourceIsReachableAndReturnError:&receiptError];
    
    NSLog(@"isPresent:%d",isPresent);
    
    if (!isPresent) {
        // No receipt - In App Purchase was never initiated
        completionHandler(nil, nil);
        return;
    }
    
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    if (!receiptData) {

        NSLog(@"Receipt exists but there is no data available. Try refreshing the reciept payload and then checking again.");
        completionHandler(nil, nil);
        return;
    }
    
    NSError *error;
    NSMutableDictionary *requestContents = [NSMutableDictionary dictionaryWithObject:
                                            [receiptData base64EncodedStringWithOptions:0] forKey:@"receipt-data"];
    NSString *sharedSecret = [TestKit configs][@"SharedSecret"];
    
    NSLog(@"SharedSecret:%@",sharedSecret);
    
    if (sharedSecret) requestContents[@"password"] = sharedSecret;
    
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    
#ifdef DEBUG
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kSandboxServer]];
#else
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kLiveServer]];
#endif
    
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:storeRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSLog(@"jsonResponse:%@",jsonResponse);
            
            //            NSString *string = [NSString stringWithFormat: @"%@", jsonResponse];
            
            
            printf("Complete JSON = %s", [NSString stringWithFormat: @"%@", jsonResponse].UTF8String);
            
            //            printf("%s",string);
            
            //            NSLog(@"LatestRecipt :%@",[jsonResponse objectForKey:@"latest_receipt"]);
            
            //            [self sendSpaceServer:[jsonResponse objectForKey:@"latest_receipt"]];
            
            [[NSUserDefaults standardUserDefaults]setObject:jsonResponse forKey:@"PurchaseReceipt"];
            
            [[NSUserDefaults standardUserDefaults]setObject:[jsonResponse objectForKey:@"latest_receipt"] forKey:@"ltsReceipt"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            NSInteger status = [jsonResponse[@"status"] integerValue];
            
            NSLog(@"status:%ld",(long)status);
            
            if (jsonResponse[@"receipt"] != [NSNull null])
            {
                NSString *originalAppVersion = jsonResponse[@"receipt"][@"original_application_version"];
                
                //  NSLog(@"originalAppVersion:%@",originalAppVersion);
                
                if (nil != originalAppVersion)
                {
                    [self.purchaseRecord setObject:originalAppVersion forKey:kOriginalAppVersionKey];
                    [self savePurchaseRecord];
                }
                else
                {
                    completionHandler(nil, nil);
                }
            }
            else
            {
                completionHandler(nil, nil);
            }
            
            if (status != 0)
            {
                NSError *error = [NSError errorWithDomain:@"com.test.teststorekit" code:status userInfo:@{NSLocalizedDescriptionKey : errorDictionary[@(status)]}];
                completionHandler(nil, error);
            }
            else
            {
                NSMutableArray *receipts = [jsonResponse[@"latest_receipt_info"] mutableCopy];
                
                receipts123 =[jsonResponse[@"latest_receipt_info"]mutableCopy];
                NSLog(@"latestReceipt");
                //NSLog(@"latestReceipt:%@",receipts);
                
                if (jsonResponse[@"receipt"] != [NSNull null])
                {
                    
                    inAppReceipts = jsonResponse[@"receipt"][@"in_app"];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:inAppReceipts forKey:@"ConsumeReceipt"];
                    NSString *order_id = [NSString stringWithFormat:@"%@",[[inAppReceipts objectAtIndex:0] valueForKey:@"transaction_id"]];
                    
                    [[NSUserDefaults standardUserDefaults]setObject:order_id forKey:@"order_id"];

                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    
                    
                    //NSLog(@"inAppReceipts:%@",inAppReceipts);
                    
                    [receipts addObjectsFromArray:inAppReceipts];
                    
                    //[self StoreReceiptIntoServer:inAppReceipts];
                    
                    completionHandler(receipts, nil);
                }
                else
                {
                    completionHandler(nil, nil);
                }
            }
        }
        else
        {
            completionHandler(nil, error);
        }
    }] resume];
}


- (BOOL)purchasedAppBeforeVersion:(NSString *)requiredVersion {
    NSString *actualVersion = [self.purchaseRecord objectForKey:kOriginalAppVersionKey];
    NSLog(@"purchasedAppBeforeVersion required:%@",requiredVersion);
    
    NSLog(@"purchasedAppBeforeVersion actual:%@",actualVersion);
    
    if ([requiredVersion compare:actualVersion options:NSNumericSearch] == NSOrderedDescending) {
        // actualVersion is lower than the requiredVersion
        return YES;
    } else return NO;
}

- (void)startValidatingReceiptsAndUpdateLocalStore
{
    //[self restorePurchases];
    
    [self startValidatingAppStoreReceiptWithCompletionHandler:^(NSArray *receipts, NSError *error) {
        if (error) {
            NSLog(@"Receipt validation failed with error: %@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitReceiptValidationFailedNotification object:error];
        } else {
            __block BOOL purchaseRecordDirty = NO;
            [receipts enumerateObjectsUsingBlock:^(NSDictionary *receiptDictionary, NSUInteger idx, BOOL *stop) {
                NSString *productIdentifier = receiptDictionary[@"product_id"];
                
                NSLog(@"productIdentifier:%@",productIdentifier);
                
                NSNumber *expiresDateMs = receiptDictionary[@"expires_date_ms"];
                NSLog(@"expiresDateMS:%@",expiresDateMs);
                
                if (expiresDateMs) { // renewable subscription
                    NSNumber *previouslyStoredExpiresDateMs = self.purchaseRecord[productIdentifier];
                    NSLog(@"number previouslyexpiredate:%@",previouslyStoredExpiresDateMs);
                    
                    if (!previouslyStoredExpiresDateMs ||
                        [previouslyStoredExpiresDateMs isKindOfClass:NSNull.class])
                    {
                        NSLog(@"!previously stored called");
                        self.purchaseRecord[productIdentifier] = expiresDateMs;
                        purchaseRecordDirty = YES;
                    }
                    else
                    {
                        if ([expiresDateMs doubleValue] > [previouslyStoredExpiresDateMs doubleValue])
                        {
                            NSLog(@"previously stored called");
                            self.purchaseRecord[productIdentifier] = expiresDateMs;
                            purchaseRecordDirty = YES;
                        }
                    }
                }
            }];
            
            if (purchaseRecordDirty) {
                [self savePurchaseRecord];
            }
            
            [self.purchaseRecord enumerateKeysAndObjectsUsingBlock:^(NSString *productIdentifier, NSNumber *expiresDateMs, BOOL *stop) {
                if (![expiresDateMs isKindOfClass: [NSNull class]]) {
                    if ([[NSDate date] timeIntervalSince1970] > [expiresDateMs doubleValue])
                    {
                        NSLog(@"date:%f",[[NSDate date] timeIntervalSince1970]);
                        NSLog(@"date1:%f",[expiresDateMs doubleValue]);
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitSubscriptionExpiredNotification object:productIdentifier];

                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitProductPurchasedNotification
                        //      object:productIdentifier];
                    }
                }
            }];
        }
        
        NSLog(@"CFrom = %@",cFrom);
        
        if ([cFrom isEqualToString:@"Advance"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rmveWatermrk" object:transactionVal];
        }
        else if ([cFrom isEqualToString:@"Wizard"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rmveWzdWatermrk" object:transactionVal];
        }
        else if ([cFrom isEqualToString:@"Minutes"] || [cFrom isEqualToString:@"Space"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"topupMinSpc" object:transactionVal];
        }
        else if([cFrom isEqualToString:@"EffectsOrTransition"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockEffectsOrTransition" object:transactionVal];
        }
        else if([cFrom isEqualToString:@"TenzTemplate"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlockTenzTemplate" object:transactionVal];
        }
        else if([cFrom isEqualToString:@"UploadOneMusic"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadOneMusic" object:transactionVal];
        }
        else if([cFrom isEqualToString:@"UploadOneAIStyle"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadOneAIStyle" object:transactionVal];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitProductPurchasedNotification object:transactionVal];
        }
    }];
}

#pragma mark -
#pragma mark Transaction Observers

// TODO: FIX ME
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads {
    NSLog(@"updatedDownloads called");

    [downloads enumerateObjectsUsingBlock:^(SKDownload *thisDownload, NSUInteger idx, BOOL *stop) {
        SKDownloadState state;
#if TARGET_OS_IPHONE
        state = thisDownload.downloadState;
#elif TARGET_OS_MAC
        state = thisDownload.state;
#endif
        NSLog(@"state:%ld",(long)state);
        switch (state) {
            case SKDownloadStateActive:
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kMKStoreKitDownloadProgressNotification
                 object:thisDownload
                 userInfo:@{thisDownload.transaction.payment.productIdentifier: @(thisDownload.progress)}];
                break;
            case SKDownloadStateFinished: {
                NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                NSString *contentDirectoryForThisProduct =
                [[documentDirectory stringByAppendingPathComponent:@"Contents"]
                 stringByAppendingPathComponent:thisDownload.transaction.payment.productIdentifier];
                
                [NSFileManager.defaultManager createDirectoryAtPath:contentDirectoryForThisProduct withIntermediateDirectories:YES attributes:nil error:nil];
                NSError *error = nil;
                [NSFileManager.defaultManager moveItemAtURL:thisDownload.contentURL
                                                      toURL:[NSURL URLWithString:contentDirectoryForThisProduct]
                                                      error:&error];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:kMKStoreKitDownloadCompletedNotification
                 object:thisDownload
                 userInfo:@{thisDownload.transaction.transactionIdentifier: contentDirectoryForThisProduct}];
                [queue finishTransaction:thisDownload.transaction];
            }
                
                break;
            default:
                break;
        }
    }];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"transactionState:%ld",(long)transaction.transactionState);
        switch (transaction.transactionState) {
                
            case SKPaymentTransactionStatePurchasing:
                break;
                
            case SKPaymentTransactionStateDeferred:
                [self deferredTransaction:transaction inQueue:queue];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction inQueue:queue];
                break;
                
            case SKPaymentTransactionStatePurchased:
            case SKPaymentTransactionStateRestored: {
                NSLog(@"purchased or restored called");
                
                if (transaction.downloads.count > 0) {
                    [SKPaymentQueue.defaultQueue startDownloads:transaction.downloads];
                } else {
                    [queue finishTransaction:transaction];
                }
                
                //                NSDictionary *availableConsumables = [MKStoreKit configs][@"Consumables"];
                //                NSArray *consumables = [availableConsumables allKeys];
                //                if ([consumables containsObject:transaction.payment.productIdentifier]) {
                //
                //                    NSDictionary *thisConsumable = availableConsumables[transaction.payment.productIdentifier];
                //                    NSLog(@"thisConsumable:%@",thisConsumable);
                //                    NSString *consumableId = thisConsumable[@"ConsumableId"];
                //                    NSLog(@"consumableId:%@",consumableId);
                //                    NSNumber *consumableCount = thisConsumable[@"ConsumableCount"];
                //                    NSLog(@"consumbaleCount:%@",consumableCount);
                //                    NSNumber *currentConsumableCount = self.purchaseRecord[consumableId];
                //                    NSLog(@"currentConsumablecount:%@",currentConsumableCount);
                //                    consumableCount = @([consumableCount doubleValue] + [currentConsumableCount doubleValue]);
                //                    self.purchaseRecord[consumableId] = consumableCount;
                //                } else {
                //                    // non-consumable or subscriptions
                //                    // subscriptions will eventually contain the expiry date after the receipt is validated during the next run
                //  self.purchaseRecord[transaction.payment.productIdentifier] = [NSNull null];
                
                
                transactionVal = transaction.payment.productIdentifier;
                
                [self startValidatingReceiptsAndUpdateLocalStore];
                
                //   }
                
                //                [self savePurchaseRecord];
                //                [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitProductPurchasedNotification
                //                    object:transaction.payment.productIdentifier];
            }
                break;
        }
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction inQueue:(SKPaymentQueue *)queue {
    NSLog(@"Transaction Failed with error: %@", transaction.error);
    [queue finishTransaction:transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitProductPurchaseFailedNotification
                                                        object:transaction.payment.productIdentifier];
}

- (void)deferredTransaction:(SKPaymentTransaction *)transaction inQueue:(SKPaymentQueue *)queue
{
    NSLog(@"Transaction Deferred: %@", transaction);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMKStoreKitProductPurchaseDeferredNotification
                                                        object:transaction.payment.productIdentifier];
}




@end
