import com.redhat.ceylon.ide.common.model {
    BaseIdeModule,
    IResourceAware,
    IdeUnit
}
import com.redhat.ceylon.model.loader.model {
    LazyPackage
}
import com.redhat.ceylon.model.typechecker.model {
    Unit
}

shared interface JavaUnitUtils<NativeFolder,NativeFile,JavaClassRoot> {
    shared formal NativeFile? javaClassRootToNativeFile(JavaClassRoot javaClassRoot);
    shared formal NativeFolder? javaClassRootToNativeRootFolder(JavaClassRoot javaClassRoot);
}

shared alias AnyJavaUnit => JavaUnit<out Anything,out Anything,out Anything,out Anything,out Anything>;

shared abstract class JavaUnit<NativeProject,NativeFolder,NativeFile,JavaClassRoot,JavaElement>
        (String theFilename, String theRelativePath, String theFullPath, LazyPackage thePackage)
        extends IdeUnit.init(theFilename, theRelativePath, theFullPath, thePackage)
        satisfies IResourceAware<NativeProject, NativeFolder, NativeFile>
                & IJavaModelAware<NativeProject, JavaClassRoot, JavaElement>
                & JavaUnitUtils<NativeFolder, NativeFile, JavaClassRoot> {
    
    shared void remove() {
        value p = \ipackage;
        p.removeUnit(this);
        assert (is BaseIdeModule m = p.\imodule);
        m.moduleInReferencingProjects
                .each((m) => m.removedOriginalUnit(relativePath));
    }
    
    shared formal Unit clone();
    
    shared void update() {
        remove();
        value newUnit = clone();
        newUnit.dependentsOf.addAll(dependentsOf);
        thePackage.addLazyUnit(newUnit);
    }

    resourceFile => javaClassRootToNativeFile(typeRoot);
    resourceProject => project;
    resourceRootFolder 
            => if (resourceFile exists) 
            then javaClassRootToNativeRootFolder(typeRoot)
            else null;
}
