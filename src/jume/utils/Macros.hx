package jume.utils;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.Tools;

function init() {
  Compiler.registerCustomMetadata({
    metadata: ':inject',
    doc: 'Inject the service of this type.',
    targets: [ClassField],
    platforms: [Js]
  }, 'jume');
}

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

/**
 * Build event classes by adding and object pool and functions to send and reset the event using the class fields.
 * @return The class fields.
 */
function buildEvent(): Array<Field> {
  final fields = Context.getBuildFields();

  final classType = Context.getLocalClass().get();
  final eventType = Context.getLocalType().toComplexType();

  final typePath = { name: classType.name, pack: classType.pack, params: [] };

  // Create an object pool for this event.
  fields.push({
    name: 'pool',
    access: [APrivate, AStatic],
    pos: Context.currentPos(),
    kind: FVar(macro : Array<$eventType>, macro [])
  });

  var putFunction: Field;

  for (field in fields) {
    switch (field.kind) {
      case FFun(func):
        if (field.name == 'put') {
          putFunction = field;
          break;
        }

      default:
    }
  }

  // Create the EventType<Event> parameter for this event.
  final typeParam: FunctionArg = {
    name: 'type',
    type: TPath({
      name: 'EventType',
      pack: ['jume', 'events'],
      params: [TPType(eventType)]
    })
  };

  final paramFields: Array<FunctionArg> = [typeParam];

  for (field in fields) {
    switch (field.kind) {
      // Make all non-static variables of the event public readonly properties
      // and store them to use as parameters later.
      case FVar(fType, fExpr):
        if (!field.access.contains(AStatic)) {
          field.access = [APublic];
          field.kind = FProp('default', 'null', fType, fExpr);

          paramFields.push({ name: field.name, type: fType, value: fExpr });
        }

      // Add non-static public properties to the field parameters.
      case FProp(get, set, fType, fExpr):
        if (!field.access.contains(AStatic) && field.access.contains(APublic)) {
          paramFields.push({
            name: field.name,
            type: fType,
            value: fExpr
          });
        }

      default:
    }
  }

  final paramNames: Array<Expr> = [];
  final assignExprs: Array<Expr> = [];

  // Get all parameter names and assignments.
  for (param in paramFields) {
    final name = param.name;
    paramNames.push(macro $i{param.name});
    assignExprs.push(macro {this.$name = $i{name};});
  }

  // Create the reset function to reset all fields with new values.
  fields.push({
    name: 'reset',
    access: [APrivate],
    pos: Context.currentPos(),
    kind: FFun({
      args: paramFields,
      expr: macro $b{assignExprs}
    })
  });

  // Add a static get function to get an event from the pool.
  fields.push({
    name: 'get',
    access: [APublic, AStatic],
    pos: Context.currentPos(),
    kind: FFun({
      args: paramFields,
      expr: macro {
        var event: $eventType;
        if (pool.length > 0) {
          event = pool.pop();
        } else {
          event = new $typePath();
        }
        event.reset($a{paramNames});

        return event;
      },
      ret: eventType
    })
  });

  // Add a static send function that uses the object pool to recycle events.
  fields.push({
    name: 'send',
    access: [APublic, AStatic],
    pos: Context.currentPos(),
    kind: FFun({
      args: paramFields,
      expr: macro {
        var event: $eventType;
        if (pool.length > 0) {
          event = pool.pop();
        } else {
          event = new $typePath();
        }
        event.reset($a{paramNames});
        jume.di.Services.get(jume.events.Events).sendEvent(event);
      },
      ret: macro : Void
    })
  });

  // Create the put function to put the event back into the object pool.
  if (putFunction == null) {
    fields.push({
      name: 'put',
      pos: Context.currentPos(),
      access: [APublic, AOverride],
      kind: FFun({
        args: [],
        expr: macro {
          super.put();
          pool.push(this);
        }
      })
    });
  } else {
    switch (putFunction.kind) {
      case FFun(func):
        final expr = macro {pool.puh(this);};
        func.expr = macro $b{[func.expr, expr]};

      default:
    }
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
