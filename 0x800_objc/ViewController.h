//
//  ViewController.h
//  0x800_objc
//
//  Created by Artur Rojek on 23/02/15.
//  Copyright (c) 2015 Artur Rojek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardModel.h"

@interface ViewController : UIViewController

- (void) refreshBoard;

@property (weak, nonatomic) IBOutlet UILabel *scoreCount;
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (nonatomic) BoardModel *bm;

@end

