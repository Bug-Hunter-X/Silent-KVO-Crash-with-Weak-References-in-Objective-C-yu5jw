// FixedKVO.m
#import "FixedKVO.h"

@interface ObservedObject : NSObject
@property (nonatomic, strong) NSString *observedProperty;
@end

@implementation ObservedObject
- (void)dealloc {
    NSLog(@"ObservedObject deallocated");
}
@end

@interface ObserverObject : NSObject
@property (nonatomic, weak) ObservedObject *observedObject;
@end

@implementation ObserverObject
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.observedObject && [keyPath isEqualToString:@"observedProperty"]) {
        NSLog(@"Observed property changed: %@
", change[NSKeyValueChangeNewKey]);
    }
}

- (void)startObserving:(ObservedObject *)observedObject {
    self.observedObject = observedObject;
    [self.observedObject addObserver:self forKeyPath:@"observedProperty" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)stopObserving {
    if (self.observedObject) {
        [self.observedObject removeObserver:self forKeyPath:@"observedProperty"];
        self.observedObject = nil; //important to nil out the weak ref
    }
}

- (void)dealloc {
    [self stopObserving];
    NSLog(@"ObserverObject deallocated");
}
@end