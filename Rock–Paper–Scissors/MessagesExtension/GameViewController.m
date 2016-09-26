//
//  GameViewController.m
//  Rock–Paper–Scissors
//
//  Created by Matrejek, Mateusz on 26/09/16.
//  Copyright © 2016 Pega. All rights reserved.
//

#import "GameViewController.h"
#import "MessagesViewController.h"

NSString *rockImage = @"rock";
NSString *paperImage = @"paper";
NSString *scissorsImage = @"scissors";

@interface GameViewController ()

@property NSArray<UIImage *> *images;

@property (nonatomic) UILabel *statusLabel;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *p = [UIImage imageNamed:paperImage];
    UIImage *r = [UIImage imageNamed:rockImage];
    UIImage *s = [UIImage imageNamed:scissorsImage];

    self.images = [NSArray arrayWithObjects:p, r, s, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.weaponImage setAnimationImages:self.images];
    [self.weaponImage setAnimationDuration:0.25];
    [self.weaponImage setAnimationRepeatCount:0];
    [self.weaponImage startAnimating];

    self.statusLabel = [[UILabel alloc] initWithFrame:self.view.frame];
    [self.statusLabel setFont:[UIFont fontWithName:@"Helvetica" size:82]];
    [self.statusLabel setAlpha:0.0];
    [self.view addSubview:self.statusLabel];
    [self.statusLabel setTextAlignment:NSTextAlignmentCenter];
}

- (IBAction)choose:(UIButton *)sender {

    [self.weaponImage stopAnimating];
    [self.weaponImage setImage:[self.images objectAtIndex:self.gameTag]];

    if (sender.tag == 0) { // rock
        switch (self.gameTag) {
        case 0:
            [self showDraw];
            break;
        case 1:
            [self showLoss];
            break;
        case 2:
            [self showSuccess];
            break;
        default:
            break;
        }
    }

    if (sender.tag == 1) { // paper
        switch (self.gameTag) {
        case 0:
            [self showSuccess];
            break;
        case 1:
            [self showDraw];
            break;
        case 2:
            [self showLoss];
            break;
        default:
            break;
        }
    }

    if (sender.tag == 2) { // scissors
        switch (self.gameTag) {
        case 0:
            [self showLoss];
            break;
        case 1:
            [self showSuccess];
            break;
        case 2:
            [self showDraw];
            break;
        default:
            break;
        }
    }
}

- (void)showSuccess {

    NSInteger score = [[NSUserDefaults standardUserDefaults] integerForKey:kScore];
    score++;
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:kScore];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.statusLabel setText:@"WIN!"];
    [self.statusLabel setTextColor:[UIColor greenColor]];

    [UIView animateWithDuration:0.5
        animations:^{
          self.statusLabel.alpha = 1.0;
        }
        completion:^(BOOL finished) {
          [self.parentVC endGameWithStatus:@"I win"];
        }];
}

- (void)showDraw {
    [self.statusLabel setText:@"DRAW"];
    [self.statusLabel setTextColor:[UIColor blueColor]];

    [UIView animateWithDuration:0.5
        animations:^{
          self.statusLabel.alpha = 1.0;
        }
        completion:^(BOOL finished) {
          [self.parentVC endGameWithStatus:@"It is a draw"];
        }];
}

- (void)showLoss {

    NSInteger score = [[NSUserDefaults standardUserDefaults] integerForKey:kScore];

    if (score > 0) {
        score -= 1;
    }

    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:kScore];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self.statusLabel setText:@"LOSS :("];
    [self.statusLabel setTextColor:[UIColor redColor]];

    [UIView animateWithDuration:0.5
        animations:^{
          self.statusLabel.alpha = 1.0;
        }
        completion:^(BOOL finished) {
          [self.parentVC endGameWithStatus:@"You beat me!"];
        }];
}

@end
