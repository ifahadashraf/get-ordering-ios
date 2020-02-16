//
//  GOMenuViewController.h
//  GetOrdering
//
//  Created by Ali Apple on 1/19/18.
//  Copyright © 2018 Ali Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GOMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}

@property(strong,nonatomic)IBOutlet UITableView* datatableView;

@end
