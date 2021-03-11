%Load original image

image_orig = imread('E:\Work\MATLAB\DIP Assignment 1\Image Files\Main_Image.jpg');
image_reference_original = imread('E:\Work\MATLAB\DIP Assignment 1\Image Files\Hist_Ref_Image.jpg');

%Add your path here                            ^^^^^^^

%%
%Image preprocessing section
image_gray = rgb2gray(image_orig);      %Converting image to grayscale
image_ref_gray = rgb2gray(image_reference_original);      %Converting image to grayscale

%%
%Variable initializations
cdf = zeros([256,1]);
cdf_orig = zeros([256,1]);
cdf_ref = zeros([256,1]);
new_gray_levels_spec = zeros([256,1]);
size_image = size(image_gray, 1) * size(image_gray, 2);      %Finding total number of pixels in image

%%
%Histogram sliding
image_slide = image_gray + 40;

%Histogram stretching
int_min = double(min(image_gray,[],'all'));
int_max = double(max(image_gray,[],'all'));
copy = double(image_gray);
stretch = ((copy - int_min)/(int_max - int_min)) * 255;
image_stretch = uint8(stretch);

original_histogram = hist_conv(image_gray);
reference_histogram = hist_conv(image_ref_gray);

%%
%Histogram equalization
for i = 0:255
    cdf(i+1) = sum(original_histogram(1:i+1)) / size_image;
end

new_gray_levels_eq = cdf * 255;
image_eq = image_gray;

for i = 1 : size(image_gray, 1)
    for j = 1 : size(image_gray, 2)
        image_eq(i,j) = new_gray_levels_eq(image_gray(i,j)+1);
    end
end

%%
%Histogram specification
for i = 0:255
    cdf_orig(i+1) = sum(original_histogram(1:i+1)) / size_image;
    cdf_ref(i+1) = sum(reference_histogram(1:i+1)) / size_image;
end

for i = 1:size(cdf_orig)
    [N, I] = min(abs(cdf_orig(i) - cdf_ref));
    new_gray_levels_spec(i) = I;
end

image_spec = image_gray;
for i = 1 : size(image_gray, 1)
    for j = 1 : size(image_gray, 2)
        image_spec(i,j) = new_gray_levels_spec(image_gray(i,j)+1);
    end
end

%%
%Creating the vectors to plot histograms
slided_histogram = hist_conv(image_slide);
stretched_histogram = hist_conv(image_stretch);
equalized_histogram = hist_conv(image_eq);
specified_histogram = hist_conv(image_spec);

%%
%Plotting
plt_bar(original_histogram, "Original Image", "Original Image Hist.png");
plt_img(image_gray, "Original Image", "Original Image.png");
plt_bar(slided_histogram, "Histogram Sliding", "Histogram Sliding Hist.png");
plt_img(image_slide, "Histogram Sliding", "Histogram Sliding.png");
plt_bar(stretched_histogram, "Histogram Stretching", "Histogram Stretching Hist.png");
plt_img(image_stretch, "Histogram Stretching", "Histogram Stretching.png");
plt_bar(equalized_histogram, "Histogram Equalization", "Histogram Equalization Hist.png");
plt_img(image_eq, "Histogram Equalization", "Histogram Equalization.png");
plt_bar(specified_histogram, "Histogram Specification", "Histogram Specification Hist.png");
plt_img(image_spec, "Histogram Specification", "Histogram Specification.png");
plt_bar(reference_histogram, "Reference Image", "Reference Image Hist.png");
plt_img(image_ref_gray, "Reference Image", "Reference Image.png");

%%

%All Functions

%Function to find histogram of image
function y = hist_conv(image)
    y = zeros([256,1]);
    for count = 0 : 255
        for i = 1 : size(image, 1)
            for j = 1 : size(image, 2)
                if image(i, j) == count
                    y(count + 1) = y(count + 1) + 1;
                end
            end
        end
    end
end

%Function to show the image in the required format and save
function y = plt_img(data, ttl, save)
    figure
    y = imshow(data); title(ttl), saveas(gcf,save);
end

%Functrion to show the histogram in the required format and save it
function y = plt_bar(data, ttl, save)
    figure
    y = bar(data); title(ttl), ylabel("Number of Pixels"), saveas(gcf,save);
end