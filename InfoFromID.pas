(**************************************************)
(*                                                *)
(*        ����Ԫ���ڸ��ݸ���ID��������URL         *)
(*                                                *)
(*              Copyright (c) 2019                *)
(*                     ����                       *)
(*                                                *)
(**************************************************)
unit InfoFromID;

interface

uses
  System.NetEncoding, System.Classes, System.sysutils, IdHTTP, IdIOHandlerSocket,
  superobject, Winapi.Windows, JDAESExtend;

type (* ͨ������ID����ø��������ص�ַ���߳� *)
  GetFromId = class
  private
    const
      QQDownLoad1 = 'https://u.y.qq.com/cgi-bin/musicu.fcg?data={"comm":{"ct":20,"cv":0,"format":"json","uin":0},"req_0":{"method":"CgiGetVkey","module":"vkey.GetVkeyServer","param":{"guid":"9583885280","loginflag":1,"platform":"20","songmid":["';
      QQDownLoad2 = '"],"songtype":[0],"uin":"0"}}}';
      KuWoDownLoad = 'http://antiserver.kuwo.cn/anti.s?type=convert_url&format=mp3&response=url&rid='; // +����ID
      KuGouDownLoad = 'https://wwwapi.kugou.com/yy/index.php?r=play/getdata&hash=';
      OnceKey = '0CoJUm6Qyw8W8jud';
      skey = 'a8dfcd22f776d072cde96b0bc309dc8e845d0a145b11f5e02d1144e61e619aedd3c4ee2a1774b5e998c6e3f85a3ae64a1defc66e4896aa92decd9e132a20a413819509abc0552' + 'f3b1885340f4eaa0ac2f19239f197a41120747205082b77c944e9541fc67a6fc6f7e5c770923748f5b4f48d55be9585bd930918b92888a9102b';
    // 'http://dl.stream.qqmusic.qq.com/'
    function AES_Params: string; // AES����
  public
    var
      ID: string; // ����ID
    function GetFromId_QQ: string;
    function GetFromId_Kuwo: string;
    function GetFromId_KuGou: string;
    function GetFromId_WangYi: string;
  end;

type
  GetMvUrlFromId = class
  private
    const
      QQ_Url1 = 'https://u.y.qq.com/cgi-bin/musicu.fcg?data={"getMvUrl":{"module":"gosrf.Stream.MvUrlProxy","method":"GetMvUrls","param":{"vids":["';
      QQ_Url2 = '"],"request_typet":10001}}}';
  public
    procedure GetMvUrlFromId_QQ(id: string);
  end;

const
  UserAgent = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.104 Safari/537.36 Core/1.53.3408.400 QQBrowser/9.6.12028.400';

implementation

uses
  Main;

function GetFromId.AES_Params: string;
var (* ����ID��Ӧ��POST����������ֵΪ2�μ��ܺ��params *)
  OneceEncode: string;
  TwiceEncode: string;
  strx: string;
begin
  strx := '{"ids":"[' + ID + ']","br":128000,"csrf_token":""}';
  OneceEncode := string(EncryptString(AnsiString(strx), OnceKey, kb128, amCBC, PKCS5Padding, '0102030405060708', ctBase64)); // ��һ��AES����
  OneceEncode := stringreplace(OneceEncode, #13#10, '', [rfReplaceall]);
  TwiceEncode := string(EncryptString(AnsiString(OneceEncode), 'svoXIdz7ZwOI1bXm', kb128, amCBC, PKCS5Padding, '0102030405060708', ctBase64)); // �ڶ���AES����
  TwiceEncode := stringreplace(TwiceEncode, #13#10, '', [rfReplaceall]);
  result := TNetEncoding.URL.Encode(UTF8Encode(TwiceEncode));
end;

function GetFromId.GetFromId_KuGou: string;
var
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  str_KuGou: string;
  jo_KuGou: Isuperobject; // ���ص�ַJosn��������
  x: string;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  x := ID;
  str_KuGou := HP.Get('https://wwwapi.kugou.com/yy/index.php?r=play/getdata&mid=a55266deb33310dfea9f642586c6a04e&hash=' + ID);
  jo_KuGou := so(str_KuGou);
  result := jo_KuGou['data.play_url'].AsString; // ���ص�ַ
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

function GetFromId.GetFromId_Kuwo: string;
var
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  result := HP.Get(KuWoDownLoad + ID); // ���ص�ַ
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

function GetFromId.GetFromId_QQ: string;
var
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  str_QQ: string;
  jo_QQ: Isuperobject; // ���ص�ַJosn��������
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  str_QQ := HP.Get(QQDownLoad1 + ID + QQDownLoad2);
  jo_QQ := so(str_QQ);
  result := 'http://dl.stream.qqmusic.qq.com/' + jo_QQ['req_0.data.midurlinfo[0].purl'].AsString;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

function GetFromId.GetFromId_WangYi: string;
var (* ����POST�ӿڵ�ַ��POST���ݻ�ȡ����ֵ������ֵΪJOSN *)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  st, stb: tstringstream;
  str_WangYi: string;
  jo_WY: Isuperobject; // ���ص�ַJosn��������
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  HP.Request.ContentType := 'application/x-www-form-urlencoded';
  HP.Request.Referer := 'http://music.163.com/';
  st := tstringstream.Create;
  stb := tstringstream.Create('', tencoding.UTF8);
  st.WriteString('params=' + AES_Params + '&encSecKey=' + skey);
  HP.post('http://music.163.com/weapi/song/enhance/player/url?csrf_token=', st, stb);
  str_WangYi := stb.DataString;
  jo_WY := so(str_WangYi);
  result := jo_WY['data[0].url'].AsString;
  FreeAndNil(HP);
  FreeAndNil(SSL);
  st.free;
  stb.free;
end;

{ GetMvUrlFromId }

procedure GetMvUrlFromId.GetMvUrlFromId_QQ(id: string);
var
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  str_QQ: string;
  jo_QQ: Isuperobject; // ���ص�ַJosn��������
  i: Integer;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  str_QQ := HP.Get(QQ_Url1 + id + QQ_Url2);
  jo_QQ := so(str_QQ);
  with Fm_Main.MEM_MV_Urls do
  begin
    Open;
    Append;
    for i := 0 to 4 do
    begin
      if jo_QQ['getMvUrl.data.' + id + '.mp4['+inttostr(i)+'].freeflow_url[0]'] <> nil then
      begin
        FieldByName('Url'+IntToStr(i+1)).AsString := jo_QQ['getMvUrl.data.' + id + '.mp4['+inttostr(i)+'].freeflow_url[0]'].AsString;
      end
      else
      begin
        FieldByName('Url'+IntToStr(i+1)).AsString := '��';
      end;
    end;
    post;
  end;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

end.

