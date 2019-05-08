(**************************************************)
(*                                                *)
(*             ����Ԫ������ȡQQ����               *)
(*                                                *)
(*              Copyright (c) 2019                *)
(*                     ����                       *)
(*                                                *)
(**************************************************)
//������
//1��Key_Word���������������ؼ���
//2��Num������������
//3��ִ���߳̿�ʼ��������ӵ�NextGrid
unit Music_QQ_Spider;

interface

uses
  System.NetEncoding, Winapi.GDIPOBJ, Winapi.GDIPAPI, Vcl.Graphics, System.Classes,
  system.sysutils, IdHTTP, IdIOHandlerSocket, InfoFromID, scGPExtControls,
  superobject, Winapi.Windows, vcl.Forms, AdvListEditor, VMsgMonitor, MSGs,
  dxTileControl, dxCustomTileControl;

type(*��ȡ��ͨ������Ϣ���߳�*)(*Done*)
  Get_QQ_Info = class(TTHread)
  private
    const
      QQInfo = 'https://c.y.qq.com/soso/fcgi-bin/client_search_cp?aggr=1&cr=1&n='; // +����
      QQDownLoad1 = 'https://u.y.qq.com/cgi-bin/musicu.fcg?data={"comm":{"ct":20,"cv":0,"format":"json","uin":0},"req_0":{"method":"CgiGetVkey","module":"vkey.GetVkeyServer","param":{"guid":"9583885280","loginflag":1,"platform":"20","songmid":["';
      QQDownLoad2 = '"],"songtype":[0],"uin":"0"}}}';
    var
      Res_Json: string;
      Song_Name, Song_Album, Song_Singer, Song_Time, Song_Img, Song_Url, Song_ID, Album_ID, Singer_ID, MV_ID: string;
      QQ: Word; // �����������
  public
    var
      Key_Word: string; //�����ؼ���
      Num: integer; //��������
    constructor Create(S_Key_Word: string; S_Num: Integer); overload; //���캯��
  protected
    function QQ_Music_Info(KW: string; S_Count: integer): string; // ��ȡQQ������Ϣ
    function Music_Info(InNo: Integer; Music_ID: string): string; //��ȡVkey����,��InNo=0Ϊ��ȡVkey��=1Ϊ��ȡMV��ַ
    procedure Execute; override;
  end;

type(*��ȡ����������Ϣ���߳�*)
  Get_HS_Info = class(Get_QQ_Info)
  private
    const
      (*QQ����*)
      Mp3_128_1 = 'http://isure.stream.qqmusic.qq.com/M500';
      Mp3_128_2 = '.mp3?guid=9583885280&uin=0&fromtag=53&vkey='; // ��ͨmp3
      Mp3_320_1 = 'http://isure.stream.qqmusic.qq.com/M800';
      Mp3_320_2 = '.mp3?guid=9583885280&uin=0&fromtag=53&vkey='; // ����mp3
      Flac_1 = 'http://isure.stream.qqmusic.qq.com/F000';
      Flac_2 = '.flac?guid=9583885280&uin=0&fromtag=53&vkey='; // ����flac
      Ape_1 = 'http://streamoc.music.tc.qq.com/A000';
      Ape_2 = '.ape?guid=9583885280&uin=0&fromtag=8&vkey='; // ����ape
    var
      MP3_128, MP3_320, Flac, Ape: string;
      VKey: string; //����VKey
  protected
    procedure Add_To_HS_Grid; //��ӵ���������ʾ
    procedure Execute; override;
  end;

type(*��ȡ�������а���Ϣ���߳�*)
  Get_Top_Info = class(Get_QQ_Info)
  public
    const
      LiuXing = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=4&type=top&song_num=100'; // �۷��-����ָ��
      ReGe = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=26&type=top&song_num=100'; // �۷��-�ȸ�
      XinGe = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?&topid=27&type=top&song_num=100'; // �۷��-�¸�
      ShuoChang = 'https://szc.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=58&type=top&song_num=100'; // �۷��-˵����
      WangLuo = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=28&type=top&song_num=100'; // �۷��-�������
      NeiDi = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=5&type=top&song_num=100'; // �۷��-�ڵ�
      GangTai = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=6&type=top&song_num=100'; // �۷��-��̨
      OuMei = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=3&type=top&song_num=100'; // �۷��-ŷ��
      HanGuo = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=16&type=top&song_num=100'; // �۷��-����
      YingShi = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=29&type=top&song_num=100'; // �۷��-Ӱ�ӽ���
      RiBen = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=17&type=top&song_num=100'; // �۷��-�ձ�
      YuanChuang = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=52&type=top&song_num=100'; // �۷��-��Ѷ������ԭ����
      KGe = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_toplist_cp.fcg?topid=36&type=top&song_num=100'; // �۷��-K�������
    var
      Top_Addr: string; //�ⲿ�������洢��ַ
      Update_Time: string; //�б��������
      i, j: Word;
    constructor Create(m, n: word); overload; //���캯��
  protected
    procedure Add_To_Top_Grid; //��ӵ���������ʾ
    function Get_Top_Info(Addr: string): string; // ��ȡQQ���а���Ϣ
    procedure Execute; override;
  end;

type(*��ȡMV��Ϣ���߳�*)
  Get_MV_Info = class(Get_QQ_Info)
  private
    const
      url1 = 'https://u.y.qq.com/cgi-bin/musicu.fcg?data={"getMvUrl":{"module":"gosrf.Stream.MvUrlProxy","method":"GetMvUrls","param":{"vids":["';
      url2 = '"],"request_typet":10001}}}';
    var
      index: Word; //�洢���±�
  public
    var
      MV_Name: string; //��������
      MV_Num: Word; //��������
    constructor Create(S_Key_Word: string; S_Num: Integer); overload; //���캯��
  protected
    procedure Add_To_MV_Grid; //��ӵ���������ʾ
    procedure Get_MV_Img; //��ȡMV����ͼ
    procedure Execute; override;
  end;

