//
//  DAGroupController.m
//  TribeIPhone
//
//  Created by LI LIN on 2013/04/21.
//  Copyright (c) 2013年 kita. All rights reserved.
//
#import "DAGroupController.h"

@interface DAGroupController ()
{
    NSArray *theGroups;
}

@end

@implementation DAGroupController

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
	// Do any additional setup after loading the view.
    
    self.barTitle.title = [DAHelper localizedStringWithKey:@"group.joinList.title" comment:@"参加的组"];
    
    [self refresh];
}

- (void)fetch
{
    if ([self preFetch]) {
        return;
    }
    [[DAGroupModule alloc] getGroupListByUser:self.uid start:0 count:20 callback:^(NSError *error, DAGroupList *groups){
        [self finishFetch:groups.items error:error];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAGroup *group = [list objectAtIndex:indexPath.row];
    DAGroupCell *cell = [DAGroupCell initWithGroup:group tableView:tableView];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    }
//    
//    cell.textLabel.text = group.name.name_zh;
    return cell;
}

- (IBAction)onCancelTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end