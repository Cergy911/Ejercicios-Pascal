program TrianguloConEspacios;
{ Triangulo EXACTO con espacios centrados (10 filas) usando arreglos. }
uses crt;
const
  N = 10;
var
  arr: array[1..N, 1..(2*N-1)] of char;
  i, j, len, maxlen, pad, val: integer;
begin
  clrscr;
  maxlen := 2*N - 1;  { ancho de la ultima fila = 19 }

  { Construir las filas en el arreglo }
  for i := 1 to N do
  begin
    len := 2*i - 1;
    { mitad izquierda + centro }
    for j := 1 to i do
    begin
      val := (i + (j-1)) mod 10;
      arr[i, j] := chr(ord('0') + val);
    end;
    { mitad derecha (espejo sin repetir centro) }
    for j := i+1 to len do
    begin
      val := (i + (len - j)) mod 10;
      arr[i, j] := chr(ord('0') + val);
    end;
  end;

  { Imprimir centrado con espacios }
  for i := 1 to N do
  begin
    len := 2*i - 1;
    pad := (maxlen - len) div 2;
    for j := 1 to pad do write(' ');
    for j := 1 to len do write(arr[i, j]);
    writeln;
  end;

  writeln;
  writeln('Pulsa ENTER para salir...');
  readln;
end.
