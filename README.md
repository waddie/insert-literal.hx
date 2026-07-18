# insert-literal.hx

Insert the next keypress literally (`:insert-literal`).

Or, because Helix isn’t great at displaying things like escape characters and
this is probably the main use-case, just suppress pairing on the next keypress
(`:insert-without-pairing`).

## Installation

Install with [forge](https://github.com/mattwparas/steel), Steel’s package
manager:

```sh
forge pkg install --git https://github.com/waddie/insert-literal.hx
```

Then load the plugin in your `init.scm`:

```scheme
(require "insert-literal/insert-literal.scm")
```

## Key bindings

```scheme
(keymap (global)
  (insert
    (C-V ":insert-literal")
    (C-v ":insert-without-pairing")))
```

## Licence

AGPL-3.0-or-later. See [LICENSE](./LICENSE).
