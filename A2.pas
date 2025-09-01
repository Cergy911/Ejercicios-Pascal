program DecimalARomano;
{ Version compatible con Turbo Pascal (DOS). Usa string[2] en arreglos constantes. }
uses crt;

const
  N = 13;
  valores: array[1..N] of integer =
    (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1);
  simbolos: array[1..N] of string[2] =
    ('M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I');

var
  num, i: integer;

begin
  clrscr;
  write('Ingresa un numero decimal (1..3999): '); readln(num);
  if (num < 1) or (num > 3999) then
  begin
    writeln('Fuera de rango (usa 1..3999)'); readln; halt(1);
  end;

  i := 1;
  while num > 0 do
  begin
    if num >= valores[i] then
    begin
      write(simbolos[i]);
      num := num - valores[i];
    end
    else
      i := i + 1;
  end;
  writeln;
  writeln('Listo. Pulsa ENTER para salir.');
  readln;
end.
