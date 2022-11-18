db = dbConnect("sqlite","bankaverileri.db")

if db then
    print("[BankaSistemi] Database ile bağlantı başarılı.")
end

local bankamarkeri1 = createMarker( 1415.462, -1624.437, 12.592, "cylinder", 1.1, 255, 127, 0)
local bankamarkeri2 = createMarker( 1415.35, -1621.829, 12.592, "cylinder", 1.1, 255, 127, 0)
local bankamarkeri3 = createMarker( 1415.33, -1619.498, 12.592, "cylinder", 1.1, 255, 127, 0)
local bankamarkeri4 = createMarker( 1415.4, -1616.598, 12.592, "cylinder", 1.1, 255, 127, 0)

local hesap
local hesapnick
local hesapsifre 
local bildiri
local oyuncununparasi

function paneliacarmisin(oyuncu)
  triggerClientEvent(oyuncu,"bankahesap:panelac",oyuncu)
end

addEventHandler("onMarkerHit",bankamarkeri1,paneliacarmisin)
addEventHandler("onMarkerHit",bankamarkeri2,paneliacarmisin)
addEventHandler("onMarkerHit",bankamarkeri3,paneliacarmisin)
addEventHandler("onMarkerHit",bankamarkeri4,paneliacarmisin)

function yenile()
    dbQuery(yenile2, db, "SELECT * FROM hesapbilgiler")
end

function yenile2(veris)
    local secim = dbPoll(veris,0)
    local parasi = 0
    for i,isim in pairs(secim) do 
        hesaps = isim.hesapadi
        if tostring(hesapnick) == tostring(hesaps) then
            oyuncununparasi = isim.para
        end
    end  
    triggerClientEvent(bildiri,"bankahesap:yenile",bildiri,oyuncununparasi)
end

 function hesapekle(veriler)
    local baglanti = dbPoll(veriler,0)
    local kullanicininvar = false
    local hesapnickivar = false

    for i,z in pairs(baglanti) do 
        if tostring(hesap) == tostring(z.kadi) then
            kullanicininvar = true
        end
        if tostring(hesapnick) == tostring(z.hesapadi) then
        hesapnickivar = true
        end
    end
    if kullanicininvar == false then
        if hesapnickivar == false then
            if #hesapnick >= 5 and #hesapsifre >= 5 then
                local parasi = getPlayerMoney(bildiri)
                if parasi >= 1000 then
                dbExec(db,"INSERT INTO hesapbilgiler (kadi, hesapadi, hesapsifre, para, izin) VALUES (?,?,?,?,?)",hesap,hesapnick,hesapsifre,500,"false")
                exports.hud:dm("#ffffffBaşarıyla #ff7f00Banka hesabı #ffffffOluşturdunuz! İşlem ücreti olarak $1000 kesildi.",bildiri,255,127,0,true)
                takePlayerMoney(bildiri,1000)
                else
                    exports.hud:dm("#ffffffİşlem ücreti için #ff7f00yeterli paranız yok. #ffffff(işlem ücreti $1000 'dır.)",bildiri,255,127,0,true)
                end
            else
                exports.hud:dm("#ffffffHesap ismi ve şifresi #ff7f00En Az 5 #ffffffharften oluşmalıdır.",bildiri,255,127,0,true)
            end
        else
            exports.hud:dm("#ffffffZaten #ff7f00bu hesap adı kullanılıyor.. #ffffffBaşka bir hesap adı tercih edebilirsiniz.",bildiri,255,127,0,true)
        end
    else 
        exports.hud:dm("#ffffffZaten #ff7f00banka hesabınız var. #ffffffHesap adınızı veya şifrenizi unuttuysanız, chat'e #ff7f00/bankahesabim #ffffffyazınız.",bildiri,255,127,0,true)
    end
 end

addEvent("bankahesap:olustur",true)
addEventHandler("bankahesap:olustur",root,function(hesapnicki, sifresi)
    if db then
        hesap = getAccountName(getPlayerAccount(source))
        hesapnick = hesapnicki
        hesapsifre = sifresi
        bildiri = source
        dbQuery(hesapekle,db, "SELECT * FROM hesapbilgiler")
    else
        outputChatBox("İşlem başarısız. Hata Kodu: [3332] Lütfen Hatayı Sunucu Yönetimine Bildiriniz.",source)
    end
end)

