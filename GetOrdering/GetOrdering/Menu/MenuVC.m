//
//  MenuVC.m
//  GetOrdering
//
//  Created by shahbaz tariq on 1/24/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "MenuVC.h"
#import "MenuCell.h"

@interface MenuVC ()
{
    NSArray * arrayCategories;
}
@property(strong,nonatomic) IBOutlet UITableView * tblViewCategories;
@property(strong,nonatomic) IBOutlet UIImageView * ImgViewProduct;

@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setHidden:NO];
    
    [self.tblViewCategories setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tblViewCategories.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tblViewCategories.tableHeaderView=[[UIView alloc]initWithFrame:CGRectZero];
    self.tblViewCategories.backgroundColor=[UIColor clearColor];
    
    arrayCategories = self.dictData[@"categories"];
    
    [self.ImgViewProduct sd_setImageWithURL: [NSURL URLWithString:[self.dictData objectForKey:@"image_url"]]];
    
    [self.tblViewCategories reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];
}
#pragma mark--UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iDentifier = @"MenuCell";
    
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:iDentifier];
    
    NSArray *nib;

    if (cell == nil) {
        nib = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    cell.lblTitle.text = arrayCategories[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
