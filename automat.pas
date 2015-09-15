UNIT Automat;

{$STATIC ON}

INTERFACE

USES fgl;

TYPE
	TZustand = CLASS
		PRIVATE
			name : String;
		PUBLIC
			CONSTRUCTOR Create(_name : String);
			DESTRUCTOR Dispose();
			FUNCTION GetName() : String;
	END;

	{TZustand = CLASS
	PRIVATE
		next: TFPGMap<char,TZustand>; {TFPGMap --> Dicitonary --> generisches Array}
		PUBLIC
		CONSTRUCTOR Create(dict: TFPGMap<char,TZustand>);
		DESTRUCTOR Dispose;
		FUNCTION GetNext(zeichen: char): TZustand;
	END;}

	TStringArray = Array of String;

	TZustandArray = Array of TZustand;
	TZustandTabelle = Array of TZustandArray;

	TTabellenEintrag = RECORD
		ursprung : TZustand;
		ziel : TZustandArray;
	END;

	TUebergangsTabelle = RECORD
		alphabet : String;
		tabelle : Array of TTabellenEintrag;
	END;

	TAutomat = CLASS ABSTRACT
		PRIVATE
			alphabet : String;
			zustaende : TZustandArray;
			startzustand : TZustand;
			endzustaende : TZustandArray;
			uebergangstabelle : TUebergangstabelle;
		PUBLIC
			FUNCTION SimuliereEingabe(eingabe : String) : TZustand; VIRTUAL; ABSTRACT;
	END;

	TDEA = CLASS(TAutomat)
		PUBLIC
			CONSTRUCTOR Create(_alphabet : String; _zustaende, _endzustaende : TZustandArray;
			            _startzustand: TZustand; _uebergangstabelle : TUebergangstabelle);
			DESTRUCTOR Dispose();
			FUNCTION SimuliereEingabe(eingabe : String) : TZustand; OVERRIDE;
			FUNCTION AkzeptiertEingabe(eingabe : String) : Boolean;
			CLASS FUNCTION CreateFromFile(filename : String) : TDEA; STATIC;
	END;

