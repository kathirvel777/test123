//
//  GetAlbumViewController.m
//  Montage
//
//  Created by MacBookPro on 4/13/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "GetAlbumViewController.h"
#import "GetImageCollectionCell.h"

@interface GetAlbumViewController ()
{
    NSMutableArray *imageName,*sendImage;
    NSString *user_id;
    NSMutableURLRequest *request;
    
    NSString *imgName;
    
    NSIndexPath *selectedValue;
    
}

@end

@implementation GetAlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return [imageName count];
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    
    GetImageCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //  cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 0.2f;
    
    cell.alpha = 1.0;
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    DocDir = [DocDir stringByAppendingString:@"/MyImages"];
    
    DocDir = [DocDir stringByAppendingPathComponent:[imageName objectAtIndex:indexPath.row]];
    
    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
    
    UIImage *img=[[UIImage alloc] initWithData:pictureData];
    
    cell.ImgView.image = img;
    
    return cell;
}

-(void)edit_btn:(UIButton*)sender
{
    
}


- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.view.frame.size.width / 2.02f;
    return CGSizeMake(picDimension, picDimension);
}


-(void)getName
{
    
    imageName = [[NSMutableArray alloc]init];
    
    NSArray *pathos = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [pathos objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    myPath = [myPath stringByAppendingString:@"/MyImages"];
    
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
    
    NSMutableArray *subpredicates = [NSMutableArray array];
    
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"]];
    
    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
    
    NSMutableArray *getAllImages = [[NSMutableArray alloc]init];
    
    NSArray *onlyImages = [directoryContents filteredArrayUsingPredicate:filter];
    
    for (int i = 0; i < onlyImages.count; i++)
    {
        NSString *imagePath = [myPath stringByAppendingPathComponent:[onlyImages objectAtIndex:i]];
        
        NSString *myPath = [imagePath lastPathComponent];
        
        [imageName addObject:myPath];
        
        NSLog(@"Gievn Image = %@",myPath);
    }
    [self.collectionView reloadData];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!selectedValue)
    {
        
        UICollectionViewCell* cellValue = [collectionView  cellForItemAtIndexPath:selectedValue];
        
        cellValue.alpha = 1.0;
        
        UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
        
        cell.alpha = 0.3;
    }
    else
    {
        selectedValue = indexPath;
        
        UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
        
        cell.alpha = 0.3;
        
    }
    imgName = [imageName objectAtIndex:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
    cell.alpha = 1;
}


@end
