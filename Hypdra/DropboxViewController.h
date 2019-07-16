//
//  DropboxViewController.h
//  DBRoulette
//
//  Created by MacBookPro on 6/8/17.
//  Copyright © 2017 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropBoxImportDelegate <NSObject>

@optional

- (void)didFinishedDropBoxImage:(NSData*)imageData;

@end

@interface DropboxViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) id<DropBoxImportDelegate> delegate;
- (IBAction)backAction:(id)sender;

- (IBAction)logOut:(id)sender;



@end
