//
//  PhotoViewController.h
//  SampleFlickr
//
//  Created by MacBookPro4 on 4/11/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlickrImportDelegate <NSObject>

@optional

- (void)didFinishedFlickrImage:(NSData*)imageData;

@end

@interface PhotoViewController : UIViewController

- (id) initWithURLArray:(NSArray *)urlArray;

@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollview;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIButton *done;

- (IBAction)done:(id)sender;

- (IBAction)back:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *back;

@property (nonatomic,weak) id<FlickrImportDelegate> delegate;

@end
