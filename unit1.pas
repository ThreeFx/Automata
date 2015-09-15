unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Automat;

type

  { TForm1 }

  TForm1 = class(TForm)
    dateiButton: TButton;
    eingabesenden: TButton;
    eingabe: TEdit;
    daumenhoch: TImage;
    daumenrunter: TImage;
    graph: TImage;
    importLabel: TLabel;
    chooseFile: TOpenDialog;
    akzeptiert: TLabel;
    status: TLabel;
    procedure dateiButtonClick(Sender: TObject);
    procedure eingabesendenClick(Sender: TObject);
    procedure automatVisualisieren();
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



procedure TForm1.dateiButtonClick(Sender: TObject);
var
    filename: string;
begin
  if chooseFile.Execute then
    filename := chooseFile.Filename;
  dateiButton.Caption := 'Datei gewählt: ...' + Copy(filename, Length(filename) - 20, 21);
  dateiButton.Width := 300;
  status.Caption := 'Automat in Arbeit.';
  automatVisualisieren();
end;

procedure TForm1.eingabesendenClick(Sender: TObject);
begin
   status.caption := eingabe.text;
   IF eingabe.text = 'anneliese' THEN
   BEGIN
   	daumenhoch.Visible := True;
        daumenrunter.Visible := True;
   END
   ELSE BEGIN
        daumenhoch.Visible := False;
        daumenrunter.Visible := True;
   END;
end;

procedure zeichneZustand(gr : TImage; zeile, spalte: Integer; name : String);
begin
     gr.canvas.Ellipse(30 + (spalte - 1) * 200, 30 + (zeile - 1) * 200, 150 + (spalte - 1) * 200, 150 + (zeile - 1) * 200);
     gr.canvas.TextOut(50 + (spalte - 1) * 200,80 + (zeile - 1) * 200,Copy(name, 1, 14));
end;

procedure verbindeZustaende(gr : TImage; x1,y1,x2,y2 : Integer; name : String);
var abw : Integer;
begin
     if ((x1 <> x2) AND (y1 <> y2)) then
     begin
       abw := 30 + Random(60);
       gr.canvas.Line(30 + abw + (y1 - 1) * 200, 30 + abw + (x1 - 1) * 200, 30 + abw +  (y2 - 1) * 200, 30 + abw + (x2 - 1) * 200);
       gr.canvas.Rectangle(20 + abw +  (y2 - 1) * 200, 20 + abw + (x2 - 1) * 200, 40 + abw +  (y2 - 1) * 200, 40 + abw + (x2 - 1) * 200);
       gr.canvas.TextOut(22 + abw +  (y2 - 1) * 200, 22 + abw + (x2 - 1) * 200, Copy(name, 1, 3));
     end else
     begin
       { Selbstreferenz kann man nicht als einfache Linie umsetzen... Was anderes überlegen }
     end;
end;

procedure markiereZustand(gr : TImage; zeile, spalte: Integer);
begin
   gr.canvas.Pen.Color := clRed;
   gr.canvas.Brush.Style:=bsClear;
   zeichneZustand(gr, zeile, spalte, '');
   gr.canvas.Brush.Style:=bsSolid;
   gr.canvas.Pen.Color := clBlack;
end;

procedure zustandNormal(gr : TImage; zeile, spalte: Integer);
begin
   gr.canvas.Brush.Style:=bsClear;
   zeichneZustand(gr, zeile, spalte, '');
   gr.canvas.Brush.Style:=bsSolid;
end;

procedure TForm1.automatVisualisieren();
begin
     graph.canvas.Brush.Color := clWhite;
     graph.Canvas.Brush.Style:=bsSolid;
     graph.canvas.Pen.Color := clBlack;

     graph.canvas.clear;
     graph.canvas.clear;

     zeichneZustand(graph,1,1,'q_0');
     zeichneZustand(graph,2,2,'q_1');
     zeichneZustand(graph,1,3,'q_2');


     Randomize;
     verbindeZustaende(graph, 1,1,2,2, '0');
     verbindeZustaende(graph, 2,2,1,1, '1');
     verbindeZustaende(graph, 2,2,1,3, '0');
     verbindeZustaende(graph, 1,3,1,1, '1');

     markiereZustand(graph, 1,1);
     markiereZustand(graph, 1, 3);
     zustandNormal(graph,1,3);


end;




















end.
