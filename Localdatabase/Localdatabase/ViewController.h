//
//  ViewController.h
//  Localdatabase
//
//  Created by Airborne Group on 11/07/19.
//  Copyright © 2019 Airborne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong) NSManagedObjectModel *fullvideoList;
-(void)saveLocalData:(NSMutableArray *)saveArray;
@end

