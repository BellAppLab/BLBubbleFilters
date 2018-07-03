#import "ViewController.h"
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
    
    BLBubbleScene *scene = [BLBubbleScene sceneWithSize:CGSizeMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0)];
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

@end
