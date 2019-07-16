//
//  WizardCollectionViewController.m
//  Montage
//
//  Created by MacBookPro4 on 6/5/17.
//  Copyright © 2017 sssn. All rights reserved.


#import "WizardCollectionViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMORootViewController.h"
#import "PageSelectionViewController.h"
#import "WizardImageCollectionViewCell.h"
#import "AddAdvanceCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import <ImageIO/ImageIO.h>
#import "CustomPopUp.h"
#import "singletons.h"
#import "UIColor+Utils.h"


@interface WizardCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout>
{
    NSMutableArray *OnlyImages,*imgArray,*shareArray;
    NSIndexPath *SelectedIndexPath;
    
}
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation WizardCollectionViewController

static NSString * const reuseIdentifier = @"WizardCell";

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    imgArray=[[NSMutableArray alloc]init];
    [self getName];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width/1.5, self.view.frame.size.height/1.5);
    _holdView =[[UIView alloc]initWithFrame:self.view.bounds];
    
    _EmptyImage = [[UIImageView alloc]initWithFrame:rect];
    [_EmptyImage setCenter:_holdView.center];
    
    _EmptyImage.contentMode= UIViewContentModeScaleAspectFit;// UIViewContentModeCenter;
    _EmptyImage.image = [UIImage imageNamed:@"bg-2.png"];
    
    shareArray = [[NSMutableArray alloc]init];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapPosition:)];
    
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    [_holdView addGestureRecognizer:tapGesture1];
    
    [_holdView addSubview:_EmptyImage];
    [self.view addSubview:_holdView];
    
    _wizardCollectionView.contentInset=UIEdgeInsetsMake(15, 15, 15, 15);
    
    [self.wizardCollectionView setAllowsMultipleSelection:YES];
    
    self.backView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    _title_lbl.text = @"Document Empty";
    _title_lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    [_title_lbl setCenter:self.backView.center];
    _title_lbl.textAlignment = NSTextAlignmentCenter;
    _title_lbl.textColor = UIColor.whiteColor;
    [_title_lbl setFont:[UIFont fontWithName:@"Myriad Pro" size:17.0]];
    //    _title_lbl.font = [UIFont systemFontOfSize:12];
    // _title_lbl.backgroundColor = [UIColor blackColor];
    [self.backView addSubview:_title_lbl];
    self.navigationItem.titleView = self.backView;
}


