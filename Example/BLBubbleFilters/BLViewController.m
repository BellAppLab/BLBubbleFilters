//
//  BLViewController.m
//  BLBubbleFilters
//
//  Created by André Campana on 07/26/2016.
//  Copyright (c) 2016 André Campana. All rights reserved.
//

#import "BLViewController.h"
#import "BLDataModel.h"


@interface BLViewController () <BLBubbleSceneDataSource, BLBubbleSceneDelegate>

@property (nonatomic, strong) NSArray<id<BLBubbleModel>> *dataModel;

@end


@implementation BLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0; i<10; i++) {
        [array addObject:[BLDataModel new]];
    }
    
    BLDataModel *wierdModel = [BLDataModel new];
    wierdModel.bubbleState = BLBubbleNodeStateHighlighted;
    wierdModel.background = [SKTexture textureWithImageNamed:@"bubbles-on-blue-background"];
    [array addObject:wierdModel];
    
    self.dataModel = [NSArray arrayWithArray:array];
}

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
    return self.dataModel.count;
}

- (id<BLBubbleModel>)bubbleScene:(BLBubbleScene *)scene
           modelForBubbleAtIndex:(NSInteger)index
{
    return self.dataModel[index];
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
