//
//  DropboxVideoViewController.h
//  Montage
//
//  Created by Srinivasan on 25/10/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DropBoxVideoImportDelegate <NSObject>

@optional

- (void)didFinishedDropBoxVideo:(NSURL*)videoURL;

@end
@interface DropboxVideoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)logout:(id)sender;
- (IBAction)Cancel:(id)sender;

@property (nonatomic,strong) id<DropBoxVideoImportDelegate> delegate;

- (IBAction)backAction:(id)sender;


@end

