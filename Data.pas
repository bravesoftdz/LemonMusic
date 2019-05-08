(**************************************************)
(*                                                *)
(*          ����Ԫ���ڸ����б�洢����            *)
(*                                                *)
(*              Copyright (c) 2019                *)
(*                     ����                       *)
(*                                                *)
(**************************************************)
unit Data;

interface

uses
  superobject, System.SysUtils, System.Classes, Vcl.Controls, NxControls6,
  NxVirtualGrid6, NxGrid6, dxmdaset, InfoFromID;

type
  IO_List = class
  private
    const
      INIT_Str = '{"customlist":[],"playlist":[]}';
  public
    procedure Create_Json; // ��ʼ������JSON�����ļ�
    function Open_Json: string; // ��JSON�����ļ�
    procedure AddSongs(ListName: string; Music_Info: array of string); // ���б�д�������Ϣ
    procedure DelSongs(ListName, SongID: string); // ɾ���б������Ϣ
  end;

type
  LD_List = class(TThread)
  private
    var
      Filed_ID, Song_Name, Song_Album, Song_Singer, Song_Time, Song_Img, Song_Url, Song_ID, Song_From, Song_Count: string;
  public
    var
      NG_S: TNextGrid6;
      MEM_S: TdxMemData;
      LM: string;
    constructor Create(ListName: string; NG: TNextGrid6; MEM: TdxMemData); overload; // ���캯��
  protected
    procedure Add_To; // ��ʾ���������б�
    procedure Execute; override;
  end;

implementation

uses
  Main, List,Start;
{ IO_List }
// ���б�д�������Ϣ  <Done>
procedure IO_List.AddSongs(ListName: string; Music_Info: array of string);
var
  jo: ISuperObject;
  sm: TStringStream;
  Add_Str: string;
begin
  sm := TStringStream.Create('', tencoding.UTF8);
  jo := so(Open_Json);
  Add_Str := '{"from":"' + Music_Info[0] + '","name":"' + Music_Info[1] + '","album":"' + Music_Info[2] + '","singer":"' + Music_Info[3] + '","time":"' + Music_Info[4] + '","img":"' + Music_Info[5] + '","id":"' + Music_Info[6] + '","singerid":"' + Music_Info[7] + '","albumid":"' + Music_Info[8] + '","mvid":"' + Music_Info[9] + '"}';
  jo.A[ListName].Add(so(Add_Str));
  jo.SaveTo(sm);
  sm.SaveToFile(ExtractFileDir(ParamStr(0)) + '\Data.json');
end;

// ��ʼ������JSON�����ļ������ļ������ڵ�����´���   <Done>
procedure IO_List.Create_Json;
var
  path: string;
  sm: TStringStream;
begin
  path := ExtractFileDir(ParamStr(0));
  sm := TStringStream.Create(INIT_Str, tencoding.UTF8);
  sm.SaveToFile(path + '\Data.json');
  FreeAndNil(sm);
end;

// ɾ�����ظ����б����   <Done>
procedure IO_List.DelSongs(ListName, SongID: string);
var
  jo, item: ISuperObject;
  ja: TSuperArray;
  sm: TStringStream;
  FIleName: string;
  no: Word;
begin
  FIleName := ExtractFileDir(ParamStr(0)) + '\Data.json';
  if not FileExists(FIleName) then
  begin
    // ��ʾ
  end
  else
  begin
    no := 0;
    sm := TStringStream.Create('', tencoding.UTF8);
    jo := so(Open_Json);
    ja := jo.A[ListName];
    for item in jo[ListName] do
    begin
      if jo[ListName + '[' + inttostr(no) + '].id'].AsString = SongID then
      begin
        ja.Delete(no);
        Break;
      end;
      Inc(no);
    end;
    jo.SaveTo(sm);
    sm.SaveToFile(ExtractFileDir(ParamStr(0)) + '\Data.json');
  end;
end;

// ��JSON�����ļ������ļ������ڵ�������ȴ���   <Done>
function IO_List.Open_Json: string;
var
  sm: TStringStream;
  FIleName: string;
begin
  FIleName := ExtractFileDir(ParamStr(0)) + '\Data.json';
  if not FileExists(FIleName) then // ����ļ������ڣ���ô����һ��
  begin
    Create_Json; // ��������ڣ���ô�ȴ���
  end;
  sm := TStringStream.Create('', tencoding.UTF8);
  sm.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\Data.json');
  result := sm.DataString;
