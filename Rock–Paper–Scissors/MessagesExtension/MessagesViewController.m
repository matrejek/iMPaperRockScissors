//
//  MessagesViewController.m
//  MessagesExtension
//
//  Created by Matrejek, Mateusz on 25/09/16.
//  Copyright © 2016 Pega. All rights reserved.
//

#import "MessagesViewController.h"
#import "GameViewController.h"

NSString *kScore = @"rpsScore";

NSString *kGameViewControllerIdentifier = @"GameViewController";

@interface MessagesViewController ()

@property GameViewController *gameViewController;

@property NSString *summary;

@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int score = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kScore];
    [self.scoreLabel setText:[NSString stringWithFormat:@"My score: %d", score]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Conversation Handling

- (void)willBecomeActiveWithConversation:(MSConversation *)conversation {
    [super willBecomeActiveWithConversation:conversation];
    [self presentViewControllerForConversation:conversation withPresentationStyle:self.presentationStyle];
}

- (void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    [self presentViewControllerForConversation:self.activeConversation withPresentationStyle:presentationStyle];
}

- (void)presentViewControllerForConversation:(MSConversation *)conversation withPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {

    if (presentationStyle == MSMessagesAppPresentationStyleCompact) {

    } else {

        MSMessage *msg = [conversation selectedMessage];
        NSURL *msgURL = [msg URL];

        NSURLComponents *components = [[NSURLComponents alloc] initWithURL:msgURL resolvingAgainstBaseURL:false];
        NSArray<NSURLQueryItem *> *queryItems = [components queryItems];

        int tag = 0;
        for (NSURLQueryItem *item in queryItems) {
            tag = [[item value] intValue];
        }

        self.gameViewController = (GameViewController *)[self.storyboard instantiateViewControllerWithIdentifier:kGameViewControllerIdentifier];
        [self.gameViewController setParentVC:self];
        [self.view addSubview:[self.gameViewController view]];
        [[self.gameViewController view] setFrame:self.view.frame];
        [self.gameViewController setGameTag:tag];
    }
}

- (void)endGameWithStatus:(NSString *)status {

    self.summary = status;

    [UIView animateWithDuration:0.5
        animations:^{
          [[self.gameViewController view] setAlpha:0.0];
          [self requestPresentationStyle:MSMessagesAppPresentationStyleCompact];
        }
        completion:^(BOOL finished) {
          [[self.gameViewController view] removeFromSuperview];
          self.gameViewController = nil;
        }];
}

- (IBAction)choose:(UIButton *)sender {
    [self composeMessageForConversation:self.activeConversation type:sender.tag];
}

- (void)composeMessageForConversation:(MSConversation *)conversation type:(NSInteger)type {

    MSMessageTemplateLayout *layout = [[MSMessageTemplateLayout alloc] init];
    [layout setCaption:@"I challenge you! "];
    [layout setSubcaption:@"Paper Rock Scissors"];
    [layout setTrailingCaption:self.summary];
    [layout setImage:[UIImage imageNamed:@"cover"]];

    NSURLComponents *components = [[NSURLComponents alloc] init];

    NSString *value = [NSString stringWithFormat:@"%d", (int)type];
    NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:@"code" value:value];

    NSMutableArray<NSURLQueryItem *> *items = [[NSMutableArray alloc] init];
    [items addObject:queryItem];
    [components setQueryItems:items];

    MSSession *session = [[self.activeConversation selectedMessage] session];

    MSMessage *msg = [[MSMessage alloc] initWithSession:session];
    [msg setShouldExpire:YES];
    [msg setLayout:layout];
    [msg setSummaryText:@"Game over!"];
    [msg setURL:[components URL]];

    [self.activeConversation insertMessage:msg completionHandler:nil];
}

- (void)didBecomeActiveWithConversation:(MSConversation *)conversation {
}

- (void)willResignActiveWithConversation:(MSConversation *)conversation {
}

- (void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
}

- (void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
}

- (void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
}

- (void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
}

@end
