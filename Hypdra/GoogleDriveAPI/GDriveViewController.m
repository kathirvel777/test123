//
//  GDriveViewController.m
//  Montage
//
//  Created by Srinivasan on 02/11/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "GDriveViewController.h"
#import <Google/SignIn.h>
#import <GTLRDrive.h>
#import "MBProgressHUD.h"
#import "GDriveTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SwipeBack.h"

@interface GDriveViewController ()
{
    NSURL *commonURL;
    NSString *queryQ;
    MBProgressHUD *hud;
    GIDSignIn* signIn;

#define URL @"https://www.hypdra.com/api/api.php?rquest=image_upload"
}

@end

@implementation GDriveViewController
@synthesize driveFiles = _driveFiles;
@synthesize driveService = _driveService;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.swipeBackEnabled=NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.view.hidden=YES;
    // Configure Google Sign-in.
    signIn = [GIDSignIn sharedInstance];
    signIn.delegate = self;
    signIn.uiDelegate = self;
    signIn.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeDrive, nil];
    
//    if([signIn hasAuthInKeychain])
//    {
        [signIn signInSilently];

  //  }
    
    self.driveService = [[GTLRDriveService alloc] init];
    _driveFiles=[[NSMutableArray alloc]init];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    GIDGoogleUser *currentUser = [GIDSignIn sharedInstance].currentUser;
    NSLog(@"user = %@", currentUser);
    
    if (!currentUser)
    {
        [self showSignIn];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [signIn signInSilently];
    
}

- (void)showSignIn
{
    //[[GIDSignIn sharedInstance] hasAuthInKeychain];
    [[GIDSignIn sharedInstance] signIn];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.driveFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"GDriveTableViewCell";
    
    GTLRDrive_File *file = [self.driveFiles objectAtIndex:indexPath.row];
        
    GDriveTableViewCell *cell = (GDriveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GDriveTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSURL *aURL = [NSURL URLWithString:[file.thumbnailLink stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    NSLog(@"the url is %@",aURL);
    
    //UIImage *aImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:aURL]];
    
    cell.nameLabel.text= file.name;
    
    [cell.imgView sd_setImageWithURL:aURL placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
    cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
   // cell.imgView.layer.cornerRadius=cell.imgView.frame.size.width/2;
    //cell.imgView.image=aImage;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    GTLRDrive_File *file = [self.driveFiles objectAtIndex:indexPath.row];
    
    NSString *fileiD=file.identifier;
    NSString *fileName=file.name;
    
    NSString *thumbnailLnkImage=file.thumbnailLink;
    
    GTLRQuery *query = [GTLRDriveQuery_FilesGet queryForMediaWithFileId:fileiD];
    
    @try
    {
        [self.driveService executeQuery:query completionHandler:^(GTLRServiceTicket *ticket,GTLRDataObject *file,NSError *error)
         {
             if (error == nil)
             {
                 NSLog(@"Downloaded %lu bytes", file.data.length);
                 
                 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                 NSString *DocDir = [paths objectAtIndex:0];
                 
                 DocDir = [DocDir stringByAppendingPathComponent:fileName];
                 
                 [file.data writeToFile:DocDir atomically:NO];
                 
                 if([_mimeTypes isEqualToString:@"video"])
                 {
                 commonURL = [NSURL fileURLWithPath:DocDir];
                     [self downloadVideo:commonURL];

                 }
                 
                 if([_mimeTypes isEqualToString:@"image"])
                 {
                     commonURL = [NSURL fileURLWithPath:DocDir];
                     [self downloadImage:commonURL second:thumbnailLnkImage];
                 }
             }
             
             else
             {
                 NSLog(@"An error occurred: %@", error);
             }
         }];

    }
    @catch (NSException *exception)
    {
        NSLog(@"The excep is %@",exception);
    }
}

-(void)downloadVideo:(NSURL *)filename
{
        if ([self.delegate respondsToSelector:@selector(didFinishedGDriveVideo:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {

            [self.delegate didFinishedGDriveVideo:filename];
            
            [self.navigationController popViewControllerAnimated:YES];

            });
        
         }
}

-(void)downloadImage:(NSURL *)filename second:(NSString *)thumbnailLnkImg
{
        if ([self.delegate respondsToSelector:@selector(didFinishedGDriveImage: second:)])
        
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                
                [self.delegate didFinishedGDriveImage:filename second:thumbnailLnkImg];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            });

        }
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    @try
    {
        GIDGoogleUser *currentUser = [GIDSignIn sharedInstance].currentUser;
        NSLog(@"user = %@", currentUser);
        
        NSLog(@"the error is%@",error);
        NSString *errorValue=[NSString stringWithFormat:@"%@",error];
        
        if([errorValue containsString:@"user canceled the sign-in flow"])
        {
            NSLog(@"the string");
            
            NSArray *array = [self.navigationController viewControllers];
            
            NSLog(@"the arr %@",array);
            
            [self.navigationController popToViewController:[array objectAtIndex:0] animated:YES];
        }

        if(currentUser)
        {
            
            self.driveService.authorizer = user.authentication.fetcherAuthorizer;
            
            self.view.hidden=NO;
            [self loadDriveFiles];
        }
    } @catch (NSException *exception)
    {
        
    }
}

- (void)loadDriveFiles
{
    GTLRDriveQuery_FilesList *query = [GTLRDriveQuery_FilesList query];
    
    if([_mimeTypes isEqualToString:@"video"])
    {
      queryQ  = [NSString stringWithFormat:@"mimeType='video/mp4'"];
    }
    
    else if([_mimeTypes isEqualToString:@"image"])
    {
        queryQ=[NSString stringWithFormat:@"mimeType='image/jpeg' or mimeType='image/png' or mimeType='image/gif'"];
    }
    
    query.q=queryQ;
    query.pageSize = 10;
    
    query.fields = @"files(id,name,mimeType,modifiedTime,webContentLink,thumbnailLink),nextPageToken";
    
  [self.driveService executeQuery:query
                  completionHandler:^(GTLRServiceTicket *ticket,
                                      GTLRDrive_FileList *files,
                                      NSError *error)
    {
                      if (error == nil)
                      
                      {

                          [self.driveFiles removeAllObjects];
                          
                          [self.driveFiles addObjectsFromArray:files.files];
                          
                          NSLog(@"The drive files are %@",self.driveFiles);
                          [self.gDriveTableView reloadData];

                       }
        
                      else
                      {
                          [self showErrorAlert:error.localizedDescription];
                      }
     
        [hud hideAnimated:YES];
    }
  ];
}

- (void)showErrorAlert:(NSString*)error
{
    NSString *errorMsg=error;
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:errorMsg
        message:[NSString stringWithFormat:@"%@", error]
        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    
    [errorAlert addAction:ok];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:errorAlert animated:YES completion:nil];
    });
}

- (IBAction)signOut:(id)sender
{
    [[GIDSignIn sharedInstance] signOut];
    self.driveService.authorizer = nil;
    [self.driveFiles removeAllObjects];
    [self.gDriveTableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];

}

@end
