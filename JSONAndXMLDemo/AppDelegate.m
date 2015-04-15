//
//  AppDelegate.m
//  JSONAndXMLDemo
//
//  Created by Gabriel Theodoropoulos on 24/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "AppDelegate.h"

#warning Set your Geonames username in the kUsername constant.
NSString *const kUsername = @"progab";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(void)downloadDataFromURL:(NSURL *)url withComplationHandler:(void(^)(NSData *data))ComplationHander
{
    //in order to get the data we want , we need use NSURLSessionDataTask class to fetch
    //before take it action, we need do 2 steps to init NSURLSessionConfiguration and NSURLSession

    NSURLSessionConfiguration   *URLSessionConfig   =[NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession                *URLSession         =[NSURLSession sessionWithConfiguration:URLSessionConfig];
    //we’ll use has a completion handler block which is called after the data has been downloaded or if any error has occurred.
    NSURLSessionDataTask        *SessionDataTask               =[URLSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *Response, NSError * error){
        //if exist some errors, show error
        if (error != nil) {
            NSLog(@"there is an error occur:%@",[error localizedDescription]);
            
        }
        
        else
        {
            // init HttpStatusCode
            NSInteger HTTPStatusCode    =[(NSHTTPURLResponse *)Response statusCode];
            // if code is not 200, show something wrong
            if (HTTPStatusCode != 200) {
                NSLog(@"STATUS code= %ld",(long)HTTPStatusCode);
                
            }
            //if no error, Call the completion handler with the returned data on the main thread.
            NSLog(@"%ld",(long)HTTPStatusCode);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{ComplationHander(data);
            }];
            
        }
    }];
    //resume task
    
    [SessionDataTask resume];
    
    
}

@end
