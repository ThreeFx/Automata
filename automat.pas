UNIT Automat;

INTERFACE

TYPE
	TZustand = CLASS
		PUBLIC
			Constructor Create();
			DESTRUCTOR Dispose();
	END;

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
			CONSTRUCTOR Create(a : String; z, endz : TZustandArray;
			            startz : TZustand; uetabelle : TUebergangstabelle);
			DESTRUCTOR Dispose();
			FUNCTION SimuliereEingabe(eingabe : String) : TZustand; VIRTUAL; ABSTRACT;
	END;

	TDEA = CLASS(TAutomat)
		PUBLIC
			CONSTRUCTOR Create(a : String; z, endz : TZustandArray;
			            startz : TZustand; uetabelle : TUebergangstabelle);
			FUNCTION AkzeptiertEingabe(eingabe : String) : Boolean;
	END;

IMPLEMENTATION

	CONSTRUCTOR TDEA.Create(a : String; z, endz : TZustandArray;
			            startz : TZustand; uetabelle : TUebergangstabelle);
	BEGIN
		self.alphabet := a;
		self.zustaende := z;
		self.endzustaende := endz;
		self.startzustand := startz;
		self.uebergangstabelle := self.uetabelle;
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
		FOR j := 0 TO Length(uetabelle.tabelle[i]) - 1 DO
		BEGIN
			IF alphabet[j] = zeichen THEN
			BEGIN
				break;
			END;
		END;
		
		{ Ergebnis festhalten }
		result := uetabelle.tabelle[i][j];
	END;

	{ Simuliert die Eingabe in dem Automaten }
	FUNCTION TDEA.SimuliereEingabe(eingabe : String) : TZustand; OVERRIDE;
	VAR
		i : Integer;
		aktuellerzustand : TZustand;
	BEGIN
		result := startzustand;
		
		FOR i := 1 TO Length(eingabe) DO
		BEGIN
			result := NaechsterZustand(result, eingabe[i], uetabelle);
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

BEGIN
END.
