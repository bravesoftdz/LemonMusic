unit MSGs;

interface

uses
  System.Classes, VMsgMonitor, Vcl.Graphics;

type
// �˲�����������ÿ���Ƽ����赥������Ϣ�������̻߳�ȡÿ���Ƽ�����
  TQQ_Recom_List_MSG = class(TVMsg)
  private
    FName: string;
    FNum: string;
    FID: string;
    FImg: string;
  published
    property List_Name: string read FName write FName;
    property List_ID: string read FID write FID;
    property List_Num: string read FNum write FNum;
    property List_Img: string read FImg write FImg;
  end;

type
//�˲���������ʾ���赥���б����ϸ��Ŀ
  TQQ_List_Song_MSG = class(TVMsg)
  private
    FSong_Info: array[0..12] of string;
    function GetValue(index: integer): string;
    procedure SetValue(index: Integer; Value: string);
  published
    property Song_Name: string index 0 read GetValue write SetValue;
    property Song_Album: string index 1 read GetValue write SetValue;
    property Song_Singer: string index 2 read GetValue write SetValue;
    property Song_Time: string index 3 read GetValue write SetValue;
    property Song_From: string index 4 read GetValue write SetValue;
    property Song_Img: string index 5 read GetValue write SetValue;
    property Song_ID: string index 6 read GetValue write SetValue;
    property Song_AlbumID: string index 7 read GetValue write SetValue;
    property Song_SingerID: string index 8 read GetValue write SetValue;
    property Song_MVID: string index 9 read GetValue write SetValue;
    property Song_Lrc: string index 10 read GetValue write SetValue;
    property List_Title: string index 10 read GetValue write SetValue;
    property List_Des: string index 10 read GetValue write SetValue;
  end;

type
// �˲�����������ÿ���Ƽ���ר��������Ϣ�������̻߳�ȡÿ���Ƽ�����
  TQQ_Recom_Album_MSG = class(TVMsg)
  private
    FName: string;
    FSinger: string;
    FID: string;
    FImg: string;
  published
    property Album_Name: string read FName write FName;
    property Album_ID: string read FID write FID;
    property Album_Singer: string read FSinger write FSinger;
    property Album_Img: string read FImg write FImg;
  end;

type
//�˲���������ʾ��ר�����б����ϸ��Ŀ
  TQQ_Album_Song_MSG = class(TVMsg)
  private
    FSong_Info: array[0..10] of string;
    function GetValue(index: integer): string;
    procedure SetValue(index: Integer; Value: string);
  published
    property Song_Name: string index 0 read GetValue write SetValue;
    property Song_Album: string index 1 read GetValue write SetValue;
    property Song_Singer: string index 2 read GetValue write SetValue;
    property Song_Time: string index 3 read GetValue write SetValue;
    property Song_From: string index 4 read GetValue write SetValue;
    property Song_Img: string index 5 read GetValue write SetValue;
    property Song_ID: string index 6 read GetValue write SetValue;
    property Song_AlbumID: string index 7 read GetValue write SetValue;
    property Song_SingerID: string index 8 read GetValue write SetValue;
    property Song_MVID: string index 9 read GetValue write SetValue;
    property Song_Lrc: string index 10 read GetValue write SetValue;
  end;

type
// �˲�����������ÿ���Ƽ�������������Ϣ�������̻߳�ȡÿ���Ƽ�����
  TQQ_Recom_Song_MSG = class(TVMsg)
  private
    FSONG_Info: array[0..10] of string;
    function GetValue(index: integer): string;
    procedure SetValue(index: Integer; Value: string);
  published
    property Song_Name: string index 0 read GetValue write SetValue;
    property Song_Album: string index 1 read GetValue write SetValue;
    property Song_Singer: string index 2 read GetValue write SetValue;
    property Song_Time: string index 3 read GetValue write SetValue;
    property Song_From: string index 4 read GetValue write SetValue;
    property Song_Img: string index 5 read GetValue write SetValue;
    property Song_ID: string index 6 read GetValue write SetValue;
    property Song_AlbumID: string index 7 read GetValue write SetValue;
    property Song_SingerID: string index 8 read GetValue write SetValue;
    property Song_MVID: string index 9 read GetValue write SetValue;
    property Song_Lrc: string index 10 read GetValue write SetValue;
  end;

