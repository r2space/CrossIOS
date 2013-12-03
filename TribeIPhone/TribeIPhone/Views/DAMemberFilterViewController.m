//
//  DAMemberFilterViewController.m
//  TribeIPhone
//
//  Created by Antony on 13-6-14.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMemberFilterViewController.h"
#import "DAHelper.h"

@interface DAMemberFilterViewController ()
{
    NSArray *_list;
    NSArray *_groupList;
    NSArray *_typeList;
    NSString *_typesegment;
}
@end

@implementation DAMemberFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setSegment:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger segment = segmentedControl.selectedSegmentIndex;
    if (0==segment) {
        _typesegment = @"user";
        [self.tableView reloadData];
    }else{
        _typesegment = @"group";
        [self.tableView reloadData];
    }
}
- (void)viewDidLoad
{
    [self.segType setTitle:[DAHelper localizedStringWithKey:@"user.title" comment:@"成员"] forSegmentAtIndex:0];
    [self.segType setTitle:[DAHelper localizedStringWithKey:@"group.title" comment:@"组/部门"] forSegmentAtIndex:1];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _list = @[[DAHelper localizedStringWithKey:@"user.filter.type.follower" comment:@"粉丝"], [DAHelper localizedStringWithKey:@"user.filter.type.following" comment:@"关注"]];
    _typeList = @[@"follower", @"following"];
    
    [[DAGroupModule alloc] getGroupListStart:0 count:20  type:@"" keywords:@"" callback:^(NSError *error, DAGroupList *groups){
        _groupList = groups.items;
        
    }];
    _typesegment = @"user";
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
    if ([_typesegment isEqualToString:@"group"]) {
        DAGroup *group = [_groupList objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = group.name.name_zh;
    }else{
        cell.detailTextLabel.text = [_list objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_typesegment isEqualToString:@"group"])
    {
        DAGroup *group = [_groupList objectAtIndex:indexPath.row];
        if (self.selectedBlocks != nil) {
            self.selectedBlocks(group._id,_typesegment,group.name.name_zh);
        }
    }
    else
    {
        if (self.selectedBlocks != nil) {
            self.selectedBlocks([_typeList objectAtIndex:indexPath.row],_typesegment,[_list objectAtIndex:indexPath.row]);
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_typesegment isEqualToString:@"group"]) {
        return _groupList.count;
    }else{
        return _list.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


@end
