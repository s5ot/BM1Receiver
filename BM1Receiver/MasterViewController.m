//
//  MasterViewController.m
//  BM1Receiver
//
//  Created by sogo on 1/13/14.
//  Copyright (c) 2014 sogo. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

NSString* const PROXIMITY_UUID = @"00000000-0C57-1001-B000-001C4DA451B2";

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        // CLLocationManagerの生成とデリゲートの設定
        self.manager = [CLLocationManager new];
        self.manager.delegate = self;
        
        // proximityUUID
        NSString *uuid = PROXIMITY_UUID;
        self.proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
        
        // CLBeaconRegionを作成
        self.region = [[CLBeaconRegion alloc]
                       initWithProximityUUID:self.proximityUUID
                       identifier:@"com.s5ot.bm1"];
        self.region.notifyOnEntry = YES;
        self.region.notifyOnExit = YES;
        self.region.notifyEntryStateOnDisplay = NO;
        
        // 領域監視を開始
        [self.manager startMonitoringForRegion:self.region];
        // 距離測定を開始
        [self.manager startRangingBeaconsInRegion:self.region];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }

    NSMutableDictionary *dic = [self convertedData];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"UUID";
            cell.detailTextLabel.text = _beacon.proximityUUID.UUIDString;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:9];
            break;
        case 1:
            cell.textLabel.text = @"major";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _beacon.major];
            break;
        case 2:
            cell.textLabel.text = @"minor";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _beacon.minor];
            break;
        case 3:
            cell.textLabel.text = @"proximity";
            cell.detailTextLabel.text = [dic objectForKey:@"proximity"];
            break;
        case 4:
            cell.textLabel.text = @"accuracy";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", _beacon.accuracy];
            break;
        case 5:
            cell.textLabel.text = @"rssi";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)_beacon.rssi];
            break;
        default:
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// Beaconに入ったときに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self sendNotification:@"Beaconの領域に入りました"];
}

// Beaconから出たときに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self sendNotification:@"Beaconの領域から出ました"];
}

// Beaconとの状態が確定したときに呼ばれる
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    switch (state) {
        case CLRegionStateInside:
            NSLog(@"CLRegionStateInside");
            [self playSound:@"enter"];
            break;
        case CLRegionStateOutside:
            NSLog(@"CLRegionStateOutside");
            [self playSound:@"exit"];
            break;
        case CLRegionStateUnknown:
            NSLog(@"CLRegionStateUnknown");
            break;
        default:
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    _beacon = beacons.firstObject;
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"kCLAuthorizationStatusNotDetermined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"kCLAuthorizationStatusRestricted");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"kCLAuthorizationStatusDenied");
            break;
        case kCLAuthorizationStatusAuthorized:
            NSLog(@"kCLAuthorizationStatusAuthorized");
            break;
        default:
            break;
    }
}

- (void)sendNotification:(NSString*)message
{
    // 通知を作成する
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = [[NSDate date] init];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = message;
    notification.alertAction = @"Open";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知を登録する
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


- (void)playSound:(NSString*)name
{
    //////////////////////////////////////////////////
    //
    // 音声ファイルは以下のサイトからお借りしています。
    // http://www.skipmore.com/sound/
    //
    //////////////////////////////////////////////////
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:name ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    SystemSoundID sndId;
    OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(url), &sndId);
    if (!err) {
        AudioServicesPlaySystemSound(sndId);
    }
}

- (NSMutableDictionary *) convertedData
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    switch (_beacon.proximity) {
        case CLProximityUnknown:
            [dic setObject:@"Unknown" forKey:@"proximity"];
            [dic setObject:@"0.3" forKey:@"alpha"];
            break;
        case CLProximityImmediate:
            [dic setObject:@"Immediate" forKey:@"proximity"];
            [dic setObject:@"1.0" forKey:@"alpha"];
            break;
        case CLProximityNear:
            [dic setObject:@"Near" forKey:@"proximity"];
            [dic setObject:@"0.8" forKey:@"alpha"];
            break;
        case CLProximityFar:
            [dic setObject:@"Far" forKey:@"proximity"];
            [dic setObject:@"0.5" forKey:@"alpha"];
            break;
        default:
            break;
    }
    return dic;
}
@end

