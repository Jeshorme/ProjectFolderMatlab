function myGUI()
    % 创建主窗口
    window = figure('Name', '账号注册与登录', 'NumberTitle', 'off', 'Position', [1000, 800, 350, 200]);
    passwordLabel = uicontrol('Style', 'text', 'String', '裂缝检测系统登录', 'Position', [50, 150, 250, 40],'fontsize',20);
    % 创建用户名文本框和标签
    usernameLabel = uicontrol('Style', 'text', 'String', '用户名:', 'Position', [00, 120, 80, 20]);
    usernameEdit = uicontrol('Style', 'edit', 'Position', [100, 120, 200, 20]);

    % 创建密码文本框和标签
    passwordLabel = uicontrol('Style', 'text', 'String', '密码:', 'Position', [00, 80, 80, 20]);
    passwordEdit = uicontrol('Style', 'edit', 'Position', [100, 80, 200, 20]);

    % 创建注册按钮
    registerButton = uicontrol('Style', 'pushbutton', 'String', '注册', 'Position', [100, 40, 80, 30], 'Callback', @registerCallback);

    % 创建登录按钮
    loginButton = uicontrol('Style', 'pushbutton', 'String', '登录', 'Position', [220, 40, 80, 30], 'Callback', @loginCallback);

    % 注册按钮的回调函数
    function registerCallback(~, ~)
        username = get(usernameEdit, 'String');
        password = get(passwordEdit, 'String');
        
        % 从 Excel 文件中读取已有的用户信息
        [~, ~, existingData] = xlsread('user_data.xlsx');
        
        % 检查用户名是否已存在
        usernames = existingData(2:end, 1);
        if any(strcmp(usernames, username))
            msgbox('用户名已存在！');
            return;
        end
        
        % 创建新的用户信息
        newUserData = {username, password};
        
        % 将新的用户信息追加到 Excel 文件中
        newData = [existingData; newUserData];
        xlswrite('user_data.xlsx', newData);
        
        msgbox('注册成功！');
    end

    % 登录按钮的回调函数
    function loginCallback(~, ~)
        username = get(usernameEdit, 'String');
        password = get(passwordEdit, 'String');
        
        % 从 Excel 文件中读取保存的用户名和密码
        [~, ~, data] = xlsread('user_data.xlsx');
        
        usernames = data(2:end, 1);
        passwords = data(2:end, 2);
        
        % 检查用户名和密码是否匹配
        userIndex = find(strcmp(usernames, username));
        if isempty(userIndex)
            msgbox('用户名不存在！');
        else
            
            storedPassword = passwords{userIndex};
            if strcmp(password, char(num2str(storedPassword)))
                msgbox('登录成功！');
                close all;
                % 创建登录过程弹窗
                loginMsg = msgbox('正在登录，请稍候...', '登录', 'modal');

                % 模拟登录过程（此处可以替换为实际的登录逻辑）
                pause(2);

                % 关闭登录过程弹窗
                delete(loginMsg);
                Gui_Main
            else
                msgbox('密码不正确！');
            end
        end
    end
end
