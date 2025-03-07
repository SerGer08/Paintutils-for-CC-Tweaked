-- Additional Functions
local function setUp()
    bgcolour = colours.black
    pixels_data = {}
    local xSize, ySize = term.getSize()
    local prevcolour = colours.black
    local nextcolour = colours.black
    local y = 0

    if ySize%2 == 1 then
        y = ySize*1.5+0.5
    else
        y = ySize*1.5
    end

    for h=1, y do
        table.insert(pixels_data, {})
        for w=1, xSize do
            table.insert(pixels_data[h], {prevcolour, nextcolour})
        end
    end
    SET_UP_IS_COMPLETE = true
end

local function round(x)
    if x-math.floor(x) < 0.5 then
        return math.floor(x)
    else
        return math.ceil(x)
    end
end

-- Main Functions
local function getSize()
    local xSize, ySize = term.getSize()
    return xSize, ySize*1.5
end

local function drawPixel(xPos, yPos, colour)
    if SET_UP_IS_COMPLETE == nil then
        setUp()
    end

    -- Pixel allignment
    xPos = math.floor(xPos)
    yPos = math.floor(yPos)

    -- If pixel color isn't specified, then default pixel color (white) is set
    if colour == nil then
        colour = 0
    end

    -- Exception handler
    if yPos <= #pixels_data and yPos > 0 and xPos <= #pixels_data[1] and xPos > 0 and colour > 0 and colour < 32768 and colour%1 == 0 then

        --[[ 
            There are 3 types of pixels here, separeted by location type where: 
            ● The first type is located like this:  "⎴"
            ● The second type is located like this: "⎶"
            ● The third type is located like this:  "⎵"
            This is because my square pixel occupies 2 thirds of the Computer Craft pixel
        ]]

        -- The first type:
        if (yPos+2)%3 == 0 then
            term.setCursorPos(xPos, (yPos+2)/1.5-1)
            term.setBackgroundColour(pixels_data[(yPos+2)/1.5-1][xPos][2])
            term.setTextColour(colour)
            term.write("\143")
            pixels_data[(yPos+2)/1.5-1][xPos][1] = colour

        -- The second type:
        elseif (yPos+1)%3 == 0 then
            term.setCursorPos(xPos, (yPos+1)/1.5-1)
            term.setTextColour(pixels_data[(yPos+1)/1.5-1][xPos][1])
            term.setBackgroundColour(colour)
            term.write("\143")
            term.setCursorPos(xPos, (yPos+1)/1.5)
            term.setTextColour(colour)
            term.setBackgroundColour(pixels_data[(yPos+1)/1.5][xPos][2])
            term.write("\131")
            pixels_data[(yPos+1)/1.5][xPos][1] = colour
            pixels_data[(yPos+1)/1.5-1][xPos][2] = colour
        
        -- The third type:
        elseif yPos%3 == 0 then
            term.setCursorPos(xPos, yPos/1.5)
            term.setTextColour(pixels_data[yPos/1.5][xPos][1])
            term.setBackgroundColour(colour)
            term.write("\131")
            pixels_data[yPos/1.5][xPos][2] = colour
        end
    end
end

local function drawLine(startX, startY, endX, endY, colour)
    local w, h = getSize()

    local k = (endY-startY)/(endX-startX)
    if math.abs(endX-startX) > math.abs(endY-startY) then
        for x = math.max(startX, 0), math.min(endX, w), (endX-startX)/math.abs(endX-startX) do
            drawPixel(x, round(k*(x-startX)+startY), colour)
        end
    else
        for y = math.max(startY, 0),  math.min(endY, h), (endY-startY)/math.abs(endY-startY) do
            drawPixel(round((y-startY)/k+startX), y, colour)
        end
    end
end

local function drawBox(startX, startY, endX, endY, colour)
    local w, h = getSize()

    -- exeption handler for values that are too large or too small
    if startX < 1 then startX = 0 end
    if endX > w then endX = w + 1 end
    if startY < 1 then startY = 0 end
    if endY > h then endY = h + 2 end

    -- vertex adjustments
    if startX > endX then startX, endX = endX, startX end
    if startY > endY then startY, endY = endY, startY end
    if endX-startX > 0 and endX-startX > 0 then
        for i=0, endX-startX-1 do
            drawPixel(startX+i, startY, colour)
        end
        for col=0, endY-startY-1 do
            drawPixel(startX, startY+col, colour)
            drawPixel(endX, startY+col, colour)
        end
        for i=0, endX-startX do
            drawPixel(startX+i, endY, colour)
        end
    end
end

local function drawFilledBox(startX, startY, endX, endY, colour)
    local w, h = getSize()

    -- exeption handler for values that are too large or too small
    if startX < 1 then startX = 0 end
    if endX > w then endX = w + 1 end
    if startY < 1 then startY = 0 end
    if endY > h then endY = h + 2 end

    -- vertex adjustments
    if startX > endX then startX, endX = endX, startX end
    if startY > endY then startY, endY = endY, startY end
    if endX-startX > 0 and endX-startX > 0 then
        for col=0, endY-startY-1 do
            for i=0, endX-startX-1 do
                drawPixel(startX+i, startY+col, colour)
            end
        end
    end
end


