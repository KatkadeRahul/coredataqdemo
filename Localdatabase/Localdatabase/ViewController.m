//
//  ViewController.m
//  Localdatabase
//
//  Created by Airborne Group on 11/07/19.
//  Copyright © 2019 Airborne. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Reachability.h"
#import "fullvideovc.h"
#import "firstpageoffullvideovc.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
	NSMutableArray *myarrray;
	NSString *mainurl,*mainvideourl,*checkurl,*imagelink;
	NSMutableArray *plannamearray;
}
@property (strong) NSMutableArray *DBArray;

@property (strong) NSManagedObject *device;
@end
@implementation ViewController
@synthesize DBArray;

- (void)viewDidLoad {
	
	mainurl=@"http://awakenthegenius.org/awakenpanel/webserv/mobservice_demo";
	mainvideourl=@"http://awakenthegenius.org/awakenpanel/videos_mobile";
	checkurl=@"http://awakenthegenius.org/awakenpanel/front/frontloginplan";
	imagelink=@"http://awakenthegenius.org/awakenpanel/images";
	
	
	myarrray = [NSMutableArray arrayWithObjects:@"First", @"Second", nil];

		if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
		{
	//connection unavailable
	NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SerialEntity"];
	
	DBArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
	NSMutableArray *tparray=[[NSMutableArray alloc]init];
	
	
	for (int i=0; i<DBArray.count; i++) {
		
        
//        self.device = [DBArray objectAtIndex:i];
//        NSLog(@"%@",[_device valueForKey:@"activation_date"]);
//        NSLog(@"%@",[_device valueForKey:@"expiration_date"]);
//        NSLog(@"%@",[_device valueForKey:@"serial_key"]);
//        NSLog(@"%@",[_device valueForKey:@"package"]);
//
        
		NSString *expiration_date=[NSString stringWithFormat:@"%@", [[DBArray objectAtIndex:i]valueForKey:@"expiration_date"]];
		NSString *serial_key=[NSString stringWithFormat:@"%@",[[DBArray objectAtIndex:i]valueForKey:@"serial_key"]];
		NSLog(@"Key value==%@",serial_key);
		
		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"yyyy-MM-dd"];
		NSDate *date = [dateFormat dateFromString:expiration_date];
		
		NSDate * now = [NSDate date];
		
		NSComparisonResult result = [now compare:date];
		
		NSLog(@"%@", now);
		NSLog(@"%@", date);
		
		switch (result)
		{
			case NSOrderedAscending: NSLog(@"%@ is in future from %@", date, now);
				[self.device setValue:@"1" forKey:@"status"];
				break;
			case NSOrderedDescending: NSLog(@"%@ is in past from %@", date, now);
				[self.device setValue:@"0" forKey:@"status"];
				[tparray removeObjectAtIndex: i];
				break;
			case NSOrderedSame: NSLog(@"%@ is the same as %@", date, now);
				[self.device setValue:@"1" forKey:@"status"];
				break;
			default: NSLog(@"erorr dates %@, %@", date, now); break;
		}
		
		[self movetonextvc:@"3@Main_Videos-p" arrytopass:tparray];
		
	}
}
else
{
	[self getdetails:@"3@Main_Videos-p"];

}
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text=[NSString stringWithFormat:@"%@",[myarrray objectAtIndex:indexPath.row]];
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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



