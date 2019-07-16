//
//  MyMusic.m
//  Montage
//
//  Created by MacBookPro4 on 4/7/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "MyMusic.h"
#import "MyMusicTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface MyMusic ()
{
    NSString *user_id;
    NSMutableArray *MusicName;
    int HigestImageCount;
    NSData *Musicdata;
    NSMutableURLRequest *request;
    
    #define URL @"https://www.hypdra.com/api/api.php?rquest=user_upload_music"
}

@end

@implementation MyMusic

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MusicName=[[NSMutableArray alloc]init];
    UIImage *img=[UIImage imageNamed:@"plus-icon-black-2.png"];
    
    [_btnchooseMusic setImage:img forState:UIControlStateNormal];
    
    [self getmusicfromlocal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    user_id = @"1";//[defaults valueForKey:@"USER_ID"];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return MusicName.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"MyMusicTableViewCell";
    
    MyMusicTableViewCell *cell = (MyMusicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyMusicTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    NSLog(@"Index = %ld",(long)indexPath.row);
    
    //  cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 0.2f;
    
    NSArray *ScreensDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocDir = [ScreensDir objectAtIndex:0];
    
    
    UIImage *img=[UIImage imageNamed:@"music_img"];
    NSDictionary *dic = [MusicName objectAtIndex:indexPath.row];
    NSString *StringId = [dic valueForKey:@"MusicId"];
    NSString *Title = [dic valueForKey:@"MusicTitle"];
    
    
    NSLog(@"Music Title song:%@",Title);
    cell.music_img.image=img;
    cell.Music_title.text=Title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [MusicName objectAtIndex:indexPath.row];
    NSString *musicId = [dic valueForKey:@"MusicId"];
    NSString *musicTitle = [dic valueForKey:@"MusicTitle"];
    NSLog(@"DIdSelected %@,%@", musicId,musicTitle);
    
}


//- (NSIndexPath *)collectionView:(UICollectionView *)collectionView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return indexPath;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat picDimension = self.view.frame.size.width / 1.0f;
//
//    CGFloat picHimension = self.view.frame.size.width / 2.0f;
//
//    return CGSizeMake(picDimension, picHimension);
//}

-(void)getMusicFromGallery
{
    
    MPMediaPickerController *picker =
    [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
    
    picker.delegate = self;
    picker.allowsPickingMultipleItems   = NO;
    picker.prompt                       = NSLocalizedString (@"Select any song from the list", @"Prompt to user to choose some songs to play");
    
    // [self presentModalViewController: picker animated: YES];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    __block NSData *assetData = nil;
    
    //    MPMediaItem *theChosenSong = [[mediaItemCollection items]objectAtIndex:0];
    //    NSString *songTitle = [theChosenSong valueForProperty:MPMediaItemPropertyTitle];
    //    NSURL *assetURL = [theChosenSong valueForProperty:MPMediaItemPropertyAssetURL];
    //    AVURLAsset  *songAsset  = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    //    NSLog(@"asset url:%@",assetURL);
    
    MPMediaItem *theChosenSong = [[mediaItemCollection items]objectAtIndex:0];
    NSString *songTitle = [theChosenSong valueForProperty:MPMediaItemPropertyTitle];
    NSString *f=[theChosenSong valueForKey:MPMediaItemPropertyArtwork];
    
    NSURL *url = [theChosenSong valueForProperty: MPMediaItemPropertyAssetURL];
    NSLog(@"Song Title:%@",songTitle);
    NSLog(@"Song art:%@",f);
    
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL: url options:nil];
    NSData *d1=[NSData dataWithContentsOfURL:url];
    NSLog(@"d1:%@",d1);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset: songAsset presetName:AVAssetExportPresetAppleM4A];
    
    NSLog(@"Exporter:%@",exporter);
    
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPathlist = [pathfinalPlist objectAtIndex:0];
    // NSString *documentsPathlist = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",@"MyMusic"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&error];
    NSString *SharedFinalplistPath = [documentsPathlist stringByAppendingPathComponent:@"MyMusic.plist"];
    
    MusicName = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    if (MusicName == nil)
    {
        MusicName = [[NSMutableArray alloc]init];
    }
    
    NSLog(@"MusicPlistPath:%@",SharedFinalplistPath);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    HigestImageCount++;
    [dic setValue:songTitle forKey:@"MusicTitle"];
    
    [dic setValue:[NSString stringWithFormat:@"%d",HigestImageCount] forKey:@"MusicId"];
    [MusicName addObject:dic];
    [MusicName writeToFile:SharedFinalplistPath atomically:YES];
    [self.tableview reloadData];
    
    
    [self FileName:(NSString *)songTitle Data:(NSData *)d1];
    
    
}
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    //[self dismissModalViewControllerAnimated: YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)getmusicfromlocal
{
    HigestImageCount=0;
    MusicName = [[NSMutableArray alloc]init];
    NSError *error;
    NSArray *pathfinalPlist = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsPathlist = [pathfinalPlist objectAtIndex:0];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPathlist])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPathlist withIntermediateDirectories:NO attributes:nil error:&error];
    NSString *SharedFinalplistPath = [documentsPathlist stringByAppendingPathComponent:@"MyMusic.plist"];
    
    //    if (MusicName == nil)
    //    {
    MusicName = [NSMutableArray arrayWithContentsOfFile:SharedFinalplistPath];
    //  }
    for( NSDictionary *dic in MusicName){
        NSString *StringId = [dic valueForKey:@"MusicId"];
        int id = StringId.intValue;
        if(id>HigestImageCount)
            HigestImageCount=id;
    }
    
    NSLog(@"GetMusicFromLocal_PlistPath:%@",MusicName);
    [self.tableview reloadData];
}

- (IBAction)chooseMusic:(id)sender
{
    [self getMusicFromGallery];
}

-(void)FileName:(NSString *)fileName Data:(NSData *)Musicdata1
{
    NSLog(@"File name in server:%@",fileName);
    NSLog(@"Music Data:%@",Musicdata1);
    
    if([self setImageParams:Musicdata1 Filename:fileName])
    {
        
        NSLog(@"Enter block");
        
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:queue
                               completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error)
         {
             
             NSLog(@"Response = %@",urlResponse);
         }];
        
        NSLog(@"Image Sent");
    }
    
}

-(BOOL)setImageParams:(NSData *)imgData Filename:(NSString *)fileName
{
    
    @try
    {
        
        //        UIImage *img = [UIImage imageNamed:@"letter-c-icon-png-4.png"];
        //
        //        imgData = UIImageJPEGRepresentation(img, 1.0);
        
        
        if (imgData!=nil)
        {
            
            request = [NSMutableURLRequest new];
            request.timeoutInterval = 20.0;
            [request setURL:[NSURL URLWithString:URL]];
            [request setHTTPMethod:@"POST"];
            //[request setCachePolicy:NSURLCacheStorageNotAllowed];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
            
            
            [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
            
            NSMutableData *body = [NSMutableData data];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload_files\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //           NSLog(@"Image send to  server = %@",imgData);
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"Rand_ID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"User_ID\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lang\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"iOS" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"After Values");
            [request setHTTPBody:body];
            NSLog(@"From Body");
            [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
            NSLog(@"After Content length");
            
            return TRUE;
            
        }
        else
        {
            return FALSE;
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Send Image Exception = %@",exception);
    }
    @finally
    {
        NSLog(@"Send Image Finally...");
    }
}
@end
