//
//  TVCell.m
//  GetOrdering
//
//  Created by shahbaz tariq on 1/22/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import "TVCell.h"
#import "GOHomeViewController.h"

@implementation TVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnTrending:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil,nil];
    
    [alert show];
}
@end
