//
//  AdvancedViewController.m
//  Montage
//
//  Created by MacBookPro on 4/4/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "AdvancedViewController.h"
#import "AdvancedCollectionViewCell.h"
#import "WYPopoverController.h"
#import "GetTransitionViewController.h"
#import "GetTransitionCollectionCell.h"
#import "GetEffectsViewController.h"
#import "GetEffectsCollectionCell.h"
#import "GetMusicViewController.h"
#import "SetContentViewController.h"
#import "AFNetworking.h"
#import "SetMusicViewController.h"
#import "AllVideosViewController.h"


@interface AdvancedViewController ()<WYPopoverControllerDelegate>
{
    BOOL isPhoto,isTransitions,isEffects,isText,isMusic,isAlbum;
    
    GetImageViewController *secondChildVC;
    
    GetTransitionViewController *thirdChildVC;
    
    GetEffectsViewController *fourthChildVC;
    
    GetTextViewController *fifthChildVC;
    
    GetMusicViewController *sixthChildVC;
    
    SetContentViewController *seventhChildVC;
    
    SetMusicViewController *eightChildVC;
    
    WYPopoverController *popoverController;
    
    NSMutableArray *setImage;
    
    NSMutableArray *EffectsArray,*EffectsImageArray,*setTitle,*setTitleImage,*isTitle,*setMusic,*setMusicType;

    int GlobalIndex;
    
    NSString *user_id;
    
    UIView *makeTransparentView;
    
    NSMutableArray *mtArray;
    
    NSMutableDictionary *saveDict;
}

@end

@implementation AdvancedViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    user_id = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    
    isPhoto = true;
    
    isEffects = isText = isMusic = isAlbum = isTransitions = false;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setMinimumInteritemSpacing:2.0f];
    
    [flowLayout setMinimumLineSpacing:2.0f];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GetImageRemove:)
                                                 name:@"GetImageRemove"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GetEffectsRemove:)
                                                 name:@"GetEffectsRemove"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTitleText:)
                                                 name:@"setTitleText"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ContentClose:)
                                                 name:@"ContentClose"
                                               object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GetMusicRemove:)
                                                 name:@"GetMusicRemove"
                                               object:nil];


    setImage = [[NSMutableArray alloc]init];

    EffectsArray = [[NSMutableArray alloc]init];

    EffectsImageArray = [[NSMutableArray alloc]init];

    setTitle = [[NSMutableArray alloc]init];

    setTitleImage = [[NSMutableArray alloc]init];

    isTitle = [[NSMutableArray alloc]init];

    setMusic = [[NSMutableArray alloc]init];
    
    setMusicType = [[NSMutableArray alloc]init];
    
    
    saveDict = [[NSMutableDictionary alloc]init];
    
    for (int i=0; i<4; i++)
    {
        if (i % 2 == 0)
        {
            //            setImage [i] = @"sample2.jpg";

            [setImage addObject:@"0"];
            [EffectsArray addObject:@"true"];
            [EffectsImageArray addObject:@"0"];
            [setTitle addObject:@"0"];
            [setTitleImage addObject:@"0"];
            [isTitle addObject:@"true"];
            [setMusic addObject:@"0"];
            [setMusicType addObject:@"0"];
        }
        else
        {
            [setImage addObject:@"0"];
            [EffectsArray addObject:@"true"];
            [EffectsImageArray addObject:@"0"];
            [setTitle addObject:@"0"];
            [setTitleImage addObject:@"0"];
            [isTitle addObject:@"true"];
            [setMusic addObject:@"0"];
            [setMusicType addObject:@"0"];

            //            setImage [i] = @"drag-transition.png";
        }
    }
    
}

-(void) ContentClose:(NSNotification *)notification
{
    [seventhChildVC.view removeFromSuperview];
    
    makeTransparentView.alpha = 1.0f;
    
    
    [makeTransparentView removeFromSuperview];
}

