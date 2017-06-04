//
//  ViewController.m
//  RunLoop
//
//  Created by 王一 on 2017/3/21.
//  Copyright © 2017年 countryLane. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSThread *thread;

@property (nonatomic) NSTimer *timer;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configTableView];

    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(createThread) object:nil];
    self.thread.name = @"子线程";
    [self.thread start];
}

- (void)configTableView
{
    self.tableView.tableFooterView = [UIView new];
    self.title = @"RunLoop常见使用场景";

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)createThread
{
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
    [[NSRunLoop currentRunLoop] run];
}

- (void)someLog
{
    NSLog(@"%@：常驻子线程", [NSThread currentThread].name);
}

- (void)timerFired:(NSTimer *)timer
{
    NSLog(@"%@：TimerFired!", [NSThread currentThread].name);
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"添加NSPort让子线程常驻";
            break;
        case 1:
            cell.textLabel.text = self.timer.isValid ? @"Timer运行中..." : @"Timer已停止";
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self performSelector:@selector(someLog) onThread:self.thread withObject:nil waitUntilDone:NO];
            break;
        case 1:
            if (self.timer.isValid) {
                [self.timer invalidate];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.textLabel.text = @"Timer已停止";
            }
            break;
    }
}

#pragma mark - getter

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    }
    return _timer;
}

@end
