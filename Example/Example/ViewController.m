#import "ViewController.h"
#import "BLBubbleFilters.h"
#import "Bubble.h"


@interface ViewController () <BLBubbleSceneDataSource, BLBubbleSceneDelegate>

@property (nonatomic, strong) NSArray<Bubble *> *bubbles;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBubbles:@[[[Bubble alloc] initWithIndex:0],
                       [[Bubble alloc] initWithIndex:1],
                       [[Bubble alloc] initWithIndex:2],
                       [[Bubble alloc] initWithIndex:3]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BLBubbleScene *scene = [BLBubbleScene sceneWithSize:self.view.bounds.size];
    scene.backgroundColor = [UIColor whiteColor];
    scene.bubbleDataSource = self;
    scene.bubbleDelegate = self;
    
    [(SKView *)self.view presentScene:scene];
}

#pragma mark Bubble Delegate

- (void)bubbleScene:(BLBubbleScene *)scene
    didSelectBubble:(BLBubbleNode *)bubble
            atIndex:(NSInteger)index
{
    NSLog(@"Bubble Pressed! %@", bubble);
    NSLog(@"The bubble is now on state %ld", (long)[bubble.model bubbleState]);
}

#pragma mark Bubble Data Source

- (NSInteger)numberOfBubblesInBubbleScene:(BLBubbleScene *)scene
{
    return self.bubbles.count;
}

- (id<BLBubbleModel>)bubbleScene:(BLBubbleScene *)scene
           modelForBubbleAtIndex:(NSInteger)index
{
    return [self.bubbles objectAtIndex:index];
}

- (SKColor *)bubbleScene:(BLBubbleScene *)scene
 bubbleFillColorForState:(BLBubbleNodeState)state
{
    return [UIColor blueColor];
}

- (SKColor *)bubbleScene:(BLBubbleScene *)scene
 bubbleTextColorForState:(BLBubbleNodeState)state
{
    return [UIColor whiteColor];
}

- (SKColor *)bubbleScene:(BLBubbleScene *)scene
bubbleStrokeColorForState:(BLBubbleNodeState)state
{
    return [UIColor clearColor];
}

@end
