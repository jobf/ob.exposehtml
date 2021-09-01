# Expose HTML

## What?

A haxelib to help quickly expose parts of your application via the web page it is on.

See the sample project here - https://jobf.github.io/ob.exposehtml/

## Why?

I wanted to be ale change some in game values on a game that had a resolution of 64 x 64 pixels where there is barely enough space for words let alone UI controls.

## How?

### Install

```bash
haxelib git ob.exposehtml https://github.com/jobf/ob.exposehtml.git
```

### Implement

#### Imports

```haxe
import js.Browser.document;
import ob.exposehtml.Expose;
```

#### Using

```haxe
// instatiate the Expose object, passing the document in
var expose = new Expose(document);

// expose a checkbox bound to the sprite visible property
expose.Checkbox(sprite, "visible");

// expose a numeric input bound to the sprite x property
expose.Numeric(sprite, "x");

// expose a button labled 'Click', bound to a function
expose.Button("Click", () -> trace("clicked!"));

// or reference a named function, in this case 'onClick'
expose.Button("Click", onClick);
```


### Caveats

Clearly this only works when haxe target is html5, so if you need multiple targets make sure to use conditionals in your code otherwise builds will fail for non web targets. Example below.


```haxe
// imports
#if web
import js.Browser.document;
import ob.exposehtml.Expose;
#end

// implementation
#if web
var expose = new Expose(document);
expose.Button("etc", doSomething);
#end
```