type(*��������ʱ��ȡ�Ƽ������б��߳�*)(*Done*)
  Get_List_Type = class(TTHread)
  public
    constructor Create(TCX: TdxTileControl); overload;
  private
    RecTitle, RecId: string; //�Ƽ���������ƺͶ�ӦID
    TC: TdxTileControl;
    it: TdxTileControlItem;
  protected
    procedure Execute; override;
  end;

type(*�����Ƽ����͵�id��ȡ��ר����id�����ƺ�ͼƬ����Ϣ*)(*Done*)
  Get_List_Songs = class(TTHread)
  private
    var
      List_UrlX: string;
      List_No, CodeX: Word;
  public
    constructor Create(List_Idx, List_Countx: string; Code: Integer = 0); overload;
  protected
    function Get_List_Info(Url: string): string;
    procedure Execute; override;
  end;

type(*���ݸ赥ID��ȡ����ID�б�*)(* Done*)
  Get_Song_From_ListID = class(TTHread)
  private
    var
      List_ID: string;
    const
      List_Url = 'https://c.y.qq.com/qzone/fcg-bin/fcg_ucc_getcdinfo_byids_cp.fcg?type=1&format=json&disstid=';
  public
    constructor Create(ListID: string); overload;
  protected
    function Get_Info(ListIDX: string): string; //��ȡ�赥json����ֵ
    procedure Execute; override;
  end;

type(*���ڻ�ȡÿ�����µĵ���*)
  Get_New_Song = class(TTHread)
  private
    var
      Area_ID: Word;
    const
      New_Song_Url = 'https://u.y.qq.com/cgi-bin/musicu.fcg?data={"comm":{"ct":24},"new_song":{"module":"QQMusic.MusichallServer","method":"GetNewSong","param":{"type":';
  public
    constructor Create(AreaID: Word); overload;
  protected
    function Get_Info(AreaID: Word): string; //��ȡ�¸�json����ֵ
    procedure Execute; override;
  end;

type(*���ڻ�ȡÿ�����µ�ר��*)(* Done*)
  Get_New_Albubm = class(TTHread)
  private
    var
      Area_ID, Num: Word;
      NewNo: Integer;
      Album_ID: string;
    const //����ƴ�ӣ�New_Album_Url1+��������+New_Album_Url2+��������+New_Album_Url3
      New_Album_Url1 = 'https://u.y.qq.com/cgi-bin/musicu.fcg?data={"comm":{"ct":24},"new_album":{"module":"newalbum.NewAlbumServer","method":"get_new_album_info","param":{"area":';
      New_Album_Url2 = ',"sin":0,"num":';
      New_Album_Url3 = '}}}';
  public
    constructor Create(AreaID, No: Word); overload;
  protected
    procedure Get_List_Img; //��ȡר������ͼ
    function Get_Info(AreaID, No: Word): string; //��ȡ��ר��json����ֵ
    procedure Execute; override;
  end;

type(*���ڻ�ȡÿ���Ƽ���MV*)(* Done*)
  Get_Recom_MV = class(TTHread)
  private
    var
      vMsg: TQQ_Recom_MV_MSG;
      Area_Name: string;
      Song_Img: string;
    const
      Recom_MV_Url = 'https://c.y.qq.com/mv/fcgi-bin/getmv_by_tag?format=json&cmd=shoubo&lan=';
  public
    constructor Create(AreaName: string); overload;
  protected
    procedure Get_List_Img; //��ȡMV����ͼ
    function Get_Info(AreaName: string): string; //��ȡNV json����ֵ
    procedure Execute; override;
  end;

type(*���ڸ��ݡ�ר����ID��ȡר�������б�ͻ�����Ϣ*)(* Done*)
  Get_Album_From_AlbumID = class(TTHread)
  private
    var
      Album_ID: string;
    const
      Album_Url = 'https://c.y.qq.com/v8/fcg-bin/fcg_v8_album_info_cp.fcg?albummid=';
  public
    constructor Create(AlbumID: string); overload;
  protected
    function Get_Info(AlbumIDX: string): string; //��ȡ�赥json����ֵ
    procedure Execute; override;
  end;

const
 //get�赥�б�ʱ,ƴ�ӹ���ΪList0+List1+<id>+List2+<count>+List3+<id>+List4
 //get�赥����ʱ,ƴ�ӹ���ΪList0+{"category":{"method":"get_hot_category","module":"music.web_category_svr","param":{"qq":""}}}
 //get�����Ƽ�ʱ,ƴ�ӹ���ΪList0+{"comm":{"ct":24},"recomPlaylist":{"method":"get_hot_recommend","param":{"async":1,"cmd":2},"module":"playlist.HotRecommendServer"}}
  ListGet0 = 'https://u.y.qq.com/cgi-bin/musicu.fcg?data=';
  ListGet1 = '{"comm":{"ct":24},"playlist":{"method":"get_playlist_by_category","param":{"id":';
  ListGet2 = ',"curPage":1,"size":';
  ListGet3 = ',"order":5,"titleid":';
  ListGet4 = '},"module":"playlist.PlayListPlazaServer"}}';

const
  UserAgent = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.104 Safari/537.36 Core/1.53.3408.400 QQBrowser/9.6.12028.400';

implementation

uses
  Main;
{ Get_QQ_Info��ȡQQ��ͨ������Ϣ Done}

constructor Get_QQ_Info.Create(S_Key_Word: string; S_Num: Integer);
begin
  Key_Word := S_Key_Word;
  Num := S_Num;
  inherited Create(false);
end;

procedure Get_QQ_Info.Execute;
var
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  joQQ, itemQQ: Isuperobject; // QQ����JSON��������
  vMsg: TSearch_QQ_Song_MSG;
