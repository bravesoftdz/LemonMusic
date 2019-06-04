(**************************************************)
(*                                                *)
(*            ����Ԫ������ȡ�ṷ����              *)
(*                                                *)
(*              Copyright (c) 2019                *)
(*                     ����                       *)
(*                                                *)
(**************************************************)
unit Music_KuGou_Spider;

interface

uses
  System.Classes, system.sysutils, IdHTTP, IdIOHandlerSocket, superobject,
  Winapi.Windows, MSGs, VMsgMonitor;

type
  Get_KuGou_Info = class(TTHread)
  private
    const
      UserAgent = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.104 Safari/537.36 Core/1.53.3408.400 QQBrowser/9.6.12028.400';
      KuGouInfo = 'http://songsearch.kugou.com/song_search_v2?&page=1&platform=WebFilter&filter=2&iscorrection=1&pagesize='; // +����
      KuGouDownLoad = 'http://www.kugou.com/yy/index.php?r=play/getdata&mid=a55266deb33310dfea9f642586c6a04e';
    var
      KuGou: Word; // �����������
  public
    var
      Key_Word: string; //�����ؼ���
      Num: integer; //��������
    constructor Create(S_Key_Word: string; S_Num: Integer); overload; //���캯��
  protected
    function KuGou_Music_Info(KW: string; S_Count: integer): string; // ��ȡ����������Ϣ
    procedure Execute; override;
  end;

implementation

uses
  System.NetEncoding, Main;
{ Get_KuGo_Info }

constructor Get_KuGou_Info.Create(S_Key_Word: string; S_Num: Integer);
begin
  Key_Word := S_Key_Word; //�����ؼ���
  Num := S_Num; //��������
  inherited Create(false);
end;

procedure Get_KuGou_Info.Execute;
var
  HPX: TIdHTTP;
  SSLX: TIdIOHandlerSocket;
  joKuGou, jox, itemKuGou: Isuperobject; // �ṷ����API
  strKuGou, str_Other: string;
  KuGouX: string;
  vMsg: TSearch_KuGou_Song_MSG;
begin
  FreeOnTerminate := true;
  OnTerminate := Fm_Main.Search_Over;
  KuGou := 0;
  HPX := TIdHTTP.Create(nil);
  SSLX := TIdIOHandlerSocket(nil);
  HPX.IOHandler := SSLX;
  HPX.Request.UserAgent := UserAgent; // ����UserAgent
  strKuGou := KuGou_Music_Info(Key_Word, Num);
  joKuGou := SO(strKuGou);
  for itemKuGou in joKuGou['data.lists'] do
  begin
    KuGouX := KuGouDownLoad + '&album_id=' + joKuGou['data.lists[' + inttostr(KuGou) + '].AlbumID'].AsString + '&hash=' + joKuGou['data.lists[' + inttostr(KuGou) + '].FileHash'].AsString;
    str_Other := HPX.Get(KuGouX);
    jox := SO(str_Other);

    vMsg :=  TSearch_KuGou_Song_MSG.Create;
    vMsg.Song_Name := joKuGou['data.lists[' + inttostr(KuGou) + '].SongName'].AsString; // ����
    vMsg.Song_Album := joKuGou['data.lists[' + inttostr(KuGou) + '].AlbumName'].AsString; // ר����
    vMsg.Song_Singer := joKuGou['data.lists[' + inttostr(KuGou) + '].SingerName'].AsString; // ������
    vMsg.Song_Time := joKuGou['data.lists[' + inttostr(KuGou) + '].Duration'].AsString; //ʱ����
    vMsg.Song_From := '4';
    vMsg.Song_Img := jox['data.img'].AsString;  // ͼƬ
    vMsg.Song_ID := joKuGou['data.lists[' + inttostr(KuGou) + '].FileHash'].AsString; // ID
    vMsg.Song_AlbumID := joKuGou['data.lists[' + inttostr(KuGou) + '].AlbumID'].AsString; //ר��ID
    vMsg.Song_SingerID := joKuGou['data.lists[' + inttostr(KuGou) + '].SingerId[0]'].AsString; //����ID
    vMsg.Song_MVID := joKuGou['data.lists[' + inttostr(KuGou) + '].MvHash'].AsString; //��MV_ID
    vMsg.Song_Lrc := '';
    GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ
    inc(KuGou);
  end;
  FreeAndNil(HPX);
  FreeAndNil(SSLX);
end;

function Get_KuGou_Info.KuGou_Music_Info(KW: string; S_Count: integer): string;
var
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  result := HP.Get(KuGouInfo + inttostr(S_Count) + '&keyword=' + TNetEncoding.URL.Encode(Trim(KW)));
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

end.