-(void)getdetails:(NSString*)title
{NSString* urlString = [NSString stringWithFormat:@"%@/getProgramList?memberid=%@&macid=%@",mainurl,@"0",@"F4A0A943-42E3-4C7E-B57C-2861B90B4C91"];
	
	NSURL* url = [NSURL URLWithString:urlString];
	NSLog(@"%@", urlString);
	plannamearray=[[NSMutableArray alloc]init];
	NSMutableArray *tparray=[[NSMutableArray alloc]init];
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
			
			UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"No Subscription" message:@"" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *ok=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
							   {
								   
								   [alert dismissViewControllerAnimated:YES completion:nil];
							   }];
			[alert addAction:ok];
			[self presentViewController:alert animated:YES completion:nil];
			[[UIApplication sharedApplication] endIgnoringInteractionEvents];
		}
		else
		{
			 [self deleteAllObjects:@"SerialEntity"];
			[[UIApplication sharedApplication] endIgnoringInteractionEvents];
			
			for (NSDictionary *dic in [dicAllNetworks objectForKey:@"data"])
			{
				[plannamearray addObject:@{@"package" : [dic objectForKey:@"package"], @"activation_date": [dic objectForKey:@"activation_date"],@"expiration_date": [dic objectForKey:@"expiration_date"], @"serial_key": [dic objectForKey:@"serial_key"]}];
				[tparray addObject:@{@"package" : [dic objectForKey:@"package"], @"activation_date": [dic objectForKey:@"activation_date"],@"expiration_date": [dic objectForKey:@"expiration_date"], @"serial_key": [dic objectForKey:@"serial_key"]}];
			}

					//If net available clear all data from core
				NSManagedObjectContext *context = [self managedObjectContext];

				for (int i=0; i<plannamearray.count; i++) {
					
					NSString *activation_date=[NSString stringWithFormat:@"%@", [[plannamearray objectAtIndex:i]objectForKey:@"activation_date"]];
					NSString *expiration_date=[NSString stringWithFormat:@"%@", [[plannamearray objectAtIndex:i]objectForKey:@"expiration_date"]];
					NSString *serial_key=[NSString stringWithFormat:@"%@",[[plannamearray objectAtIndex:i]objectForKey:@"serial_key"]];
					NSLog(@"Key value==%@",serial_key);
					NSString *package=[NSString stringWithFormat:@"%@", [[plannamearray objectAtIndex:i]objectForKey:@"package"]];
					
					
					  self.device = [NSEntityDescription insertNewObjectForEntityForName:@"SerialEntity" inManagedObjectContext:context];
					// Convert string to date object
					NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
					[dateFormat setDateFormat:@"yyyy-MM-dd"];
					NSDate *date = [dateFormat dateFromString:expiration_date];
					
					NSDate * now = [NSDate date];
				
					NSComparisonResult result = [now compare:date];
					
					NSLog(@"%@", now);
					NSLog(@"%@", date);
					
					switch (result)
					{
						case NSOrderedAscending: NSLog(@"%@ is in future from %@", date, now);
							[self.device setValue:@"1" forKey:@"status"];
												break;
						case NSOrderedDescending: NSLog(@"%@ is in past from %@", date, now);
							[self.device setValue:@"0" forKey:@"status"];
							[tparray removeObjectAtIndex: i];
												break;
						case NSOrderedSame: NSLog(@"%@ is the same as %@", date, now);
							[self.device setValue:@"1" forKey:@"status"];
												break;
						default: NSLog(@"erorr dates %@, %@", date, now); break;
					}
					//Rahul
					
                    if ([package isEqualToString:@"Study Skill"]) {
                        package = @"Study_Skill";
                    }
                    
                    
					[self.device setValue:activation_date forKey:@"activation_date"];
					[self.device setValue:expiration_date forKey:@"expiration_date"];
					[self.device setValue:serial_key forKey:@"serial_key"];
					[self.device setValue:package forKey:@"package"];
                    
                    
                    NSError *error = nil;
                    if (![context save:&error]) {
                        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                    }
				}
			
			
			
			
			[self movetonextvc:title arrytopass:tparray];
		
			}
		}
}
	
-(void)movetonextvc:(NSString*)name arrytopass:(NSMutableArray*) numbercount
	{
		
		if (numbercount.count>=2)
		{
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
			firstpageoffullvideovc * vc = [storyboard instantiateViewControllerWithIdentifier:@"firstpageoffullvideopage"];
			vc.subtitle=@"3@Main_Videos-p";
			[self.navigationController pushViewController:vc animated:YES];
		}
		else
		{
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
			fullvideovc * vc = [storyboard instantiateViewControllerWithIdentifier:@"fullvideopage"];
			NSString *tp=[NSString stringWithFormat:@"%@",[[plannamearray objectAtIndex:0]objectForKey:@"package"]];
			tp=[tp stringByReplacingOccurrencesOfString:@" " withString:@"_"];
			vc.nameofplan=tp;
			vc.subtitle=name;
			[self.navigationController pushViewController:vc animated:YES];
		}
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
