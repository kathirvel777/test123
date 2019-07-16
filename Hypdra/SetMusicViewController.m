//
//  SetMusicViewController.m
//  Montage
//
//  Created by MacBookPro on 4/11/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "SetMusicViewController.h"


@interface SetMusicViewController ()
{
    NSMutableArray *imageName,*sendImage;
    NSString *user_id;
    NSMutableURLRequest *request;
    
    NSString *imgName;
    
    NSIndexPath *selectedValue;
    
}

@end

@implementation SetMusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"Enter Music");
    
    imageName = [[NSMutableArray alloc]init];
    
    sendImage = [[NSMutableArray alloc]init];
    
    
    [self getName];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    cell.imageView.layer.cornerRadius = 30;
//    
//    cell.imageView.clipsToBounds = YES;
//    
//    cell.imageView.layer.borderWidth = 2.0f;
//    
//    cell.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    DocDir = [DocDir stringByAppendingString:@"/Music"];
    
    DocDir = [DocDir stringByAppendingPathComponent:[imageName objectAtIndex:indexPath.row]];
    
    //    NSLog(@"My Path = %@",DocDir);
    
    
    
    cell.textLabel.text = [imageName objectAtIndex:indexPath.row];
    
//    
//    NSData* pictureData=[[NSData alloc]initWithContentsOfFile:[NSURL fileURLWithPath:DocDir]];
//    
//    UIImage *img=[[UIImage alloc]initWithContentsOfFile:@"ios_9.jpg"];
    
//    cell.imageView.image = img;
    
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imageName count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"effectName = %@",imgName);
    
    
    imgName = [imageName objectAtIndex:indexPath.row];
  
    
    NSRange endRange = [imgName rangeOfString:@"$" options:NSBackwardsSearch];
    NSRange endRange1 = [imgName rangeOfString:@"$"];
    
    NSString *tempCon1 = [imgName substringFromIndex:(endRange.location+1)];
    NSRange dotrange = [tempCon1 rangeOfString:@"."];
    NSRange dotrange1 = NSMakeRange(0, dotrange.location);
    
    tempCon1=[tempCon1 substringWithRange:dotrange1];
    
    
    NSLog(@"Send Music ID = %@",tempCon1);
    

    
//    NSString *theFileName = [[imgName lastPathComponent] stringByDeletingPathExtension];

    
    if (imgName != NULL )
    {
        NSLog(@"Saved");
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"GetMusicRemove"
         object:tempCon1];
        
    }
    else
    {
        
    }
}



-(void)getName
{
    imageName = [[NSMutableArray alloc]init];
    
    NSArray *pathos = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [pathos objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    myPath = [myPath stringByAppendingString:@"/Music"];
    
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
    
    NSMutableArray *subpredicates = [NSMutableArray array];
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.m4a'"]];
    
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
    
    [self.tableView reloadData];
}


@end
