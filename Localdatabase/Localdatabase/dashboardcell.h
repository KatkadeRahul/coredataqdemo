//
//  dashboardcell.h
//  ATG
//
//  Created by Mac on 16/10/17.
//  Copyright © 2017 Mplussoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface dashboardcell : UITableViewCell
@property (nonatomic,strong)IBOutlet UIView *backview;
@property (nonatomic,strong) IBOutlet UIImageView *titleimage;
@property (nonatomic,strong) IBOutlet UILabel *namelabels,*serialkey_lb,*validation_lbl,*plan_lbl;


@end
