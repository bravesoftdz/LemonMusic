unit TaskBar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, scGPControls, scControls;

type
  TFm_TaskBar = class(TForm)
    BTN_Last: TscGPButton;
    BTN_Play_Pause: TscGPButton;
    BTN_Next: TscGPButton;
    BTN_Menu: TscGPGlyphButton;
    procedure BTN_MenuClick(Sender: TObject);
    procedure BTN_Play_PauseClick(Sender: TObject);
    procedure BTN_NextClick(Sender: TObject);
    procedure BTN_LastClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fm_TaskBar: TFm_TaskBar;

implementation

uses
  Main, Bass,Task_Menu;
{$R *.dfm}

procedure TFm_TaskBar.BTN_LastClick(Sender: TObject);
begin
  case Loop_Type of
    0: //�б�ѭ������һ��
      begin
        try
          Fm_Main.Last_Music;
        except
          Fm_Main.Last_Music;
        end;
      end;
    2: //�����һ��
      begin
        try
          Fm_Main.Loop_Random;
        except
          Fm_Main.Loop_Random;
        end;
      end;
  end;
end;

procedure TFm_TaskBar.BTN_NextClick(Sender: TObject);
begin
  case Loop_Type of
    0: //�б�ѭ������һ��
      begin
        try
          Fm_Main.Loop_List;
        except
          Fm_Main.Loop_List;
        end;
      end;
    1: //�б�ѭ������һ��
      begin
        try
          Fm_Main.Loop_List;
        except
          Fm_Main.Loop_List;
        end;
      end;
    2: //���ѭ������һ��
      begin
        try
          Fm_Main.Loop_Random;
        except
          Fm_Main.Loop_Random;
        end;
      end;
  end;
end;

procedure TFm_TaskBar.BTN_Play_PauseClick(Sender: TObject);
begin
  if MEM.Size > 0 then
  begin
    if Bo_Play then
    begin
      BASS_ChannelSetAttribute(HS, BASS_ATTRIB_VOL, Fm_Main.Trc_Voice.Value / Fm_Main.Trc_Voice.MaxValue);
      Fm_Main.Tmr_Play.Enabled := True;  //��������
      BASS_ChannelPlay(HS, false);
      BTN_Play_Pause.ImageIndex := 1;
      Fm_Main.BTN_Play_Pause.ImageIndex := 1; //���Ű�ť��ʾΪ��ͣ
      Fm_Main.N_Play_Pause.ImageIndex := 5; //��������ť��ʾΪ��ͣ
      Fm_Main.N_Play_Pause.Caption := '��ͣ';
      Bo_Play := false;
    end
    else
    begin
      Fm_Main.Tmr_Play.Enabled := false; //ֹͣ��������
      BASS_ChannelPause(HS);
      BTN_Play_Pause.ImageIndex := 0;
      Fm_Main.BTN_Play_Pause.ImageIndex := 0; //���Ű�ť��ʾΪ����
      Fm_Main.N_Play_Pause.ImageIndex := 4; //��������ť��ʾΪ����
      Fm_Main.N_Play_Pause.Caption := '����';
      Bo_Play := True;
    end;
  end;
end;

procedure TFm_TaskBar.BTN_MenuClick(Sender: TObject);
var
  MainH, FirH: THandle;
  MainR, FirR: TRect;
begin
  MainH := FindWindow(PChar('Shell_TrayWnd'), nil); //Shell_TaryWnd���
  FirH := FindWindowEX(MainH, 0, 'ReBarWindow32', nil); //ReBarWindow32���
  GetWindowRect(MainH, MainR);
  GetWindowRect(FirH, FirR);
  Fm_Task_Menu.SF_Task_Menu.DropDown(Fm_TaskBar,FirR.Left+ Fm_Taskbar.Left+Fm_Taskbar.Width-Fm_Task_Menu.Width,Screen.Height-40-Fm_Task_Menu.Height);
end;

procedure TFm_TaskBar.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

end.

