%Load original image
image_orig = imread('C:\Users\aashi\Pictures\Camera Roll\flower.jpg');
image_reference_original = imread('C:\Users\aashi\Pictures\Camera Roll\p5alvy476di41.jpg');

%%
%Image preprocessing section
image_gray = rgb2gray(image_orig);      %Converting image to grayscale
image_ref_gray = rgb2gray(image_reference_original);      %Converting image to grayscale

%%
%Histogram sliding
image_slide = image_gray + 40;

%%
%Histogram stretching
int_min = double(min(image_gray,[],'all'));
int_max = double(max(image_gray,[],'all'));
copy = double(image_gray);

stretch = ((copy - int_min)/(int_max - int_min)) * 255;

image_stretch = uint8(stretch);

%%
%Forming the vectors to plot histograms
y = zeros([256,1]);
y_ref = zeros([256,1]);
z = zeros([256,1]);
x = zeros([256,1]);
for count = 0 : 255
    for i = 1 : size(image_gray, 1)
        for j = 1 : size(image_gray, 2)
            if image_gray(i, j) == count
                y(count + 1) = y(count + 1) + 1;
            end
            if image_ref_gray(i, j) == count
                y_ref(count + 1) = y_ref(count + 1) + 1;
            end
            if image_slide(i, j) == count
                z(count + 1) = z(count + 1) + 1;
            end
            if image_stretch(i, j) == count
                x(count + 1) = x(count + 1) + 1;
            end
        end
    end
end

%%
%Histogram equalization
n = size(image_gray, 1) * size(image_gray, 2);
cdf = zeros([256,1]);
for i = 0:255
    cdf(i+1) = sum(y(1:i+1)) / n;
end
new_gray_levels = cdf * 255;
image_eq = image_gray;
for i = 1 : size(image_gray, 1)
    for j = 1 : size(image_gray, 2)
        image_eq(i,j) = new_gray_levels(image_gray(i,j)+1);
    end
end

w = zeros([256,1]);
for count = 0 : 255
    for i = 1 : size(image_gray, 1)
        for j = 1 : size(image_gray, 2)
            if image_eq(i, j) == count
                w(count + 1) = w(count + 1) + 1;
            end  
        end
    end
end

%%
%Histogram specification
n = size(image_gray, 1) * size(image_gray, 2);
cdf_orig = zeros([256,1]);
cdf_ref = zeros([256,1]);
for i = 0:255
    cdf_orig(i+1) = sum(y(1:i+1)) / n;
    cdf_ref(i+1) = sum(y_ref(1:i+1)) / n;
end
%Performing histogram mapping
new_gray_val = cdf_orig;
for i = 1:size(cdf_orig)
    [N, I] = min(abs(cdf_orig(i) - cdf_ref));
    new_gray_val(i) = I;
end

image_spec = image_gray;
for i = 1 : size(image_gray, 1)
    for j = 1 : size(image_gray, 2)
        image_spec(i,j) = new_gray_val(image_gray(i,j)+1);
    end
end

v = zeros([256,1]);
for count = 0 : 255
    for i = 1 : size(image_gray, 1)
        for j = 1 : size(image_gray, 2)
            if image_spec(i, j) == count
                v(count + 1) = v(count + 1) + 1;
            end  
        end
    end
end

%%
%Plotting
figure
subplot(1, 2, 1), bar(y), title("Original Image"), ylabel("Number of Pixels")
subplot(1, 2, 2), imshow(image_gray), title("Original Image")
figure
subplot(1, 2, 1), bar(z), title("Histogram Sliding"), ylabel("Number of Pixels")
subplot(1, 2, 2), imshow(image_slide), title("Histogram Sliding")
figure
subplot(1, 2, 1), bar(x), title("Histogram Stretching"), ylabel("Number of Pixels")
subplot(1, 2, 2), imshow(image_stretch), title("Histogram Stretching")
figure
subplot(1, 2, 1), bar(w), title("Histogram Equalization"), ylabel("Number of Pixels")
subplot(1, 2, 2), imshow(image_eq), title("Histogram Equalization")
figure
subplot(1, 2, 1), bar(v), title("Histogram Specification"), ylabel("Number of Pixels")
subplot(1, 2, 2), imshow(image_spec), title("Histogram Specification")
figure
subplot(1, 2, 1), bar(y_ref), title("Reference Image"), ylabel("Number of Pixels")
subplot(1, 2, 2), imshow(image_ref_gray), title("Reference Image")