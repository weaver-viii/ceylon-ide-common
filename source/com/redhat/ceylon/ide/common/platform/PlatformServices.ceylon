import com.redhat.ceylon.model.typechecker.model {
    Unit
}
import java.lang {
    Thread
}
import com.redhat.ceylon.cmr.api {
    RepositoryManagerBuilder
}

shared interface PlatformServices {
    shared void register() {
        _platformServices = this;
        value oldClassLoader = Thread.currentThread().contextClassLoader;
        Thread.currentThread().contextClassLoader = utils().pluginClassLoader;
        try {
            RepositoryManagerBuilder(utils().cmrLogger).repositoryBuilder();
        } finally {
            Thread.currentThread().contextClassLoader = oldClassLoader;
        }
    }
    
    shared formal IdeUtils utils();
    shared formal ModelServices<NativeProject, NativeResource, NativeFolder, NativeFile> 
            model<NativeProject, NativeResource, NativeFolder, NativeFile>();
    shared formal JavaModelServices<JavaClassRoot>
            javaModel<JavaClassRoot>();
    shared formal VfsServices<NativeProject, NativeResource, NativeFolder, NativeFile> 
            vfs<NativeProject, NativeResource, NativeFolder, NativeFile>();
    shared formal CompletionServices completion;
    shared formal DocumentServices document;
    shared formal CommonDocument? gotoLocation(Unit unit, Integer offset, Integer length);
    
    shared formal LinkedMode createLinkedMode(CommonDocument document);
    shared default ParserServices parser() => defaultParserServices;
}

suppressWarnings("expressionTypeNothing")
variable PlatformServices _platformServices 
        = object satisfies PlatformServices {
    shared actual ModelServices<NativeProject,NativeResource,NativeFolder,NativeFile> 
            model<NativeProject, NativeResource, NativeFolder, NativeFile>() 
            => nothing;
    shared actual JavaModelServices<JavaClassRoot>
            javaModel<JavaClassRoot>()
            => nothing;
    shared actual IdeUtils utils() => DefaultIdeUtils();
    shared actual VfsServices<NativeProject,NativeResource,NativeFolder,NativeFile> 
            vfs<NativeProject, NativeResource, NativeFolder, NativeFile>() 
            => nothing;
    completion => nothing;
    document => nothing;
    gotoLocation(Unit unit, Integer offset, Integer length) => null;
    createLinkedMode(CommonDocument document) => NoopLinkedMode(document);
    parser() => defaultParserServices;
};

shared PlatformServices platformServices => _platformServices;
shared IdeUtils platformUtils => platformServices.utils();