function hesabagir(veriler)
    local baglanti = dbPoll(veriler,0)
    local kullaniciadi = false
    local kullanicisifre
    local girisizni
    local bizimkininhesap

    for i,z in pairs(baglanti) do 
        if tostring(hesapnick) == tostring(z.hesapadi) then
        kullaniciadi = true
        oyuncununparasi = tonumber(z.para)
        kullanicisifre = tostring(z.hesapsifre)
        girisizni = tostring(z.izin)
        bizimkininhesap = tostring(z.kadi)
        end
    end
    if kullaniciadi == true then
        if tostring(hesapsifre) == tostring(kullanicisifre) then
            if girisizni == "true" then
                if tostring(hesap) == tostring(bizimkininhesap) then
                    triggerClientEvent(bildiri,"bankahesap:hesapwindowac",bildiri)
                    yenile()
                    exports.hud:dm("#ffffffHesabınıza #ff7f00Başarıyla giriş #ffffffyaptınız!",bildiri,255,127,0,true)
                else
                    exports.hud:dm("#ffffffBu hesaba #ff7f00Giriş yetkiniz#ffffff yok!",bildiri,255,127,0,true)
                end
            else
			yenile()
            triggerClientEvent(bildiri,"bankahesap:hesapwindowac",bildiri)
            exports.hud:dm("#ffffffHesabınıza #ff7f00Başarıyla giriş #ffffffyaptınız!",bildiri,255,127,0,true)
            end
        else
            exports.hud:dm("#ffffffGirdiğiniz şifre #ff7f00Yanlış! #fffffflütfen tekrar deneyiniz, hesap bilgilerini unuttuysanız: /bankahesabim",bildiri,255,127,0,true)
        end
    else
        exports.hud:dm("#ffffffHesabınız #ff7f00bulunamadı! #fffffflütfen tekrar deneyiniz, hesap bilgilerini unuttuysanız: /bankahesabim",bildiri,255,127,0,true)
    end
end

addEvent("bankahesap:girisyap",true)
addEventHandler("bankahesap:girisyap",root,function(hesapnicki, sifresi)
    if db then
        hesap = getAccountName(getPlayerAccount(source))
        hesapnick = hesapnicki
        hesapsifre = sifresi
        bildiri = source
        dbQuery(hesabagir,db, "SELECT * FROM hesapbilgiler")
    else
        outputChatBox("İşlem başarısız. Hata Kodu: [3332] Lütfen Hatayı Sunucu Yönetimine Bildiriniz.",source)
    end
end)

addEvent("bankahesap:islem",true)
addEventHandler("bankahesap:islem",root,function(yapilacak,miktar)
    if db then
	if tonumber(miktar) < 0 then exports.hud:dm("- 'li sayıların kullanımı kesinlikle yasaktır.",source,255,255,255,true) return end
        local parasi = getPlayerMoney(source)
        if tostring(yapilacak) == "parayatir" then
            if parasi >= tonumber(miktar) then
                if tonumber(miktar) == 0 then
                    exports.hud:dm("#ffffffBankaya #ff7f000 TL yatıramazsın. #ffffffBankadaki paranız: #ff7f00"..oyuncununparasi,bildiri,255,127,0,true)
                    return
                end
                local eklenecek = oyuncununparasi + miktar
                dbExec(db, "UPDATE hesapbilgiler SET para = ? WHERE kadi = ?",eklenecek,hesap)
                takePlayerMoney(source, miktar)
                yenile()
            else
                exports.hud:dm("#ffffffüzerinde yeterli para bulunmadığı için #ff7f00İşlem iptal edildi. #ffffffLütfen tekrar deneyin.",bildiri,255,127,0,true)
            end
        elseif tostring(yapilacak) == "paracek" then
            if tonumber(miktar) <= tonumber(oyuncununparasi) then
                if tonumber(miktar) == 0 then
                    exports.hud:dm("#ffffffBankadan #ff7f000 TL çekemezsin. #ffffffBankadaki paranız: #ff7f00"..oyuncununparasi,bildiri,255,127,0,true)
                    return
                end
                oyuncununparasi = oyuncununparasi - miktar
                givePlayerMoney(source,miktar)
                dbExec(db, "UPDATE hesapbilgiler SET para = ? WHERE kadi = ?",oyuncununparasi,hesap)
                exports.hud:dm("#ffffffBankadaki paranızı #ff7f00Başarıyla çektiniz! #ffffffBankada kalan paranız: #ff7f00"..oyuncununparasi,bildiri,255,127,0,true)
                yenile()
            else
                exports.hud:dm("#ffffffBanka Hesabınızda yeterli para bulunmadığı için #ff7f00İşlem iptal edildi. #ffffffLütfen tekrar deneyin.",bildiri,255,127,0,true)
            end
        end
    else
        outputChatBox("İşlem başarısız. Hata Kodu: [3332] Lütfen Hatayı Sunucu Yönetimine Bildiriniz.",source)
    end
end)

local islems
local gelens

