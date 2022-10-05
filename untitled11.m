function varargout = untitled11(varargin)
% UNTITLED11 MATLAB code for untitled11.fig
%      UNTITLED11, by itself, creates a new UNTITLED11 or raises the existing
%      singleton*.
%
%      H = UNTITLED11 returns the handle to a new UNTITLED11 or the handle to
%      the existing singleton*.
%
%      UNTITLED11('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED11.M with the given input arguments.
%
%      UNTITLED11('Property','Value',...) creates a new UNTITLED11 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled11_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled11_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled11

% Last Modified by GUIDE v2.5 19-Dec-2020 21:02:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled11_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled11_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before untitled11 is made visible.
function untitled11_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled11 (see VARARGIN)

% Choose default command line output for untitled11
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled11 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled11_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cd D:\openpose-1.2.1-win64-binaries\examples\media_out;
load 05082L;
cd D:\test11;
%folders = fullfile(matlabroot,'toolbox','matlab',{'demos','imagesci'});
scorecontainer=[]; categorycontainer=[];conf=[];
neckcoscontainer=[];
var=[];tittleA=[];
var(1,1)=0;                                                %adjectmirror
var(1,2)=0;                                                %checkmirror
var(1,3)=0;                                                %horn
var(1,4)=0;                                                %phone
var(1,5)=0;                                                %shift
var(1,6)=0;                                                %texting
var(1,7)=0;                                                %turnright
var(1,8)=0;                                                %turnleft
var(1,9)=0;                                                %waveinside
var(1,10)=0;                                               %waveoutside
var(1,11)=0;                                               %unknownpose

handles.headangle = get(handles.slider1,'Value');

[S1, FS]=audioread("adjectmirror.mp3");
[S2, FS]=audioread("checkmirror.mp3");
[S3, FS]=audioread("horn.mp3");
[S4, FS]=audioread("phone.mp3");
[S5, FS]=audioread("shift.mp3");
[S6, FS]=audioread("texting.mp3");
[S7, FS]=audioread("turnleft.mp3");
[S8, FS]=audioread("turnright.mp3");
[S9, FS]=audioread("waveinside.mp3");
[S10, FS]=audioread("waveoutside.mp3");
[S11, FS]=audioread("unknown.mp3");

am=0;cm=0;hn=0;ph=0;sh=0;text=0;tl=0;tr=0;wi=0;wo=0;unknownpose=0;
i=0;

while 1
    filename=sprintf('%012d_rendered.png',i);      %format data into string
    
    if (exist(filename,'file')==2)
        c=sprintf('%012d_rendered.png',i);
        a=imread(c);
        d = imresize(a,[227, 227]);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        imshow(d);
        axes(handles.axes4);
%         disp('photonumber:');disp(i);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [YPred,scores] = classify(netTransfer,d);
        categorycontainer=[categorycontainer;[YPred]];  %contain category
        scorecontainer=[scorecontainer;[scores]];
        
        %readjson
        jsoncount=i;
        for ii=jsoncount:i
            fname=sprintf('%012d_keypoints.json',i);
            if(exist(fname,'file')==0) break; end
%             fprintf(1,'===============================================\n>> %s\n',fname);
            json=savejson('data',loadjson(fname));
%             fprintf(1,'%s\n',json);
%             fprintf(1,'%s\n',savejson('data',loadjson(fname),'Compact',1));
            data=loadjson(json);
            savejson('data',data,'selftest.json');
            data=loadjson('selftest.json');
        end %jsoncount end
        pos=[];
        %Makes keyoints into array
        for j=1:3:75
            PD= data.data.data.people{1, 1}.pose_keypoints_2d;
            %data.data.data.people{1, 1}.pose_keypoints;
            %data.data.data.people{1, 1}.pose_keypoints_2d;
            x = PD(1, j);
            y = PD(1, j+1);
            z = PD(1, j+1);
            pos=[pos;[x,y]];
            conf=[conf;[z]];           
        end %Makes keyoints end
        
        % cos(0) = 1
        % cos(30) = SquareRoot(3)/2
        % cos(45) = SquareRoot(2)/2
        % cos(60) = 1/2
        % cos(90) = 0
        % Angle ¶V¤j
        
        %checkmirror cos
        x01=pos(1,1); y01=pos(1,2);
        x02=pos(2,1); y02=pos(2,2);
        x19=pos(19,1); y19=pos(19,2);
        vtx0102=x01-x02; vty0102=y01-y02;
        vtx0119=x01-x19; vty0119=y01-y19;
        cosLface=(vtx0102 * vtx0119 + vty0102 * vty0119)/(sqrt(vtx0102^2 + vty0102^2) * sqrt(vtx0119^2 + vty0119^2));
        x01=pos(1,1); y01=pos(1,2);
        x02=pos(2,1); y02=pos(2,2);
        x18=pos(18,1); y18=pos(18,2);
        vtx0102=x01-x02;vty0102=y01-y02;
        vtx0118=x01-x18;vty0118=y01-y18;
        cosRface=(vtx0102 * vtx0118 + vty0102 * vty0118)/(sqrt(vtx0102^2 + vty0102^2) * sqrt(vtx0118^2 + vty0118^2));
        neckcoscontainer=[neckcoscontainer;[cosLface]];
        if cosLface >handles.headangle | cosRface >handles.headangle    %0.500
            YPred="checkmirror";
            categorycontainer=[categorycontainer;[YPred]];
        end
        %calculate score
        if scores>0
            if YPred=="adjectmirror"
                am=am+1;
                var(1,1)=am;
            elseif YPred=="checkmirror"
                cm=cm+1;
                var(1,2)=cm;
            elseif YPred=="horn"
                hn=hn+1;
                var(1,3)=hn;
            elseif YPred=="phone"
                ph=ph+1;
                var(1,4)=ph;
            elseif YPred=="shif"
                sh=sh+1;
                var(1,5)=sh;
            elseif YPred=="texting"
                text=text+1;
                var(1,6)=text;
            elseif YPred=="turnleft"
                tl=tl+1;
                var(1,7)=tl;
            elseif YPred=="turnright"
                tr=tr+1;
                var(1,8)=tr;
            elseif YPred=="waveinside"
                wi=wi+1;
                var(1,9)=wi;
            elseif YPred=="waveoutside"
                wo=wo+1;
                var(1,10)=wo;
            end
        end
        %Establish resoult string
        ca=0;
        cb=0;%y
        cf=0;
        ce=0;
        for jjj=1:10
            ca=var(1,jjj);
            if ca<0.4
                var(1,11)=unknownpose+1;
            end
        end
        for jj=1:11
            
            if cb<=var(1,jj)
                cb=var(1,jj);
                ce=jj;
            else
                continue;
            end
        end
        
        if ce==1
            tittleA =[tittleA; ["adjectmirror"]];
        elseif ce==2
            tittleA =[tittleA;[ "checkmirror"]];
        elseif ce==3
            tittleA =[tittleA;[ "horn"]];
        elseif ce==4
            tittleA = [tittleA;["phone"]];
        elseif ce==5
            tittleA = [tittleA;["shift"]];
        elseif ce==6
            tittleA=[tittleA;["texting"]];
        elseif ce==7
            tittleA=[tittleA;["turnright"]];
        elseif ce==8
            tittleA=[tittleA;["turnleft"]];
        elseif ce==9
            tittleA=[tittleA;["waveinside"]];
        elseif ce==10
            tittleA=[tittleA;["waveoutside"]];
        elseif ce==11
            tittleA=[tittleA;["unknownpose"]];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        kkk=mod(i,15);
        if kkk==0
            var(1,1)=am/15;                                                %adjectmirror
            var(1,2)=cm/15;                                                %checkmirror
            var(1,3)=hn/15;                                                %horn
            var(1,4)=ph/15;                                                %phone
            var(1,5)=sh/15;                                                %shift
            var(1,6)=text/15;                                              %texting
            var(1,7)=tl/15;                                                %turnright
            var(1,8)=tr/15;                                                %turnleft
            var(1,9)=wi/15;                                                %waveinside
            var(1,10)=wo/15;                                               %waveoutside
            var(1,11)=unknownpose/15;                                      %unknownpose
            
            if i > 15
                if tittleA(i-1,1)=="adjectmirror"
                    AudioLenght=length(S1)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S1,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="checkmirror"
                    AudioLenght=length(S2)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S2,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="horn"
                    AudioLenght=length(S3)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S3,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="phone"
                    AudioLenght=length(S4)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S4,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="shift"
                    AudioLenght=length(S5)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S5,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="texting"
                    AudioLenght=length(S6)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S6,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="turnleft"
                    AudioLenght=length(S7)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S7,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="turnright"
                    AudioLenght=length(S8)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S8,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="waveinside"
                    AudioLenght=length(S9)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S9,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="waveoutside"
                    AudioLenght=length(S10)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S10,FS);
                    pause(AudioLenght);
                elseif tittleA(i-1,1)=="unknownpose"
                    AudioLenght=length(S11)/FS;
                    set(handles.text3,'String',tittleA(i-1,1));
                    sound(S11,FS);
                    pause(AudioLenght);
                end
            end
            var(1,1)=0;                                                %adjectmirror
            var(1,2)=0;                                                %checkmirror
            var(1,3)=0;                                                %horn
            var(1,4)=0;                                                %phone
            var(1,5)=0;                                                %shift
            var(1,6)=0;                                                %texting
            var(1,7)=0;                                                %turnright
            var(1,8)=0;                                                %turnleft
            var(1,9)=0;                                                %waveinside
            var(1,10)=0;                                               %waveoutside
            var(1,11)=0;                                               %unknownpose
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         disp(i);
        i=i+1;
        pause(0.1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
%         disp('ERROR');
        set(handles.text3,'String','ERROR');
        break;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cd D:\openpose-1.2.1-win64-binaries;
% cmd1='cd';
% [status,comdout]=system(cmd1);
% cmd3='bin\OpenPoseDemo.exe --disable_blending --write_images D:\test --write_json D:\test';%+ --hand
% [status,comdout]=system(cmd3);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%camObj = webcam;
%frame = snapshot(cam); 
%m = image(handles.axes_video,zeros(size(frame),'uint8')); 
%preview(camObj);

 
 % Acquire and display a single image frame.
        %img = snapshot(camObj);
        %a=imread(img)
        %imshow(a);
        
 %while (true)
 %       i=0; 
 %       c=sprintf('%012d_rendered.png',i);
 %       a=imread(c);
 %       imshow(a);
 %       i=i+1;
 %end

% --------------------------------------------------------------------
% function open_Callback(hObject, eventdata, handles)
% % hObject    handle to open (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [filename, pathname]=uigetfile('*.png','Open File');
% if filename~=0
%     filename=[pathname filename];
%     handles.filename=filename;
%     guidata(gcbf,handles);
% end;    

% --------------------------------------------------------------------
% function exit_Callback(hObject, eventdata, handles)
% % hObject    handle to exit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% close(gcbf)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Show
% --- Executes on button press in show.
% function show_Callback(hObject, eventdata, handles)
% hObject    handle to show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% cd D:\openpose-1.2.1-win64-binaries\examples\media_out\test;
%  i=0;
% while 1
%     filename=sprintf('%012d_rendered.png',i);       %formst data into string
%     abc= exist(filename,'file')
%     if abc==2 
%         c=sprintf('%012d_rendered.png',i);
%         a=imread(c);
%         %d = imresize(a,[227, 227]);
%         imshow(a);
%         axes(handles.axes4);
%         disp('photonumber:');disp(i);
%         i=i+1;
%      elseif abc==0
%         i=i-5;
%         disp('minus 5');
%         continue;
%     end
% end

% for i=1:10
%     %%%%%%%%%Show Picture
%     fname=sprintf('%012d_rendered.png',i);
%     a=imread(fname);
%     d = imresize(a,[227, 227]);
%     imshow(d);
    
    %%%%%%%%%%Draw Skeleton
%     fname=sprintf('%012d_keypoints.json',i);
%     if(exist(fname,'file')==0) break; end
%     fprintf(1,'===============================================\n>> %s\n',fname);
%     json=savejson('data',loadjson(fname));
%     fprintf(1,'%s\n',json);
%     fprintf(1,'%s\n',savejson('data',loadjson(fname),'Compact',1));
%     data=loadjson(json);
%     savejson('data',data,'selftest.json');
%     data=loadjson('selftest.json');
%     
%     I = imread('white.png');
% pos=[];
% conf=[];
% for j=1:3:75
%         PD= data.data.data.people{1, 1}.pose_keypoints_2d%data.data.data.people{1, 1}.pose_keypoints%data.data.data.people{1, 1}.pose_keypoints_2d
%         x = PD(1, j);
%         y = PD(1, j+1);
%         z = PD(1, j+1)
%         conf=[conf;[z]];
%         pos=[pos;[x,y]];
%         
% end
% RGB = insertMarker(I, [147 279]); 
% color = {'blue'};
% RGB = insertMarker(RGB, pos, 'o', 'color', color, 'size', 5);
% imshow(RGB);
% 
% %%%%%%%%%%%%%%%%%%%%%%%Confidence%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CF00=conf(1,1);
% CF01=conf(2,1);
% CF02=conf(3,1);
% CF03=conf(4,1);
% CF04=conf(5,1);
% CF05=conf(6,1);
% CF06=conf(7,1);
% CF07=conf(8,1);
% CF08=conf(9,1);
% CF09=conf(10,1);
% CF10=conf(11,1);
% CF11=conf(12,1);
% CF12=conf(13,1);
% CF13=conf(14,1);
% CF14=conf(15,1);
% CF15=conf(16,1);
% CF16=conf(17,1);
% CF17=conf(18,1);
% CF18=conf(19,1);
% CF19=conf(20,1);
% CF20=conf(21,1);
% CF21=conf(22,1);
% CF22=conf(23,1);
% CF23=conf(24,1);
% CF24=conf(25,1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% axis ([0 1500 0 1500]);
% %hold no;
% 
% %00-15-RightEye
% X0015=[pos(1,1),pos(16,1)]; Y0015=[pos(1,2),pos(16,2)];
% if((CF00>0) && (CF15>0))
%     line(X0015,Y0015); 
% end
% 
% %00-16-LeftEye
% X0016=[pos(1,1),pos(17,1)]; Y0016=[pos(1,2),pos(17,2)];
% if((CF00>0) && (CF17>0))
%     line(X0016,Y0016); 
% end
% 
% %16-18-leftEar
% X1618=[pos(17,1),pos(19,1)]; Y1618=[pos(17,2),pos(19,2)];
% if((CF16>0) && (CF18>0))
%     line(X1618,Y1618); 
% end
% 
% %15-17-RightEar8
% X1517=[pos(16,1),pos(18,1)]; Y1517=[pos(16,2),pos(18,2)];
% if((CF15>0) && (CF17>0))
%     line(X1517,Y1517); 
% end
% 
% 
% %0-1-Neck
% X0001=[pos(1,1),pos(2,1)]; Y0001=[pos(1,2),pos(2,2)];
% if((CF00>0) && (CF01>0))
%     line(X0001,Y0001); 
% end
% 
% %1-2-RightShoulder
% X0102=[pos(2,1),pos(3,1)]; Y0102=[pos(2,2),pos(3,2)];
% if((CF01>0) && (CF02>0))
%     line(X0102,Y0102); 
% end
% 
% %1-5-LeftShoulder
% X0105=[pos(2,1),pos(6,1)]; Y0105=[pos(2,2),pos(6,2)];
% if((CF01>0) && (CF05>0))
%     line(X0105,Y0105); 
% end
% 
% %2-3-RightUpperArm
% X0203=[pos(3,1),pos(4,1)]; Y0203=[pos(3,2),pos(4,2)];
% if((CF02>0) && (CF03>0))
%     line(X0203,Y0203); 
% end
% 
% %5-6-LeftUpperArm
% X0506=[pos(6,1),pos(7,1)]; Y0506=[pos(6,2),pos(7,2)];
% if((CF05>0) && (CF06))
%     line(X0506,Y0506); 
% end
% 
% %3-4-RightForeArm
% X0304=[pos(4,1),pos(5,1)]; Y0304=[pos(4,2),pos(5,2)];
% if((CF03>0) && (CF04>0))
%     line(X0304,Y0304); 
% end
% 
% %6-7-LeftForeArm
% X0607=[pos(7,1),pos(8,1)]; Y0607=[pos(7,2),pos(8,2)];
% if((CF06>0) && (CF07>0))
%     line(X0607,Y0607); 
% end
% 
% %1-8tBody
% X0108=[pos(2,1),pos(9,1)]; Y0108=[pos(2,2),pos(9,2)];
% if((CF01>0) && (CF08>0))
%     line(X0108,Y0108); 
% end

%8-9-Lefpelvis
%X0809=[pos(08,1),pos(09,1)]; Y0809=[pos(08,2),pos(09,2)];
%if((CF08>0) && (CF09>0))
%    line(X0809,Y0809); 
%end

%8-12-Rightpelvis
%X0812=[pos(9,1),pos(13,1)]; Y0812=[pos(8,2),pos(13,2)];
%if((CF08>0) && (CF12>0))
%    line(X0812,Y0812); 
%end

%12-13-Leftthigh
%X1112=[pos(12,1),pos(13,1)]; Y1112=[pos(12,2),pos(13,2)];
%if((CF11>0) && (CF12>0))
%    line(X1112,Y1112); 
%end

%9-10-RightCalf
%X0910=[pos(10,1),pos(11,1)]; Y0910=[pos(10,2),pos(11,2)];
%if((CF09>0) && (CF10>0))
%    line(X0910,Y0910); 
%end

%12-13-LeftCalf
%X1213=[pos(13,1),pos(14,1)]; Y1213=[pos(13,2),pos(14,2)];
%if((CF12>0) && (CF13>0))
%    line(X1213,Y1213); 
%end


%hold off
% end





    



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.headangle = get(handles.slider1,'Value')
guidata(hObject,handles);
num2str(handles.headangle)
set(handles.text4,'String',num2str(handles.headangle));

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%cd D:\openpose-1.2.1-win64-binaries;
%cmd1='cd';
%[status,comdout]=system(cmd1);
%cmd3='bin\OpenPoseDemo.exe --disable_blending --write_images D:\test --write_json D:\test';%+ --hand
%[status,comdout]=system(cmd3);
% D:
% cd D:\openpose-1.5.0-binaries-win64-gpu-python-flir-3d_recommended
% bin\OpenPoseDemo.exe --write_images D:\test --write_json D:\test
% cd D:\openpose-1.2.1-win64-binaries
% bin\OpenPoseDemo.exe --disable_blending
% error('Interrupted by user');

% % --- Executes on button press in pushbutton8.
% function pushbutton8_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton8 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% cmd1='cd D:\openpose-1.2.1-win64-binaries';
% error('Interrupted by user');
