(**************************************************)
(*                                                *)
(*         ����Ԫ���ڲ���XML��Ϊ�����б�          *)
(*                                                *)
(*              Copyright (c) 2019                *)
(*                     ����                       *)
(*                                                *)
(**************************************************)
unit XMLX;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
  NxControls6, NxVirtualGrid6, NxGrid6, dxmdaset,ActiveX;

type
  XML_RW = class
  public
    procedure CreateXml; // �����б�XML
    function AddNewList(TCOM: TControl; List_Name: string): boolean; // �������б�
    function AddSongs(TCOM: TControl; ListName: string; Music_Info: array of string): boolean; // ���б�д�������Ϣ
    procedure DelSongs(TCOM: TControl; NodeText, SearchText: string); // ɾ���赥����

    function Show_List(TCOM: TControl): TStringList; // ��ʾ�Զ����б�
//    function Add_Song_List(TCOM: TControl; LB: TscGPListBox; ListName: string): TStringList; // �Ѹ�����ӵ������б�
  end;

type
  ShowList = class(TThread)
  private
    var
      Filed_ID, Song_Name, Song_Album, Song_Singer, Song_Time, Song_Img, Song_Url, Song_ID, Song_From: string;
  public
    var
      TCOM_S: TControl;
      NG_S: TNextGrid6;
      MEM_S: TdxMemData;
    // function ShowSongs(TCOM: TControl; NG: TNextGrid6; MEM: TdxMemData): string; // ��ʾ�����б�
    constructor Create(TCOM: TControl; NG: TNextGrid6; MEM: TdxMemData); overload; // ���캯��
  protected
    procedure Add_To; // ��ʾ���������б�
    procedure Execute; override;
  end;

implementation

uses
  InfoFromID, Main, List;

{// �Ѹ�����ӵ������б�
function XML_RW.Add_Song_List(TCOM: TControl; LB: TscGPListBox; ListName: string): TStringList;
var
  XMLDoc: TXMLDocument;
  FileName: string;
  NodeList, SongList: IXMLNodeList;
  i: Integer;
begin
  result := TStringList.Create;
  FileName := ExtractFileDir(ParamStr(0)) + '\MusicList.xml';
  if FileExists(FileName) then // ����ļ�����
  begin
    XMLDoc := TXMLDocument.Create(TCOM);
    XMLDoc.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
    XMLDoc.Active := True;
    NodeList := XMLDoc.DocumentElement.ChildNodes; // ��Ӧ���ڵ����ӽڵ��б�
    for i := 0 to NodeList.Count - 1 do
    begin
      if NodeList[i].AttributeNodes[0].Text = ListName then
      begin
        SongList := NodeList[i].ChildNodes;
      end;
    end;
    for i := 0 to SongList.Count - 1 do
    begin
      with LB.Items.Add do
      begin
        Caption := SongList[i].ChildNodes['Name'].Text;
        Detail := SongList[i].ChildNodes['Singer'].Text;
        result.Add(SongList[i].ChildNodes['Url'].Text);
        if SongList[i].ChildNodes['From'].Text = 'ĳ��' then
          ImageIndex := 0;
        if SongList[i].ChildNodes['From'].Text = 'ĳQ' then
          ImageIndex := 1;
        if SongList[i].ChildNodes['From'].Text = 'ĳ��' then
          ImageIndex := 2;
        if SongList[i].ChildNodes['From'].Text = 'ĳ��' then
          ImageIndex := 3;
        if SongList[i].ChildNodes['From'].Text = 'ĳ��' then
          ImageIndex := 4;
        if SongList[i].ChildNodes['From'].Text = 'ĳ��' then
          ImageIndex := 5;
        if SongList[i].ChildNodes['From'].Text = 'ĳ��' then
          ImageIndex := 6;
      end;
    end;
    XMLDoc.Free;
  end;
end;
*/}
procedure ShowList.Add_To;
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
    Item[1].AsString := Filed_ID;
    Item[2].AsString := Song_Name;
    Item[3].AsString := Song_Album;
    Item[4].AsString := Song_Singer;
    Item[5].AsString := Song_Time;
    Item[6].AsString := Song_From;
    Item[7].AsString := Song_Url;
    Item[8].AsString := Song_Img;
    Item[9].AsString := Song_ID;
    // Item[10].AsString := SongList[i].ChildNodes['SingerID'].Text;
    // Item[10].AsString := SongList[i].ChildNodes['AlbumID'].Text;
    // Item[10].AsString := SongList[i].ChildNodes['MVID'].Text;
  end;
end;

constructor ShowList.Create(TCOM: TControl; NG: TNextGrid6; MEM: TdxMemData);
begin
  TCOM := TCOM_S;
  NG := NG_S;
  MEM := MEM_S;
  inherited Create(True);
end;

// ��ʾ�����б�
procedure ShowList.Execute;
var
  XMLDoc: TXMLDocument;
  NodeList, SongList: IXMLNodeList;
  FileName: string;
  i, Index: Integer;
  gt: GetFromId;
