
function [x,y,score] = detection(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%

% compute the feature map for the image
f = hog(I);

nori = size(f,3);

% cross-correlate template with feature map to get a total response
R = zeros(size(f,1),size(f,2));
for i = 1:nori
  R = R + imfilter(f(:,:,i), template(:,:,i), 'symmetric');
end

% now return locations of the top ndet detections

% sort response from high to low
[val,ind] = sort(R(:),'descend');

% work down the list of responses, removing overlapping detections as we go
i = 1;
detcount = 0;
while ((detcount < ndet) && (i < length(ind)))
  % convert ind(i) back to (i,j) values to get coordinates of the block
  s = [size(f,1), size(f,2)];
  [yblock,xblock] = ind2sub(s, ind(i));

  assert(val(i)==R(yblock,xblock)); %make sure we did the indexing correctly

  % now convert yblock,xblock to pixel coordinates 
  ypixel = 8*yblock;
  xpixel = 8*xblock;

  % check if this detection overlaps any detections which we've already added to the list
  
  overlap = 0;
  if (detcount ~= 0)
      distance = sqrt((y-ypixel).^2 + (x-xpixel).^2);
      if (sum(distance < 115) >= 1)
          overlap = 1;
      end
  end

  % if not, then add this detection location and score to the list we return
  if (~overlap)
    detcount = detcount+1;
    x(detcount) = xpixel;
    y(detcount) = ypixel;
    score(detcount) = R(yblock,xblock);
  end
  i = i + 1;
end


