//
//  DAGroupSelectViewController.m
//  TribeIPhone
//
//  Created by kita on 13-4-24.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAGroupSelectViewController.h"
#import "DALoginProxy.h"

@interface DAGroupSelectViewController ()
{
    NSArray *_allGroups;
    NSMutableArray *_unSelectGroups;
}
@end

@implementation DAGroupSelectViewController

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
    withoutGetMore = YES;
    [super viewDidLoad];

    _allGroups = [[NSArray alloc] init];
    _unSelectGroups = [[NSMutableArray alloc] init];
    
    self.barTitle.title = [DAHelper localizedStringWithKey:@"group.select.title" comment:@"组/部门选择"];
    
    [self refresh];
}


-(void) viewDidAppear:(BOOL)animated
{
    DALoginProxy *loginProxy = [DALoginProxy sharedInstance];
    [loginProxy setCurVC:self];
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetch
{
    if ([self preFetch]) {
        return;
    }
    [[DAGroupModule alloc] getGroupListByUser:[DALoginModule getLoginUserId] start:0 count:20 callback:^(NSError *error, DAGroupList *groups){
        _allGroups = groups.items;
        [self setUnSelectGroups];
        [self finishFetch:groups.items error:error];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.selectedGroups.count;
    }
    return _unSelectGroups.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DAGroup *group = [self.selectedGroups objectAtIndex:indexPath.row];
        DAGroupCell *cell = [DAGroupCell initWithGroup:group tableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        return cell;
    } else {
        DAGroup *group = [_unSelectGroups objectAtIndex:indexPath.row];
        DAGroupCell *cell = [DAGroupCell initWithGroup:group tableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DAGroup *group = [self.selectedGroups objectAtIndex:indexPath.row];
        [self.selectedGroups removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self setUnSelectGroups];
        int idx = [self getIndexInGroups:_unSelectGroups group:group];
        if (idx >= 0) {
            NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:idx inSection:1]];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        }
    } else {
        DAGroup *group = [_unSelectGroups objectAtIndex:indexPath.row];
        if (self.allowMultiSelect) {
            [self.selectedGroups addObject:group];
             NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.selectedGroups.count-1 inSection:0]];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [self setUnSelectGroups];
            indexPaths = [NSArray arrayWithObject:indexPath];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [self.selectedGroups removeAllObjects];
            [self.selectedGroups addObject:group];
            [self setUnSelectGroups];
            
            [self dismiss];
            
        }
    }
}

-(void)setUnSelectGroups
{
    [_unSelectGroups removeAllObjects];
    for (DAGroup *group in _allGroups) {
        if (![self isGroupSelected:group]) {
            [_unSelectGroups addObject:group];
        }
    }
}

-(BOOL)isGroupSelected:(DAGroup *)group
{
    for (DAGroup *g in self.selectedGroups) {
        if ([group._id isEqualToString:g._id]) {
            return YES;
        }
    }
    return NO;
}

-(int) getIndexInGroups:(NSArray *)groups group:(DAGroup *)group
{
    for (int i = 0; i < groups.count; i++) {
        DAGroup *g = [groups objectAtIndex:i];
        if ([group._id isEqualToString:g._id]) {
            return i;
        }
    }
    return -1;
}

- (IBAction)onCancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSelectClicked:(id)sender {
    [self dismiss];
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.selectedBlocks != nil) {
            self.selectedBlocks(_selectedGroups);
        }
    }];
}

@end
