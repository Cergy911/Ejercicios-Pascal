program FigurasExactas;
uses crt;

const
  MAXW = 64;
  N = 6;
  valores: array[1..N] of integer = (2,4,8,16,32,64);

var
  i, j, w, pad: integer;

begin
  clrscr;
  writeln('Volcan:');
  for i := 1 to N do
  begin
    w := valores[i];
    pad := (MAXW - w) div 2;
    for j := 1 to pad do write(' ');
    for j := 1 to w do write('*');
    writeln;
  end;

  writeln;
  writeln('Mosaico 8x8:');
  for i := 1 to 8 do
  begin
    for j := 1 to 8 do
    begin
      if ((i + j) mod 2 = 0) then
        write('*')
      else
        write(' ');
    end;
    writeln;
  end;

  writeln;
  writeln('Pulsa ENTER para salir...');
  readln;
end.