begin
  FreeOnTerminate := true;
  OnTerminate := Fm_Main.Search_Over;
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  QQ := 0;
  Res_Json := QQ_Music_Info(Key_Word, NUM);
  joQQ := SO(Res_Json); // QQ���ֻ�ȡ
  for itemQQ in joQQ['data.song.list'] do
  begin
    vMsg := TSearch_QQ_Song_MSG.Create;
    vMsg.Song_Name := joQQ['data.song.list[' + inttostr(QQ) + '].songname'].AsString; // ����
    vMsg.Song_Album := joQQ['data.song.list[' + inttostr(QQ) + '].albumname'].AsString; //ר��
    vMsg.Song_Singer := joQQ['data.song.list[' + inttostr(QQ) + '].singer[0].name'].AsString; //����
    vMsg.Song_Time := joQQ['data.song.list[' + inttostr(QQ) + '].interval'].AsString; // ʱ������
    vMsg.Song_From := '1';
    vMsg.Song_Img := 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' + joQQ['data.song.list[' + inttostr(QQ) + '].albummid'].AsString + '.jpg'; //ͼƬ
    vMsg.Song_ID := joQQ['data.song.list[' + inttostr(QQ) + '].songmid'].AsString; //����ID
    vMsg.Song_AlbumID := joQQ['data.song.list[' + inttostr(QQ) + '].albummid'].AsString; //ר��ID
    vMsg.Song_SingerID := joQQ['data.song.list[' + inttostr(QQ) + '].singer[0].mid'].AsString; //����ID
    vMsg.Song_MVID := joQQ['data.song.list[' + inttostr(QQ) + '].vid'].AsString; //��MV_ID
    vMsg.Song_Lrc := '';
    GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ
    inc(QQ);
  end;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

function Get_QQ_Info.QQ_Music_Info(KW: string; S_Count: integer): string;
var
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  KW_S: string; //�����ؼ���
  strQQ: string; //���ص�JSON
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  KW_S := TNetEncoding.URL.Encode(Trim(KW)); //URL����
  strQQ := HP.Get(QQInfo + inttostr(S_Count) + '&w=' + KW_S); //��ȡ�����ķ����б�JSON
  result := copy(strQQ, 10, Length(strQQ) - 10); //ȡ�÷���ֵJSON
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

