//
//  BLViewController.m
//  BLBubbleFilters
//
//  Created by André Campana on 07/26/2016.
//  Copyright (c) 2016 André Campana. All rights reserved.
//

#import "BLViewController.h"
@import BLBubbleFilters;

@interface BLViewController () <BLBubbleSceneDataSource>

@end

@implementation BLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BLBubbleScene *scene = [[BLBubbleScene alloc] initWithSize:self.view.frame.size];
    scene.bubbleDataSource = self;
    scene.backgroundColor = [UIColor whiteColor];
    [(SKView *)self.view presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfBubbles
{
    return 10;
}

- (NSString *)textForBubbleAtIndex:(NSInteger)index
{
    return @"test";
}

- (SKColor *)bubbleFillColorForState:(BLBubbleNodeState)state
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

- (SKColor *)bubbleStrokeColorForState:(BLBubbleNodeState)state
{
    return [UIColor blueColor];
}

- (SKColor *)bubbleTextColorForState:(BLBubbleNodeState)state
{
    return [UIColor whiteColor];
}

@end
