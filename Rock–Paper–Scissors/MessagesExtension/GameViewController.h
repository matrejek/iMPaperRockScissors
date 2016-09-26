//
//  GameViewController.h
//  Rock–Paper–Scissors
//
//  Created by Matrejek, Mateusz on 26/09/16.
//  Copyright © 2016 Pega. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessagesViewController;

@interface GameViewController : UIViewController

@property (nonatomic) int gameTag;

@property (nonatomic, weak) IBOutlet UIImageView *weaponImage;

@property (nonatomic) MessagesViewController *parentVC;

@end
