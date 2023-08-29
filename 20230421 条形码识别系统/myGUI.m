function myGUI
    % 创建一个figure窗口
    f = figure('Name', '条形码识别系统','Position', [200, 200, 1000, 600]);

    % 创建下拉菜单
    noiseMethods = {'高斯噪声', '椒盐噪声', '泊松噪声'};
    filterMethods = {'均值滤波', '中值滤波', '高斯滤波'};
    decodingMethods = {'宽度测量法译码', '平均值法译码', '相似边距离法译码'};

    noiseDropdown = uicontrol('Style', 'popupmenu', 'String', strjoin(noiseMethods, '|'), 'Position', [20, 500, 150, 30]);
    filterDropdown = uicontrol('Style', 'popupmenu', 'String', strjoin(filterMethods, '|'), 'Position', [20, 400, 150, 30]);
    decodingDropdown = uicontrol('Style', 'popupmenu', 'String', strjoin(decodingMethods, '|'), 'Position', [20, 300, 150, 30]);

    % 创建文本框
    errorRateText = uicontrol('Style', 'text', 'String', '误码率结果：', 'Position', [0, 250, 200, 20]);
    decodingResultText = uicontrol('Style', 'text', 'String', '译码结果：', 'Position', [0, 220, 200, 20]);

    % 创建按钮
    uicontrol('Style', 'pushbutton', 'String', '打开图片文件', 'Position', [20, 160, 150, 30], 'Callback', @openImage);
    uicontrol('Style', 'pushbutton', 'String', '加噪', 'Position', [20, 120, 150, 30], 'Callback', @addNoise);
    uicontrol('Style', 'pushbutton', 'String', '滤波', 'Position', [20, 80, 150, 30], 'Callback', @filtering);
    uicontrol('Style', 'pushbutton', 'String', '二值化', 'Position', [20, 40, 150, 30], 'Callback', @binarize);
    uicontrol('Style', 'pushbutton', 'String', '译码', 'Position', [20, 0, 150, 30], 'Callback', @decoding);

    % 创建图形显示区域
    originalAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [200, 300, 350, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '原图:', 'Position', [320, 550, 100, 20]);
    noiseAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [600, 300, 350, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '加噪图:', 'Position', [720, 550, 100, 20]);
    filteredAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [200, 20, 350, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '二值化图:', 'Position', [720, 250, 100, 20]);
    binarizedAxes = axes('Parent', f, 'Units', 'pixels', 'Position', [600, 20, 350, 250]);
    uicontrol('Parent', f, 'Style', 'text', 'String', '滤波图:', 'Position', [320, 250, 100, 20]);
    % 全局变量
    originalImage = [];
    noiseImage = [];
    filteredImage = [];
    binarizedImage =[];
    function openImage(hObject, eventdata)
        [filename, pathname] = uigetfile({'*.bmp;*.jpg;*.png', 'Image files (*.bmp, *.jpg, *.png)'}, '选择图片文件');
        if isequal(filename, 0) || isequal(pathname, 0)
            return;
        end
        originalImage = imread(fullfile(pathname, filename));
        axes(originalAxes);
        imshow(originalImage);
    end

    function addNoise(hObject, eventdata)
        if isempty(originalImage)
            return;
        end
        method = noiseMethods{get(noiseDropdown, 'Value')};
        switch method
            case '高斯噪声'
                noiseImage = imnoise(originalImage, 'gaussian');
            case '椒盐噪声'
                noiseImage = imnoise(originalImage, 'salt & pepper');
            case '泊松噪声'
                noiseImage = imnoise(originalImage, 'poisson');
        end
        axes(noiseAxes);
        imshow(noiseImage);
    end

    function filtering(hObject, eventdata)
        if isempty(noiseImage)
            return;
        end
        method = filterMethods{get(filterDropdown, 'Value')};
        switch method
            case '均值滤波'
                noiseImage = im2gray(noiseImage);
                filteredImage = imgaussfilt(noiseImage);
                % 滤波器大小 
                filter_size = 1; 
                % 均值滤波核 
                kernel = ones(filter_size) / filter_size^2; 
                % 进行均值滤波
                filteredImage = imfilter(filteredImage, kernel); 
                