end;

{ LD_List }
// ��������ʱ�����б��߳�
procedure LD_List.Add_To;
begin
  with MEM_S do
  begin
    Open;
    Append;
    FieldByName('S_ID').AsString := Filed_ID; // ���
    FieldByName('S_Name').AsString := Song_Name; // ����
    FieldByName('S_Album').AsString := Song_Album; // ר��
    FieldByName('S_Singer').AsString := Song_Singer; // ����
    FieldByName('S_Time').AsString := Song_Time; // ʱ��
    FieldByName('S_From').AsString := Song_From; // ��Դ
    FieldByName('S_Url').AsString := Song_Url; // ���ص�ַ
    FieldByName('S_Img').AsString := Song_Img; // ͼƬ��ַ
    FieldByName('S_MusicId').AsString := Song_ID; // ����ID
    Post;
  end;
  with NG_S.AddRow.Cells do
  begin
    item[1].AsString := Filed_ID;
    item[2].AsString := Song_Name;
    item[3].AsString := Song_Album;
    item[4].AsString := Song_Singer;
    item[5].AsString := Song_Time;
    item[6].AsString := Song_From;
    item[7].AsString := Song_Url;
    item[8].AsString := Song_Img;
    item[9].AsString := Song_ID;
    // Item[10].AsString := SongList[i].ChildNodes['SingerID'].Text;
    // Item[10].AsString := SongList[i].ChildNodes['AlbumID'].Text;
    // Item[10].AsString := SongList[i].ChildNodes['MVID'].Text;
  end;
  Fm_Main.BTN_PlayList.Caption := Song_Count;
  Fm_List.SB_List.Max := StrToInt(Song_Count);
end;

constructor LD_List.Create(ListName: string; NG: TNextGrid6; MEM: TdxMemData);
begin
  NG_S := NG;
  MEM_S := MEM;
  LM := ListName;
  inherited Create(True);
end;

procedure LD_List.Execute;
var
  FIleName: string;
  IO: IO_List;
  jo, item: ISuperObject;
  Num: Word;
  GT: GetFromId;
begin
  FreeOnTerminate := True;
  OnTerminate := Fm_Main.Search_Over;
  FIleName := ExtractFileDir(ParamStr(0)) + '\Data.json';
  if FileExists(FIleName) then // ����ļ����ڣ���ôִ�ж�ȡ
  begin
    Num := 0;
    IO := IO_List.Create;
    jo := so(IO.Open_Json);
    MEM_S.Open;
    MEM_S.First;
    for item in jo[LM] do
    begin
      GT := GetFromId.Create;
      GT.ID := jo[LM + '[' + inttostr(Num) + '].id'].AsString;
      case StrToInt(jo[LM + '[' + inttostr(Num) + '].from'].AsString) of
        1: // QQ����
          begin
            Song_Url := GT.GetFromId_QQ;
          end;
        2: // ��������
          begin
            Song_Url := GT.GetFromId_WangYi;
          end;
        3: // ��������
          begin
            Song_Url := GT.GetFromId_Kuwo;
          end;
        4: // �ṷ����
          begin
            Song_Url := GT.GetFromId_KuGou;
          end;
      end;
      GT.Free;
      Filed_ID := inttostr(Num + 1);
      Song_Name := jo[LM + '[' + inttostr(Num) + '].name'].AsString;
      Song_Album := jo[LM + '[' + inttostr(Num) + '].album'].AsString;
      Song_Singer := jo[LM + '[' + inttostr(Num) + '].singer'].AsString;
      Song_Time := jo[LM + '[' + inttostr(Num) + '].time'].AsString;
      Song_Img := jo[LM + '[' + inttostr(Num) + '].img'].AsString;
      Song_ID := jo[LM + '[' + inttostr(Num) + '].id'].AsString;
      Song_From := jo[LM + '[' + inttostr(Num) + '].from'].AsString;
      Song_Count := inttostr(Num + 1);
      Synchronize(Add_To);
      Inc(Num);
      Fm_Start.LB_Satate.Caption := '�������벥���б�<'+inttostr(Num)+'>����';
    end;
    IO.Free;
  end;
end;

end.

