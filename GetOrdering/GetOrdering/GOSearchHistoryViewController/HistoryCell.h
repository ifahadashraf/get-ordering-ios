//
//  HistoryCell.h
//  GetOrdering
//
//  Created by shahbaz tariq on 1/28/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property(weak,nonatomic) IBOutlet UILabel * lblDateTime;
@property(weak,nonatomic) IBOutlet UILabel * lblTitle;
@property(weak,nonatomic) IBOutlet UIButton * btnDelete;
@end
