unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtDlgs, IOUtils, CommCtrl,
  Vcl.ComCtrls, System.ImageList, FileCtrl,
  Vcl.ImgList, Vcl.Imaging.jpeg, Vcl.ExtCtrls, DateUtils, Vcl.VirtualImageList,
  Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TForm1 = class(TForm)
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    StatusBar1: TStatusBar;
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Button2: TButton;
    RichEdit1: TRichEdit;
    Button4: TButton;
    Image1: TImage;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    function DeleteIlegalChar(pPath: string): string;
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit1.Text := OpenDialog1.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      if TPath.GetExtension(OpenDialog1.FileName) = '.txt' then
         Edit2.Text := OpenDialog1.FileName
      else
        Messagebox(0, 'The file must be a .txt', 'Only .txt', MB_OK or MB_ICONWARNING);
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  line, newPath, fileExtension, fullPath: string;
  Txt: TextFile;
  date0, date1: TDateTime;
begin
  if SelectDirectory('Selecciones', '%userprofile%', newPath) then
    begin
        date0 := Now;
        RichEdit1.Text := '� PhysicalDrive0.net' + #13 + '> File Renamer output' + #13 + '---------------------------';
        fileExtension := TPath.GetExtension(Edit1.Text);
        AssignFile(Txt, Edit2.Text);
        Reset(Txt);
        while not Eof(Txt) do
        begin
          Readln(Txt, line);
          fullPath := newPath + '\' + DeleteIlegalChar(line) + fileExtension;
          if CopyFile(PChar(Edit1.Text), PChar(fullPath), false) then
              RichEdit1.Text := RichEdit1.text + #13 + 'File packaging: ' + fullPath +' > Successfully!'
          else
              RichEdit1.Text := RichEdit1.text + #13 + 'File packaging: ' + fullPath +' > Error';
          Sleep(1);
        end;
        CloseFile(Txt);
        date1 := Now;
        RichEdit1.Text := RichEdit1.Text + #13 + '--------------------------------------------------------------------------------' + #13 + '> Time: ' + (DateUtils.MilliSecondsBetween(date0, date1) / 1000).ToString + ' seconds';
        SendMessage(RichEdit1.handle, WM_VSCROLL, SB_BOTTOM, 0);
        MessageBox(0, 'Files dumped successfully!', '', MB_OK);
    end;
end;


procedure TForm1.Button4Click(Sender: TObject);
begin
  MessageBox(0, '- Choose a file you want to copy multiple times.' + #13 + '- Choose a .txt with the desired names.' + #13 + '- (The file will be copied the number of names that appear in the txt)' + #13 + '- Select a folder for dump.', 'Usage', MB_OK or MB_ICONWARNING);
end;

function TForm1.DeleteIlegalChar(pPath: string): string;
var
  i: integer;
  auxiliar: string;
begin
  if TPath.HasValidFileNameChars(pPath, true) then
    Result := pPath
  else
    begin
      for i := 0 to Length(pPath) do
        begin
           auxiliar := pPath.Replace(pPath[i], '-');
           if TPath.HasValidFileNameChars(auxiliar, true) then
              Result := auxiliar;
        end;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  RichEdit1.Text := '';
  Left := round(Screen.Width / 2) - 200;
  Top := round(Screen.Height / 2) - 200;
end;

end.
