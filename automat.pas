UNIT Automat;

INTERFACE

USES fgl;

TYPE 	
	TZustand = CLASS;
	TZustand = CLASS
	PRIVATE
		next: TFPGMap<char,TZustand>; {TFPGMap --> Dicitonary --> generisches Array}
	PUBLIC
		CONSTRUCTOR Create(dict: TFPGMap<char,TZustand>);
		DESTRUCTOR Dispose;
		FUNCTION GetNext(zeichen: char): TZustand;
	END;
	

IMPLEMENTATION

CONSTRUCTOR TZustand.Create(dict: TFPGMap<char,TZustand>);
BEGIN
	next := dict;
END;

DESTRUCTOR TZustand.Dispose;
VAR
	i: integer;
BEGIN
	FOR i:=0 TO next.Count-1 DO
	BEGIN
		next.Remove(next.Keys[i]);
	END;
END;

FUNCTION TZustand.GetNext(zeichen: char): TZustand;
VAR
	sinnlos: integer;
BEGIN
	next.Find(zeichen,sinnlos);
	result:=next.GetData(sinnlos);
END;


BEGIN
END.
