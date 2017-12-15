function MusicScoreGUI(filename)
[yall,fs,bits]=wavread(filename);
i=sqrt(-1);
yall=yall(:,1);
TrackLength=length(yall)/fs;
tmin=0;
tmax=10;
A4freq=440;
sampletime=0.1;
timespace=0.01;
colorscale=0;

figure('Position',get(0,'screensize'));
mainaxes=axes('Units','Normalized','Position',[0.2,0.05,0.8,0.9]);
TextTrackLength=uicontrol('style','text',...
                      'Units','Normalized',...
                      'String',...
    {['Total Track Time ' num2str(TrackLength) ' seconds']},...
                      'Position',[0.05,0.8,0.1,0.05]);
TextTmin=uicontrol('style','text',...
                    'Units','Normalized',...
                    'Position',[0.02,0.7,0.08,0.05],...
                    'String','Time-min');
TextTmax=uicontrol('style','text',...
                    'Units','Normalized',...
                    'Position',[0.1,0.7,0.08,0.05],...
                    'String','Time-max');
EditTmin=uicontrol('style','edit',...
                    'Units','Normalized',...
                    'Position',[0.02,0.65,0.08,0.05],...
                    'String','0',...
                'Callback',@EditTminCallback);
EditTmax=uicontrol('style','edit',...
                    'Units','Normalized',...
                    'Position',[0.1,0.65,0.08,0.05],...
                    'String','10',...
                    'Callback',@EditTmaxCallback);
TextA4freq=uicontrol('style','text',...
                    'Units','Normalized',...
                    'Position',[0.05,0.6,0.1,0.05],...
                    'String','A4 Frequency');
EditA4freq=uicontrol('style','edit',...
                    'Units','Normalized',...
                    'Position',[0.05,0.55,0.1,0.05],...
                    'String','440',...
                    'Callback',@EditA4freqCallback);
TextCscale=uicontrol('style','text',...
                    'Units','Normalized',...
                    'Position',[0.05,0.5,0.1,0.05],...
                    'String','Color scale');
EditCscale=uicontrol('style','edit',...
                    'Units','Normalized',...
                    'Position',[0.05,0.45,0.1,0.05],...
                    'String',num2str(colorscale),...
                    'Callback',@EditCscaleCallback);
ButtonUpdate=uicontrol('style','pushbutton',...
                    'Units','Normalized',...
                    'Position',[0.05,0.35,0.1,0.1],...
                    'String','Update',...
                    'Callback',@ButtonUpdateCallback);
TextSampleTime=uicontrol('style','text',...
                    'Units','Normalized',...
                    'Position',[0.02,0.2,0.08,0.05],...
                    'String','Sample Time');
TextTimeSpace=uicontrol('style','text',...
                    'Units','Normalized',...
                    'Position',[0.1,0.2,0.08,0.05],...
                    'String','Time Space');
EditSampleTime=uicontrol('style','edit',...
                    'Units','Normalized',...
                    'Position',[0.02,0.15,0.08,0.05],...
                    'String','0.1',...
                'Callback',@EditSampleTimeCallback);
EditTimeSpace=uicontrol('style','edit',...
                    'Units','Normalized',...
                    'Position',[0.1,0.15,0.08,0.05],...
                    'String','0.01',...
                    'Callback',@EditTimeSpaceCallback);
                
    function EditTminCallback(source,eventdata)
        tmin=(str2double(get(source,'String')));
        if tmin<0||tmin>=tmax;
            tmin=0;
            set(EditTmin,'String','0');
        end
    end
    function EditTmaxCallback(source,eventdata)
        tmax=(str2double(get(source,'String')));
        if tmax>TrackLength||tmin>=tmax
            tmax=TrackLength;
            set(EditTmax,'String',num2str(TrackLength));
        end
    end
    function EditA4freqCallback(source,eventdata)
        A4freq=(str2double(get(source,'String')));
        if A4freq<=0
            A4freq=440;
        end
    end
    function EditCscaleCallback(source,eventdata)
        colorscale=(str2double(get(source,'String')));
    end
    function EditSampleTimeCallback(source,eventdata)
        sampletime=(str2double(get(source,'String')));
        if sampletime<=0;
            sampletime=0.1;
            set(EditSampleTime,'String','0.1');
        end
    end
    function EditTimeSpaceCallback(source,eventdata)
        timespace=(str2double(get(source,'String')));
        if timespace<=0
            timespace=0.01;
            set(EditTimeSpace,'String','0.01');
        end
    end
    function ButtonUpdateCallback(source,eventdata)
        y=yall(floor(tmin*fs)+1:floor(tmax*fs));
        n=floor(sampletime*fs)+1;
        yp=sampling;
        W=wavefunction;
        A=W*yp;
        hold off
        if colorscale==0
            imagesc(abs(A))
        else
            image(abs(A)*colorscale)
        end
        hold on
        for note=1:87
            if abs(mod(note,12)-0.5)<1
                linestyle='r:';
            else
                linestyle='k:';
            end
            plot([0,n],[note+0.7,note+0.7],linestyle)
        end
        function W=wavefunction
            key=89-(1:88);
            frequency=A4freq*2.^((key-49)/12);
            tt=(1:n)/fs;
            [T,F]=meshgrid(tt,frequency);
            W=exp(i*F.*T*2*pi);
        end
        function yp=sampling
            ncol=floor((length(y)-n)/(timespace*fs));
            [COL ROW]=meshgrid(1:ncol,1:n);
            yp=y((COL-1)*floor(timespace*fs)+ROW);
        end
    end
end
