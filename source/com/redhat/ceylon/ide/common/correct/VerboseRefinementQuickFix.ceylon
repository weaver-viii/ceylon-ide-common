import com.redhat.ceylon.compiler.typechecker.tree {
    Tree
}
import com.redhat.ceylon.ide.common.platform {
    platformServices,
    InsertEdit,
    DeleteEdit,
    ReplaceEdit
}
import com.redhat.ceylon.model.typechecker.model {
    ModelUtil
}

shared object verboseRefinementQuickFix {
    
    shared void addVerboseRefinementProposal(QuickFixData data, 
        Tree.Statement? statement) {
        if (is Tree.SpecifierStatement ss = statement,
            ss.refinement, 
            exists e = ss.specifierExpression.expression,
            !ModelUtil.isTypeUnknown(e.typeModel)) {
            
            value change 
                    = platformServices.document.createTextChange {
                name = "Convert to Verbose Refinement";
                input = data.phasedUnit;
            };
            change.initMultiEdit();
            
            value unit = ss.unit;
            value type = unit.denotableType(e.typeModel);
            value importProposals 
                    = CommonImportProposals {
                        document = data.document;
                        rootNode = data.rootNode;
                    };
            importProposals.importType(type);
            importProposals.apply(change);
            
            change.addEdit(InsertEdit {
                start = ss.startIndex.intValue();
                text = "shared actual ``type.asSourceCodeString(unit)`` ";
            });
            
            data.addQuickFix("Convert to verbose refinement", change);
        }
    }

    shared void addShortcutRefinementProposal(QuickFixData data, 
        Tree.Statement? statement) {
        if (is Tree.TypedDeclaration statement,
            exists model = statement.declarationModel,
            model.actual, 
            if (is Tree.AnyMethod statement)
                then !statement.typeParameterList exists 
                else true) {
            
            value body = 
                switch (statement) 
                case (is Tree.AttributeDeclaration) 
                    statement.specifierOrInitializerExpression
                case (is Tree.MethodDeclaration) 
                    statement.specifierExpression
                case (is Tree.AttributeGetterDefinition)
                    statement.block
                case (is Tree.MethodDefinition) 
                    statement.block
                else null;
            
            Tree.Expression? expr;
            switch (body)
            case (null) {
                return;
            }
            case (is Tree.SpecifierOrInitializerExpression) {
                expr = body.expression;
            }
            case (is Tree.Block) {
                if (is Tree.Return ret = body.statements[0]) {
                    expr = ret.expression;
                }
                else {
                    return;
                }
            }
            
            if (exists expr,
                !ModelUtil.isTypeUnknown(expr.typeModel)) {
            
                value change 
                        = platformServices.document.createTextChange {
                    name = "Convert to Shortcut Refinement";
                    input = data.phasedUnit;
                };
                change.initMultiEdit();
                
                value start = statement.startIndex.intValue();
                value length = statement.identifier.startIndex.intValue() - start;
                change.addEdit(DeleteEdit {
                    start = start;
                    length = length;
                });
                
                if (is Tree.Block body) {
                    change.addEdit(ReplaceEdit {
                        start = body.startIndex.intValue();
                        length = expr.startIndex.intValue() 
                               - body.startIndex.intValue();
                        text = "=> ";
                    });
                    change.addEdit(ReplaceEdit {
                        start = expr.endIndex.intValue();
                        length = body.endIndex.intValue() 
                               - expr.endIndex.intValue();
                        text = ";";
                    });
                }
                
                data.addQuickFix("Convert to shortcut refinement", change);
            }
        }
    }
}