-(void) GetMusicRemove:(NSNotification *)notification
{
    
    [popoverController dismissPopoverAnimated:YES];
    
    setMusic[GlobalIndex] = notification.object;
    
    setMusicType[GlobalIndex] = @"user";
    
    [self.collectionView reloadData];
    
    self.view.alpha = 1.0f;
}

- (void) GetImageRemove:(NSNotification *) notification
{
    
    [popoverController dismissPopoverAnimated:YES];
    
    setImage[GlobalIndex] = notification.object;
    
    [self.collectionView reloadData];
    
    self.view.alpha = 1.0f;
}

- (void) GetEffectsRemove:(NSNotification *) notification
{
    [popoverController dismissPopoverAnimated:YES];
    
    
    NSLog(@"Effects Object = %@",notification.object);
    
    EffectsImageArray[GlobalIndex] = notification.object;
    
    EffectsArray[GlobalIndex] = @"false";
    
    [self.collectionView reloadData];
    
    self.view.alpha = 1.0f;
    
}

- (void) setTitleText:(NSNotification *) notification
{
    NSDictionary *dict = notification.object;
    
    [popoverController dismissPopoverAnimated:YES];
    
    
    NSLog(@"Text Object = %@",notification.object);
    
    setTitleImage[GlobalIndex] = [dict objectForKey:@"titleImage"];
    
    setTitle[GlobalIndex] = [dict objectForKey:@"titleName"];
    
    isTitle[GlobalIndex] = @"false";
    
    [self.collectionView reloadData];
    
    self.view.alpha = 1.0f;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [setImage count];
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    AdvancedCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //  cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 0.2f;
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    
    BOOL boolValue = [[EffectsArray objectAtIndex:indexPath.row] boolValue];

    BOOL boolFlagValue = [[isTitle objectAtIndex:indexPath.row] boolValue];

    
    if (isPhoto)
    {
        
        if (indexPath.row % 2 == 0)
        {
         
            DocDir = [DocDir stringByAppendingString:@"/MyImages"];
            
            
            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
            
            
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];
            
            
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            cell.ImgView.image = img;
            
            cell.AddView.hidden = false;
            
            cell.ImgView.contentMode = UIViewContentModeScaleAspectFill;
            
            cell.tempImgView.image = [UIImage imageNamed:@"sample2.jpg"];
            
            cell.EffectImage.hidden = boolValue;

            cell.TitleImage.hidden = boolFlagValue;

        }
        else
        {
            
            DocDir = [DocDir stringByAppendingString:@"/Transitions"];

            
            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
            
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];
            
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            cell.ImgView.image = img;
            
            cell.ImgView.contentMode = UIViewContentModeCenter;
            
            cell.AddView.hidden = true;
            
            cell.tempImgView.image = [UIImage imageNamed:@"drag-transition.png"];
            
            cell.EffectImage.hidden = boolValue;
            
            cell.TitleImage.hidden = boolFlagValue;

        }
    }
    else if (isTransitions)
    {
        if (indexPath.row % 2 == 0)
        {
            DocDir = [DocDir stringByAppendingString:@"/MyImages"];
            
            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
        
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];

            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            cell.ImgView.image = img;
            
            cell.AddView.hidden = true;
            
            cell.ImgView.contentMode = UIViewContentModeScaleAspectFill;
            
            cell.tempImgView.image = [UIImage imageNamed:@"sample2.jpg"];
            
            cell.EffectImage.hidden = boolValue;
            
            cell.TitleImage.hidden = boolFlagValue;

        }
        else
        {
            
            DocDir = [DocDir stringByAppendingString:@"/Transitions"];
            
            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
            
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            cell.ImgView.image = img;
            
            cell.ImgView.contentMode = UIViewContentModeCenter;
            
            cell.AddView.hidden = false;
            
            cell.tempImgView.image = [UIImage imageNamed:@"drag-transition.png"];
            
            cell.EffectImage.hidden = boolValue;
            
            cell.TitleImage.hidden = boolFlagValue;

        }
        
    }
    else if (isEffects)
    {
        if (indexPath.row % 2 == 0)
        {
            DocDir = [DocDir stringByAppendingString:@"/MyImages"];

            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
            
            
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            cell.ImgView.image = img;
            
            cell.AddView.hidden = false;
            
            cell.ImgView.contentMode = UIViewContentModeScaleAspectFill;
            
            cell.tempImgView.image = [UIImage imageNamed:@"sample2.jpg"];
            
            cell.EffectImage.hidden = boolValue;
            
            cell.TitleImage.hidden = boolFlagValue;

        }
        else
        {
            
            DocDir = [DocDir stringByAppendingString:@"/Transitions"];
            
            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
            
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            
            cell.ImgView.image = img;
            
            cell.ImgView.contentMode = UIViewContentModeCenter;
            
            cell.AddView.hidden = true;
            
            
            cell.tempImgView.image = [UIImage imageNamed:@"drag-transition.png"];
            
            cell.EffectImage.hidden = boolValue;
            
            cell.TitleImage.hidden = boolFlagValue;
            
        }
    }
    else if (isText)
    {
        if (indexPath.row % 2 == 0)
        {
            DocDir = [DocDir stringByAppendingString:@"/MyImages"];

            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
            
            
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            cell.ImgView.image = img;
            
            cell.AddView.hidden = false;
            
            cell.ImgView.contentMode = UIViewContentModeScaleAspectFill;
            
            cell.tempImgView.image = [UIImage imageNamed:@"sample2.jpg"];
            
            cell.EffectImage.hidden = boolValue;
            
            cell.TitleImage.hidden = boolFlagValue;

        }
        else
        {
            
            DocDir = [DocDir stringByAppendingString:@"/Transitions"];
            
            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
            
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            cell.ImgView.image = img;
            
            cell.ImgView.contentMode = UIViewContentModeCenter;
            
            cell.AddView.hidden = true;
                        
            cell.tempImgView.image = [UIImage imageNamed:@"drag-transition.png"];
            
            cell.EffectImage.hidden = boolValue;
            
            cell.TitleImage.hidden = boolFlagValue;

        }
    }
    else if (isMusic)
    {
        if (indexPath.row % 2 == 0)
        {
            DocDir = [DocDir stringByAppendingString:@"/MyImages"];
            
            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
            
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            cell.ImgView.image = img;
            
            cell.AddView.hidden = false;
            
            cell.ImgView.contentMode = UIViewContentModeScaleAspectFill;
            
            cell.tempImgView.image = [UIImage imageNamed:@"sample2.jpg"];
            
            cell.EffectImage.hidden = boolValue;
            
            cell.TitleImage.hidden = boolFlagValue;
            
        }
        else
        {
            
            DocDir = [DocDir stringByAppendingString:@"/Transitions"];
            
            NSString *tempFileName = [setImage objectAtIndex:indexPath.row];
            
            tempFileName = [tempFileName stringByAppendingString:@".png"];
            
            DocDir = [DocDir stringByAppendingPathComponent:tempFileName];
            
            NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
            
            UIImage *img=[[UIImage alloc] initWithData:pictureData];
            
            cell.ImgView.image = img;
            
            cell.ImgView.contentMode = UIViewContentModeCenter;
            
            cell.AddView.hidden = true;
            
            cell.tempImgView.image = [UIImage imageNamed:@"drag-transition.png"];
            
            cell.EffectImage.hidden = boolValue;
            
            cell.TitleImage.hidden = boolFlagValue;
            
        }
    }
    
    cell.AddView.tag=indexPath.row;
    [cell.AddView addTarget:self action:@selector(edit_btn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


-(void)edit_btn:(UIButton*)sender
{
    
    if (isPhoto)
    {
        
        NSLog(@"Photos");
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        secondChildVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GetImage"];
        
        
        self.view.alpha = 0.5f;
        
        
        popoverController = [[WYPopoverController alloc ]initWithContentViewController:secondChildVC];
        
        
        popoverController.delegate = self;
        
        
        NSIndexPath *path=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        GlobalIndex = (int)path.row;
        
        NSLog(@"Path = %ld",(long)path.row);
        
        
        AdvancedCollectionViewCell *cells = [self.collectionView cellForItemAtIndexPath:path];
        
        
        popoverController.popoverContentSize = CGSizeMake(250, 350);
        
        [popoverController presentPopoverFromRect:cells.AddView.frame
                                           inView:cells.contentView
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES
                                          options:WYPopoverAnimationOptionFadeWithScale];
        
    }
    else if (isTransitions)
    {
        
        NSLog(@"Transitions");
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        thirdChildVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GetTran"];
        
        self.view.alpha = 0.5f;
        
        popoverController = [[WYPopoverController alloc ]initWithContentViewController:thirdChildVC];
        
        popoverController.delegate = self;
        
        NSIndexPath *path=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        GlobalIndex = (int)path.row;
        
        NSLog(@"Path = %ld",(long)path.row);
        
        AdvancedCollectionViewCell *cells = [self.collectionView cellForItemAtIndexPath:path];
        
        popoverController.popoverContentSize = CGSizeMake(250, 350);
        
        [popoverController presentPopoverFromRect:cells.AddView.frame
                                           inView:cells.contentView
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES
                                          options:WYPopoverAnimationOptionFadeWithScale];
        
    }
    else if (isEffects)
    {
        NSLog(@"Effects");
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        fourthChildVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GetEffects"];
        
        self.view.alpha = 0.5f;
        
        popoverController = [[WYPopoverController alloc ]initWithContentViewController:fourthChildVC];
        
        popoverController.delegate = self;
        
        NSIndexPath *path=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        GlobalIndex = (int)path.row;
        
        NSLog(@"Path = %ld",(long)path.row);
        
        AdvancedCollectionViewCell *cells = [self.collectionView cellForItemAtIndexPath:path];
        
        popoverController.popoverContentSize = CGSizeMake(250, 350);
        
        [popoverController presentPopoverFromRect:cells.AddView.frame
                                           inView:cells.contentView
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES
                                          options:WYPopoverAnimationOptionFadeWithScale];
    }
    else if (isText)
    {
        NSLog(@"Text");
    
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        fifthChildVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"GetText"];
        
        UINavigationController *navbar = [[UINavigationController alloc]  initWithRootViewController:fifthChildVC];
        
        self.view.alpha = 0.5f;
        
        popoverController = [[WYPopoverController alloc ]initWithContentViewController:navbar];
        
        popoverController.delegate = self;
        
        NSIndexPath *path=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        GlobalIndex = (int)path.row;
        
        NSLog(@"Path = %ld",(long)path.row);
        
        AdvancedCollectionViewCell *cells = [self.collectionView cellForItemAtIndexPath:path];
        
        popoverController.popoverContentSize = CGSizeMake(250, 350);
        
        [popoverController presentPopoverFromRect:cells.AddView.frame
                                           inView:cells.contentView
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES
                                          options:WYPopoverAnimationOptionFadeWithScale];
    }
    else if (isMusic)
    {
        NSLog(@"Text");
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        eightChildVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SetMusic"];
        
        UINavigationController *navbar = [[UINavigationController alloc]  initWithRootViewController:eightChildVC];
        
        self.view.alpha = 0.5f;
        
        popoverController = [[WYPopoverController alloc ]initWithContentViewController:navbar];
        
        popoverController.delegate = self;
        
        NSIndexPath *path=[NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        GlobalIndex = (int)path.row;
        
        NSLog(@"Path = %ld",(long)path.row);
        
        AdvancedCollectionViewCell *cells = [self.collectionView cellForItemAtIndexPath:path];
        
        popoverController.popoverContentSize = CGSizeMake(250, 350);
        
        [popoverController presentPopoverFromRect:cells.AddView.frame
                                           inView:cells.contentView
                         permittedArrowDirections:UIPopoverArrowDirectionAny
                                         animated:YES
                                          options:WYPopoverAnimationOptionFadeWithScale];
    }
    
    
}


- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.CollectView.frame.size.width / 2.02f;
    return CGSizeMake(picDimension, picDimension);
}


- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController;
{
    self.view.alpha = 1.0f;
}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    CGFloat leftRightInset = self.CollectView.frame.size.width / 25.0f;
//    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
//
//}

- (IBAction)photos:(id)sender
{
    isPhoto = true;
    
    isEffects = isText = isMusic = isAlbum = isTransitions = false;
    
    [self.collectionView reloadData];
}

- (IBAction)transitions:(id)sender
{
    isTransitions = true;
    
    isEffects = isText = isMusic = isAlbum = isPhoto = false;
    
    [self.collectionView reloadData];
}

- (IBAction)effects:(id)sender
{
    isEffects = true;
    
    isTransitions = isText = isMusic = isAlbum = isPhoto = false;
    
    [self.collectionView reloadData];
}

- (IBAction)text:(id)sender
{
    isText = true;
    
    isTransitions = isEffects = isMusic = isAlbum = isPhoto = false;
    
    [self.collectionView reloadData];
    
}

- (IBAction)music:(id)sender
{
    
    isMusic = true;
    
    isTransitions = isEffects = isText = isAlbum = isPhoto = false;
    
    [self.collectionView reloadData];

    
/*
    // Container View
 
    makeTransparentView = [[UIView alloc]initWithFrame:self.mainView.frame];
    
    makeTransparentView.backgroundColor = [UIColor darkGrayColor];
    
    
    [self.mainView addSubview:makeTransparentView];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    seventhChildVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SetContent"];
    
    
    [seventhChildVC.view setBackgroundColor:[UIColor whiteColor]];
    [self addChildViewController:seventhChildVC];
    
    [seventhChildVC didMoveToParentViewController:self];
    
    seventhChildVC.view.frame = CGRectMake(self.view.frame.size.width/2, (self.view.frame.size.height/2), (self.view.frame.size.width)*70/100, (self.view.frame.size.height)*70/100);
    
    seventhChildVC.view.center=self.view.center;
    
    [self.view addSubview:seventhChildVC.view];
    
    makeTransparentView.alpha = 0.5f; */
    
}

- (IBAction)album:(id)sender
{
    //    isAlbum = true;
    //
    //    isTransitions = isEffects = isText = isMusic = isPhoto = false;
    //
    //    [self.collectionView reloadData];
    
    NSLog(@"Final Image = %@",setImage);
    
    NSLog(@"Final Effects = %@",EffectsImageArray);

    NSLog(@"Final Title = %@",setTitleImage);
    
    mtArray = [[NSMutableArray alloc]init];
    
//    int tempValue = 0;
    
    for (int i = 0; i < setImage.count; i++)
    {
        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
        
        NSString *strFromInt = [NSString stringWithFormat:@"%d",i];

        if (i%2 == 0)
        {
            [mutableDict setObject:[setImage objectAtIndex:i] forKey:@"image_path"];
            [mutableDict setObject:strFromInt forKey:@"image_pos"];
            [mutableDict setObject:[EffectsImageArray objectAtIndex:i] forKey:@"effect"];
            [mutableDict setObject:[setTitleImage objectAtIndex:i] forKey:@"text_img"];
            [mutableDict setObject:[setTitle objectAtIndex:i] forKey:@"text"];
            [mutableDict setObject:[setMusic objectAtIndex:i] forKey:@"music"];
            [mutableDict setObject:[setMusicType objectAtIndex:i] forKey:@"music_type"];
            
            [mutableDict setObject:[setImage objectAtIndex:(i+1)] forKey:@"transition"];
            [mutableDict setObject:strFromInt forKey:@"image_pos"];

            [mtArray addObject:mutableDict];

        }
        else
        {
            
//            tempValue++;
        }

    }
    
    NSDictionary *fDict = @{@"FinalTemplates":mtArray};
    
    NSLog(@"mtArray = %@",mtArray);
    
    [self sendFinalArray:fDict];
}


-(void)sendFinalArray:(NSDictionary*)fArray
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"parse-application-id-removed" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [manager.requestSerializer setValue:@"parse-rest-api-key-removed" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    
    NSString *jsonString;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fArray
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
    }
    
    NSLog(@"JsonString = %@",jsonString);
    
    NSDictionary *params = @{@"Dictionary":jsonString,@"lang":@"ios",@"User_ID":user_id,@"video_id":@"1"};
    
    [manager POST:@"https://www.hypdra.com/api/api.php?rquest=advance_final_details" parameters:params success:^(NSURLSessionTask *operation, id responseObject)
     {
         NSLog(@"Response = %@",responseObject);
         
/*         NSString *videoID = [responseObject objectForKey:@"Rand_id"];
         
         saveDict = [[NSMutableDictionary alloc]init];
         
         saveDict = [fArray mutableCopy];
         [saveDict setObject:videoID forKey:@"video"];
         
         NSMutableDictionary *subDic=[[NSMutableDictionary alloc]init];
         
         [subDic setValue:saveDict forKey:@"File"];

         
         [self testSave:subDic]; */
         
/*         NSError *jsonError;
         NSData *objectData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&jsonError];
         
         
         NSLog(@"After JSON = %@",json); */
         
         
     }
     failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];
}