-(void)tapPosition:(UITapGestureRecognizer *)recognizer
{
    
    //    [[NSUserDefaults standardUserDefaults]setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
    //    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_5" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
    
}
-(void)getName
{
    NSLog(@"getname called");
    NSString *arraytag=[NSString stringWithFormat:@"ChoosenImagesandVideos"];
    NSLog(@"Onarraytag:%@",arraytag);
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:arraytag];
    OnlyImages = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    for(int i=0;i<OnlyImages.count;i++)
    {
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
        NSString *imgid= [[OnlyImages objectAtIndex:i]valueForKey:@"Id"];
        
        // NSString *imgpath=[[OnlyImages objectAtIndex:i]valueForKey:@"videoPath"];
        // NSString *finalimgPath = [imgpath stringByReplacingOccurrencesOfString:@"http://108.175.2.116/montage/api/uploads/" withString:@""];
        
        //NSLog(@"imgPath:%@",imgpath);
        [dic setValue:imgid forKey:@"id"];
        //[dic setValue:finalimgPath forKey:@"image_path"];
        
        [imgArray addObject:dic];
    }
    NSLog(@"WIZARD ONLYIMAGES %@",OnlyImages);
    NSLog(@"final dic ImgArray %@",imgArray);
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:imgArray]  forKey:@"WizardImageDic"];
    //[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:imgArray]  forKey:@"WizardImageDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if (OnlyImages.count<5)
    {
        NSLog(@"select BEGIN");
        self.title_lbl.text=@"Select Minimum 5";
        self.btnDone.enabled=false;
        self.btnDone.tintColor = [UIColor clearColor];
        self.holdView.hidden=true;
        
    }
    
    [self.wizardCollectionView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    NSLog(@"Only images count:%lu",(unsigned long)OnlyImages.count);
    if (OnlyImages.count == 0)
    {
        self.title_lbl.text=@"Document Empty";
        self.btnDone.enabled=false;
        self.btnDone.tintColor = [UIColor clearColor];
        // [self. setImage:nil];
        
        //        self.secondView.hidden = true;
        //        self.tabView.hidden = false;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabClicked:)];
        //        [self.tabView addGestureRecognizer:tap];
    }
    else if (OnlyImages.count<5)
    {
        NSLog(@"select BEGIN");
        self.title_lbl.text=@"Select Minimum 5";
        self.btnDone.enabled=false;
        self.btnDone.tintColor = [UIColor clearColor];
        self.holdView.hidden=true;
        
    }
    else
    {
        self.title_lbl.text=@"Add Photos/Videos";
        self.btnDone.enabled=true;
        self.btnDone.tintColor = [UIColor whiteColor];
        
        self.holdView.hidden=true;
        //        self.secondView.hidden = false;
        //        self.tabView.hidden = true;
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
#warning Incomplete implementation, return the number of items
    return OnlyImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WizardImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //SHADOW WITH CORNER RADIUS
    
    cell.contentView.layer.cornerRadius = 12;
    cell.contentView.layer.masksToBounds = YES;
    cell.contentView.layer.borderWidth = 2;
    cell.contentView.layer.borderColor = [[UIColor clearColor]CGColor];
    cell.layer.shadowRadius = 2;
    cell.layer.cornerRadius = 12;
    cell.layer.masksToBounds = NO;
    [[cell layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    
    [[cell layer] setShadowOffset:CGSizeMake(0,2)];
    [[cell layer] setShadowOpacity:1];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:12];
    [[cell layer] setShadowPath:[path CGPath]];
    //SHADOW WITH CORNER RADIUS
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
    NSMutableDictionary *dic = [OnlyImages objectAtIndex:indexPath.row];
    NSLog(@"OnlyImages %@",OnlyImages);
    NSString *imagePath = [dic valueForKey:@"imagePath"];
    NSString *type=[dic valueForKey:@"DataType"];
    
    NSString *lower = [type lowercaseString];
    NSURL *url = [NSURL URLWithString:[dic valueForKey:@"imagePath"]];
    
    [cell.selectedWizardImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"150-image-holder"]];
    
    //    DocDir = [DocDir stringByAppendingPathComponent:[Id stringByAppendingString:@".png"]];
    //    NSLog(@"docdir:%@",DocDir);
    //    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
    
    
    /* CGImageSourceRef BlurImageSource = CGImageSourceCreateWithData((__bridge CFDataRef)pictureData, NULL);
     CFDictionaryRef BlurOptions = (__bridge CFDictionaryRef) @{
     (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
     (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
     (id) kCGImageSourceThumbnailMaxPixelSize : @(25)
     };
     
     // Generate the thumbnail*/
    
    //    CGImageRef Blurthumbnail = CGImageSourceCreateThumbnailAtIndex(BlurImageSource, 0, BlurOptions);
    //    if (NULL != BlurImageSource)
    //        CFRelease(BlurImageSource);
    //
    //    UIImage* scaledBlurImage = [UIImage imageWithCGImage:Blurthumbnail];
    //    cell.BackGroundImageView.image = scaledBlurImage;
    //
    //    UIImage *BackgroundImg=[[UIImage alloc] initWithData:pictureData];
    //    UIImage *watermarkImage = [UIImage imageNamed:@"64-video.png"];
    //
    //    //cell.addvance_ImgView.image = img;
    //    cell.contentView.frame = [cell bounds];
    //
    //    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-border.png"]];
    //    cell.menuButton.tag = indexPath.row;
    //[cell.menuButton addTarget:self action:@selector(menu:) forControlEvents:UIControlEventTouchUpInside];
    // NSLog(@"Background image:%@",BackgroundImg);
    
    if([type isEqualToString:@"Video"])
    {
        /* UIGraphicsBeginImageContext(BackgroundImg.size);
         [BackgroundImg drawInRect:CGRectMake(0, 0, BackgroundImg.size.width, BackgroundImg.size.height)];
         [watermarkImage drawInRect:CGRectMake(BackgroundImg.size.width - watermarkImage.size.width, BackgroundImg.size.height - watermarkImage.size.height, 50, 50)];
         UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
         UIGraphicsEndImageContext();
         cell.selectedWizardImage.image = result;*/
        cell.videoImgView.hidden = NO;
    }
    else
    {
        cell.videoImgView.hidden = YES;
        // cell.selectedWizardImage.image = BackgroundImg;
    }
    
    cell.btnDelete.tag=indexPath.row;
    
    [cell.btnDelete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
    //    {
    //        cell.btnDelete.hidden = false;
    //    }
    //    else
    //    {
    //        cell.btnDelete.hidden = true;
    //    }
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
 return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 
 }
 */

-(void)deleteAction:(UIButton *)sender
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *temArray = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"ChoosenImagesandVideos"]];
    [temArray removeObjectAtIndex:sender.tag];
    NSLog(@"AfterDeleteChoosenImagesandVideos %@",temArray);
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:temArray]  forKey:@"ChoosenImagesandVideos"];
    
    
    [defaults synchronize];
    [self getName];
}

