%Load original image

image_orig = imread('C:\Users\aashi\Pictures\Camera Roll\flower.jpg');

%%
%Image preprocessing section

image_gray = rgb2gray(image_orig);      %Converting image to grayscale

%%
%filter parameters

inp = inputdlg("Enter kernel size:");
kernel_size = str2double(inp{1});
kernel_box  = ones(kernel_size, kernel_size);
kernel_gaussian = [1 2 1; 2 4 2; 1 2 1];
div_box = sum(kernel_box, 'all');
div_gauss = sum(kernel_gaussian, 'all');
step = 1;
mid = (kernel_size +1) / 2;

%%
%Operation

box_filtered = double(image_gray);  %Type convertion to perform operations
gaussian_filtered = double(image_gray);
median_filtered = double(image_gray);
min_filtered = double(image_gray);
max_filtered = double(image_gray);
midpoint_filtered = double(image_gray);
for i = 1 : step : (size(image_gray, 1) - (kernel_size - 1))
    for j = 1 : step : (size(image_gray, 2) - (kernel_size - 1))
        box = double(image_gray(i:i+(kernel_size-1), j:j+(kernel_size-1)));
        intermediate = box .* kernel_box; 'all';
        arr = intermediate(:).';
        arr = sort(arr);
        minval = arr(1);
        maxval = arr(kernel_size ^ 2);
        median = arr(((kernel_size ^ 2) + 1) / 2);
        median_filtered(i+mid, j+mid) = median;
        min_filtered(i+mid, j+mid) = minval;
        max_filtered(i+mid, j+mid) = maxval;
        midpoint_filtered(i+mid, j+mid) = (minval + maxval) / 2;
        box_filtered(i+mid, j+mid) = (sum(intermediate, 'all') / sum(kernel_box, 'all'));
        gaussian_filtered(i+mid, j+mid) = sum(double(image_gray(i:i+2, j:j+2)) .* kernel_gaussian, 'all') / sum(kernel_gaussian, 'all');
    end
end

final_min = uint8(min_filtered);
final_max = uint8(max_filtered);
final_mid = uint8(midpoint_filtered);
final_median = uint8(median_filtered);
final_gaussian = uint8(gaussian_filtered);
final_box = uint8(box_filtered);
unsharp_mask = image_gray - final_box;
sharpened_image = image_gray + unsharp_mask;

%%
%Printing images

figure, imshow(image_gray), title("Grayscale Image");
figure, imshow(final_box), title("Filtered Image");
figure, imshow(sharpened_image), title("Sharpened image");
figure, imshow(final_gaussian), title("Weighted Average Image");
figure, imshow(final_min), title("Min Filtered Image");
figure, imshow(final_max), title("Max Filtered Image");
figure, imshow(final_mid), title("Midpoint Filtered Image");
figure, imshow(final_median), title("Median Filtered image");
figure, imshow(unsharp_mask), title("Unsharp Mask");