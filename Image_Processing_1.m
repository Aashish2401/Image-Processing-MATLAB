%Load original image
image_orig = imread('C:\Users\aashi\Pictures\Camera Roll\flower.jpg');
histo = zeros([256,7]);
%%
%All inputs are taken in this section
prompts = {'Enter the value of c', 'Enter the value for power transform:','Enter the value for root transform:', 'Enter the lower limit for intesity slice:','Enter the upper limit for intesity slice:', 'Enter the lower limit for input image:','Enter the upper limit for input image:', 'Enter the lower limit for output image:','Enter the upper limit for output image:'};
i1 = inputdlg(prompts, 'Inputs', [1,100]);
c = str2double(i1{1});
p = str2double(i1{2});
rt = str2double(i1{3});
l = str2double(i1{4});
u = str2double(i1{5});
l1 = str2double(i1{6});
u1 = str2double(i1{7});
l2 = str2double(i1{8});
u2 = str2double(i1{9});

%%
%Image preprocessing section
image_gray = rgb2gray(image_orig);      %Converting image to grayscale

%Title of each transformation performed in the program
image_types = ["Grayscale", "Power", "Root", "Logarithmic", "Exponential", "Intesity Sliced", "Contrast Stretched"];

result_images(:,:,1) = image_gray;      %Initializing variable to store all images

%%
%Calling the function to perform all the point transforms
for i = 2:7
    result_images(:,:,i) = loop(image_gray, i - 1, c, p, rt, l, u, l1, u1, l2, u2);
end

for i  = 1:7
    histo(:,i) = hist_conv(result_images(:,:,i));
end
%%
%Diplaying all images in a single figure
figure
subplot(4,2,1), imshow(image_orig), title('Original')
for i = 2:8
    subplot(4,2,i), imshow(result_images(:,:,i-1)), title(image_types(i-1))
end

for i = 2:8
    figure
    bar(histo(:,i-1)), title(image_types(i-1))
end
%%
%Calling Bitplane slicing
bps(image_gray);

%%
%Function containing all point operations
function y = operate(x, transform, c, p, rt, low, high, low_inp, up_inp, low_out, up_out)
    if transform == 1                   %Power Transform
        y = c * (x^p);
    elseif transform == 2
        y = c * nthroot((255 * x), rt);  %Root Transform
    elseif transform == 3
        y = c * log(1 + x);              %Logarithmic Tranform
    elseif transform == 4
        y = c * (exp(x) - 1);            %Exponential Transform
    elseif transform == 5
        if x >= low && x <= high         %Intensity Slicing
            y = 255;
        else
            y = 0;
        end
    elseif transform == 6                   
        if x <= low_inp                 %Constrast Stretching
            y = x * low_out / low_inp;
        elseif x > low_inp && x < up_inp
            y = x * (up_out - low_out) / (up_inp - low_inp);
        else
            y = x * up_out / up_inp;
        end
    end
end
%%
%Bitplane Slicing Function
function img = bps(orig)
    img(:,:,1) = orig;
    for bits = 1 : 8    
        for i = 1 : size(orig, 1)
            for j = 1 : size(orig, 2)
                img(i, j, bits) = mod(orig(i, j), 2);
                orig(i, j) = floor(orig(i, j) / 2);
            end
        end
    end
    figure
    for i = 1 : 8
        subplot(4,2,i), imshow(logical(img(:,:,i))), title(sprintf("Bitplane %d",i))
    end
end
%%
%Loop function
function img = loop(orig, transform, c, p, rt, l, u, l1, u1, l2, u2)
    img = orig;
    for i = 1 : size(orig, 1)
        for j = 1 : size(orig, 2)
            img(i, j) = operate(double(orig(i, j)), transform, c, p, rt, l, u, l1, u1, l2, u2);
        end
    end
end

%%
%Histogram
function y = hist_conv(image_gray)
    y = zeros([256,1]);
    for count = 0 : 255
        for i = 1 : size(image_gray, 1)
            for j = 1 : size(image_gray, 2)
                if image_gray(i, j) == count
                    y(count + 1) = y(count + 1) + 1;
                end
            end
        end
    end
end