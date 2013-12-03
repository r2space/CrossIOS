//
//  DAGroupViewController.m
//  tribe
//
//  Created by 李 林 on 2012/11/27.
//  Copyright (c) 2012年 dac. All rights reserved.
//

#import "DAGroupViewController.h"
#import "DAGroupViewCell.h"
#import "DAGroupDetailViewController.h"
#import "DAGroupMoreContainerViewController.h"
#import "DAGroupFilterViewController.h"

@interface DAGroupViewController ()
{
    NSString *_type;
    NSDictionary *_typeValues;
    NSString *_keywords;
    BOOL isFirstIn;
}
@end

@implementation DAGroupViewController

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
    
    
    _type = @"all";
    _typeValues = @{@"all":[DAHelper localizedStringWithKey:@"group.type.all" comment:@"组/部门"],@"1":[DAHelper localizedStringWithKey:@"group.type.group" comment:@"组"],@"2":[DAHelper localizedStringWithKey:@"group.type.department" comment:@"部门"]};
    _keywords =@"";
    isFirstIn = YES;
    [self displayFilter];
    
    // 不显示空行的cell分隔线
//    self.tblGroups.tableFooterView = [[UIView alloc]init];
    [self fetch];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _searchBar.placeholder = [DAHelper localizedStringWithKey:@"group.search.placeholder" comment:@"检索名称、拼音"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)fetch
{
    if ([self preFetch]) {
        return;
    }
    NSString *type = [_type isEqualToString:@"all"] ? @"" : _type;
    [[DAGroupModule alloc] getGroupListStart:0 count:20 type:type keywords:_keywords callback:^(NSError *error, DAGroupList *groups){
        [self finishFetch:groups.items error:error];
        [self displayFilter];
        if (isFirstIn && list.count > 0) {
            isFirstIn = NO;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }];
}

-(void)displayFilter
{
    if ([_type isEqualToString:@"all"]) {
        [self.barFilterIco setImage:[UIImage imageNamed:@"tool_down.png"]];
    } else {
        [self.barFilterIco setImage:[UIImage imageNamed:@"tool_multiply-symbol-mini.png"]];
    }
    [self.barFilter setTitle:[_typeValues objectForKey:_type]];
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
	DAGroupViewCell *cell = [DAGroupViewCell initWithMessage:group  tableView:tableView];
    
    [cell lblName].text = group.name.name_zh;
    cell.gid = group._id;
    cell.lblDescription.text = group.description;
    cell.lblMembers.text = [NSString stringWithFormat:[DAHelper localizedStringWithKey:@"group.cell.memberCount" comment:@"%d 成员"],group.member.count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DAGroupDetailViewController *groupDetailViewController =[[DAGroupDetailViewController alloc]initWithNibName:@"DAGroupDetailViewController" bundle:nil];
    groupDetailViewController.hidesBottomBarWhenPushed = YES;
    groupDetailViewController.gid = ((DAGroup *)[list objectAtIndex:indexPath.row])._id ;
    
    [self.navigationController pushViewController:groupDetailViewController animated:YES];
    
}


//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    NSString *a = @"あ/か/さ/た/な/は/ま/や/ら/わ/A/●/D/●/G/●/J/●/M/●/P/●/T/●/Z";
//    return [a pathComponents];
//}

- (IBAction)onAddTouched:(id)sender {
    DAGroupMoreContainerViewController *moreViewController = [[DAGroupMoreContainerViewController alloc] initWithNibName:@"DAGroupMoreContainerViewController" bundle:nil];
    [self.navigationController pushViewController:moreViewController animated:YES];
}

- (IBAction)barFilterOnClick:(id)sender {
    DAGroupFilterViewController *filterCtrl = [[DAGroupFilterViewController alloc] initWithNibName:@"DAGroupFilterViewController" bundle:nil];
    filterCtrl.selectedBlocks = ^(NSString *filter){
        _type = filter;
        _keywords = @"";
        _searchBar.text = @"";
        [self refresh];
        [DAHelper hidePopup];
    };
    [DAHelper showPopup:filterCtrl];
}

- (IBAction)barFilterIcoOnClick:(id)sender {
    if ([_type isEqualToString:@"all"]) {
        [self barFilterOnClick:nil];
    } else {
        _type = @"all";
        _keywords = @"";
        _searchBar.text = @"";
        [self refresh];
    }
}

- (IBAction)onCancelTouched:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    _keywords = searchBar.text;
    [self refresh];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    _searchBar.text = @"";
    _keywords = @"";
    [self refresh];
}


@end
