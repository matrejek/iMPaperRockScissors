//
//  MessagesViewController.h
//  MessagesExtension
//
//  Created by Matrejek, Mateusz on 25/09/16.
//  Copyright © 2016 Pega. All rights reserved.
//

#import <Messages/Messages.h>

CF_EXPORT NSString *kScore;

@interface MessagesViewController : MSMessagesAppViewController

@property (nonatomic, weak) IBOutlet UILabel *scoreLabel;

- (void)endGameWithStatus:(NSString *)status;

@end