begin
  FreeOnTerminate := True;
  FileName := ExtractFileDir(ParamStr(0)) + '\MusicList.xml';
  if FileExists(FileName) then // ����ļ�����
  begin
    CoInitialize(nil);
    try
    XMLDoc := TXMLDocument.Create(TCOM_S);
    XMLDoc.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
    XMLDoc.Active := True;
    NodeList := XMLDoc.DocumentElement.ChildNodes; // ��Ӧ���ڵ����ӽڵ��б�
    for i := 0 to NodeList.Count - 1 do
    begin
      if NodeList[i].AttributeNodes[0].Text = 'PlayList' then
      begin
        SongList := NodeList[i].ChildNodes;
      end;
    end;
    MEM_S.Open;
    MEM_S.First;
    for i := 0 to SongList.Count - 1 do
    begin
      case strtoint(SongList[i].ChildNodes['From'].Text) of
        1: // QQ����
          begin
            gt := GetFromId.Create(SongList[i].ChildNodes['ID'].Text);
            Song_Url := gt.GetFromId_QQ;
            gt.Free;
          end;
        2: // ��������
          begin
            gt := GetFromId.Create(SongList[i].ChildNodes['ID'].Text);
            Song_Url := gt.GetFromId_WangYi;
            gt.Free;
          end;
        3: // �ṷ����
          begin
            gt := GetFromId.Create(SongList[i].ChildNodes['ID'].Text);
            Song_Url := gt.GetFromId_KuGou;
            gt.Free;
          end;
        4: // ��������
          begin
            gt := GetFromId.Create(SongList[i].ChildNodes['ID'].Text);
            Song_Url := gt.GetFromId_Kuwo;
            gt.Free;
          end;
      end;
      Filed_ID := inttostr(i + 1);
      Song_Name := SongList[i].ChildNodes['Name'].Text;
      Song_Album := SongList[i].ChildNodes['Album'].Text;
      Song_Singer := SongList[i].ChildNodes['Singer'].Text;
      Song_Time := SongList[i].ChildNodes['Time'].Text;
      Song_Img := SongList[i].ChildNodes['Img'].Text;
      Song_ID := SongList[i].ChildNodes['ID'].Text;
      Song_From := SongList[i].ChildNodes['From'].Text;
    end;
    Synchronize(Add_To);
    Fm_Main.BTN_PlayList.Caption := inttostr(SongList.Count);
    XMLDoc.Free;
    finally
      CoUninitialize;
    end;
  end;
end;

// �����µ�XML�����ļ���ɾ��������´���<Down>
procedure XML_RW.CreateXml;
var
  Root, PlayList, DownLoadList: IXmlNode;
  NewXml: IXmlDocument;
begin
  NewXml := NewXmlDocument();
  try
    NewXml.Encoding := 'UTF-8';
    Root := NewXml.AddChild('Lists');
    PlayList := Root.AddChild('MusicList'); // ����ʱ�Զ�����һ�������б�ڵ�
    PlayList.Attributes['ListName'] := 'PlayList'; // �б�ڵ㱸ע
    // DownLoadList := Root.AddChild('MusicList'); // ����ʱ�Զ�����һ�������б�ڵ�
    // DownLoadList.Attributes['ListName'] := 'DownLoadList'; // �б�ڵ㱸ע
    NewXml.SaveToFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
  finally
    NewXml := nil;
  end;
end;

// ���б�д�������Ϣ<Down>
function XML_RW.AddSongs(TCOM: TControl; ListName: string; Music_Info: array of string): boolean;
var
  Songs: IXmlNode;
  Music_Node: array[0..9] of IXmlNode;
  XMLDoc: TXMLDocument;
  FileName: string;
  NodeList: IXMLNodeList; // �洢���ڵ��µ��ӽڵ��б����ڲ�����Ŀ�б��Ƿ����
  i: Integer; // ��������
