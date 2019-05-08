(**************************************************)
(*                                                *)
(*            ����Ԫ������ȡ��������              *)
(*                                                *)
(*              Copyright (c) 2019                *)
(*                     ����                       *)
(*                                                *)
(**************************************************)
//������
//1��Key_Word���������������ؼ���
//2��Num������������
//3��ִ���߳̿�ʼ��������ӵ�NextGrid
unit Music_163_Spider;

interface

uses
  System.Classes, system.sysutils, IdHTTP, IdIOHandlerSocket, superobject,
  JDAESExtend, Winapi.Windows, MSGs, VMsgMonitor;

type
  Get_163_Info = class(TTHread)
  private
    const
      UserAgent = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.104 Safari/537.36 Core/1.53.3408.400 QQBrowser/9.6.12028.400';
      skey = 'a8dfcd22f776d072cde96b0bc309dc8e845d0a145b11f5e02d1144e61e619aedd3c4ee2a1774b5e998c6e3f85a3ae64a1defc66e4896aa92decd9e132a20a413819509abc0552' + 'f3b1885340f4eaa0ac2f19239f197a41120747205082b77c944e9541fc67a6fc6f7e5c770923748f5b4f48d55be9585bd930918b92888a9102b';
      OnceKey = '0CoJUm6Qyw8W8jud';
      Music_Post = 'http://music.163.com/weapi/song/enhance/player/url?csrf_token=';
      MV_Post = 'https://music.163.com/weapi/song/enhance/play/mv/url?csrf_token=';
    var
//      S_Type: Integer; //�������ͣ�0Ϊ������1ΪMV��2Ϊ�б�
//      M_Type: Integer; //MV�������ȣ�����240,480��720��,1080
      WY163: Word; // �����������
  public
    var
      HTTP: TIdHTTP;
      SSL: TIdIOHandlerSocket;
      Key_Word: string; //�����ؼ���
      Num: integer; //��������
    constructor Create(S_Key_Word: string; S_Num: Integer); overload; //���캯��
  protected
    function AES_Params(i: integer; Video_HD: Integer; str: string): string; //������Ҫ�����ݻ�ȡ��Ӧ��POST����������ֵΪparams
    function Post(url, params: string): string; //����POST�ӿڵ�ַ��POST���ݻ�ȡ����ֵ������ֵΪJOSN
    function JO_Song_ID(jo_str: string): TStringList; //����JSON��ȡ����ID�б�
    function JO_SOng_Time(jo_str: string): TStringList; //����JSON��ȡ����ʱ���б�
    procedure Execute; override;
  end;

implementation

uses
  System.NetEncoding, Main;
{ Get_163_Info }

procedure Get_163_Info.Execute;
var(*�߳���ִ��*)
  Params_Str: string;
  str163: string;
  jo163, item163: Isuperobject; // ��������API
  Time_Ls: TStringList; // ���������б�
  vMsg: TSearch_163_Song_MSG;
begin
  FreeOnTerminate := true;
  OnTerminate := Fm_Main.Search_Over;
  WY163 := 0;
  Time_Ls := TStringList.Create; // ����ʱ���б�
  Params_Str := AES_Params(2, 720, Key_Word); //������ø����б��Params
  str163 := Post('http://music.163.com/weapi/cloudsearch/get/web?csrf_token=', Params_Str);
  jo163 := SO(str163);
  Time_Ls.Assign(JO_Song_TIME(str163)); // �����������ص�ַ��ȡ
  for item163 in jo163['result.songs'] do
  begin
    vMsg := TSearch_163_Song_MSG.Create;
    vMsg.Song_Name := jo163['result.songs[' + inttostr(WY163) + '].name'].AsString; // ����
    vMsg.Song_Album := jo163['result.songs[' + inttostr(WY163) + '].al.name'].AsString; // ר����
    vMsg.Song_Singer := jo163['result.songs[' + inttostr(WY163) + '].ar[0].name'].AsString; // ������
    vMsg.Song_Time := inttostr(Trunc(strtofloat(Time_Ls[WY163]) / 1000)); //ʱ����
    vMsg.Song_From := '2';
    vMsg.Song_Img := jo163['result.songs[' + inttostr(WY163) + '].al.picUrl'].AsString; // ͼƬ
    vMsg.Song_ID := jo163['result.songs[' + inttostr(WY163) + '].id'].AsString; // ID
    vMsg.Song_AlbumID := jo163['result.songs[' + inttostr(WY163) + '].al.id'].AsString; //ר��ID
    vMsg.Song_SingerID := jo163['result.songs[' + inttostr(WY163) + '].ar[0].id'].AsString; //����ID
    vMsg.Song_MVID := jo163['result.songs[' + inttostr(WY163) + '].mv'].AsString; //��MV_ID
    vMsg.Song_Lrc := '';
    GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ
    inc(WY163);
  end;
