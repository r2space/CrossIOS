//
//  DAMemberPasswordViewController.m
//  TribeIPhone
//
//  Created by 罗浩 on 13-12-24.
//  Copyright (c) 2013年 kita. All rights reserved.
//

#import "DAMemberPasswordViewController.h"
#import "DAMemberMoreDetailCell.h"
#import "DAHelper.h"
@interface DAMemberPasswordViewController (){
    NSString *oldPassword;
    NSString *newPassword;
    NSString *newPassword2;
}
@end

@implementation DAMemberPasswordViewController

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
    self.btnSave.enabled = NO;
    self.barTitle.title  =[DAHelper localizedStringWithKey:@"user.password.change" comment:@"修改密码"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OnCancelTouched:(id)sender {
    // 返回
    [self back];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)OnSaveTouched:(id)sender {
    
    if([newPassword isEqualToString:newPassword2]){
        [[DAUserModule alloc] changePassword:self.user oldPassword:oldPassword newPassword:newPassword callback:^(NSError *error, DAUser *user){
            if (error != nil) {
                [DAHelper alert:self.view message:[DAHelper localizedStringWithKey:@"error.updateError" comment:@"更新失败"] detail:[NSString stringWithFormat:@"error : %d", [error code]] delay:0.6 yOffset:0];
                return ;
            }
            [[NSUserDefaults standardUserDefaults] setObject:newPassword forKey:@"jp.co.dreamarts.smart.message.password"];
            [DAHelper alert:self.view message:[DAHelper localizedStringWithKey:@"msg.updateSuccess" comment:@"更新成功"] detail:nil delay:0.6 yOffset:0];
            [self performSelector:@selector(back) withObject:self afterDelay:0.6];
        }];
    }else{
        [DAHelper alert:self.view message:[DAHelper localizedStringWithKey:@"error.updateError" comment:@"更新失败"] detail:[DAHelper localizedStringWithKey:@"error.password.confirm" comment:@"确认密码不正确"] delay:0.6 yOffset:0];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"DAMemberPasswordCell";
    DAMemberMoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
        NSArray *array = [nib instantiateWithOwner:nil options:nil];
        cell = [array objectAtIndex:0];
    }

    switch (indexPath.row) {
        case 0:
            [self rendCell:cell title:[DAHelper localizedStringWithKey:@"user.password.old" comment:@"原密码"] icon: @"recycle-bin.png" value:@"" tag:1 hasDetail:NO];
            break;
        case 1:
            [self rendCell:cell title:[DAHelper localizedStringWithKey:@"user.password.new" comment:@"新密码"] icon: @"lock.png" value:@"" tag:2 hasDetail:NO];
            break;
        case 2:
            [self rendCell:cell title:[DAHelper localizedStringWithKey:@"user.password.retry" comment:@"再次输入"] icon: @"lock.png" value:@"" tag:3 hasDetail:NO];
            break;
        default:
            break;
    }
    
    
    return cell;
}
-(DAMemberMoreDetailCell *)rendCell:(DAMemberMoreDetailCell *)cell title:(NSString *)title icon:(NSString *)icon value:(NSString *)value tag:(int )tag hasDetail:(BOOL)hasDetail
{
    cell.lblName.text = @"";
    cell.txtValue.text = value;
    cell.txtValue.delegate = self;
    cell.txtValue.placeholder = title;
    cell.txtValue.secureTextEntry = YES;
    cell.txtValue.enabled = YES;
    cell.txtValue.tag = tag;
    [cell.txtValue addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.txtValue addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidBegin];
    
    cell.imgPortrait.image = [UIImage imageNamed:icon];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}
- (void) textFieldDidChange:(UITextField *) TextField
{
    if (TextField.tag == 1) {
        oldPassword = TextField.text;
    } else if(TextField.tag == 2){
        newPassword = TextField.text;
    } else if(TextField.tag == 3){
        newPassword2 = TextField.text;
    }
    if(oldPassword.length * newPassword.length * newPassword2.length != 0){
        self.btnSave.enabled = YES;
    }else{
        self.btnSave.enabled = NO;
    }
    
}
@end
