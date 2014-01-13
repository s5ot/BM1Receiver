//
//  DetailViewController.h
//  BM1Receiver
//
//  Created by sogo on 1/13/14.
//  Copyright (c) 2014 sogo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
