//
//  PhotoViewController.m
//  SampleFlickr
//
//  Created by MacBookPro4 on 4/11/17.
//  Copyright © 2017 seek. All rights reserved.
//

#import "PhotoViewController.h"
#import "SelectSourceViewController.h"
#import "FlickrKit.h"
#import "FlickrCollectionCell.h"
#import "DEMORootViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import <ImageIO/ImageIO.h>


@interface PhotoViewController ()
{
    
    NSMutableArray *thumbImg,*imageName;
    
    NSString *imagePath;
    
    MBProgressHUD *hud;
    
    NSIndexPath *selectedValue,*imgValue;
    
    NSMutableArray *sendImage,*finalArray,*OnlyImages,*fullImage,*thumbImage;
    
    NSString *user_id;
    NSMutableURLRequest *request;
    int HigestImageCount,lastHighestCount;
    
    NSString *imgName,*imageID;
    
    #define URL @"https://www.hypdra.com/api/api.php?rquest=image_upload"
    
}

@property (nonatomic, retain) NSArray *photoURLs;
@end

@implementation PhotoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View Didload Flickr");
    
    fullImage = [[NSMutableArray alloc]init];
    thumbImage = [[NSMutableArray alloc]init];

    [self.collectionView registerNib:[UINib nibWithNibName:@"FlickrCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MyCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setMinimumInteritemSpacing:2.0f];
    
    [flowLayout setMinimumLineSpacing:30.0f];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    thumbImg = [[NSMutableArray alloc]init];
    
    imageName = [[NSMutableArray alloc]init];
    
    imagePath = nil;
    
 //   [self getName];
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];

}

- (id) initWithURLArray:(NSArray *)urlArray
{
    NSLog(@"initwithURL");
    self = [super init];
    if (self)
    {
        self.photoURLs = urlArray;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    user_id = [defaults valueForKey:@"USER_ID"];
    
    NSLog(@"User ID = %@",user_id);
    
    imagePath = nil;
    
    
    thumbImg = [[NSMutableArray alloc]init];
    
    NSLog(@"view will appear photo");
    NSLog(@"Photo Count:%lu",(unsigned long)_photoURLs.count);
    
    for (NSURL *url in self.photoURLs)
    {
        NSLog(@"URL = %@",url);
        
        [thumbImg addObject:url];
        
    }
}



- (void) addImageToView:(UIImage *)image
{
    
    NSLog(@"add image to view photo");
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    CGFloat width = CGRectGetWidth(self.imageScrollview.frame);
    CGFloat imageRatio = image.size.width / image.size.height;
    CGFloat height = width / imageRatio;
    CGFloat x = 0;
    CGFloat y = self.imageScrollview.contentSize.height;
    
    imageView.frame = CGRectMake(x, y, width, height);
    
    CGFloat newHeight = self.imageScrollview.contentSize.height + height;
    self.imageScrollview.contentSize = CGSizeMake(320, newHeight);
    
    [self.imageScrollview addSubview:imageView];
    
}


- (IBAction)LogOut:(id)sender
{
    [[FlickrKit sharedFlickrKit] logout];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_2" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [thumbImg count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    //    static NSString *CellIdentifier = @"Cell";
    
    
    NSLog(@"Image Count = %lu",(unsigned long)[thumbImg count]);
    
    
    FlickrCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    
    cell.layer.borderWidth = 0.2f;
    
    cell.alpha = 1.0;
    
    NSURL *imageURL = [thumbImg objectAtIndex:indexPath.row];
/*    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    cell.imageView.image = image;*/
    
    
    [cell.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Placeholder_no_text.png"]];

    return cell;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width / 3.4f;
    return CGSizeMake(picDimension, picDimension);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    imagePath = nil;
    
    imgValue = nil;
    
    if (!selectedValue)
    {
        NSLog(@"!Selected");
        
        //        UICollectionViewCell* cellValue = [collectionView  cellForItemAtIndexPath:selectedValue];
        //
        //        cellValue.alpha = 1.0;
        
        FlickrCollectionCell* cell = (FlickrCollectionCell*)[collectionView  cellForItemAtIndexPath:indexPath];
        
        cell.selectedImage.hidden = false;
        
        //        cell.alpha = 0.3;
    }
    else
    {
        NSLog(@"Selected");
        
        selectedValue = indexPath;
        
        FlickrCollectionCell* cell = (FlickrCollectionCell*)[collectionView  cellForItemAtIndexPath:indexPath];
        
        cell.selectedImage.hidden = false;
        
        //        cell.alpha = 0.3;
    }
    
    imgValue = indexPath;
    
    
    imagePath = [self.photoURLs objectAtIndex:indexPath.row];
    
    NSLog(@"Final Link = %@",imagePath);
    
    NSURL *imageURL = [thumbImg objectAtIndex:imgValue.row];
    
    NSLog(@"After URL = %@",imageURL);
    
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    
    if ([self.delegate respondsToSelector:@selector(didFinishedFlickrImage:)])
        
    {
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           
                           [self.delegate didFinishedFlickrImage:data];
                           
                           [self dismissViewControllerAnimated:YES completion:nil];
                           
                          // [self.navigationController popViewControllerAnimated:YES];
                           
                       });
        
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Deselected..");
    
    FlickrCollectionCell* cell = (FlickrCollectionCell*)[collectionView  cellForItemAtIndexPath:indexPath];
    //    cell.alpha = 1;
    
    cell.selectedImage.hidden = true;
    
}


- (IBAction)done:(id)sender
{
        [[FlickrKit sharedFlickrKit] logout];
        
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SelectSourceViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SelectSource"];
        
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:vc animated:YES completion:NULL];
}



- (IBAction)back:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"MainUpload" bundle:nil];
    
    DEMORootViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"rootController"];
    
    [vc awakeFromNib:@"contentController_2" arg:@"menuController"];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