IMPLEMENTATION USES SysUtils;

	CONSTRUCTOR TZustand.Create(_name : String);
	BEGIN
		self.name := _name;
	END;

	DESTRUCTOR TZustand.Dispose();
	BEGIN
	END;

	FUNCTION TZustand.GetName() : String;
	BEGIN
		result := name;
	END;

	CONSTRUCTOR TDEA.Create(_alphabet : String; _zustaende, _endzustaende : TZustandArray;
			            _startzustand : TZustand; _uebergangstabelle : TUebergangstabelle);
	BEGIN
		self.alphabet := _alphabet;
		self.zustaende := _zustaende;
		self.endzustaende := _endzustaende;
		self.startzustand := _startzustand;
		self.uebergangstabelle := _uebergangstabelle;
	END;

	DESTRUCTOR TDEA.Dispose();
	BEGIN
	END;

	FUNCTION NaechsterZustand(aktuellerzustand : TZustand; zeichen : Char;
		uetabelle : TUebergangstabelle) : TZustand;
	VAR
		i, j : Integer;
	BEGIN
		{ Auswahl der richtigen Zeile }
		FOR i := 0 TO Length(uetabelle.tabelle) - 1 DO
		BEGIN
			IF uetabelle.tabelle[i].ursprung = aktuellerzustand THEN
			BEGIN
				break;
			END;
		END;
		
		{ Auswahl der richtigen Spalte }
		FOR j := 0 TO Length(uetabelle.tabelle[i].ziel) - 1 DO
		BEGIN
			IF uetabelle.alphabet[j] = zeichen THEN
			BEGIN
				break;
			END;
		END;
		
		{ Ergebnis festhalten }
		result := uetabelle.tabelle[i].ziel[j];
	END;

	{ Simuliert die Eingabe in dem Automaten }
	FUNCTION TDEA.SimuliereEingabe(eingabe : String) : TZustand;
	VAR
		i : Integer;
	BEGIN
		result := startzustand;
		
		FOR i := 1 TO Length(eingabe) DO
		BEGIN
			result := NaechsterZustand(result, eingabe[i], uebergangstabelle);
		END;
	END;

	{ Prüft, ob die Eingabe an einem Endzustand terminiert
	  -> ob die Maschine die Eingabe akzeptiert }
	FUNCTION TDEA.AkzeptiertEingabe(eingabe : String) : Boolean;
	VAR
		i : Integer;
		zustand : TZustand;
	BEGIN
		zustand := SimuliereEingabe(eingabe);

		result := false;

		FOR i := 0 TO Length(endzustaende) - 1 DO
		BEGIN
			IF zustand = endzustaende[i] THEN
			BEGIN
				result := true;
				break;
			END;
		END;
	END;

	FUNCTION SplitString(str : String; delimiter : Char) : TStringArray;
	VAR
		i, j : Integer;
	BEGIN
		SetLength(result, 0);
		j := 0;

		FOR i := 1 TO Length(str) DO
		BEGIN
			IF str[i] <> delimiter THEN
			BEGIN
				Inc(j);
			END
			ELSE
			BEGIN
				SetLength(result, Length(result) + 1);
				result[High(result)] := Copy(str, i, j);
				j := 0;
			END;
		END;
	END;

	FUNCTION GetByName(name : String; list : TZustandArray) : TZustand;
	VAR
		i : Integer;
	BEGIN
		FOR i := 0 TO Length(list) - 1 DO
		BEGIN
			IF CompareText(list[i].GetName(), name) = 0 THEN
			BEGIN
				result := list[i];
				break;
			END;
		END;
	END;


	CLASS FUNCTION TDEA.CreateFromFile(filename : String) : TDEA; STATIC;
	VAR
		f : TextFile;
		i, j : Integer;
		_alphabet, helperstring : String;
		helperarr : TStringArray;
		_zustaende, _endzustaende : TZustandArray;
		_startzustand : TZustand;
		_uebergangstabelle : TUebergangsTabelle;
	BEGIN
		AssignFile(f, filename);
			Reset(f);

			ReadLn(f, _alphabet);

			ReadLn(f, helperstring);
			helperarr := SplitString(helperstring, ';');
			SetLength(_zustaende, Length(helperarr));
			FOR i := 0 TO Length(helperarr) DO
			BEGIN
				_zustaende[i] := TZustand.Create(helperarr[i]);
			END;

			ReadLn(f, helperstring);
			_startzustand := GetByName(helperstring, _zustaende);

			ReadLn(f, helperstring);
			helperarr := SplitString(helperstring, ';');
			SetLength(_endzustaende, Length(helperarr));
			FOR i := 0 TO Length(helperarr) DO
			BEGIN
				_endzustaende[i] := GetByName(helperarr[i], _zustaende);
			END;

			_uebergangstabelle.alphabet := _alphabet;
			SetLength(_uebergangstabelle.tabelle, 0);
			i := 0;
			WHILE NOT EOF(f) DO
			BEGIN
				SetLength(_uebergangstabelle.tabelle, Length(_uebergangstabelle.tabelle) + 1);
				ReadLn(f, helperstring);
				helperarr := SplitString(helperstring, ';');
				
				_uebergangstabelle.tabelle[i].ursprung := GetByName(helperarr[0], _zustaende);
				SetLength(_uebergangstabelle.tabelle[i].ziel, Length(helperarr) - 1);
				
				FOR j := 1 TO Length(helperarr) - 1 DO
				BEGIN
					_uebergangstabelle.tabelle[i].ziel[j-1] := GetByName(helperarr[i], _zustaende);
				END;
				
				Inc(i);
			END;
		CloseFile(f);
		result := TDEA.Create(_alphabet, _zustaende, _endzustaende, _startzustand, _uebergangstabelle);
	END;

	{CONSTRUCTOR TZustand.Create(dict: TFPGMap<char,TZustand>);
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
	END;}

BEGIN
END.
