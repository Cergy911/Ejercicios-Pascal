program AjedrezFuncional;
{ Tablero "funcional" en consola Turbo Pascal (DOS):
  - Dibuja tablero en colores con piezas iniciales.
  - Permite introducir movimientos simples (ej. e2e4, g8f6).
  - Cambia el turno (blancas primero). No valida reglas completas
    (jaque, jaque mate, enroque, peones dobles, etc.), solo:
      * No puedes mover desde casilla vacia.
      * No puedes mover pieza del color equivocado.
      * Permite captura sobre pieza del rival.
  - Tecla Q para salir.
}
uses crt;

const
  EMPTY = ' ';

type
  TBoard = array[1..8, 1..8] of char; { [fila, col] }

var
  B: TBoard;
  turnWhite: boolean;
  s: string;

function IsWhitePiece(c: char): boolean;
begin
  IsWhitePiece := c in ['P','R','N','B','Q','K'];
end;

function IsBlackPiece(c: char): boolean;
begin
  IsBlackPiece := c in ['p','r','n','b','q','k'];
end;

procedure InitBoard(var A: TBoard);
var
  i: integer;
begin
  { Limpia }
  for i := 1 to 8 do
  begin
    A[3, i] := ' ';
    A[4, i] := ' ';
    A[5, i] := ' ';
    A[6, i] := ' ';
  end;
  { Blancas (mayusculas) en filas 1 y 2 (abajo) }
  A[2,1]:='P'; A[2,2]:='P'; A[2,3]:='P'; A[2,4]:='P';
  A[2,5]:='P'; A[2,6]:='P'; A[2,7]:='P'; A[2,8]:='P';
  A[1,1]:='R'; A[1,2]:='N'; A[1,3]:='B'; A[1,4]:='Q';
  A[1,5]:='K'; A[1,6]:='B'; A[1,7]:='N'; A[1,8]:='R';

  { Negras (minusculas) en filas 7 y 8 (arriba) }
  A[7,1]:='p'; A[7,2]:='p'; A[7,3]:='p'; A[7,4]:='p';
  A[7,5]:='p'; A[7,6]:='p'; A[7,7]:='p'; A[7,8]:='p';
  A[8,1]:='r'; A[8,2]:='n'; A[8,3]:='b'; A[8,4]:='q';
  A[8,5]:='k'; A[8,6]:='b'; A[8,7]:='n'; A[8,8]:='r';
end;

procedure DrawBoard(const A: TBoard);
var
  row, col: integer;
  sqColor: integer;
  ch: char;
begin
  clrscr;
  TextColor(White);
  writeln('   A  B  C  D  E  F  G  H');
  for row := 8 downto 1 do
  begin
    write(' ', row, ' ');
    for col := 1 to 8 do
    begin
      { alternar colores }
      if ((row + col) mod 2 = 0) then sqColor := Brown else sqColor := LightGray;
      TextBackground(sqColor);
      ch := A[row, col];
      if ch = EMPTY then ch := ' ';
      if IsWhitePiece(ch) then TextColor(White) else TextColor(Black);
      write(' ', ch);
      TextBackground(Black);
      write(' ');
    end;
    TextBackground(Black); TextColor(White);
    writeln(' ', row);
  end;
  writeln('   A  B  C  D  E  F  G  H');
  TextBackground(Black);
  TextColor(LightCyan);
  writeln;
  writeln('Movimiento (ej. e2e4)  |  Q para salir');
end;

function FileToCol(f: char): integer;
begin
  f := upcase(f);
  if (f < 'A') or (f > 'H') then FileToCol := 0
  else FileToCol := ord(f) - ord('A') + 1;
end;

function RankToRow(r: char): integer;
begin
  if (r < '1') or (r > '8') then RankToRow := 0
  else RankToRow := ord(r) - ord('0');
end;

function ParseMove(const s: string; var r1,c1,r2,c2: integer): boolean;
var
  t: string;
  i, p: integer;
begin
  t := '';
  for i := 1 to length(s) do
    if s[i] <> ' ' then t := t + s[i];
  if length(t) <> 4 then
  begin
    ParseMove := false; exit;
  end;
  c1 := FileToCol(t[1]);
  r1 := RankToRow(t[2]);
  c2 := FileToCol(t[3]);
  r2 := RankToRow(t[4]);
  ParseMove := (c1>=1) and (c1<=8) and (r1>=1) and (r1<=8) and
               (c2>=1) and (c2<=8) and (r2>=1) and (r2<=8);
end;

function IsOpponent(c: char; whiteToMove: boolean): boolean;
begin
  if whiteToMove then IsOpponent := IsBlackPiece(c)
  else IsOpponent := IsWhitePiece(c);
end;

function IsOwnPiece(c: char; whiteToMove: boolean): boolean;
begin
  if whiteToMove then IsOwnPiece := IsWhitePiece(c)
  else IsOwnPiece := IsBlackPiece(c);
end;

procedure MakeMove(var A: TBoard; r1,c1,r2,c2: integer);
begin
  A[r2, c2] := A[r1, c1];
  A[r1, c1] := EMPTY;
end;

var r1,c1,r2,c2: integer;
    piece: char;

begin
  TextBackground(Black);
  turnWhite := true;
  InitBoard(B);
  repeat
    DrawBoard(B);
    if turnWhite then
      writeln('Turno: BLANCAS')
    else
      writeln('Turno: NEGRAS');
    write('> ');
    readln(s);
    if (length(s) > 0) and ((s[1] = 'q') or (s[1] = 'Q')) then break;
    if not ParseMove(s, r1,c1,r2,c2) then
    begin
      writeln('Formato invalido. Usa ej. e2e4. Pulsa ENTER...'); readln; continue;
    end;
    piece := B[r1, c1];
    if piece = EMPTY then
    begin
      writeln('Casilla de origen vacia. Pulsa ENTER...'); readln; continue;
    end;
    if not IsOwnPiece(piece, turnWhite) then
    begin
      writeln('Esa pieza no es tuya. Pulsa ENTER...'); readln; continue;
    end;
    if IsOwnPiece(B[r2,c2], turnWhite) then
    begin
      writeln('No puedes capturar tu propia pieza. Pulsa ENTER...'); readln; continue;
    end;
    { Sin validacion de legalidad completa }
    MakeMove(B, r1,c1,r2,c2);
    turnWhite := not turnWhite;
  until false;

  clrscr;
  writeln('Gracias por jugar!');
  readln;
end.
