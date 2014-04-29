//
//  AEMapViewController.m
//  Sketch
//
//  Created by Alex Eisenach on 4/27/14.
//  Copyright (c) 2014 Free Swim. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "AEMapViewController.h"
#import "AEFriendsViewController.h"
#import "AEActiveFriendsViewController.h"

@interface AEMapViewController ()
@end

@implementation AEMapViewController
GMSMapView *mapView_;
GMSMarker *marker;

@synthesize myTime;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Map";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.RightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"TRACK" style:UIBarButtonItemStyleBordered target:self action:@selector(editItems:)];
    self.navigationItem.LeftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"ME" style:UIBarButtonItemStyleBordered  target:self action:@selector(addFriend:)];

    mapView_.myLocationEnabled = YES;

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mapView_.myLocation.coordinate.latitude
                                                            longitude:mapView_.myLocation.coordinate.longitude
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    marker = [[GMSMarker alloc] init];
    marker.position = camera.target;
    
    marker.snippet = @"Hello World";
    marker.map = mapView_;
    self.view = mapView_;
    
    // Create url connection and fire request

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}
- (void)addFriend:(id)sender {
    AEFriendsViewController *friendController = [[AEFriendsViewController alloc] initWithNibName:@"AEFriendsViewController" bundle:nil];
    UINavigationController *friendNavController = [[UINavigationController alloc] initWithRootViewController:friendController];
    [friendController setDelegate:self];
    [self presentViewController:friendNavController animated:YES completion:nil];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSDictionary *newJSON = [NSJSONSerialization JSONObjectWithData:_responseData
                                                            options:0
                                                              error:nil];
    NSString *latString = [newJSON valueForKey:@"lat"];
    NSString *longString = [newJSON valueForKey:@"long"];
    NSString *username = [newJSON valueForKey:@"user"];
    marker.position = CLLocationCoordinate2DMake([latString doubleValue], [longString doubleValue]);
    marker.icon = [UIImage imageNamed:@"flag_icon"];
    marker.map = mapView_;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[latString doubleValue]
                                                            longitude:[longString doubleValue]
                                                                 zoom:15];
                                 
                                 
    [mapView_ animateToCameraPosition:camera];
    
}

-(void)controller:(AEFriendsViewController *)controller didSelectUserWithName:(NSString *)name
{
    activeFriend = name;
    [self startTimer];

}

-(void)editItems:(id)sender {
    AEActiveFriendsViewController *friendController = [[AEActiveFriendsViewController alloc] init];
    UINavigationController *activeFriendsNavController = [[UINavigationController alloc] initWithRootViewController:friendController];
    [friendController setDelegate:self];
    [self presentViewController:activeFriendsNavController animated:YES completion:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

- (void) startTimer
{
    self.myTime = [NSTimer scheduledTimerWithTimeInterval:5
                                                    target:self
                                                  selector:@selector(timerFired:)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void) stopTimer
{
    [self.myTime invalidate];
}

- (void) timerFired:(NSTimer*)theTimer
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://sheltered-harbor-2567.herokuapp.com/retrieve_coordinates?username=%@",activeFriend]]];
    NSLog(@"request for mapping");
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}
@end
