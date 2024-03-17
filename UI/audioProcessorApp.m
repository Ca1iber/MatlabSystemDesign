function createAudioGUI
    % 读取音频文件
    [audioData, Fs] = audioread('F:\MATProject\Recording\DingZhen.wav');
    player = audioplayer(audioData, Fs);

    % 创建GUI界面
    hFig = figure('Name', '音频播放和变声处理', 'Position', [300, 300, 300, 150]);
    playButton = uicontrol('Style', 'pushbutton', 'String', '播放', ...
                           'Position', [50, 100, 60, 30], 'Callback', @playAudio);
    pauseButton = uicontrol('Style', 'pushbutton', 'String', '暂停', ...
                            'Position', [120, 100, 60, 30], 'Callback', @pauseAudio);
    resumeButton = uicontrol('Style', 'pushbutton', 'String', '继续播放', ...
                             'Position', [190, 100, 60, 30], 'Callback', @resumeAudio);
    pitchButton = uicontrol('Style', 'togglebutton', 'String', '变声', ...
                            'Position', [50, 50, 200, 30], 'Callback', @changePitch);

    function playAudio(hObject, eventdata)
        play(player);
    end

    function pauseAudio(hObject, eventdata)
        pause(player);
    end

    function resumeAudio(hObject, eventdata)
        resume(player);
    end

    function changePitch(hObject, eventdata)
        % 这里应该实现变声的逻辑
        % 简单示例：调整音高，这需要重新处理audioData并创建新的audioplayer
        if get(hObject, 'Value') == get(hObject, 'Max')
            disp('变声处理激活');
            % 例如，通过改变音频数据的播放速度来简单变声
            newAudioData = resample(audioData, 1, 2); % 这里只是一个示例
            stop(player);
            player = audioplayer(newAudioData, Fs/4);
            play(player);
        else
            disp('变声处理关闭');
            stop(player);
            player = audioplayer(audioData, Fs);
            play(player);
        end
    end
end
