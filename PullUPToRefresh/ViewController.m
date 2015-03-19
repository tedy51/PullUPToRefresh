//
//  ViewController.m
//  PullUPToRefresh
//
//  Created by hisa on 15/3/19.
//  Copyright (c) 2015年 hisa. All rights reserved.
//

#import "ViewController.h"
#import "TBTableViewCell.h"
#import "MoreTableViewCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataSource;
@property(strong,nonatomic)NSMutableArray *data;

@property  BOOL  finished;
@property  BOOL  loaded;
@end

@implementation ViewController
{
    UIButton *button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _data = [[NSMutableArray alloc]init];
    
    for(int i = 0;i<10;i++)
    {
        [_data addObject:[NSNumber numberWithInt:i]];
    }
    
    _dataSource = [[NSMutableArray alloc]init];
    
    [self.dataSource addObjectsFromArray:_data];
    
    _loaded = YES;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count] +1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <[_dataSource count])
    {
        
        static NSString * ID = @"ad";
        TBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TBTableViewCell" owner:self options:nil]lastObject];
        }
        cell.img.image = [UIImage imageNamed:@"a"];
        cell.lable.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        return cell;
        
    }
    else
    {
        static NSString * ID = @"ad1";
        MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MoreTableViewCell" owner:self options:nil]lastObject];
        }
        
        return cell;
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat scrollViewBottomToTop = scrollView.contentSize.height - contentYoffset;
    
    if(scrollViewBottomToTop < height)
    {
        
        if(_loaded == YES)
        {
            
            _finished = YES;
            
        }
        
    }
    
}

-(void)delayMethod
{
    NSIndexPath  *path = [NSIndexPath indexPathForRow:[_dataSource count] inSection:0];
    
    MoreTableViewCell *cell = (MoreTableViewCell*)[_tableView cellForRowAtIndexPath:path];
    
    [cell.activ stopAnimating];
    
    [self.dataSource addObjectsFromArray:_data];
    
    [_tableView reloadData];
    
    NSLog(@"刷新数据");
    
    _loaded = YES;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_finished == YES)
    {
        _finished = NO;
        _loaded = NO;
        NSIndexPath  *path = [NSIndexPath indexPathForRow:[_dataSource count] inSection:0];
        
        MoreTableViewCell *cell = (MoreTableViewCell*)[_tableView cellForRowAtIndexPath:path];
        
        [cell.activ startAnimating];
        
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
        
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <[_dataSource count])
    {
        
        return 90;
        
    }
    else
    {
        return 44;
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
