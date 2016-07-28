//
//  BLViewController.m
//  BLBubbleFilters
//
//  Created by André Campana on 07/26/2016.
//  Copyright (c) 2016 André Campana. All rights reserved.
//

#import "BLViewController.h"
@import BLBubbleFilters;

@interface BLViewController () <BLBubbleSceneDataSource, BLBubbleSceneDelegate>

@end

@implementation BLViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BLBubbleScene *scene = [[BLBubbleScene alloc] initWithSize:self.view.frame.size];
    scene.bubbleDataSource = self;
    scene.bubbleDelegate = self;
    
    scene.backgroundColor = [UIColor whiteColor];
    [(SKView *)self.view presentScene:scene];
}

#pragma mark Data Source

- (NSInteger)numberOfBubblesInBubbleScene:(BLBubbleScene *)scene
{
    return 10;
}

- (NSString *)bubbleScene:(BLBubbleScene *)scene
     textForBubbleAtIndex:(NSInteger)index
{
    return @"bubble";
}

- (SKTexture *)bubbleScene:(BLBubbleScene *)scene
      iconForBubbleAtIndex:(NSInteger)index
{
    if (index != 0) {
        return [SKTexture textureWithImageNamed:@"bubble"];
    }
    return nil;
}

- (SKTexture *)bubbleScene:(BLBubbleScene *)scene backgroundImageForBubbleAtIndex:(NSInteger)index
{
    if (index == 0) {
        return [SKTexture textureWithImageNamed:@"bubbles-on-blue-background"];
    }
    return nil;
}

- (SKColor *)bubbleScene:(BLBubbleScene *)scene
 bubbleFillColorForState:(BLBubbleNodeState)state
{
    switch (state) {
        case BLBubbleNodeStateNormal:
            return [UIColor greenColor];
        case BLBubbleNodeStateHighlighted:
            return [UIColor yellowColor];
        case BLBubbleNodeStateSuperHighlighted:
            return [UIColor redColor];
        default:
            return nil;
    }
}

- (SKColor *)bubbleScene:(BLBubbleScene *)scene
bubbleStrokeColorForState:(BLBubbleNodeState)state
{
    return [UIColor blueColor];
}

- (SKColor *)bubbleScene:(BLBubbleScene *)scene
 bubbleTextColorForState:(BLBubbleNodeState)state
{
    return [UIColor whiteColor];
}

#pragma mark Delegate

- (void)bubbleScene:(BLBubbleScene *)scene
    didSelectBubble:(BLBubbleNode *)bubble
            atIndex:(NSInteger)index
{
    NSLog(@"Bubble selected: %@; Bubble state: %d; at index: %d", bubble, (int)bubble.state, (int)index);
}

@end