%                 disp(size(filteredImage))
                
            case '中值滤波'
                noiseImage = im2gray(noiseImage);
                filteredImage = medfilt2(noiseImage);
            case '高斯滤波'
                noiseImage = im2gray(noiseImage);
                filteredImage = imgaussfilt(noiseImage, 0.001);
        end
        axes(filteredAxes);
        imshow(filteredImage);

        % 计算误码率
        if numel(originalImage) == 2
            imageSize = numel(originalImage);
            differentPixels = sum(sum(originalImage ~= filteredImage));
            errorRate = differentPixels / imageSize;
        else
            originalGray = im2gray(originalImage);
            filteredGray = im2gray(filteredImage);
            imageSize = numel(originalGray);
            differentPixels = sum(sum(originalGray ~= filteredGray));
            errorRate = differentPixels / imageSize;
        end
        
        set(errorRateText, 'String', sprintf('误码率结果：%f', errorRate));
    end


    function binarize(hObject, eventdata)
        if isempty(filteredImage)
            return;
        end
        
%         grayFilteredImage = rgb2gray(filteredImage);
        binarizedImage = imbinarize(filteredImage);
        axes(binarizedAxes);
        imshow(binarizedImage);
    end

    function decoding(hObject, eventdata)
        t = 1;
        p = 1;
        bw = binarizedImage;
        [m n] = size(bw);
        %初步计数黑白条的书目
        q = round(m/2);
            for i=q
                for j=1:n-1
                    if bw(i,j)==0&&bw(i,j+1)==1%颜色变化由黑色变成白色，黑条
                        x(t) = j;
                         t = t+1;
                    end

                end
            end

        for i=q
            for j=1:n-1
                if bw(i,j)==1&&bw(i,j+1)==0 %颜色变化由白色变成黑色，白条
                    y(p) = j;
                     p = p+1;
                end

            end
        end
        pin = 0;
         while length(x)~=30||length(y)~=30
             %%等待提示信息
                if pin ==0
                display('正在扫码，请对准而条形码............');
                end
                pin = pin+1;
             %条形码有损坏是逐行扫描
               for pp=q:round(5*m/6)
                   t=1;
                   p=1;
                    if length(x)==30&&length(y)==30 %通过判断黑白条数测试当前行有无算坏
                        break;
                    end
                        for i=pp
                            for j=1:n-1
                                if bw(i,j)==0&&bw(i,j+1)==1
                                    x(t) = j;
                                    t = t+1;
                                end
                            end
                        end
                        for i=pp
                            for j=1:n-1
                                if bw(i,j)==1&&bw(i,j+1)==0
                                    y(p) = j;
                                    p = p+1;
                                end

                            end
                        end
               end
         end 
         if length(x)~=30||length(y)~=30
             display('扫码错误！');
             return;
         end
         if i~=round(m/2)
             display('该条形码已受损，但仍然可以正常扫描');
         end
        %计算每个条—空的宽度，利用所记录在xy数组中的坐标值，对应相减
         for ii=1:30
            if ii==1
                d(ii)=x(ii)-y(ii);      %计算第一个条的宽度
                d(ii+1)=y(ii+1)-x(ii);  %计算第一个空的宽度
            end
             if ii>1
                 if ii>1&&ii<30
                d(2*ii) = y(ii+1)-x(ii); %分别计算第2~29个空的宽度
                d(2*ii-1)=x(ii)-y(ii);   %分别计算第2~29个条的宽度
             elseif ii==30
                 d(ii*2-1)=x(ii)-y(ii);   %总共有59个条-空，单独计算第三十个条的宽度
                 end
             end    
        end

        j  = 3;
        for i=1:6               
            r(i)=(d(j+1)+d(j+2)+d(j+3)+d(j+4))/7;       %计算左边六个字的基准码的宽度
        end
        j=32;
        for i=7:12
            r(i)=(d(j+1)+d(j+2)+d(j+3)+d(j+4))/7;       %计算右边五个字的基准码的宽度
        end
        n=0;%四字计数
        i=1;
        j1=1;
        j=4;%跳过起始符，从左边第一个开始读码
        flag0=0;%作为标识符，将样条交替翻译成1或者0
        while j<=56
            if n==4
                n=0;
                i=i+1;
            end
            if d(j)<0.5*r(i)%小于0.5舍去
                return;
            elseif d(j)<1.5*r(i)&&d(j)>0.5*r(i)%0.5~1.5记为1个值
                if flag0==0
                    bs(j1)={'0'};%对于的被译码
                else
                     bs(j1)={'1'};   
                end
               j1=j1+1;
            elseif (d(j)>=1.5*r(i))&&(d(j)<2.5*r(i))%1.5~2.5记为2个值
                if flag0==0
                    bs(j1)={'00'};
                else
                    bs(j1)={'11'};
                end
               j1=j1+1;
            elseif (d(j)>=2.5*r(i))&&(d(j)<3.5*r(i))%2.5~3.5记为3个值
               if flag0==0
                   bs(j1)={'000'};
               else
                   bs(j1)={'111'};
               end
               j1=j1+1;
            elseif (d(j)>=3.5*r(i))&&(d(j)<4.5*r(i))%3.5~4.5记为4个值
               if flag0==0
                   bs(j1)={'0000'};
               else
                   bs(j1)={'1111'};
               end
               j1=j1+1;
            else
                return;
            end

            n=n+1;

            if flag0==0
                flag0=1;
            else
                flag0=0;
            end

            if j==27%跳过中间位分隔符，由5个模块构成
                j=j+5;
                flag0=1;
            end

            j=j+1;
        end
        for i = 1:12
            gan(i) = bs(i*4-3); %记录每个字符对应的第一个码的编码
            for j=4*i-2:4*i
                gan(i) = strcat(gan(i),bs(j));%把一个字对应的四个码链接起来
            end
        end
        A={'0001101','0011001','0010011','0111101','0100011','0110001','0101111','0111011','0110111','0001011'}; %A子集     3 5
        B={'0100111','0110011','0011011','0100001','0011101','0111001','0000101','0010001','0001001','0010111'}; %B子集     2 4
        C={'1110010','1100110','1101100','1000010','1011100','1001110','1010000','1000100','1001000','1110100'}; %C子集  
        %不同首字的奇偶排列规则表，1为A，0为B
        D=[1,1,1,1,1,1;1,1,0,1,0,0;1,1,0,0,1,0;1,1,0,0,0,1;1,0,1,1,0,0;1,0,0,1,1,0; ...
            1,0,0,0,1,1;1,0,1,0,1,0;1,0,1,0,0,1;1,0,0,1,0,1];
        %由于左边字符的译码对应方式与起始字符有关系下面使用分别对应的方式分析，
        %使本设计作品能译出各种开头的EAN-13码
        DC(1:6)=1;
        j = 8;
        for i=3:7
            if (d(j+1)+d(j+3))>2.5*r(i)&&(d(j+1)+d(j+3))<3.5*r(i)||d(j+1)+d(j+3)>4.5*r(i) %对应为3，5，说明使用A集解码
                DC(i-1)=1;
            elseif (d(j+1)+d(j+3))>3.5*r(i)&&(d(j+1)+d(j+3))<4.5*r(i)||d(j+1)+d(j+3)<2.5*r(i)%对应为2，4，说明使用B集解码
                DC(i-1)=0;
            else
                DC(1:6)=0;
            end
            j=j+4;
        end
        %使用DC确定首字
        pre_num = 10;   %从10开会向下扫面，扫到break是就对应首字
        for i=1:10
            if D(i,:) == DC
                pre_num =  i-1;
                break;
            end
        end
        %当首字出现为两位数时证明扫描出错，直接返回
         if  pre_num ==10
             display('译码出错！');
             return;
         end
        gen(1:13) = 0;
        gen(1) = pre_num;%第一个字符直接赋值上面求得的首字
        for j=1:6
            %对左边六个字解码，使用A集
            if D(pre_num+1,j)==1
                for i=1:10  %逐行扫描与A集比较
                    if strcmp(A(i),gan(j))
                        gen(j+1)=i-1; %获得对应对应的解码结果
                    end
                end
            else            %使用B集解
                for i=1:10  %逐行扫描与B集比较
                    if strcmp(B(i),gan(j)) 
                        gen(j+1) = i-1;
                    end
                end
            end
        end
        %解码右边五个字符，使用C集解码
        for j = 7:12
            for i=1:10 %逐行扫描与C集比较
                if strcmp(C(i),gan(j))
                    gen(j+1) = i-1;
                end
            end
        end
        %检测所解码是否为两位数，若是，则证明错误，然后直接返回
        for i=1:13
            if gen(i)==10;
                return;
            end
        end
        %利用校验码对校验
        odd_num=gen*[1 0 1 0 1 0 1 0 1 0 1 0 0]';%奇
        even_num=gen*[0 1 0 1 0 1 0 1 0 1 0 1 0]';%偶
        sum_num=odd_num+3*even_num;
        s=sum_num-fix(sum_num/100)*100;
        d=fix(s-fix(s/10)*10);
        if d~=0
            d=10-d;
        end
        if d==gen(13)
            coding=gan;
            d=1;
        end
        Result = string(gen);
        decodingResult = join(Result);
        set(decodingResultText, 'String', sprintf('译码结果：%s', decodingResult));
    end

    
end