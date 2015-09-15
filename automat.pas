UNIT Automat;

USES fgl;

INTERFACE

TYPE TZustand = CLASS
	PRIVATE
		next: TFPGMap; {TFPGMap --> Dicitonary --> generisches Array}
	PUBLIC
		CONSTRUCTOR Create(dict: TFPGMap);
		DESTRUCTOR Dispose;
		FUNCTION GetNext(zeichen: char): TZustand;
	 	
	

IMPLEMENTATION

BEGIN
END.
