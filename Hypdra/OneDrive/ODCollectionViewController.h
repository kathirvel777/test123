//
//  ODCollectionViewController.h
//  TestOneDrive
//
//  Created by MacBookPro4 on 10/27/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OneDriveSDK/OneDriveSDK.h>
#import "ODCollectionViewCell.h"

@protocol ODVideoImportDelegate <NSObject>

@optional

- (void)didFinishedODImage:(NSData*)imageData;
- (void)didFinishedODVideo:(NSData*)videoData thumbnail:(NSData *)thumbnailData;


@end

@interface ODCollectionViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *ODCollectionView;

@property NSMutableDictionary *items;

@property NSMutableArray *itemsLookup;

@property (strong, nonatomic) ODClient *client;

@property (strong, nonatomic) NSString *mime_Type;

- (IBAction)btnBackAction:(id)sender;


@property ODItem *currentItem;

- (void)loadChildrenWithRequest:(ODChildrenCollectionRequest*)childrenRequests;

- (void)loadChildren;

- (ODCollectionViewController *)collectionViewWithItem:(ODItem *)item;

- (void)showErrorAlert:(NSError*)error;
- (IBAction)btnDoneAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btndone;
- (IBAction)ODLogout:(id)sender;


@property (nonatomic,strong) id<ODVideoImportDelegate> delegate;
- (IBAction)backAction:(id)sender;

@end
