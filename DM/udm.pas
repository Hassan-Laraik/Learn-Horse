unit uDM;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset;

type

  { TDM }

  TDM = class(TDataModule)
    ZNX: TZConnection;

  private

  public
   function Lister_Clients(): Tdataset;
   function Lister_Client(code: string): Tdataset;
   function Ajouter_Client(code,nom,adresse,phone,fax,
                                  email,status : string):Boolean;
   function Modifier_Client(code,nom,adresse,phone,fax,
                                  email,status : string):Boolean;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

function TDM.Lister_Clients: Tdataset;
var
  zquery : Tzquery;
begin
   try
     zquery := Tzquery.create(nil);
     zquery.Connection:=ZNX;
     zquery.SQL.add('select *  from clients');
     zquery.Open;
     result := zquery;
     //Result := zquery.ToJSONArray() ;
   finally
     zquery:=nil;
     zquery.free;
   end;

end;

function TDM.Lister_Client(code: string): Tdataset;
var
  zquery : Tzquery;
begin
   try
     zquery := Tzquery.create(nil);
     zquery.Connection:=ZNX;
     zquery.SQL.add('select *  from clients where code_cli=:code_cli');
     zquery.ParamByName('code_cli').AsString:=code;
     zquery.Open;
     result := zquery;
     //result := zquery.ToJSONArray();
   finally
     zquery:=nil;
     zquery.free;
   end;

end;

function TDM.Ajouter_Client(code, nom, adresse, phone, fax, email,
  status: string): Boolean;
var
  zquery : Tzquery;
begin
   try
     zquery := Tzquery.create(nil);
     zquery.Connection:=ZNX;
/// Verification si client exit
     zquery.SQL.add('select *  from clients where code_cli=:code_cli');
     zquery.ParamByName('code_cli').AsString:=code;
     zquery.Open;
     if zquery.RecordCount = 0 then
     begin
      zquery.SQL.clear;
      zquery.sql.add('insert into clients  values (');
      zquery.sql.add(':code_cli,:nom_cli,:adresse_cli,:phone_cli,');
      zquery.sql.add(':fax_cli,:email_cli,:status_cli)');
      zquery.ParamByName('code_cli').AsString:=code;
      zquery.ParamByName('nom_cli').AsString:=nom;
      zquery.ParamByName('adresse_cli').AsString:=adresse;
      zquery.ParamByName('phone_cli').AsString:=phone;
      zquery.ParamByName('fax_cli').AsString:=fax;
      zquery.ParamByName('email_cli').AsString:=email;
      zquery.ParamByName('status_cli').AsString:=status;
      zquery.ExecSQL;
      result := true;
     end else
     begin
      Result := False;
     end;

   finally
     zquery:=nil;
     zquery.free;
   end;

end;

function TDM.Modifier_Client(code, nom, adresse, phone, fax, email,
  status: string): Boolean;
var
  zquery : Tzquery;
begin
 try
     zquery := Tzquery.create(nil);
     zquery.Connection:=ZNX;
/// Verification si client exit
     zquery.SQL.add('select *  from clients where code_cli=:code_cli');
     zquery.ParamByName('code_cli').AsString:=code;
     zquery.Open;

     if zquery.RecordCount = 1 then
     begin

      zquery.SQL.clear;
      zquery.sql.add('Update clients  ');
      zquery.sql.add( 'set nom_cli=:nom_cli,adresse_cli=:adresse_cli,phone_cli=:phone_cli,');
      zquery.sql.add('fax_cli=:fax_cli,email_cli=:email_cli,status_cli=:status_cli');
      zquery.ParamByName('nom_cli').AsString:=nom;
      zquery.ParamByName('adresse_cli').AsString:=adresse;
      zquery.ParamByName('phone_cli').AsString:=phone;
      zquery.ParamByName('fax_cli').AsString:=fax;
      zquery.ParamByName('email_cli').AsString:=email;
      zquery.ParamByName('status_cli').AsString:=status;
      zquery.ExecSQL;
      result := true;
     end else
     begin
      Result := False;
     end;

   finally
     zquery:=nil;
     zquery.free;
   end;
end;

end.