type
//�˲�������������QQ��������������õ����ݷ��ص������棬����Ϊ���������������Ƽ�������ϸ�б�
  TSearch_QQ_Song_MSG = class(TVMsg)
  private
    FSong_Info: array[0..10] of string;
    function GetValue(index: integer): string;
    procedure SetValue(index: Integer; Value: string);
  published
    property Song_Name: string index 0 read GetValue write SetValue;
    property Song_Album: string index 1 read GetValue write SetValue;
    property Song_Singer: string index 2 read GetValue write SetValue;
    property Song_Time: string index 3 read GetValue write SetValue;
    property Song_From: string index 4 read GetValue write SetValue;
    property Song_Img: string index 5 read GetValue write SetValue;
    property Song_ID: string index 6 read GetValue write SetValue;
    property Song_AlbumID: string index 7 read GetValue write SetValue;
    property Song_SingerID: string index 8 read GetValue write SetValue;
    property Song_MVID: string index 9 read GetValue write SetValue;
    property Song_Lrc: string index 10 read GetValue write SetValue;
  end;

type
//�˲����������������ס�������������õ����ݷ��ص�������
  TSearch_163_Song_MSG = class(TVMsg)
  private
    FSong_Info: array[0..10] of string;
    function GetValue(index: integer): string;
    procedure SetValue(index: Integer; Value: string);
  published
    property Song_Name: string index 0 read GetValue write SetValue;
    property Song_Album: string index 1 read GetValue write SetValue;
    property Song_Singer: string index 2 read GetValue write SetValue;
    property Song_Time: string index 3 read GetValue write SetValue;
    property Song_From: string index 4 read GetValue write SetValue;
    property Song_Img: string index 5 read GetValue write SetValue;
    property Song_ID: string index 6 read GetValue write SetValue;
    property Song_AlbumID: string index 7 read GetValue write SetValue;
    property Song_SingerID: string index 8 read GetValue write SetValue;
    property Song_MVID: string index 9 read GetValue write SetValue;
    property Song_Lrc: string index 10 read GetValue write SetValue;
  end;

type
//�˲����������������ҡ�������������õ����ݷ��ص�������
  TSearch_KuWo_Song_MSG = class(TVMsg)
  private
    FSong_Info: array[0..10] of string;
    function GetValue(index: integer): string;
    procedure SetValue(index: Integer; Value: string);
  published
    property Song_Name: string index 0 read GetValue write SetValue;
    property Song_Album: string index 1 read GetValue write SetValue;
    property Song_Singer: string index 2 read GetValue write SetValue;
    property Song_Time: string index 3 read GetValue write SetValue;
    property Song_From: string index 4 read GetValue write SetValue;
    property Song_Img: string index 5 read GetValue write SetValue;
    property Song_ID: string index 6 read GetValue write SetValue;
    property Song_AlbumID: string index 7 read GetValue write SetValue;
    property Song_SingerID: string index 8 read GetValue write SetValue;
    property Song_MVID: string index 9 read GetValue write SetValue;
    property Song_Lrc: string index 10 read GetValue write SetValue;
  end;

type
//�˲��������������ṷ��������������õ����ݷ��ص�������
  TSearch_KuGou_Song_MSG = class(TVMsg)
  private
    FSong_Info: array[0..10] of string;
    function GetValue(index: integer): string;
    procedure SetValue(index: Integer; Value: string);
  published
    property Song_Name: string index 0 read GetValue write SetValue;
    property Song_Album: string index 1 read GetValue write SetValue;
    property Song_Singer: string index 2 read GetValue write SetValue;
    property Song_Time: string index 3 read GetValue write SetValue;
    property Song_From: string index 4 read GetValue write SetValue;
    property Song_Img: string index 5 read GetValue write SetValue;
    property Song_ID: string index 6 read GetValue write SetValue;
    property Song_AlbumID: string index 7 read GetValue write SetValue;
    property Song_SingerID: string index 8 read GetValue write SetValue;
    property Song_MVID: string index 9 read GetValue write SetValue;
    property Song_Lrc: string index 10 read GetValue write SetValue;
  end;

