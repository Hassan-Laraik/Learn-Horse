unit Controller.Client;

{$mode Delphi}

interface


uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes ,sysutils,
  { you can add units after this }
  Horse,Horse.Jhonson,  UDM,  DataSet.Serialize,dataset.Serialize.Config,fpjson;

procedure ClientRoute;

implementation

 procedure informer();
 begin
  writeln('GETCLIENTS Coonected At : '+DateTimeToStr(Time));
 end;

procedure GetClients(Req: THorseRequest; Res: THorseResponse);
 var
   dmi        : TDM;
   LJSONArray : TJSONArray;
   jsonObject : TJSONObject;
begin
  try
   dmi :=TDM.Create(nil);
   if  DMI.Lister_Clients().IsEmpty then
   begin
    jsonObject := TJSONObject.Create();
    jsonObject.add('Reponse','NO');
    res.Send<TJSONObject>(jsonObject);
    jsonObject := nil;
    jsonObject.free;
   end else
   begin
    LJSONArray := DMI.Lister_Clients().ToJSONArray;
    Res.Send<TJSONArray>(LJSONArray);
    LJSONArray := nil;
    LJSONArray.free;
   end;
     informer;
  finally

    dmi := nil;
    dmi.Free;
  end;

end;

procedure GetClient(Req: THorseRequest; Res: THorseResponse);
 var
   dmi        : TDM;
   LJSONArray : TJSONArray;
   JsonObject : TJSONObject;
   code :  string;
begin
  try
   code := Req.Params.Items['code'];
   dmi  :=TDM.Create(nil);
   if DMI.Lister_Client(code).IsEmpty then
   begin
    JsonObject := TJSONObject.create;
    JsonObject.add('Reponse' , 'NO');
    res.send<TJSONObject>(JsonObject);
    JsonObject := nil;
    JsonObject.Free;
   end else
   begin
     LJSONArray := DMI.Lister_Client(code).ToJSONArray;
     Res.Send<TJSONArray>(LJSONArray);
     LJSONArray := nil;
     LJSONArray.free;
   end;
  finally
    dmi := nil;
    dmi.Free;
  end;

end;
//Ajouter_Client
 procedure postClient(Req: THorseRequest; Res: THorseResponse);
 var
   dmi       : TDM;
   //LJSONArray: TJSONArry;
  JSONObject : TJSONObject;
   body      : TJSONObject;
   code, nom, adresse, phone, fax, email,status: string ;
   reponse : string;
begin
  try
   dmi     := TDM.Create(nil);
   body    := Req.Body<TJSONObject>;
   code    := body.Get('code', '');
   nom     := body.Get('nom', '');
   adresse := body.Get('adresse', '');
   phone   := body.Get('phone', '');
   fax     := body.Get('fax', '');
   email   := body.Get('email', '');
   status  := body.Get('status', '');

   if DMI.Ajouter_Client(code, nom, adresse, phone, fax, email,status) then
   reponse := 'OK'
   else
   reponse := 'NO';

   JSONObject := TJSONObject.Create();
   JSONObject.Add('Reponse',reponse);
   Res.Send<TJSONObject>(JSONObject);

  finally
    JSONObject := nil;
    JSONObject.free;
    dmi        := nil;
    dmi.Free;
  end;

end;

 procedure putClient(Req: THorseRequest; Res: THorseResponse);
  var
    dmi        : TDM;
    //LJSONArray: TJSONArray;
    JSONObject : TJSONObject;
    body       : TJSONObject;
    code, nom, adresse, phone, fax, email,status: string ;
    reponse    : string;
 begin
   try
    dmi     :=TDM.Create(nil);
    body    := Req.Body<TJSONObject>;
    code    := body.Get('code', '');
    nom     := body.Get('nom', '');
    adresse := body.Get('adresse', '');
    phone   := body.Get('phone', '');
    fax     := body.Get('fax', '');
    email   := body.Get('email', '');
    status  := body.Get('status', '');

    if DMI.Modifier_Client(code, nom, adresse, phone, fax, email,status) then
    reponse    := 'OK'
    else
    reponse    :=  'NO';
    JSONObject :=TJSONObject.Create();
    JSONObject.Add('Reponse',reponse);
    Res.Send<TJSONObject>(JSONObject);
   finally
     JSONObject := nil;
     JSONObject.free;
     dmi        := nil;
     dmi.Free;
   end;

 end;

 procedure ClientRoute;
 begin
  THorse.Get ('/Clients'      , GetClients);
  THorse.Get ('/Clients/:code', GetClient);
  THorse.post('/Client'      , postClient); //postClient
  THorse.put ('/Client'     , putClient); //postClient
 end;

initialization
 TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
 TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator:='.';

end.

