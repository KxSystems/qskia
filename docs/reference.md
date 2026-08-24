# Skia Module Reference

The code examples below assume that the Skia module has been loaded into a variable named `skia`, i.e.
```q
skia:use`kx.skia
```
The type names used in this document have the following meanings:
|Type   |Description|
|-------|-----------|
|string |`char` list|
|integer|`short`, `int` or `long`|
|float  |`float` or `real`|


## `init`
Initialize the `skia` module.

### Parameters
|Name      |Type         |Description|
|----------|-------------|-----------|
|`fontpath`|string/symbol|Path to fonts|


### Example
```q
fp:$[not ""~cp:getenv `CONDA_PREFIX;cp;.Q.rp "::../"] // font path: $CONDA_PREFIX or this directory
skia.init[fp]
```

## `new`
Creates a new Skia foreign object.

### Parameters
|Name    |Type   |Description|
|--------|-------|-----------|
|`width` |integer|Canvas width in pixels|
|`height`|integer|Canvas height in pixels|

### Returns
|Type   |Description|
|-------|-----------|
|foreign|A Skia foreign object|

### Example
```
s:skia.new[320;240]
```

## `delete`
Delete a Skia foreign object.

|Name  |Type   |Description|
|------|-------|-----------|
|`skia`|foreign|Skia foreign object|

### Example
```q
skia.delete[s]
```

## `setStrokeColour`
Set the colour of lines and shape borders.

### Parameters
|Name  |Type   |Description|
|------|-------|-----------|
|`skia`|foreign|Skia foreign object|
|`argb`|integer|ARGB colour value|

### Example
```q
skia.setStrokeColour[s;0x0 sv"x"$255 0 255 0]
```

## `setStrokeWidth`
Set the width of lines and shape borders.

### Parameters
|Name   |Type         |Description|
|-------|-------------|-----------|
|`skia` |foreign      |Skia foreign object|
|`width`|float/integer||


## `setFillColour`
Set the interior colour of shapes.

### Parameters
|Name  |Type   |Description|
|------|-------|-----------|
|`skia`|foreign|Skia foreign object|
|`argb`|integer|ARGB colour value|

### Example
```q
skia.setFillColour[s;0x0 sv"x"$255 0 0 255]
```

## `addCirle`
Add a cirle to the image.

### Parameters
|Name  |Type         |Description|
|------|-------------|-----------|
|`skia`|foreign      |Skia foreign object|
|`x`   |float/integer|x coordinate of circle's centre|
|`y`   |float/integer|y coordinate of circle's centre|
|`r`   |float/integer|circle's radius|

## `addLine`
Add a line segment to the image.

### Parameters
|Name  |Type         |Description|
|------|-------------|-----------|
|`skia`|foreign      |Skia foreign object|
|`x1`  |float/integer|x coordinate of line segment's start point|
|`y1`  |float/integer|y coordinate of line segment's start point|
|`x2`  |float/integer|x coordinate of line segment's end point|
|`y2`  |float/integer|y coordinate of line segment's end point|

## `addDashedLine`
Add a dashed line segment to the image.

### Parameters
|Name  |Type         |Description|
|------|-------------|-----------|
|`skia`|foreign      |Skia foreign object|
|`x1`  |float/integer|x coordinate of line segment's start point|
|`y1`  |float/integer|y coordinate of line segment's start point|
|`x2`  |float/integer|x coordinate of line segment's end point|
|`y2`  |float/integer|y coordinate of line segment's end point|
|`on`  |float/integer|length of filled interval|
|`off` |float/integer|length of unfilled interval|

## `addRect`
Add a rectangle to the image.

### Parameters
|Name    |Type         |Description|
|--------|-------------|-----------|
|`skia`  |foreign      |Skia foreign object|
|`x`     |float/integer|x coordinate of top left corner|
|`y`     |float/integer|y coordinate of top left corner|
|`width` |float/integer|rectangle's width|
|`height`|float/integer|rectangle's height|

## `addPath`
Draw a path.

### Parameters
|Name   |Type     |Description|
|-------|---------|-----------|
|`skia` |foreign  |Skia foreign object|
|`close`|bool     |Is the path closed?|
|`xs`   |real list|x coordinates of path points|
|`xs`   |real list|y coordinates of path points|

### Example
```q
skia.addPath[s;0b;"e"$0 64 128 192 256 320;"e"$120 100 120 100 120 100]
```

## `addPixels`
Add a block of pixels to the image.

### Parameters
|Name    |Type        |Description|
|--------|------------|-----------|
|`skia`  |foreign     |Skia foreign object|
|`width` |integer     |pixel column count; must be zero or greater|
|`height`|integer     |pixel row count; must be zero or greater|
|`px`    |integer     |top left x coordinate|
|`py`    |integer     |top left y coordinate|
|`pixels`|integer list|RGBA pixel data|

### Example
Add a 10×10 red square to the centre of the image.
```q
s:skia.new[320;240]
p:100#0x0 sv"x"$255 0 0 255
skia.addPixels[s;10;10;155;115;p]
```

## `multiFillCircle`
Add multiple filled circles to the image.

### Parameters
|Name  |Type     |Description|
|------|---------|-----------|
|`skia`|foreign  |Skia foreign object|
|`ys`  |real list|y coordinates|
|`rs`  |real list|radii |
|`ffs` |int list |ARGB fill colours|

## `multiStrokeCircle`
Add multiple stroked circles to the image.

### Parameters
|Name  |Type     |Description|
|------|---------|-----------|
|`skia`|foreign  |Skia foreign object|
|`xs`  |real list|x coordinates|
|`ys`  |real list|y coordinates|
|`rs`  |real list|radii |
|`cs`  |int list |ARGB stroke colours|
|`ws`  |real list|stroke widths|

## `multiFillRect`
Add multiple filled rectangles to the image.

### Parameters
|Name  |Type     |Description|
|------|---------|-----------|
|`skia`|foreign  |Skia foreign object|
|`xs`  |real list|top left corner x coordinates|
|`ys`  |real list|top left corner y coordinates|
|`ws`  |real list|widths|
|`hs`  |real list|heights|
|`ffs` |int list |ARGB fill colours|

## `multiStrokeRect`
Add multiple stroked rectangles to the image.

### Parameters
|Name  |Type     |Description|
|------|---------|-----------|
|`skia`|foreign  |Skia foreign object|
|`xs`  |real list|top left corner x coordinates|
|`ys`  |real list|top left corner y coordinates|
|`ws`  |real list|widths|
|`hs`  |real list|heights|
|`ffs` |int list |ARGB stroke colours|
|`sws` |real list|stroke widths|

## `multiLine`
Add multiple line segments to the image.

### Parameters
|Name  |Type       |Description|
|------|-----------|-----------|
|`skia`|foreign    |Skia foreign object|
|`x1`  |real list  |x coordinate of start points|
|`y1`  |real list  |y coordinate of start points|
|`x2`  |real list  |x coordinate of end points|
|`y2`  |real list  |y coordinate of end points|
|`ffs` |int list   |ARGB fill colours|
|`sws` |real list  |stroke widths|

## `multiFillPath`
Draw multiple paths.

### Parameters
|Name   |Type              |Description|
|-------|------------------|-----------|
|`skia` |foreign           |Skia foreign object|
|`close`|bool list         |Is the path closed?|
|`xs`   |list of real lists|x coordinates of path points|
|`xs`   |list of real lists|y coordinates of path points|
|`fs`   |int list          |ARGB fill colours|

## `multiStrokePath`
Draw multiple stroked paths.

### Parameters
|Name   |Type              |Description|
|-------|------------------|-----------|
|`skia` |foreign           |Skia foreign object|
|`close`|bool list         |Is the path closed?|
|`xs`   |list of real lists|x coordinates of path points|
|`xs`   |list of real lists|y coordinates of path points|
|`fs`   |int list          |ARGB stroke colours|
|`ws`   |real list         |stroke widths|

## `rotate`
Roate canvas.

### Parameters
|Name     |Type      |Description|
|---------|----------|-----------|
|`skia`   |foreign   |Skia foreign object|
|`degrees`|real/float|amount to rotate, in degrees|
|`x`      |real/float|x-axis value of the point to rotate about|
|`y`      |real/float|y-axis value of the point to rotate about|

## `restore`
Remove effects of calling `rotate`.

### Parameters
|Name   |Type   |Description|
|-------|-------|-----------|
|`skia` |foreign|Skia foreign object|

## `toPNG`
Render the image to a PNG.

### Parameters
|Name  |Type   |Description|
|------|-------|-----------|
|`skia`|foreign|Skia foreign object|

### Returns
|Type     |Description|
|---------|-----------|
|byte list|PNG as a byte list|

### Example
```q
i:skia.toPNG[s]
```

## `toRGB`
Render the image to a RGB byte list.

### Parameters
|Name  |Type   |Description|
|------|-------|-----------|
|`skia`|foreign|Skia foreign object|

### Returns
|Type     |Description|
|---------|-----------|
|byte list|byte list of RGB values|

### Example
```q
i:skia.toRGB[s]
```

## `setFontFace`
Set font face.

### Parameters
|Name        |Type         |Description|
|------------|-------------|-----------|
|`skia`      |foreign      |Skia foreign object|
|`fontFamily`|string/symbol|`regular` or `monospace`|
|`bold`      |bool         ||
|`italic`    |bool         ||

## `setFontSize`
Set font size.

### Parameters
|Name      |Type   |Description|
|----------|-------|-----------|
|`skia`    |foreign|Skia foreign object|
|`fontSize`|integer||

## `addText`
Add text to the image.

### Parameters
|Name  |Type         |Description|
|------|-------------|-----------|
|`skia`|foreign      |Skia foreign object|
|`x`   |numeric      |start of text on x-axis
|`y`   |numeric      |start of text on y-axis
|`str` |string/symbol|Text to add|

## `addTextMiddleAnchor`
Add middle aligned text to the image.

### Parameters
|Name  |Type         |Description|
|------|-------------|-----------|
|`skia`|foreign      |Skia foreign object|
|`x`   |numeric      |start of text on x-axis
|`y`   |numeric      |start of text on y-axis
|`str` |string/symbol|Text to add|

## `addTextLeftAnchor`
Add left aligned text to the image.

### Parameters
|Name  |Type         |Description|
|------|-------------|-----------|
|`skia`|foreign      |Skia foreign object|
|`x`   |numeric      |start of text on x-axis
|`y`   |numeric      |start of text on y-axis
|`str` |string/symbol|Text to add|

## `addTextRightAnchor`
Add right aligned text to the image.

### Parameters
|Name  |Type         |Description|
|------|-------------|-----------|
|`skia`|foreign      |Skia foreign object|
|`x`   |numeric      |start of text on x-axis
|`y`   |numeric      |start of text on y-axis
|`str` |string/symbol|Text to add|

## `textWidth`
Measure text width.

### Parameters
|Name  |Type         |Description|
|------|-------------|-----------|
|`skia`|foreign      |Skia foreign object|
|`str` |string/symbol|Text to mesaure|

### Returns
|Type |Description|
|-----|-----------|
|float|text width |
