//
//  DAFileFilterViewController.m
//  TribeIPhone
//
//  Created by kita on 13-6-13.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAFileFilterViewController.h"
#import "DAHelper.h"

@interface DAFileFilterViewController ()
{
    NSArray *_list;
    NSArray *_typeList;
}
@end

@implementation DAFileFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _list = @[[DAHelper localizedStringWithKey:@"file.type.image" comment:@"图片"], [DAHelper localizedStringWithKey:@"file.type.video" comment:@"视频"], [DAHelper localizedStringWithKey:@"file.type.audio" comment:@"音频"], [DAHelper localizedStringWithKey:@"file.type.application" comment:@"其它"]];
    _typeList = @[@"image", @"video", @"audio", @"application"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
    }
    cell.detailTextLabel.text = [_list objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedBlocks != nil) {
        self.selectedBlocks([_typeList objectAtIndex:indexPath.row]);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
@end