#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"willMoveToIndexPath");
    NSMutableDictionary *dic = OnlyImages[fromIndexPath.item];
    
    [OnlyImages removeObjectAtIndex:fromIndexPath.item];
    [OnlyImages insertObject:dic atIndex:toIndexPath.item];
    
    //    NSMutableDictionary *dic1 = MainArray[fromIndexPath.item];
    //
    //    [MainArray removeObjectAtIndex:fromIndexPath.item];
    //    [MainArray insertObject:dic1 atIndex:toIndexPath.item];
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"canMoveItemAtIndexPath");
    
    //#if LX_LIMITED_MOVEMENT == 1
    //    PlayingCard *playingCard = self.deck[indexPath.item];
    //
    //    switch (playingCard.suit) {
    //        case PlayingCardSuitSpade:
    //        case PlayingCardSuitClub: {
    //            return YES;
    //        } break;
    //        default: {
    //            return NO;
    //        } break;
    //    }
    //#else
    return YES;
    //#endif
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    NSLog(@"canMoveToIndexPath");
    
    //#if LX_LIMITED_MOVEMENT == 1
    //    PlayingCard *fromPlayingCard = self.deck[fromIndexPath.item];
    //    PlayingCard *toPlayingCard = self.deck[toIndexPath.item];
    //
    //    switch (toPlayingCard.suit) {
    //        case PlayingCardSuitSpade:
    //        case PlayingCardSuitClub: {
    //            return fromPlayingCard.rank == toPlayingCard.rank;
    //        } break;
    //        default: {
    //            return NO;
    //        } break;
    //    }
    //#else
    return YES;
    //#endif
}

- (IBAction)menuAction:(id)sender
{
    /*    [self.view endEditing:YES];
     [self.frostedViewController.view endEditing:YES];
     self.frostedViewController.direction = REFrostedViewControllerDirectionRight;
     
     [self.frostedViewController presentMenuViewController];*/
    
}

