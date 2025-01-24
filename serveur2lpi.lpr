program serveur2lpi;

{$MODE DELPHI}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes ,sysutils, zcomponent,
  { you can add units after this }
  Horse,Horse.Jhonson, Udm, ZConnection,  DataSet.Serialize,fpjson,
  Controller.Client;

var
  port :  integer;


 procedure messages();
 begin
   writeln('Serveur Run on : ' + Thorse.Port.ToString);
 end;

begin
  try
  THorse.Use(Jhonson);
  port := 9000;

 ClientRoute();
  THorse.Listen(port,messages);
  except on e:exception do
    writeln(e.message);
  end;

end.