begin
  result := false;
  FileName := ExtractFileDir(ParamStr(0)) + '\MusicList.xml';
  if not FileExists(FileName) then // ����ļ������ڣ���ô����һ��
  begin
    CreateXml; // ��������ڣ���ô�ȴ���
  end;
  XMLDoc := TXMLDocument.Create(TCOM);
  XMLDoc.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
  XMLDoc.Active := True; // ����XML�ļ�
  NodeList := XMLDoc.DocumentElement.ChildNodes; // ��Ӧ���ڵ����ӽڵ��б�
  for i := 0 to NodeList.Count - 1 do
  begin
    try
      if NodeList[i].AttributeNodes[0].Text = ListName then // ����ýڵ����
      begin
        Songs := NodeList[i].AddChild('Songs'); // ������ڵ���
        Music_Node[0] := Songs.AddChild('From'); // ��Դ
        Music_Node[0].Text := Music_Info[0];
        Music_Node[1] := Songs.AddChild('Name'); // ����
        Music_Node[1].Text := Music_Info[1];
        Music_Node[2] := Songs.AddChild('Album'); // ר��
        Music_Node[2].Text := Music_Info[2];
        Music_Node[3] := Songs.AddChild('Singer'); // ����
        Music_Node[3].Text := Music_Info[3];
        Music_Node[4] := Songs.AddChild('Time'); // ʱ��
        Music_Node[4].Text := Music_Info[4];
        Music_Node[5] := Songs.AddChild('Img'); // ͼƬ
        Music_Node[5].Text := Music_Info[5];
        Music_Node[6] := Songs.AddChild('ID'); // ����ID
        Music_Node[6].Text := Music_Info[6];
        Music_Node[7] := Songs.AddChild('SingerID'); // ����ID
        Music_Node[7].Text := Music_Info[7];
        Music_Node[8] := Songs.AddChild('AlbumID'); // ר��ID
        Music_Node[8].Text := Music_Info[8];
        Music_Node[9] := Songs.AddChild('MVID'); // MV ID
        Music_Node[9].Text := Music_Info[9];
        XMLDoc.SaveToFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
        result := True;
        Break;
      end; // �������������ʾ
    except

    end;
  end;
  XMLDoc.Free;
end;

// �������б����½������б��ʱ�򴴽�
function XML_RW.AddNewList(TCOM: TControl; List_Name: string): boolean;
var
  NewList: IXmlNode;
  XMLDoc: TXMLDocument;
  FileName: string;
  NodeList: IXMLNodeList; // �洢���ڵ��µ��ӽڵ��б����ڲ�����Ŀ�б��Ƿ����
  i: Integer; // ��������
  bo: boolean;
begin
  bo := True;
  result := false;
  FileName := ExtractFileDir(ParamStr(0)) + '\MusicList.xml';
  if not FileExists(FileName) then // ����ļ������ڣ���ô����һ��
  begin
    CreateXml;
  end;
  XMLDoc := TXMLDocument.Create(TCOM);
  XMLDoc.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
  XMLDoc.Active := True;
  NodeList := XMLDoc.DocumentElement.ChildNodes; // ��Ӧ���ڵ����ӽڵ��б�
  for i := 0 to NodeList.Count - 1 do
  begin
    try
      if NodeList[i].AttributeNodes[0].Text = List_Name then
      begin
        bo := false;
      end;
    finally

    end;
  end;
  if bo then
  begin
    NewList := XMLDoc.DocumentElement.AddChild('MusicList'); // ����б�ڵ�
    NewList.Attributes['ListName'] := List_Name; // �б�ڵ㱸ע
    XMLDoc.SaveToFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
    result := bo;
  end;
  XMLDoc.Free;
end;

// ɾ���赥��ĸ���<Down>
procedure XML_RW.DelSongs(TCOM: TControl; NodeText, SearchText: string);
var
  XMLDoc: TXMLDocument;
  FileName: string;
  NodeList: IXMLNodeList;
  i: Integer;
begin
  FileName := ExtractFileDir(ParamStr(0)) + '\MusicList.xml';
  if FileExists(FileName) then // ����ļ�����
  begin
    XMLDoc := TXMLDocument.Create(TCOM);
    XMLDoc.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
    XMLDoc.Active := True;
    for i := 0 to XMLDoc.DocumentElement.ChildNodes.Count - 1 do
    begin
      if XMLDoc.DocumentElement.ChildNodes[i].AttributeNodes[0].Text = NodeText then
      begin
        NodeList := XMLDoc.DocumentElement.ChildNodes[i].ChildNodes;
      end;
    end;
  end;
  for i := 0 to NodeList.Count - 1 do
  begin
    if NodeList[i].ChildNodes['ID'].Text = SearchText then
    begin
      NodeList.Delete(i);
      XMLDoc.SaveToFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
      Exit;
    end;
  end;
  XMLDoc.SaveToFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
end;

// ��ʾ�Զ����б�
function XML_RW.Show_List(TCOM: TControl): TStringList;
var
  XMLDoc: TXMLDocument;
  FileName: string;
  i: Integer;
begin
  result := TStringList.Create;
  FileName := ExtractFileDir(ParamStr(0)) + '\MusicList.xml';
  if FileExists(FileName) then // ����ļ�����
  begin
    XMLDoc := TXMLDocument.Create(TCOM);
    XMLDoc.LoadFromFile(ExtractFileDir(ParamStr(0)) + '\MusicList.xml');
    XMLDoc.Active := True;
    for i := 0 to XMLDoc.DocumentElement.ChildNodes.Count - 1 do
    begin
      if (XMLDoc.DocumentElement.ChildNodes[i].AttributeNodes[0].Text <> 'LikeList') and (XMLDoc.DocumentElement.ChildNodes[i].AttributeNodes[0].Text <> 'DownLoadList') then
      begin
        result.Add(XMLDoc.DocumentElement.ChildNodes[i].AttributeNodes[0].Text);
      end;
    end;
  end;
end;

end.

