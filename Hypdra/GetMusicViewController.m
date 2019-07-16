//
//  GetMusicViewController.m
//  Montage
//
//  Created by MacBookPro on 4/6/17.
//  Copyright © 2017 sssn. All rights reserved.
//

#import "GetMusicViewController.h"

@interface GetMusicViewController ()
{
    NSArray *montageMusic;
}

@end

@implementation GetMusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    montageMusic = @[@"World", @"Techno",@"sentimental",@"Sad",@"Jazz",@"island",@"Hip Hop",@"Happy_Inspiring",@"Epic",@"Easy listening",@"Country",@"Corporate",@"Classical",@"Classical rock",@"Christmas",@"Blues",@"4th of july",@"Alternative Rock"];

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
    
    cell.imageView.layer.cornerRadius = 30;
    
    cell.imageView.clipsToBounds = YES;
    
    cell.imageView.layer.borderWidth = 2.0f;
    
    cell.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    cell.imageView.image = [UIImage imageNamed:@"1.jpg"];
    
    cell.textLabel.text= [montageMusic objectAtIndex:indexPath.row];
    
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [montageMusic count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