local function drawCircle(centerX, centerY, radius, colour)
    local w, h = getSize()

    -- Center and radius allignment
    centerX = round(centerX)
    centerY = round(centerY)
    radius = math.abs(round(radius))

    -- draw 2 radii and fill the space between them
    local r = (radius + 0.25)^2 + 1
    local r_min
    if radius > 1 then
        r_min = (radius - 0.75)^2 + 1
    else
        r_min = (radius - 1)^2 + 1
    end
    for yPos = math.max(radius*-1, -centerY), math.min(radius, h-centerY) do
        for xPos = math.max(radius*-1, -centerX), math.min(radius, w-centerX) do
            if yPos^2+xPos^2 >= r_min and yPos^2+xPos^2 <= r then
                drawPixel(centerX+xPos, centerY+yPos, colour)
            end
        end
    end
end

local function drawFilledCircle(centerX, centerY, radius, colour)
    local w, h = getSize()

    -- Center and radius allignment
    centerX = round(centerX)
    centerY = round(centerY)
    radius = math.abs(round(radius))

    local r = (radius + 0.25)^2 + 1
    for yPos = math.max(radius*-1, -centerY), math.min(radius, h-centerY+1) do
        for xPos = math.max(radius*-1, -centerX), math.min(radius, w-centerX) do
            if yPos^2+xPos^2 <= r then
                drawPixel(centerX+xPos, centerY+yPos, colour)
            end
        end
    end
end

local function drawSimpleFilledTriangle(p1, p2, p3, colour)
    local w, h = getSize()

    local k1 = (p2[2]-p1[2])/(p2[1]-p1[1])
    local k2 = (p2[2]-p3[2])/(p2[1]-p3[1])

    local step = 1
    if p2[2] < p1[2] then
        step = -1
    end

    for y = math.max(p1[2], 0), math.min(p2[2], h), step do
        local x1 = (y-p1[2])/k1+p1[1]
        local x2 = (y-p3[2])/k2+p3[1]
        for x = math.max(math.min(p1[1], p2[1]), 0), math.min(math.max(p3[1], p2[1])+2, w) do
            local y1
            local y2
            if p2[2] < p1[2] then
                y1 = k1*(x-p1[1])+p1[2]
                y2 = k2*(x-p3[1])+p3[2]
            else
                y1 = round(k1*(x-p1[1])+p1[2])
                y2 = round(k2*(x-p3[1])+p3[2])
            end
            if x >= x1 and x <= x2 then
                drawPixel(x, y, colour)
            else
                if y1 >= math.min(p1[2], p2[2]) and y1 <= math.max(p1[2], p2[2]) then
                    drawPixel(x, y1, colour)
                end
                if y2 >= math.min(p1[2], p2[2]) and y2 <= math.max(p1[2], p2[2]) then
                    drawPixel(x, y2, colour)
                end
            end
        end
    end
end

local function drawFilledTriangle(p1, p2, p3, colour)
    if p2[2] ~= math.max(p1[2], p2[2], p3[2]) and p2 ~= math.min(p1[2], p2[2], p3[2]) then
        p2, p1 = p1, p2
    end

    if p1[1] > p3[1] then
        p1, p3 = p3, p1
    end

    if p1[2] > p3[2] then
        local k = (p2[2]-p3[2])/(p2[1]-p3[1])
        local p4 = (p1[2]-p3[2])/k+p3[1]
        drawSimpleFilledTriangle(p1, p2, {p4, p1[2]}, colour)
        drawSimpleFilledTriangle(p1, p3, {p4, p1[2]}, colour)
    elseif p1[2] < p3[2] then
        local k = (p2[2]-p1[2])/(p2[1]-p1[1])
        local p4 = (p3[2]-p1[2])/k+p1[1]
        drawSimpleFilledTriangle({p4, p3[2]}, p2, p3, colour)
        drawSimpleFilledTriangle({p4, p3[2]}, p1, p3, colour)
    else
        drawSimpleFilledTriangle(p1, p2, p3, colour)
    end
end

local function drawFigure(coordinates, colour)
    for i=2, #coordinates do
        local startX = coordinates[i-1][1]
        local startY = coordinates[i-1][2]
        local endX = coordinates[i][1]
        local endY = coordinates[i][2]
        drawLine(startX, startY, endX, endY, colour)
    end

    local startX = coordinates[1][1]
    local startY = coordinates[1][2]
    local endX = coordinates[#coordinates][1]
    local endY = coordinates[#coordinates][2]
    drawLine(startX, startY, endX, endY, colour)
end

-- Image working functions
local function parseImage(image)
    local tImage = {}
    local i = 1
    for line in (image .. "\n"):gmatch("(.-)\n") do
        table.insert(tImage, {})
        for x=1, #line do
            local colour
            if string.sub(line, x, x) ~= ' ' then
                if string.byte(string.sub(line, x, x))-87 < 10 then
                    colour = 2^(string.byte(string.sub(line, x, x))-48)
                else
                    colour = 2^(string.byte(string.sub(line, x, x))-87)
                end
            else
                colour = 0
            end
            table.insert(tImage[i], colour)
        end
        i = i+1
    end
    return tImage
end

local function loadImage(path)
    if fs.exists(path) then
        local file = io.open(path, "r")
        local sContent = file:read("a")
        file:close()
        return parseImage(sContent)
    end
    return nil
end

local function drawImage(image, xPos, yPos)
    for y=1, #image do
        for x=1, #image[y] do
            drawPixel(x+xPos-1, y+yPos-1, image[y][x])
        end
    end
end

return {getSize = getSize, drawPixel = drawPixel, drawLine = drawLine,
drawBox = drawBox, drawFilledBox = drawFilledBox,
drawCircle = drawCircle, drawFilledCircle = drawFilledCircle,
parseImage = parseImage, loadImage = loadImage, drawImage = drawImage,}
