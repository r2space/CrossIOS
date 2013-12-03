//
//  DAFileSelectViewController.m
//  TribeIPhone
//
//  Created by kita on 13-6-19.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAFileSelectViewController.h"
#import "DAFileViewCell.h"
#import "DAHelper.h"

@interface DAFileSelectViewController ()
{
    NSArray *_allFiles;
    NSMutableArray *_unSelectFiles;
}
@end

@implementation DAFileSelectViewController

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
    
    _allFiles = [[NSArray alloc] init];
    _unSelectFiles = [[NSMutableArray alloc] init];
    self.barTitle.title = [DAHelper localizedStringWithKey:@"file.select.title" comment:@"文件选择"];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetch
{
    if ([self preFetch]) {
        return;
    }
    
    [[DAFileModule alloc] getFileList:start count:20 type:@"all" callback:^(NSError *error, DAFileList *files) {
        
        [progress hide:YES];
        [refresh endRefreshing];
        [((UIActivityIndicatorView *)self.tableView.tableFooterView) stopAnimating];
        
        // 判断是否有错误
        if (error != nil) {
            
            // 显示错误消息
            [self showMessage:[DAHelper localizedStringWithKey:@"error.FetchError" comment:@"无法获取数据"] detail:[NSString stringWithFormat:@"error : %d", [error code]]];
            
        }
        
        // 如果获取的实际数小于，指定的数，则标记为没有更多数据
        if (files.items.count < count) {
            hasMore = NO;
        } else {
            hasMore = YES;
        }
        
        // 保存数据
        if (_allFiles == nil || start == 0) {
            _allFiles = files.items;
        } else {
            _allFiles = [_allFiles arrayByAddingObjectsFromArray:files.items];
        }
        
        [self setUnSelectFiles];
        // 刷新UITableView
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.selectedFiles.count;
    }
    return _unSelectFiles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DAFileViewCell *cell;
    DAFile *file;
    if (indexPath.section == 0) {
        file = [self.selectedFiles objectAtIndex:indexPath.row];
        cell = [DAFileViewCell initWithMessage:file tableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {
        file = [_unSelectFiles objectAtIndex:indexPath.row];
        cell = [DAFileViewCell initWithMessage:file tableView:tableView];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.lblFileName.text = file.filename;
    cell.lblAt.text = [DAHelper stringFromISODateString: file.uploadDate];
    cell.imgFileType.image = [UIImage imageNamed:[DAHelper fileanExtension:file.contentType]];
    if (([file.length intValue]/1024)> 1024) {
        cell.lblFileSize.text = [NSString stringWithFormat:@"%dMB",[file.length intValue]/1024/1024];
    }else{
        cell.lblFileSize.text = [NSString stringWithFormat:@"%dKB",[file.length intValue]/1024];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DAFile *file = [self.selectedFiles objectAtIndex:indexPath.row];
        [self.selectedFiles removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self setUnSelectFiles];
        int idx = [self getIndexInFiles:_unSelectFiles file:file];
        if (idx >= 0) {
            NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:idx inSection:1]];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        }
    } else {
        DAFile *file = [_unSelectFiles objectAtIndex:indexPath.row];
        if (self.allowMultiSelect) {
            [self.selectedFiles addObject:file];
            NSArray *indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.selectedFiles.count-1 inSection:0]];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            [self setUnSelectFiles];
            indexPaths = [NSArray arrayWithObject:indexPath];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [self.selectedFiles removeAllObjects];
            [self.selectedFiles addObject:file];
            [self setUnSelectFiles];
            
            [self dismiss];
            
        }
    }
}

-(void)setUnSelectFiles
{
    [_unSelectFiles removeAllObjects];
    for (DAFile *file in _allFiles) {
        if (![self isFileSelected:file]) {
            [_unSelectFiles addObject:file];
        }
    }
}

-(BOOL)isFileSelected:(DAFile *)file
{
    for (DAFile *f in self.selectedFiles) {
        if ([file._id isEqualToString:f._id]) {
            return YES;
        }
    }
    return NO;
}

-(int) getIndexInFiles:(NSArray *)files file:(DAFile *)file
{
    for (int i = 0; i < files.count; i++) {
        DAGroup *g = [files objectAtIndex:i];
        if ([file._id isEqualToString:g._id]) {
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
            self.selectedBlocks(_selectedFiles);
        }
    }];
}

@end
