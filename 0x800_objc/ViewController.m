//
//  ViewController.m
//  0x800_objc
//
//  Created by Artur Rojek on 23/02/15.
//  Copyright (c) 2015 Artur Rojek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSInteger rows;
    NSInteger cols;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _bm = [BoardModel sharedInstance];
    rows = _bm.rows;
    cols = _bm.cols;
    
    // Register to receive a board releated notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRefreshBoard:) name:_bm.refreshBoardNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGameOver:) name:_bm.gameOverNotif object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: Notifications
- (void) onRefreshBoard:(NSNotification *) notification {
    NSLog(@"Received a notification %@", notification.name);
    [self refreshBoard];
}

- (void) onGameOver:(NSNotification *) notification {
    NSLog(@"Received a notification %@", notification.name);
    
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Oops" message:@"Game over\nKeep trying. Good luck!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSLog(@"Handle Ok logic here");
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)newGameBtnTapped:(id)sender {
    [self.bm clear];
}

- (IBAction)upBtnTapped:(id)sender {
    NSLog(@"Up button pressed");
    [self.bm moveUp];
}

- (IBAction)downBtnTapped:(id)sender {
    NSLog(@"Down button pressed");
    [self.bm moveDown];

}

- (IBAction)leftBtnTapped:(id)sender {
    NSLog(@"Left button pressed");
    [self.bm moveLeft];

}

- (IBAction)rightBtnTapped:(id)sender {
    NSLog(@"Right button pressed");
    [self.bm moveRight];

}

- (IBAction)swipedUp:(id)sender {
    [self.bm moveUp];
    NSLog(@"Swiped up");
}

- (IBAction)swipedDown:(id)sender {
    [self.bm moveDown];
}

- (IBAction)swipedLeft:(id)sender {
    [self.bm moveLeft];
}

- (IBAction)swipedRight:(id)sender {
    [self.bm moveRight];
}


// MARK: board
- (void)refreshBoard {
    for (NSInteger x = 1; x <= cols; ++x) {
        for (NSInteger y = 1; y <= rows; ++y) {
            UIColor *tileColor;
            UIView *tile = [self getTileView:x varY:y];
            UILabel *label = [self getLabelFromView:tile];
            NSInteger value = [self.bm valueFor:x secondParameter:y];
            tileColor = [UIColor colorWithRed:0.1 green:0.1 * sqrt(value) blue:0.1 alpha:1];
            tile.backgroundColor = (value == 0 ? [UIColor whiteColor] : tileColor);
            label.textColor = (value >= 32) ? [UIColor blackColor] : [UIColor whiteColor];
            label.text = (value == 0 ? @"" : [@(value) stringValue]);
        }
    }
    _scoreCount.text = [@([self.bm score]) stringValue];
}

//MARK: Access to each tile

- (UIView *) getTileView: (NSInteger)x varY: (NSInteger)y {
    NSInteger tag = 10 * y + x;
    return [_boardView viewWithTag:tag];
}

- (UILabel *) getLabelFromView: (UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[UILabel class]]) {
            return (UILabel *)v;
        }
    }
    return nil;
}

@end
