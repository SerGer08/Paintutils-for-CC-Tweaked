# Paintutils+ for CC:Tweaked

It's the new library for CC:Tweaked with corrected square pixels and some new functions
Currently, there are several functions:
- getSize() - returns width and height of terminal relative to square pixels
- drawPixel(xPos, yPos, colour) - draw a pixel at the specified coordinates and with the specified color (if no color is specified then a white pixel is drawn)
- drawLine(startX, startY, endX, endY, colour) - draw a line
- drawBox(startX, startY, endX, endY, colour) - draw an empty box with one pixel thick edges
- drawFilledBox(startX, startY, endX, endY, colour) - draw a filled box
- drawCircle(centerX, centerY, radius, colour) - draw an empty circle with one pixel thick edges
- drawFilledCircle(centerX, centerY, radius, colour) - draw a filled circle

Also this library works with images like original paintutils:
- parseImage(image) - convert the string image scheme to table
- loadImage(path) - load and parse the image
- drawImage(image, xPos, yPos) - draw the image at the specified coordinates

# This library is currenly in Alpha testing, so some functions may change or more new ones may appear. There may also be some errors 
