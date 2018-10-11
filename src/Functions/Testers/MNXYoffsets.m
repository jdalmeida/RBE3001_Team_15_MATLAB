xml = xmlread('calibrations/pixels.xml');
xml_pixels = xml.getElementsByTagName('pixel');
pixels = zeros(5,2);
for i = 1:5
   pixels(i, :) = extract_ith_pixel(i-1, xml_pixels);
end

realCoords = [-114.3, 79.1;
              114.3, 79.1;
              0, 0;
              -114.3, 282.3 
              114.3, 282.3];

pixelsXY = zeros(5,2,'single');

% apply mn2xy to all pixel coords and convert to mm
for i = 1:5
    pixelsXY(i,:) = mn2xy(pixels(i, 1), pixels(i, 2)) * 10;
end
xraw = pixelsXY(:, 1);
yraw = pixelsXY(:, 2);

xreal = realCoords(:, 2);
yreal = realCoords(:, 1);

xP = polyfit(xraw, xreal, 1)
yP = polyfit(yraw, yreal, 1)



% burrows into xml object and rips out numbers
function [pix] = extract_ith_pixel(i, pixels)
    pix(1) = str2num(pixels.item(i).getElementsByTagName('m').item(0).getTextContent());
    pix(2) = str2num(pixels.item(i).getElementsByTagName('n').item(0).getTextContent());
end