//  Url_Ls.Free;
  Time_Ls.Free;
end;


function Get_163_Info.AES_Params(i: integer; Video_HD: Integer; str: string): string;
var  (*������Ҫ�����ݻ�ȡ��Ӧ��POST����������ֵΪ2�μ��ܺ��params*)
  OneceEncode: string;
  TwiceEncode: string;
  strx: string;
begin
  case i of
    0:
      begin
      //post��ȡ�ĸ���id�б�
        strx := '{"ids":"[' + str + ']","br":128000,"csrf_token":""}';
      end;
    1:
      begin
      //post��ȡ����Ƶid�б�
        strx := '{"id":"' + str + '","r":"' + inttostr(Video_HD) + '","csrf_token":""}';
      end;
    2:
      begin
        //post��ȡ���������õ��ĸ����б�
        strx := '{"hlpretag":"<span class=\"s-fc7\">","hlposttag":"</span>","s":"' + str + '","type":"1","offset":"0","total":"true","limit":"' + inttostr(NUM) + '","csrf_token":""}';
      end;
  end;
  OneceEncode := string(EncryptString(AnsiString(strx), OnceKey, kb128, amCBC, PKCS5Padding, '0102030405060708', ctBase64)); //��һ��AES����
  OneceEncode := stringreplace(OneceEncode, #13#10, '', [rfReplaceall]);
  TwiceEncode := string(EncryptString(AnsiString(OneceEncode), 'svoXIdz7ZwOI1bXm', kb128, amCBC, PKCS5Padding, '0102030405060708', ctBase64)); //�ڶ���AES����
  TwiceEncode := stringreplace(TwiceEncode, #13#10, '', [rfReplaceall]);
  result := TNetEncoding.URL.Encode(UTF8Encode(TwiceEncode));
end;

constructor Get_163_Info.Create(S_Key_Word: string; S_Num: Integer);
begin
  Key_Word := S_Key_Word; //�����ؼ���
  Num := S_Num; //��������
  inherited Create(false);
end;

function Get_163_Info.JO_Song_ID(jo_str: string): TStringList;
var(*����JSON��ȡ����ID������ֵΪ����ID�б�*)
  jo163, item163: Isuperobject; // ��������API
  jo_music: Isuperobject; // ���ص�ַ
  ct163: Integer;
begin
  ct163 := 0;
  result := TStringList.Create;
  jo163 := so(jo_str);
  try
    for item163 in jo163['result.songs'] do
    begin
      jo_music := SO(Post(Music_Post, AES_Params(0, 0, jo163['result.songs[' + inttostr(ct163) + '].id'].AsString)));
      result.Add(jo_music['data[0].url'].AsString);
      inc(ct163);
    end;
  except
    begin
      //�����κ���
    end;
  end;
end;

function Get_163_Info.JO_SOng_Time(jo_str: string): TStringList;
var (*����JSON��ȡ����ʱ��������ֵΪ����ʱ���б�*)
  jo163, item163: Isuperobject;
  ct163: Integer;
begin
  ct163 := 0;
  result := TStringList.Create;
  jo163 := so(jo_str);
  try
    for item163 in jo163['result.songs'] do
    begin
      result.Add(jo163['result.songs[' + inttostr(ct163) + '].dt'].AsString);
      inc(ct163);
    end;
  except
    begin
      //�����κ���
    end;
  end;
end;

function Get_163_Info.Post(url, params: string): string;
var (*����POST�ӿڵ�ַ��POST���ݻ�ȡ����ֵ������ֵΪJOSN*)
  st, stb: tstringstream;
begin
  HTTP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HTTP.IOHandler := SSL;
  st := tstringstream.Create;
  stb := tstringstream.Create('', tencoding.UTF8);
  st.WriteString('params=' + params + '&encSecKey=' + skey);
  HTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  HTTP.Request.UserAgent := UserAgent;
  HTTP.Request.Referer := 'http://music.163.com/';
  HTTP.post(url, st, stb);
  result := stb.DataString;
  st.free;
  stb.free;
  HTTP.Free;
  SSL.Free;
end;

end.

