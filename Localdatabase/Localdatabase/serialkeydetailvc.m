//
//  serialkeydetailvc.m
//  ATG
//
//  Created by Mac on 26/10/17.
//  Copyright © 2017 Mplussoft. All rights reserved.
//

#import "serialkeydetailvc.h"
#import "dashboardcell.h"


extern NSString *userid,*webviewid,*mainurl;
extern CGFloat navigationheight;
@interface serialkeydetailvc ()<UITableViewDelegate,UITableViewDataSource>
{
    dashboardcell *cell;
    
    NSMutableArray *tablearray,*iconarray;
	
}
@end

@implementation serialkeydetailvc
@synthesize table1;
- (void)viewDidLoad {
    [super viewDidLoad];
	mainurl=@"http://awakenthegenius.org/awakenpanel/webserv/mobservice_demo";
	

    table1.separatorColor=[UIColor clearColor];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 15, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor whiteColor]; // Your color here
    titleView.text=@"Awaken The Genius";
    self.navigationItem.titleView = titleView;
    
    [self getdetails];

    // Do any additional setup after loading the view.
}
-(void)setnavigation
{
    UIButton *logobutton = [UIButton buttonWithType: UIButtonTypeCustom];
    [logobutton setImage:[UIImage imageNamed:@"drawerlogo"] forState:UIControlStateNormal];
    logobutton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *mailbutton = [[UIBarButtonItem alloc] initWithCustomView:logobutton];
    self.navigationItem.leftBarButtonItem =mailbutton;
    
//    UIImage* image1 = [UIImage imageNamed:@"menu-1"];
//    CGRect frameimg1 = CGRectMake(15,5, 25,20);
//    
//    UIButton *someButton1 = [[UIButton alloc] initWithFrame:frameimg1];
//    [someButton1 setBackgroundImage:image1 forState:UIControlStateNormal];
//    [someButton1 addTarget:self action:@selector(buttonMenuRight:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *mailbutton1 =[[UIBarButtonItem alloc] initWithCustomView:someButton1];
//    self.navigationItem.rightBarButtonItem =mailbutton1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    table1.estimatedRowHeight = 1000;
    table1.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - uitableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [tablearray count];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:
            cellIdentifier];
    if (cell == nil) {
        cell = [[dashboardcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
                        cell.backview.layer.cornerRadius=5;
                        cell.backview.layer.borderWidth=1.5f;
                        cell.backview.layer.borderColor=[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1.0].CGColor;
    
    
                        [cell.backview.layer setShadowColor:[UIColor grayColor].CGColor];
                        [cell.backview.layer setShadowOpacity:0.7];
                        [cell.backview.layer setShadowRadius:2.0];
                        [cell.backview.layer setShadowOffset:CGSizeZero];
   
   // Serial Key : WHWN-TMDG-JD8K-UQSX
//    [ cell.backview.layer setCornerRadius:5.0f];
//    
//    // border
//    [ cell.backview.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//    [ cell.backview.layer setBorderWidth:0.5f];
//    
//    // drop shadow
//    [ cell.backview.layer setShadowColor:[UIColor lightGrayColor].CGColor];
//    [ cell.backview.layer setShadowOpacity:0.8];
//    [ cell.backview.layer setShadowRadius:3.0];
//    [ cell.backview.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    cell.serialkey_lb.text=[NSString stringWithFormat:@"Serial Key : %@",[[tablearray objectAtIndex:indexPath.row ] objectForKey:@"serial_key"] ];
    
     cell.plan_lbl.text=[NSString stringWithFormat:@"Program : %@",[[tablearray objectAtIndex:indexPath.row ] objectForKey:@"program_title"] ];
    
    cell.validation_lbl.text=[NSString stringWithFormat:@"Validity : %@ ",[[tablearray objectAtIndex:indexPath.row ] objectForKey:@"plan_title"] ];
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
         return UITableViewAutomaticDimension;
  
   
}

-(CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@",[[tablearray objectAtIndex:indexPath.row ] objectForKey:@"serial_key"] ]];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Serial key copied successfully" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
}
#pragma mark --navigation button

- (IBAction)backbutton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- webservice
-(void)getdetails
{
    tablearray=[[NSMutableArray alloc]init];
        
        NSString* urlString = [NSString stringWithFormat:@"%@/get_purchase_keys_details?member_id=%@",mainurl,@"0"];
        
        NSURL* url = [NSURL URLWithString:urlString];
        
        
        NSLog(@"%@", urlString);
        
        
        //Take the data we get back and convert it into JSON
        NSData* data = [NSData dataWithContentsOfURL:url];
        
        if (data ==nil)
        {
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Connection error" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
        }
        else
        {
            NSDictionary *dicAllNetworks = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            
            NSLog(@"Serial Key Details =%@",dicAllNetworks);
            NSString *status1=[NSString stringWithFormat:@"%@",[dicAllNetworks objectForKey:@"success"]];
            
            if ([status1 isEqualToString:@"0"])
            {
                NSString *meassgae=[dicAllNetworks objectForKey:@"message"];
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:meassgae message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
                [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
                
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                self.table1.hidden=YES;
                
            }
            else
            {
                
               [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                
                for (NSDictionary *dic in [dicAllNetworks objectForKey:@"data"])
                {
                    [tablearray addObject:@{@"serial_key" : [dic objectForKey:@"serial_key"], @"program_title": [dic objectForKey:@"program_title"], @"plan_title": [dic objectForKey:@"plan_title"],@"expiry_date": [dic objectForKey:@"expiry_date"]}];
                    
                }
                
                [table1 reloadData];
                
            }
        }
   
}

-(void)dismissAlertView:(UIAlertController *)alertcontroller
{
    [alertcontroller dismissViewControllerAnimated:YES completion:nil];
    
}
@end
