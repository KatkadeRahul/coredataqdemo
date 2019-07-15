//priya
//  fullvideovc.m
//  ATG
//
//  Created by Mac on 26/10/17.
//  Copyright © 2017 Mplussoft. All rights reserved.
//

#import "fullvideovc.h"
#import "dashboardcell.h"
#import "Reachability.h"



#import <CoreData/CoreData.h>
extern NSString *mainurl,*userid,*mobilenumber,*mainusername,*addressmain,*webviewid,*mainvideourl,*udid,*useremail,*imagelink;
extern CGFloat navigationheight;
@interface fullvideovc ()<UITableViewDelegate,UITableViewDataSource>
{
    dashboardcell *cell;
    
    NSMutableArray *namearray,*plannamearray,*arraytopass;
 
    NSString *plantitle;
}
@property (strong) NSManagedObject *device;
@end

@implementation fullvideovc
@synthesize table1;
- (void)viewDidLoad {
    [super viewDidLoad];
	mainurl=@"http://awakenthegenius.org/awakenpanel/webserv/mobservice_demo";
	mainvideourl=@"http://awakenthegenius.org/awakenpanel/videos_mobile";

	imagelink=@"http://awakenthegenius.org/awakenpanel/images";
	
    self.titlelabel.text=self.nameofplan;
    arraytopass=[[NSMutableArray alloc] init];
    
    table1.separatorColor=[UIColor clearColor];
    


    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 15, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor whiteColor]; // Your color here
    titleView.text=@"Awaken The Genius";
    self.navigationItem.titleView = titleView;
    
  
    //sidebar
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    navigationheight = self.navigationController.navigationBar.bounds.size.height+statusBarFrame.size.height;
    
	
    // Do any additional setup after loading the view.
	if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
	{
		NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SerialEntity"];
		
		namearray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
		[table1 reloadData];
	}
	else
	{
    [self getvideos];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uitableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return namearray.count;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:
            cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
	
    
    
    NSString *tp1=[namearray objectAtIndex:indexPath.row];
    
    NSRange r1 = [tp1 rangeOfString:@"@"];
    NSRange r2 = [tp1 rangeOfString:@"."];
    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
    NSRange rSub1 = NSMakeRange(0,r2.location);
  
    NSString *sub1 = [tp1 substringWithRange:rSub1];

    NSString *sub = [tp1 substringWithRange:rSub];
    cell.titleimage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.png",imagelink,sub1]]]];
	
    NSLog(@"uuu==%@",[NSString stringWithFormat:@"%@/%@.png",imagelink,sub1]);
     cell.namelabels.text=@"";
    

  
    [arraytopass addObject:sub];
    
    NSLog(@"arratopass==%@",arraytopass);
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSLog (@"%@", [NSString stringWithFormat:@"%@/%@/%@/%@",mainvideourl,self.subtitle,self.nameofplan,[namearray objectAtIndex:indexPath.row]]);
}

#pragma mark --navigation button

- (IBAction)backbutton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)getvideos
{
	NSString* urlString = [NSString stringWithFormat:@"%@/video_free?folder=%@",mainurl,self.subtitle];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    
    NSLog(@"%@", urlString);
    
    namearray=[[NSMutableArray alloc]init];
    
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
        
        
        NSLog(@" =%@",dicAllNetworks);
        NSString *status1=[NSString stringWithFormat:@"%@",[dicAllNetworks objectForKey:@"success"]];
        
        if ([status1 isEqualToString:@"0"])
        {
            
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"No Plan Activated for your Device" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                               {
                                   [self.navigationController popViewControllerAnimated:YES];
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                               }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            self.table1.hidden=YES;
            
        }
        else
        {
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            
            namearray =[[NSMutableArray alloc] init];
            
          
            NSLog(@"PLANNAME===%@",self.nameofplan);
            if( [self.titlelabel.text caseInsensitiveCompare:@"Corporate"] == NSOrderedSame)
            {
                NSArray *tparray=[[dicAllNetworks objectForKey:@"map"] objectForKey:self.nameofplan];
                namearray=[tparray mutableCopy];
            }
            else
            {
                NSArray *tparray=[[dicAllNetworks objectForKey:@"map"] objectForKey:self.nameofplan];
                namearray=[tparray mutableCopy];
            }
            
            NSLog(@"dkmm=%@",namearray);
			
			//DB save namearray and nameofplan
			NSManagedObjectContext *context = [self managedObjectContext];
			
			for (int i=0; i<namearray.count; i++) {
				
				NSString *folders=[NSString stringWithFormat:@"%@", [namearray objectAtIndex:i]];
				self.device = [NSEntityDescription insertNewObjectForEntityForName:@"SerialEntity" inManagedObjectContext:context];
				
				
				[self.device setValue:folders forKey:@"videname"];
				NSError *error = nil;
				
				if (![context save:&error]) {
					NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
				}
			}
            [table1 reloadData];

        }
    }
    
}

-(void)dismissAlertView:(UIAlertController *)alertcontroller
{
    [alertcontroller dismissViewControllerAnimated:YES completion:nil];
    
}
- (NSManagedObjectContext *)managedObjectContext
{
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}
- (void) deleteAllObjects: (NSString *) entityDescription  {
	NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSError *error;
	NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	for (NSManagedObject *managedObject in items) {
		[managedObjectContext deleteObject:managedObject];
		NSLog(@"%@ object deleted",entityDescription);
	}
	if (![managedObjectContext save:&error]) {
		NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
	}
}
@end