-(void)testSave:(NSDictionary*)fArray
{
    
    
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathfinalPlist objectAtIndex:0];
    NSString *documentsPathlist = [documentsDirectory stringByAppendingPathComponent:@"/File"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&error];
    
    NSString *dataPath = [documentsPathlist stringByAppendingFormat:@"/DocFinal.plist"];
    
    NSLog(@"FilePath:%@",dataPath);
    
    NSMutableArray *finalArray = [NSMutableArray arrayWithContentsOfFile:dataPath];
    
    if (finalArray == nil)
    {
        finalArray = [NSMutableArray array];
    }
    NSLog(@"BEFORE %lu",(unsigned long)finalArray.count);

    int FilePosition=[[NSUserDefaults standardUserDefaults]integerForKey:@"FilePosition"];
    NSLog(@"FilePosition  = %d",FilePosition);
    
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"existingDoc"])
    {
        NSLog(@"New Array = %@",fArray);
        [finalArray addObject:fArray];
    }
    else
    {
        NSLog(@"Old Array");
        NSLog(@"MiniArrayPosition %d",FilePosition);
        [finalArray replaceObjectAtIndex:FilePosition withObject:fArray];
        
    }
    
    NSLog(@"AFTER%lu",(unsigned long)finalArray.count);
    [finalArray writeToFile:dataPath atomically:YES];
    
    NSLog(@"Before Calledd..");
}



- (IBAction)AddCell:(id)sender
{
    int count = (int)[setImage count];
    
    for (int i = count; i < count + 4; i++)
    {
        NSLog(@"Begin Added = %d",i);
        
        if (i % 2 == 0)
        {
            //            setImage [i] = @"sample2.jpg";
            [setImage addObject:@"0"];
            [EffectsArray addObject:@"true"];
            [EffectsImageArray addObject:@"0"];
            [setTitle addObject:@"0"];
            [setTitleImage addObject:@"0"];
            [isTitle addObject:@"true"];
            [setMusic addObject:@"0"];
            [setMusicType addObject:@"0"];

        }
        else
        {
            //            setImage [i] = @"drag-transition.png";
            [setImage addObject:@"0"];
            [EffectsArray addObject:@"true"];
            [EffectsImageArray addObject:@"0"];
            [setTitle addObject:@"0"];
            [setTitleImage addObject:@"0"];
            [isTitle addObject:@"true"];
            [setMusic addObject:@"0"];
            [setMusicType addObject:@"0"];

        }
    }
    
    [self.collectionView reloadData];
    
}

- (IBAction)Album:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AllVideosViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AllVideos"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];

}

@end
