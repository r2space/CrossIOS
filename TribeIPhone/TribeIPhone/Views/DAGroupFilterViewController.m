//
//  DAGroupFilterViewController.m
//  TribeIPhone
//
//  Created by kita on 13-6-17.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAGroupFilterViewController.h"
#import "DAHelper.h"

@interface DAGroupFilterViewController ()
{
    NSArray *_list;
    NSArray *_typeList;
}
@end

@implementation DAGroupFilterViewController

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
    _list = @[[DAHelper localizedStringWithKey:@"group.type.group" comment:@"组"], [DAHelper localizedStringWithKey:@"group.type.department" comment:@"部门"]];
    _typeList = @[@"1", @"2"];
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
