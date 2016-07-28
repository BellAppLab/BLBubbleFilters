//
//  BLDataModel.m
//  BLBubbleFilters
//
//  Created by Founders Factory on 28/07/2016.
//  Copyright © 2016 André Campana. All rights reserved.
//

#import "BLDataModel.h"


@implementation BLDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _bubbleState = BLBubbleNodeStateNormal;
    }
    return self;
}

@synthesize bubbleText, bubbleIcon, bubbleBackground;
@synthesize bubbleState = _bubbleState;

- (NSString *)bubbleText
{
    return @"bubble";
}

- (SKTexture *)bubbleIcon
{
    return [SKTexture textureWithImageNamed:@"bubble"];
}

- (SKTexture *)bubbleBackground
{
    return self.background;
}

@end
