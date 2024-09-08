package jume.utils;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.Function;

using haxe.macro.Tools;

function inject(): Array<Field> {
  // Get all the fields in the event class.
  final fields = Context.getBuildFields();

  final getters: Array<Field> = [];

  for (field in fields) {
    // Only inject fields that have `@:inject` metadata.
    if (!hasMetadata(field, ':inject')) {
      continue;
    }

    try {
      switch (field.kind) {
        case FVar(fType, fExpr):
          if (fType == null) {
            continue;
          }

          final classType = fType.toType().getClass();
          final serviceType = Context.getType('jume.di.Service').getClass();

          //         // Make sure the class to inject implements `Service`.
          var implementsService = false;
          if (classType.interfaces != null) {
            for (interfaceRef in classType.interfaces) {
              if (interfaceRef.t.get().name == serviceType.name) {
                implementsService = true;
                break;
              }
            }

            if (implementsService) {
              final path = classType.pack.concat([classType.name]);

              final getterFunc: Function = {
                expr: macro return jume.di.Services.get($p{path}),
                ret: fType,
                args: []
              };

              field.kind = FProp('get', 'never', getterFunc.ret);

              final getter: Field = {
                name: 'get_${field.name}',
                access: [APrivate, AInline],
                kind: FFun(getterFunc),
                pos: Context.currentPos()
              };
              getters.push(getter);
            }
          }

        default:
      }
    } catch (e) {}
  }

  for (getter in getters) {
    fields.push(getter);
  }

  return fields;
}

private function hasMetadata(field: Field, tagName: String): Bool {
  if (field.meta != null) {
    for (tag in field.meta) {
      if (tag.name == tagName) {
        return true;
      }
    }
  }

  return false;
}
#end
