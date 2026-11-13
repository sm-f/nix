# Build a typed `settings` option for an entity kind that mirrors the aspect
# tree. Copied from den's aspect-settings guide and kept out of the import
# tree (leading underscore in the importing module is enough) so den can read
# the declarations back.
{ den, lib }:
let
  inherit (lib) mkOption types;
  inherit (den.lib.aspects.fx.keyClassification) isStructuralKey;

  # Keys that are pipeline machinery, class content or quirk data, never
  # child aspects.
  skipKey = k: isStructuralKey k || (den.classes or { }) ? ${k} || (den.quirks or { }) ? ${k};

  # `settings` is either a bare attrset of options, or a module with
  # options / config / imports.
  reshape = raw: if raw ? options || raw ? config || raw ? imports then raw else { options = raw; };

  hasSettingsDeep =
    node:
    builtins.isAttrs node
    && (
      node ? settings
      || lib.any (k: !(skipKey k) && hasSettingsDeep (node.${k} or null)) (builtins.attrNames node)
    );

  # One submodule per aspect-tree node. A node can carry its own settings and
  # also be the parent of aspects that do.
  nodeModule =
    node:
    let
      own = reshape (node.settings or { });
      children = lib.filterAttrs (k: v: !(skipKey k) && builtins.isAttrs v && hasSettingsDeep v) node;
    in
    {
      imports = own.imports or [ ];
      config = own.config or { };
      options =
        (own.options or { })
        // lib.mapAttrs (
          name: child:
          mkOption {
            type = types.submodule (nodeModule child);
            default = { };
            description = "Settings under ${name}";
          }
        ) children;
    };
in
types.submodule (nodeModule (den.aspects or { }))
