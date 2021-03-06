import java.util {
    JList=List,
    Collections
}

shared class DummyFolder<NativeProject,NativeResource,NativeFolder,NativeFile> 
        satisfies FolderVirtualFile<NativeProject,NativeResource,NativeFolder,NativeFile> 
        given NativeProject satisfies Object 
        given NativeResource satisfies Object 
        given NativeFolder satisfies NativeResource 
        given NativeFile satisfies NativeResource {
    String _path;
    
    shared new (String path="") {
        _path = path;
    }
    
    shared actual Boolean \iexists() => true;
    shared actual String path => _path;
    shared actual String name => "";
    shared actual JList<ResourceVirtualFile<NativeProject,NativeResource,NativeFolder,NativeFile>> children =>
            Collections.emptyList<ResourceVirtualFile<NativeProject,NativeResource,NativeFolder,NativeFile>>();

    suppressWarnings("expressionTypeNothing")
    shared actual Nothing findFile(String fileName) => nothing;
    suppressWarnings("expressionTypeNothing")
    shared actual Nothing nativeResource => nothing;
    suppressWarnings("expressionTypeNothing")
    shared actual Nothing parent => nothing;
    suppressWarnings("expressionTypeNothing")
    shared actual Nothing toPackageName(BaseFolderVirtualFile srcDir) => nothing;
    
    shared actual Integer hash =>
            (super of FolderVirtualFile<NativeProject,NativeResource,NativeFolder,NativeFile>).hash;
    shared actual Boolean equals(Object that) =>
            (super of FolderVirtualFile<NativeProject,NativeResource,NativeFolder,NativeFile>).equals(that);
    
    suppressWarnings("expressionTypeNothing")
    shared actual Nothing ceylonProject => nothing;
    suppressWarnings("expressionTypeNothing")
    shared actual Nothing ceylonPackage => nothing;
    suppressWarnings("expressionTypeNothing")
    shared actual Nothing isSource => nothing;
    suppressWarnings("expressionTypeNothing")
    shared actual Nothing rootFolder => nothing;
    suppressWarnings("expressionTypeNothing")
    shared actual Nothing nativeProject => nothing;
}
