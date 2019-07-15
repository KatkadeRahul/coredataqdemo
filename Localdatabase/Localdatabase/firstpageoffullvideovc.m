//
//  firstpageoffullvideovc.m
//  ATG
//
//  Created by Mac on 28/10/17.
//  Copyright © 2017 Mplussoft. All rights reserved.
//

#import "firstpageoffullvideovc.h"
#import "dashboardcell.h"
#import "Reachability.h"
#import "fullvideovc.h"
#import <CoreData/CoreData.h>


extern NSString *mainurl,*userid,*mobilenumber,*mainusername,*addressmain,*webviewid,*mainvideourl,*udid,*useremail;
extern CGFloat navigationheight;
@interface firstpageoffullvideovc ()<UITableViewDelegate,UITableViewDataSource>
{
    dashboardcell *cell;
	
    NSMutableArray *namearray;
}
@property (strong) NSManagedObject *device;
@end
@implementation firstpageoffullvideovc

@synthesize table1;
- (void)viewDidLoad {
    
    
	mainurl=@"http://awakenthegenius.org/awakenpanel/webserv/mobservice_demo";
	mainvideourl=@"http://awakenthegenius.org/awakenpanel/videos_mobile";
	
    
    
    
    [super viewDidLoad];
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
    
    
    
    NSLog(@"table1.contentSize.height=%f",table1.contentSize.height);
    NSLog(@"table1.frame.size.height=%f",table1.frame.size.height);
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
	if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
	{
		NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SerialEntity"];
		
		namearray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
		[table1 reloadData];
	}
	else
	{
    [self getlist];
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
    return 75;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:
            cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backview.layer.cornerRadius=5;
    cell.backview.layer.borderWidth=0.5;
    cell.backview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    
    cell.namelabels.text=[namearray objectAtIndex:indexPath.row];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    fullvideovc * vc = [storyboard instantiateViewControllerWithIdentifier:@"fullvideopage"];
    vc.nameofplan=[namearray objectAtIndex:indexPath.row];
	vc.subtitle=self.subtitle;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

#pragma mark --navigation button

- (IBAction)backbutton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)getlist
{
    
    NSString* urlString = [NSString stringWithFormat:@"%@/video_free?folder=%@",mainurl,_subtitle];
    
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
        NSLog(@"Firstpage=%@",dicAllNetworks);
        NSString *status1=[NSString stringWithFormat:@"%@",[dicAllNetworks objectForKey:@"success"]];
        
        if ([status1 isEqualToString:@"0"])
        {
            NSString *meassgae=[dicAllNetworks objectForKey:@"message"];
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:meassgae message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
            [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
        else
        {
			//[self deleteAllObjects:@"SerialEntity"];
          
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            namearray =[[NSMutableArray alloc] init];
            NSArray *tparray=[dicAllNetworks objectForKey:@"folders"] ;
            namearray=[tparray mutableCopy];
            NSLog(@"dkmm=%@",namearray);
            
       
          
			
			
			NSManagedObjectContext *context = [self managedObjectContext];
			
			for (int i=0; i<namearray.count; i++) {
				
				NSString *folders=[NSString stringWithFormat:@"%@", [namearray objectAtIndex:i]];
               
                NSMutableArray *mapValue = [[dicAllNetworks objectForKey:@"map"]valueForKey:folders];
                NSLog(@"%@",mapValue);
                NSString *greeting = [mapValue componentsJoinedByString:@","];
                NSLog(@"%@",greeting);
                
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"SerialEntity" inManagedObjectContext:context];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"package like %@",folders];
                [fetchRequest setPredicate:predicate];
                [fetchRequest setFetchLimit:1];
                [fetchRequest setEntity:entity];
                NSError *error;
                NSArray *arrResult = [context executeFetchRequest:fetchRequest error:&error];
                _device = arrResult[0];
				[self.device setValue:folders forKey:@"folders"];
                [self.device setValue:greeting forKey:@"videname"];
				
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
