f=imread("C:\Users\Shikhar\Pictures\daftry.jpg");
f1=f(:,:,1); %TO GET GRAYSCALE IMAGE
figure(1)
imshow(f1);
title("Input Image");
s_img=size(f1);
a1=double(f1); 

%CREATING DCT MATRIX
N=8;
for k=0:N-1
    for n=0:N-1
        if(k==0)
            a=sqrt(1/N);
        else
            a=sqrt(2/N);
        end
        
        X(k+1,n+1)=a*cos(((2*n+1)*pi*k)/(2*N));
    end
end

for x=1:8:s_img(1)-rem(s_img(1),8)
    for y=1:8:s_img(2)-rem(s_img(2),8)
        img(1:8,1:8)=a1(x:x+7,y:y+7); %BLOCK TRANSFORMATION
        trans_img=X.*img.*X'; %APPLYING DCT 
    
        %LUMINANCE QUANTIZATION MATRIX
        mask = [16 11  10 16 24 40 51 61;
                12 12 14 19 26 58 60 55;
                14 13 16 24 40 57 69 56;
                14 17 22 29 51 87 80 62;
                18 22 37 56 68 109 103 77;  
                24 35 55 64 81 104 113 92;
                49 64 78 87 103 121 120 101;
                72 92 95 98 112 100 103 99];
            
        trans_img=floor(trans_img./(mask*0.01)+0.5);
        a1(x:x+7,y:y+7)=trans_img;
    end
end

figure(2)
imshow(uint8(a1));
title("DCT transformed image");

%disp(a1)

MIN = min(min(a1));
MAX = max(max(a1));
A = a1 - MIN;
A = floor((A*255)/(MAX-MIN));

symbols=0:255;
%disp(A)

histObject=histogram(A,256,'Normalization','probability');
p=histObject.Values;    %GETTING PROBABILITIES OF ALL PIXEL INTENSITIES
%size(p)
dict=huffmandict(symbols,p);   %DICTIONARY FOR STORING HUFFMAN CODES

img_vect=A(:);   %VECTOR FOR IMAGE 

comp=huffmanenco(img_vect,dict); %ENCODING IMAGE VECTOR WITH HUFFMAN CODES

binarySig = de2bi(img_vect);
seqLen = size(binarySig);   

compLen = size(comp);       

[compBinaryMat,paddedBin] = vec2mat(comp,8);

compDecimalVec = bi2de(compBinaryMat);

[compDecimalMat,paddedDec] = vec2mat(compDecimalVec,s_img(2));

original_total_bits = s_img(1)*s_img(2)*8;
disp('Bit Length Before Compression: ')
disp(original_total_bits)

compSize = size(uint8(compDecimalMat));
comp_total_bits = compSize(1)*compSize(2)*8;
disp('Bit Length After Compression: ')
disp(comp_total_bits)

Comp_Ratio = original_total_bits/comp_total_bits;
disp('Compression Ratio: ')
disp(Comp_Ratio)



