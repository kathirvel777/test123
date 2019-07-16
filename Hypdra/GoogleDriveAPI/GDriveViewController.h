//
//  GDriveViewController.h
//  Montage
//
//  Created by Srinivasan on 02/11/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <GTLRDrive.h>

@protocol GDriveImportDelegate <NSObject>

@optional

- (void)didFinishedGDriveVideo:(NSURL*)videoURL;
-(void)didFinishedGDriveImage:(NSURL*)imageURL second:(NSString *)thumbnailLnkImg;

@end

@interface GDriveViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,GIDSignInDelegate, GIDSignInUIDelegate>

@property (strong, nonatomic) IBOutlet UITableView *gDriveTableView;

@property (nonatomic, retain) GTLRDriveService *driveService;
@property (strong) NSMutableArray *driveFiles;
@property(strong) NSString *mimeTypes;


- (void)loadDriveFiles;

@property (nonatomic,weak) id<GDriveImportDelegate> delegate;

- (IBAction)signOut:(id)sender;

@end