- (IBAction)plusAction:(id)sender
{
    
    //  [[NSUserDefaults standardUserDefaults]setObject:@"Wizard" forKey:@"isWizardOrAdvance"];
    // [[NSUserDefaults standardUserDefaults]synchronize];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_5" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)backAction:(id)sender
{
    
    if (OnlyImages.count == 0)
    {
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc1 animated:YES completion:nil];
        
    }
    else
    {
        
        //    UIAlertController * alert=[UIAlertController
        //                               alertControllerWithTitle:@"Remove \"Image\"?" message:@"Chosen Image will discarded"preferredStyle:UIAlertControllerStyleAlert];
        //
        //    UIAlertAction* yesButton = [UIAlertAction
        //                                actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
        //                                handler:^(UIAlertAction * action)
        //                                {
        //
        //                                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ChoosenImagesandVideos"];
        //
        //                                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MainArray"];
        //
        //                                    [[NSUserDefaults standardUserDefaults]synchronize];
        //
        //
        //
        //                                    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //
        //                                    PageSelectionViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PageSelection"];
        //
        //                                    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        //
        //                                    [self presentViewController:vc animated:YES completion:NULL];
        //
        //                                }];
        //
        //    UIAlertAction* noButton = [UIAlertAction
        //                               actionWithTitle:@"Cancel"
        //                               style:UIAlertActionStyleDefault
        //                               handler:^(UIAlertAction * action)
        //                               {
        //
        //                               }];
        //
        //    [alert addAction:yesButton];
        //    [alert addAction:noButton];
        //
        //    [self presentViewController:alert animated:YES completion:nil];
        
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Chosen Image will be discarded?" withTitle:@"Remove\nImage" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        
        popUp.okay.hidden = YES;
        popUp.accessibilityHint =@"ConfirmToRemove";
        
        popUp.agreeBtn.backgroundColor = [UIColor navyBlue];
        popUp.cancelBtn.backgroundColor = [UIColor blueBlack];
        [popUp.agreeBtn setTitle:@"Yes" forState:UIControlStateNormal];
        [popUp.cancelBtn setTitle:@"No" forState:UIControlStateNormal];
        popUp.inputTextField.hidden = YES;
        [popUp show];
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"collectionView layout");
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    float cellWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellWidth = screenWidth / 2.5;
    }
    else
    {
        cellWidth = screenWidth / 3.25;
    }
    
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    return size;
}
/*{
 
 NSLog(@"collectionView layout");
 
 //    CGRect screenRect = [[UIScreen mainScreen] bounds];
 //    CGFloat screenWidth = screenRect.size.width;
 //
 //    float cellWidth;
 //
 //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
 //    {
 //        cellWidth = screenWidth / 2.1;
 //    }
 //    else
 //    {
 //        cellWidth = screenWidth / 3.1;
 //    }
 //
 //    CGSize size = CGSizeMake(cellWidth, cellWidth);
 //
 //    return size;
 
 //    NSLog(@"collectionView layout");
 //
 //    CGFloat picDimension;
 //
 //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
 //    {
 //        picDimension = self.view.frame.size.width / 3.0f;
 //
 //    }
 //    else
 //    {
 //        picDimension = self.view.frame.size.width / 2.25f;
 //    }
 //    return CGSizeMake(picDimension, picDimension);
 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
 {
 return CGSizeMake((collectionView.frame.size.width/3)-20, (collectionView.frame.size.width/3)-20);
 }
 else
 {
 return CGSizeMake((collectionView.frame.size.width/2)-20, (collectionView.frame.size.width/2)-20);
 }
 
 
 }*/

/*
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
 {
 return 15.0;
 }*/


