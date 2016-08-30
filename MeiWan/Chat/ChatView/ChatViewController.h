/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

@interface ChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>

@property (nonatomic,strong)NSDictionary * chatDic;
- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

@end
