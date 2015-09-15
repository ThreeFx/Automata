unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    eingabesenden: TButton;
    eingabe: TEdit;
    daumenhoch: TImage;
    daumenrunter: TImage;
    importLabel: TLabel;
    chooseFile: TOpenDialog;
    akzeptiert: TLabel;
    status: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure eingabesendenClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation


{$R *.lfm}

{ TForm1 }



procedure TForm1.Button1Click(Sender: TObject);
var
    filename: string;
begin
  if chooseFile.Execute then
  begin
    filename := chooseFile.Filename;
    ShowMessage(filename);
  end;

  Button1.Caption := 'Datei gewählt: ...' + Copy(filename, Length(filename) - 20, 21);
  Button1.Width := 300;
  status.Caption := 'Automat in Arbeit.';
end;

procedure TForm1.eingabesendenClick(Sender: TObject);
begin
   status.caption := eingabe.text;
   IF eingabe.text = 'anneliese' THEN
   BEGIN
   	daumenhoch.Visible := True;
    daumenrunter.Visible := False;
   end
   ELSE
    BEGIN
    daumenhoch.Visible := False;
    daumenrunter.Visible := True;
    END;

end;


end.