function Get_QQ_Info.Music_Info(InNo: Integer; Music_ID: string): string;
var(*��ȡMV�������Vkey����*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  strQQ: string;
  joQQ: Isuperobject; // QQ����Josn����
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  strQQ := HP.Get(QQDownLoad1 + Music_ID + QQDownLoad2);
  joQQ := SO(strQQ);
  if InNo = 1 then
  begin
    result := joQQ['req_0.data.midurlinfo[0].purl'].AsString;
  end
  else
  begin
    result := joQQ['req_0.data.midurlinfo[0].vkey'].AsString;
  end;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;
{ Get_HS_Info��ȡQQ����������Ϣ }

procedure Get_HS_Info.Add_To_HS_Grid;
(*������ӵ���������ʾ*)
begin
//  with Fm_Main.NG_HS.AddRow.Cells do
//  begin
//    Item[Fm_Main.Col_No.Index].AsInteger := Fm_Main.NG_HS.RowCount;
//    Item[Fm_Main.HS_Col_Check.Index].AsBoolean := false;
//    Item[Fm_Main.HS_Col_Music.Index].AsString := Song_Name; // ����
//    if Song_Album <> '' then
//    begin
//      Item[Fm_Main.HS_Col_Album.Index].AsString := Song_Album; // ר����
//    end
//    else
//    begin
//      Item[Fm_Main.HS_Col_Album.Index].AsString := '����'; // ר����
//    end;
//    if Mp3_128 <> '0' then
//    begin
//      Item[Fm_Main.Col_Url.Index].AsString := Mp3_128_1 + Song_ID + Mp3_128_2 + VKey; // mp3_128���ص�ַ
//    end
//    else
//    begin
//      Item[Fm_Main.HS_Col_Url_MP3_128.Index].AsString := '';
//      Item[Fm_Main.HS_Col_MP3_128.Index].Visible := false;
//    end;
//
//    if MP3_320 <> '0' then
//    begin
//      Item[Fm_Main.HS_Col_Url_MP3_320.Index].AsString := Mp3_320_1 + Song_ID + Mp3_320_2 + VKey; // mp3_320���ص�ַ
//    end
//    else
//    begin
//      Item[Fm_Main.HS_Col_Url_MP3_320.Index].AsString := '';
//      Item[Fm_Main.HS_Col_MP3_320.Index].Visible := false;
//    end;
//
//    if Flac <> '0' then
//    begin
//      Item[Fm_Main.HS_Col_Url_Flac.Index].AsString := Flac_1 + Song_ID + Flac_2 + VKey; // flac���ص�ַ
//    end
//    else
//    begin
//      Item[Fm_Main.HS_Col_Url_Flac.Index].AsString := '';
//      Item[Fm_Main.HS_Col_Flac.Index].Visible := false;
//    end;
//
//    if Ape <> '0' then
//    begin
//      Item[Fm_Main.HS_Col_Url_Ape.Index].AsString := Ape_1 + Song_ID + Ape_2 + VKey; // ape���ص�ַ
//    end
//    else
//    begin
//      Item[Fm_Main.HS_Col_Url_Ape.Index].AsString := '';
//      Item[Fm_Main.HS_Col_Ape.Index].Visible := false;
//    end;
//    Item[Fm_Main.HS_Col_Singer.Index].AsString := Song_Singer; // ������
//    Item[Fm_Main.HS_Col_Img.Index].AsString := 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' + Song_Img + '.jpg'; // ͼƬ
//    Item[Fm_Main.HS_Col_Time.Index].AsString := Format('%.2d', [StrToInt(Song_Time) div 60]) + ':' + Format('%.2d ', [StrToInt(Song_Time) mod 60]); // ʱ����ʽ��
//    Item[Fm_Main.HS_Col_MusicID.Index].AsString := Song_ID; //����ID
//    Item[Fm_Main.HS_Col_From.Index].AsString := '1';
//    Fm_Main.SB_HS.Max := Fm_Main.NG_HS.RowCount;
//  end;
end;

procedure Get_HS_Info.Execute;
var
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  joQQ, itemQQ: Isuperobject; // QQ����JSON��������
begin
  FreeOnTerminate := true;
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  QQ := 0;
  Res_Json := QQ_Music_Info(Key_Word, NUM);
  joQQ := SO(Res_Json); // QQ���ֻ�ȡ
  for itemQQ in joQQ['data.song.list'] do
  begin
    if (strtoint(joQQ['data.song.list[' + inttostr(QQ) + '].size128'].AsString) > 0) or (strtoint(joQQ['data.song.list[' + inttostr(QQ) + '].size320'].AsString) > 0) or (strtoint(joQQ['data.song.list[' + inttostr(QQ) + '].sizeflac'].AsString) > 0) or (strtoint(joQQ['data.song.list[' + inttostr(QQ) + '].sizeape'].AsString) > 0) then
    begin
      VKey := Music_Info(0, joQQ['data.song.list[' + inttostr(QQ) + '].songmid'].AsString);
      MP3_128 := joQQ['data.song.list[' + inttostr(QQ) + '].size128'].AsString;
      MP3_320 := joQQ['data.song.list[' + inttostr(QQ) + '].size320'].AsString;
      Flac := joQQ['data.song.list[' + inttostr(QQ) + '].sizeflac'].AsString;
      Ape := joQQ['data.song.list[' + inttostr(QQ) + '].sizeape'].AsString;
      Song_Time := joQQ['data.song.list[' + inttostr(QQ) + '].interval'].AsString; // ʱ����
      Song_Name := joQQ['data.song.list[' + inttostr(QQ) + '].songname'].AsString; // ����
      Song_Album := joQQ['data.song.list[' + inttostr(QQ) + '].albumname'].AsString; // ר����
      Song_Singer := joQQ['data.song.list[' + inttostr(QQ) + '].singer[0].name'].AsString; // ������
      Song_Img := joQQ['data.song.list[' + inttostr(QQ) + '].albummid'].AsString;
      Song_ID := joQQ['data.song.list[' + inttostr(QQ) + '].songmid'].AsString;
      Synchronize(Add_To_HS_Grid);
      inc(QQ);
    end;
  end;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

{ Get_Top_Info��ȡ���а���Ϣ }

procedure Get_Top_Info.Add_To_Top_Grid;
begin(*������ӵ����а�����ʾ*)
//  with Fm_Main.NG_Top.AddRow.Cells do
//  begin
//    Item[Fm_Main.Top_Col_No.Index].AsInteger := Fm_Main.NG_Top.RowCount;
//    Item[Fm_Main.Top_Col_Name.Index].AsString := Song_Name; // ����
//    if Song_Album <> '' then
//    begin
//      Item[Fm_Main.Top_Col_Album.Index].AsString := Song_Album; // ר����
//    end
//    else
//    begin
//      Item[Fm_Main.Top_Col_Album.Index].AsString := '����'; // ר����
//    end;
//    Item[Fm_Main.Top_Col_Singer.Index].AsString := Song_Singer; // ������
//    Item[Fm_Main.Top_Col_Img.Index].AsString := 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' + Song_Img + '.jpg'; // ͼƬ
//    Item[Fm_Main.Top_Col_Url.Index].AsString := 'http://dl.stream.qqmusic.qq.com/' + Song_Url; // ���ص�ַ
//    Item[Fm_Main.Top_Col_Time.Index].AsString := Format('%.2d', [StrToInt(Song_Time) div 60]) + ':' + Format('%.2d ', [StrToInt(Song_Time) mod 60]); // ʱ����ʽ��
//    Item[Fm_Main.Top_Col_ID.Index].AsString := Song_ID; //����ID
//    Item[Fm_Main.Top_Col_From.Index].AsString := '1';
//  end;
//  Fm_Main.SB_Top.Max := Fm_Main.NG_Top.RowCount;
//  Fm_Main.WCC_Top.Categories[i].Words[j].Hint := '�������ڣ�' + Update_Time; //��ʾHint
end;

constructor Get_Top_Info.Create(m, n: word);
begin
  i := m;
  j := n;
  inherited Create(True);
end;

procedure Get_Top_Info.Execute;
var(*ִ�����а��ѯ�߳�*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  joQQ, itemQQ: Isuperobject; // QQ����JSON��������
  joQQ_Url: Isuperobject; // QQ�������ص�ַJosn��������
  strQQ_Url: string; //���ص�ַ����url
  strQQ: string; //QQ����json����ֵ
begin
  FreeOnTerminate := true;
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  QQ := 0;
  strQQ := Get_Top_Info(Top_Addr);
  joQQ := SO(strQQ);
  Update_Time := joQQ['update_time'].AsString; //��������
  for itemQQ in joQQ['songlist'] do
  begin
    strQQ_Url := HP.Get(QQDownLoad1 + joQQ['songlist[' + inttostr(QQ) + '].data.songmid'].AsString + QQDownLoad2);
    joQQ_Url := SO(strQQ_Url);
    Song_Url := joQQ_Url['req_0.data.midurlinfo[0].purl'].AsString; // ���ص�ַ�ڶ�����
    Song_Time := joQQ['songlist[' + inttostr(QQ) + '].data.interval'].AsString; // ʱ������
    Song_Name := joQQ['songlist[' + inttostr(QQ) + '].data.songname'].AsString; // ����
    Song_Album := joQQ['songlist[' + inttostr(QQ) + '].data.albumname'].AsString; //ר��
    Song_Singer := joQQ['songlist[' + inttostr(QQ) + '].data.singer[0].name'].AsString; //����
    Song_Img := joQQ['songlist[' + inttostr(QQ) + '].data.albummid'].AsString; //ͼƬ
    Song_ID := joQQ['songlist[' + inttostr(QQ) + '].data.songmid'].AsString; //����ID
    Synchronize(Add_To_Top_Grid); //��ӵ����б�����ʾ
    inc(QQ);
  end;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

function Get_Top_Info.Get_Top_Info(Addr: string): string;
var(*��ȡ���а��������Ϣ*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  result := HP.Get(Addr);
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

{ Get_MV_Thread��ȡMV��Ϣ }

procedure Get_MV_Info.Add_To_MV_Grid;
begin(*������ӵ�MV�����ʾ*)
//  with Fm_Main.NG_MV.AddRow.Cells do
//  begin
//    Item[Fm_Main.MV_Col_No.Index].AsInteger := Fm_Main.NG_MV.RowCount;
////    Item[Fm_Main.MV_Col_Pic.Index].Data := Song_Pic; // ר��ͼƬ
//    Item[Fm_Main.MV_Col_Name.Index].AsString := Song_Name; // ����
//    Item[Fm_Main.MV_Col_Singer.Index].AsString := Song_Singer; // ������
//    Item[Fm_Main.MV_Col_Img.Index].AsString := Song_Img; // ͼƬ
//    Item[Fm_Main.MV_Col_Url.Index].AsString := 'http://dl.stream.qqmusic.qq.com/' + Song_Url; // ���ص�ַ
//    Item[Fm_Main.MV_Col_Time.Index].AsString := Format('%.2d', [StrToInt(Song_Time) div 60]) + ':' + Format('%.2d ', [StrToInt(Song_Time) mod 60]); // ʱ����ʽ��
//    Item[Fm_Main.MV_Col_ID.Index].AsString := Song_ID; //MV ID
//    Item[Fm_Main.MV_Col_From.Index].AsString := '1';
//  end;
//  Fm_Main.SB_MV.Max := Fm_Main.NG_MV.RowCount;
end;

constructor Get_MV_Info.Create(S_Key_Word: string; S_Num: Integer);
begin
  MV_Name := S_Key_Word; //��������
  MV_Num := S_Num; //��������
  inherited Create(True);
end;

procedure Get_MV_Info.Execute;
var(*ִ��MV��ѯ�߳�*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  joMV, itemMV: Isuperobject; // QQ����JSON��������
  strMV: string;
  MV: Word;
begin
  MV := 0;
  FreeOnTerminate := true;
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  strMV := HP.Get('https://c.y.qq.com/soso/fcgi-bin/client_search_cp?remoteplace=txt.yqq.mv&t=12&n=' + inttostr(MV_NUM) + '&w=' + TNetEncoding.URL.Encode(Trim(MV_Name)));
  strMV := copy(strMV, 10, Length(strMV) - 10);
  joMV := SO(strMV); // QQ���ֻ�ȡ
  for itemMV in joMV['data.mv.list'] do
  begin
    Song_Time := joMV['data.mv.list[' + inttostr(MV) + '].duration'].AsString; // ʱ����         duration
    Song_Name := joMV['data.mv.list[' + inttostr(MV) + '].mv_name'].AsString; // ����
    Song_Singer := joMV['data.mv.list[' + inttostr(MV) + '].singer_name'].AsString; //����
    Song_Img := joMV['data.mv.list[' + inttostr(MV) + '].mv_pic_url'].AsString; //ͼƬ
    Song_ID := joMV['data.mv.list[' + inttostr(MV) + '].v_id'].AsString; //����ID
    index := MV; //�±�
    Synchronize(Add_To_MV_Grid); //��ӵ����б�����ʾ
    Synchronize(Get_MV_Img); //��ʾͼƬ
    inc(MV);
  end;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

procedure Get_MV_Info.Get_MV_Img;
var(*��������MV����ͼ*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  Pic_MS: TMemoryStream;
  MyIStream: TStreamAdapter;
  Bmp: Vcl.Graphics.tbitmap;
  BmpX: TGPBitmap;
  Graphic: TGPGraphics;
  pic: tPicture;
begin
  pic := TPicture.Create;
  Bmp := Vcl.Graphics.tbitmap.Create;
  Pic_MS := TMemoryStream.Create();
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  HP.Get(Song_Img, Pic_MS); //��ȡͼƬ���洢����
  Pic_MS.Position := 0;
  MyIStream := TStreamAdapter.Create(Pic_MS);
  BmpX := TGPBitmap.Create(MyIStream);
  Bmp.Width := 100;
  Bmp.Height := 55;
  Graphic := TGPGraphics.Create(Bmp.Canvas.Handle);
  Graphic.SetInterpolationMode(InterpolationModeHighQualityBicubic);
  Graphic.DrawImage(BmpX, 0.0, 0.0, Bmp.Width, Bmp.Height);
  pic.Assign(Bmp);
//  Fm_Main.NG_MV.Cell[1, index].Data := pic.Graphic;
  Bmp.free; //�����ͷ���Դ
  BmpX.free;
  Pic_MS.free;
  Graphic.free;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

{ Get_List_Type ��ȡÿ���Ƽ����赥��������Ϣ Done}
constructor Get_List_Type.Create(TCX: TdxTileControl);
begin
  TC := TCX;
  inherited Create(False);
end;

procedure Get_List_Type.Execute;
var
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  joRec, itemRec: Isuperobject;
  strRec: string;
  Rec: Word;
begin
  Rec := 0;
  FreeOnTerminate := true;
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  strRec := HP.Get(ListGet0 + '{"category":{"method":"get_hot_category","module":"music.web_category_svr","param":{"qq":""}}}');
  joRec := SO(strRec);
  for itemRec in joRec['category.data.category[0].items'] do
  begin
    if joRec['category.data.category[0].items[' + IntToStr(Rec) + '].item_id'].AsString <> '-100' then
    begin
      Synchronize(
      procedure
      begin
        it := TC.Items.Add;
        with it do
        begin
          GroupIndex := 0;
          Text1.Align := oaMiddleCenter;
          Style.GradientBeginColor := $6FA364;
          Style.GradientEndColor := $6FA364;
          Text1.Font.Name := '΢���ź�';
          Text1.Font.Size := 9;
          Text1.Value := joRec['category.data.category[0].items[' + IntToStr(Rec) + '].item_name'].AsString;
          DetailOptions.Caption := joRec['category.data.category[0].items[' + IntToStr(Rec) + '].item_id'].AsString;
          it.OnClick := Fm_Main.ItemXClick;
        end;
      end);
    end;
    inc(Rec);
  end;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

{ Get_List_Songs ��ȡÿ���Ƽ����赥�� Done}
constructor Get_List_Songs.Create(List_Idx, List_Countx: string; Code: Integer = 0);
begin
  if Code = 0 then
  begin
    List_UrlX := ListGet0 + '{"comm":{"ct":24},"recomPlaylist":{"method":"get_hot_recommend","param":{"async":1,"cmd":2},"module":"playlist.HotRecommendServer"}}';
  end
  else
  begin
    List_UrlX := ListGet0 + ListGet1 + List_Idx + ListGet2 + List_Countx + ListGet3 + List_Idx + ListGet4;
  end;
  CodeX := Code;
  inherited Create(false);
end;

procedure Get_List_Songs.execute;
var(*��Ϣͬ����ʾ�����*)
  joList, itemList: Isuperobject;
  strList: string;
  vMsg: TQQ_Recom_List_MSG;
begin
  FreeOnTerminate := True;
  OnTerminate := Fm_Main.Search_Over;
  try
    List_No := 0;
    strList := Get_List_Info(List_UrlX);
    joList := SO(strList);
    if CodeX = 0 then
    begin
      for itemList in joList['recomPlaylist.data.v_hot'] do
      begin
        vMsg := TQQ_Recom_List_MSG.Create;
        vMsg.List_Name := joList['recomPlaylist.data.v_hot[' + inttostr(List_No) + '].title'].AsString;
        vMsg.List_ID := joList['recomPlaylist.data.v_hot[' + inttostr(List_No) + '].content_id'].AsString;
        vMsg.List_Num := joList['recomPlaylist.data.v_hot[' + inttostr(List_No) + '].listen_num'].AsString;
        vMsg.List_Img := joList['recomPlaylist.data.v_hot[' + inttostr(List_No) + '].cover'].AsString;
        GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ
        Inc(List_No);
      end;
    end
    else
    begin
      for itemList in joList['playlist.data.v_playlist'] do
      begin
        vMsg := TQQ_Recom_List_MSG.Create;
        vMsg.List_Name := joList['playlist.data.v_playlist[' + inttostr(List_No) + '].title'].AsString;
        vMsg.List_ID := joList['playlist.data.v_playlist[' + inttostr(List_No) + '].tid'].AsString;
        vMsg.List_Num := joList['playlist.data.v_playlist[' + inttostr(List_No) + '].access_num'].AsString;
        vMsg.List_Img := joList['playlist.data.v_playlist[' + inttostr(List_No) + '].cover_url_medium'].AsString;
        GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ
        Inc(List_No);
      end;
    end;
  except

  end;
end;

function Get_List_Songs.Get_List_Info(Url: string): string;
var(*��ȡ�Ƽ��赥�Ļ�����Ϣ*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  result := HP.Get(Url);
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

{ Get_Song_From_ListID ����ÿ���Ƽ����赥��ID��ȡ�����б���ϸ��Ϣ Done}
constructor Get_Song_From_ListID.Create(ListID: string);
begin
  List_ID := ListID;
  inherited Create(false);
end;

procedure Get_Song_From_ListID.Execute;
var(*��ȡ�赥��Ϣjson*)
  joList, itemList: Isuperobject;
  strList: string;
  ListNo: Integer;
  vMsg: TQQ_List_Song_MSG;
begin
  FreeOnTerminate := True;
  OnTerminate := Fm_Main.Search_Over;
  ListNo := 0;
  strList := Get_Info(List_ID);
  joList := So(strList);
  for itemList in joList['cdlist[0].songlist'] do
  begin
    vMsg := TQQ_List_Song_MSG.Create;
    vMsg.Song_Name := joList['cdlist[0].songlist[' + inttostr(ListNo) + '].songname'].AsString; // ����
    vMsg.Song_Album := joList['cdlist[0].songlist[' + inttostr(ListNo) + '].albumname'].AsString; //ר����
    vMsg.Song_Singer := joList['cdlist[0].songlist[' + inttostr(ListNo) + '].singer[0].name'].AsString; //����
    vMsg.Song_Time := joList['cdlist[0].songlist[' + inttostr(ListNo) + '].interval'].AsString; // ʱ������
    vMsg.Song_From := '1';
    vMsg.Song_Img := 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' + joList['cdlist[0].songlist[' + inttostr(ListNo) + '].albummid'].AsString + '.jpg'; //ͼƬ
    vMsg.Song_ID := joList['cdlist[0].songlist[' + inttostr(ListNo) + '].strMediaMid'].AsString; //����id
    vMsg.Song_AlbumID := joList['cdlist[0].songlist[' + inttostr(ListNo) + '].albummid'].AsString; //ר��ID
    vMsg.Song_SingerID := joList['cdlist[0].songlist[' + inttostr(ListNo) + '].singer[0].mid'].AsString; //����ID
    vMsg.Song_MVID := joList['cdlist[0].songlist[' + inttostr(ListNo) + '].vid'].AsString; //��MV_ID
    vMsg.Song_Lrc := '';
    vMsg.List_Des := joList['cdlist[0].desc'].AsString; //�赥����
    vMsg.List_Title := joList['cdlist[0].dissname'].AsString; //�赥��
    GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ
    inc(ListNo);
  end;
end;

function Get_Song_From_ListID.Get_Info(ListIDX: string): string;
var(*��ȡ�赥��Ϣjson*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  HP.Request.Referer := 'https://y.qq.com/portal/playlist.html';
  result := HP.Get(List_Url + ListIDX);
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

{ Get_New_Song ��ȡÿ���Ƽ����¸衿 }

constructor Get_New_Song.Create(AreaID: Word);
begin
  Area_ID := AreaID;
  inherited Create(false);
end;

procedure Get_New_Song.Execute;
var
  joNew, itemNew: Isuperobject;
  strNew: string;
  NewNo: Integer;
  vMsg: TQQ_Recom_Song_MSG;
begin
  FreeOnTerminate := True;
  OnTerminate := Fm_Main.Search_Over;
  NewNo := 0;
  strNew := Get_Info(Area_ID);
  joNew := SO(strNew);
  for itemNew in joNew['new_song.data.song_list'] do
  begin
    vMsg:=TQQ_Recom_Song_MSG.Create;
    vMsg.Song_Name := joNew['new_song.data.song_list[' + inttostr(NewNo) + '].title'].AsString; // ����
    vMsg.Song_Album :=  joNew['new_song.data.song_list[' + inttostr(NewNo) + '].album.name'].AsString;  //ר��
    vMsg.Song_Singer := joNew['new_song.data.song_list[' + inttostr(NewNo) + '].singer[0].name'].AsString;  //����
    vMsg.Song_Time := joNew['new_song.data.song_list[' + inttostr(NewNo) + '].interval'].AsString; // ʱ����
    vMsg.Song_From := '1';
    vMsg.Song_Img := 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' + joNew['new_song.data.song_list[' + inttostr(NewNo) + '].album.mid'].AsString + '.jpg'; //ͼƬ
    vMsg.Song_ID := joNew['new_song.data.song_list[' + inttostr(NewNo) + '].mid'].AsString; //����ID
    vMsg.Song_AlbumID := joNew['new_song.data.song_list[' + inttostr(NewNo) + '].album.mid'].AsString; //ר��ID
    vMsg.Song_SingerID := joNew['new_song.data.song_list[' + inttostr(NewNo) + '].singer[0].mid'].AsString; //����ID
    vMsg.Song_MVID := joNew['new_song.data.song_list[' + inttostr(NewNo) + '].mv.vid'].AsString;//��MV_ID
    vMsg.Song_Lrc := '';
    GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ
    Inc(NewNo);
  end;
end;

function Get_New_Song.Get_Info(AreaID: Word): string;
var(*��ȡ�¸��б�json*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  result := HP.Get(New_Song_Url + inttostr(AreaID) + '}}}');
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

{ Get_New_Albubm ��ȡÿ���Ƽ���ר���� Done}
constructor Get_New_Albubm.Create(AreaID, No: Word);
begin
  Area_ID := AreaID;
  Num := No;
  inherited Create(false);
end;

procedure Get_New_Albubm.Execute;
var(*ִ����ר����ȡ�߳�*)
  joNew, itemNew: Isuperobject;
  strNew: string;
  vMsg: TQQ_Recom_Album_MSG;
begin
  FreeOnTerminate := True;
  OnTerminate := Fm_Main.Search_Over;
  NewNo := 0;
  strNew := Get_Info(Area_ID, Num);
  joNew := SO(strNew);
  for itemNew in joNew['new_album.data.albums'] do
  begin
    vMsg := TQQ_Recom_Album_MSG.Create;
    vMsg.Album_Name := joNew['new_album.data.albums[' + inttostr(NewNo) + '].name'].AsString; //ר����
    vMsg.Album_ID := joNew['new_album.data.albums[' + inttostr(NewNo) + '].mid'].AsString; //ר��ID
    vMsg.Album_Singer := joNew['new_album.data.albums[' + inttostr(NewNo) + '].singers[0].name'].AsString; //������
    vMsg.Album_Img := 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' + joNew['new_album.data.albums[' + inttostr(NewNo) + '].mid'].AsString + '.jpg'; //ͼƬ
    GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ

//    Pub_Time := joNew['new_album.data.albums[' + inttostr(NewNo) + '].release_time'].AsString; //����ʱ��

    Inc(NewNo);
  end;
end;

function Get_New_Albubm.Get_Info(AreaID, No: Word): string;
var(*��ȡ��ר���б�json*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  result := HP.Get(New_Album_Url1 + inttostr(AreaID) + New_Album_Url2 + inttostr(No) + New_Album_Url3);
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

procedure Get_New_Albubm.Get_List_Img;
var(*��ȡר������ͼ*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  Pic_MS: TMemoryStream;
  MyIStream: TStreamAdapter;
  Bmp: Vcl.Graphics.tbitmap;
  BmpX: TGPBitmap;
  Graphic: TGPGraphics;
  pic: tPicture;
begin
  pic := TPicture.Create;
  Bmp := Vcl.Graphics.tbitmap.Create;
  Pic_MS := TMemoryStream.Create();
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  HP.Get('https://y.gtimg.cn/music/photo_new/T002R300x300M000' + Album_ID + '.jpg', Pic_MS); //��ȡͼƬ���洢����
  Pic_MS.Position := 0;
  MyIStream := TStreamAdapter.Create(Pic_MS);
  BmpX := TGPBitmap.Create(MyIStream);
  Bmp.Width := 60;
  Bmp.Height := 60;
  Graphic := TGPGraphics.Create(Bmp.Canvas.Handle);
  Graphic.SetInterpolationMode(InterpolationModeHighQualityBicubic);
  Graphic.DrawImage(BmpX, 0.0, 0.0, Bmp.Width, Bmp.Height);
  pic.Assign(Bmp);
//  Fm_Main.NG_New_Album.Cell[Fm_Main.New_Album_Col_Pic.Index, NewNo].Data := pic.Graphic;
  Bmp.free; //�����ͷ���Դ
  BmpX.free;
  Pic_MS.free;
  Graphic.free;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

{ Get_Recom_MV ��ȡÿ���Ƽ���MV����Ϣ}

constructor Get_Recom_MV.Create(AreaName: string);
begin
  Area_Name := AreaName;
  inherited Create(false);
end;

procedure Get_Recom_MV.Execute;
var(*ִ���Ƽ�MV��ȡ�߳�*)
  joMV, itemMV: Isuperobject;
  strMV: string;
  MV_No: Word;
begin
  FreeOnTerminate := True;
  OnTerminate := Fm_Main.Search_Over;
  MV_No := 0;
  strMV := Get_Info(Area_Name);
  joMV := SO(strMV);
  for itemMV in joMV['data.mvlist'] do
  begin
    vMsg := TQQ_Recom_MV_MSG.Create;
    vMsg.MV_Name := joMV['data.mvlist[' + inttostr(MV_No) + '].mvtitle'].AsString; //MV��
    vMsg.MV_Singer := joMV['data.mvlist[' + inttostr(MV_No) + '].singer_name'].AsString; //����
    vMsg.MV_From := '1';
    vMsg.MV_Img := joMV['data.mvlist[' + inttostr(MV_No) + '].picurl'].AsString; //MV����ͼ��ַ
    Song_Img := joMV['data.mvlist[' + inttostr(MV_No) + '].picurl'].AsString; //MV����ͼ��ַ
    vMsg.MV_SingerID := joMV['data.mvlist[' + inttostr(MV_No) + '].singer_mid'].AsString; //����ID
    vMsg.MV_MVID := joMV['data.mvlist[' + inttostr(MV_No) + '].vid'].AsString; //MVID
    vMsg.MV_Des := joMV['data.mvlist[' + inttostr(MV_No) + '].mvdesc'].AsString; //MV����
    vMsg.MV_Pub := joMV['data.mvlist[' + inttostr(MV_No) + '].pub_date'].AsString; //����ʱ��
    vMsg.MV_No := joMV['data.mvlist[' + inttostr(MV_No) + '].listennum'].AsString; //������
    Synchronize(Get_List_Img);
    GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ
    Inc(MV_No);
  end;
end;

function Get_Recom_MV.Get_Info(AreaName: string): string;
var(*��ȡ��MV�б�json*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  result := HP.Get(Recom_MV_Url + Area_Name);
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

procedure Get_Recom_MV.Get_List_Img;
var(*��ȡMV����ͼ*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
  Pic_MS: TMemoryStream;
  MyIStream: TStreamAdapter;
  Bmp: Vcl.Graphics.tbitmap;
  BmpX: TGPBitmap;
  Graphic: TGPGraphics;
  pic: tPicture;
begin
  pic := TPicture.Create;
  Bmp := Vcl.Graphics.tbitmap.Create;
  Pic_MS := TMemoryStream.Create();
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  HP.Get(Song_Img, Pic_MS); //��ȡͼƬ���洢����
  Pic_MS.Position := 0;
  MyIStream := TStreamAdapter.Create(Pic_MS);
  BmpX := TGPBitmap.Create(MyIStream);
  Bmp.Width := 300;
  Bmp.Height := 170;
  Graphic := TGPGraphics.Create(Bmp.Canvas.Handle);
  Graphic.SetInterpolationMode(InterpolationModeHighQualityBicubic);
  Graphic.DrawImage(BmpX, 0.0, 0.0, Bmp.Width, Bmp.Height);
  pic.Assign(Bmp);
  pic.Graphic.SaveToStream(vMsg.MV_Pic);
  Bmp.free; //�����ͷ���Դ
  BmpX.free;
  Pic_MS.free;
  Graphic.free;
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

{ Get_Album_From_AlbumID }

constructor Get_Album_From_AlbumID.Create(AlbumID: string);
begin
  Album_ID := AlbumID;
  inherited Create(false);
end;

procedure Get_Album_From_AlbumID.Execute;
var
  str: string;
  joAlbum, itemAlbum: ISuperObject;
  vMsg: TQQ_Album_Song_MSG;
  ct: integer;
begin
  FreeOnTerminate := True;
  OnTerminate := Fm_Main.Search_Over;
  ct := 0;
  str := Get_Info(Album_ID);
  joAlbum := SO(str);
  for itemAlbum in joAlbum['data.list'] do
  begin
    vMsg := TQQ_Album_Song_MSG.Create;
    vMsg.Song_Name := joAlbum['data.list[' + inttostr(ct) + '].songname'].AsString; //����
    vMsg.Song_Singer := joAlbum['data.list[' + inttostr(ct) + '].singer[0].name'].AsString; //������
    vMsg.Song_Album := joAlbum['data.list[' + inttostr(ct) + '].albumname'].AsString; //ר����
    vMsg.Song_Time := joAlbum['data.list[' + inttostr(ct) + '].interval'].AsString; //ʱ��
    vMsg.Song_From := '1'; //��Դ
    vMsg.Song_Img := 'https://y.gtimg.cn/music/photo_new/T002R300x300M000' + Album_ID + '.jpg'; //ͼƬ
    vMsg.Song_ID := joAlbum['data.list[' + inttostr(ct) + '].strMediaMid'].AsString; //����id
    vMsg.Song_SingerID := joAlbum['data.list[' + inttostr(ct) + '].singer[0].mid'].AsString; //����id
    vMsg.Song_AlbumID := Album_ID; //ר��id
    vMsg.Song_MVID := joAlbum['data.list[' + inttostr(ct) + '].vid'].AsString; //MV ID
    vMsg.Song_Lrc := '';
    GlobalVMsgMonitor.PostVMsg(vMsg); //������Ϣ
    inc(ct);
  end;
end;

function Get_Album_From_AlbumID.Get_Info(AlbumIDX: string): string;
var(*������ר���б�json*)
  HP: TIdHTTP;
  SSL: TIdIOHandlerSocket;
begin
  HP := TIdHTTP.Create(nil);
  SSL := TIdIOHandlerSocket(nil);
  HP.IOHandler := SSL;
  HP.Request.UserAgent := UserAgent; // ����UserAgent
  result := HP.Get(Album_Url + AlbumIDX);
  FreeAndNil(HP);
  FreeAndNil(SSL);
end;

end.

