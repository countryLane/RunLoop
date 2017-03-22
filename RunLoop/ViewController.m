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
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
}

- (void)createThread
{
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}

- (void)someLog
{
    NSLog(@"%@", [NSThread currentThread].name);
}

#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"添加NSPort让子线程常驻";
            break;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            [self performSelector:@selector(someLog) onThread:self.thread withObject:nil waitUntilDone:NO];
            break;
        }
    }
}

@end