type
//�˲�������������QQ����MV����������õ����ݷ��ص�������
  TQQ_Recom_MV_MSG = class(TVMsg)
  private
    FMV_Info: array[0..8] of string;
    FMV_Pic: TMemoryStream; //ͼƬ��
    function GetValue(index: integer): string;
    procedure SetValue(index: Integer; Value: string);
  public
    constructor Create; overload;
    destructor Destory; overload;
  published
    property MV_Name: string index 0 read GetValue write SetValue;
    property MV_Singer: string index 1 read GetValue write SetValue;
    property MV_From: string index 2 read GetValue write SetValue;
    property MV_Img: string index 3 read GetValue write SetValue;
    property MV_SingerID: string index 4 read GetValue write SetValue;
    property MV_MVID: string index 5 read GetValue write SetValue;
    property MV_Des: string index 6 read GetValue write SetValue;
    property MV_Pub: string index 7 read GetValue write SetValue;
    property MV_No: string index 8 read GetValue write SetValue;
    property MV_Pic: TMemoryStream read FMV_Pic write FMV_Pic;
  end;

implementation


{ TSearch_Song_MSG }

function TSearch_QQ_Song_MSG.GetValue(index: integer): string;
begin
  Result := FSong_Info[index];
end;

procedure TSearch_QQ_Song_MSG.SetValue(index: Integer; Value: string);
begin
  FSong_Info[index] := Value;
end;

{ TQQ_Recom_Songs_MSG }

function TQQ_List_Song_MSG.GetValue(index: integer): string;
begin
  Result := FSong_Info[index];
end;

procedure TQQ_List_Song_MSG.SetValue(index: Integer; Value: string);
begin
  FSong_Info[index] := Value;
end;

{ TSearch_163_Song_MSG }

function TSearch_163_Song_MSG.GetValue(index: integer): string;
begin
  Result := FSong_Info[index];
end;

procedure TSearch_163_Song_MSG.SetValue(index: Integer; Value: string);
begin
  FSong_Info[index] := Value;
end;

{ TSearch_KuWo_Song_MSG }

function TSearch_KuWo_Song_MSG.GetValue(index: integer): string;
begin
  Result := FSong_Info[index];
end;

procedure TSearch_KuWo_Song_MSG.SetValue(index: Integer; Value: string);
begin
  FSong_Info[index] := Value;
end;

{ TSearch_KuGou_Song_MSG }

function TSearch_KuGou_Song_MSG.GetValue(index: integer): string;
begin
  Result := FSong_Info[index];
end;

procedure TSearch_KuGou_Song_MSG.SetValue(index: Integer; Value: string);
begin
  FSong_Info[index] := Value;
end;

{ TAlbum_Song_MSG }

function TQQ_Album_Song_MSG.GetValue(index: integer): string;
begin
  Result := FSong_Info[index];
end;

procedure TQQ_Album_Song_MSG.SetValue(index: Integer; Value: string);
begin
  FSong_Info[index] := Value;
end;

{ TQQ_Recom_MV_MSG }

constructor TQQ_Recom_MV_MSG.Create;
begin
  FMV_Pic := TMemoryStream.Create; //ͼƬ��
end;

destructor TQQ_Recom_MV_MSG.Destory;
begin
  FMV_Pic.Free;
end;

function TQQ_Recom_MV_MSG.GetValue(index: integer): string;
begin
  Result := FMV_Info[index];
end;

procedure TQQ_Recom_MV_MSG.SetValue(index: Integer; Value: string);
begin
  FMV_Info[index] := Value;
end;

{ TQQ_Recom_Song_MSG }

function TQQ_Recom_Song_MSG.GetValue(index: integer): string;
begin
  Result := FSONG_Info[index];
end;

procedure TQQ_Recom_Song_MSG.SetValue(index: Integer; Value: string);
begin
  FSONG_Info[index] := Value;
end;

end.