- (IBAction)createWizardMovie:(id)sender
{
    if(OnlyImages.count<5)
    {
        //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Select minimum 5 items" preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        //        [alertController addAction:ok];
        //
        //        [self presentViewController:alertController animated:YES completion:nil];
        CustomPopUp *popUp = [CustomPopUp new];
        [popUp initAlertwithParent:self withDelegate:self withMsg:@"Select minimum 5 items" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
        popUp.okay.backgroundColor = [UIColor lightGreen];
        popUp.agreeBtn.hidden = YES;
        popUp.cancelBtn.hidden = YES;
        popUp.inputTextField.hidden = YES;
        [popUp show];
    }
    else
    {
        
        if (OnlyImages.count>10)
        {
            //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Select Maximum 10 items" preferredStyle:UIAlertControllerStyleAlert];
            //
            //            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            //            [alertController addAction:ok];
            //
            //            [self presentViewController:alertController animated:YES completion:nil];
            
            CustomPopUp *popUp = [CustomPopUp new];
            [popUp initAlertwithParent:self withDelegate:self withMsg:@"Select only 10 items" withTitle:@"Sorry" withImage:[UIImage imageNamed:@"Alert_icon.png"]];
            popUp.okay.backgroundColor = [UIColor lightGreen];
            popUp.agreeBtn.hidden = YES;
            popUp.cancelBtn.hidden = YES;
            popUp.inputTextField.hidden = YES;
            [popUp show];
        }
        else
        {
            
            NSLog(@"choose theme and audio");
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainWizard" bundle:nil];
            
            DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
            
            [vc awakeFromNib:@"contentController_7" arg:@"menuController"];
            
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:vc animated:YES completion:NULL];
            
            
            //[self.navigationController pushViewController:vc animated:YES];
            // [self presentViewController:vc animated:YES completion:NULL];
        }
        
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*  NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *DocDir = [ScreensDir objectAtIndex:0];
     
     DocDir = [DocDir stringByAppendingString:@"/MyImagesAndVideos"];
     
     
     NSMutableDictionary *dic = [OnlyImages objectAtIndex:indexPath.row];
     
     NSLog(@"OnlyImages %@",OnlyImages);
     
     NSString *id = [dic valueForKey:@"Id"];
     
     DocDir = [DocDir stringByAppendingPathComponent:[id stringByAppendingString:@".png"]];
     
     NSData* pictureData=[[NSData alloc]initWithContentsOfFile:DocDir];
     
     UIImage *img=[[UIImage alloc] initWithData:pictureData];
     
     
     CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:img delegate:self];
     
     [self presentViewController:editor animated:YES completion:nil];
     
     NSLog(@"After Editing..");*/
    [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"SelectedIndex"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //[igcMenu showCircularMenu];
    
    
    /*    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
     
     if (self.selectedItemIndexPath)
     {
     // if we had a previously selected cell
     
     if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
     {
     // if it's the same as the one we just tapped on, then we're unselecting it
     
     self.selectedItemIndexPath = nil;
     }
     else
     {
     // if it's different, then add that old one to our list of cells to reload, and
     // save the currently selected indexPath
     
     [indexPaths addObject:self.selectedItemIndexPath];
     self.selectedItemIndexPath = indexPath;
     }
     }
     else
     {
     // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
     self.selectedItemIndexPath = indexPath;
     }
     
     // and now only reload only the cells that need updating
     
     [collectionView reloadItemsAtIndexPaths:indexPaths];*/
    
    
    NSDictionary *selectedRecipe = [OnlyImages objectAtIndex:indexPath.row];
    
    [shareArray addObject:selectedRecipe];
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Did Deselect");
    
    NSDictionary *deSelectedRecipe = [OnlyImages objectAtIndex:indexPath.row];
    
    [shareArray removeObject:deSelectedRecipe];
}

-(void) okClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
    }
}

-(void) cancelClicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@""]){
        
    }
}

- (void)agreeCLicked:(CustomPopUp *)alertView{
    if([alertView.accessibilityHint isEqualToString:@"ConfirmToRemove"]){
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ChoosenImagesandVideos"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"MainArray"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DEMORootViewController *vc1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
        
        [vc1 awakeFromNib:@"demo_pageselection" arg:@"menuController"];
        
        vc1.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:vc1 animated:YES completion:nil];
        
    }
}
@end

