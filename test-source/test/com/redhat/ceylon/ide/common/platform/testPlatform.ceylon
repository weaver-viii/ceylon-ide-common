import com.redhat.ceylon.ide.common.platform {
    PlatformServices,
    VfsServices,
    IdeUtils,
    ModelServices,
    CommonDocument,
    NoopLinkedMode,
    JavaModelServices
}
import com.redhat.ceylon.model.typechecker.model {
    Unit
}

shared object testPlatform satisfies PlatformServices {
    
    shared actual ModelServices<NativeProject,NativeResource,NativeFolder,NativeFile> model<NativeProject, NativeResource, NativeFolder, NativeFile>() => nothing;
    
    shared actual IdeUtils utils() => nothing;
    
    shared actual VfsServices<NativeProject,NativeResource,NativeFolder,NativeFile> vfs<NativeProject, NativeResource, NativeFolder, NativeFile>() => nothing;
    
    gotoLocation(Unit unit, Integer offset, Integer length) => null;
    
    createLinkedMode(CommonDocument document)
            => NoopLinkedMode(document);
    
    completion => nothing;
    document => testDocumentServices;
    
    shared actual JavaModelServices<JavaClassRoot> javaModel<JavaClassRoot>() => nothing;
}