function hesapguncelle(veriler)
    local baglanti = dbPoll(veriler,0)
    local varmi = false
    for i,z in pairs(baglanti) do 
        if tostring(gelens) == tostring(z.hesapadi) then
            varmi = true
        end
    end
    if tostring(islems) == "hesapadidegis" then
        if varmi == false then
            if #gelens >= 5 then
                dbExec(db, "UPDATE hesapbilgiler SET hesapadi = ? WHERE kadi = ?",tostring(gelens),hesap)
                exports.hud:dm("#ffffffHesap adınızı #ff7f00Başarıyla değiştirdiniz! #ffffffYeni hesap adınız: "..tostring(gelens),bildiri,255,127,0,true)
            else
                exports.hud:dm("#ffffffHesap adınız #ff7f005 karakter veya daha uzun#ffffff olması gerekmekte!",bildiri,255,127,0,true)
            end
        else
            exports.hud:dm("#ffffffYapmak istediğiniz hesap adı #ff7f00Zaten Mevcut #fffffflütfen başka bir isim deneyin.",bildiri,255,127,0,true)
        end
    end
    if tostring(islems) == "sifredegis" then
            if #gelens >= 5 then
                dbExec(db, "UPDATE hesapbilgiler SET hesapsifre = ? WHERE kadi = ?",tostring(gelens),hesap)
                exports.hud:dm("#ffffffHesap şifrenizi #ff7f00Başarıyla değiştirdiniz! #ffffffYeni hesap şifreniz: "..tostring(gelens),bildiri,255,127,0,true)
            else
                exports.hud:dm("#ffffffHesap şifreniz #ff7f005 karakter veya daha uzun#ffffff olması gerekmekte!",bildiri,255,127,0,true)
            end
    end
end

addEvent("bankahesap:bilgiler",true)
addEventHandler("bankahesap:bilgiler",root,function(islem,gonderilen)
    if db then
        islems = tostring(islem)
        gelens = tostring(gonderilen)
        dbQuery(hesapguncelle,db, "SELECT * FROM hesapbilgiler")
    else
        outputChatBox("İşlem başarısız. Hata Kodu: [3332] Lütfen Hatayı Sunucu Yönetimine Bildiriniz.",source)
    end
end)

addEvent("bankahesap:izin",true)
addEventHandler("bankahesap:izin",root,function(acikmis)
    if acikmis == false then
        local durum = "false"
        dbExec(db, "UPDATE hesapbilgiler SET izin = ? WHERE kadi = ?",durum,hesap)
    elseif acikmis == true then
        local durum = "true"
        dbExec(db, "UPDATE hesapbilgiler SET izin = ? WHERE kadi = ?",durum,hesap)
    end
end)

local hesabi
local bildiriat

function parasinabak(veriler)
    local baglanti = dbPoll(veriler,0)
    local varmi = false
    local hesapadiss
    local hesapsifresiss
    for i,z in pairs(baglanti) do 
        if tostring(hesabi) == tostring(z.kadi) then
            varmi = true
            hesapadiss = tostring(z.hesapadi)
            hesapsifresiss = tostring(z.hesapsifre)
        end
    end
    if varmi == true then
        exports.hud:dm("#ff7f00[Madde Bank] #ffffffHesap Adı: #ff7f00"..hesapadiss.." #ffffffHesap şifresi: #ff7f00"..hesapsifresiss,bildiriat,255,127,0,true)
    else
        exports.hud:dm("#ff7f00[Madde Bank] #ffffffHesabın Bulunamadı! Bankaya gidip, ücretsiz hesap açtırabilirsin.",bildiriat,255,127,0,true)
    end
end



addCommandHandler("bankahesabim",function(oyuncu)
    hesabi = getAccountName(getPlayerAccount(oyuncu))
	bildiriat = oyuncu
    dbQuery(parasinabak,db, "SELECT * FROM hesapbilgiler")
end)

local hesapa
local parasiz

function AraziParasiniVer(mani,adam)
	hesapa = adam
	parasiz = mani
	dbQuery(paraverpara,db,"SELECT * FROM hesapbilgiler")
end

function paraverpara(veriler)
	local results = dbPoll(veriler,0)
	local paraa
	local sa = false
	for i,v in pairs(results) do
		if hesapa == v.kadi then
		paraa = v.para
		sa = true
		end
	end
	local randoms = math.random(0,1000)
	local hesapadi = "MaddeG"..randoms
	if sa == false then 
	dbExec(db,"INSERT INTO hesapbilgiler (kadi,hesapadi,hesapsifre,para,izin) VALUES (?,?,?,?,?)",hesapa,hesapadi,randoms,parasiz,"false") 
	else
	local eklenecek = paraa + parasiz
	dbExec(db,"UPDATE hesapbilgiler SET para = ? WHERE kadi = ?",eklenecek,hesapa)
	end
end
