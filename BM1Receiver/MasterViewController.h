//
//  MasterViewController.h
//  BM1Receiver
//
//  Created by sogo on 1/13/14.
//  Copyright (c) 2014 sogo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import AudioToolbox;

extern NSString * const PROXIMITY_UUID;

@interface MasterViewController : UITableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) NSUUID *proximityUUID;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLBeaconRegion *region;
@property (strong, nonatomic) CLBeacon *beacon;

@end
