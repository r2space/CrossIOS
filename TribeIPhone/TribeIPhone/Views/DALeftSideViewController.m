//
//  DAMessageFilterViewController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/06/07.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DALeftSideViewController.h"
#import "DATimeLineViewController.h"

@interface DALeftSideViewController ()
{
    
    NSString *type;
    NSString *loginuid ;
}
@end

@implementation DALeftSideViewController
@synthesize contentController;
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
    withoutRefresh = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    type = @"group";
    [self.segType setTitle:[DAHelper localizedStringWithKey:@"user.joinGroup" comment:@"参加的组"] forSegmentAtIndex:0];
    [self.segType setTitle:[DAHelper localizedStringWithKey:@"user.folling" comment:@"关注的人"] forSegmentAtIndex:1];
    self.segType.selectedSegmentIndex = 0;

    loginuid = [DALoginModule getLoginUserId];
    
    [self refresh];
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
    if ([type isEqualToString:@"group"]) {
        [[DAGroupModule alloc] getGroupListByUser:loginuid start:start count:count callback:^(NSError *error, DAGroupList *groups){
            [self finishFetch:groups.items error:error];
        }];
    }
    if ([type isEqualToString:@"user"]) {
        [[DAUserModule alloc] getUserFollowingListByUser:loginuid start:start count:count keywords:@"" callback:^(NSError *error, DAUserList *users){
            [self finishFetch:users.items error:error];
        }];
    }
}


-(void)setSegment:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSInteger segment = segmentedControl.selectedSegmentIndex;
    if (0==segment) {
        type = @"group";
    }else{
        type = @"user";
    }
    [self refresh];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    if ([type isEqualToString:@"group"]) {
        DAGroup *g = [list objectAtIndex:row];
        
        cell.detailTextLabel.text = g.name.name_zh;
        
        
    }
    if ([type isEqualToString:@"user"]) {
        NSUInteger row = [indexPath row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [((DAUser *)[list objectAtIndex:row]) getUserName]];
        
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [DAHelper hidePopup];
    if ([type isEqualToString:@"group"]) {
        DAGroup *filteredGroup = [list objectAtIndex:[indexPath row]];
        [((DATimeLineViewController *) contentController) filter:@"group" filterid:[filteredGroup _id] filtername:[[filteredGroup name] name_zh] ];
    }else{
        DAUser *filteredUser = [list objectAtIndex:[indexPath row]];
        
        [(DATimeLineViewController *) contentController filter:@"user" filterid:[filteredUser _id] filtername:[[filteredUser name] name_zh] ];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
