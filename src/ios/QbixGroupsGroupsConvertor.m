 //
//  QbixGroupsGroupsConvertor.m
//  Groups
//
//  Created by Igor on 7/14/17.
//
//

#import "QbixGroupsGroupsConvertor.h"
#import "AddressBook.h"
#import "TEMPServiceLocator.h"
#import "QbixGroupsRepository.h"

@interface QbixGroupsGroupsConvertor()
@property(nonatomic, strong) QbixGroupsRepository *repository;
@end

@implementation QbixGroupsGroupsConvertor

+ (void) configure {
    [QbixGroupsGroupsConvertor instance];
}

+ (instancetype) instance
{
    static QbixGroupsGroupsConvertor *inst = nil;
    if (!inst) {
        inst = [[self alloc] init];
    }
    return inst;
}

- (instancetype)init {
    if(self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupsChanged) name:kNotificationSorageGroupsSettingsChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupsLoaded) name:kNotificationSorageGroupsSettingsLoaded object:nil];
        
        _repository = [QbixGroupsRepository instance];
    }
    return self;
}

-(NSArray<StorageGroupModel*>*) getStoredData {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"storedGroup.position" ascending:YES];
    
    NSArray<ABGroup*> *groups = [[[AddressBook instance] allGroups] sortedArrayUsingDescriptors:@[descriptor]];
    
    NSMutableArray *convertedGroups = [NSMutableArray array];
    
    for (ABGroup *group in groups) {
        StorageGroupModel *groupModel = [[StorageGroupModel alloc] init];
    
        [groupModel setIdentifier:@"-1"];
        if(![group isExternal]) {
            [groupModel setIdentifier:[@([group recordId]) stringValue]];
            [groupModel setContactIds:@[]];
        } else {
            NSMutableArray *contactIds = [NSMutableArray array];
            for(ABPerson* person in [group members]) {
                [contactIds addObject:@([person recordId])];
            }
            [groupModel setContactIds:[contactIds copy]];
        }
        
        [groupModel setTitle:[group name]];
        
        
        [groupModel setIcon:[[TEMPServiceLocator generateIconsGroupsService] imageForType:group.storedGroup.imageType value:group.storedGroup.imageValue groupID:group.recordId]];
        
        [groupModel setSortMethod:StorageSortMethodDefault];
        SortMethod sortMethod = group.storedGroup.sortMethod;
        switch (sortMethod) {
            case SortMethodByFirst:
                [groupModel setSortMethod:StorageSortMethodByFirst];
                break;
            case SortMethodByLast:
                [groupModel setSortMethod:StorageSortMethodByLast];
                break;
            case SortMethodByCompany:
                [groupModel setSortMethod:StorageSortMethodByCompany];
                break;
            case SortMethodByRecentAdd:
                [groupModel setSortMethod:StorageSortMethodByRecentAdd];
                break;
            default:
                break;
        }
        
        [convertedGroups addObject:groupModel];
    }
    
    return [convertedGroups copy];
}

-(void) groupsChanged {
    NSArray<StorageGroupModel*> *savedGroups = [self getStoredData];
    [_repository saveLatestGroups:savedGroups];
}

-(void) groupsLoaded {
    NSArray<StorageGroupModel*> *savedGroups = [self getStoredData];
    [_repository saveLatestGroups:savedGroups];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
